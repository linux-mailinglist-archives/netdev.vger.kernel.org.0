Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E738394DAD
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 20:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhE2S3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 14:29:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229734AbhE2S3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 May 2021 14:29:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B8A56112F;
        Sat, 29 May 2021 18:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622312856;
        bh=Da53OQw4As5KKqSGeJ8Dz/T5K+i/k/2kHpMjJUuJK6I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c3ATEZyeQaWJbesWkEd+w587Dfm4j1MAsHmB6uLQG8Id7hDVJflnOZWA7yXASX5Be
         NZ4v2RFfI/sDvTf6tDZv3hUdyP1JcdHMi0bujevzrfJfYooKXRH1IXHQbdDAnLFxre
         jL5C7VEW1ZiKclbd0CBP5UWHcPsnTsCQZFOMhaZ44iwDS70lvTSij5aReZdfWwkzvL
         DPrXTlsl68m2rrVhFH41HT8jRGiiMhwqkV+yMFAXTXsXfFBRfoH1YrxDyjgWAbzuRR
         zKyJrMhuBE9vluAnK7FsNS5+nEqNFHnYqdfdcqtv03MCv75BLqgeZDI66INBccFP9K
         Teto/kPDW+2rA==
Date:   Sat, 29 May 2021 11:27:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Changbin Du <changbin.du@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] net: fix oops in socket ioctl cmd SIOCGSKNS when NET_NS
 is disabled
Message-ID: <20210529112735.22bdc153@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210529060526.422987-1-changbin.du@gmail.com>
References: <20210529060526.422987-1-changbin.du@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 May 2021 14:05:26 +0800 Changbin Du wrote:
> When NET_NS is not enabled, socket ioctl cmd SIOCGSKNS should do nothing
> but acknowledge userspace it is not supported. Otherwise, kernel would
> panic wherever nsfs trys to access ns->ops since the proc_ns_operations
> is not implemented in this case.
> 
> [7.670023] Unable to handle kernel NULL pointer dereference at virtual address 00000010
> [7.670268] pgd = 32b54000
> [7.670544] [00000010] *pgd=00000000
> [7.671861] Internal error: Oops: 5 [#1] SMP ARM
> [7.672315] Modules linked in:
> [7.672918] CPU: 0 PID: 1 Comm: systemd Not tainted 5.13.0-rc3-00375-g6799d4f2da49 #16
> [7.673309] Hardware name: Generic DT based system
> [7.673642] PC is at nsfs_evict+0x24/0x30
> [7.674486] LR is at clear_inode+0x20/0x9c
> 
> Signed-off-by: Changbin Du <changbin.du@gmail.com>
> Cc: <stable@vger.kernel.org> # v4.9

Please provide a Fixes tag.

> diff --git a/net/socket.c b/net/socket.c
> index 27e3e7d53f8e..644b46112d35 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -1149,11 +1149,15 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
>  			mutex_unlock(&vlan_ioctl_mutex);
>  			break;
>  		case SIOCGSKNS:
> +#ifdef CONFIG_NET_NS
>  			err = -EPERM;
>  			if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
>  				break;
>  
>  			err = open_related_ns(&net->ns, get_net_ns);

There's a few more places with this exact code. Can we please add the
check in get_net_ns? That should fix all callers.

> +#else
> +			err = -ENOTSUPP;

EOPNOTSUPP, you shouldn't return ENOTSUPP to user space.

> +#endif
>  			break;
>  		case SIOCGSTAMP_OLD:
>  		case SIOCGSTAMPNS_OLD:

