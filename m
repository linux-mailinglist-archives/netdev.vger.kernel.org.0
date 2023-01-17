Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67FA266E618
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 19:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbjAQSeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 13:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbjAQSbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 13:31:39 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563BF3CE2C;
        Tue, 17 Jan 2023 10:01:38 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30HG6Dck031445;
        Tue, 17 Jan 2023 10:01:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=hPvJtkj+Ph7k7qMoeteLV8y4LskXnHIWGWIDFAPLc9A=;
 b=nLAGNe9WmhPlPFnoKo2lOx6bqEiOySox48fQgRdeq2q/1ju/bnfGYmyHZuhinYs8u1WQ
 3hom9UnHaG54iYHPHKque+xynUAET0026vmyeVBX9TQKDN8rDbxNpy6KU6a1gXyV1TDk
 nrPKhVhkyIHUf+JynOJpGhmaUGxX1CZbjaMNFDIru3LFrAZhcHE3fNQGeg7Hnai0fDXJ
 QAcc/tv1SvNRkgIgxfKxiEDHg4H+VrMkSoPnWnfwCWZSZjeJkm7a+I65CXu6rWL9L2o4
 hzh+XC+YGE69sfVTCQOa9a79HA1Tq2gdCd/oY/kW/UnJwfjuMr+BfsEjF7/2XZLrdLfK mw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3n58dke2hp-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Jan 2023 10:01:13 -0800
Received: from devvm1736.cln0.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server id
 15.1.2375.34; Tue, 17 Jan 2023 10:01:09 -0800
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        "Arkadiusz Kubalewski" <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Vadim Fedorenko <vadfed@meta.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-clk@vger.kernel.org>,
        "Milena Olech" <milena.olech@intel.com>,
        Michal Michalik <michal.michalik@intel.com>
Subject: [RFC PATCH v5 1/4] dpll: Add DPLL framework base functions
Date:   Tue, 17 Jan 2023 10:00:48 -0800
Message-ID: <20230117180051.2983639-2-vadfed@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230117180051.2983639-1-vadfed@meta.com>
References: <20230117180051.2983639-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:108::8]
X-Proofpoint-GUID: 58LujJZvpcvF42v5TZGRO3wawk01Aeuc
X-Proofpoint-ORIG-GUID: 58LujJZvpcvF42v5TZGRO3wawk01Aeuc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_09,2023-01-17_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DPLL framework is used to represent and configure DPLL devices
in systems. Each device that has DPLL and can configure sources
and outputs can use this framework. Netlink interface is used to
provide configuration data and to receive notification messages
about changes in the configuration or status of DPLL device.
Inputs and outputs of the DPLL device are represented as special
objects which could be dynamically added to and removed from DPLL
device.

Co-developed-by: Milena Olech <milena.olech@intel.com>
Signed-off-by: Milena Olech <milena.olech@intel.com>
Co-developed-by: Michal Michalik <michal.michalik@intel.com>
Signed-off-by: Michal Michalik <michal.michalik@intel.com>
Co-developed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
---
 MAINTAINERS                 |    8 +
 drivers/Kconfig             |    2 +
 drivers/Makefile            |    1 +
 drivers/dpll/Kconfig        |    7 +
 drivers/dpll/Makefile       |    9 +
 drivers/dpll/dpll_core.c    | 1010 +++++++++++++++++++++++++++++++++++
 drivers/dpll/dpll_core.h    |  105 ++++
 drivers/dpll/dpll_netlink.c |  883 ++++++++++++++++++++++++++++++
 drivers/dpll/dpll_netlink.h |   24 +
 include/linux/dpll.h        |  282 ++++++++++
 include/uapi/linux/dpll.h   |  294 ++++++++++
 11 files changed, 2625 insertions(+)
 create mode 100644 drivers/dpll/Kconfig
 create mode 100644 drivers/dpll/Makefile
 create mode 100644 drivers/dpll/dpll_core.c
 create mode 100644 drivers/dpll/dpll_core.h
 create mode 100644 drivers/dpll/dpll_netlink.c
 create mode 100644 drivers/dpll/dpll_netlink.h
 create mode 100644 include/linux/dpll.h
 create mode 100644 include/uapi/linux/dpll.h

diff --git a/MAINTAINERS b/MAINTAINERS
index f82dd8d43c2b..de8a10b21ce8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6411,6 +6411,14 @@ F:	Documentation/networking/device_drivers/ethernet/freescale/dpaa2/switch-drive
 F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-switch*
 F:	drivers/net/ethernet/freescale/dpaa2/dpsw*
 
+DPLL CLOCK SUBSYSTEM
+M:	Vadim Fedorenko <vadfed@fb.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/dpll/*
+F:	include/net/dpll.h
+F:	include/uapi/linux/dpll.h
+
 DRBD DRIVER
 M:	Philipp Reisner <philipp.reisner@linbit.com>
 M:	Lars Ellenberg <lars.ellenberg@linbit.com>
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 968bd0a6fd78..453df9e1210d 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -241,4 +241,6 @@ source "drivers/peci/Kconfig"
 
 source "drivers/hte/Kconfig"
 
+source "drivers/dpll/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index bdf1c66141c9..7cbee58bc692 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -189,3 +189,4 @@ obj-$(CONFIG_COUNTER)		+= counter/
 obj-$(CONFIG_MOST)		+= most/
 obj-$(CONFIG_PECI)		+= peci/
 obj-$(CONFIG_HTE)		+= hte/
+obj-$(CONFIG_DPLL)		+= dpll/
diff --git a/drivers/dpll/Kconfig b/drivers/dpll/Kconfig
new file mode 100644
index 000000000000..a4cae73f20d3
--- /dev/null
+++ b/drivers/dpll/Kconfig
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Generic DPLL drivers configuration
+#
+
+config DPLL
+  bool
diff --git a/drivers/dpll/Makefile b/drivers/dpll/Makefile
new file mode 100644
index 000000000000..b18cf848a010
--- /dev/null
+++ b/drivers/dpll/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for DPLL drivers.
+#
+
+obj-$(CONFIG_DPLL)          += dpll_sys.o
+dpll_sys-y                  += dpll_core.o
+dpll_sys-y                  += dpll_netlink.o
+
diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
new file mode 100644
index 000000000000..fec534f17827
--- /dev/null
+++ b/drivers/dpll/dpll_core.c
@@ -0,0 +1,1010 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *  dpll_core.c - Generic DPLL Management class support.
+ *
+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+#include "dpll_core.h"
+
+/**
+ * struct dpll_pin - structure for a dpll pin
+ * @idx:		unique id number for each pin
+ * @parent_pin:		parent pin
+ * @type:		type of the pin
+ * @ops:		operations this &dpll_pin supports
+ * @priv:		pointer to private information of owner
+ * @ref_dplls:		array of registered dplls
+ * @description:	name to distinguish the pin
+ */
+struct dpll_pin {
+	u32 idx;
+	struct dpll_pin *parent_pin;
+	enum dpll_pin_type type;
+	struct dpll_pin_ops *ops;
+	void *priv;
+	struct xarray ref_dplls;
+	char description[DPLL_PIN_DESC_LEN];
+};
+static DEFINE_MUTEX(dpll_device_xa_lock);
+
+static DEFINE_XARRAY_FLAGS(dpll_device_xa, XA_FLAGS_ALLOC);
+#define DPLL_REGISTERED		XA_MARK_1
+#define PIN_REGISTERED		XA_MARK_1
+
+#define ASSERT_DPLL_REGISTERED(d)                                           \
+	WARN_ON_ONCE(!xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
+#define ASSERT_DPLL_NOT_REGISTERED(d)                                      \
+	WARN_ON_ONCE(xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
+
+struct dpll_pin_ref {
+	struct dpll_device *dpll;
+	struct dpll_pin_ops *ops;
+	void *priv;
+};
+
+/**
+ * dpll_device_get_by_id - find dpll device by it's id
+ * @id: id of searched dpll
+ *
+ * Return: dpll_device struct if found, NULL otherwise.
+ */
+struct dpll_device *dpll_device_get_by_id(int id)
+{
+	struct dpll_device *dpll = NULL;
+
+	if (xa_get_mark(&dpll_device_xa, id, DPLL_REGISTERED))
+		dpll = xa_load(&dpll_device_xa, id);
+
+	return dpll;
+}
+
+/**
+ * dpll_device_get_by_name - find dpll device by it's id
+ * @name: name of searched dpll
+ *
+ * Return: dpll_device struct if found, NULL otherwise.
+ */
+struct dpll_device *dpll_device_get_by_name(const char *name)
+{
+	struct dpll_device *dpll, *ret = NULL;
+	unsigned long index;
+
+	mutex_lock(&dpll_device_xa_lock);
+	xa_for_each_marked(&dpll_device_xa, index, dpll, DPLL_REGISTERED) {
+		if (!strcmp(dev_name(&dpll->dev), name)) {
+			ret = dpll;
+			break;
+		}
+	}
+	mutex_unlock(&dpll_device_xa_lock);
+
+	return ret;
+}
+
+struct dpll_device *dpll_device_get_by_clock_id(u64 clock_id,
+						enum dpll_type type, u8 idx)
+{
+	struct dpll_device *dpll, *ret = NULL;
+	unsigned long index;
+
+	mutex_lock(&dpll_device_xa_lock);
+	xa_for_each_marked(&dpll_device_xa, index, dpll, DPLL_REGISTERED) {
+		if (dpll->clock_id == clock_id) {
+			if (dpll->type == type) {
+				if (dpll->dev_driver_idx == idx) {
+					ret = dpll;
+					break;
+				}
+			}
+		}
+	}
+	mutex_unlock(&dpll_device_xa_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dpll_device_get_by_clock_id);
+
+static void dpll_device_release(struct device *dev)
+{
+	struct dpll_device *dpll;
+
+	mutex_lock(&dpll_device_xa_lock);
+	dpll = to_dpll_device(dev);
+	dpll_device_unregister(dpll);
+	mutex_unlock(&dpll_device_xa_lock);
+	dpll_device_free(dpll);
+}
+
+static struct class dpll_class = {
+	.name = "dpll",
+	.dev_release = dpll_device_release,
+};
+
+struct dpll_device
+*dpll_device_alloc(struct dpll_device_ops *ops, enum dpll_type type,
+		   const u64 clock_id, enum dpll_clock_class clock_class,
+		   u8 dev_driver_idx, void *priv, struct device *parent)
+{
+	struct dpll_device *dpll;
+	int ret;
+
+	dpll = kzalloc(sizeof(*dpll), GFP_KERNEL);
+	if (!dpll)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_init(&dpll->lock);
+	dpll->ops = ops;
+	dpll->dev.class = &dpll_class;
+	dpll->parent = parent;
+	dpll->type = type;
+	dpll->dev_driver_idx = dev_driver_idx;
+	dpll->clock_id = clock_id;
+	dpll->clock_class = clock_class;
+
+	mutex_lock(&dpll_device_xa_lock);
+	ret = xa_alloc(&dpll_device_xa, &dpll->id, dpll,
+		       xa_limit_16b, GFP_KERNEL);
+	if (ret)
+		goto error;
+	dev_set_name(&dpll->dev, "dpll_%s_%d_%d", dev_name(parent), type,
+		     dev_driver_idx);
+	dpll->priv = priv;
+	xa_init_flags(&dpll->pins, XA_FLAGS_ALLOC);
+	xa_set_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
+	mutex_unlock(&dpll_device_xa_lock);
+	dpll_notify_device_create(dpll);
+
+	return dpll;
+
+error:
+	mutex_unlock(&dpll_device_xa_lock);
+	kfree(dpll);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(dpll_device_alloc);
+
+void dpll_device_free(struct dpll_device *dpll)
+{
+	WARN_ON_ONCE(!dpll);
+	WARN_ON_ONCE(!xa_empty(&dpll->pins));
+	xa_destroy(&dpll->pins);
+	mutex_destroy(&dpll->lock);
+	kfree(dpll);
+}
+EXPORT_SYMBOL_GPL(dpll_device_free);
+
+/**
+ * dpll_device_unregister - unregister dpll device
+ * @dpll: registered dpll pointer
+ *
+ * Note: It does not free the memory
+ */
+void dpll_device_unregister(struct dpll_device *dpll)
+{
+	ASSERT_DPLL_REGISTERED(dpll);
+
+	mutex_lock(&dpll_device_xa_lock);
+	xa_erase(&dpll_device_xa, dpll->id);
+	dpll_notify_device_delete(dpll);
+	mutex_unlock(&dpll_device_xa_lock);
+}
+EXPORT_SYMBOL_GPL(dpll_device_unregister);
+
+/**
+ * dpll_id - return dpll id
+ * @dpll: registered dpll pointer
+ *
+ * Return: dpll id.
+ */
+u32 dpll_id(struct dpll_device *dpll)
+{
+	return dpll->id;
+}
+
+/**
+ * dpll_pin_idx - return index of a pin
+ * @dpll: registered dpll pointer
+ * @pin: registered pin pointer
+ *
+ * Return: index of a pin or PIN_IDX_INVALID if not found.
+ */
+u32 dpll_pin_idx(struct dpll_device *dpll, struct dpll_pin *pin)
+{
+	struct dpll_pin *pos;
+	unsigned long index;
+
+	xa_for_each_marked(&dpll->pins, index, pos, PIN_REGISTERED) {
+		if (pos == pin)
+			return pin->idx;
+	}
+
+	return PIN_IDX_INVALID;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_idx);
+
+const char *dpll_dev_name(struct dpll_device *dpll)
+{
+	return dev_name(&dpll->dev);
+}
+
+struct dpll_pin *dpll_pin_alloc(const char *description,
+				const enum dpll_pin_type pin_type)
+{
+	struct dpll_pin *pin = kzalloc(sizeof(struct dpll_pin), GFP_KERNEL);
+
+	if (!pin)
+		return ERR_PTR(-ENOMEM);
+	if (pin_type <= DPLL_PIN_TYPE_UNSPEC ||
+	    pin_type > DPLL_PIN_TYPE_MAX)
+		return ERR_PTR(-EINVAL);
+
+	strncpy(pin->description, description, DPLL_PIN_DESC_LEN);
+	pin->description[DPLL_PIN_DESC_LEN - 1] = '\0';
+	xa_init_flags(&pin->ref_dplls, XA_FLAGS_ALLOC);
+	pin->type = pin_type;
+
+	return pin;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_alloc);
+
+static int dpll_alloc_pin_on_xa(struct xarray *pins, struct dpll_pin *pin)
+{
+	struct dpll_pin *pos;
+	unsigned long index;
+	int ret;
+
+	xa_for_each(pins, index, pos) {
+		if (pos == pin ||
+		    !strncmp(pos->description, pin->description,
+			     DPLL_PIN_DESC_LEN))
+			return -EEXIST;
+	}
+
+	ret = xa_alloc(pins, &pin->idx, pin, xa_limit_16b, GFP_KERNEL);
+	if (!ret)
+		xa_set_mark(pins, pin->idx, PIN_REGISTERED);
+
+	return ret;
+}
+
+static int dpll_pin_ref_add(struct dpll_pin *pin, struct dpll_device *dpll,
+			    struct dpll_pin_ops *ops, void *priv)
+{
+	struct dpll_pin_ref *ref, *pos;
+	unsigned long index;
+	u32 idx;
+
+	ref = kzalloc(sizeof(struct dpll_pin_ref), GFP_KERNEL);
+	if (!ref)
+		return -ENOMEM;
+	ref->dpll = dpll;
+	ref->ops = ops;
+	ref->priv = priv;
+	if (!xa_empty(&pin->ref_dplls)) {
+		xa_for_each(&pin->ref_dplls, index, pos) {
+			if (pos->dpll == ref->dpll)
+				return -EEXIST;
+		}
+	}
+
+	return xa_alloc(&pin->ref_dplls, &idx, ref, xa_limit_16b, GFP_KERNEL);
+}
+
+static void dpll_pin_ref_del(struct dpll_pin *pin, struct dpll_device *dpll)
+{
+	struct dpll_pin_ref *pos;
+	unsigned long index;
+
+	xa_for_each(&pin->ref_dplls, index, pos) {
+		if (pos->dpll == dpll) {
+			WARN_ON_ONCE(pos != xa_erase(&pin->ref_dplls, index));
+			break;
+		}
+	}
+}
+
+static int pin_deregister_from_xa(struct xarray *xa_pins, struct dpll_pin *pin)
+{
+	struct dpll_pin *pos;
+	unsigned long index;
+
+	xa_for_each(xa_pins, index, pos) {
+		if (pos == pin) {
+			WARN_ON_ONCE(pos != xa_erase(xa_pins, index));
+			return 0;
+		}
+	}
+
+	return -ENXIO;
+}
+
+int dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
+		      struct dpll_pin_ops *ops, void *priv)
+{
+	int ret;
+
+	if (!pin || !ops)
+		return -EINVAL;
+
+	mutex_lock(&dpll->lock);
+	ret = dpll_alloc_pin_on_xa(&dpll->pins, pin);
+	if (!ret) {
+		ret = dpll_pin_ref_add(pin, dpll, ops, priv);
+		if (ret)
+			pin_deregister_from_xa(&dpll->pins, pin);
+	}
+	mutex_unlock(&dpll->lock);
+	if (!ret)
+		dpll_pin_notify(dpll, pin, DPLL_CHANGE_PIN_ADD);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_register);
+
+struct dpll_pin *dpll_pin_get_by_idx_from_xa(struct xarray *xa_pins, int idx)
+{
+	struct dpll_pin *pos;
+	unsigned long index;
+
+	xa_for_each_marked(xa_pins, index, pos, PIN_REGISTERED) {
+		if (pos->idx == idx)
+			return pos;
+	}
+
+	return NULL;
+}
+
+/**
+ * dpll_pin_get_by_idx - find a pin by its index
+ * @dpll: dpll device pointer
+ * @idx: index of pin
+ *
+ * Allows multiple driver instances using one physical DPLL to find
+ * and share pin already registered with existing dpll device.
+ *
+ * Return: pointer if pin was found, NULL otherwise.
+ */
+struct dpll_pin *dpll_pin_get_by_idx(struct dpll_device *dpll, int idx)
+{
+	return dpll_pin_get_by_idx_from_xa(&dpll->pins, idx);
+}
+
+	struct dpll_pin
+*dpll_pin_get_by_description(struct dpll_device *dpll, const char *description)
+{
+	struct dpll_pin *pos, *pin = NULL;
+	unsigned long index;
+
+	xa_for_each(&dpll->pins, index, pos) {
+		if (!strncmp(pos->description, description,
+			     DPLL_PIN_DESC_LEN)) {
+			pin = pos;
+			break;
+		}
+	}
+
+	return pin;
+}
+
+int
+dpll_shared_pin_register(struct dpll_device *dpll_pin_owner,
+			 struct dpll_device *dpll,
+			 const char *shared_pin_description,
+			 struct dpll_pin_ops *ops, void *priv)
+{
+	struct dpll_pin *pin;
+	int ret;
+
+	mutex_lock(&dpll_pin_owner->lock);
+	pin = dpll_pin_get_by_description(dpll_pin_owner,
+					  shared_pin_description);
+	if (!pin) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+	ret = dpll_pin_register(dpll, pin, ops, priv);
+unlock:
+	mutex_unlock(&dpll_pin_owner->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dpll_shared_pin_register);
+
+int dpll_pin_deregister(struct dpll_device *dpll, struct dpll_pin *pin)
+{
+	int ret = 0;
+
+	if (xa_empty(&dpll->pins))
+		return -ENOENT;
+
+	mutex_lock(&dpll->lock);
+	ret = pin_deregister_from_xa(&dpll->pins, pin);
+	if (!ret)
+		dpll_pin_ref_del(pin, dpll);
+	mutex_unlock(&dpll->lock);
+	if (!ret)
+		dpll_pin_notify(dpll, pin, DPLL_CHANGE_PIN_DEL);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_deregister);
+
+void dpll_pin_free(struct dpll_pin *pin)
+{
+	if (!xa_empty(&pin->ref_dplls))
+		return;
+
+	xa_destroy(&pin->ref_dplls);
+	kfree(pin);
+}
+EXPORT_SYMBOL_GPL(dpll_pin_free);
+
+int dpll_muxed_pin_register(struct dpll_device *dpll,
+			    const char *parent_pin_description,
+			    struct dpll_pin *pin,
+			    struct dpll_pin_ops *ops, void *priv)
+{
+	struct dpll_pin *parent_pin;
+	int ret;
+
+	if (!parent_pin_description || !pin)
+		return -EINVAL;
+
+	mutex_lock(&dpll->lock);
+	parent_pin = dpll_pin_get_by_description(dpll, parent_pin_description);
+	if (!parent_pin)
+		return -EINVAL;
+	if (parent_pin->type != DPLL_PIN_TYPE_MUX)
+		return -EPERM;
+	ret = dpll_alloc_pin_on_xa(&dpll->pins, pin);
+	if (!ret)
+		ret = dpll_pin_ref_add(pin, dpll, ops, priv);
+	if (!ret)
+		pin->parent_pin = parent_pin;
+	mutex_unlock(&dpll->lock);
+	if (!ret)
+		dpll_pin_notify(dpll, pin, DPLL_CHANGE_PIN_ADD);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dpll_muxed_pin_register);
+
+/**
+ * dpll_pin_first - get first registered pin
+ * @dpll: registered dpll pointer
+ * @index: found pin index (out)
+ *
+ * Return: dpll_pin struct if found, NULL otherwise.
+ */
+struct dpll_pin *dpll_pin_first(struct dpll_device *dpll, unsigned long *index)
+{
+	*index = 0;
+
+	return xa_find(&dpll->pins, index, LONG_MAX, PIN_REGISTERED);
+}
+
+/**
+ * dpll_pin_next - get next registered pin to the relative pin
+ * @dpll: registered dpll pointer
+ * @index: relative pin index (in and out)
+ *
+ * Return: dpll_pin struct if found, NULL otherwise.
+ */
+struct dpll_pin *dpll_pin_next(struct dpll_device *dpll, unsigned long *index)
+{
+	return xa_find_after(&dpll->pins, index, LONG_MAX, PIN_REGISTERED);
+}
+
+/**
+ * dpll_first - get first registered dpll device
+ * @index: found dpll index (out)
+ *
+ * Return: dpll_device struct if found, NULL otherwise.
+ */
+struct dpll_device *dpll_first(unsigned long *index)
+{
+	*index = 0;
+
+	return xa_find(&dpll_device_xa, index, LONG_MAX, DPLL_REGISTERED);
+}
+
+/**
+ * dpll_pin_next - get next registered dpll device to the relative pin
+ * @index: relative dpll index (in and out)
+ *
+ * Return: dpll_pin struct if found, NULL otherwise.
+ */
+struct dpll_device *dpll_next(unsigned long *index)
+{
+	return xa_find_after(&dpll_device_xa, index, LONG_MAX, DPLL_REGISTERED);
+}
+
+static struct dpll_pin_ref
+*dpll_pin_find_ref(const struct dpll_device *dpll, const struct dpll_pin *pin)
+{
+	struct dpll_pin_ref *ref;
+	unsigned long index;
+
+	xa_for_each((struct xarray *)&pin->ref_dplls, index, ref) {
+		if (ref->dpll != dpll)
+			continue;
+		else
+			return ref;
+	}
+
+	return NULL;
+}
+
+/**
+ * dpll_pin_type_get - get type of a pin
+ * @dpll: registered dpll pointer
+ * @pin: registered pin pointer
+ * @type: on success - configured pin type
+ *
+ * Return:
+ * * 0 - successfully got pin's type
+ * * negative - failed to get pin's type
+ */
+int dpll_pin_type_get(const struct dpll_device *dpll,
+		      const struct dpll_pin *pin,
+		      enum dpll_pin_type *type)
+{
+	if (!pin)
+		return -ENODEV;
+	*type = pin->type;
+
+	return 0;
+}
+
+/**
+ * dpll_pin_signal_type_get - get signal type of a pin
+ * @dpll: registered dpll pointer
+ * @pin: registered pin pointer
+ * @type: on success - configured signal type
+ *
+ * Return:
+ * * 0 - successfully got signal type
+ * * negative - failed to obtain signal type
+ */
+int dpll_pin_signal_type_get(const struct dpll_device *dpll,
+			     const struct dpll_pin *pin,
+			     enum dpll_pin_signal_type *type)
+{
+	struct dpll_pin_ref *ref = dpll_pin_find_ref(dpll, pin);
+	int ret;
+
+	if (!ref)
+		return -ENODEV;
+	if (!ref->ops || !ref->ops->signal_type_get)
+		return -EOPNOTSUPP;
+	ret = ref->ops->signal_type_get(ref->dpll, pin, type);
+
+	return ret;
+}
+
+/**
+ * dpll_pin_signal_type_set - set signal type of a pin
+ * @dpll: registered dpll pointer
+ * @pin: registered pin pointer
+ * @type: type to be set
+ *
+ * Return:
+ * * 0 - signal type set
+ * * negative - failed to set signal type
+ */
+int dpll_pin_signal_type_set(const struct dpll_device *dpll,
+			     const struct dpll_pin *pin,
+			     const enum dpll_pin_signal_type type)
+{
+	struct dpll_pin_ref *ref;
+	unsigned long index;
+	int ret;
+
+	xa_for_each((struct xarray *)&pin->ref_dplls, index, ref) {
+		if (!ref->dpll)
+			return -EFAULT;
+		if (!ref || !ref->ops || !ref->ops->signal_type_set)
+			return -EOPNOTSUPP;
+		if (ref->dpll != dpll)
+			mutex_lock(&ref->dpll->lock);
+		ret = ref->ops->signal_type_set(ref->dpll, pin, type);
+		if (ref->dpll != dpll)
+			mutex_unlock(&ref->dpll->lock);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
+/**
+ * dpll_pin_signal_type_supported - check if signal type is supported on a pin
+ * @dpll: registered dpll pointer
+ * @pin: registered pin pointer
+ * @type: type being checked
+ * @supported: on success - if given signal type is supported
+ *
+ * Return:
+ * * 0 - successfully got supported signal type
+ * * negative - failed to obtain supported signal type
+ */
+int dpll_pin_signal_type_supported(const struct dpll_device *dpll,
+				   const struct dpll_pin *pin,
+				   const enum dpll_pin_signal_type type,
+				   bool *supported)
+{
+	struct dpll_pin_ref *ref = dpll_pin_find_ref(dpll, pin);
+
+	if (!ref)
+		return -ENODEV;
+	if (!ref->ops || !ref->ops->signal_type_supported)
+		return -EOPNOTSUPP;
+	*supported = ref->ops->signal_type_supported(ref->dpll, pin, type);
+
+	return 0;
+}
+
+/**
+ * dpll_pin_mode_active - check if given mode is active on a pin
+ * @dpll: registered dpll pointer
+ * @pin: registered pin pointer
+ * @mode: mode being checked
+ * @active: on success - if mode is active
+ *
+ * Return:
+ * * 0 - successfully checked if mode is active
+ * * negative - failed to check for active mode
+ */
+int dpll_pin_mode_active(const struct dpll_device *dpll,
+			  const struct dpll_pin *pin,
+			  const enum dpll_pin_mode mode,
+			  bool *active)
+{
+	struct dpll_pin_ref *ref = dpll_pin_find_ref(dpll, pin);
+
+	if (!ref)
+		return -ENODEV;
+	if (!ref->ops || !ref->ops->mode_active)
+		return -EOPNOTSUPP;
+	*active = ref->ops->mode_active(ref->dpll, pin, mode);
+
+	return 0;
+}
+
+/**
+ * dpll_pin_mode_supported - check if given mode is supported on a pin
+ * @dpll: registered dpll pointer
+ * @pin: registered pin pointer
+ * @mode: mode being checked
+ * @supported: on success - if mode is supported
+ *
+ * Return:
+ * * 0 - successfully checked if mode is supported
+ * * negative - failed to check for supported mode
+ */
+int dpll_pin_mode_supported(const struct dpll_device *dpll,
+			     const struct dpll_pin *pin,
+			     const enum dpll_pin_mode mode,
+			     bool *supported)
+{
+	struct dpll_pin_ref *ref = dpll_pin_find_ref(dpll, pin);
+
+	if (!ref)
+		return -ENODEV;
+	if (!ref->ops || !ref->ops->mode_supported)
+		return -EOPNOTSUPP;
+	*supported = ref->ops->mode_supported(ref->dpll, pin, mode);
+
+	return 0;
+}
+
+/**
+ * dpll_pin_mode_set - set pin's mode
+ * @dpll: registered dpll pointer
+ * @pin: registered pin pointer
+ * @mode: mode being set
+ *
+ * Return:
+ * * 0 - successfully set the mode
+ * * negative - failed to set the mode
+ */
+int dpll_pin_mode_set(const struct dpll_device *dpll,
+		       const struct dpll_pin *pin,
+		       const enum dpll_pin_mode mode)
+{
+	struct dpll_pin_ref *ref;
+	unsigned long index;
+	int ret;
+
+	xa_for_each((struct xarray *)&pin->ref_dplls, index, ref) {
+		if (!ref)
+			return -ENODEV;
+		if (!ref->ops || !ref->ops->mode_enable)
+			return -EOPNOTSUPP;
+		if (ref->dpll != dpll)
+			mutex_lock(&ref->dpll->lock);
+		ret = ref->ops->mode_enable(ref->dpll, pin, mode);
+		if (ref->dpll != dpll)
+			mutex_unlock(&ref->dpll->lock);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
+/**
+ * dpll_pin_custom_freq_get - get pin's custom frequency
+ * @dpll: registered dpll pointer
+ * @pin: registered pin pointer
+ * @freq: on success - custom frequency of a pin
+ *
+ * Return:
+ * * 0 - successfully got custom frequency
+ * * negative - failed to obtain custom frequency
+ */
+int dpll_pin_custom_freq_get(const struct dpll_device *dpll,
+			     const struct dpll_pin *pin, u32 *freq)
+{
+	struct dpll_pin_ref *ref = dpll_pin_find_ref(dpll, pin);
+	int ret;
+
+	if (!ref)
+		return -ENODEV;
+	if (!ref->ops || !ref->ops->custom_freq_get)
+		return -EOPNOTSUPP;
+	ret = ref->ops->custom_freq_get(ref->dpll, pin, freq);
+
+	return ret;
+}
+
+/**
+ * dpll_pin_custom_freq_set - set pin's custom frequency
+ * @dpll: registered dpll pointer
+ * @pin: registered pin pointer
+ * @freq: custom frequency to be set
+ *
+ * Return:
+ * * 0 - successfully set custom frequency
+ * * negative - failed to set custom frequency
+ */
+int dpll_pin_custom_freq_set(const struct dpll_device *dpll,
+			     const struct dpll_pin *pin, const u32 freq)
+{
+	enum dpll_pin_signal_type type;
+	struct dpll_pin_ref *ref;
+	unsigned long index;
+	int ret;
+
+	xa_for_each((struct xarray *)&pin->ref_dplls, index, ref) {
+		if (!ref)
+			return -ENODEV;
+		if (!ref->ops || !ref->ops->custom_freq_set ||
+		    !ref->ops->signal_type_get)
+			return -EOPNOTSUPP;
+		if (dpll != ref->dpll)
+			mutex_lock(&ref->dpll->lock);
+		ret = ref->ops->signal_type_get(dpll, pin, &type);
+		if (!ret && type == DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ)
+			ret = ref->ops->custom_freq_set(ref->dpll, pin, freq);
+		if (dpll != ref->dpll)
+			mutex_unlock(&ref->dpll->lock);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
+/**
+ * dpll_pin_prio_get - get pin's prio on dpll
+ * @dpll: registered dpll pointer
+ * @pin: registered pin pointer
+ * @prio: on success - priority of a pin on a dpll
+ *
+ * Return:
+ * * 0 - successfully got priority
+ * * negative - failed to obtain priority
+ */
+int dpll_pin_prio_get(const struct dpll_device *dpll,
+		      const struct dpll_pin *pin, u32 *prio)
+{
+	struct dpll_pin_ref *ref = dpll_pin_find_ref(dpll, pin);
+	int ret;
+
+	if (!ref)
+		return -ENODEV;
+	if (!ref->ops || !ref->ops->prio_get)
+		return -EOPNOTSUPP;
+	ret = ref->ops->prio_get(ref->dpll, pin, prio);
+
+	return ret;
+}
+
+/**
+ * dpll_pin_prio_set - set pin's prio on dpll
+ * @dpll: registered dpll pointer
+ * @pin: registered pin pointer
+ * @prio: priority of a pin to be set on a dpll
+ *
+ * Return:
+ * * 0 - successfully set priority
+ * * negative - failed to set the priority
+ */
+int dpll_pin_prio_set(const struct dpll_device *dpll,
+		      const struct dpll_pin *pin, const u32 prio)
+{
+	struct dpll_pin_ref *ref = dpll_pin_find_ref(dpll, pin);
+	int ret;
+
+	if (!ref)
+		return -ENODEV;
+	if (!ref->ops || !ref->ops->prio_set)
+		return -EOPNOTSUPP;
+	ret = ref->ops->prio_set(ref->dpll, pin, prio);
+
+	return ret;
+}
+
+/**
+ * dpll_pin_netifindex_get - get pin's netdev iterface index
+ * @dpll: registered dpll pointer
+ * @pin: registered pin pointer
+ * @netifindex: on success - index of a netdevice associated with pin
+ *
+ * Return:
+ * * 0 - successfully got netdev interface index
+ * * negative - failed to obtain netdev interface index
+ */
+int dpll_pin_netifindex_get(const struct dpll_device *dpll,
+			    const struct dpll_pin *pin,
+			    int *netifindex)
+{
+	struct dpll_pin_ref *ref = dpll_pin_find_ref(dpll, pin);
+	int ret;
+
+	if (!ref)
+		return -ENODEV;
+	if (!ref->ops || !ref->ops->net_if_idx_get)
+		return -EOPNOTSUPP;
+	ret = ref->ops->net_if_idx_get(ref->dpll, pin, netifindex);
+
+	return ret;
+}
+
+/**
+ * dpll_pin_description - provide pin's description string
+ * @pin: registered pin pointer
+ *
+ * Return: pointer to a description string.
+ */
+const char *dpll_pin_description(struct dpll_pin *pin)
+{
+	return pin->description;
+}
+
+/**
+ * dpll_pin_parent - provide pin's parent pin if available
+ * @pin: registered pin pointer
+ *
+ * Return: pointer to aparent if found, NULL otherwise.
+ */
+struct dpll_pin *dpll_pin_parent(struct dpll_pin *pin)
+{
+	return pin->parent_pin;
+}
+
+/**
+ * dpll_mode_set - handler for dpll mode set
+ * @dpll: registered dpll pointer
+ * @mode: mode to be set
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_mode_set(struct dpll_device *dpll, const enum dpll_mode mode)
+{
+	int ret;
+
+	if (!dpll->ops || !dpll->ops)
+		return -EOPNOTSUPP;
+
+	ret = dpll->ops->mode_set(dpll, mode);
+
+	return ret;
+}
+
+/**
+ * dpll_source_idx_set - handler for selecting a dpll's source
+ * @dpll: registered dpll pointer
+ * @source_pin_idx: index of a source pin to e selected
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_source_idx_set(struct dpll_device *dpll, const u32 source_pin_idx)
+{
+	struct dpll_pin_ref *ref;
+	struct dpll_pin *pin;
+	int ret;
+
+	pin = dpll_pin_get_by_idx_from_xa(&dpll->pins, source_pin_idx);
+	if (!pin)
+		return -ENXIO;
+	ref = dpll_pin_find_ref(dpll, pin);
+	if (!ref || !ref->ops)
+		return -EFAULT;
+	if (!ref->ops->select)
+		return -ENODEV;
+	ret = ref->ops->select(ref->dpll, pin);
+
+	return ret;
+}
+
+/**
+ * dpll_lock - locks the dpll using internal mutex
+ * @dpll: registered dpll pointer
+ */
+void dpll_lock(struct dpll_device *dpll)
+{
+	mutex_lock(&dpll->lock);
+}
+
+/**
+ * dpll_unlock - unlocks the dpll using internal mutex
+ * @dpll: registered dpll pointer
+ */
+void dpll_unlock(struct dpll_device *dpll)
+{
+	mutex_unlock(&dpll->lock);
+}
+
+enum dpll_pin_type dpll_pin_type(const struct dpll_pin *pin)
+{
+	return pin->type;
+}
+
+void *dpll_priv(const struct dpll_device *dpll)
+{
+	return dpll->priv;
+}
+EXPORT_SYMBOL_GPL(dpll_priv);
+
+void *dpll_pin_priv(const struct dpll_device *dpll, const struct dpll_pin *pin)
+{
+	struct dpll_pin_ref *ref = dpll_pin_find_ref(dpll, pin);
+
+	if (!ref)
+		return NULL;
+
+	return ref->priv;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_priv);
+
+static int __init dpll_init(void)
+{
+	int ret;
+
+	ret = dpll_netlink_init();
+	if (ret)
+		goto error;
+
+	ret = class_register(&dpll_class);
+	if (ret)
+		goto unregister_netlink;
+
+	return 0;
+
+unregister_netlink:
+	dpll_netlink_finish();
+error:
+	mutex_destroy(&dpll_device_xa_lock);
+	return ret;
+}
+subsys_initcall(dpll_init);
diff --git a/drivers/dpll/dpll_core.h b/drivers/dpll/dpll_core.h
new file mode 100644
index 000000000000..b933d63b60c1
--- /dev/null
+++ b/drivers/dpll/dpll_core.h
@@ -0,0 +1,105 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
+ */
+
+#ifndef __DPLL_CORE_H__
+#define __DPLL_CORE_H__
+
+#include <linux/dpll.h>
+
+#include "dpll_netlink.h"
+
+#define to_dpll_device(_dev) \
+	container_of(_dev, struct dpll_device, dev)
+
+/**
+ * struct dpll_device - structure for a DPLL device
+ * @id:		unique id number for each device
+ * @dev:	struct device for this dpll device
+ * @parent:	parent device
+ * @ops:	operations this &dpll_device supports
+ * @lock:	mutex to serialize operations
+ * @type:	type of a dpll
+ * @priv:	pointer to private information of owner
+ * @pins:	list of pointers to pins registered with this dpll
+ * @clock_id:	unique identifier (clock_id) of a dpll
+ * @clock_class	quality class of a DPLL clock
+ * @dev_driver_idx: provided by driver for
+ */
+struct dpll_device {
+	u32 id;
+	struct device dev;
+	struct device *parent;
+	struct dpll_device_ops *ops;
+	struct mutex lock;
+	enum dpll_type type;
+	void *priv;
+	struct xarray pins;
+	u64 clock_id;
+	enum dpll_clock_class clock_class;
+	u8 dev_driver_idx;
+};
+
+#define for_each_pin_on_dpll(dpll, pin, i)			\
+	for (pin = dpll_pin_first(dpll, &i); pin != NULL;	\
+	     pin = dpll_pin_next(dpll, &i))
+
+#define for_each_dpll(dpll, i)                         \
+	for (dpll = dpll_first(&i); dpll != NULL; dpll = dpll_next(&i))
+
+struct dpll_device *dpll_device_get_by_id(int id);
+
+struct dpll_device *dpll_device_get_by_name(const char *name);
+struct dpll_pin *dpll_pin_first(struct dpll_device *dpll, unsigned long *index);
+struct dpll_pin *dpll_pin_next(struct dpll_device *dpll, unsigned long *index);
+struct dpll_device *dpll_first(unsigned long *index);
+struct dpll_device *dpll_next(unsigned long *index);
+void dpll_device_unregister(struct dpll_device *dpll);
+u32 dpll_id(struct dpll_device *dpll);
+const char *dpll_dev_name(struct dpll_device *dpll);
+void dpll_lock(struct dpll_device *dpll);
+void dpll_unlock(struct dpll_device *dpll);
+u32 dpll_pin_idx(struct dpll_device *dpll, struct dpll_pin *pin);
+int dpll_pin_type_get(const struct dpll_device *dpll,
+		      const struct dpll_pin *pin,
+		      enum dpll_pin_type *type);
+int dpll_pin_signal_type_get(const struct dpll_device *dpll,
+			     const struct dpll_pin *pin,
+			     enum dpll_pin_signal_type *type);
+int dpll_pin_signal_type_set(const struct dpll_device *dpll,
+			     const struct dpll_pin *pin,
+			     const enum dpll_pin_signal_type type);
+int dpll_pin_signal_type_supported(const struct dpll_device *dpll,
+				   const struct dpll_pin *pin,
+				   const enum dpll_pin_signal_type type,
+				   bool *supported);
+int dpll_pin_mode_active(const struct dpll_device *dpll,
+			 const struct dpll_pin *pin,
+			 const enum dpll_pin_mode mode,
+			 bool *active);
+int dpll_pin_mode_supported(const struct dpll_device *dpll,
+			    const struct dpll_pin *pin,
+			    const enum dpll_pin_mode mode,
+			    bool *supported);
+int dpll_pin_mode_set(const struct dpll_device *dpll,
+		      const struct dpll_pin *pin,
+		      const enum dpll_pin_mode mode);
+int dpll_pin_custom_freq_get(const struct dpll_device *dpll,
+			     const struct dpll_pin *pin, u32 *freq);
+int dpll_pin_custom_freq_set(const struct dpll_device *dpll,
+			     const struct dpll_pin *pin, const u32 freq);
+int dpll_pin_prio_get(const struct dpll_device *dpll,
+		      const struct dpll_pin *pin, u32 *prio);
+struct dpll_pin *dpll_pin_get_by_idx(struct dpll_device *dpll, int idx);
+int dpll_pin_prio_set(const struct dpll_device *dpll,
+		      const struct dpll_pin *pin, const u32 prio);
+int dpll_pin_netifindex_get(const struct dpll_device *dpll,
+			    const struct dpll_pin *pin,
+			    int *netifindex);
+const char *dpll_pin_description(struct dpll_pin *pin);
+struct dpll_pin *dpll_pin_parent(struct dpll_pin *pin);
+int dpll_mode_set(struct dpll_device *dpll, const enum dpll_mode mode);
+int dpll_source_idx_set(struct dpll_device *dpll, const u32 source_pin_idx);
+
+#endif
diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
new file mode 100644
index 000000000000..91a1e5025ab2
--- /dev/null
+++ b/drivers/dpll/dpll_netlink.c
@@ -0,0 +1,883 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Generic netlink for DPLL management framework
+ *
+ * Copyright (c) 2021 Meta Platforms, Inc. and affiliates
+ *
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <net/genetlink.h>
+#include "dpll_core.h"
+
+#include <uapi/linux/dpll.h>
+
+static const struct genl_multicast_group dpll_mcgrps[] = {
+	{ .name = DPLL_MONITOR_GROUP_NAME,  },
+};
+
+static const struct nla_policy dpll_cmd_device_get_policy[] = {
+	[DPLLA_ID]		= { .type = NLA_U32 },
+	[DPLLA_NAME]		= { .type = NLA_STRING,
+				    .len = DPLL_NAME_LEN },
+	[DPLLA_FILTER]		= { .type = NLA_U32 },
+};
+
+static const struct nla_policy dpll_cmd_device_set_policy[] = {
+	[DPLLA_ID]		= { .type = NLA_U32 },
+	[DPLLA_NAME]		= { .type = NLA_STRING,
+				    .len = DPLL_NAME_LEN },
+	[DPLLA_MODE]		= { .type = NLA_U32 },
+	[DPLLA_SOURCE_PIN_IDX]	= { .type = NLA_U32 },
+};
+
+static const struct nla_policy dpll_cmd_pin_set_policy[] = {
+	[DPLLA_ID]		= { .type = NLA_U32 },
+	[DPLLA_PIN_IDX]		= { .type = NLA_U32 },
+	[DPLLA_PIN_SIGNAL_TYPE]	= { .type = NLA_U32 },
+	[DPLLA_PIN_CUSTOM_FREQ] = { .type = NLA_U32 },
+	[DPLLA_PIN_MODE]	= { .type = NLA_U32 },
+	[DPLLA_PIN_PRIO]	= { .type = NLA_U32 },
+};
+
+struct dpll_dump_ctx {
+	int dump_filter;
+};
+
+static struct genl_family dpll_gnl_family;
+
+static struct dpll_dump_ctx *dpll_dump_context(struct netlink_callback *cb)
+{
+	return (struct dpll_dump_ctx *)cb->ctx;
+}
+
+static int dpll_msg_add_id(struct sk_buff *msg, u32 id)
+{
+	if (nla_put_u32(msg, DPLLA_ID, id))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int dpll_msg_add_name(struct sk_buff *msg, const char *name)
+{
+	if (nla_put_string(msg, DPLLA_NAME, name))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int __dpll_msg_add_mode(struct sk_buff *msg, enum dplla msg_type,
+			       enum dpll_mode mode)
+{
+	if (nla_put_s32(msg, msg_type, mode))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+dpll_msg_add_mode(struct sk_buff *msg, const struct dpll_device *dpll)
+{
+	enum dpll_mode m;
+	int ret;
+
+	if (!dpll->ops->mode_get)
+		return 0;
+	ret = dpll->ops->mode_get(dpll, &m);
+	if (ret)
+		return ret;
+
+	return __dpll_msg_add_mode(msg, DPLLA_MODE, m);
+}
+
+static int
+dpll_msg_add_modes_supported(struct sk_buff *msg,
+			     const struct dpll_device *dpll)
+{
+	enum dpll_mode i;
+	int ret = 0;
+
+	if (!dpll->ops->mode_supported)
+		return ret;
+
+	for (i = DPLL_MODE_UNSPEC + 1; i <= DPLL_MODE_MAX; i++) {
+		if (dpll->ops->mode_supported(dpll, i)) {
+			ret = __dpll_msg_add_mode(msg, DPLLA_MODE_SUPPORTED, i);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return ret;
+}
+
+static int dpll_msg_add_clock_id(struct sk_buff *msg,
+				 const struct dpll_device *dpll)
+{
+	if (nla_put_64bit(msg, DPLLA_CLOCK_ID, sizeof(dpll->clock_id),
+			  &dpll->clock_id, 0))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int dpll_msg_add_clock_class(struct sk_buff *msg,
+				    const struct dpll_device *dpll)
+{
+	if (nla_put_s32(msg, DPLLA_CLOCK_CLASS, dpll->clock_class))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+dpll_msg_add_source_pin(struct sk_buff *msg, struct dpll_device *dpll)
+{
+	u32 source_idx;
+	int ret;
+
+	if (!dpll->ops->source_pin_idx_get)
+		return 0;
+	ret = dpll->ops->source_pin_idx_get(dpll, &source_idx);
+	if (ret)
+		return ret;
+	if (nla_put_u32(msg, DPLLA_SOURCE_PIN_IDX, source_idx))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int dpll_msg_add_lock_status(struct sk_buff *msg, struct dpll_device *dpll)
+{
+	enum dpll_lock_status s;
+	int ret;
+
+	if (!dpll->ops->lock_status_get)
+		return 0;
+	ret = dpll->ops->lock_status_get(dpll, &s);
+	if (ret)
+		return ret;
+	if (nla_put_s32(msg, DPLLA_LOCK_STATUS, s))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int dpll_msg_add_temp(struct sk_buff *msg, struct dpll_device *dpll)
+{
+	s32 temp;
+	int ret;
+
+	if (!dpll->ops->temp_get)
+		return 0;
+	ret = dpll->ops->temp_get(dpll, &temp);
+	if (ret)
+		return ret;
+	if (nla_put_u32(msg, DPLLA_TEMP, temp))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int dpll_msg_add_pin_idx(struct sk_buff *msg, u32 pin_idx)
+{
+	if (nla_put_u32(msg, DPLLA_PIN_IDX, pin_idx))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int dpll_msg_add_pin_description(struct sk_buff *msg,
+					const char *description)
+{
+	if (nla_put_string(msg, DPLLA_PIN_DESCRIPTION, description))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int dpll_msg_add_pin_parent_idx(struct sk_buff *msg, u32 parent_idx)
+{
+	if (nla_put_u32(msg, DPLLA_PIN_PARENT_IDX, parent_idx))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+dpll_msg_add_pin_type(struct sk_buff *msg, const struct dpll_device *dpll,
+		      const struct dpll_pin *pin)
+{
+	enum dpll_pin_type t;
+
+	if (dpll_pin_type_get(dpll, pin, &t))
+		return 0;
+
+	if (nla_put_s32(msg, DPLLA_PIN_TYPE, t))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int __dpll_msg_add_pin_signal_type(struct sk_buff *msg,
+					  enum dplla attr,
+					  enum dpll_pin_signal_type type)
+{
+	if (nla_put_s32(msg, attr, type))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int dpll_msg_add_pin_signal_type(struct sk_buff *msg,
+					const struct dpll_device *dpll,
+					const struct dpll_pin *pin)
+{
+	enum dpll_pin_signal_type t;
+	int ret;
+
+	if (dpll_pin_signal_type_get(dpll, pin, &t))
+		return 0;
+	ret = __dpll_msg_add_pin_signal_type(msg, DPLLA_PIN_SIGNAL_TYPE, t);
+	if (ret)
+		return ret;
+
+	if (t == DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ) {
+		u32 freq;
+
+		if (dpll_pin_custom_freq_get(dpll, pin, &freq))
+			return 0;
+		if (nla_put_u32(msg, DPLLA_PIN_CUSTOM_FREQ, freq))
+			return -EMSGSIZE;
+	}
+
+	return 0;
+}
+
+static int
+dpll_msg_add_pin_signal_types_supported(struct sk_buff *msg,
+					const struct dpll_device *dpll,
+					const struct dpll_pin *pin)
+{
+	const enum dplla da = DPLLA_PIN_SIGNAL_TYPE_SUPPORTED;
+	enum dpll_pin_signal_type i;
+	bool supported;
+
+	for (i = DPLL_PIN_SIGNAL_TYPE_UNSPEC + 1;
+	     i <= DPLL_PIN_SIGNAL_TYPE_MAX; i++) {
+		if (dpll_pin_signal_type_supported(dpll, pin, i, &supported))
+			continue;
+		if (supported) {
+			int ret = __dpll_msg_add_pin_signal_type(msg, da, i);
+
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int dpll_msg_add_pin_modes(struct sk_buff *msg,
+				   const struct dpll_device *dpll,
+				   const struct dpll_pin *pin)
+{
+	enum dpll_pin_mode i;
+	bool active;
+
+	for (i = DPLL_PIN_MODE_UNSPEC + 1; i <= DPLL_PIN_MODE_MAX; i++) {
+		if (dpll_pin_mode_active(dpll, pin, i, &active))
+			return 0;
+		if (active)
+			if (nla_put_s32(msg, DPLLA_PIN_MODE, i))
+				return -EMSGSIZE;
+	}
+
+	return 0;
+}
+
+static int dpll_msg_add_pin_modes_supported(struct sk_buff *msg,
+					     const struct dpll_device *dpll,
+					     const struct dpll_pin *pin)
+{
+	enum dpll_pin_mode i;
+	bool supported;
+
+	for (i = DPLL_PIN_MODE_UNSPEC + 1; i <= DPLL_PIN_MODE_MAX; i++) {
+		if (dpll_pin_mode_supported(dpll, pin, i, &supported))
+			return 0;
+		if (supported)
+			if (nla_put_s32(msg, DPLLA_PIN_MODE_SUPPORTED, i))
+				return -EMSGSIZE;
+	}
+
+	return 0;
+}
+
+static int
+dpll_msg_add_pin_prio(struct sk_buff *msg, const struct dpll_device *dpll,
+		      const struct dpll_pin *pin)
+{
+	u32 prio;
+
+	if (dpll_pin_prio_get(dpll, pin, &prio))
+		return 0;
+	if (nla_put_u32(msg, DPLLA_PIN_PRIO, prio))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+dpll_msg_add_pin_netifindex(struct sk_buff *msg, const struct dpll_device *dpll,
+			    const struct dpll_pin *pin)
+{
+	int netifindex;
+
+	if (dpll_pin_netifindex_get(dpll, pin, &netifindex))
+		return 0;
+	if (nla_put_s32(msg, DPLLA_PIN_NETIFINDEX, netifindex))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+__dpll_cmd_device_dump_one(struct sk_buff *msg, struct dpll_device *dpll)
+{
+	int ret = dpll_msg_add_id(msg, dpll_id(dpll));
+
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_name(msg, dpll_dev_name(dpll));
+
+	return ret;
+}
+
+static int
+__dpll_cmd_pin_dump_one(struct sk_buff *msg, struct dpll_device *dpll,
+			struct dpll_pin *pin)
+{
+	struct dpll_pin *parent = NULL;
+	int ret;
+
+	ret = dpll_msg_add_pin_idx(msg, dpll_pin_idx(dpll, pin));
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_pin_description(msg, dpll_pin_description(pin));
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_pin_type(msg, dpll, pin);
+	if (ret)
+		return ret;
+	parent = dpll_pin_parent(pin);
+	if (parent) {
+		ret = dpll_msg_add_pin_parent_idx(msg, dpll_pin_idx(dpll,
+								    parent));
+		if (ret)
+			return ret;
+	}
+	ret = dpll_msg_add_pin_signal_type(msg, dpll, pin);
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_pin_signal_types_supported(msg, dpll, pin);
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_pin_modes(msg, dpll, pin);
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_pin_modes_supported(msg, dpll, pin);
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_pin_prio(msg, dpll, pin);
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_pin_netifindex(msg, dpll, pin);
+
+	return ret;
+}
+
+static int __dpll_cmd_dump_pins(struct sk_buff *msg, struct dpll_device *dpll)
+{
+	struct dpll_pin *pin;
+	struct nlattr *attr;
+	unsigned long i;
+	int ret = 0;
+
+	for_each_pin_on_dpll(dpll, pin, i) {
+		attr = nla_nest_start(msg, DPLLA_PIN);
+		if (!attr) {
+			ret = -EMSGSIZE;
+			goto nest_cancel;
+		}
+		ret = __dpll_cmd_pin_dump_one(msg, dpll, pin);
+		if (ret)
+			goto nest_cancel;
+		nla_nest_end(msg, attr);
+	}
+
+	return ret;
+
+nest_cancel:
+	nla_nest_cancel(msg, attr);
+	return ret;
+}
+
+static int
+__dpll_cmd_dump_status(struct sk_buff *msg, struct dpll_device *dpll)
+{
+	int ret = dpll_msg_add_source_pin(msg, dpll);
+
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_temp(msg, dpll);
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_lock_status(msg, dpll);
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_mode(msg, dpll);
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_modes_supported(msg, dpll);
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_clock_id(msg, dpll);
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_clock_class(msg, dpll);
+
+	return ret;
+}
+
+static int
+dpll_device_dump_one(struct dpll_device *dpll, struct sk_buff *msg,
+		     int dump_filter)
+{
+	int ret;
+
+	dpll_lock(dpll);
+	ret = __dpll_cmd_device_dump_one(msg, dpll);
+	if (ret)
+		goto out_unlock;
+
+	if (dump_filter & DPLL_FILTER_STATUS) {
+		ret = __dpll_cmd_dump_status(msg, dpll);
+		if (ret) {
+			if (ret != -EMSGSIZE)
+				ret = -EAGAIN;
+			goto out_unlock;
+		}
+	}
+	if (dump_filter & DPLL_FILTER_PINS)
+		ret = __dpll_cmd_dump_pins(msg, dpll);
+	dpll_unlock(dpll);
+
+	return ret;
+out_unlock:
+	dpll_unlock(dpll);
+	return ret;
+}
+
+static int
+dpll_pin_set_from_nlattr(struct dpll_device *dpll,
+			 struct dpll_pin *pin, struct genl_info *info)
+{
+	enum dpll_pin_signal_type st;
+	enum dpll_pin_mode mode;
+	struct nlattr *a;
+	int rem, ret = 0;
+	u32 prio, freq;
+
+	nla_for_each_attr(a, genlmsg_data(info->genlhdr),
+			  genlmsg_len(info->genlhdr), rem) {
+		switch (nla_type(a)) {
+		case DPLLA_PIN_SIGNAL_TYPE:
+			st = nla_get_s32(a);
+			ret = dpll_pin_signal_type_set(dpll, pin, st);
+			if (ret)
+				return ret;
+			break;
+		case DPLLA_PIN_CUSTOM_FREQ:
+			freq = nla_get_u32(a);
+			ret = dpll_pin_custom_freq_set(dpll, pin, freq);
+			if (ret)
+				return ret;
+			break;
+		case DPLLA_PIN_MODE:
+			mode = nla_get_s32(a);
+			ret = dpll_pin_mode_set(dpll, pin, mode);
+			if (ret)
+				return ret;
+			break;
+		case DPLLA_PIN_PRIO:
+			prio = nla_get_u32(a);
+			ret = dpll_pin_prio_set(dpll, pin, prio);
+			if (ret)
+				return ret;
+			break;
+		default:
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static int dpll_cmd_pin_set(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dpll_device *dpll = info->user_ptr[0];
+	struct nlattr **attrs = info->attrs;
+	struct dpll_pin *pin;
+	int pin_id;
+
+	if (!attrs[DPLLA_PIN_IDX])
+		return -EINVAL;
+	pin_id = nla_get_u32(attrs[DPLLA_PIN_IDX]);
+	dpll_lock(dpll);
+	pin = dpll_pin_get_by_idx(dpll, pin_id);
+	dpll_unlock(dpll);
+	if (!pin)
+		return -ENODEV;
+	return dpll_pin_set_from_nlattr(dpll, pin, info);
+}
+
+enum dpll_mode dpll_msg_read_mode(struct nlattr *a)
+{
+	return nla_get_s32(a);
+}
+
+u32 dpll_msg_read_source_pin_id(struct nlattr *a)
+{
+	return nla_get_u32(a);
+}
+
+static int
+dpll_set_from_nlattr(struct dpll_device *dpll, struct genl_info *info)
+{
+	enum dpll_mode m;
+	struct nlattr *a;
+	int rem, ret = 0;
+	u32 source_pin;
+
+	nla_for_each_attr(a, genlmsg_data(info->genlhdr),
+			  genlmsg_len(info->genlhdr), rem) {
+		switch (nla_type(a)) {
+		case DPLLA_MODE:
+			m = dpll_msg_read_mode(a);
+
+			ret = dpll_mode_set(dpll, m);
+			if (ret)
+				return ret;
+			break;
+		case DPLLA_SOURCE_PIN_IDX:
+			source_pin = dpll_msg_read_source_pin_id(a);
+
+			ret = dpll_source_idx_set(dpll, source_pin);
+			if (ret)
+				return ret;
+			break;
+		default:
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static int dpll_cmd_device_set(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dpll_device *dpll = info->user_ptr[0];
+
+	return dpll_set_from_nlattr(dpll, info);
+}
+
+static int
+dpll_cmd_device_dump(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct dpll_dump_ctx *ctx = dpll_dump_context(cb);
+	struct dpll_device *dpll;
+	struct nlattr *hdr;
+	unsigned long i;
+	int ret;
+
+	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			  &dpll_gnl_family, 0, DPLL_CMD_DEVICE_GET);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	for_each_dpll(dpll, i) {
+		ret = dpll_device_dump_one(dpll, skb, ctx->dump_filter);
+		if (ret)
+			break;
+	}
+
+	if (ret)
+		genlmsg_cancel(skb, hdr);
+	else
+		genlmsg_end(skb, hdr);
+
+	return ret;
+}
+
+static int dpll_cmd_device_get(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dpll_device *dpll = info->user_ptr[0];
+	struct nlattr **attrs = info->attrs;
+	struct sk_buff *msg;
+	int dump_filter = 0;
+	struct nlattr *hdr;
+	int ret;
+
+	if (attrs[DPLLA_FILTER])
+		dump_filter = nla_get_s32(attrs[DPLLA_FILTER]);
+
+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+	hdr = genlmsg_put_reply(msg, info, &dpll_gnl_family, 0,
+				DPLL_CMD_DEVICE_GET);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	ret = dpll_device_dump_one(dpll, msg, dump_filter);
+	if (ret)
+		goto out_free_msg;
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_reply(msg, info);
+
+out_free_msg:
+	nlmsg_free(msg);
+	return ret;
+
+}
+
+static int dpll_cmd_device_get_start(struct netlink_callback *cb)
+{
+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
+	struct dpll_dump_ctx *ctx = dpll_dump_context(cb);
+	struct nlattr *attr = info->attrs[DPLLA_FILTER];
+
+	if (attr)
+		ctx->dump_filter = nla_get_s32(attr);
+	else
+		ctx->dump_filter = 0;
+
+	return 0;
+}
+
+static int dpll_pre_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
+			 struct genl_info *info)
+{
+	struct dpll_device *dpll_id = NULL, *dpll_name = NULL;
+
+	if (!info->attrs[DPLLA_ID] &&
+	    !info->attrs[DPLLA_NAME])
+		return -EINVAL;
+
+	if (info->attrs[DPLLA_ID]) {
+		u32 id = nla_get_u32(info->attrs[DPLLA_ID]);
+
+		dpll_id = dpll_device_get_by_id(id);
+		if (!dpll_id)
+			return -ENODEV;
+		info->user_ptr[0] = dpll_id;
+	}
+	if (info->attrs[DPLLA_NAME]) {
+		const char *name = nla_data(info->attrs[DPLLA_NAME]);
+
+		dpll_name = dpll_device_get_by_name(name);
+		if (!dpll_name)
+			return -ENODEV;
+
+		if (dpll_id && dpll_name != dpll_id)
+			return -EINVAL;
+		info->user_ptr[0] = dpll_name;
+	}
+
+	return 0;
+}
+
+static const struct genl_ops dpll_ops[] = {
+	{
+		.cmd	= DPLL_CMD_DEVICE_GET,
+		.flags  = GENL_UNS_ADMIN_PERM,
+		.start	= dpll_cmd_device_get_start,
+		.dumpit	= dpll_cmd_device_dump,
+		.doit	= dpll_cmd_device_get,
+		.policy	= dpll_cmd_device_get_policy,
+		.maxattr = ARRAY_SIZE(dpll_cmd_device_get_policy) - 1,
+	},
+	{
+		.cmd	= DPLL_CMD_DEVICE_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= dpll_cmd_device_set,
+		.policy	= dpll_cmd_device_set_policy,
+		.maxattr = ARRAY_SIZE(dpll_cmd_device_set_policy) - 1,
+	},
+	{
+		.cmd	= DPLL_CMD_PIN_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= dpll_cmd_pin_set,
+		.policy	= dpll_cmd_pin_set_policy,
+		.maxattr = ARRAY_SIZE(dpll_cmd_pin_set_policy) - 1,
+	},
+};
+
+static struct genl_family dpll_family __ro_after_init = {
+	.hdrsize	= 0,
+	.name		= DPLL_FAMILY_NAME,
+	.version	= DPLL_VERSION,
+	.ops		= dpll_ops,
+	.n_ops		= ARRAY_SIZE(dpll_ops),
+	.mcgrps		= dpll_mcgrps,
+	.n_mcgrps	= ARRAY_SIZE(dpll_mcgrps),
+	.pre_doit	= dpll_pre_doit,
+	.parallel_ops   = true,
+};
+
+static int dpll_event_device_id(struct sk_buff *msg, struct dpll_device *dpll)
+{
+	int ret = dpll_msg_add_id(msg, dpll_id(dpll));
+
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_name(msg, dpll_dev_name(dpll));
+
+	return ret;
+}
+
+static int dpll_event_device_change(struct sk_buff *msg,
+				    struct dpll_device *dpll,
+				    struct dpll_pin *pin,
+				    enum dpll_event_change event)
+{
+	int ret = dpll_msg_add_id(msg, dpll_id(dpll));
+
+	if (ret)
+		return ret;
+	ret = nla_put_s32(msg, DPLLA_CHANGE_TYPE, event);
+	if (ret)
+		return ret;
+	switch (event)	{
+	case DPLL_CHANGE_PIN_ADD:
+	case DPLL_CHANGE_PIN_SIGNAL_TYPE:
+	case DPLL_CHANGE_PIN_MODE:
+	case DPLL_CHANGE_PIN_PRIO:
+		ret = dpll_msg_add_pin_idx(msg, dpll_pin_idx(dpll, pin));
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+/*
+ * Generic netlink DPLL event encoding
+ */
+static int dpll_send_event_create(enum dpll_event event,
+				  struct dpll_device *dpll)
+{
+	struct sk_buff *msg;
+	int ret = -EMSGSIZE;
+	void *hdr;
+
+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, 0, 0, &dpll_family, 0, event);
+	if (!hdr)
+		goto out_free_msg;
+
+	ret = dpll_event_device_id(msg, dpll);
+	if (ret)
+		goto out_cancel_msg;
+	genlmsg_end(msg, hdr);
+	genlmsg_multicast(&dpll_family, msg, 0, 0, GFP_KERNEL);
+
+	return 0;
+
+out_cancel_msg:
+	genlmsg_cancel(msg, hdr);
+out_free_msg:
+	nlmsg_free(msg);
+
+	return ret;
+}
+
+/*
+ * Generic netlink DPLL event encoding
+ */
+static int dpll_send_event_change(struct dpll_device *dpll,
+				  struct dpll_pin *pin,
+				  enum dpll_event_change event)
+{
+	struct sk_buff *msg;
+	int ret = -EMSGSIZE;
+	void *hdr;
+
+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, 0, 0, &dpll_family, 0, DPLL_EVENT_DEVICE_CHANGE);
+	if (!hdr)
+		goto out_free_msg;
+
+	ret = dpll_event_device_change(msg, dpll, pin, event);
+	if (ret)
+		goto out_cancel_msg;
+	genlmsg_end(msg, hdr);
+	genlmsg_multicast(&dpll_family, msg, 0, 0, GFP_KERNEL);
+
+	return 0;
+
+out_cancel_msg:
+	genlmsg_cancel(msg, hdr);
+out_free_msg:
+	nlmsg_free(msg);
+
+	return ret;
+}
+
+int dpll_notify_device_create(struct dpll_device *dpll)
+{
+	return dpll_send_event_create(DPLL_EVENT_DEVICE_CREATE, dpll);
+}
+
+int dpll_notify_device_delete(struct dpll_device *dpll)
+{
+	return dpll_send_event_create(DPLL_EVENT_DEVICE_DELETE, dpll);
+}
+
+int dpll_device_notify(struct dpll_device *dpll, enum dpll_event_change event)
+{
+	return dpll_send_event_change(dpll, NULL, event);
+}
+EXPORT_SYMBOL_GPL(dpll_device_notify);
+
+int dpll_pin_notify(struct dpll_device *dpll, struct dpll_pin *pin,
+		    enum dpll_event_change event)
+{
+	return dpll_send_event_change(dpll, pin, event);
+}
+EXPORT_SYMBOL_GPL(dpll_pin_notify);
+
+int __init dpll_netlink_init(void)
+{
+	return genl_register_family(&dpll_family);
+}
+
+void dpll_netlink_finish(void)
+{
+	genl_unregister_family(&dpll_family);
+}
+
+void __exit dpll_netlink_fini(void)
+{
+	dpll_netlink_finish();
+}
diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
new file mode 100644
index 000000000000..8e50b2493027
--- /dev/null
+++ b/drivers/dpll/dpll_netlink.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
+ */
+
+/**
+ * dpll_notify_device_create - notify that the device has been created
+ * @dpll: registered dpll pointer
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_notify_device_create(struct dpll_device *dpll);
+
+
+/**
+ * dpll_notify_device_delete - notify that the device has been deleted
+ * @dpll: registered dpll pointer
+ *
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int dpll_notify_device_delete(struct dpll_device *dpll);
+
+int __init dpll_netlink_init(void);
+void dpll_netlink_finish(void);
diff --git a/include/linux/dpll.h b/include/linux/dpll.h
new file mode 100644
index 000000000000..fcba46ea1b7b
--- /dev/null
+++ b/include/linux/dpll.h
@@ -0,0 +1,282 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
+ */
+
+#ifndef __DPLL_H__
+#define __DPLL_H__
+
+#include <uapi/linux/dpll.h>
+#include <linux/device.h>
+
+struct dpll_device;
+struct dpll_pin;
+
+#define PIN_IDX_INVALID		((u32)ULONG_MAX)
+
+struct dpll_device_ops {
+	int (*mode_get)(const struct dpll_device *dpll, enum dpll_mode *mode);
+	int (*mode_set)(const struct dpll_device *dpll,
+			const enum dpll_mode mode);
+	bool (*mode_supported)(const struct dpll_device *dpll,
+			       const enum dpll_mode mode);
+	int (*source_pin_idx_get)(const struct dpll_device *dpll,
+				  u32 *pin_idx);
+	int (*lock_status_get)(const struct dpll_device *dpll,
+			       enum dpll_lock_status *status);
+	int (*temp_get)(const struct dpll_device *dpll, s32 *temp);
+};
+
+struct dpll_pin_ops {
+	int (*signal_type_get)(const struct dpll_device *dpll,
+			       const struct dpll_pin *pin,
+			       enum dpll_pin_signal_type *type);
+	int (*signal_type_set)(const struct dpll_device *dpll,
+			       const struct dpll_pin *pin,
+			       const enum dpll_pin_signal_type type);
+	bool (*signal_type_supported)(const struct dpll_device *dpll,
+				      const struct dpll_pin *pin,
+				      const enum dpll_pin_signal_type type);
+	int (*custom_freq_set)(const struct dpll_device *dpll,
+			       const struct dpll_pin *pin,
+			       const u32 custom_freq);
+	int (*custom_freq_get)(const struct dpll_device *dpll,
+			       const struct dpll_pin *pin,
+			       u32 *custom_freq);
+	bool (*mode_active)(const struct dpll_device *dpll,
+			     const struct dpll_pin *pin,
+			     const enum dpll_pin_mode mode);
+	int (*mode_enable)(const struct dpll_device *dpll,
+			    const struct dpll_pin *pin,
+			    const enum dpll_pin_mode mode);
+	bool (*mode_supported)(const struct dpll_device *dpll,
+				const struct dpll_pin *pin,
+				const enum dpll_pin_mode mode);
+	int (*prio_get)(const struct dpll_device *dpll,
+			const struct dpll_pin *pin,
+			u32 *prio);
+	int (*prio_set)(const struct dpll_device *dpll,
+			const struct dpll_pin *pin,
+			const u32 prio);
+	int (*net_if_idx_get)(const struct dpll_device *dpll,
+			      const struct dpll_pin *pin,
+			      int *net_if_idx);
+	int (*select)(const struct dpll_device *dpll,
+		      const struct dpll_pin *pin);
+};
+
+/**
+ * dpll_device_alloc - allocate memory for a new dpll_device object
+ * @ops: pointer to dpll operations structure
+ * @type: type of a dpll being allocated
+ * @clock_id: a system unique number for a device
+ * @clock_class: quality class of a DPLL clock
+ * @dev_driver_idx: index of dpll device on parent device
+ * @priv: private data of a registerer
+ * @parent: device structure of a module registering dpll device
+ *
+ * Allocate memory for a new dpll and initialize it with its type, name,
+ * callbacks and private data pointer.
+ *
+ * Name is generated based on: parent driver, type and dev_driver_idx.
+ * Finding allocated and registered dpll device is also possible with
+ * the: clock_id, type and dev_driver_idx. This way dpll device can be
+ * shared by multiple instances of a device driver.
+ *
+ * Returns:
+ * * pointer to initialized dpll - success
+ * * NULL - memory allocation fail
+ */
+struct dpll_device
+*dpll_device_alloc(struct dpll_device_ops *ops, enum dpll_type type,
+		   const u64 clock_id, enum dpll_clock_class clock_class,
+		   u8 dev_driver_idx, void *priv, struct device *parent);
+
+/**
+ * dpll_device_unregister - unregister registered dpll
+ * @dpll: pointer to dpll
+ *
+ * Unregister the dpll from the subsystem, make it unavailable for netlink
+ * API users.
+ */
+void dpll_device_unregister(struct dpll_device *dpll);
+
+/**
+ * dpll_device_free - free dpll memory
+ * @dpll: pointer to dpll
+ *
+ * Free memory allocated with ``dpll_device_alloc(..)``
+ */
+void dpll_device_free(struct dpll_device *dpll);
+
+/**
+ * dpll_priv - get private data
+ * @dpll: pointer to dpll
+ *
+ * Obtain private data pointer passed to dpll subsystem when allocating
+ * device with ``dpll_device_alloc(..)``
+ */
+void *dpll_priv(const struct dpll_device *dpll);
+
+/**
+ * dpll_pin_priv - get private data
+ * @dpll: pointer to dpll
+ *
+ * Obtain private pin data pointer passed to dpll subsystem when pin
+ * was registered with dpll.
+ */
+void *dpll_pin_priv(const struct dpll_device *dpll, const struct dpll_pin *pin);
+
+/**
+ * dpll_pin_idx - get pin idx
+ * @dpll: pointer to dpll
+ * @pin: pointer to a pin
+ *
+ * Obtain pin index of given pin on given dpll.
+ *
+ * Return: PIN_IDX_INVALID - if failed to find pin, otherwise pin index
+ */
+u32 dpll_pin_idx(struct dpll_device *dpll, struct dpll_pin *pin);
+
+/**
+ * dpll_shared_pin_register - share a pin between dpll devices
+ * @dpll_pin_owner: a dpll already registered with a pin
+ * @dpll: a dpll being registered with a pin
+ * @shared_pin_description: identifies pin registered with dpll device
+ *	(@dpll_pin_owner) which is now being registered with new dpll (@dpll)
+ * @ops: struct with pin ops callbacks
+ * @priv: private data pointer passed when calling callback ops
+ *
+ * Register a pin already registered with different dpll device.
+ * Allow to share a single pin within multiple dpll instances.
+ *
+ * Returns:
+ * * 0 - success
+ * * negative - failure
+ */
+int
+dpll_shared_pin_register(struct dpll_device *dpll_pin_owner,
+			 struct dpll_device *dpll,
+			 const char *shared_pin_description,
+			 struct dpll_pin_ops *ops, void *priv);
+
+/**
+ * dpll_pin_alloc - allocate memory for a new dpll_pin object
+ * @description: pointer to string description of a pin with max length
+ * equal to PIN_DESC_LEN
+ * @type: type of allocated pin
+ *
+ * Allocate memory for a new pin and initialize its resources.
+ *
+ * Returns:
+ * * pointer to initialized pin - success
+ * * NULL - memory allocation fail
+ */
+struct dpll_pin *dpll_pin_alloc(const char *description,
+				const enum dpll_pin_type type);
+
+/**
+ * dpll_pin_register - register pin with a dpll device
+ * @dpll: pointer to dpll object to register pin with
+ * @pin: pointer to allocated pin object being registered with dpll
+ * @ops: struct with pin ops callbacks
+ * @priv: private data pointer passed when calling callback ops
+ *
+ * Register previously allocated pin object with a dpll device.
+ *
+ * Return:
+ * * 0 - if pin was registered with a parent pin,
+ * * -ENOMEM - failed to allocate memory,
+ * * -EEXIST - pin already registered with this dpll,
+ * * -EBUSY - couldn't allocate id for a pin.
+ */
+int dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
+		      struct dpll_pin_ops *ops, void *priv);
+
+/**
+ * dpll_pin_deregister - deregister pin from a dpll device
+ * @dpll: pointer to dpll object to deregister pin from
+ * @pin: pointer to allocated pin object being deregistered from dpll
+ *
+ * Deregister previously registered pin object from a dpll device.
+ *
+ * Return:
+ * * 0 - pin was successfully deregistered from this dpll device,
+ * * -ENXIO - given pin was not registered with this dpll device,
+ * * -EINVAL - pin pointer is not valid.
+ */
+int dpll_pin_deregister(struct dpll_device *dpll, struct dpll_pin *pin);
+
+/**
+ * dpll_pin_free - free memory allocated for a pin
+ * @pin: pointer to allocated pin object being freed
+ *
+ * Shared pins must be deregistered from all dpll devices before freeing them,
+ * otherwise the memory won't be freed.
+ */
+void dpll_pin_free(struct dpll_pin *pin);
+
+/**
+ * dpll_muxed_pin_register - register a pin to a muxed-type pin
+ * @parent_pin_description: parent pin description as given on it's allocation
+ * @pin: pointer to allocated pin object being registered with a parent pin
+ * @ops: struct with pin ops callbacks
+ * @priv: private data pointer passed when calling callback ops*
+ *
+ * In case of multiplexed pins, allows registring them under a single
+ * parent pin.
+ *
+ * Return:
+ * * 0 - if pin was registered with a parent pin,
+ * * -ENOMEM - failed to allocate memory,
+ * * -EEXIST - pin already registered with this parent pin,
+ * * -EBUSY - couldn't assign id for a pin.
+ */
+int dpll_muxed_pin_register(struct dpll_device *dpll,
+			    const char *parent_pin_description,
+			    struct dpll_pin *pin,
+			    struct dpll_pin_ops *ops, void *priv);
+
+/**
+ * dpll_device_get_by_clock_id - find a dpll by its clock_id, type and index
+ * @clock_id: clock_id of dpll, as given by driver on ``dpll_device_alloc``
+ * @type: type of dpll, as given by driver on ``dpll_device_alloc``
+ * @idx: index of dpll, as given by driver on ``dpll_device_alloc``
+ *
+ * Allows multiple driver instances using one physical DPLL to find
+ * and share already registered DPLL device.
+ *
+ * Return: pointer if device was found, NULL otherwise.
+ */
+struct dpll_device *dpll_device_get_by_clock_id(u64 clock_id,
+						enum dpll_type type, u8 idx);
+
+/**
+ * dpll_device_notify - notify on dpll device change
+ * @dpll: dpll device pointer
+ * @event: type of change
+ *
+ * Broadcast event to the netlink multicast registered listeners.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - error
+ */
+int dpll_device_notify(struct dpll_device *dpll, enum dpll_event_change event);
+
+/**
+ * dpll_pin_notify - notify on dpll pin change
+ * @dpll: dpll device pointer
+ * @pin: dpll pin pointer
+ * @event: type of change
+ *
+ * Broadcast event to the netlink multicast registered listeners.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - error
+ */
+int dpll_pin_notify(struct dpll_device *dpll, struct dpll_pin *pin,
+		    enum dpll_event_change event);
+
+#endif
diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
new file mode 100644
index 000000000000..b7dbdd814b5c
--- /dev/null
+++ b/include/uapi/linux/dpll.h
@@ -0,0 +1,294 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_DPLL_H
+#define _UAPI_LINUX_DPLL_H
+
+#define DPLL_NAME_LEN		32
+#define DPLL_DESC_LEN		20
+#define DPLL_PIN_DESC_LEN	20
+
+/* Adding event notification support elements */
+#define DPLL_FAMILY_NAME	"dpll"
+#define DPLL_VERSION		0x01
+#define DPLL_MONITOR_GROUP_NAME	"monitor"
+
+#define DPLL_FILTER_PINS	1
+#define DPLL_FILTER_STATUS	2
+
+/* dplla - Attributes of dpll generic netlink family
+ *
+ * @DPLLA_UNSPEC - invalid attribute
+ * @DPLLA_ID - ID of a dpll device (unsigned int)
+ * @DPLLA_NAME - human-readable name (char array of DPLL_NAME_LENGTH size)
+ * @DPLLA_MODE - working mode of dpll (enum dpll_mode)
+ * @DPLLA_MODE_SUPPORTED - list of supported working modes (enum dpll_mode)
+ * @DPLLA_SOURCE_PIN_ID - ID of source pin selected to drive dpll
+ *	(unsigned int)
+ * @DPLLA_LOCK_STATUS - dpll's lock status (enum dpll_lock_status)
+ * @DPLLA_TEMP - dpll's temperature (signed int - Celsius degrees)
+ * @DPLLA_CLOCK_ID - Unique Clock Identifier of dpll (u64)
+ * @DPLLA_CLOCK_CLASS - clock quality class of dpll (enum dpll_clock_class)
+ * @DPLLA_FILTER - filter bitmask for filtering get and dump requests (int,
+ *	sum of DPLL_DUMP_FILTER_* defines)
+ * @DPLLA_PIN - nested attribute, each contains single pin attributes
+ * @DPLLA_PIN_IDX - index of a pin on dpll (unsigned int)
+ * @DPLLA_PIN_DESCRIPTION - human-readable pin description provided by driver
+ *	(char array of PIN_DESC_LEN size)
+ * @DPLLA_PIN_TYPE - current type of a pin (enum dpll_pin_type)
+ * @DPLLA_PIN_SIGNAL_TYPE - current type of a signal
+ *	(enum dpll_pin_signal_type)
+ * @DPLLA_PIN_SIGNAL_TYPE_SUPPORTED - pin signal types supported
+ *	(enum dpll_pin_signal_type)
+ * @DPLLA_PIN_CUSTOM_FREQ - freq value for DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ
+ *	(unsigned int)
+ * @DPLLA_PIN_MODE - state of pin's capabilities (enum dpll_pin_mode)
+ * @DPLLA_PIN_MODE_SUPPORTED - available pin's capabilities
+ *	(enum dpll_pin_mode)
+ * @DPLLA_PIN_PRIO - priority of a pin on dpll (unsigned int)
+ * @DPLLA_PIN_PARENT_IDX - if of a parent pin (unsigned int)
+ * @DPLLA_PIN_NETIFINDEX - related network interface index for the pin
+ * @DPLLA_CHANGE_TYPE - type of device change event
+ *	(enum dpll_change_type)
+ **/
+enum dplla {
+	DPLLA_UNSPEC,
+	DPLLA_ID,
+	DPLLA_NAME,
+	DPLLA_MODE,
+	DPLLA_MODE_SUPPORTED,
+	DPLLA_SOURCE_PIN_IDX,
+	DPLLA_LOCK_STATUS,
+	DPLLA_TEMP,
+	DPLLA_CLOCK_ID,
+	DPLLA_CLOCK_CLASS,
+	DPLLA_FILTER,
+	DPLLA_PIN,
+	DPLLA_PIN_IDX,
+	DPLLA_PIN_DESCRIPTION,
+	DPLLA_PIN_TYPE,
+	DPLLA_PIN_SIGNAL_TYPE,
+	DPLLA_PIN_SIGNAL_TYPE_SUPPORTED,
+	DPLLA_PIN_CUSTOM_FREQ,
+	DPLLA_PIN_MODE,
+	DPLLA_PIN_MODE_SUPPORTED,
+	DPLLA_PIN_PRIO,
+	DPLLA_PIN_PARENT_IDX,
+	DPLLA_PIN_NETIFINDEX,
+	DPLLA_CHANGE_TYPE,
+	__DPLLA_MAX,
+};
+
+#define DPLLA_MAX (__DPLLA_MAX - 1)
+
+/* dpll_lock_status - DPLL status provides information of device status
+ *
+ * @DPLL_LOCK_STATUS_UNSPEC - unspecified value
+ * @DPLL_LOCK_STATUS_UNLOCKED - dpll was not yet locked to any valid (or is in
+ *	DPLL_MODE_FREERUN/DPLL_MODE_NCO modes)
+ * @DPLL_LOCK_STATUS_CALIBRATING - dpll is trying to lock to a valid signal
+ * @DPLL_LOCK_STATUS_LOCKED - dpll is locked
+ * @DPLL_LOCK_STATUS_HOLDOVER - dpll is in holdover state - lost a valid lock
+ *	or was forced by DPLL_MODE_HOLDOVER mode)
+ **/
+enum dpll_lock_status {
+	DPLL_LOCK_STATUS_UNSPEC,
+	DPLL_LOCK_STATUS_UNLOCKED,
+	DPLL_LOCK_STATUS_CALIBRATING,
+	DPLL_LOCK_STATUS_LOCKED,
+	DPLL_LOCK_STATUS_HOLDOVER,
+
+	__DPLL_LOCK_STATUS_MAX,
+};
+
+#define DPLL_LOCK_STATUS_MAX (__DPLL_LOCK_STATUS_MAX - 1)
+
+/* dpll_pin_type - signal types
+ *
+ * @DPLL_PIN_TYPE_UNSPEC - unspecified value
+ * @DPLL_PIN_TYPE_MUX - mux type pin, aggregates selectable pins
+ * @DPLL_PIN_TYPE_EXT - external source
+ * @DPLL_PIN_TYPE_SYNCE_ETH_PORT - ethernet port PHY's recovered clock
+ * @DPLL_PIN_TYPE_INT_OSCILLATOR - device internal oscillator
+ * @DPLL_PIN_TYPE_GNSS - GNSS recovered clock
+ **/
+enum dpll_pin_type {
+	DPLL_PIN_TYPE_UNSPEC,
+	DPLL_PIN_TYPE_MUX,
+	DPLL_PIN_TYPE_EXT,
+	DPLL_PIN_TYPE_SYNCE_ETH_PORT,
+	DPLL_PIN_TYPE_INT_OSCILLATOR,
+	DPLL_PIN_TYPE_GNSS,
+
+	__DPLL_PIN_TYPE_MAX,
+};
+
+#define DPLL_PIN_TYPE_MAX (__DPLL_PIN_TYPE_MAX - 1)
+
+/* dpll_pin_signal_type - signal types
+ *
+ * @DPLL_PIN_SIGNAL_TYPE_UNSPEC - unspecified value
+ * @DPLL_PIN_SIGNAL_TYPE_1_PPS - a 1Hz signal
+ * @DPLL_PIN_SIGNAL_TYPE_10_MHZ - a 10 MHz signal
+ * @DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ - custom frequency signal, value defined
+ *	with pin's DPLLA_PIN_SIGNAL_TYPE_CUSTOM_FREQ attribute
+ **/
+enum dpll_pin_signal_type {
+	DPLL_PIN_SIGNAL_TYPE_UNSPEC,
+	DPLL_PIN_SIGNAL_TYPE_1_PPS,
+	DPLL_PIN_SIGNAL_TYPE_10_MHZ,
+	DPLL_PIN_SIGNAL_TYPE_CUSTOM_FREQ,
+
+	__DPLL_PIN_SIGNAL_TYPE_MAX,
+};
+
+#define DPLL_PIN_SIGNAL_TYPE_MAX (__DPLL_PIN_SIGNAL_TYPE_MAX - 1)
+
+/* dpll_pin_mode - available pin states
+ *
+ * @DPLL_PIN_MODE_UNSPEC - unspecified value
+ * @DPLL_PIN_MODE_CONNECTED - pin connected
+ * @DPLL_PIN_MODE_DISCONNECTED - pin disconnected
+ * @DPLL_PIN_MODE_SOURCE - pin used as an input pin
+ * @DPLL_PIN_MODE_OUTPUT - pin used as an output pin
+ **/
+enum dpll_pin_mode {
+	DPLL_PIN_MODE_UNSPEC,
+	DPLL_PIN_MODE_CONNECTED,
+	DPLL_PIN_MODE_DISCONNECTED,
+	DPLL_PIN_MODE_SOURCE,
+	DPLL_PIN_MODE_OUTPUT,
+
+	__DPLL_PIN_MODE_MAX,
+};
+
+#define DPLL_PIN_MODE_MAX (__DPLL_PIN_MODE_MAX - 1)
+
+/**
+ * dpll_event - Events of dpll generic netlink family
+ *
+ * @DPLL_EVENT_UNSPEC - invalid event type
+ * @DPLL_EVENT_DEVICE_CREATE - dpll device created
+ * @DPLL_EVENT_DEVICE_DELETE - dpll device deleted
+ * @DPLL_EVENT_DEVICE_CHANGE - attribute of dpll device or pin changed
+ **/
+enum dpll_event {
+	DPLL_EVENT_UNSPEC,
+	DPLL_EVENT_DEVICE_CREATE,
+	DPLL_EVENT_DEVICE_DELETE,
+	DPLL_EVENT_DEVICE_CHANGE,
+
+	__DPLL_EVENT_MAX,
+};
+
+#define DPLL_EVENT_MAX (__DPLL_EVENT_MAX - 1)
+
+/**
+ * dpll_change_type - values of events in case of device change event
+ * (DPLL_EVENT_DEVICE_CHANGE)
+ *
+ * @DPLL_CHANGE_UNSPEC - invalid event type
+ * @DPLL_CHANGE_MODE - mode changed
+ * @DPLL_CHANGE_LOCK_STATUS - lock status changed
+ * @DPLL_CHANGE_SOURCE_PIN - source pin changed,
+ * @DPLL_CHANGE_TEMP - temperature changed
+ * @DPLL_CHANGE_PIN_ADD - source pin added,
+ * @DPLL_CHANGE_PIN_DEL - source pin deleted,
+ * @DPLL_CHANGE_PIN_SIGNAL_TYPE pin signal type changed
+ * @DPLL_CHANGE_PIN_CUSTOM_FREQ custom frequency changed
+ * @DPLL_CHANGE_PIN_MODE - pin state changed
+ * @DPLL_CHANGE_PIN_PRIO - pin prio changed
+ **/
+enum dpll_event_change {
+	DPLL_CHANGE_UNSPEC,
+	DPLL_CHANGE_MODE,
+	DPLL_CHANGE_LOCK_STATUS,
+	DPLL_CHANGE_SOURCE_PIN,
+	DPLL_CHANGE_TEMP,
+	DPLL_CHANGE_PIN_ADD,
+	DPLL_CHANGE_PIN_DEL,
+	DPLL_CHANGE_PIN_SIGNAL_TYPE,
+	DPLL_CHANGE_PIN_CUSTOM_FREQ,
+	DPLL_CHANGE_PIN_MODE,
+	DPLL_CHANGE_PIN_PRIO,
+
+	__DPLL_CHANGE_MAX,
+};
+
+#define DPLL_CHANGE_MAX (__DPLL_CHANGE_MAX - 1)
+
+/**
+ * dpll_cmd - Commands supported by the dpll generic netlink family
+ *
+ * @DPLL_CMD_UNSPEC - invalid message type
+ * @DPLL_CMD_DEVICE_GET - Get list of dpll devices (dump) or attributes of
+ *	single dpll device and it's pins
+ * @DPLL_CMD_DEVICE_SET - Set attributes for a dpll
+ * @DPLL_CMD_PIN_SET - Set attributes for a pin
+ **/
+enum dpll_cmd {
+	DPLL_CMD_UNSPEC,
+	DPLL_CMD_DEVICE_GET,
+	DPLL_CMD_DEVICE_SET,
+	DPLL_CMD_PIN_SET,
+
+	__DPLL_CMD_MAX,
+};
+
+#define DPLL_CMD_MAX (__DPLL_CMD_MAX - 1)
+
+/**
+ * dpll_mode - Working-modes a dpll can support. Modes differentiate how
+ * dpll selects one of its sources to syntonize with a source.
+ *
+ * @DPLL_MODE_UNSPEC - invalid
+ * @DPLL_MODE_MANUAL - source can be only selected by sending a request to dpll
+ * @DPLL_MODE_AUTOMATIC - highest prio, valid source, auto selected by dpll
+ * @DPLL_MODE_HOLDOVER - dpll forced into holdover mode
+ * @DPLL_MODE_FREERUN - dpll driven on system clk, no holdover available
+ * @DPLL_MODE_NCO - dpll driven by Numerically Controlled Oscillator
+ **/
+enum dpll_mode {
+	DPLL_MODE_UNSPEC,
+	DPLL_MODE_MANUAL,
+	DPLL_MODE_AUTOMATIC,
+	DPLL_MODE_HOLDOVER,
+	DPLL_MODE_FREERUN,
+	DPLL_MODE_NCO,
+
+	__DPLL_MODE_MAX,
+};
+
+#define DPLL_MODE_MAX (__DPLL_MODE_MAX - 1)
+
+/**
+ * dpll_clock_class - enumerate quality class of a DPLL clock as specified in
+ * Recommendation ITU-T G.8273.2/Y.1368.2.
+ */
+enum dpll_clock_class {
+	DPLL_CLOCK_CLASS_UNSPEC,
+	DPLL_CLOCK_CLASS_A,
+	DPLL_CLOCK_CLASS_B,
+	DPLL_CLOCK_CLASS_C,
+
+	__DPLL_CLOCK_CLASS_MAX,
+};
+
+#define DPLL_CLOCK_CLASS_MAX (__DPLL_CLOCK_CLASS_MAX - 1)
+
+/**
+ * enum dpll_type - type of dpll, integer value of enum is embedded into
+ * name of DPLL device (DPLLA_NAME)
+ *
+ * @DPLL_TYPE_UNSPEC - unspecified
+ * @DPLL_TYPE_PPS - dpll produces Pulse-Per-Second signal
+ * @DPLL_TYPE_EEC - dpll drives the Ethernet Equipment Clock
+ */
+enum dpll_type {
+	DPLL_TYPE_UNSPEC,
+	DPLL_TYPE_PPS,
+	DPLL_TYPE_EEC,
+
+	__DPLL_TYPE_MAX
+};
+#define DPLL_TYPE_MAX	(__DPLL_TYPE_MAX - 1)
+
+#endif /* _UAPI_LINUX_DPLL_H */
-- 
2.30.2

