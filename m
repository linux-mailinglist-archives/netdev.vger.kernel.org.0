Return-Path: <netdev+bounces-5053-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2E8470F8F9
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:45:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F14E1C20DA5
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:45:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72C9E1800A;
	Wed, 24 May 2023 14:44:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6600918AF8
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:44:46 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF940C1;
	Wed, 24 May 2023 07:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684939484; x=1716475484;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uSfqOWtPPlqoLDTT1//GodCoyf69GseeY7MaOQIvqCY=;
  b=M51IwuIvAS5x1353Qhsp/TzMhtt1Bd95u1N2cuiUK5vafAwmIDfcRm9u
   28QrEMAeYq3wfuEpkU31vLlAWCFZfp3djTowQXcausU+Zzi09+YeAFOrG
   3dRN6sDUEu4cTYQ8hdMcWHGEH8zVATw1BzdMr0jf0fyIAy0OT9Y7QPm8k
   uOYMqNxTl6UGs97BVkilVxsptRZlkcoJLLGb5q22J2MZW2tyI2ashwBgJ
   /I/+52rqtqJ3V1xH7EU8jufrM93jbf2jXbhXQomL95aPkEYclvMjV3DxF
   orftY7ricHpwj0ParRurO+2dVOAdhcJORns6IpzIAazqMW/xWH9mNbP9c
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="214713902"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 May 2023 07:44:44 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 24 May 2023 07:44:43 -0700
Received: from CHE-LT-I17164LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Wed, 24 May 2023 07:44:39 -0700
From: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ramon.nordin.rodriguez@ferroamp.se>
CC: <horatiu.vultur@microchip.com>, <Woojung.Huh@microchip.com>,
	<Nicolas.Ferre@microchip.com>, <Thorsten.Kummermehr@microchip.com>,
	"Parthiban Veerasooran" <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next v3 2/6] net: phy: microchip_t1s: replace read-modify-write code with phy_modify_mmd
Date: Wed, 24 May 2023 20:15:35 +0530
Message-ID: <20230524144539.62618-3-Parthiban.Veerasooran@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
References: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
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
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Replace read-modify-write code in the lan867x_config_init function to
avoid handling data type mismatch and to simplify the code.

Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
---
 drivers/net/phy/microchip_t1s.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/microchip_t1s.c b/drivers/net/phy/microchip_t1s.c
index a42a6bb6e3bd..b5b5a95fa6e7 100644
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
@@ -63,23 +63,22 @@ static int lan867x_config_init(struct phy_device *phydev)
 	 * used, which might then write the same value back as read + modified.
 	 */
 
-	int reg_value;
 	int err;
-	int reg;
 
 	/* Read-Modified Write Pseudocode (from AN1699)
 	 * current_val = read_register(mmd, addr) // Read current register value
 	 * new_val = current_val AND (NOT mask) // Clear bit fields to be written
 	 * new_val = new_val OR value // Set bits
-	 * write_register(mmd, addr, new_val) // Write back updated register value
+	 * write_register(mmd, addr, new_val) // Write back updated register value.
+	 * Although AN1699 says Read, Modify, Write, the write is not required if
+	 * the register already has the required value.
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


