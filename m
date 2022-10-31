Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4B56130C3
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 07:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiJaGyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 02:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJaGxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 02:53:42 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05608BC30;
        Sun, 30 Oct 2022 23:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667199223; x=1698735223;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rU4I0JveSpwxFZv76TH1DlpqLQDynZN6SkcnkghPSTc=;
  b=RVLiCcx9XxcTL7YHFTDmlkctdxnzEzwrMzW2dweVI3WjkPLjEhgHAiSB
   HvkKHRLScjO1rm0/gjW3f9fJ4jIE7z57Ifkd9c1Yyw4fObHrLIoIJ717O
   78C3sxPyZ/j66Z6rMFAAb3IfXMcwNZdJ6iHj4USP9obr+IJRayK4QO9hi
   1cUeVS8cVt0Xj52/MW/Gw3FmArQ5jyZPvu76G0z2WqwhVaAvVYBNnPTkm
   qmKXPAvcd+HkMrTOyjTcPyy9l59SnspmHYbA5hpL/x8KsEFBYMGAdTaWf
   U2LAW35hBxQRQ1PfFx63QN/8bOyhaUZoj2EbYvlTxNb16TSmikNLpJWDu
   g==;
X-IronPort-AV: E=Sophos;i="5.95,227,1661842800"; 
   d="scan'208";a="181184807"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Oct 2022 23:53:42 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 30 Oct 2022 23:53:40 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Sun, 30 Oct 2022 23:53:37 -0700
Date:   Mon, 31 Oct 2022 12:23:36 +0530
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <Bryan.Whitehead@microchip.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next V4] net: lan743x: Add support to SGMII register
 dump for PCI11010/PCI11414 chips
Message-ID: <20221031065336.GB8441@raju-project-pc>
References: <20221018061425.3400-1-Raju.Lakkaraju@microchip.com>
 <20221019164344.52cf16dd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221019164344.52cf16dd@kernel.org>
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Thank you for review comments.

The 10/19/2022 16:43, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Tue, 18 Oct 2022 11:44:25 +0530 Raju Lakkaraju wrote:
> > Add support to SGMII register dump
> 
> > +++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
> > @@ -24,6 +24,9 @@
> >  #define LOCK_TIMEOUT_MAX_CNT             (100) // 1 sec (10 msce * 100)
> >
> >  #define LAN743X_CSR_READ_OP(offset)       lan743x_csr_read(adapter, offset)
> > +#define VSPEC1                       MDIO_MMD_VEND1
> > +#define VSPEC2                       MDIO_MMD_VEND2
> > +#define SGMII_RD(adp, dev, adr) lan743x_sgmii_dump_read(adp, dev, adr)
> 
> These defines help limit the line length?
> Please don't obfuscate code like that, see below.
> 

Accepted. I will remove the above code.

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
> 
> You can declare a structure holding the params and save the info there:
> 
>         struct {
>                 u8 id;
>                 u8 dev;
>                 u16 addr;
>         } regs[] = {
>                 { ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_LWR,  MDIO_MMD_VEND2, 0x0709 },
>         };
> 
> that should fit on the line.

O.K. I will change.

> 
> You can then read the values in a loop. And inside that loop you can
> handle errors (perhaps avoiding the need for lan743x_sgmii_dump_read()
> which seems rather unnecessary as lan743x_sgmii_read() already prints
> errors).
> 
> FWIW I like Andrew's suggestion from v3 to use version as a bitfield, too.

I will implement Andrew's suggestion in my next regdump function patch.
Is it OK ?

--------
Thanks,
Raju
