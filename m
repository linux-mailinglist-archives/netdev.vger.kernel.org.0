Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011755A3C41
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 08:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbiH1Gat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 02:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbiH1Gan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 02:30:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E711D32AA1
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 23:30:40 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oSBoQ-0003bn-1r; Sun, 28 Aug 2022 08:30:26 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oSBoP-002QZu-8M; Sun, 28 Aug 2022 08:30:25 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oSBoN-00GdB5-5b; Sun, 28 Aug 2022 08:30:23 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH net-next v4 2/7] net: add framework to support Ethernet PSE and PDs devices
Date:   Sun, 28 Aug 2022 08:30:16 +0200
Message-Id: <20220828063021.3963761-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220828063021.3963761-1-o.rempel@pengutronix.de>
References: <20220828063021.3963761-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This framework was create with intention to provide support for Ethernet PSE
(Power Sourcing Equipment) and PDs (Powered Device).

At current step this patch implements generic PSE support for PoDL (Power over
Data Lines 802.3bu) specification with reserving name space for PD devices as
well.

This framework can be extended to support 802.3af and 802.3at "Power via the
Media Dependent Interface" (or PoE/Power over Ethernet)

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
changes v4:
- add Reviewed-by: Andrew Lunn
changes v2:
- remove ethtool interface support from this patch
---
 drivers/net/Kconfig           |   2 +
 drivers/net/Makefile          |   1 +
 drivers/net/pse-pd/Kconfig    |  11 ++
 drivers/net/pse-pd/Makefile   |   4 +
 drivers/net/pse-pd/pse_core.c | 294 ++++++++++++++++++++++++++++++++++
 include/linux/pse-pd/pse.h    |  93 +++++++++++
 6 files changed, 405 insertions(+)
 create mode 100644 drivers/net/pse-pd/Kconfig
 create mode 100644 drivers/net/pse-pd/Makefile
 create mode 100644 drivers/net/pse-pd/pse_core.c
 create mode 100644 include/linux/pse-pd/pse.h

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 94c889802566a..15d4a38b1351d 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -500,6 +500,8 @@ config NET_SB1000
 
 source "drivers/net/phy/Kconfig"
 
+source "drivers/net/pse-pd/Kconfig"
+
 source "drivers/net/can/Kconfig"
 
 source "drivers/net/mctp/Kconfig"
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 3f1192d3c52d3..6ce076462dbfd 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_NET) += loopback.o
 obj-$(CONFIG_NETDEV_LEGACY_INIT) += Space.o
 obj-$(CONFIG_NETCONSOLE) += netconsole.o
 obj-y += phy/
+obj-y += pse-pd/
 obj-y += mdio/
 obj-y += pcs/
 obj-$(CONFIG_RIONET) += rionet.o
diff --git a/drivers/net/pse-pd/Kconfig b/drivers/net/pse-pd/Kconfig
new file mode 100644
index 0000000000000..49c7f0bcff526
--- /dev/null
+++ b/drivers/net/pse-pd/Kconfig
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Ethernet Power Sourcing Equipment drivers
+#
+
+menuconfig PSE_CONTROLLER
+	bool "Ethernet Power Sourcing Equipment Support"
+	help
+	  Generic Power Sourcing Equipment Controller support.
+
+	  If unsure, say no.
diff --git a/drivers/net/pse-pd/Makefile b/drivers/net/pse-pd/Makefile
new file mode 100644
index 0000000000000..cfa780c7801dd
--- /dev/null
+++ b/drivers/net/pse-pd/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0-only
+# Makefile for Linux PSE drivers
+
+obj-$(CONFIG_PSE_CONTROLLER) += pse_core.o
diff --git a/drivers/net/pse-pd/pse_core.c b/drivers/net/pse-pd/pse_core.c
new file mode 100644
index 0000000000000..7bf3acc721c0a
--- /dev/null
+++ b/drivers/net/pse-pd/pse_core.c
@@ -0,0 +1,294 @@
+// SPDX-License-Identifier: GPL-2.0-only
+//
+// Framework for Ethernet Power Sourcing Equipment
+//
+// Copyright (c) 2022 Pengutronix, Oleksij Rempel <kernel@pengutronix.de>
+//
+
+#include <linux/device.h>
+#include <linux/of.h>
+#include <linux/pse-pd/pse.h>
+
+static DEFINE_MUTEX(pse_list_mutex);
+static LIST_HEAD(pse_controller_list);
+
+/**
+ * struct pse_control - a PSE control
+ * @pcdev: a pointer to the PSE controller device
+ *         this PSE control belongs to
+ * @list: list entry for the pcdev's PSE controller list
+ * @id: ID of the PSE line in the PSE controller device
+ * @refcnt: Number of gets of this pse_control
+ */
+struct pse_control {
+	struct pse_controller_dev *pcdev;
+	struct list_head list;
+	unsigned int id;
+	struct kref refcnt;
+};
+
+/**
+ * of_pse_zero_xlate - dummy function for controllers with one only control
+ * @pcdev: a pointer to the PSE controller device
+ * @pse_spec: PSE line specifier as found in the device tree
+ *
+ * This static translation function is used by default if of_xlate in
+ * :c:type:`pse_controller_dev` is not set. It is useful for all PSE
+ * controllers with #pse-cells = <0>.
+ */
+static int of_pse_zero_xlate(struct pse_controller_dev *pcdev,
+			     const struct of_phandle_args *pse_spec)
+{
+	return 0;
+}
+
+/**
+ * of_pse_simple_xlate - translate pse_spec to the PSE line number
+ * @pcdev: a pointer to the PSE controller device
+ * @pse_spec: PSE line specifier as found in the device tree
+ *
+ * This static translation function is used by default if of_xlate in
+ * :c:type:`pse_controller_dev` is not set. It is useful for all PSE
+ * controllers with 1:1 mapping, where PSE lines can be indexed by number
+ * without gaps.
+ */
+static int of_pse_simple_xlate(struct pse_controller_dev *pcdev,
+			       const struct of_phandle_args *pse_spec)
+{
+	if (pse_spec->args[0] >= pcdev->nr_lines)
+		return -EINVAL;
+
+	return pse_spec->args[0];
+}
+
+/**
+ * pse_controller_register - register a PSE controller device
+ * @pcdev: a pointer to the initialized PSE controller device
+ */
+int pse_controller_register(struct pse_controller_dev *pcdev)
+{
+	if (!pcdev->of_xlate) {
+		if (pcdev->of_pse_n_cells == 0)
+			pcdev->of_xlate = of_pse_zero_xlate;
+		else if (pcdev->of_pse_n_cells == 1)
+			pcdev->of_xlate = of_pse_simple_xlate;
+	}
+
+	mutex_init(&pcdev->lock);
+	INIT_LIST_HEAD(&pcdev->pse_control_head);
+
+	mutex_lock(&pse_list_mutex);
+	list_add(&pcdev->list, &pse_controller_list);
+	mutex_unlock(&pse_list_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pse_controller_register);
+
+/**
+ * pse_controller_unregister - unregister a PSE controller device
+ * @pcdev: a pointer to the PSE controller device
+ */
+void pse_controller_unregister(struct pse_controller_dev *pcdev)
+{
+	mutex_lock(&pse_list_mutex);
+	list_del(&pcdev->list);
+	mutex_unlock(&pse_list_mutex);
+}
+EXPORT_SYMBOL_GPL(pse_controller_unregister);
+
+static void devm_pse_controller_release(struct device *dev, void *res)
+{
+	pse_controller_unregister(*(struct pse_controller_dev **)res);
+}
+
+/**
+ * devm_pse_controller_register - resource managed pse_controller_register()
+ * @dev: device that is registering this PSE controller
+ * @pcdev: a pointer to the initialized PSE controller device
+ *
+ * Managed pse_controller_register(). For PSE controllers registered by
+ * this function, pse_controller_unregister() is automatically called on
+ * driver detach. See pse_controller_register() for more information.
+ */
+int devm_pse_controller_register(struct device *dev,
+				 struct pse_controller_dev *pcdev)
+{
+	struct pse_controller_dev **pcdevp;
+	int ret;
+
+	pcdevp = devres_alloc(devm_pse_controller_release, sizeof(*pcdevp),
+			      GFP_KERNEL);
+	if (!pcdevp)
+		return -ENOMEM;
+
+	ret = pse_controller_register(pcdev);
+	if (ret) {
+		devres_free(pcdevp);
+		return ret;
+	}
+
+	*pcdevp = pcdev;
+	devres_add(dev, pcdevp);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devm_pse_controller_register);
+
+/* PSE control section */
+
+static void __pse_control_release(struct kref *kref)
+{
+	struct pse_control *psec = container_of(kref, struct pse_control,
+						  refcnt);
+
+	lockdep_assert_held(&pse_list_mutex);
+
+	module_put(psec->pcdev->owner);
+
+	list_del(&psec->list);
+	kfree(psec);
+}
+
+static void __pse_control_put_internal(struct pse_control *psec)
+{
+	lockdep_assert_held(&pse_list_mutex);
+
+	kref_put(&psec->refcnt, __pse_control_release);
+}
+
+/**
+ * pse_control_put - free the PSE control
+ * @psec: PSE control pointer
+ */
+void pse_control_put(struct pse_control *psec)
+{
+	if (IS_ERR_OR_NULL(psec))
+		return;
+
+	mutex_lock(&pse_list_mutex);
+	__pse_control_put_internal(psec);
+	mutex_unlock(&pse_list_mutex);
+}
+EXPORT_SYMBOL_GPL(pse_control_put);
+
+static struct pse_control *
+pse_control_get_internal(struct pse_controller_dev *pcdev, unsigned int index)
+{
+	struct pse_control *psec;
+
+	lockdep_assert_held(&pse_list_mutex);
+
+	list_for_each_entry(psec, &pcdev->pse_control_head, list) {
+		if (psec->id == index) {
+			kref_get(&psec->refcnt);
+			return psec;
+		}
+	}
+
+	psec = kzalloc(sizeof(*psec), GFP_KERNEL);
+	if (!psec)
+		return ERR_PTR(-ENOMEM);
+
+	if (!try_module_get(pcdev->owner)) {
+		kfree(psec);
+		return ERR_PTR(-ENODEV);
+	}
+
+	psec->pcdev = pcdev;
+	list_add(&psec->list, &pcdev->pse_control_head);
+	psec->id = index;
+	kref_init(&psec->refcnt);
+
+	return psec;
+}
+
+struct pse_control *
+of_pse_control_get(struct device_node *node)
+{
+	struct pse_controller_dev *r, *pcdev;
+	struct of_phandle_args args;
+	struct pse_control *psec;
+	int psec_id;
+	int ret;
+
+	if (!node)
+		return ERR_PTR(-EINVAL);
+
+	ret = of_parse_phandle_with_args(node, "ieee802.3-pse",
+					 "#pse-cells", 0, &args);
+	if (ret)
+		return ERR_PTR(ret);
+
+	mutex_lock(&pse_list_mutex);
+	pcdev = NULL;
+	list_for_each_entry(r, &pse_controller_list, list) {
+		if (args.np == r->dev->of_node) {
+			pcdev = r;
+			break;
+		}
+	}
+
+	if (!pcdev) {
+		psec = ERR_PTR(-EPROBE_DEFER);
+		goto out;
+	}
+
+	if (WARN_ON(args.args_count != pcdev->of_pse_n_cells)) {
+		psec = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
+	psec_id = pcdev->of_xlate(pcdev, &args);
+	if (psec_id < 0) {
+		psec = ERR_PTR(psec_id);
+		goto out;
+	}
+
+	/* pse_list_mutex also protects the pcdev's pse_control list */
+	psec = pse_control_get_internal(pcdev, psec_id);
+
+out:
+	mutex_unlock(&pse_list_mutex);
+	of_node_put(args.np);
+
+	return psec;
+}
+EXPORT_SYMBOL_GPL(of_pse_control_get);
+
+struct pse_control *pse_control_get(struct device *dev)
+{
+	if (!dev->of_node)
+		return ERR_PTR(-ENODEV);
+
+	return of_pse_control_get(dev->of_node);
+}
+EXPORT_SYMBOL_GPL(pse_control_get);
+
+static void devm_pse_control_release(struct device *dev, void *res)
+{
+	pse_control_put(*(struct pse_control **)res);
+}
+
+struct pse_control *
+devm_pse_control_get(struct device *dev)
+{
+	struct pse_control **ptr, *psec;
+
+	ptr = devres_alloc(devm_pse_control_release, sizeof(*ptr),
+			   GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	psec = pse_control_get(dev);
+	if (IS_ERR_OR_NULL(psec)) {
+		devres_free(ptr);
+		return psec;
+	}
+
+	*ptr = psec;
+	devres_add(dev, ptr);
+
+	return psec;
+}
+EXPORT_SYMBOL_GPL(devm_pse_control_get);
diff --git a/include/linux/pse-pd/pse.h b/include/linux/pse-pd/pse.h
new file mode 100644
index 0000000000000..8bf84288db418
--- /dev/null
+++ b/include/linux/pse-pd/pse.h
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+// Copyright (c) 2022 Pengutronix, Oleksij Rempel <kernel@pengutronix.de>
+ */
+#ifndef _LINUX_PSE_CONTROLLER_H
+#define _LINUX_PSE_CONTROLLER_H
+
+#include <linux/ethtool.h>
+#include <linux/list.h>
+#include <uapi/linux/ethtool.h>
+
+struct module;
+struct device_node;
+struct of_phandle_args;
+struct pse_control;
+
+/**
+ * struct pse_controller_dev - PSE controller entity that might
+ *                             provide multiple PSE controls
+ * @ops: a pointer to device specific struct pse_controller_ops
+ * @owner: kernel module of the PSE controller driver
+ * @list: internal list of PSE controller devices
+ * @pse_control_head: head of internal list of requested PSE controls
+ * @dev: corresponding driver model device struct
+ * @of_pse_n_cells: number of cells in PSE line specifiers
+ * @of_xlate: translation function to translate from specifier as found in the
+ *            device tree to id as given to the PSE control ops
+ * @nr_lines: number of PSE controls in this controller device
+ */
+struct pse_controller_dev {
+	const struct pse_controller_ops *ops;
+	struct module *owner;
+	struct list_head list;
+	struct list_head pse_control_head;
+	struct device *dev;
+	int of_pse_n_cells;
+	int (*of_xlate)(struct pse_controller_dev *pcdev,
+			const struct of_phandle_args *pse_spec);
+	unsigned int nr_lines;
+	struct mutex lock;
+};
+
+#if IS_ENABLED(CONFIG_PSE_CONTROLLER)
+int pse_controller_register(struct pse_controller_dev *pcdev);
+void pse_controller_unregister(struct pse_controller_dev *pcdev);
+struct device;
+int devm_pse_controller_register(struct device *dev,
+				 struct pse_controller_dev *pcdev);
+
+struct pse_control *pse_control_get(struct device *dev);
+struct pse_control *devm_pse_control_get( struct device *dev);
+struct pse_control *of_pse_control_get(struct device_node *node);
+void pse_control_put(struct pse_control *psec);
+
+#else
+
+static inline int pse_controller_register(struct pse_controller_dev *pcdev)
+{
+	return -ENOTSUPP;
+}
+
+static inline void pse_controller_unregister(struct pse_controller_dev *pcdev)
+{
+}
+
+static inline int devm_pse_controller_register(struct device *dev,
+						 struct pse_controller_dev *pcdev)
+{
+	return -ENOTSUPP;
+}
+
+static inline struct pse_control *pse_control_get(struct device *dev)
+{
+	return ERR_PTR(-ENOTSUPP);
+}
+
+static inline struct pse_control *devm_pse_control_get( struct device *dev)
+{
+	return ERR_PTR(-ENOTSUPP);
+}
+
+static inline struct pse_control *of_pse_control_get(struct device_node *node)
+{
+	return ERR_PTR(-ENOTSUPP);
+}
+
+static inline void pse_control_put(struct pse_control *psec)
+{
+}
+
+#endif
+
+#endif
-- 
2.30.2

