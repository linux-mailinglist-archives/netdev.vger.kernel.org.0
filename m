Return-Path: <netdev+bounces-4222-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3137A70BBE7
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 13:33:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFC49280F5B
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 11:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42480D30B;
	Mon, 22 May 2023 11:32:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33ED7D2F1
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:32:51 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B308ABB;
	Mon, 22 May 2023 04:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684755160; x=1716291160;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GsuBZcasl8sgSNzixS2gOiiY1ioqkDcpYlCuGBXnRyo=;
  b=gqX0EBpvEuRToAmejaYPMixciBJJEO0ufMqXgcnVMDT5yVgUyrNz+PG+
   MqRVeFfBGmVxBsJ1QecsfiFcMdJAEYcXSxzqEywyi28XDTc0U5fhq0yOL
   ci0xsYjdm7/SU3KAjSuZ3R7Dnu0zxH+8oWRrI2i0R2m2Smljjj/PYHMy5
   xlFlTeLmUwa0RwV08Knxym/G8W6cxFjl5HyqPv78byn42fIPF/QvEHGwx
   qoq3r1H6JvZ5olnf6mnvxbk56xrPykkHFXuetDTSqHY6vKuUDZsr4BOmx
   u3ZP4b8qUu/duNlcjTizHJEIILDehQHTpRkag94lrYJjFCr60c0nVgQAX
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="153287684"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2023 04:32:39 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 22 May 2023 04:32:38 -0700
Received: from CHE-LT-I17164LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Mon, 22 May 2023 04:32:33 -0700
From: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ramon.nordin.rodriguez@ferroamp.se>
CC: <horatiu.vultur@microchip.com>, <Woojung.Huh@microchip.com>,
	<Nicolas.Ferre@microchip.com>, <Thorsten.Kummermehr@microchip.com>,
	"Parthiban Veerasooran" <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next v2 2/6] net: phy: microchip_t1s: replace read-modify-write code with phy_modify_mmd
Date: Mon, 22 May 2023 17:03:27 +0530
Message-ID: <20230522113331.36872-3-Parthiban.Veerasooran@microchip.com>
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

Replace read-modify-write code in the lan867x_config_init function to
avoid handling data type mismatch and to simplify the code.

Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
---
 drivers/net/phy/microchip_t1s.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/microchip_t1s.c b/drivers/net/phy/microchip_t1s.c
index a42a6bb6e3bd..534d9faf8475 100644
--- a/drivers/net/phy/microchip_t1s.c
+++ b/drivers/net/phy/microchip_t1s.c
@@ -31,19 +31,19 @@
  * W   0x1F 0x0099 0x7F80 ------
  */
 
-static const int lan867x_fixup_registers[12] = {
+static const u32 lan867x_fixup_registers[12] = {
 	0x00D0, 0x00D1, 0x0084, 0x0085,
 	0x008A, 0x0087, 0x0088, 0x008B,
 	0x0080, 0x00F1, 0x0096, 0x0099,
 };
 
-static const int lan867x_fixup_values[12] = {
+static const u16 lan867x_fixup_values[12] = {
 	0x0002, 0x0000, 0x3380, 0x0006,
 	0xC000, 0x801C, 0x033F, 0x0404,
 	0x0600, 0x2400, 0x2000, 0x7F80,
 };
 
-static const int lan867x_fixup_masks[12] = {
+static const u16 lan867x_fixup_masks[12] = {
 	0x0E03, 0x0300, 0xFFC0, 0x000F,
 	0xF800, 0x801C, 0x1FFF, 0xFFFF,
 	0x0600, 0x7F00, 0x2000, 0xFFFF,
@@ -63,9 +63,7 @@ static int lan867x_config_init(struct phy_device *phydev)
 	 * used, which might then write the same value back as read + modified.
 	 */
 
-	int reg_value;
 	int err;
-	int reg;
 
 	/* Read-Modified Write Pseudocode (from AN1699)
 	 * current_val = read_register(mmd, addr) // Read current register value
@@ -74,12 +72,11 @@ static int lan867x_config_init(struct phy_device *phydev)
 	 * write_register(mmd, addr, new_val) // Write back updated register value
 	 */
 	for (int i = 0; i < ARRAY_SIZE(lan867x_fixup_registers); i++) {
-		reg = lan867x_fixup_registers[i];
-		reg_value = phy_read_mmd(phydev, MDIO_MMD_VEND2, reg);
-		reg_value &= ~lan867x_fixup_masks[i];
-		reg_value |= lan867x_fixup_values[i];
-		err = phy_write_mmd(phydev, MDIO_MMD_VEND2, reg, reg_value);
-		if (err != 0)
+		err = phy_modify_mmd(phydev, MDIO_MMD_VEND2,
+				     lan867x_fixup_registers[i],
+				     lan867x_fixup_masks[i],
+				     lan867x_fixup_values[i]);
+		if (err)
 			return err;
 	}
 
-- 
2.34.1


