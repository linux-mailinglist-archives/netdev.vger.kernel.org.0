Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582A461309E
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 07:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiJaGnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 02:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiJaGnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 02:43:23 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A64B1D8;
        Sun, 30 Oct 2022 23:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667198602; x=1698734602;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Z7FHaXOO6xiQWr/hB1QIjdWJm+N++mHh0y+nfZQG9LQ=;
  b=p4BKXQu6f8/a2sbbDWk+7mzUWSsbfEd5Wxi4L7dO1xYlD/LH1gJcX0mZ
   dm4kkQy1RDmca80v0AB5Zr15fv12AOt2D0eZIgOeEgIgb/33KwsUXVDvz
   eP6jPnzfLVA8wWJAbk+DtapGvcofgtTad4rqR7Kg4QJQpLxqaLEfSUdoA
   d0WN8wZFUn16xeGyIqOxRQFNtl3y7IJD/VL6dNdWzS3kI+STNKbeOJh4B
   lIOz43H+xYi1KRPxBPzsIchO7Bb+ycDtLFLu+0yI7QGuqJghTP+qa1ycL
   Fpi6EnjYdeBk/m8nPKaMeXSKHreuT/295d9Oc69Ae0NvoXqZaYbfQVhzJ
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,227,1661842800"; 
   d="scan'208";a="197692815"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Oct 2022 23:43:21 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 30 Oct 2022 23:43:21 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Sun, 30 Oct 2022 23:43:18 -0700
Date:   Mon, 31 Oct 2022 12:13:17 +0530
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <Bryan.Whitehead@microchip.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next V4] net: lan743x: Add support to SGMII register
 dump for PCI11010/PCI11414 chips
Message-ID: <20221031064317.GA8441@raju-project-pc>
References: <20221018061425.3400-1-Raju.Lakkaraju@microchip.com>
 <20221020002009.iektjcnov4oyufsk@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221020002009.iektjcnov4oyufsk@skbuf>
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Thank you for review comments.

The 10/20/2022 03:20, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Tue, Oct 18, 2022 at 11:44:25AM +0530, Raju Lakkaraju wrote:
> > +static void lan743x_sgmii_regs(struct net_device *dev, void *p)
> > +{
> > +     struct lan743x_adapter *adp = netdev_priv(dev);
> > +     u32 *rb = p;
> > +
> > +     rb[ETH_SR_VSMMD_DEV_ID1]                = SGMII_RD(adp, VSPEC1, 0x0002);
> > +     rb[ETH_SR_VSMMD_DEV_ID2]                = SGMII_RD(adp, VSPEC1, 0x0003);
> > +     rb[ETH_SR_VSMMD_PCS_ID1]                = SGMII_RD(adp, VSPEC1, 0x0004);
> > +     rb[ETH_SR_VSMMD_PCS_ID2]                = SGMII_RD(adp, VSPEC1, 0x0005);
> > +     rb[ETH_SR_VSMMD_STS]                    = SGMII_RD(adp, VSPEC1, 0x0008);
> > +     rb[ETH_SR_VSMMD_CTRL]                   = SGMII_RD(adp, VSPEC1, 0x0009);
> > +     rb[ETH_SR_MII_CTRL]                     = SGMII_RD(adp, VSPEC2, 0x0000);
> > +     rb[ETH_SR_MII_STS]                      = SGMII_RD(adp, VSPEC2, 0x0001);
> > +     rb[ETH_SR_MII_DEV_ID1]                  = SGMII_RD(adp, VSPEC2, 0x0002);
> > +     rb[ETH_SR_MII_DEV_ID2]                  = SGMII_RD(adp, VSPEC2, 0x0003);
> > +     rb[ETH_SR_MII_AN_ADV]                   = SGMII_RD(adp, VSPEC2, 0x0004);
> > +     rb[ETH_SR_MII_LP_BABL]                  = SGMII_RD(adp, VSPEC2, 0x0005);
> > +     rb[ETH_SR_MII_EXPN]                     = SGMII_RD(adp, VSPEC2, 0x0006);
> > +     rb[ETH_SR_MII_EXT_STS]                  = SGMII_RD(adp, VSPEC2, 0x000F);
> > +     rb[ETH_SR_MII_TIME_SYNC_ABL]            = SGMII_RD(adp, VSPEC2, 0x0708);
> > +     rb[ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_LWR] = SGMII_RD(adp, VSPEC2, 0x0709);
> > +     rb[ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_UPR] = SGMII_RD(adp, VSPEC2, 0x070A);
> > +     rb[ETH_SR_MII_TIME_SYNC_TX_MIN_DLY_LWR] = SGMII_RD(adp, VSPEC2, 0x070B);
> > +     rb[ETH_SR_MII_TIME_SYNC_TX_MIN_DLY_UPR] = SGMII_RD(adp, VSPEC2, 0x070C);
> > +     rb[ETH_SR_MII_TIME_SYNC_RX_MAX_DLY_LWR] = SGMII_RD(adp, VSPEC2, 0x070D);
> > +     rb[ETH_SR_MII_TIME_SYNC_RX_MAX_DLY_UPR] = SGMII_RD(adp, VSPEC2, 0x070E);
> > +     rb[ETH_SR_MII_TIME_SYNC_RX_MIN_DLY_LWR] = SGMII_RD(adp, VSPEC2, 0x070F);
> > +     rb[ETH_SR_MII_TIME_SYNC_RX_MIN_DLY_UPR] = SGMII_RD(adp, VSPEC2, 0x0710);
> > +     rb[ETH_VR_MII_DIG_CTRL1]                = SGMII_RD(adp, VSPEC2, 0x8000);
> > +     rb[ETH_VR_MII_AN_CTRL]                  = SGMII_RD(adp, VSPEC2, 0x8001);
> > +     rb[ETH_VR_MII_AN_INTR_STS]              = SGMII_RD(adp, VSPEC2, 0x8002);
> > +     rb[ETH_VR_MII_TC]                       = SGMII_RD(adp, VSPEC2, 0x8003);
> > +     rb[ETH_VR_MII_DBG_CTRL]                 = SGMII_RD(adp, VSPEC2, 0x8005);
> > +     rb[ETH_VR_MII_EEE_MCTRL0]               = SGMII_RD(adp, VSPEC2, 0x8006);
> > +     rb[ETH_VR_MII_EEE_TXTIMER]              = SGMII_RD(adp, VSPEC2, 0x8008);
> > +     rb[ETH_VR_MII_EEE_RXTIMER]              = SGMII_RD(adp, VSPEC2, 0x8009);
> > +     rb[ETH_VR_MII_LINK_TIMER_CTRL]          = SGMII_RD(adp, VSPEC2, 0x800A);
> > +     rb[ETH_VR_MII_EEE_MCTRL1]               = SGMII_RD(adp, VSPEC2, 0x800B);
> > +     rb[ETH_VR_MII_DIG_STS]                  = SGMII_RD(adp, VSPEC2, 0x8010);
> > +     rb[ETH_VR_MII_ICG_ERRCNT1]              = SGMII_RD(adp, VSPEC2, 0x8011);
> > +     rb[ETH_VR_MII_GPIO]                     = SGMII_RD(adp, VSPEC2, 0x8015);
> > +     rb[ETH_VR_MII_EEE_LPI_STATUS]           = SGMII_RD(adp, VSPEC2, 0x8016);
> > +     rb[ETH_VR_MII_EEE_WKERR]                = SGMII_RD(adp, VSPEC2, 0x8017);
> > +     rb[ETH_VR_MII_MISC_STS]                 = SGMII_RD(adp, VSPEC2, 0x8018);
> > +     rb[ETH_VR_MII_RX_LSTS]                  = SGMII_RD(adp, VSPEC2, 0x8020);
> > +     rb[ETH_VR_MII_GEN2_GEN4_TX_BSTCTRL0]    = SGMII_RD(adp, VSPEC2, 0x8038);
> > +     rb[ETH_VR_MII_GEN2_GEN4_TX_LVLCTRL0]    = SGMII_RD(adp, VSPEC2, 0x803A);
> > +     rb[ETH_VR_MII_GEN2_GEN4_TXGENCTRL0]     = SGMII_RD(adp, VSPEC2, 0x803C);
> > +     rb[ETH_VR_MII_GEN2_GEN4_TXGENCTRL1]     = SGMII_RD(adp, VSPEC2, 0x803D);
> > +     rb[ETH_VR_MII_GEN4_TXGENCTRL2]          = SGMII_RD(adp, VSPEC2, 0x803E);
> > +     rb[ETH_VR_MII_GEN2_GEN4_TX_STS]         = SGMII_RD(adp, VSPEC2, 0x8048);
> > +     rb[ETH_VR_MII_GEN2_GEN4_RXGENCTRL0]     = SGMII_RD(adp, VSPEC2, 0x8058);
> > +     rb[ETH_VR_MII_GEN2_GEN4_RXGENCTRL1]     = SGMII_RD(adp, VSPEC2, 0x8059);
> > +     rb[ETH_VR_MII_GEN4_RXEQ_CTRL]           = SGMII_RD(adp, VSPEC2, 0x805B);
> > +     rb[ETH_VR_MII_GEN4_RXLOS_CTRL0]         = SGMII_RD(adp, VSPEC2, 0x805D);
> > +     rb[ETH_VR_MII_GEN2_GEN4_MPLL_CTRL0]     = SGMII_RD(adp, VSPEC2, 0x8078);
> > +     rb[ETH_VR_MII_GEN2_GEN4_MPLL_CTRL1]     = SGMII_RD(adp, VSPEC2, 0x8079);
> > +     rb[ETH_VR_MII_GEN2_GEN4_MPLL_STS]       = SGMII_RD(adp, VSPEC2, 0x8088);
> > +     rb[ETH_VR_MII_GEN2_GEN4_LVL_CTRL]       = SGMII_RD(adp, VSPEC2, 0x8090);
> > +     rb[ETH_VR_MII_GEN4_MISC_CTRL2]          = SGMII_RD(adp, VSPEC2, 0x8093);
> > +     rb[ETH_VR_MII_GEN2_GEN4_MISC_CTRL0]     = SGMII_RD(adp, VSPEC2, 0x8099);
> > +     rb[ETH_VR_MII_GEN2_GEN4_MISC_CTRL1]     = SGMII_RD(adp, VSPEC2, 0x809A);
> > +     rb[ETH_VR_MII_SNPS_CR_CTRL]             = SGMII_RD(adp, VSPEC2, 0x80A0);
> > +     rb[ETH_VR_MII_SNPS_CR_ADDR]             = SGMII_RD(adp, VSPEC2, 0x80A1);
> > +     rb[ETH_VR_MII_SNPS_CR_DATA]             = SGMII_RD(adp, VSPEC2, 0x80A2);
> > +     rb[ETH_VR_MII_DIG_CTRL2]                = SGMII_RD(adp, VSPEC2, 0x80E1);
> > +     rb[ETH_VR_MII_DIG_ERRCNT]               = SGMII_RD(adp, VSPEC2, 0x80E2);
> 
> What a nice DesignWare XPCS register layout... Is there any chance the
> lan743x driver could use phylink and the XPCS driver from drivers/net/pcs/pcs-xpcs.c?

Yes. I would like to use phylink for SFP support. I'm working on phylink.

> I'm thinking it would be nice if we could all have access to a register
> dump procedure for it somehow.

Sure. I will check pcs-xpcs code and chnage regdump function after
implement phylink.

--------
Thanks,
Raju
