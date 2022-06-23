Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67947556FAA
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 02:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344256AbiFWA5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 20:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbiFWA53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 20:57:29 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4EF141F9B
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 17:57:27 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 1ADFF5005A9;
        Thu, 23 Jun 2022 03:55:53 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 1ADFF5005A9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1655945756; bh=WjIIAQcee69mQA8ius9qJME66nBn3gBg7/S/+k2LD+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yDSS8nkEWL+uZa292e430XbP7+5VUmctFjneDms6Bt5ZCSQWy4Qm8ZR8aRuUR8Siz
         xVCTTTDF7ZuqZxvirhVDJmhcoDfqqS5Ob2qClfEg1kWhojxD4VJ5MjLjSb8LO0iHwK
         5C1wWSQOVUZatXCMR/OJIMtPgSJH6WB/l+k+rkX8=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH v1 1/3] dpll: Add DPLL framework base functions
Date:   Thu, 23 Jun 2022 03:57:15 +0300
Message-Id: <20220623005717.31040-2-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220623005717.31040-1-vfedorenko@novek.ru>
References: <20220623005717.31040-1-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@fb.com>

DPLL framework is used to represent and configure DPLL devices
in systems. Each device that has DPLL and can configure sources
and outputs can use this framework.

Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
---
 MAINTAINERS                 |   8 +
 drivers/Kconfig             |   2 +
 drivers/Makefile            |   1 +
 drivers/dpll/Kconfig        |   7 +
 drivers/dpll/Makefile       |   7 +
 drivers/dpll/dpll_core.c    | 152 +++++++++++++
 drivers/dpll/dpll_core.h    |  40 ++++
 drivers/dpll/dpll_netlink.c | 437 ++++++++++++++++++++++++++++++++++++
 drivers/dpll/dpll_netlink.h |   7 +
 include/linux/dpll.h        |  25 +++
 include/uapi/linux/dpll.h   |  77 +++++++
 11 files changed, 763 insertions(+)
 create mode 100644 drivers/dpll/Kconfig
 create mode 100644 drivers/dpll/Makefile
 create mode 100644 drivers/dpll/dpll_core.c
 create mode 100644 drivers/dpll/dpll_core.h
 create mode 100644 drivers/dpll/dpll_netlink.c
 create mode 100644 drivers/dpll/dpll_netlink.h
 create mode 100644 include/linux/dpll.h
 create mode 100644 include/uapi/linux/dpll.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 05fcbea3e432..5532130baf36 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6122,6 +6122,14 @@ F:	Documentation/networking/device_drivers/ethernet/freescale/dpaa2/switch-drive
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
 DPT_I2O SCSI RAID DRIVER
 M:	Adaptec OEM Raid Solutions <aacraid@microsemi.com>
 L:	linux-scsi@vger.kernel.org
diff --git a/drivers/Kconfig b/drivers/Kconfig
index b6a172d32a7d..dcdc23116eb8 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -241,4 +241,6 @@ source "drivers/peci/Kconfig"
 
 source "drivers/hte/Kconfig"
 
+source "drivers/dpll/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 9a30842b22c5..acc370a2cda6 100644
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
index 000000000000..0748c80097e4
--- /dev/null
+++ b/drivers/dpll/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for DPLL drivers.
+#
+
+obj-$(CONFIG_DPLL)          += dpll_sys.o
+dpll_sys-y                  += dpll_core.o dpll_netlink.o
diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
new file mode 100644
index 000000000000..e34767e723cf
--- /dev/null
+++ b/drivers/dpll/dpll_core.c
@@ -0,0 +1,152 @@
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
+static DEFINE_MUTEX(dpll_device_xa_lock);
+static DEFINE_XARRAY_FLAGS(dpll_device_xa, XA_FLAGS_ALLOC);
+#define DPLL_REGISTERED XA_MARK_1
+
+#define ASSERT_DPLL_REGISTERED(d)                                           \
+	WARN_ON_ONCE(!xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
+#define ASSERT_DPLL_NOT_REGISTERED(d)                                      \
+	WARN_ON_ONCE(xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
+
+
+int for_each_dpll_device(int id, int (*cb)(struct dpll_device *, void *), void *data)
+{
+	struct dpll_device *dpll;
+	unsigned long index;
+	int ret = 0;
+
+	mutex_lock(&dpll_device_xa_lock);
+	xa_for_each_start(&dpll_device_xa, index, dpll, id) {
+		if (!xa_get_mark(&dpll_device_xa, index, DPLL_REGISTERED))
+			continue;
+		ret = cb(dpll, data);
+		if (ret)
+			break;
+	}
+	mutex_unlock(&dpll_device_xa_lock);
+
+	return ret;
+}
+
+struct dpll_device *dpll_device_get_by_id(int id)
+{
+	struct dpll_device *dpll = NULL;
+
+	if (xa_get_mark(&dpll_device_xa, id, DPLL_REGISTERED))
+		dpll = xa_load(&dpll_device_xa, id);
+	return dpll;
+}
+
+void *dpll_priv(struct dpll_device *dpll)
+{
+	return dpll->priv;
+}
+EXPORT_SYMBOL_GPL(dpll_priv);
+
+static void dpll_device_release(struct device *dev)
+{
+	struct dpll_device *dpll;
+
+	dpll = to_dpll_device(dev);
+
+	dpll_device_unregister(dpll);
+
+	mutex_destroy(&dpll->lock);
+	kfree(dpll);
+}
+
+static struct class dpll_class = {
+	.name = "dpll",
+	.dev_release = dpll_device_release,
+};
+
+struct dpll_device *dpll_device_alloc(struct dpll_device_ops *ops, int sources_count,
+					 int outputs_count, void *priv)
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
+	dpll->sources_count = sources_count;
+	dpll->outputs_count = outputs_count;
+
+	mutex_lock(&dpll_device_xa_lock);
+	ret = xa_alloc(&dpll_device_xa, &dpll->id, dpll, xa_limit_16b, GFP_KERNEL);
+	if (ret)
+		goto error;
+	dev_set_name(&dpll->dev, "dpll%d", dpll->id);
+	mutex_unlock(&dpll_device_xa_lock);
+	dpll->priv = priv;
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
+void dpll_device_register(struct dpll_device *dpll)
+{
+	ASSERT_DPLL_NOT_REGISTERED(dpll);
+
+	mutex_lock(&dpll_device_xa_lock);
+	xa_set_mark(&dpll_device_xa, dpll->id, DPLL_REGISTERED);
+	dpll_notify_device_create(dpll->id, dev_name(&dpll->dev));
+	mutex_unlock(&dpll_device_xa_lock);
+}
+EXPORT_SYMBOL_GPL(dpll_device_register);
+
+void dpll_device_unregister(struct dpll_device *dpll)
+{
+	ASSERT_DPLL_REGISTERED(dpll);
+
+	mutex_lock(&dpll_device_xa_lock);
+	xa_erase(&dpll_device_xa, dpll->id);
+	mutex_unlock(&dpll_device_xa_lock);
+}
+EXPORT_SYMBOL_GPL(dpll_device_unregister);
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
index 000000000000..5ad3224d5caf
--- /dev/null
+++ b/drivers/dpll/dpll_core.h
@@ -0,0 +1,40 @@
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
+/**
+ * struct dpll_device - structure for a DPLL device
+ * @id:		unique id number for each edvice
+ * @dev:	&struct device for this dpll device
+ * @sources_count:	amount of input sources this dpll_device supports
+ * @outputs_count:	amount of outputs this dpll_device supports
+ * @ops:	operations this &dpll_device supports
+ * @lock:	mutex to serialize operations
+ * @priv:	pointer to private information of owner
+ */
+struct dpll_device {
+	int id;
+	struct device dev;
+	int sources_count;
+	int outputs_count;
+	struct dpll_device_ops *ops;
+	struct mutex lock;
+	void *priv;
+};
+
+#define to_dpll_device(_dev) \
+	container_of(_dev, struct dpll_device, dev)
+
+int for_each_dpll_device(int id, int (*cb)(struct dpll_device *, void *),
+			  void *data);
+struct dpll_device *dpll_device_get_by_id(int id);
+void dpll_device_unregister(struct dpll_device *dpll);
+#endif
diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
new file mode 100644
index 000000000000..0bbdaa6dde8e
--- /dev/null
+++ b/drivers/dpll/dpll_netlink.c
@@ -0,0 +1,437 @@
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
+static const struct genl_multicast_group dpll_genl_mcgrps[] = {
+	{ .name = DPLL_CONFIG_DEVICE_GROUP_NAME, },
+	{ .name = DPLL_CONFIG_SOURCE_GROUP_NAME, },
+	{ .name = DPLL_CONFIG_OUTPUT_GROUP_NAME, },
+	{ .name = DPLL_MONITOR_GROUP_NAME,  },
+};
+
+static const struct nla_policy dpll_genl_get_policy[] = {
+	[DPLLA_DEVICE_ID]	= { .type = NLA_U32 },
+	[DPLLA_DEVICE_NAME]	= { .type = NLA_STRING,
+				    .len = DPLL_NAME_LENGTH },
+	[DPLLA_FLAGS]		= { .type = NLA_U32 },
+};
+
+static const struct nla_policy dpll_genl_set_source_policy[] = {
+	[DPLLA_DEVICE_ID]	= { .type = NLA_U32 },
+	[DPLLA_SOURCE_ID]	= { .type = NLA_U32 },
+	[DPLLA_SOURCE_TYPE]	= { .type = NLA_U32 },
+};
+
+static const struct nla_policy dpll_genl_set_output_policy[] = {
+	[DPLLA_DEVICE_ID]	= { .type = NLA_U32 },
+	[DPLLA_OUTPUT_ID]	= { .type = NLA_U32 },
+	[DPLLA_OUTPUT_TYPE]	= { .type = NLA_U32 },
+};
+
+struct param {
+	struct netlink_callback *cb;
+	struct dpll_device *dpll;
+	struct nlattr **attrs;
+	struct sk_buff *msg;
+	int dpll_id;
+	int dpll_source_id;
+	int dpll_source_type;
+	int dpll_output_id;
+	int dpll_output_type;
+};
+
+struct dpll_dump_ctx {
+	struct dpll_device *dev;
+	int flags;
+	int pos_idx;
+	int pos_src_idx;
+	int pos_out_idx;
+};
+
+typedef int (*cb_t)(struct param *);
+
+static struct genl_family dpll_gnl_family;
+
+static struct dpll_dump_ctx *dpll_dump_context(struct netlink_callback *cb)
+{
+	return (struct dpll_dump_ctx *)cb->ctx;
+}
+
+static int __dpll_cmd_device_dump_one(struct dpll_device *dpll,
+					   struct sk_buff *msg)
+{
+	if (nla_put_u32(msg, DPLLA_DEVICE_ID, dpll->id))
+		return -EMSGSIZE;
+
+	if (nla_put_string(msg, DPLLA_DEVICE_NAME, dev_name(&dpll->dev)))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int __dpll_cmd_dump_sources(struct dpll_device *dpll,
+					   struct sk_buff *msg)
+{
+	struct nlattr *src_attr;
+	int i, ret = 0, type;
+
+	for (i = 0; i < dpll->sources_count; i++) {
+		src_attr = nla_nest_start(msg, DPLLA_SOURCE);
+		if (!src_attr) {
+			ret = -EMSGSIZE;
+			break;
+		}
+		type = dpll->ops->get_source_type(dpll, i);
+		if (nla_put_u32(msg, DPLLA_SOURCE_ID, i) ||
+		    nla_put_u32(msg, DPLLA_SOURCE_TYPE, type)) {
+			nla_nest_cancel(msg, src_attr);
+			ret = -EMSGSIZE;
+			break;
+		}
+		nla_nest_end(msg, src_attr);
+	}
+
+	return ret;
+}
+
+static int __dpll_cmd_dump_outputs(struct dpll_device *dpll,
+					   struct sk_buff *msg)
+{
+	struct nlattr *out_attr;
+	int i, ret = 0, type;
+
+	for (i = 0; i < dpll->outputs_count; i++) {
+		out_attr = nla_nest_start(msg, DPLLA_OUTPUT);
+		if (!out_attr) {
+			ret = -EMSGSIZE;
+			break;
+		}
+		type = dpll->ops->get_source_type(dpll, i);
+		if (nla_put_u32(msg, DPLLA_OUTPUT_ID, i) ||
+		    nla_put_u32(msg, DPLLA_OUTPUT_TYPE, type)) {
+			nla_nest_cancel(msg, out_attr);
+			ret = -EMSGSIZE;
+			break;
+		}
+		nla_nest_end(msg, out_attr);
+	}
+
+	return ret;
+}
+
+static int __dpll_cmd_dump_status(struct dpll_device *dpll,
+					   struct sk_buff *msg)
+{
+	int ret;
+
+	if (!dpll->ops->get_status && !dpll->ops->get_temp && !dpll->ops->get_lock_status)
+		return 0;
+
+	if (dpll->ops->get_status) {
+		ret = dpll->ops->get_status(dpll);
+		if (nla_put_u32(msg, DPLLA_STATUS, ret))
+			return -EMSGSIZE;
+	}
+
+	if (dpll->ops->get_temp) {
+		ret = dpll->ops->get_status(dpll);
+		if (nla_put_u32(msg, DPLLA_TEMP, ret))
+			return -EMSGSIZE;
+	}
+
+	if (dpll->ops->get_lock_status) {
+		ret = dpll->ops->get_lock_status(dpll);
+		if (nla_put_u32(msg, DPLLA_LOCK_STATUS, ret))
+			return -EMSGSIZE;
+	}
+
+	return 0;
+}
+
+static int dpll_device_dump_one(struct dpll_device *dev, struct sk_buff *msg, int flags)
+{
+	struct nlattr *hdr;
+	int ret;
+
+	hdr = nla_nest_start(msg, DPLLA_DEVICE);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	mutex_lock(&dev->lock);
+	ret = __dpll_cmd_device_dump_one(dev, msg);
+	if (ret)
+		goto out_cancel_nest;
+
+	if (flags & DPLL_FLAG_SOURCES && dev->ops->get_source_type) {
+		ret = __dpll_cmd_dump_sources(dev, msg);
+		if (ret)
+			goto out_cancel_nest;
+	}
+
+	if (flags & DPLL_FLAG_OUTPUTS && dev->ops->get_output_type) {
+		ret = __dpll_cmd_dump_outputs(dev, msg);
+		if (ret)
+			goto out_cancel_nest;
+	}
+
+	if (flags & DPLL_FLAG_STATUS) {
+		ret = __dpll_cmd_dump_status(dev, msg);
+		if (ret)
+			goto out_cancel_nest;
+	}
+
+	mutex_unlock(&dev->lock);
+	nla_nest_end(msg, hdr);
+
+	return 0;
+
+out_cancel_nest:
+	mutex_unlock(&dev->lock);
+	nla_nest_cancel(msg, hdr);
+
+	return ret;
+}
+
+static int dpll_genl_cmd_set_source(struct param *p)
+{
+	const struct genl_dumpit_info *info = genl_dumpit_info(p->cb);
+	struct dpll_device *dpll = p->dpll;
+	int ret = 0, src_id, type;
+
+	if (!info->attrs[DPLLA_SOURCE_ID] ||
+	    !info->attrs[DPLLA_SOURCE_TYPE])
+		return -EINVAL;
+
+	if (!dpll->ops->set_source_type)
+		return -EOPNOTSUPP;
+
+	src_id = nla_get_u32(info->attrs[DPLLA_SOURCE_ID]);
+	type = nla_get_u32(info->attrs[DPLLA_SOURCE_TYPE]);
+
+	mutex_lock(&dpll->lock);
+	ret = dpll->ops->set_source_type(dpll, src_id, type);
+	mutex_unlock(&dpll->lock);
+
+	return ret;
+}
+
+static int dpll_genl_cmd_set_output(struct param *p)
+{
+	const struct genl_dumpit_info *info = genl_dumpit_info(p->cb);
+	struct dpll_device *dpll = p->dpll;
+	int ret = 0, out_id, type;
+
+	if (!info->attrs[DPLLA_OUTPUT_ID] ||
+	    !info->attrs[DPLLA_OUTPUT_TYPE])
+		return -EINVAL;
+
+	if (!dpll->ops->set_output_type)
+		return -EOPNOTSUPP;
+
+	out_id = nla_get_u32(info->attrs[DPLLA_OUTPUT_ID]);
+	type = nla_get_u32(info->attrs[DPLLA_OUTPUT_TYPE]);
+
+	mutex_lock(&dpll->lock);
+	ret = dpll->ops->set_source_type(dpll, out_id, type);
+	mutex_unlock(&dpll->lock);
+
+	return ret;
+}
+
+static int dpll_device_loop_cb(struct dpll_device *dpll, void *data)
+{
+	struct dpll_dump_ctx *ctx;
+	struct param *p = (struct param *)data;
+
+	ctx = dpll_dump_context(p->cb);
+
+	ctx->pos_idx = dpll->id;
+
+	return dpll_device_dump_one(dpll, p->msg, ctx->flags);
+}
+
+static int dpll_cmd_device_dump(struct param *p)
+{
+	struct dpll_dump_ctx *ctx = dpll_dump_context(p->cb);
+
+	return for_each_dpll_device(ctx->pos_idx, dpll_device_loop_cb, p);
+}
+
+static int dpll_genl_cmd_device_get_id(struct param *p)
+{
+	struct dpll_device *dpll = p->dpll;
+	int flags = 0;
+
+	if (p->attrs[DPLLA_FLAGS])
+		flags = nla_get_u32(p->attrs[DPLLA_FLAGS]);
+
+	return dpll_device_dump_one(dpll, p->msg, flags);
+}
+
+static cb_t cmd_doit_cb[] = {
+	[DPLL_CMD_DEVICE_GET]		= dpll_genl_cmd_device_get_id,
+	[DPLL_CMD_SET_SOURCE_TYPE]	= dpll_genl_cmd_set_source,
+	[DPLL_CMD_SET_OUTPUT_TYPE]	= dpll_genl_cmd_set_output,
+};
+
+static cb_t cmd_dump_cb[] = {
+	[DPLL_CMD_DEVICE_GET]		= dpll_cmd_device_dump,
+};
+
+static int dpll_genl_cmd_start(struct netlink_callback *cb)
+{
+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
+	struct dpll_dump_ctx *ctx = dpll_dump_context(cb);
+
+	ctx->dev = NULL;
+	if (info->attrs[DPLLA_FLAGS])
+		ctx->flags = nla_get_u32(info->attrs[DPLLA_FLAGS]);
+	else
+		ctx->flags = 0;
+	ctx->pos_idx = 0;
+	ctx->pos_src_idx = 0;
+	ctx->pos_out_idx = 0;
+	return 0;
+}
+
+static int dpll_genl_cmd_dumpit(struct sk_buff *skb,
+				   struct netlink_callback *cb)
+{
+	struct param p = { .cb = cb, .msg = skb };
+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
+	int cmd = info->op.cmd;
+	int ret;
+	void *hdr;
+
+	hdr = genlmsg_put(skb, 0, 0, &dpll_gnl_family, 0, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	ret = cmd_dump_cb[cmd](&p);
+	if (ret)
+		goto out_cancel_msg;
+
+	genlmsg_end(skb, hdr);
+
+	return 0;
+
+out_cancel_msg:
+	genlmsg_cancel(skb, hdr);
+
+	return ret;
+}
+
+static int dpll_genl_cmd_doit(struct sk_buff *skb,
+				 struct genl_info *info)
+{
+	struct param p = { .attrs = info->attrs, .dpll = info->user_ptr[0] };
+	int cmd = info->genlhdr->cmd;
+	struct sk_buff *msg;
+	void *hdr;
+	int ret;
+
+	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+	p.msg = msg;
+
+	hdr = genlmsg_put_reply(msg, info, &dpll_gnl_family, 0, cmd);
+	if (!hdr) {
+		ret = -EMSGSIZE;
+		goto out_free_msg;
+	}
+
+	ret = cmd_doit_cb[cmd](&p);
+	if (ret)
+		goto out_cancel_msg;
+
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_reply(msg, info);
+
+out_cancel_msg:
+	genlmsg_cancel(msg, hdr);
+out_free_msg:
+	nlmsg_free(msg);
+
+	return ret;
+}
+
+static int dpll_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
+						 struct genl_info *info)
+{
+	struct dpll_device *dpll;
+	int id;
+
+	if (!info->attrs[DPLLA_DEVICE_ID])
+		return -EINVAL;
+	id = nla_get_u32(info->attrs[DPLLA_DEVICE_ID]);
+
+	dpll = dpll_device_get_by_id(id);
+	if (!dpll)
+		return -ENODEV;
+	info->user_ptr[0] = dpll;
+
+	return 0;
+}
+
+static const struct genl_ops dpll_genl_ops[] = {
+	{
+		.cmd	= DPLL_CMD_DEVICE_GET,
+		.start	= dpll_genl_cmd_start,
+		.dumpit	= dpll_genl_cmd_dumpit,
+		.doit	= dpll_genl_cmd_doit,
+		.policy	= dpll_genl_get_policy,
+		.maxattr = ARRAY_SIZE(dpll_genl_get_policy) - 1,
+	},
+	{
+		.cmd	= DPLL_CMD_SET_SOURCE_TYPE,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= dpll_genl_cmd_doit,
+		.policy	= dpll_genl_set_source_policy,
+		.maxattr = ARRAY_SIZE(dpll_genl_set_source_policy) - 1,
+	},
+	{
+		.cmd	= DPLL_CMD_SET_OUTPUT_TYPE,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= dpll_genl_cmd_doit,
+		.policy	= dpll_genl_set_output_policy,
+		.maxattr = ARRAY_SIZE(dpll_genl_set_output_policy) - 1,
+	},
+};
+
+static struct genl_family dpll_gnl_family __ro_after_init = {
+	.hdrsize	= 0,
+	.name		= DPLL_FAMILY_NAME,
+	.version	= DPLL_VERSION,
+	.ops		= dpll_genl_ops,
+	.n_ops		= ARRAY_SIZE(dpll_genl_ops),
+	.mcgrps		= dpll_genl_mcgrps,
+	.n_mcgrps	= ARRAY_SIZE(dpll_genl_mcgrps),
+	.pre_doit	= dpll_pre_doit,
+};
+
+int __init dpll_netlink_init(void)
+{
+	return genl_register_family(&dpll_gnl_family);
+}
+
+void dpll_netlink_finish(void)
+{
+	genl_unregister_family(&dpll_gnl_family);
+}
+
+void __exit dpll_netlink_fini(void)
+{
+	dpll_netlink_finish();
+}
diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
new file mode 100644
index 000000000000..e2d100f59dd6
--- /dev/null
+++ b/drivers/dpll/dpll_netlink.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
+ */
+
+int __init dpll_netlink_init(void);
+void dpll_netlink_finish(void);
diff --git a/include/linux/dpll.h b/include/linux/dpll.h
new file mode 100644
index 000000000000..9051337bcf9e
--- /dev/null
+++ b/include/linux/dpll.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  Copyright (c) 2021 Meta Platforms, Inc. and affiliates
+ */
+
+#ifndef __DPLL_H__
+#define __DPLL_H__
+
+struct dpll_device;
+
+struct dpll_device_ops {
+	int (*get_status)(struct dpll_device *dpll);
+	int (*get_temp)(struct dpll_device *dpll);
+	int (*get_lock_status)(struct dpll_device *dpll);
+	int (*get_source_type)(struct dpll_device *dpll, int id);
+	int (*get_output_type)(struct dpll_device *dpll, int id);
+	int (*set_source_type)(struct dpll_device *dpll, int id, int val);
+	int (*set_output_type)(struct dpll_device *dpll, int id, int val);
+};
+
+struct dpll_device *dpll_device_alloc(struct dpll_device_ops *ops, int sources_count,
+					 int outputs_count, void *priv);
+void dpll_device_register(struct dpll_device *dpll);
+void *dpll_priv(struct dpll_device *dpll);
+#endif
diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
new file mode 100644
index 000000000000..8c00f52736ee
--- /dev/null
+++ b/include/uapi/linux/dpll.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_DPLL_H
+#define _UAPI_LINUX_DPLL_H
+
+#define DPLL_NAME_LENGTH	20
+
+/* Adding event notification support elements */
+#define DPLL_FAMILY_NAME		"dpll"
+#define DPLL_VERSION			0x01
+#define DPLL_CONFIG_DEVICE_GROUP_NAME  "config"
+#define DPLL_CONFIG_SOURCE_GROUP_NAME  "source"
+#define DPLL_CONFIG_OUTPUT_GROUP_NAME  "output"
+#define DPLL_MONITOR_GROUP_NAME        "monitor"
+
+#define DPLL_FLAG_SOURCES	1
+#define DPLL_FLAG_OUTPUTS	2
+#define DPLL_FLAG_STATUS	4
+
+/* Attributes of dpll_genl_family */
+enum dpll_genl_get_attr {
+	DPLLA_UNSPEC,
+	DPLLA_DEVICE,
+	DPLLA_DEVICE_ID,
+	DPLLA_DEVICE_NAME,
+	DPLLA_SOURCE,
+	DPLLA_SOURCE_ID,
+	DPLLA_SOURCE_TYPE,
+	DPLLA_OUTPUT,
+	DPLLA_OUTPUT_ID,
+	DPLLA_OUTPUT_TYPE,
+	DPLLA_STATUS,
+	DPLLA_TEMP,
+	DPLLA_LOCK_STATUS,
+	DPLLA_FLAGS,
+
+	__DPLLA_MAX,
+};
+#define DPLLA_GET_MAX (__DPLLA_MAX - 1)
+
+/* DPLL signal types used as source or as output */
+enum dpll_genl_signal_type {
+	DPLL_TYPE_EXT_1PPS,
+	DPLL_TYPE_EXT_10MHZ,
+	DPLL_TYPE_SYNCE_ETH_PORT,
+	DPLL_TYPE_INT_OSCILLATOR,
+	DPLL_TYPE_GNSS,
+
+	__DPLL_TYPE_MAX,
+};
+#define DPLL_TYPE_MAX (__DPLL_TYPE_MAX - 1)
+
+/* Events of dpll_genl_family */
+enum dpll_genl_event {
+	DPLL_EVENT_UNSPEC,
+	DPLL_EVENT_DEVICE_CREATE,		/* DPLL device creation */
+	DPLL_EVENT_DEVICE_DELETE,		/* DPLL device deletion */
+	DPLL_EVENT_STATUS_LOCKED,		/* DPLL device locked to source */
+	DPLL_EVENT_STATUS_UNLOCKED,	/* DPLL device freerun */
+	DPLL_EVENT_SOURCE_CHANGE,		/* DPLL device source changed */
+	DPLL_EVENT_OUTPUT_CHANGE,		/* DPLL device output changed */
+
+	__DPLL_EVENT_MAX,
+};
+#define DPLL_EVENT_MAX (__DPLL_EVENT_MAX - 1)
+
+/* Commands supported by the dpll_genl_family */
+enum dpll_genl_cmd {
+	DPLL_CMD_UNSPEC,
+	DPLL_CMD_DEVICE_GET,	/* List of DPLL devices id */
+	DPLL_CMD_SET_SOURCE_TYPE,	/* Set the DPLL device source type */
+	DPLL_CMD_SET_OUTPUT_TYPE,	/* Get the DPLL device output type */
+
+	__DPLL_CMD_MAX,
+};
+#define DPLL_CMD_MAX (__DPLL_CMD_MAX - 1)
+
+#endif /* _UAPI_LINUX_DPLL_H */
-- 
2.27.0

