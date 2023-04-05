Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 412A96D7850
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237711AbjDEJav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237735AbjDEJaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:30:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2BDC3
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:29:45 -0700 (PDT)
Received: from dude02.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::28])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <m.felsch@pengutronix.de>)
        id 1pjzQ4-0004pA-KC; Wed, 05 Apr 2023 11:27:08 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
Date:   Wed, 05 Apr 2023 11:26:57 +0200
Subject: [PATCH 06/12] net: phy: add phy_device_atomic_register helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230405-net-next-topic-net-phy-reset-v1-6-7e5329f08002@pengutronix.de>
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
In-Reply-To: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
X-Mailer: b4 0.12.1
X-SA-Exim-Connect-IP: 2a0a:edc0:0:1101:1d::28
X-SA-Exim-Mail-From: m.felsch@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the usually way to probe and setup a phy is done via:
 1) get_phy_device()/phy_device_create()
 2) phy_device_register.

During get_phy_device() the PHYID1/2 registers are read which assumes
that the phy is already accessible. This is not always the case, e.g.
 - if the pre-running firmware did not initialize the phy or
 - if the kernel does gate important clocks while booting and the phy
   isn't accessible after the pre-running firmware anymore.

To fix this we need to:
 - parse the phy's fwnode first,
 - do some basic setup like: bring it out of the reset state and
 - finally read the PHYID1/2 registers to probe the correct driver

This patch adds a new helper called phy_device_atomic_register() to not
break exisiting running systems based on the current mdio/phy handling.
This new helper bundles all required steps into a single function to
make it easier for driver developers.

To bundle the phy firmware parsing step within phx_device.c the commit
copies the required code from fwnode_mdio.c. After we converterd all
callers of fwnode_mdiobus_* to this new API we can remove the support
from fwnode_mdio.c.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/net/phy/phy_device.c | 208 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          |   9 ++
 2 files changed, 217 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 7e4b3b3caba9..a784ac06e6a9 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3124,6 +3124,214 @@ struct fwnode_handle *fwnode_get_phy_node(const struct fwnode_handle *fwnode)
 }
 EXPORT_SYMBOL_GPL(fwnode_get_phy_node);
 
+static int fwnode_setup_phy_irq(struct phy_device *phydev, struct mii_bus *bus,
+				struct fwnode_handle *fwnode)
+{
+	u32 addr = phydev->mdio.addr;
+	int ret;
+
+	if (is_acpi_node(fwnode)) {
+		phydev->irq = bus->irq[addr];
+		return 0;
+	}
+
+	/* of_node */
+	ret = fwnode_irq_get(fwnode, 0);
+	/* Don't wait forever if the IRQ provider doesn't become available,
+	 * just fall back to poll mode
+	 */
+	if (ret == -EPROBE_DEFER)
+		ret = driver_deferred_probe_check_state(&phydev->mdio.dev);
+	if (ret == -EPROBE_DEFER)
+		return ret;
+
+	if (ret > 0) {
+		phydev->irq = ret;
+		bus->irq[addr] = ret;
+	} else {
+		phydev->irq = bus->irq[addr];
+	}
+
+	return 0;
+}
+
+static struct pse_control *
+fwnode_find_pse_control(struct fwnode_handle *fwnode)
+{
+	struct pse_control *psec;
+	struct device_node *np;
+
+	if (!IS_ENABLED(CONFIG_PSE_CONTROLLER))
+		return NULL;
+
+	np = to_of_node(fwnode);
+	if (!np)
+		return NULL;
+
+	psec = of_pse_control_get(np);
+	if (PTR_ERR(psec) == -ENOENT)
+		return NULL;
+
+	return psec;
+}
+
+static struct mii_timestamper *
+fwnode_find_mii_timestamper(struct fwnode_handle *fwnode)
+{
+	struct of_phandle_args arg;
+	int err;
+
+	if (is_acpi_node(fwnode))
+		return NULL;
+
+	err = of_parse_phandle_with_fixed_args(to_of_node(fwnode),
+					       "timestamper", 1, 0, &arg);
+	if (err == -ENOENT)
+		return NULL;
+	else if (err)
+		return ERR_PTR(err);
+
+	if (arg.args_count != 1)
+		return ERR_PTR(-EINVAL);
+
+	return register_mii_timestamper(arg.np, arg.args[0]);
+}
+
+static int
+phy_device_parse_fwnode(struct phy_device *phydev,
+			struct phy_device_config *config)
+{
+	struct fwnode_handle *fwnode = config->fwnode;
+	struct mii_bus *bus = config->mii_bus;
+	u32 addr = phydev->mdio.addr;
+	int ret;
+
+	if (!fwnode)
+		return 0;
+
+	if (!is_acpi_node(fwnode) && !is_of_node(fwnode))
+		return 0;
+
+	ret = fwnode_setup_phy_irq(phydev, bus, fwnode);
+	if (ret)
+		return ret;
+
+	ret = fwnode_property_match_string(fwnode, "compatible",
+					   "ethernet-phy-ieee802.3-c45");
+	if (ret >= 0)
+		config->is_c45 = true;
+
+	if (fwnode_property_read_bool(fwnode, "broken-turn-around"))
+		bus->phy_ignore_ta_mask |= 1 << addr;
+	fwnode_property_read_u32(fwnode, "reset-assert-us",
+				 &phydev->mdio.reset_assert_delay);
+	fwnode_property_read_u32(fwnode, "reset-deassert-us",
+				 &phydev->mdio.reset_deassert_delay);
+
+	fwnode_handle_get(fwnode);
+	if (is_acpi_node(fwnode))
+		phydev->mdio.dev.fwnode = fwnode;
+	else if (is_of_node(fwnode))
+		device_set_node(&phydev->mdio.dev, fwnode);
+
+	phydev->psec = fwnode_find_pse_control(fwnode);
+	if (IS_ERR(phydev->psec)) {
+		ret = PTR_ERR(phydev->psec);
+		goto put_fwnode;
+	}
+
+	/* A mii_timestamper probed via the device tree will have precedence. */
+	phydev->mii_ts = fwnode_find_mii_timestamper(fwnode);
+	if (IS_ERR(phydev->mii_ts)) {
+		ret = PTR_ERR(phydev->mii_ts);
+		goto put_pse;
+	}
+
+	return 0;
+
+put_pse:
+	pse_control_put(phydev->psec);
+put_fwnode:
+	fwnode_handle_put(phydev->mdio.dev.fwnode);
+
+	return ret;
+}
+
+/**
+ * phy_device_atomic_register - Setup, init and register a PHY on the MDIO bus
+ * @config: The PHY config
+ *
+ * Probe, initialise and register a PHY at @addr on @bus.
+ *
+ * Returns an allocated and registered &struct phy_device on success.
+ */
+struct phy_device *phy_device_atomic_register(struct phy_device_config *config)
+{
+	struct phy_c45_device_ids *c45_ids = &config->c45_ids;
+	struct phy_device *phydev;
+	int err;
+
+	phydev = phy_device_alloc(config);
+	if (IS_ERR(phydev))
+		return ERR_CAST(phydev);
+
+	err = phy_device_parse_fwnode(phydev, config);
+	if (err) {
+		phydev_err(phydev, "failed to parse fwnode\n");
+		goto err_free_phydev;
+	}
+
+	err = mdiobus_register_device(&phydev->mdio);
+	if (err) {
+		phydev_err(phydev, "pre-init step failed\n");
+		goto err_free_fwnode;
+	}
+
+	phy_device_reset(phydev, 0);
+
+	memset(c45_ids->device_ids, 0xff, sizeof(c45_ids->device_ids));
+
+	err = phy_device_detect(config);
+	if (err) {
+		phydev_err(phydev, "failed to query the phyid\n");
+		goto err_unregister_mdiodev;
+	}
+
+	err = phy_device_init(phydev, config);
+	if (err) {
+		phydev_err(phydev, "failed to initialize\n");
+		goto err_unregister_mdiodev;
+	}
+
+	err = phy_scan_fixups(phydev);
+	if (err) {
+		phydev_err(phydev, "failed to apply fixups\n");
+		goto err_unregister_mdiodev;
+	}
+
+	err = device_add(&phydev->mdio.dev);
+	if (err) {
+		phydev_err(phydev, "failed to add\n");
+		goto err_out;
+	}
+
+	return 0;
+
+err_out:
+	phy_device_reset(phydev, 1);
+err_unregister_mdiodev:
+	mdiobus_unregister_device(&phydev->mdio);
+err_free_fwnode:
+	unregister_mii_timestamper(phydev->mii_ts);
+	pse_control_put(phydev->psec);
+	fwnode_handle_put(phydev->mdio.dev.fwnode);
+err_free_phydev:
+	kfree(phydev);
+
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL(phy_device_atomic_register);
+
 /**
  * phy_probe - probe and init a PHY device
  * @dev: device to probe and init
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 0f0cb72a08ab..bdf6d27faefb 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -761,6 +761,7 @@ static inline struct phy_device *to_phy_device(const struct device *dev)
  *
  * @mii_bus: The target MII bus the PHY is connected to
  * @phy_addr: PHY address on the MII bus
+ * @fwnode: The PHY firmware handle
  * @phy_id: UID for this device found during discovery
  * @c45_ids: 802.3-c45 Device Identifiers if is_c45.
  * @is_c45: If true the PHY uses the 802.3 clause 45 protocol
@@ -774,6 +775,7 @@ static inline struct phy_device *to_phy_device(const struct device *dev)
 struct phy_device_config {
 	struct mii_bus *mii_bus;
 	int phy_addr;
+	struct fwnode_handle *fwnode;
 	u32 phy_id;
 	struct phy_c45_device_ids c45_ids;
 	bool is_c45;
@@ -1573,6 +1575,7 @@ struct phy_device *device_phy_find_device(struct device *dev);
 struct fwnode_handle *fwnode_get_phy_node(const struct fwnode_handle *fwnode);
 struct phy_device *get_phy_device(struct phy_device_config *config);
 int phy_device_register(struct phy_device *phy);
+struct phy_device *phy_device_atomic_register(struct phy_device_config *config);
 void phy_device_free(struct phy_device *phydev);
 #else
 static inline int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
@@ -1613,6 +1616,12 @@ static inline int phy_device_register(struct phy_device *phy)
 	return 0;
 }
 
+static inline
+struct phy_device *phy_device_atomic_register(struct phy_device_config *config)
+{
+	return NULL;
+}
+
 static inline void phy_device_free(struct phy_device *phydev) { }
 #endif /* CONFIG_PHYLIB */
 void phy_device_remove(struct phy_device *phydev);

-- 
2.39.2

