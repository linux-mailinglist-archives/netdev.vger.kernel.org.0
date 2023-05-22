Return-Path: <netdev+bounces-4224-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A669570BBEA
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 13:34:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B9F31C20A0C
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 11:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D601D51C;
	Mon, 22 May 2023 11:32:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52626D50B
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:32:54 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB92FBF;
	Mon, 22 May 2023 04:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684755172; x=1716291172;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0yLHxZxQfF+DDlqfKZ3+pv14kwWQnNBMa6lwC1NTzeA=;
  b=V7154ReQ54nGQZr9A7I4uoKRYT/gZNChJswdpZ6puf5aR30XjwxDb5Vh
   vzWA9+4mg/M4WPkPcsxN/n0g6v7n7AQjOptSPjbFA7QJgPPDyQ/rl427U
   U2f7ahZMcvau5gqubBREgOH1TcCkVWcSE/Q4ArDjnGxk8DhQPLKKJPYi5
   LUWW6x5fqr3COVwSYRYUrzZ8AOfvoqUhroZsLYEOhLg61pz7J1K2129Ud
   boWdBwGiyQw5ohs4+9mbnvzKLdkj1Z64Ei/krbse6yDbvDy+cWCJ0Fpjf
   Ynss49Nan/lwH0FbbVN+/NPnnnCGcnDmQZUsSa0JdpV8iMyDeIWyWJ4XL
   w==;
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="212450157"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2023 04:32:51 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 22 May 2023 04:32:48 -0700
Received: from CHE-LT-I17164LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Mon, 22 May 2023 04:32:44 -0700
From: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ramon.nordin.rodriguez@ferroamp.se>
CC: <horatiu.vultur@microchip.com>, <Woojung.Huh@microchip.com>,
	<Nicolas.Ferre@microchip.com>, <Thorsten.Kummermehr@microchip.com>,
	"Parthiban Veerasooran" <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next v2 4/6] net: phy: microchip_t1s: fix reset complete status handling
Date: Mon, 22 May 2023 17:03:29 +0530
Message-ID: <20230522113331.36872-5-Parthiban.Veerasooran@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230522113331.36872-1-Parthiban.Veerasooran@microchip.com>
References: <20230522113331.36872-1-Parthiban.Veerasooran@microchip.com>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As per the datasheet DS-LAN8670-1-2-60001573C.pdf, the Reset Complete
status bit in the STS2 register to be checked before proceeding for the
initial configuration.

Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
---
 drivers/net/phy/microchip_t1s.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/phy/microchip_t1s.c b/drivers/net/phy/microchip_t1s.c
index 869c7f403ea1..2f22a1954c09 100644
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
@@ -65,6 +68,27 @@ static int lan867x_revb1_config_init(struct phy_device *phydev)
 
 	int err;
 
+	/* Read STS2 register and check for the Reset Complete status to do the
+	 * init configuration. If the Reset Complete is not set, wait for 5us
+	 * and then read STS2 register again and check for Reset Complete status.
+	 * Still if it is failed then declare PHY reset error or else proceed
+	 * for the PHY initial register configuration.
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
 	/* Read-Modified Write Pseudocode (from AN1699)
 	 * current_val = read_register(mmd, addr) // Read current register value
 	 * new_val = current_val AND (NOT mask) // Clear bit fields to be written
-- 
2.34.1


