Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3EE11370E
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 22:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbfLDV0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 16:26:24 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46858 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727961AbfLDV0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 16:26:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=APTYO2m9RqLPS3/Ab4sFK3b8fupKn7GjGF+Y+A4PgJQ=; b=pwrTnNMUtw8xL0UCuINDi+4KR
        nmAJmdt15WxSBToDLqANuDZwIMwV8zghocbsqdtyehLS69435sSRfMSlzblN+LaDOHNH1eccqJFE4
        Mnoeywvh5fhCdhmRJ5kdx40ApGuRw8eLREgudr9BEF933kGeuUEeVExGXNkldEYpFliFJ+DL0Ygv9
        ro2PYiI6hGyDiyqGkbGkkOLC5WQPhYlgC2FCiHSTzPhuaDPHC35wJTPW4E9vVnwqD9H+i1K6AqKRc
        a6E1esiPJAvMQwTw1rQjfHZuYMDwGlLTRqlSQOoJUR4IgnrOaWfpvx+VCskwqI1yLQDjFlXtgb2Zd
        9tGZXSR9Q==;
Received: from [2601:1c0:6280:3f0::3deb]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iccAB-0000qr-J0; Wed, 04 Dec 2019 21:26:23 +0000
Subject: Re: [PATCH 1/2] net: ethernet: ti: cpsw_switchdev: fix unmet direct
 dependencies detected for NET_SWITCHDEV
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>
Cc:     Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
References: <20191204174533.32207-1-grygorii.strashko@ti.com>
 <20191204174533.32207-2-grygorii.strashko@ti.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <5c844455-8116-5c3d-43eb-c3d12710c9c9@infradead.org>
Date:   Wed, 4 Dec 2019 13:26:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191204174533.32207-2-grygorii.strashko@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/19 9:45 AM, Grygorii Strashko wrote:
> Replace "select NET_SWITCHDEV" vs "depends on NET_SWITCHDEV" to fix Kconfig
> warning with CONFIG_COMPILE_TEST=y
> 
> WARNING: unmet direct dependencies detected for NET_SWITCHDEV
>   Depends on [n]: NET [=y] && INET [=n]
>   Selected by [y]:
>   - TI_CPSW_SWITCHDEV [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_TI [=y] && (ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST [=y])
> 
> because TI_CPSW_SWITCHDEV blindly selects NET_SWITCHDEV even though
> INET is not set/enabled, while NET_SWITCHDEV depends on INET.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.

> ---
>  drivers/net/ethernet/ti/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> index 9170572346b5..a46f4189fde3 100644
> --- a/drivers/net/ethernet/ti/Kconfig
> +++ b/drivers/net/ethernet/ti/Kconfig
> @@ -62,7 +62,7 @@ config TI_CPSW
>  config TI_CPSW_SWITCHDEV
>  	tristate "TI CPSW Switch Support with switchdev"
>  	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
> -	select NET_SWITCHDEV
> +	depends on NET_SWITCHDEV
>  	select TI_DAVINCI_MDIO
>  	select MFD_SYSCON
>  	select REGMAP
> 


-- 
~Randy

