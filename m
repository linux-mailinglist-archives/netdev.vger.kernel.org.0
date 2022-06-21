Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37FE553AC9
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 21:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353383AbiFUTu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 15:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbiFUTu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 15:50:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C281A24F01
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 12:50:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F991B81B1F
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 19:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5486C341CD;
        Tue, 21 Jun 2022 19:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655841055;
        bh=6Rh2SEN7aikfWPwmDXGcMXqdVLaME1ndHkQWKeeIUes=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gY0Y7HMGLl+XtqkG8ucQqOJhbM1Ma510lWjiqXlD0/wrbWdSGpaYhZobOGJFqj6XV
         L3lv26M7PBXWbzFnzeTcj7s27di7ZNuaiMaESO3fZqyUK0mNTILt+ULZKfV3Dd31Co
         WkZpnvUbcgOIsK0kr0DqIbK/QXhOy05XehbGGWxmOiWOq35tOkPYL2omh4MpKJGi3A
         RW0InKJEh8FMVnsQ2yOm7MSoM6bhYPqgK5sLX/zzoXXsuxi177DmjKlYZGQLXJX0R5
         /sObGPWTJS5xYV+/GNpamnIlvYq5m70hEXosLtVVslXQh+nfgbizbqkaKkekOZOpjs
         +v+XEM9AA2jaA==
Date:   Tue, 21 Jun 2022 12:50:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net-next] net: pcs: xpcs: depends on PHYLINK in Kconfig
Message-ID: <20220621125045.7e0a78c2@kernel.org>
In-Reply-To: <6959a6a51582e8bc2343824d0cee56f1db246e23.1655797997.git.pabeni@redhat.com>
References: <6959a6a51582e8bc2343824d0cee56f1db246e23.1655797997.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jun 2022 09:55:35 +0200 Paolo Abeni wrote:
> This is another attempt at fixing:
> 
> >> ERROR: modpost: "phylink_mii_c22_pcs_encode_advertisement" [drivers/net/pcs/pcs_xpcs.ko] undefined!
> >> ERROR: modpost: "phylink_mii_c22_pcs_decode_state" [drivers/net/pcs/pcs_xpcs.ko] undefined!  
> 
> We can't select PHYLINK, or that will trigger a circular dependency
> PHYLINK already selects PHYLIB, which in turn selects MDIO_DEVICE:
> replacing the MDIO_DEVICE dependency with PHYLINK will pull all the
> required configs.

We can't use depends with PHYLINK, AFAIU, because PHYLINK is not 
a user-visible knob. Its always "select"ed and does not show up
in {x,n,menu}config.

If there is no string after bool/tristate the option is not visible 
to the user:

config PHYLINK                                                                  
        tristate  
        depends on NETDEVICES                                                   
        select PHYLIB       

> Link: https://lore.kernel.org/netdev/20220620201915.1195280-1-kuba@kernel.org/
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: b47aec885bcd ("net: pcs: xpcs: add CL37 1000BASE-X AN support")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  drivers/net/pcs/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
> index 22ba7b0b476d..70fd6a03e982 100644
> --- a/drivers/net/pcs/Kconfig
> +++ b/drivers/net/pcs/Kconfig
> @@ -7,7 +7,7 @@ menu "PCS device drivers"
>  
>  config PCS_XPCS
>  	tristate "Synopsys DesignWare XPCS controller"
> -	depends on MDIO_DEVICE && MDIO_BUS
> +	depends on PHYLINK && MDIO_BUS
>  	help
>  	  This module provides helper functions for Synopsys DesignWare XPCS
>  	  controllers.

