Return-Path: <netdev+bounces-5731-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54EFB712954
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:23:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBD651C20F88
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:23:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45D6C271E1;
	Fri, 26 May 2023 15:23:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C078848B
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 15:23:11 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32233E47;
	Fri, 26 May 2023 08:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685114588; x=1716650588;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B7RtPpz7kYTaJ/wLlKs4jEJDvXUJSXp/bNU5olhnjJ4=;
  b=A88ammDPV0PFI+O46cOBow0HDWE1u5Yobe7+xHyevPlysVOB7sPQijzO
   NvSihUi1iYQIDLdhVSY50GjE2O2WMR+RsnoqCZXRrK2PzQsKbh4av8mFM
   cGkfOUDTTSgUGT9rEKuw3Ilp4Gc8rLTmZmwV0f2g8wHY8DgZ5ZXjnWERE
   CaBSHsDkTRNkfbs8ipT80wmh8SQmWwVXXpReBZjyrVuF/arhHKDmBU9H0
   fGhsMkwJS+qfvUBwI4++BzDxnQpXFjwjDx4ecjp/BicDA1kfm3hMa6YnQ
   EWQUdHB0lWHl3KlatEfx7wzjlZ8dxVcCPLrSTXcBMdKotJVVnB4TIcq9E
   A==;
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="154119474"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 May 2023 08:23:07 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 26 May 2023 08:23:02 -0700
Received: from CHE-LT-I17164LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Fri, 26 May 2023 08:22:57 -0700
From: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ramon.nordin.rodriguez@ferroamp.se>
CC: <horatiu.vultur@microchip.com>, <Woojung.Huh@microchip.com>,
	<Nicolas.Ferre@microchip.com>, <Thorsten.Kummermehr@microchip.com>,
	"Parthiban Veerasooran" <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next v4 4/6] net: phy: microchip_t1s: fix reset complete status handling
Date: Fri, 26 May 2023 20:53:46 +0530
Message-ID: <20230526152348.70781-5-Parthiban.Veerasooran@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230526152348.70781-1-Parthiban.Veerasooran@microchip.com>
References: <20230526152348.70781-1-Parthiban.Veerasooran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As per the datasheet DS-LAN8670-1-2-60001573C.pdf, the Reset Complete
status bit in the STS2 register has to be checked before proceeding to
the initial configuration. Reading STS2 register will also clear the
Reset Complete interrupt which is non-maskable.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
---
 drivers/net/phy/microchip_t1s.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/phy/microchip_t1s.c b/drivers/net/phy/microchip_t1s.c
index 7abecad28bf1..0ecef87e5882 100644
--- a/drivers/net/phy/microchip_t1s.c
+++ b/drivers/net/phy/microchip_t1s.c
@@ -14,6 +14,9 @@
 
 #define LAN867X_REG_IRQ_1_CTL 0x001C
 #define LAN867X_REG_IRQ_2_CTL 0x001D
+#define LAN867X_REG_STS2 0x0019
+
+#define LAN867x_RESET_COMPLETE_STS BIT(11)
 
 /* The arrays below are pulled from the following table from AN1699
  * Access MMD Address Value Mask
@@ -53,6 +56,24 @@ static int lan867x_revb1_config_init(struct phy_device *phydev)
 {
 	int err;
 
+	/* The chip completes a reset in 3us, we might get here earlier than
+	 * that, as an added margin we'll conditionally sleep 5us.
+	 */
+	err = phy_read_mmd(phydev, MDIO_MMD_VEND2, LAN867X_REG_STS2);
+	if (err < 0)
+		return err;
+
+	if (!(err & LAN867x_RESET_COMPLETE_STS)) {
+		udelay(5);
+		err = phy_read_mmd(phydev, MDIO_MMD_VEND2, LAN867X_REG_STS2);
+		if (err < 0)
+			return err;
+		if (!(err & LAN867x_RESET_COMPLETE_STS)) {
+			phydev_err(phydev, "PHY reset failed\n");
+			return -ENODEV;
+		}
+	}
+
 	/* Reference to AN1699
 	 * https://ww1.microchip.com/downloads/aemDocuments/documents/AIS/ProductDocuments/SupportingCollateral/AN-LAN8670-1-2-config-60001699.pdf
 	 * AN1699 says Read, Modify, Write, but the Write is not required if the
-- 
2.34.1


