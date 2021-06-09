Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DE93A2084
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 01:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhFIXK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 19:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhFIXK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 19:10:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2931613EA;
        Wed,  9 Jun 2021 23:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623280113;
        bh=tncqAXhekNcg8xDknLdW1mBezoLne7Ft/HR5hqS6ka4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I5Kkbsltd2A+FVZMOEgSypB8g2Bq6Rb6BwYlUzGU2QVNQVcE/slEIIfQTMV9aX6Gh
         kn7euRVTaBAZX2utmxZ7wTi1Z/Q0WZGJ7SSCDAFl0pcR6QsppXCDZuAr0dO5OVYHUj
         ztO7bALrLBgBWtQN/R9kHeR1mhQ0tt7HczO9MxdqGUSP1p1msYMAp0kirJW5zKohPG
         9UOFjXGAx9VdK3TzLi70c+Nm/wd1mTdw8nCtxwm048bROewOrwedhPykY7KCWMMx77
         H8UTq5BuqwDZfzn2iW0ITgcEG9pBmTv5bQtrfGfd7I2QuQmZF7qMqsAAuSADr5EkCf
         6w3+Uos88VK6Q==
Date:   Wed, 9 Jun 2021 16:08:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Changbin Du <changbin.du@gmail.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v2] net: do not invoke open_related_ns when NET_NS is
 disabled
Message-ID: <20210609160831.16c08894@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210609154635.46792-1-changbin.du@gmail.com>
References: <20210609154635.46792-1-changbin.du@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Jun 2021 23:46:35 +0800 Changbin Du wrote:
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
> The same to tun SIOCGSKNS command.
> 
> Signed-off-by: Changbin Du <changbin.du@gmail.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: David Laight <David.Laight@ACULAB.COM>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  drivers/net/tun.c | 4 ++++
>  net/socket.c      | 4 ++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 84f832806313..8ec5977d2f34 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -3003,9 +3003,13 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
>  	} else if (cmd == TUNSETQUEUE) {
>  		return tun_set_queue(file, &ifr);
>  	} else if (cmd == SIOCGSKNS) {
> +#ifdef CONFIG_NET_NS
>  		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
>  			return -EPERM;
>  		return open_related_ns(&net->ns, get_net_ns);
> +#else
> +		return -EOPNOTSUPP;
> +#endif

... and why are you not adding that check to get_net_ns like 
I suggested twice and even shared a diff?
