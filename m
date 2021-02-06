Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D6A311F9C
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 20:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhBFTUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 14:20:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230033AbhBFTUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 14:20:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A160964E0F;
        Sat,  6 Feb 2021 19:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612639159;
        bh=9KOLEiudFSeaxPgqil8Rk3sU1vkPjt+8pBRqRbUd1eE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kGpntkwNJ4KkMxHa2dJH/VDW055eKryMZQCrx8mHzmd4HJRP+ywMeaOtRkPrWxxld
         hmZYdCJXQytkTUJjnWwonxnSJ9/Gz4tLJCpcp6abQzFo+NMsJ0PKuwSGLXAlHo08HG
         oz5K9cwTrqSOkBbn6VGX8l95brlSoKe23vOYOHWIM9iEO1lN44ewLzCLuU4qbO9xcj
         5pU5t3O0uq7hF7npPGalEZFivc41sCIWwLR4B5a8MpdZK5VNnwDIWblZtrhj8glB7K
         tPL8OEpUBAc0eU1yT6fxp5cJX92Xm9RRyv6/kkoJuHQQ6bGUsEffaaPyO9qg1yNb7m
         SQ5EqxzS2LnkQ==
Date:   Sat, 6 Feb 2021 11:19:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: ipv4: Return the correct errno code
Message-ID: <20210206111918.36a528e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210204072657.17554-1-zhengyongjun3@huawei.com>
References: <20210204072657.17554-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Feb 2021 15:26:57 +0800 Zheng Yongjun wrote:
> When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/ipv4/devinet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index 123a6d39438f..fa586e915621 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -2582,7 +2582,7 @@ static int __devinet_sysctl_register(struct net *net, char *dev_name,
>  free:
>  	kfree(t);
>  out:
> -	return -ENOBUFS;
> +	return -ENOMEM;

But this path also gets hit when registration fails.
Are you sure registration also only fails when there is no memory?

>  }
>  
>  static void __devinet_sysctl_unregister(struct net *net,

