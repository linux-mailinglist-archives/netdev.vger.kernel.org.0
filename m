Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87F06BCB46
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjCPJo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjCPJo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:44:57 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C311F132E6
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 02:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678959892; x=1710495892;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iiUKp2JxkU5DkzMmojIAJhchHw+PKDPxQbBmVeuKVdY=;
  b=hcWaRx5kmZL46aCk1yXUff1SzSK6KH0NyoIygodZZc8AmDkK/rGaUhBA
   2lywTjD3OhOqWUrkepV7otu+zmLTci0xxbTbhiiNJ6lHpMR+zKe+V104p
   O1Qj/FUXg8pEXBWPvtgbaXOxQXGAMfrpJIXPOJmiWScLx4dFMxSy0l5Id
   mq3ww+HYxFTdozs3IG156n57rEvEpBDb8blJbiuNIXEYmjaN9FCFy0acN
   1yCNIDv25zNtS5CAocfawNIlD0PeqCcEyf2lQrn17FP7Z+Ad6EJdgdLeB
   b06vXxP7alL8LEzqCMfV79PeJdu0jqORBG80p76daF0iBj0P4wTO67LLT
   g==;
X-IronPort-AV: E=Sophos;i="5.98,265,1673938800"; 
   d="scan'208";a="216582306"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Mar 2023 02:44:51 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 02:44:51 -0700
Received: from den-her-m31857h.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 02:44:49 -0700
Message-ID: <918d1908c2771f4941c191b73c495e20d89a6a99.camel@microchip.com>
Subject: Re: [PATCH net-next 1/2] net: pcs: xpcs: remove double-read of link
 state when using AN
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan McDowell <noodles@earth.li>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
Date:   Thu, 16 Mar 2023 10:44:48 +0100
In-Reply-To: <E1pcSOp-00DiAo-Su@rmk-PC.armlinux.org.uk>
References: <ZBHaQDM+G/o/UW3i@shell.armlinux.org.uk>
         <E1pcSOp-00DiAo-Su@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,


On Wed, 2023-03-15 at 14:46 +0000, Russell King (Oracle) wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Phylink does not want the current state of the link when reading the
> PCS link state - it wants the latched state. Don't double-read the
> MII status register. Phylink will re-read as necessary to capture
> transient link-down events as of dbae3388ea9c ("net: phylink: Force
> retrigger in case of latched link-fail indicator").
> 
> The above referenced commit is a dependency for this change, and thus
> this change should not be backported to any kernel that does not
> contain the above referenced commit.
> 
> Fixes: fcb26bd2b6ca ("net: phy: Add Synopsys DesignWare XPCS MDIO module")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/pcs/pcs-xpcs.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> index bc428a816719..04a685353041 100644
> --- a/drivers/net/pcs/pcs-xpcs.c
> +++ b/drivers/net/pcs/pcs-xpcs.c
> @@ -321,7 +321,7 @@ static int xpcs_read_fault_c73(struct dw_xpcs *xpcs,
>         return 0;
>  }
> 
> -static int xpcs_read_link_c73(struct dw_xpcs *xpcs, bool an)
> +static int xpcs_read_link_c73(struct dw_xpcs *xpcs)
>  {
>         bool link = true;
>         int ret;
> @@ -333,15 +333,6 @@ static int xpcs_read_link_c73(struct dw_xpcs *xpcs, bool an)
>         if (!(ret & MDIO_STAT1_LSTATUS))
>                 link = false;
> 
> -       if (an) {
> -               ret = xpcs_read(xpcs, MDIO_MMD_AN, MDIO_STAT1);
> -               if (ret < 0)
> -                       return ret;
> -
> -               if (!(ret & MDIO_STAT1_LSTATUS))
> -                       link = false;
> -       }
> -
>         return link;
>  }
> 
> @@ -935,7 +926,7 @@ static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
>         int ret;
> 
>         /* Link needs to be read first ... */
> -       state->link = xpcs_read_link_c73(xpcs, state->an_enabled) > 0 ? 1 : 0;
> +       state->link = xpcs_read_link_c73(xpcs) > 0 ? 1 : 0;

Couldn't you just say:

	state->link = xpcs_read_link_c73(xpcs) > 0;

That should be a boolean, right?

> 
>         /* ... and then we check the faults. */
>         ret = xpcs_read_fault_c73(xpcs, state);
> --
> 2.30.2
> 

BR
Steen

