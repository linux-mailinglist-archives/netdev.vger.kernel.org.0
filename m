Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A5C6B62F3
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 03:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjCLC3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 21:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjCLC24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 21:28:56 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A52337B59;
        Sat, 11 Mar 2023 18:28:50 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32C1t84P007044;
        Sat, 11 Mar 2023 18:28:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=WPsDgeAtCvjGtX9crbAP7ull+4GUVUzgCssN9hhWiDY=;
 b=S8Yq3JQhQldtc3R8f0pVlbE0YCDrm38Za1IFYUlnKhtO1jRe75irqvA2HxT2ZwpUNsDw
 HRRn1lauG30mM5YhVaZTS6pH0JRdaJGEwAnyPno0FKzCn+ckWeQjQefTQpxemM1zMRkf
 Nteb4GmIHkhMfQspimezeHOus1HRRIXtcHZTR5D0ztm/MMpWWF6jsoU6W+6bRqf9oO95
 obWRJBt+UpycBAm8JmiRLYWN0C/8R+ryW1sK2NQqGmRSe2C00l6xUDL4+gpNj/VS+hap
 NMHJCn/s5UnwFhN5kniEKMzK0DSx20tl7OWMfO9uvHDwQOnr21u58QThS9FqAgcyLC8e 8A== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3p8suap7p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 11 Mar 2023 18:28:26 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Sat, 11 Mar 2023 18:28:24 -0800
Received: from devvm1736.cln0.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server id
 15.1.2507.17; Sat, 11 Mar 2023 18:28:23 -0800
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Vadim Fedorenko <vadfed@meta.com>, <poros@redhat.com>,
        <mschmidt@redhat.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-clk@vger.kernel.org>, Milena Olech <milena.olech@intel.com>,
        "Michal Michalik" <michal.michalik@intel.com>
Subject: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Date:   Sat, 11 Mar 2023 18:28:03 -0800
Message-ID: <20230312022807.278528-3-vadfed@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230312022807.278528-1-vadfed@meta.com>
References: <20230312022807.278528-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::d]
X-Proofpoint-GUID: 7q7wqjAWW9mDF567ob5R297I7ccpAawX
X-Proofpoint-ORIG-GUID: 7q7wqjAWW9mDF567ob5R297I7ccpAawX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-11_04,2023-03-10_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
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

Changes:
dpll: adapt changes after introduction of dpll yaml spec
dpll: redesign after review comments, fix minor issues
dpll: add get pin command
dpll: _get/_put approach for creating and realesing pin or dpll objects
dpll: lock access to dplls with global lock
dpll: lock access to pins with global lock

dpll: replace cookie with clock id
dpll: add clock class

Provide userspace with clock class value of DPLL with dpll device dump
netlink request. Clock class is assigned by driver allocating a dpll
device. Clock class values are defined as specified in:
ITU-T G.8273.2/Y.1368.2 recommendation.

dpll: follow one naming schema in dpll subsys

dpll: fix dpll device naming scheme

Fix dpll device naming scheme by use of new pattern.
"dpll_%s_%d_%d", where:
- %s - dev_name(parent) of parent device,
- %d (1) - enum value of dpll type,
- %d (2) - device index provided by parent device.

dpll: remove description length parameter

dpll: fix muxed/shared pin registration

Let the kernel module to register a shared or muxed pin without finding
it or its parent. Instead use a parent/shared pin description to find
correct pin internally in dpll_core, simplifing a dpll API.

dpll: move function comments to dpll_core.c, fix exports
dpll: remove single-use helper functions
dpll: merge device register with alloc
dpll: lock and unlock mutex on dpll device release
dpll: move dpll_type to uapi header
dpll: rename DPLLA_DUMP_FILTER to DPLLA_FILTER
dpll: rename dpll_pin_state to dpll_pin_mode
dpll: rename DPLL_MODE_FORCED to DPLL_MODE_MANUAL
dpll: remove DPLL_CHANGE_PIN_TYPE enum value

Co-developed-by: Milena Olech <milena.olech@intel.com>
Signed-off-by: Milena Olech <milena.olech@intel.com>
Co-developed-by: Michal Michalik <michal.michalik@intel.com>
Signed-off-by: Michal Michalik <michal.michalik@intel.com>
Co-developed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
---
 MAINTAINERS                 |    9 +
 drivers/Kconfig             |    2 +
 drivers/Makefile            |    1 +
 drivers/dpll/Kconfig        |    7 +
 drivers/dpll/Makefile       |   10 +
 drivers/dpll/dpll_core.c    |  835 +++++++++++++++++++++++++++
 drivers/dpll/dpll_core.h    |   99 ++++
 drivers/dpll/dpll_netlink.c | 1065 +++++++++++++++++++++++++++++++++++
 drivers/dpll/dpll_netlink.h |   30 +
 include/linux/dpll.h        |  284 ++++++++++
 10 files changed, 2342 insertions(+)
 create mode 100644 drivers/dpll/Kconfig
 create mode 100644 drivers/dpll/Makefile
 create mode 100644 drivers/dpll/dpll_core.c
 create mode 100644 drivers/dpll/dpll_core.h
 create mode 100644 drivers/dpll/dpll_netlink.c
 create mode 100644 drivers/dpll/dpll_netlink.h
 create mode 100644 include/linux/dpll.h

diff --git a/MAINTAINERS b/MAINTAINERS
index edd3d562beee..0222b19af545 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6289,6 +6289,15 @@ F:	Documentation/networking/device_drivers/ethernet/freescale/dpaa2/switch-drive
 F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-switch*
 F:	drivers/net/ethernet/freescale/dpaa2/dpsw*
 
+DPLL CLOCK SUBSYSTEM
+M:	Vadim Fedorenko <vadim.fedorenko@linux.dev>
+M:	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
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
index 20b118dca999..9ffb554507ef 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -194,3 +194,4 @@ obj-$(CONFIG_MOST)		+= most/
 obj-$(CONFIG_PECI)		+= peci/
 obj-$(CONFIG_HTE)		+= hte/
 obj-$(CONFIG_DRM_ACCEL)		+= accel/
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
index 000000000000..d3926f2a733d
--- /dev/null
+++ b/drivers/dpll/Makefile
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for DPLL drivers.
+#
+
+obj-$(CONFIG_DPLL)          += dpll_sys.o
+dpll_sys-y                  += dpll_core.o
+dpll_sys-y                  += dpll_netlink.o
+dpll_sys-y                  += dpll_nl.o
+
diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
new file mode 100644
index 000000000000..3fc151e16751
--- /dev/null
+++ b/drivers/dpll/dpll_core.c
@@ -0,0 +1,835 @@
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
+DEFINE_MUTEX(dpll_device_xa_lock);
+DEFINE_MUTEX(dpll_pin_xa_lock);
+
+DEFINE_XARRAY_FLAGS(dpll_device_xa, XA_FLAGS_ALLOC);
+DEFINE_XARRAY_FLAGS(dpll_pin_xa, XA_FLAGS_ALLOC);
+
+#define ASSERT_DPLL_REGISTERED(d)                                          \
+	WARN_ON_ONCE(!xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
+#define ASSERT_DPLL_NOT_REGISTERED(d)                                      \
+	WARN_ON_ONCE(xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
+
+static struct class dpll_class = {
+	.name = "dpll",
+};
+
+/**
+ * dpll_device_get_by_id - find dpll device by it's id
+ * @id: id of searched dpll
+ *
+ * Return:
+ * * dpll_device struct if found
+ * * NULL otherwise
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
+ * @bus_name: bus name of searched dpll
+ * @dev_name: dev name of searched dpll
+ *
+ * Return:
+ * * dpll_device struct if found
+ * * NULL otherwise
+ */
+struct dpll_device *
+dpll_device_get_by_name(const char *bus_name, const char *device_name)
+{
+	struct dpll_device *dpll, *ret = NULL;
+	unsigned long index;
+
+	xa_for_each_marked(&dpll_device_xa, index, dpll, DPLL_REGISTERED) {
+		if (!strcmp(dev_bus_name(&dpll->dev), bus_name) &&
+		    !strcmp(dev_name(&dpll->dev), device_name)) {
+			ret = dpll;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+/**
+ * dpll_xa_ref_pin_add - add pin reference to a given xarray
+ * @xa_pins: dpll_pin_ref xarray holding pins
+ * @pin: pin being added
+ * @ops: ops for a pin
+ * @priv: pointer to private data of owner
+ *
+ * Allocate and create reference of a pin or increase refcount on existing pin
+ * reference on given xarray.
+ *
+ * Return:
+ * * 0 on success
+ * * -ENOMEM on failed allocation
+ */
+static int
+dpll_xa_ref_pin_add(struct xarray *xa_pins, struct dpll_pin *pin,
+		    struct dpll_pin_ops *ops, void *priv)
+{
+	struct dpll_pin_ref *ref;
+	unsigned long i;
+	u32 idx;
+	int ret;
+
+	xa_for_each(xa_pins, i, ref) {
+		if (ref->pin == pin) {
+			refcount_inc(&ref->refcount);
+			return 0;
+		}
+	}
+
+	ref = kzalloc(sizeof(*ref), GFP_KERNEL);
+	if (!ref)
+		return -ENOMEM;
+	ref->pin = pin;
+	ref->ops = ops;
+	ref->priv = priv;
+	ret = xa_alloc(xa_pins, &idx, ref, xa_limit_16b, GFP_KERNEL);
+	if (!ret)
+		refcount_set(&ref->refcount, 1);
+	else
+		kfree(ref);
+
+	return ret;
+}
+
+/**
+ * dpll_xa_ref_pin_del - remove reference of a pin from xarray
+ * @xa_pins: dpll_pin_ref xarray holding pins
+ * @pin: pointer to a pin
+ *
+ * Decrement refcount of existing pin reference on given xarray.
+ * If all references are dropped, delete the reference and free its memory.
+ *
+ * Return:
+ * * 0 on success
+ * * -EINVAL if reference to a pin was not found
+ */
+static int dpll_xa_ref_pin_del(struct xarray *xa_pins, struct dpll_pin *pin)
+{
+	struct dpll_pin_ref *ref;
+	unsigned long i;
+
+	xa_for_each(xa_pins, i, ref) {
+		if (ref->pin == pin) {
+			if (refcount_dec_and_test(&ref->refcount)) {
+				xa_erase(xa_pins, i);
+				kfree(ref);
+			}
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+/**
+ * dpll_xa_ref_pin_find - find pin reference on xarray
+ * @xa_pins: dpll_pin_ref xarray holding pins
+ * @pin: pointer to a pin
+ *
+ * Search for pin reference struct of a given pin on given xarray.
+ *
+ * Return:
+ * * pin reference struct pointer on success
+ * * NULL - reference to a pin was not found
+ */
+struct dpll_pin_ref *
+dpll_xa_ref_pin_find(struct xarray *xa_pins, const struct dpll_pin *pin)
+{
+	struct dpll_pin_ref *ref;
+	unsigned long i;
+
+	xa_for_each(xa_pins, i, ref) {
+		if (ref->pin == pin)
+			return ref;
+	}
+
+	return NULL;
+}
+
+/**
+ * dpll_xa_ref_dpll_add - add dpll reference to a given xarray
+ * @xa_dplls: dpll_pin_ref xarray holding dplls
+ * @dpll: dpll being added
+ * @ops: pin-reference ops for a dpll
+ * @priv: pointer to private data of owner
+ *
+ * Allocate and create reference of a dpll-pin ops or increase refcount
+ * on existing dpll reference on given xarray.
+ *
+ * Return:
+ * * 0 on success
+ * * -ENOMEM on failed allocation
+ */
+static int
+dpll_xa_ref_dpll_add(struct xarray *xa_dplls, struct dpll_device *dpll,
+		     struct dpll_pin_ops *ops, void *priv)
+{
+	struct dpll_pin_ref *ref;
+	unsigned long i;
+	u32 idx;
+	int ret;
+
+	xa_for_each(xa_dplls, i, ref) {
+		if (ref->dpll == dpll) {
+			refcount_inc(&ref->refcount);
+			return 0;
+		}
+	}
+	ref = kzalloc(sizeof(*ref), GFP_KERNEL);
+	if (!ref)
+		return -ENOMEM;
+	ref->dpll = dpll;
+	ref->ops = ops;
+	ref->priv = priv;
+	ret = xa_alloc(xa_dplls, &idx, ref, xa_limit_16b, GFP_KERNEL);
+	if (!ret)
+		refcount_set(&ref->refcount, 1);
+	else
+		kfree(ref);
+
+	return ret;
+}
+
+/**
+ * dpll_xa_ref_dpll_del - remove reference of a dpll from xarray
+ * @xa_dplls: dpll_pin_ref xarray holding dplls
+ * @dpll: pointer to a dpll to remove
+ *
+ * Decrement refcount of existing dpll reference on given xarray.
+ * If all references are dropped, delete the reference and free its memory.
+ */
+static void
+dpll_xa_ref_dpll_del(struct xarray *xa_dplls, struct dpll_device *dpll)
+{
+	struct dpll_pin_ref *ref;
+	unsigned long i;
+
+	xa_for_each(xa_dplls, i, ref) {
+		if (ref->dpll == dpll) {
+			if (refcount_dec_and_test(&ref->refcount)) {
+				xa_erase(xa_dplls, i);
+				kfree(ref);
+			}
+			break;
+		}
+	}
+}
+
+/**
+ * dpll_xa_ref_dpll_find - find dpll reference on xarray
+ * @xa_dplls: dpll_pin_ref xarray holding dplls
+ * @dpll: pointer to a dpll
+ *
+ * Search for dpll-pin ops reference struct of a given dpll on given xarray.
+ *
+ * Return:
+ * * pin reference struct pointer on success
+ * * NULL - reference to a pin was not found
+ */
+struct dpll_pin_ref *
+dpll_xa_ref_dpll_find(struct xarray *xa_refs, const struct dpll_device *dpll)
+{
+	struct dpll_pin_ref *ref;
+	unsigned long i;
+
+	xa_for_each(xa_refs, i, ref) {
+		if (ref->dpll == dpll)
+			return ref;
+	}
+
+	return NULL;
+}
+
+
+/**
+ * dpll_device_alloc - allocate the memory for dpll device
+ * @clock_id: clock_id of creator
+ * @dev_driver_id: id given by dev driver
+ * @module: reference to registering module
+ *
+ * Allocates memory and initialize dpll device, hold its reference on global
+ * xarray.
+ *
+ * Return:
+ * * dpll_device struct pointer if succeeded
+ * * ERR_PTR(X) - failed allocation
+ */
+struct dpll_device *
+dpll_device_alloc(const u64 clock_id, u32 dev_driver_id, struct module *module)
+{
+	struct dpll_device *dpll;
+	int ret;
+
+	dpll = kzalloc(sizeof(*dpll), GFP_KERNEL);
+	if (!dpll)
+		return ERR_PTR(-ENOMEM);
+	refcount_set(&dpll->refcount, 1);
+	dpll->dev.class = &dpll_class;
+	dpll->dev_driver_id = dev_driver_id;
+	dpll->clock_id = clock_id;
+	dpll->module = module;
+	ret = xa_alloc(&dpll_device_xa, &dpll->id, dpll,
+		       xa_limit_16b, GFP_KERNEL);
+	if (ret) {
+		kfree(dpll);
+		return ERR_PTR(ret);
+	}
+	xa_init_flags(&dpll->pin_refs, XA_FLAGS_ALLOC);
+
+	return dpll;
+}
+
+/**
+ * dpll_device_get - find existing or create new dpll device
+ * @clock_id: clock_id of creator
+ * @dev_driver_id: id given by dev driver
+ * @module: reference to registering module
+ *
+ * Get existing object of a dpll device, unique for given arguments.
+ * Create new if doesn't exist yet.
+ *
+ * Return:
+ * * valid dpll_device struct pointer if succeeded
+ * * ERR_PTR of an error
+ */
+struct dpll_device *
+dpll_device_get(u64 clock_id, u32 dev_driver_id, struct module *module)
+{
+	struct dpll_device *dpll, *ret = NULL;
+	unsigned long index;
+
+	mutex_lock(&dpll_device_xa_lock);
+	xa_for_each(&dpll_device_xa, index, dpll) {
+		if (dpll->clock_id == clock_id &&
+		    dpll->dev_driver_id == dev_driver_id &&
+		    dpll->module == module) {
+			ret = dpll;
+			refcount_inc(&ret->refcount);
+			break;
+		}
+	}
+	if (!ret)
+		ret = dpll_device_alloc(clock_id, dev_driver_id, module);
+	mutex_unlock(&dpll_device_xa_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dpll_device_get);
+
+/**
+ * dpll_device_put - decrease the refcount and free memory if possible
+ * @dpll: dpll_device struct pointer
+ *
+ * Drop reference for a dpll device, if all references are gone, delete
+ * dpll device object.
+ */
+void dpll_device_put(struct dpll_device *dpll)
+{
+	if (!dpll)
+		return;
+	mutex_lock(&dpll_device_xa_lock);
+	if (refcount_dec_and_test(&dpll->refcount)) {
+		WARN_ON_ONCE(!xa_empty(&dpll->pin_refs));
+		xa_destroy(&dpll->pin_refs);
+		xa_erase(&dpll_device_xa, dpll->id);
+		kfree(dpll);
+	}
+	mutex_unlock(&dpll_device_xa_lock);
+}
+EXPORT_SYMBOL_GPL(dpll_device_put);
+
+/**
+ * dpll_device_register - register the dpll device in the subsystem
+ * @dpll: pointer to a dpll
+ * @type: type of a dpll
+ * @ops: ops for a dpll device
+ * @priv: pointer to private information of owner
+ * @owner: pointer to owner device
+ *
+ * Make dpll device available for user space.
+ *
+ * Return:
+ * * 0 on success
+ * * -EINVAL on failure
+ */
+int dpll_device_register(struct dpll_device *dpll, enum dpll_type type,
+			 struct dpll_device_ops *ops, void *priv,
+			 struct device *owner)
+{
+	if (WARN_ON(!ops || !owner))
+		return -EINVAL;
+	if (WARN_ON(type <= DPLL_TYPE_UNSPEC || type > DPLL_TYPE_MAX))
+		return -EINVAL;
+	mutex_lock(&dpll_device_xa_lock);
+	if (ASSERT_DPLL_NOT_REGISTERED(dpll)) {
+		mutex_unlock(&dpll_device_xa_lock);
+		return -EEXIST;
+	}
+	dpll->dev.bus = owner->bus;
+	dpll->parent = owner;
+	dpll->type = type;
+	dpll->ops = ops;
+	dev_set_name(&dpll->dev, "%s_%d", dev_name(owner),
+		     dpll->dev_driver_id);
+	dpll->priv = priv;
+	xa_set_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
+	mutex_unlock(&dpll_device_xa_lock);
+	dpll_notify_device_create(dpll);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_device_register);
+
+/**
+ * dpll_device_unregister - deregister dpll device
+ * @dpll: registered dpll pointer
+ *
+ * Deregister device, make it unavailable for userspace.
+ * Note: It does not free the memory
+ */
+void dpll_device_unregister(struct dpll_device *dpll)
+{
+	mutex_lock(&dpll_device_xa_lock);
+	ASSERT_DPLL_REGISTERED(dpll);
+	xa_clear_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
+	mutex_unlock(&dpll_device_xa_lock);
+	dpll_notify_device_delete(dpll);
+}
+EXPORT_SYMBOL_GPL(dpll_device_unregister);
+
+/**
+ * dpll_pin_alloc - allocate the memory for dpll pin
+ * @clock_id: clock_id of creator
+ * @dev_driver_id: id given by dev driver
+ * @module: reference to registering module
+ * @prop: dpll pin properties
+ *
+ * Return:
+ * * valid allocated dpll_pin struct pointer if succeeded
+ * * ERR_PTR of an error
+ */
+struct dpll_pin *
+dpll_pin_alloc(u64 clock_id, u8 device_drv_id,	struct module *module,
+	       const struct dpll_pin_properties *prop)
+{
+	struct dpll_pin *pin;
+	int ret;
+
+	pin = kzalloc(sizeof(*pin), GFP_KERNEL);
+	if (!pin)
+		return ERR_PTR(-ENOMEM);
+	pin->dev_driver_id = device_drv_id;
+	pin->clock_id = clock_id;
+	pin->module = module;
+	refcount_set(&pin->refcount, 1);
+	if (WARN_ON(!prop->description)) {
+		ret = -EINVAL;
+		goto release;
+	}
+	pin->prop.description = kstrdup(prop->description, GFP_KERNEL);
+	if (!pin->prop.description) {
+		ret = -ENOMEM;
+		goto release;
+	}
+	if (WARN_ON(prop->type <= DPLL_PIN_TYPE_UNSPEC ||
+		    prop->type > DPLL_PIN_TYPE_MAX)) {
+		ret = -EINVAL;
+		goto release;
+	}
+	pin->prop.type = prop->type;
+	pin->prop.capabilities = prop->capabilities;
+	pin->prop.freq_supported = prop->freq_supported;
+	pin->prop.any_freq_min = prop->any_freq_min;
+	pin->prop.any_freq_max = prop->any_freq_max;
+	xa_init_flags(&pin->dpll_refs, XA_FLAGS_ALLOC);
+	xa_init_flags(&pin->parent_refs, XA_FLAGS_ALLOC);
+	ret = xa_alloc(&dpll_pin_xa, &pin->idx, pin,
+		       xa_limit_16b, GFP_KERNEL);
+release:
+	if (ret) {
+		xa_destroy(&pin->dpll_refs);
+		xa_destroy(&pin->parent_refs);
+		kfree(pin->prop.description);
+		kfree(pin->rclk_dev_name);
+		kfree(pin);
+		return ERR_PTR(ret);
+	}
+
+	return pin;
+}
+
+/**
+ * dpll_pin_get - find existing or create new dpll pin
+ * @clock_id: clock_id of creator
+ * @dev_driver_id: id given by dev driver
+ * @module: reference to registering module
+ * @prop: dpll pin properties
+ *
+ * Get existing object of a pin (unique for given arguments) or create new
+ * if doesn't exist yet.
+ *
+ * Return:
+ * * valid allocated dpll_pin struct pointer if succeeded
+ * * ERR_PTR of an error
+ */
+struct dpll_pin *
+dpll_pin_get(u64 clock_id, u32 device_drv_id, struct module *module,
+	     const struct dpll_pin_properties *prop)
+{
+	struct dpll_pin *pos, *ret = NULL;
+	unsigned long index;
+
+	mutex_lock(&dpll_pin_xa_lock);
+	xa_for_each(&dpll_pin_xa, index, pos) {
+		if (pos->clock_id == clock_id &&
+		    pos->dev_driver_id == device_drv_id &&
+		    pos->module == module) {
+			ret = pos;
+			refcount_inc(&ret->refcount);
+			break;
+		}
+	}
+	if (!ret)
+		ret = dpll_pin_alloc(clock_id, device_drv_id, module, prop);
+	mutex_unlock(&dpll_pin_xa_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_get);
+
+/**
+ * dpll_pin_put - decrease the refcount and free memory if possible
+ * @dpll: dpll_device struct pointer
+ *
+ * Drop reference for a pin, if all references are gone, delete pin object.
+ */
+void dpll_pin_put(struct dpll_pin *pin)
+{
+	if (!pin)
+		return;
+	mutex_lock(&dpll_pin_xa_lock);
+	if (refcount_dec_and_test(&pin->refcount)) {
+		xa_destroy(&pin->dpll_refs);
+		xa_destroy(&pin->parent_refs);
+		xa_erase(&dpll_pin_xa, pin->idx);
+		kfree(pin->prop.description);
+		kfree(pin->rclk_dev_name);
+		kfree(pin);
+	}
+	mutex_unlock(&dpll_pin_xa_lock);
+}
+EXPORT_SYMBOL_GPL(dpll_pin_put);
+
+static int
+__dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
+		    struct dpll_pin_ops *ops, void *priv,
+		    const char *rclk_device_name)
+{
+	int ret;
+
+	if (rclk_device_name && !pin->rclk_dev_name) {
+		pin->rclk_dev_name = kstrdup(rclk_device_name, GFP_KERNEL);
+		if (!pin->rclk_dev_name)
+			return -ENOMEM;
+	}
+	ret = dpll_xa_ref_pin_add(&dpll->pin_refs, pin, ops, priv);
+	if (ret)
+		goto rclk_free;
+	ret = dpll_xa_ref_dpll_add(&pin->dpll_refs, dpll, ops, priv);
+	if (ret)
+		goto ref_pin_del;
+	else
+		dpll_pin_notify(dpll, pin, DPLL_A_PIN_IDX);
+
+	return ret;
+
+ref_pin_del:
+	dpll_xa_ref_pin_del(&dpll->pin_refs, pin);
+rclk_free:
+	kfree(pin->rclk_dev_name);
+	return ret;
+}
+
+/**
+ * dpll_pin_register - register the dpll pin in the subsystem
+ * @dpll: pointer to a dpll
+ * @pin: pointer to a dpll pin
+ * @ops: ops for a dpll pin ops
+ * @priv: pointer to private information of owner
+ * @rclk_device: pointer to recovered clock device
+ *
+ * Return:
+ * * 0 on success
+ * * -EINVAL - missing dpll or pin
+ * * -ENOMEM - failed to allocate memory
+ */
+int
+dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
+		  struct dpll_pin_ops *ops, void *priv,
+		  struct device *rclk_device)
+{
+	const char *rclk_name = rclk_device ? dev_name(rclk_device) : NULL;
+	int ret;
+
+	if (WARN_ON(!dpll))
+		return -EINVAL;
+	if (WARN_ON(!pin))
+		return -EINVAL;
+
+	mutex_lock(&dpll_device_xa_lock);
+	mutex_lock(&dpll_pin_xa_lock);
+	ret = __dpll_pin_register(dpll, pin, ops, priv, rclk_name);
+	mutex_unlock(&dpll_pin_xa_lock);
+	mutex_unlock(&dpll_device_xa_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_register);
+
+static void
+__dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin)
+{
+	dpll_xa_ref_pin_del(&dpll->pin_refs, pin);
+	dpll_xa_ref_dpll_del(&pin->dpll_refs, dpll);
+}
+
+/**
+ * dpll_pin_unregister - deregister dpll pin from dpll device
+ * @dpll: registered dpll pointer
+ * @pin: pointer to a pin
+ *
+ * Note: It does not free the memory
+ */
+int dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin)
+{
+	if (WARN_ON(xa_empty(&dpll->pin_refs)))
+		return -ENOENT;
+
+	mutex_lock(&dpll_device_xa_lock);
+	mutex_lock(&dpll_pin_xa_lock);
+	__dpll_pin_unregister(dpll, pin);
+	mutex_unlock(&dpll_pin_xa_lock);
+	mutex_unlock(&dpll_device_xa_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_unregister);
+
+/**
+ * dpll_pin_on_pin_register - register a pin with a parent pin
+ * @parent: pointer to a parent pin
+ * @pin: pointer to a pin
+ * @ops: ops for a dpll pin
+ * @priv: pointer to private information of owner
+ * @rclk_device: pointer to recovered clock device
+ *
+ * Register a pin with a parent pin, create references between them and
+ * between newly registered pin and dplls connected with a parent pin.
+ *
+ * Return:
+ * * 0 on success
+ * * -EINVAL missing pin or parent
+ * * -ENOMEM failed allocation
+ * * -EPERM if parent is not allowed
+ */
+int
+dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *pin,
+			 struct dpll_pin_ops *ops, void *priv,
+			 struct device *rclk_device)
+{
+	struct dpll_pin_ref *ref;
+	unsigned long i, stop;
+	int ret;
+
+	if (WARN_ON(!pin || !parent))
+		return -EINVAL;
+	if (WARN_ON(parent->prop.type != DPLL_PIN_TYPE_MUX))
+		return -EPERM;
+	mutex_lock(&dpll_pin_xa_lock);
+	ret = dpll_xa_ref_pin_add(&pin->parent_refs, parent, ops, priv);
+	if (ret)
+		goto unlock;
+	refcount_inc(&pin->refcount);
+	xa_for_each(&parent->dpll_refs, i, ref) {
+		mutex_lock(&dpll_device_xa_lock);
+		ret = __dpll_pin_register(ref->dpll, pin, ops, priv,
+					  rclk_device ?
+					  dev_name(rclk_device) : NULL);
+		mutex_unlock(&dpll_device_xa_lock);
+		if (ret) {
+			stop = i;
+			goto dpll_unregister;
+		}
+		dpll_pin_parent_notify(ref->dpll, pin, parent, DPLL_A_PIN_IDX);
+	}
+	mutex_unlock(&dpll_pin_xa_lock);
+
+	return ret;
+
+dpll_unregister:
+	xa_for_each(&parent->dpll_refs, i, ref) {
+		if (i < stop) {
+			mutex_lock(&dpll_device_xa_lock);
+			__dpll_pin_unregister(ref->dpll, pin);
+			mutex_unlock(&dpll_device_xa_lock);
+		}
+	}
+	refcount_dec(&pin->refcount);
+	dpll_xa_ref_pin_del(&pin->parent_refs, parent);
+unlock:
+	mutex_unlock(&dpll_pin_xa_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_on_pin_register);
+
+/**
+ * dpll_pin_on_pin_unregister - deregister dpll pin from a parent pin
+ * @parent: pointer to a parent pin
+ * @pin: pointer to a pin
+ *
+ * Note: It does not free the memory
+ */
+void dpll_pin_on_pin_unregister(struct dpll_pin *parent, struct dpll_pin *pin)
+{
+	struct dpll_pin_ref *ref;
+	unsigned long i;
+
+	mutex_lock(&dpll_device_xa_lock);
+	mutex_lock(&dpll_pin_xa_lock);
+	dpll_xa_ref_pin_del(&pin->parent_refs, parent);
+	refcount_dec(&pin->refcount);
+	xa_for_each(&pin->dpll_refs, i, ref) {
+		__dpll_pin_unregister(ref->dpll, pin);
+		dpll_pin_parent_notify(ref->dpll, pin, parent,
+				       DPLL_A_PIN_IDX);
+	}
+	mutex_unlock(&dpll_pin_xa_lock);
+	mutex_unlock(&dpll_device_xa_lock);
+}
+EXPORT_SYMBOL_GPL(dpll_pin_on_pin_unregister);
+
+/**
+ * dpll_pin_get_by_idx - find a pin ref on dpll by pin index
+ * @dpll: dpll device pointer
+ * @idx: index of pin
+ *
+ * Find a reference to a pin registered with given dpll and return its pointer.
+ *
+ * Return:
+ * * valid pointer if pin was found
+ * * NULL if not found
+ */
+struct dpll_pin *dpll_pin_get_by_idx(struct dpll_device *dpll, u32 idx)
+{
+	struct dpll_pin_ref *pos;
+	unsigned long i;
+
+	xa_for_each(&dpll->pin_refs, i, pos) {
+		if (pos && pos->pin && pos->pin->dev_driver_id == idx)
+			return pos->pin;
+	}
+
+	return NULL;
+}
+
+/**
+ * dpll_priv - get the dpll device private owner data
+ * @dpll:	registered dpll pointer
+ *
+ * Return: pointer to the data
+ */
+void *dpll_priv(const struct dpll_device *dpll)
+{
+	return dpll->priv;
+}
+EXPORT_SYMBOL_GPL(dpll_priv);
+
+/**
+ * dpll_pin_on_dpll_priv - get the dpll device private owner data
+ * @dpll:	registered dpll pointer
+ * @pin:	pointer to a pin
+ *
+ * Return: pointer to the data
+ */
+void *dpll_pin_on_dpll_priv(const struct dpll_device *dpll,
+			    const struct dpll_pin *pin)
+{
+	struct dpll_pin_ref *ref;
+
+	ref = dpll_xa_ref_pin_find((struct xarray *)&dpll->pin_refs, pin);
+	if (!ref)
+		return NULL;
+
+	return ref->priv;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_on_dpll_priv);
+
+/**
+ * dpll_pin_on_pin_priv - get the dpll pin private owner data
+ * @parent: pointer to a parent pin
+ * @pin: pointer to a pin
+ *
+ * Return: pointer to the data
+ */
+void *dpll_pin_on_pin_priv(const struct dpll_pin *parent,
+			   const struct dpll_pin *pin)
+{
+	struct dpll_pin_ref *ref;
+
+	ref = dpll_xa_ref_pin_find((struct xarray *)&pin->parent_refs, parent);
+	if (!ref)
+		return NULL;
+
+	return ref->priv;
+}
+EXPORT_SYMBOL_GPL(dpll_pin_on_pin_priv);
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
+	mutex_destroy(&dpll_pin_xa_lock);
+	return ret;
+}
+subsys_initcall(dpll_init);
diff --git a/drivers/dpll/dpll_core.h b/drivers/dpll/dpll_core.h
new file mode 100644
index 000000000000..876b6ac6f3a0
--- /dev/null
+++ b/drivers/dpll/dpll_core.h
@@ -0,0 +1,99 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
+ */
+
+#ifndef __DPLL_CORE_H__
+#define __DPLL_CORE_H__
+
+#include <linux/dpll.h>
+#include <linux/refcount.h>
+#include "dpll_netlink.h"
+
+#define DPLL_REGISTERED		XA_MARK_1
+
+/**
+ * struct dpll_device - structure for a DPLL device
+ * @id:			unique id number for each device
+ * @dev_driver_id:	id given by dev driver
+ * @dev:		struct device for this dpll device
+ * @parent:		parent device
+ * @module:		module of creator
+ * @ops:		operations this &dpll_device supports
+ * @lock:		mutex to serialize operations
+ * @type:		type of a dpll
+ * @priv:		pointer to private information of owner
+ * @pins:		list of pointers to pins registered with this dpll
+ * @clock_id:		unique identifier (clock_id) of a dpll
+ * @mode_supported_mask: mask of supported modes
+ * @refcount:		refcount
+ **/
+struct dpll_device {
+	u32 id;
+	u32 dev_driver_id;
+	struct device dev;
+	struct device *parent;
+	struct module *module;
+	struct dpll_device_ops *ops;
+	enum dpll_type type;
+	void *priv;
+	struct xarray pin_refs;
+	u64 clock_id;
+	unsigned long mode_supported_mask;
+	refcount_t refcount;
+};
+
+/**
+ * struct dpll_pin - structure for a dpll pin
+ * @idx:		unique idx given by alloc on global pin's XA
+ * @dev_driver_id:	id given by dev driver
+ * @clock_id:		clock_id of creator
+ * @module:		module of creator
+ * @dpll_refs:		hold referencees to dplls that pin is registered with
+ * @pin_refs:		hold references to pins that pin is registered with
+ * @prop:		properties given by registerer
+ * @rclk_dev_name:	holds name of device when pin can recover clock from it
+ * @refcount:		refcount
+ **/
+struct dpll_pin {
+	u32 idx;
+	u32 dev_driver_id;
+	u64 clock_id;
+	struct module *module;
+	struct xarray dpll_refs;
+	struct xarray parent_refs;
+	struct dpll_pin_properties prop;
+	char *rclk_dev_name;
+	refcount_t refcount;
+};
+
+/**
+ * struct dpll_pin_ref - structure for referencing either dpll or pins
+ * @dpll:		pointer to a dpll
+ * @pin:		pointer to a pin
+ * @ops:		ops for a dpll pin
+ * @priv:		pointer to private information of owner
+ **/
+struct dpll_pin_ref {
+	union {
+		struct dpll_device *dpll;
+		struct dpll_pin *pin;
+	};
+	struct dpll_pin_ops *ops;
+	void *priv;
+	refcount_t refcount;
+};
+
+struct dpll_device *dpll_device_get_by_id(int id);
+struct dpll_device *dpll_device_get_by_name(const char *bus_name,
+					    const char *dev_name);
+struct dpll_pin *dpll_pin_get_by_idx(struct dpll_device *dpll, u32 idx);
+struct dpll_pin_ref *
+dpll_xa_ref_pin_find(struct xarray *xa_refs, const struct dpll_pin *pin);
+struct dpll_pin_ref *
+dpll_xa_ref_dpll_find(struct xarray *xa_refs, const struct dpll_device *dpll);
+extern struct xarray dpll_device_xa;
+extern struct xarray dpll_pin_xa;
+extern struct mutex dpll_device_xa_lock;
+extern struct mutex dpll_pin_xa_lock;
+#endif
diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
new file mode 100644
index 000000000000..46aefeb1ac93
--- /dev/null
+++ b/drivers/dpll/dpll_netlink.c
@@ -0,0 +1,1065 @@
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
+#include "dpll_nl.h"
+#include <uapi/linux/dpll.h>
+
+static u32 dpll_pin_freq_value[] = {
+	[DPLL_PIN_FREQ_SUPP_1_HZ] = DPLL_PIN_FREQ_1_HZ,
+	[DPLL_PIN_FREQ_SUPP_10_MHZ] = DPLL_PIN_FREQ_10_MHZ,
+};
+
+static int
+dpll_msg_add_dev_handle(struct sk_buff *msg, const struct dpll_device *dpll)
+{
+	if (nla_put_u32(msg, DPLL_A_ID, dpll->id))
+		return -EMSGSIZE;
+	if (nla_put_string(msg, DPLL_A_BUS_NAME, dev_bus_name(&dpll->dev)))
+		return -EMSGSIZE;
+	if (nla_put_string(msg, DPLL_A_DEV_NAME, dev_name(&dpll->dev)))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+dpll_msg_add_mode(struct sk_buff *msg, const struct dpll_device *dpll,
+		  struct netlink_ext_ack *extack)
+{
+	enum dpll_mode mode;
+
+	if (WARN_ON(!dpll->ops->mode_get))
+		return -EOPNOTSUPP;
+	if (dpll->ops->mode_get(dpll, &mode, extack))
+		return -EFAULT;
+	if (nla_put_u8(msg, DPLL_A_MODE, mode))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+dpll_msg_add_source_pin_idx(struct sk_buff *msg, struct dpll_device *dpll,
+			    struct netlink_ext_ack *extack)
+{
+	u32 source_pin_idx;
+
+	if (WARN_ON(!dpll->ops->source_pin_idx_get))
+		return -EOPNOTSUPP;
+	if (dpll->ops->source_pin_idx_get(dpll, &source_pin_idx, extack))
+		return -EFAULT;
+	if (nla_put_u32(msg, DPLL_A_SOURCE_PIN_IDX, source_pin_idx))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+dpll_msg_add_lock_status(struct sk_buff *msg, struct dpll_device *dpll,
+			 struct netlink_ext_ack *extack)
+{
+	enum dpll_lock_status status;
+
+	if (WARN_ON(!dpll->ops->lock_status_get))
+		return -EOPNOTSUPP;
+	if (dpll->ops->lock_status_get(dpll, &status, extack))
+		return -EFAULT;
+	if (nla_put_u8(msg, DPLL_A_LOCK_STATUS, status))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+dpll_msg_add_temp(struct sk_buff *msg, struct dpll_device *dpll,
+		  struct netlink_ext_ack *extack)
+{
+	s32 temp;
+
+	if (!dpll->ops->temp_get)
+		return -EOPNOTSUPP;
+	if (dpll->ops->temp_get(dpll, &temp, extack))
+		return -EFAULT;
+	if (nla_put_s32(msg, DPLL_A_TEMP, temp))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+dpll_msg_add_pin_prio(struct sk_buff *msg, const struct dpll_pin *pin,
+		      struct dpll_pin_ref *ref,
+		      struct netlink_ext_ack *extack)
+{
+	u32 prio;
+
+	if (!ref->ops->prio_get)
+		return -EOPNOTSUPP;
+	if (ref->ops->prio_get(pin, ref->dpll, &prio, extack))
+		return -EFAULT;
+	if (nla_put_u32(msg, DPLL_A_PIN_PRIO, prio))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+dpll_msg_add_pin_on_dpll_state(struct sk_buff *msg, const struct dpll_pin *pin,
+			       struct dpll_pin_ref *ref,
+			       struct netlink_ext_ack *extack)
+{
+	enum dpll_pin_state state;
+
+	if (!ref->ops->state_on_dpll_get)
+		return -EOPNOTSUPP;
+	if (ref->ops->state_on_dpll_get(pin, ref->dpll, &state, extack))
+		return -EFAULT;
+	if (nla_put_u8(msg, DPLL_A_PIN_STATE, state))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+dpll_msg_add_pin_direction(struct sk_buff *msg, const struct dpll_pin *pin,
+			   struct netlink_ext_ack *extack)
+{
+	enum dpll_pin_direction direction;
+	struct dpll_pin_ref *ref;
+	unsigned long i;
+
+	xa_for_each((struct xarray *)&pin->dpll_refs, i, ref) {
+		if (ref && ref->ops && ref->dpll)
+			break;
+	}
+	if (!ref || !ref->ops || !ref->dpll)
+		return -ENODEV;
+	if (!ref->ops->direction_get)
+		return -EOPNOTSUPP;
+	if (ref->ops->direction_get(pin, ref->dpll, &direction, extack))
+		return -EFAULT;
+	if (nla_put_u8(msg, DPLL_A_PIN_DIRECTION, direction))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+dpll_msg_add_pin_freq(struct sk_buff *msg, const struct dpll_pin *pin,
+		      struct netlink_ext_ack *extack, bool dump_any_freq)
+{
+	enum dpll_pin_freq_supp fs;
+	struct dpll_pin_ref *ref;
+	unsigned long i;
+	u32 freq;
+
+	xa_for_each((struct xarray *)&pin->dpll_refs, i, ref) {
+		if (ref && ref->ops && ref->dpll)
+			break;
+	}
+	if (!ref || !ref->ops || !ref->dpll)
+		return -ENODEV;
+	if (!ref->ops->frequency_get)
+		return -EOPNOTSUPP;
+	if (ref->ops->frequency_get(pin, ref->dpll, &freq, extack))
+		return -EFAULT;
+	if (nla_put_u32(msg, DPLL_A_PIN_FREQUENCY, freq))
+		return -EMSGSIZE;
+	if (!dump_any_freq)
+		return 0;
+	for (fs = DPLL_PIN_FREQ_SUPP_UNSPEC + 1;
+	     fs <= DPLL_PIN_FREQ_SUPP_MAX; fs++) {
+		if (test_bit(fs, &pin->prop.freq_supported)) {
+			if (nla_put_u32(msg, DPLL_A_PIN_FREQUENCY_SUPPORTED,
+			    dpll_pin_freq_value[fs]))
+				return -EMSGSIZE;
+		}
+	}
+	if (pin->prop.any_freq_min && pin->prop.any_freq_max) {
+		if (nla_put_u32(msg, DPLL_A_PIN_ANY_FREQUENCY_MIN,
+				pin->prop.any_freq_min))
+			return -EMSGSIZE;
+		if (nla_put_u32(msg, DPLL_A_PIN_ANY_FREQUENCY_MAX,
+				pin->prop.any_freq_max))
+			return -EMSGSIZE;
+	}
+
+	return 0;
+}
+
+static int
+dpll_msg_add_pin_parents(struct sk_buff *msg, struct dpll_pin *pin,
+			 struct netlink_ext_ack *extack)
+{
+	struct dpll_pin_ref *ref_parent;
+	enum dpll_pin_state state;
+	struct nlattr *nest;
+	unsigned long index;
+	int ret;
+
+	xa_for_each(&pin->parent_refs, index, ref_parent) {
+		if (WARN_ON(!ref_parent->ops->state_on_pin_get))
+			return -EFAULT;
+		ret = ref_parent->ops->state_on_pin_get(pin, ref_parent->pin,
+							&state, extack);
+		if (ret)
+			return -EFAULT;
+		nest = nla_nest_start(msg, DPLL_A_PIN_PARENT);
+		if (!nest)
+			return -EMSGSIZE;
+		if (nla_put_u32(msg, DPLL_A_PIN_PARENT_IDX,
+				ref_parent->pin->dev_driver_id)) {
+			ret = -EMSGSIZE;
+			goto nest_cancel;
+		}
+		if (nla_put_u8(msg, DPLL_A_PIN_STATE, state)) {
+			ret = -EMSGSIZE;
+			goto nest_cancel;
+		}
+		nla_nest_end(msg, nest);
+	}
+
+	return 0;
+
+nest_cancel:
+	nla_nest_cancel(msg, nest);
+	return ret;
+}
+
+static int
+dpll_msg_add_pins_on_pin(struct sk_buff *msg, struct dpll_pin *pin,
+			 struct netlink_ext_ack *extack)
+{
+	struct dpll_pin_ref *ref = NULL;
+	enum dpll_pin_state state;
+	struct nlattr *nest;
+	unsigned long index;
+	int ret;
+
+	xa_for_each(&pin->parent_refs, index, ref) {
+		if (WARN_ON(!ref->ops->state_on_pin_get))
+			return -EFAULT;
+		ret = ref->ops->state_on_pin_get(pin, ref->pin, &state,
+						 extack);
+		if (ret)
+			return -EFAULT;
+		nest = nla_nest_start(msg, DPLL_A_PIN_PARENT);
+		if (!nest)
+			return -EMSGSIZE;
+		if (nla_put_u32(msg, DPLL_A_PIN_PARENT_IDX,
+				ref->pin->dev_driver_id)) {
+			ret = -EMSGSIZE;
+			goto nest_cancel;
+		}
+		if (nla_put_u8(msg, DPLL_A_PIN_STATE, state)) {
+			ret = -EMSGSIZE;
+			goto nest_cancel;
+		}
+		nla_nest_end(msg, nest);
+	}
+
+	return 0;
+
+nest_cancel:
+	nla_nest_cancel(msg, nest);
+	return ret;
+}
+
+static int
+dpll_msg_add_pin_dplls(struct sk_buff *msg, struct dpll_pin *pin,
+		       struct netlink_ext_ack *extack)
+{
+	struct dpll_pin_ref *ref;
+	struct nlattr *attr;
+	unsigned long index;
+	int ret;
+
+	xa_for_each(&pin->dpll_refs, index, ref) {
+		attr = nla_nest_start(msg, DPLL_A_DEVICE);
+		if (!attr)
+			return -EMSGSIZE;
+		ret = dpll_msg_add_dev_handle(msg, ref->dpll);
+		if (ret)
+			goto nest_cancel;
+		ret = dpll_msg_add_pin_on_dpll_state(msg, pin, ref, extack);
+		if (ret && ret != -EOPNOTSUPP)
+			goto nest_cancel;
+		ret = dpll_msg_add_pin_prio(msg, pin, ref, extack);
+		if (ret && ret != -EOPNOTSUPP)
+			goto nest_cancel;
+		nla_nest_end(msg, attr);
+	}
+
+	return 0;
+
+nest_cancel:
+	nla_nest_end(msg, attr);
+	return ret;
+}
+
+static int
+dpll_cmd_pin_on_dpll_get(struct sk_buff *msg, struct dpll_pin *pin,
+			 struct dpll_device *dpll,
+			 struct netlink_ext_ack *extack)
+{
+	struct dpll_pin_ref *ref;
+	int ret;
+
+	if (nla_put_u32(msg, DPLL_A_PIN_IDX, pin->dev_driver_id))
+		return -EMSGSIZE;
+	if (nla_put_string(msg, DPLL_A_PIN_DESCRIPTION, pin->prop.description))
+		return -EMSGSIZE;
+	if (nla_put_u8(msg, DPLL_A_PIN_TYPE, pin->prop.type))
+		return -EMSGSIZE;
+	if (nla_put_u32(msg, DPLL_A_PIN_DPLL_CAPS, pin->prop.capabilities))
+		return -EMSGSIZE;
+	ret = dpll_msg_add_pin_direction(msg, pin, extack);
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_pin_freq(msg, pin, extack, true);
+	if (ret && ret != -EOPNOTSUPP)
+		return ret;
+	ref = dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
+	if (!ref)
+		return -EFAULT;
+	ret = dpll_msg_add_pin_prio(msg, pin, ref, extack);
+	if (ret && ret != -EOPNOTSUPP)
+		return ret;
+	ret = dpll_msg_add_pin_on_dpll_state(msg, pin, ref, extack);
+	if (ret && ret != -EOPNOTSUPP)
+		return ret;
+	ret = dpll_msg_add_pin_parents(msg, pin, extack);
+	if (ret)
+		return ret;
+	if (pin->rclk_dev_name)
+		if (nla_put_string(msg, DPLL_A_PIN_RCLK_DEVICE,
+				   pin->rclk_dev_name))
+			return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+__dpll_cmd_pin_dump_one(struct sk_buff *msg, struct dpll_pin *pin,
+			struct netlink_ext_ack *extack, bool dump_dpll)
+{
+	int ret;
+
+	if (nla_put_u32(msg, DPLL_A_PIN_IDX, pin->dev_driver_id))
+		return -EMSGSIZE;
+	if (nla_put_string(msg, DPLL_A_PIN_DESCRIPTION, pin->prop.description))
+		return -EMSGSIZE;
+	if (nla_put_u8(msg, DPLL_A_PIN_TYPE, pin->prop.type))
+		return -EMSGSIZE;
+	ret = dpll_msg_add_pin_direction(msg, pin, extack);
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_pin_freq(msg, pin, extack, true);
+	if (ret && ret != -EOPNOTSUPP)
+		return ret;
+	ret = dpll_msg_add_pins_on_pin(msg, pin, extack);
+	if (ret)
+		return ret;
+	if (!xa_empty(&pin->dpll_refs) && dump_dpll) {
+		ret = dpll_msg_add_pin_dplls(msg, pin, extack);
+		if (ret)
+			return ret;
+	}
+	if (pin->rclk_dev_name)
+		if (nla_put_string(msg, DPLL_A_PIN_RCLK_DEVICE,
+				   pin->rclk_dev_name))
+			return -EMSGSIZE;
+
+	return 0;
+}
+
+static int
+dpll_device_get_one(struct dpll_device *dpll, struct sk_buff *msg,
+		     struct netlink_ext_ack *extack)
+{
+	struct dpll_pin_ref *ref;
+	enum dpll_mode mode;
+	unsigned long i;
+	int ret;
+
+	ret = dpll_msg_add_dev_handle(msg, dpll);
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_source_pin_idx(msg, dpll, extack);
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_temp(msg, dpll, extack);
+	if (ret && ret != -EOPNOTSUPP)
+		return ret;
+	ret = dpll_msg_add_lock_status(msg, dpll, extack);
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_mode(msg, dpll, extack);
+	if (ret)
+		return ret;
+	for (mode = DPLL_MODE_UNSPEC + 1; mode <= DPLL_MODE_MAX; mode++)
+		if (test_bit(mode, &dpll->mode_supported_mask))
+			if (nla_put_s32(msg, DPLL_A_MODE_SUPPORTED, mode))
+				return -EMSGSIZE;
+	if (nla_put_64bit(msg, DPLL_A_CLOCK_ID, sizeof(dpll->clock_id),
+			  &dpll->clock_id, 0))
+		return -EMSGSIZE;
+	if (nla_put_u8(msg, DPLL_A_TYPE, dpll->type))
+		return -EMSGSIZE;
+	xa_for_each(&dpll->pin_refs, i, ref) {
+		struct nlattr *nest = nla_nest_start(msg, DPLL_A_PIN);
+
+		if (!nest) {
+			ret = -EMSGSIZE;
+			break;
+		}
+		ret = dpll_cmd_pin_on_dpll_get(msg, ref->pin, dpll, extack);
+		if (ret) {
+			nla_nest_cancel(msg, nest);
+			break;
+		}
+		nla_nest_end(msg, nest);
+	}
+
+	return ret;
+}
+
+static bool dpll_pin_is_freq_supported(struct dpll_pin *pin, u32 freq)
+{
+	enum dpll_pin_freq_supp fs;
+
+	if (freq >= pin->prop.any_freq_min && freq <= pin->prop.any_freq_max)
+		return true;
+	for (fs = DPLL_PIN_FREQ_SUPP_UNSPEC + 1;
+	     fs <= DPLL_PIN_FREQ_SUPP_MAX; fs++)
+		if (test_bit(fs, &pin->prop.freq_supported))
+			if (freq == dpll_pin_freq_value[fs])
+				return true;
+	return false;
+}
+
+static int
+dpll_pin_freq_set(struct dpll_pin *pin, struct nlattr *a,
+		  struct netlink_ext_ack *extack)
+{
+	u32 freq = nla_get_u32(a);
+	struct dpll_pin_ref *ref;
+	unsigned long i;
+	int ret;
+
+	if (!dpll_pin_is_freq_supported(pin, freq))
+		return -EINVAL;
+
+	xa_for_each(&pin->dpll_refs, i, ref) {
+		ret = ref->ops->frequency_set(pin, ref->dpll, freq, extack);
+		if (ret)
+			return -EFAULT;
+		dpll_pin_notify(ref->dpll, pin, DPLL_A_PIN_FREQUENCY);
+	}
+
+	return 0;
+}
+
+static int
+dpll_pin_on_pin_state_set(struct dpll_device *dpll, struct dpll_pin *pin,
+			  u32 parent_idx, enum dpll_pin_state state,
+			  struct netlink_ext_ack *extack)
+{
+	struct dpll_pin_ref *ref;
+	struct dpll_pin *parent;
+
+	if (!(DPLL_PIN_CAPS_STATE_CAN_CHANGE & pin->prop.capabilities))
+		return -EOPNOTSUPP;
+	parent = dpll_pin_get_by_idx(dpll, parent_idx);
+	if (!parent)
+		return -EINVAL;
+	ref = dpll_xa_ref_pin_find(&pin->parent_refs, parent);
+	if (!ref)
+		return -EINVAL;
+	if (!ref->ops || !ref->ops->state_on_pin_set)
+		return -EOPNOTSUPP;
+	if (ref->ops->state_on_pin_set(pin, parent, state, extack))
+		return -EFAULT;
+	dpll_pin_parent_notify(dpll, pin, parent, DPLL_A_PIN_STATE);
+
+	return 0;
+}
+
+static int
+dpll_pin_state_set(struct dpll_device *dpll, struct dpll_pin *pin,
+		   enum dpll_pin_state state,
+		   struct netlink_ext_ack *extack)
+{
+	struct dpll_pin_ref *ref;
+
+	if (!(DPLL_PIN_CAPS_STATE_CAN_CHANGE & pin->prop.capabilities))
+		return -EOPNOTSUPP;
+	ref = dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
+	if (!ref)
+		return -EFAULT;
+	if (!ref->ops || !ref->ops->state_on_dpll_set)
+		return -EOPNOTSUPP;
+	if (ref->ops->state_on_dpll_set(pin, ref->dpll, state, extack))
+		return -EINVAL;
+	dpll_pin_notify(ref->dpll, pin, DPLL_A_PIN_STATE);
+
+	return 0;
+}
+
+static int
+dpll_pin_prio_set(struct dpll_device *dpll, struct dpll_pin *pin,
+		  struct nlattr *prio_attr, struct netlink_ext_ack *extack)
+{
+	struct dpll_pin_ref *ref;
+	u32 prio = nla_get_u8(prio_attr);
+
+	if (!(DPLL_PIN_CAPS_PRIORITY_CAN_CHANGE & pin->prop.capabilities))
+		return -EOPNOTSUPP;
+	ref = dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
+	if (!ref)
+		return -EFAULT;
+	if (!ref->ops || !ref->ops->prio_set)
+		return -EOPNOTSUPP;
+	if (ref->ops->prio_set(pin, dpll, prio, extack))
+		return -EINVAL;
+	dpll_pin_notify(dpll, pin, DPLL_A_PIN_PRIO);
+
+	return 0;
+}
+
+static int
+dpll_pin_direction_set(struct dpll_pin *pin, struct nlattr *a,
+		       struct netlink_ext_ack *extack)
+{
+	enum dpll_pin_direction direction = nla_get_u8(a);
+	struct dpll_pin_ref *ref;
+	unsigned long i;
+
+	if (!(DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE & pin->prop.capabilities))
+		return -EOPNOTSUPP;
+
+	xa_for_each(&pin->dpll_refs, i, ref) {
+		if (ref->ops->direction_set(pin, ref->dpll, direction, extack))
+			return -EFAULT;
+		dpll_pin_notify(ref->dpll, pin, DPLL_A_PIN_DIRECTION);
+	}
+
+	return 0;
+}
+
+static int
+dpll_pin_set_from_nlattr(struct dpll_device *dpll,
+			 struct dpll_pin *pin, struct genl_info *info)
+{
+	enum dpll_pin_state state = DPLL_PIN_STATE_UNSPEC;
+	u32 parent_idx = PIN_IDX_INVALID;
+	int rem, ret = -EINVAL;
+	struct nlattr *a;
+
+	nla_for_each_attr(a, genlmsg_data(info->genlhdr),
+			  genlmsg_len(info->genlhdr), rem) {
+		switch (nla_type(a)) {
+		case DPLL_A_PIN_FREQUENCY:
+			ret = dpll_pin_freq_set(pin, a, info->extack);
+			if (ret)
+				return ret;
+			break;
+		case DPLL_A_PIN_DIRECTION:
+			ret = dpll_pin_direction_set(pin, a, info->extack);
+			if (ret)
+				return ret;
+			break;
+		case DPLL_A_PIN_PRIO:
+			ret = dpll_pin_prio_set(dpll, pin, a, info->extack);
+			if (ret)
+				return ret;
+			break;
+		case DPLL_A_PIN_PARENT_IDX:
+			parent_idx = nla_get_u32(a);
+			break;
+		case DPLL_A_PIN_STATE:
+			state = nla_get_u8(a);
+			break;
+		default:
+			break;
+		}
+	}
+	if (state != DPLL_PIN_STATE_UNSPEC) {
+		if (parent_idx == PIN_IDX_INVALID) {
+			ret = dpll_pin_state_set(dpll, pin, state,
+						 info->extack);
+			if (ret)
+				return ret;
+		} else {
+			ret = dpll_pin_on_pin_state_set(dpll, pin, parent_idx,
+							state, info->extack);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return ret;
+}
+
+int dpll_nl_pin_set_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dpll_device *dpll = info->user_ptr[0];
+	struct dpll_pin *pin = info->user_ptr[1];
+
+	return dpll_pin_set_from_nlattr(dpll, pin, info);
+}
+
+int dpll_nl_pin_get_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dpll_pin *pin = info->user_ptr[1];
+	struct nlattr *hdr, *nest;
+	struct sk_buff *msg;
+	int ret;
+
+	if (!pin)
+		return -ENODEV;
+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+	hdr = genlmsg_put_reply(msg, info, &dpll_nl_family, 0,
+				DPLL_CMD_PIN_GET);
+	if (!hdr)
+		return -EMSGSIZE;
+	nest = nla_nest_start(msg, DPLL_A_PIN);
+	if (!nest)
+		return -EMSGSIZE;
+	ret = __dpll_cmd_pin_dump_one(msg, pin, info->extack, true);
+	if (ret) {
+		nlmsg_free(msg);
+		return ret;
+	}
+	nla_nest_end(msg, nest);
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_reply(msg, info);
+}
+
+int dpll_nl_pin_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct nlattr *hdr, *nest;
+	struct dpll_pin *pin;
+	unsigned long i;
+	int ret;
+
+	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			  &dpll_nl_family, 0, DPLL_CMD_PIN_GET);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	xa_for_each(&dpll_pin_xa, i, pin) {
+		if (xa_empty(&pin->dpll_refs))
+			continue;
+		nest = nla_nest_start(skb, DPLL_A_PIN);
+		if (!nest) {
+			ret = -EMSGSIZE;
+			break;
+		}
+		ret = __dpll_cmd_pin_dump_one(skb, pin, cb->extack, true);
+		if (ret) {
+			nla_nest_cancel(skb, nest);
+			break;
+		}
+		nla_nest_end(skb, nest);
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
+static int
+dpll_set_from_nlattr(struct dpll_device *dpll, struct genl_info *info)
+{
+	struct nlattr *attr;
+	enum dpll_mode mode;
+	int rem, ret = 0;
+
+	nla_for_each_attr(attr, genlmsg_data(info->genlhdr),
+			  genlmsg_len(info->genlhdr), rem) {
+		switch (nla_type(attr)) {
+		case DPLL_A_MODE:
+			mode = nla_get_u8(attr);
+
+			if (!dpll->ops || !dpll->ops->mode_set)
+				return -EOPNOTSUPP;
+			ret = dpll->ops->mode_set(dpll, mode, info->extack);
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
+int dpll_nl_device_set_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dpll_device *dpll = info->user_ptr[0];
+
+	return dpll_set_from_nlattr(dpll, info);
+}
+
+int dpll_nl_device_get_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct dpll_device *dpll = info->user_ptr[0];
+	struct nlattr *hdr, *nest;
+	struct sk_buff *msg;
+	int ret;
+
+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+	hdr = genlmsg_put_reply(msg, info, &dpll_nl_family, 0,
+				DPLL_CMD_DEVICE_GET);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	nest = nla_nest_start(msg, DPLL_A_DEVICE);
+	ret = dpll_device_get_one(dpll, msg, info->extack);
+	if (ret) {
+		nlmsg_free(msg);
+		return ret;
+	}
+	nla_nest_end(msg, nest);
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_reply(msg, info);
+}
+
+int dpll_nl_device_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct nlattr *hdr, *nest;
+	struct dpll_device *dpll;
+	unsigned long i;
+	int ret;
+
+	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			  &dpll_nl_family, 0, DPLL_CMD_DEVICE_GET);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	xa_for_each_marked(&dpll_device_xa, i, dpll, DPLL_REGISTERED) {
+		nest = nla_nest_start(skb, DPLL_A_DEVICE);
+		ret = dpll_msg_add_dev_handle(skb, dpll);
+		if (ret) {
+			nla_nest_cancel(skb, nest);
+			break;
+		}
+		nla_nest_end(skb, nest);
+	}
+	if (ret)
+		genlmsg_cancel(skb, hdr);
+	else
+		genlmsg_end(skb, hdr);
+
+	return ret;
+}
+
+int dpll_pre_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
+		  struct genl_info *info)
+{
+	struct dpll_device *dpll_id = NULL, *dpll_name = NULL;
+	int ret = -ENODEV;
+
+	if (!info->attrs[DPLL_A_ID] &&
+	    !(info->attrs[DPLL_A_BUS_NAME] && info->attrs[DPLL_A_DEV_NAME]))
+		return -EINVAL;
+
+	mutex_lock(&dpll_device_xa_lock);
+	if (info->attrs[DPLL_A_ID]) {
+		u32 id = nla_get_u32(info->attrs[DPLL_A_ID]);
+
+		dpll_id = dpll_device_get_by_id(id);
+		if (!dpll_id)
+			goto unlock;
+		info->user_ptr[0] = dpll_id;
+	}
+	if (info->attrs[DPLL_A_BUS_NAME] &&
+	    info->attrs[DPLL_A_DEV_NAME]) {
+		const char *bus_name = nla_data(info->attrs[DPLL_A_BUS_NAME]);
+		const char *dev_name = nla_data(info->attrs[DPLL_A_DEV_NAME]);
+
+		dpll_name = dpll_device_get_by_name(bus_name, dev_name);
+		if (!dpll_name) {
+			ret = -ENODEV;
+			goto unlock;
+		}
+
+		if (dpll_id && dpll_name != dpll_id)
+			goto unlock;
+		info->user_ptr[0] = dpll_name;
+	}
+
+	return 0;
+unlock:
+	mutex_unlock(&dpll_device_xa_lock);
+	return ret;
+}
+
+void dpll_post_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
+		    struct genl_info *info)
+{
+	mutex_unlock(&dpll_device_xa_lock);
+}
+
+int dpll_pre_dumpit(struct netlink_callback *cb)
+{
+	mutex_lock(&dpll_device_xa_lock);
+
+	return 0;
+}
+
+int dpll_post_dumpit(struct netlink_callback *cb)
+{
+	mutex_unlock(&dpll_device_xa_lock);
+
+	return 0;
+}
+
+int dpll_pin_pre_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
+		      struct genl_info *info)
+{
+	int ret = dpll_pre_doit(ops, skb, info);
+	struct dpll_device *dpll;
+	struct dpll_pin *pin;
+
+	if (ret)
+		return ret;
+	dpll = info->user_ptr[0];
+	if (!info->attrs[DPLL_A_PIN_IDX]) {
+		ret = -EINVAL;
+		goto unlock_dev;
+	}
+	mutex_lock(&dpll_pin_xa_lock);
+	pin = dpll_pin_get_by_idx(dpll,
+				  nla_get_u32(info->attrs[DPLL_A_PIN_IDX]));
+	if (!pin) {
+		ret = -ENODEV;
+		goto unlock_pin;
+	}
+	info->user_ptr[1] = pin;
+
+	return 0;
+
+unlock_pin:
+	mutex_unlock(&dpll_pin_xa_lock);
+unlock_dev:
+	mutex_unlock(&dpll_device_xa_lock);
+	return ret;
+}
+
+void dpll_pin_post_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
+			struct genl_info *info)
+{
+	mutex_unlock(&dpll_pin_xa_lock);
+	dpll_post_doit(ops, skb, info);
+}
+
+int dpll_pin_pre_dumpit(struct netlink_callback *cb)
+{
+	mutex_lock(&dpll_pin_xa_lock);
+
+	return dpll_pre_dumpit(cb);
+}
+
+int dpll_pin_post_dumpit(struct netlink_callback *cb)
+{
+	mutex_unlock(&dpll_pin_xa_lock);
+
+	return dpll_post_dumpit(cb);
+}
+
+static int
+dpll_event_device_change(struct sk_buff *msg, struct dpll_device *dpll,
+			 struct dpll_pin *pin, struct dpll_pin *parent,
+			 enum dplla attr)
+{
+	int ret = dpll_msg_add_dev_handle(msg, dpll);
+	struct dpll_pin_ref *ref = NULL;
+	enum dpll_pin_state state;
+
+	if (ret)
+		return ret;
+	if (pin && nla_put_u32(msg, DPLL_A_PIN_IDX, pin->dev_driver_id))
+		return -EMSGSIZE;
+
+	switch (attr) {
+	case DPLL_A_MODE:
+		ret = dpll_msg_add_mode(msg, dpll, NULL);
+		break;
+	case DPLL_A_SOURCE_PIN_IDX:
+		ret = dpll_msg_add_source_pin_idx(msg, dpll, NULL);
+		break;
+	case DPLL_A_LOCK_STATUS:
+		ret = dpll_msg_add_lock_status(msg, dpll, NULL);
+		break;
+	case DPLL_A_TEMP:
+		ret = dpll_msg_add_temp(msg, dpll, NULL);
+		break;
+	case DPLL_A_PIN_FREQUENCY:
+		ret = dpll_msg_add_pin_freq(msg, pin, NULL, false);
+		break;
+	case DPLL_A_PIN_PRIO:
+		ref = dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
+		if (!ref)
+			return -EFAULT;
+		ret = dpll_msg_add_pin_prio(msg, pin, ref, NULL);
+		break;
+	case DPLL_A_PIN_STATE:
+		if (parent) {
+			ref = dpll_xa_ref_pin_find(&pin->parent_refs, parent);
+			if (!ref)
+				return -EFAULT;
+			if (!ref->ops || !ref->ops->state_on_pin_get)
+				return -EOPNOTSUPP;
+			ret = ref->ops->state_on_pin_get(pin, parent, &state,
+							 NULL);
+			if (ret)
+				return ret;
+			if (nla_put_u32(msg, DPLL_A_PIN_PARENT_IDX,
+					parent->dev_driver_id))
+				return -EMSGSIZE;
+		} else {
+			ref = dpll_xa_ref_dpll_find(&pin->dpll_refs, dpll);
+			if (!ref)
+				return -EFAULT;
+			ret = dpll_msg_add_pin_on_dpll_state(msg, pin, ref,
+							     NULL);
+			if (ret)
+				return ret;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static int
+dpll_send_event_create(enum dpll_event event, struct dpll_device *dpll)
+{
+	struct sk_buff *msg;
+	int ret = -EMSGSIZE;
+	void *hdr;
+
+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, 0, 0, &dpll_nl_family, 0, event);
+	if (!hdr)
+		goto out_free_msg;
+
+	ret = dpll_msg_add_dev_handle(msg, dpll);
+	if (ret)
+		goto out_cancel_msg;
+	genlmsg_end(msg, hdr);
+	genlmsg_multicast(&dpll_nl_family, msg, 0, 0, GFP_KERNEL);
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
+static int
+dpll_send_event_change(struct dpll_device *dpll, struct dpll_pin *pin,
+		       struct dpll_pin *parent, enum dplla attr)
+{
+	struct sk_buff *msg;
+	int ret = -EMSGSIZE;
+	void *hdr;
+
+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, 0, 0, &dpll_nl_family, 0,
+			  DPLL_EVENT_DEVICE_CHANGE);
+	if (!hdr)
+		goto out_free_msg;
+
+	ret = dpll_event_device_change(msg, dpll, pin, parent, attr);
+	if (ret)
+		goto out_cancel_msg;
+	genlmsg_end(msg, hdr);
+	genlmsg_multicast(&dpll_nl_family, msg, 0, 0, GFP_KERNEL);
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
+int dpll_device_notify(struct dpll_device *dpll, enum dplla attr)
+{
+	if (WARN_ON(!dpll))
+		return -EINVAL;
+
+	return dpll_send_event_change(dpll, NULL, NULL, attr);
+}
+EXPORT_SYMBOL_GPL(dpll_device_notify);
+
+int dpll_pin_notify(struct dpll_device *dpll, struct dpll_pin *pin,
+		    enum dplla attr)
+{
+	return dpll_send_event_change(dpll, pin, NULL, attr);
+}
+
+int dpll_pin_parent_notify(struct dpll_device *dpll, struct dpll_pin *pin,
+			   struct dpll_pin *parent, enum dplla attr)
+{
+	return dpll_send_event_change(dpll, pin, parent, attr);
+}
+
+int __init dpll_netlink_init(void)
+{
+	return genl_register_family(&dpll_nl_family);
+}
+
+void dpll_netlink_finish(void)
+{
+	genl_unregister_family(&dpll_nl_family);
+}
+
+void __exit dpll_netlink_fini(void)
+{
+	dpll_netlink_finish();
+}
diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
new file mode 100644
index 000000000000..072efa10f0e6
--- /dev/null
+++ b/drivers/dpll/dpll_netlink.h
@@ -0,0 +1,30 @@
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
+int dpll_pin_notify(struct dpll_device *dpll, struct dpll_pin *pin,
+		    enum dplla attr);
+
+int dpll_pin_parent_notify(struct dpll_device *dpll, struct dpll_pin *pin,
+			   struct dpll_pin *parent, enum dplla attr);
+
+int __init dpll_netlink_init(void);
+void dpll_netlink_finish(void);
diff --git a/include/linux/dpll.h b/include/linux/dpll.h
new file mode 100644
index 000000000000..db98b6d4bb73
--- /dev/null
+++ b/include/linux/dpll.h
@@ -0,0 +1,284 @@
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
+#include <linux/netlink.h>
+
+struct dpll_device;
+struct dpll_pin;
+
+#define PIN_IDX_INVALID		((u32)ULONG_MAX)
+
+struct dpll_device_ops {
+	int (*mode_get)(const struct dpll_device *dpll, enum dpll_mode *mode,
+			struct netlink_ext_ack *extack);
+	int (*mode_set)(const struct dpll_device *dpll,
+			const enum dpll_mode mode,
+			struct netlink_ext_ack *extack);
+	bool (*mode_supported)(const struct dpll_device *dpll,
+			       const enum dpll_mode mode,
+			       struct netlink_ext_ack *extack);
+	int (*source_pin_idx_get)(const struct dpll_device *dpll,
+				  u32 *pin_idx,
+				  struct netlink_ext_ack *extack);
+	int (*lock_status_get)(const struct dpll_device *dpll,
+			       enum dpll_lock_status *status,
+			       struct netlink_ext_ack *extack);
+	int (*temp_get)(const struct dpll_device *dpll, s32 *temp,
+			struct netlink_ext_ack *extack);
+};
+
+struct dpll_pin_ops {
+	int (*frequency_set)(const struct dpll_pin *pin,
+			     const struct dpll_device *dpll,
+			     const u32 frequency,
+			     struct netlink_ext_ack *extack);
+	int (*frequency_get)(const struct dpll_pin *pin,
+			     const struct dpll_device *dpll,
+			     u32 *frequency, struct netlink_ext_ack *extack);
+	int (*direction_set)(const struct dpll_pin *pin,
+			     const struct dpll_device *dpll,
+			     const enum dpll_pin_direction direction,
+			     struct netlink_ext_ack *extack);
+	int (*direction_get)(const struct dpll_pin *pin,
+			     const struct dpll_device *dpll,
+			     enum dpll_pin_direction *direction,
+			     struct netlink_ext_ack *extack);
+	int (*state_on_pin_get)(const struct dpll_pin *pin,
+				const struct dpll_pin *parent_pin,
+				enum dpll_pin_state *state,
+				struct netlink_ext_ack *extack);
+	int (*state_on_dpll_get)(const struct dpll_pin *pin,
+				 const struct dpll_device *dpll,
+				 enum dpll_pin_state *state,
+				 struct netlink_ext_ack *extack);
+	int (*state_on_pin_set)(const struct dpll_pin *pin,
+				const struct dpll_pin *parent_pin,
+				const enum dpll_pin_state state,
+				struct netlink_ext_ack *extack);
+	int (*state_on_dpll_set)(const struct dpll_pin *pin,
+				 const struct dpll_device *dpll,
+				 const enum dpll_pin_state state,
+				 struct netlink_ext_ack *extack);
+	int (*prio_get)(const struct dpll_pin *pin,
+			const struct dpll_device *dpll,
+			u32 *prio, struct netlink_ext_ack *extack);
+	int (*prio_set)(const struct dpll_pin *pin,
+			const struct dpll_device *dpll,
+			const u32 prio, struct netlink_ext_ack *extack);
+};
+
+struct dpll_pin_properties {
+	const char *description;
+	enum dpll_pin_type type;
+	unsigned long freq_supported;
+	u32 any_freq_min;
+	u32 any_freq_max;
+	unsigned long capabilities;
+};
+
+enum dpll_pin_freq_supp {
+	DPLL_PIN_FREQ_SUPP_UNSPEC = 0,
+	DPLL_PIN_FREQ_SUPP_1_HZ,
+	DPLL_PIN_FREQ_SUPP_10_MHZ,
+
+	__DPLL_PIN_FREQ_SUPP_MAX,
+	DPLL_PIN_FREQ_SUPP_MAX = (__DPLL_PIN_FREQ_SUPP_MAX - 1)
+};
+
+/**
+ * dpll_device_get - find or create dpll_device object
+ * @clock_id: a system unique number for a device
+ * @dev_driver_idx: index of dpll device on parent device
+ * @module: register module
+ *
+ * Returns:
+ * * pointer to initialized dpll - success
+ * * NULL - memory allocation fail
+ */
+struct dpll_device
+*dpll_device_get(u64 clock_id, u32 dev_driver_id, struct module *module);
+
+/**
+ * dpll_device_put - caller drops reference to the device, free resources
+ * @dpll: dpll device pointer
+ *
+ * If all dpll_device_get callers drops their reference, the dpll device
+ * resources are freed.
+ */
+void dpll_device_put(struct dpll_device *dpll);
+
+/**
+ * dpll_device_register - register device, make it visible in the subsystem.
+ * @dpll: reference previously allocated with dpll_device_get
+ * @type: type of dpll
+ * @ops: callbacks
+ * @priv: private data of registerer
+ * @owner: device struct of the owner
+ *
+ */
+int dpll_device_register(struct dpll_device *dpll, enum dpll_type type,
+			 struct dpll_device_ops *ops, void *priv,
+			 struct device *owner);
+
+/**
+ * dpll_device_unregister - deregister registered dpll
+ * @dpll: pointer to dpll
+ *
+ * Unregister the dpll from the subsystem, make it unavailable for netlink
+ * API users.
+ */
+void dpll_device_unregister(struct dpll_device *dpll);
+
+/**
+ * dpll_priv - get dpll private data
+ * @dpll: pointer to dpll
+ *
+ * Obtain private data pointer passed to dpll subsystem when allocating
+ * device with ``dpll_device_alloc(..)``
+ */
+void *dpll_priv(const struct dpll_device *dpll);
+
+/**
+ * dpll_pin_on_pin_priv - get pin on pin pair private data
+ * @parent: pointer to a parent pin
+ * @pin: pointer to a dpll_pin
+ *
+ * Obtain private pin data pointer passed to dpll subsystem when pin
+ * was registered with parent pin.
+ */
+void *dpll_pin_on_pin_priv(const struct dpll_pin *parent, const struct dpll_pin *pin);
+
+/**
+ * dpll_pin_on_dpll_priv - get pin on dpll pair private data
+ * @dpll: pointer to dpll
+ * @pin: pointer to a dpll_pin
+ *
+ * Obtain private pin-dpll pair data pointer passed to dpll subsystem when pin
+ * was registered with a dpll.
+ */
+void *dpll_pin_on_dpll_priv(const struct dpll_device *dpll, const struct dpll_pin *pin);
+
+/**
+ * dpll_pin_get - get reference or create new pin object
+ * @clock_id: a system unique number of a device
+ * @dev_driver_idx: index of dpll device on parent device
+ * @module: register module
+ * @pin_prop: constant properities of a pin
+ *
+ * find existing pin with given clock_id, dev_driver_idx and module, or create new
+ * and returen its reference.
+ *
+ * Returns:
+ * * pointer to initialized pin - success
+ * * NULL - memory allocation fail
+ */
+struct dpll_pin
+*dpll_pin_get(u64 clock_id, u32 dev_driver_id, struct module *module,
+	      const struct dpll_pin_properties *pin_prop);
+
+/**
+ * dpll_pin_register - register pin with a dpll device
+ * @dpll: pointer to dpll object to register pin with
+ * @pin: pointer to allocated pin object being registered with dpll
+ * @ops: struct with pin ops callbacks
+ * @priv: private data pointer passed when calling callback ops
+ * @rclk_device: pointer to device struct if pin is used for recovery of a clock
+ * from that device
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
+		      struct dpll_pin_ops *ops, void *priv,
+		      struct device *rclk_device);
+
+/**
+ * dpll_pin_unregister - deregister pin from a dpll device
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
+int dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin);
+
+/**
+ * dpll_pin_put - drop reference to a pin acquired with dpll_pin_get
+ * @pin: pointer to allocated pin
+ *
+ * Pins shall be deregistered from all dpll devices before putting them,
+ * otherwise the memory won't be freed.
+ */
+void dpll_pin_put(struct dpll_pin *pin);
+
+/**
+ * dpll_pin_on_pin_register - register a pin to a muxed-type pin
+ * @parent: parent pin pointer
+ * @pin: pointer to allocated pin object being registered with a parent pin
+ * @ops: struct with pin ops callbacks
+ * @priv: private data pointer passed when calling callback ops
+ * @rclk_device: pointer to device struct if pin is used for recovery of a clock
+ * from that device
+ *
+ * In case of multiplexed pins, allows registring them under a single
+ * parent pin.
+ *
+ * Return:
+ * * 0 - if pin was registered with a parent pin,
+ * * -ENOMEM - failed to allocate memory,
+ * * -EEXIST - pin already registered with this parent pin,
+ */
+int dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *pin,
+			     struct dpll_pin_ops *ops, void *priv,
+			     struct device *rclk_device);
+
+/**
+ * dpll_pin_on_pin_register - register a pin to a muxed-type pin
+ * @parent: parent pin pointer
+ * @pin: pointer to allocated pin object being registered with a parent pin
+ * @ops: struct with pin ops callbacks
+ * @priv: private data pointer passed when calling callback ops
+ * @rclk_device: pointer to device struct if pin is used for recovery of a clock
+ * from that device
+ *
+ * In case of multiplexed pins, allows registring them under a single
+ * parent pin.
+ *
+ * Return:
+ * * 0 - if pin was registered with a parent pin,
+ * * -ENOMEM - failed to allocate memory,
+ * * -EEXIST - pin already registered with this parent pin,
+ */
+void dpll_pin_on_pin_unregister(struct dpll_pin *parent, struct dpll_pin *pin);
+
+/**
+ * dpll_device_notify - notify on dpll device change
+ * @dpll: dpll device pointer
+ * @attr: changed attribute
+ *
+ * Broadcast event to the netlink multicast registered listeners.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - error
+ */
+int dpll_device_notify(struct dpll_device *dpll, enum dplla attr);
+
+
+#endif
-- 
2.34.1

