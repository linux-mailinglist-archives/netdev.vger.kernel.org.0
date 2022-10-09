Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5875F91B7
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbiJIWkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbiJIWim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:38:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B1240E34;
        Sun,  9 Oct 2022 15:21:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9815A60CF8;
        Sun,  9 Oct 2022 22:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD67C43143;
        Sun,  9 Oct 2022 22:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354048;
        bh=UJPQOecIVFTUkiols+kZ/+I06Pn6RvkbqIrObpef9Ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NaZEZTOX7DMPeii/6zXukv8qD68MXJ/1g97wgTMbDyzUD9eft6srmhxb6WY60QfEM
         8UjPO5/gU8aL3/8HS7xXXS8Wlgv1jyCxr+cDrz2My9Xr2VWhu1fuSY+/bX1X4ta/BC
         09TFHR2HFibvEEY/c+wGv/8DTO0Nfct3lgjgna7xMNDJYDvAR+vzsBGtB4LLUwSfEm
         3TRGpM2OAEPmpNNvCUHi3RdcIe5pqtXEucWGYYvV5E10ALQTBlBaFsetEoFGMoZeAL
         YW5VGa+WrYCtnD5HRkbN+ujDttG0sfUnDDK8+Cu9sNFgH3RLlGoenjDsABN3ekq9ZV
         lD5U29pTsTopw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 31/46] net: sfp: move quirk handling into sfp.c
Date:   Sun,  9 Oct 2022 18:18:56 -0400
Message-Id: <20221009221912.1217372-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221912.1217372-1-sashal@kernel.org>
References: <20221009221912.1217372-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

[ Upstream commit 23571c7b96437483d28a990c906cc81f5f66374e ]

We need to handle more quirks than just those which affect the link
modes of the module. Move the quirk lookup into sfp.c, and pass the
quirk to sfp-bus.c

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp-bus.c | 98 ++-------------------------------------
 drivers/net/phy/sfp.c     | 94 ++++++++++++++++++++++++++++++++++++-
 drivers/net/phy/sfp.h     |  9 +++-
 3 files changed, 104 insertions(+), 97 deletions(-)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 4369d6249e7b..267182d32bd5 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -10,12 +10,6 @@
 
 #include "sfp.h"
 
-struct sfp_quirk {
-	const char *vendor;
-	const char *part;
-	void (*modes)(const struct sfp_eeprom_id *id, unsigned long *modes);
-};
-
 /**
  * struct sfp_bus - internal representation of a sfp bus
  */
@@ -38,93 +32,6 @@ struct sfp_bus {
 	bool started;
 };
 
-static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
-				unsigned long *modes)
-{
-	phylink_set(modes, 2500baseX_Full);
-}
-
-static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
-				      unsigned long *modes)
-{
-	/* Ubiquiti U-Fiber Instant module claims that support all transceiver
-	 * types including 10G Ethernet which is not truth. So clear all claimed
-	 * modes and set only one mode which module supports: 1000baseX_Full.
-	 */
-	phylink_zero(modes);
-	phylink_set(modes, 1000baseX_Full);
-}
-
-static const struct sfp_quirk sfp_quirks[] = {
-	{
-		// Alcatel Lucent G-010S-P can operate at 2500base-X, but
-		// incorrectly report 2500MBd NRZ in their EEPROM
-		.vendor = "ALCATELLUCENT",
-		.part = "G010SP",
-		.modes = sfp_quirk_2500basex,
-	}, {
-		// Alcatel Lucent G-010S-A can operate at 2500base-X, but
-		// report 3.2GBd NRZ in their EEPROM
-		.vendor = "ALCATELLUCENT",
-		.part = "3FE46541AA",
-		.modes = sfp_quirk_2500basex,
-	}, {
-		// Huawei MA5671A can operate at 2500base-X, but report 1.2GBd
-		// NRZ in their EEPROM
-		.vendor = "HUAWEI",
-		.part = "MA5671A",
-		.modes = sfp_quirk_2500basex,
-	}, {
-		// Lantech 8330-262D-E can operate at 2500base-X, but
-		// incorrectly report 2500MBd NRZ in their EEPROM
-		.vendor = "Lantech",
-		.part = "8330-262D-E",
-		.modes = sfp_quirk_2500basex,
-	}, {
-		.vendor = "UBNT",
-		.part = "UF-INSTANT",
-		.modes = sfp_quirk_ubnt_uf_instant,
-	},
-};
-
-static size_t sfp_strlen(const char *str, size_t maxlen)
-{
-	size_t size, i;
-
-	/* Trailing characters should be filled with space chars */
-	for (i = 0, size = 0; i < maxlen; i++)
-		if (str[i] != ' ')
-			size = i + 1;
-
-	return size;
-}
-
-static bool sfp_match(const char *qs, const char *str, size_t len)
-{
-	if (!qs)
-		return true;
-	if (strlen(qs) != len)
-		return false;
-	return !strncmp(qs, str, len);
-}
-
-static const struct sfp_quirk *sfp_lookup_quirk(const struct sfp_eeprom_id *id)
-{
-	const struct sfp_quirk *q;
-	unsigned int i;
-	size_t vs, ps;
-
-	vs = sfp_strlen(id->base.vendor_name, ARRAY_SIZE(id->base.vendor_name));
-	ps = sfp_strlen(id->base.vendor_pn, ARRAY_SIZE(id->base.vendor_pn));
-
-	for (i = 0, q = sfp_quirks; i < ARRAY_SIZE(sfp_quirks); i++, q++)
-		if (sfp_match(q->vendor, id->base.vendor_name, vs) &&
-		    sfp_match(q->part, id->base.vendor_pn, ps))
-			return q;
-
-	return NULL;
-}
-
 /**
  * sfp_parse_port() - Parse the EEPROM base ID, setting the port type
  * @bus: a pointer to the &struct sfp_bus structure for the sfp module
@@ -786,12 +693,13 @@ void sfp_link_down(struct sfp_bus *bus)
 }
 EXPORT_SYMBOL_GPL(sfp_link_down);
 
-int sfp_module_insert(struct sfp_bus *bus, const struct sfp_eeprom_id *id)
+int sfp_module_insert(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
+		      const struct sfp_quirk *quirk)
 {
 	const struct sfp_upstream_ops *ops = sfp_get_upstream_ops(bus);
 	int ret = 0;
 
-	bus->sfp_quirk = sfp_lookup_quirk(id);
+	bus->sfp_quirk = quirk;
 
 	if (ops && ops->module_insert)
 		ret = ops->module_insert(bus->upstream, id);
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index e5cbd5b117cc..4ba61f16ceb6 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -253,6 +253,8 @@ struct sfp {
 	unsigned int module_t_start_up;
 	bool tx_fault_ignore;
 
+	const struct sfp_quirk *quirk;
+
 #if IS_ENABLED(CONFIG_HWMON)
 	struct sfp_diag diag;
 	struct delayed_work hwmon_probe;
@@ -309,6 +311,93 @@ static const struct of_device_id sfp_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, sfp_of_match);
 
+static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
+				unsigned long *modes)
+{
+	linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseX_Full_BIT, modes);
+}
+
+static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
+				      unsigned long *modes)
+{
+	/* Ubiquiti U-Fiber Instant module claims that support all transceiver
+	 * types including 10G Ethernet which is not truth. So clear all claimed
+	 * modes and set only one mode which module supports: 1000baseX_Full.
+	 */
+	linkmode_zero(modes);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT, modes);
+}
+
+static const struct sfp_quirk sfp_quirks[] = {
+	{
+		// Alcatel Lucent G-010S-P can operate at 2500base-X, but
+		// incorrectly report 2500MBd NRZ in their EEPROM
+		.vendor = "ALCATELLUCENT",
+		.part = "G010SP",
+		.modes = sfp_quirk_2500basex,
+	}, {
+		// Alcatel Lucent G-010S-A can operate at 2500base-X, but
+		// report 3.2GBd NRZ in their EEPROM
+		.vendor = "ALCATELLUCENT",
+		.part = "3FE46541AA",
+		.modes = sfp_quirk_2500basex,
+	}, {
+		// Huawei MA5671A can operate at 2500base-X, but report 1.2GBd
+		// NRZ in their EEPROM
+		.vendor = "HUAWEI",
+		.part = "MA5671A",
+		.modes = sfp_quirk_2500basex,
+	}, {
+		// Lantech 8330-262D-E can operate at 2500base-X, but
+		// incorrectly report 2500MBd NRZ in their EEPROM
+		.vendor = "Lantech",
+		.part = "8330-262D-E",
+		.modes = sfp_quirk_2500basex,
+	}, {
+		.vendor = "UBNT",
+		.part = "UF-INSTANT",
+		.modes = sfp_quirk_ubnt_uf_instant,
+	},
+};
+
+static size_t sfp_strlen(const char *str, size_t maxlen)
+{
+	size_t size, i;
+
+	/* Trailing characters should be filled with space chars */
+	for (i = 0, size = 0; i < maxlen; i++)
+		if (str[i] != ' ')
+			size = i + 1;
+
+	return size;
+}
+
+static bool sfp_match(const char *qs, const char *str, size_t len)
+{
+	if (!qs)
+		return true;
+	if (strlen(qs) != len)
+		return false;
+	return !strncmp(qs, str, len);
+}
+
+static const struct sfp_quirk *sfp_lookup_quirk(const struct sfp_eeprom_id *id)
+{
+	const struct sfp_quirk *q;
+	unsigned int i;
+	size_t vs, ps;
+
+	vs = sfp_strlen(id->base.vendor_name, ARRAY_SIZE(id->base.vendor_name));
+	ps = sfp_strlen(id->base.vendor_pn, ARRAY_SIZE(id->base.vendor_pn));
+
+	for (i = 0, q = sfp_quirks; i < ARRAY_SIZE(sfp_quirks); i++, q++)
+		if (sfp_match(q->vendor, id->base.vendor_name, vs) &&
+		    sfp_match(q->part, id->base.vendor_pn, ps))
+			return q;
+
+	return NULL;
+}
+
 static unsigned long poll_jiffies;
 
 static unsigned int sfp_gpio_get_state(struct sfp *sfp)
@@ -1964,6 +2053,8 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	else
 		sfp->tx_fault_ignore = false;
 
+	sfp->quirk = sfp_lookup_quirk(&id);
+
 	return 0;
 }
 
@@ -2075,7 +2166,8 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 			break;
 
 		/* Report the module insertion to the upstream device */
-		err = sfp_module_insert(sfp->sfp_bus, &sfp->id);
+		err = sfp_module_insert(sfp->sfp_bus, &sfp->id,
+					sfp->quirk);
 		if (err < 0) {
 			sfp_sm_mod_next(sfp, SFP_MOD_ERROR, 0);
 			break;
diff --git a/drivers/net/phy/sfp.h b/drivers/net/phy/sfp.h
index 27226535c72b..03f1d47fe6ca 100644
--- a/drivers/net/phy/sfp.h
+++ b/drivers/net/phy/sfp.h
@@ -6,6 +6,12 @@
 
 struct sfp;
 
+struct sfp_quirk {
+	const char *vendor;
+	const char *part;
+	void (*modes)(const struct sfp_eeprom_id *id, unsigned long *modes);
+};
+
 struct sfp_socket_ops {
 	void (*attach)(struct sfp *sfp);
 	void (*detach)(struct sfp *sfp);
@@ -23,7 +29,8 @@ int sfp_add_phy(struct sfp_bus *bus, struct phy_device *phydev);
 void sfp_remove_phy(struct sfp_bus *bus);
 void sfp_link_up(struct sfp_bus *bus);
 void sfp_link_down(struct sfp_bus *bus);
-int sfp_module_insert(struct sfp_bus *bus, const struct sfp_eeprom_id *id);
+int sfp_module_insert(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
+		      const struct sfp_quirk *quirk);
 void sfp_module_remove(struct sfp_bus *bus);
 int sfp_module_start(struct sfp_bus *bus);
 void sfp_module_stop(struct sfp_bus *bus);
-- 
2.35.1

