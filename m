Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F0151A40C
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352497AbiEDPcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352480AbiEDPcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:32:14 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC0B44A01
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 08:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651678118; x=1683214118;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=Oi/vTrai5jYYzfHSOcmmV/w4dpjpWnPxRFoel5ndLwo=;
  b=mjYqgi9yGVBdKWTs5N0QKW9eTWDYcb7Ljmn9312jVCQQe7QisN1NH0pO
   zCY/hEtk0Kj2cnNlojaM/8MbkcpYujFDquOFyTGRelvrJwpoVh8AOKr2P
   G4wXSLCEEv8q4+ZwwrrA7vgTuL9t0trLRpBfLNFoyFOYRbzGCQrwrfgax
   ReqCd7zB1y/45I1Dsgng8x5g2ZSpOWGwwiElPcMzcaWNkewQurZxLO09P
   v9I4MkLIwt0PuAx4eBpEaDA2pnqqiFPtcbkW91c8G7miT9TFEjwD7gSct
   lhzlE3Szo8Gfu11VRIlRZovcklFb726CCNuveezbxQHELjw4Kp3VxzaWZ
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="162716388"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 May 2022 08:28:37 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 4 May 2022 08:28:37 -0700
Received: from chn-vm-ungapp01.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 4 May 2022 08:28:37 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <woojung.huh@microchip.com>, <yuiko.oshino@microchip.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <ravi.hegde@microchip.com>, <UNGLinuxDriver@microchip.com>
Subject: [PATCH v3 net-next 2/2] net: phy: smsc: add LAN8742 phy support.
Date:   Wed, 4 May 2022 08:28:22 -0700
Message-ID: <20220504152822.11890-3-yuiko.oshino@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220504152822.11890-1-yuiko.oshino@microchip.com>
References: <20220504152822.11890-1-yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current phy IDs on the available hardware.
        LAN8742 0x0007C130, 0x0007C131

Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
---
 drivers/net/phy/smsc.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index d8cac02a79b9..37f05793e030 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -483,6 +483,36 @@ static struct phy_driver smsc_phy_driver[] = {
 
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
+}, {
+	.phy_id	= 0x0007c130,	/* 0x0007c130 and 0x0007c131 */
+	/* This mask (0xfffffff2) is to differentiate from
+	 * LAN88xx (phy_id 0x0007c132)
+	 * and allows future phy_id revisions.
+	 */
+	.phy_id_mask	= 0xfffffff2,
+	.name		= "Microchip LAN8742",
+
+	/* PHY_BASIC_FEATURES */
+	.flags		= PHY_RST_AFTER_CLK_EN,
+
+	.probe		= smsc_phy_probe,
+
+	/* basic functions */
+	.read_status	= lan87xx_read_status,
+	.config_init	= smsc_phy_config_init,
+	.soft_reset	= smsc_phy_reset,
+
+	/* IRQ related */
+	.config_intr	= smsc_phy_config_intr,
+	.handle_interrupt = smsc_phy_handle_interrupt,
+
+	/* Statistics */
+	.get_sset_count = smsc_get_sset_count,
+	.get_strings	= smsc_get_strings,
+	.get_stats	= smsc_get_stats,
+
+	.suspend	= genphy_suspend,
+	.resume	= genphy_resume,
 } };
 
 module_phy_driver(smsc_phy_driver);
@@ -498,6 +528,7 @@ static struct mdio_device_id __maybe_unused smsc_tbl[] = {
 	{ 0x0007c0d0, 0xfffffff0 },
 	{ 0x0007c0f0, 0xfffffff0 },
 	{ 0x0007c110, 0xfffffff0 },
+	{ 0x0007c130, 0xfffffff2 },
 	{ }
 };
 
-- 
2.25.1

