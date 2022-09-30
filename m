Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA445F0D75
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbiI3OXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbiI3OWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:22:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A31B4F686
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:21:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39193B828F9
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B51C433C1;
        Fri, 30 Sep 2022 14:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664547697;
        bh=g5NtHzvmP5c58U5iVYWiuNkGRjY0fmXyklubuUujc3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pplafjcln3cA4QqvEsijJbbZswcIoSNmi88/6yg/pzspJ8bs8EKRzUmN/h+r54Yi8
         ZBLGqJ/WoXF8Kle0DCCHL4RYLKOys+Gge8gDhWcumFIK3z5V6bvJd/qfoJeGi3Qieb
         Aqyw1EneyjDW54pdClpAbxA0iUf8Hemz/WttSszD6ouDt614MmxKvtXg9wGQ0zCeTm
         5SIXVftWYRa40XnPa6oFRObbPs91qNyaInqI2AgorTS+C1suexXtf1qTPgYZaEOpRh
         ON5xne9SGa99QpXJPVgcVLqVrNRwQRW1ck8T/LLNQEyHg4YqFEfK3n4hQ+fpiMrLBP
         wjL0MvV5Lpmdg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 12/12] net: sfp: add support for multigig RollBall transceivers
Date:   Fri, 30 Sep 2022 16:21:10 +0200
Message-Id: <20220930142110.15372-13-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220930142110.15372-1-kabel@kernel.org>
References: <20220930142110.15372-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for multigig copper SFP modules from RollBall/Hilink.
These modules have a specific way to access clause 45 registers of the
internal PHY.

We also need to wait at least 22 seconds after deasserting TX disable
before accessing the PHY. The code waits for 25 seconds just to be sure.

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 49 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 20f48464a06a..40c9a64c5e30 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -166,6 +166,7 @@ static const enum gpiod_flags gpio_flags[] = {
  * on board (for a copper SFP) time to initialise.
  */
 #define T_WAIT			msecs_to_jiffies(50)
+#define T_WAIT_ROLLBALL		msecs_to_jiffies(25000)
 #define T_START_UP		msecs_to_jiffies(300)
 #define T_START_UP_BAD_GPON	msecs_to_jiffies(60000)
 
@@ -205,8 +206,11 @@ static const enum gpiod_flags gpio_flags[] = {
 
 /* SFP modules appear to always have their PHY configured for bus address
  * 0x56 (which with mdio-i2c, translates to a PHY address of 22).
+ * RollBall SFPs access phy via SFP Enhanced Digital Diagnostic Interface
+ * via address 0x51 (mdio-i2c will use RollBall protocol on this address).
  */
-#define SFP_PHY_ADDR	22
+#define SFP_PHY_ADDR		22
+#define SFP_PHY_ADDR_ROLLBALL	17
 
 struct sff_data {
 	unsigned int gpios;
@@ -252,6 +256,7 @@ struct sfp {
 	struct sfp_eeprom_id id;
 	unsigned int module_power_mW;
 	unsigned int module_t_start_up;
+	unsigned int module_t_wait;
 	bool tx_fault_ignore;
 
 	const struct sfp_quirk *quirk;
@@ -331,6 +336,22 @@ static void sfp_fixup_halny_gsfp(struct sfp *sfp)
 	sfp->state_hw_mask &= ~(SFP_F_TX_FAULT | SFP_F_LOS);
 }
 
+static void sfp_fixup_rollball(struct sfp *sfp)
+{
+	sfp->mdio_protocol = MDIO_I2C_ROLLBALL;
+	sfp->module_t_wait = T_WAIT_ROLLBALL;
+}
+
+static void sfp_fixup_rollball_cc(struct sfp *sfp)
+{
+	sfp_fixup_rollball(sfp);
+
+	/* Some RollBall SFPs may have wrong (zero) extended compliance code
+	 * burned in EEPROM. For PHY probing we need the correct one.
+	 */
+	sfp->id.base.extended_cc = SFF8024_ECC_10GBASE_T_SFI;
+}
+
 static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
 				unsigned long *modes,
 				unsigned long *interfaces)
@@ -378,6 +399,12 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK_M("Lantech", "8330-262D-E", sfp_quirk_2500basex),
 
 	SFP_QUIRK_M("UBNT", "UF-INSTANT", sfp_quirk_ubnt_uf_instant),
+
+	SFP_QUIRK_F("OEM", "SFP-10G-T", sfp_fixup_rollball_cc),
+	SFP_QUIRK_F("OEM", "RTSFP-10", sfp_fixup_rollball_cc),
+	SFP_QUIRK_F("OEM", "RTSFP-10G", sfp_fixup_rollball_cc),
+	SFP_QUIRK_F("Turris", "RTSFP-10", sfp_fixup_rollball),
+	SFP_QUIRK_F("Turris", "RTSFP-10G", sfp_fixup_rollball),
 };
 
 static size_t sfp_strlen(const char *str, size_t maxlen)
@@ -1585,12 +1612,12 @@ static void sfp_sm_phy_detach(struct sfp *sfp)
 	sfp->mod_phy = NULL;
 }
 
-static int sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
+static int sfp_sm_probe_phy(struct sfp *sfp, int addr, bool is_c45)
 {
 	struct phy_device *phy;
 	int err;
 
-	phy = get_phy_device(sfp->i2c_mii, SFP_PHY_ADDR, is_c45);
+	phy = get_phy_device(sfp->i2c_mii, addr, is_c45);
 	if (phy == ERR_PTR(-ENODEV))
 		return PTR_ERR(phy);
 	if (IS_ERR(phy)) {
@@ -1714,15 +1741,15 @@ static int sfp_sm_probe_for_phy(struct sfp *sfp)
 		break;
 
 	case MDIO_I2C_MARVELL_C22:
-		err = sfp_sm_probe_phy(sfp, false);
+		err = sfp_sm_probe_phy(sfp, SFP_PHY_ADDR, false);
 		break;
 
 	case MDIO_I2C_C45:
-		err = sfp_sm_probe_phy(sfp, true);
+		err = sfp_sm_probe_phy(sfp, SFP_PHY_ADDR, true);
 		break;
 
 	case MDIO_I2C_ROLLBALL:
-		err = -EOPNOTSUPP;
+		err = sfp_sm_probe_phy(sfp, SFP_PHY_ADDR_ROLLBALL, true);
 		break;
 	}
 
@@ -2049,6 +2076,7 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 		sfp->state_hw_mask |= SFP_F_LOS;
 
 	sfp->module_t_start_up = T_START_UP;
+	sfp->module_t_wait = T_WAIT;
 
 	sfp->tx_fault_ignore = false;
 
@@ -2263,9 +2291,10 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 
 		/* We need to check the TX_FAULT state, which is not defined
 		 * while TX_DISABLE is asserted. The earliest we want to do
-		 * anything (such as probe for a PHY) is 50ms.
+		 * anything (such as probe for a PHY) is 50ms (or more on
+		 * specific modules).
 		 */
-		sfp_sm_next(sfp, SFP_S_WAIT, T_WAIT);
+		sfp_sm_next(sfp, SFP_S_WAIT, sfp->module_t_wait);
 		break;
 
 	case SFP_S_WAIT:
@@ -2279,8 +2308,8 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 			 * deasserting.
 			 */
 			timeout = sfp->module_t_start_up;
-			if (timeout > T_WAIT)
-				timeout -= T_WAIT;
+			if (timeout > sfp->module_t_wait)
+				timeout -= sfp->module_t_wait;
 			else
 				timeout = 1;
 
-- 
2.35.1

