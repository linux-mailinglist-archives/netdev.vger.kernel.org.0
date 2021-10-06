Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938D942359E
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 03:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237153AbhJFByK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 21:54:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231867AbhJFByK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 21:54:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A3E66120C;
        Wed,  6 Oct 2021 01:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633485138;
        bh=LGWCIjarsdwSot+x0AyjNPs3qKKyM9XPxqjS8LPYrz0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KhmZBRpmLt+kvPADLs4CCwk8UoaaJfMrAmG+8fos28TravHfcVqeADPIEtu6YSP40
         aqzWqADr939OEEIzGQ8U2NqS3libwUJ6mUVXtzTLT/k7yPV+OYM8drc78ZA3a441wq
         Wvg40YP8e9Q+KhIl7sPyddmmTLdc9QUDk2DUo09cmJ7koghMeYFdtTxjUyDNAB3Xz8
         MIETMTSsDm5cSnaPDELqVGzD6+au9syLWd/fWfRnaOJ1N8+MF+ID9t7U8Bd/7iGKM6
         gVSvL6O82nlRpXgnm1mo6DCVPUkKW8GcAih0URECHs0LLlfs64fNzYfAfv2fIEt9h0
         +IpRaOfowv7lg==
Date:   Tue, 5 Oct 2021 18:52:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20211005185217.7fb12960@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211006122315.4e04fb87@canb.auug.org.au>
References: <20211006122315.4e04fb87@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Oct 2021 12:23:15 +1100 Stephen Rothwell wrote:
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/net/ethernet/toshiba/ps3_gelic_net.c: In function 'gelic_net_setup_netdev':
> drivers/net/ethernet/toshiba/ps3_gelic_net.c:1480:26: error: passing argument 2 of 'eth_hw_addr_set' from incompatible pointer type [-Werror=incompatible-pointer-types]
>  1480 |  eth_hw_addr_set(netdev, &v1);
>       |                          ^~~
>       |                          |
>       |                          u64 * {aka long long unsigned int *}
> In file included from drivers/net/ethernet/toshiba/ps3_gelic_net.c:23:
> include/linux/etherdevice.h:309:70: note: expected 'const u8 *' {aka 'const unsigned char *'} but argument is of type 'u64 *' {aka 'long long unsigned int *'}
>   309 | static inline void eth_hw_addr_set(struct net_device *dev, const u8 *addr)
>       |                                                            ~~~~~~~~~~^~~~
> 
> Caused by commit
> 
>   a96d317fb1a3 ("ethernet: use eth_hw_addr_set()")
> 
> I have applied the following patch for today.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 6 Oct 2021 12:19:08 +1100
> Subject: [PATCH] ethernet: fix up ps3_gelic_net.c for "ethernet: use
>  eth_hw_addr_set()"
> 
> Fixes: a96d317fb1a3 ("ethernet: use eth_hw_addr_set()")
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> index 1425623b868e..3dbfb1b20649 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -1477,7 +1477,7 @@ int gelic_net_setup_netdev(struct net_device *netdev, struct gelic_card *card)
>  			 __func__, status);
>  		return -EINVAL;
>  	}
> -	eth_hw_addr_set(netdev, &v1);
> +	eth_hw_addr_set(netdev, (u8 *)&v1);
>  
>  	if (card->vlan_required) {
>  		netdev->hard_header_len += VLAN_HLEN;

Applied, thanks. Is this the last one? ;)

I wonder what happened to the kbuild bot :S
