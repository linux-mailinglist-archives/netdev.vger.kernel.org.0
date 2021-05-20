Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D7A38B122
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 16:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243705AbhETOKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 10:10:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:5047 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243757AbhETOJ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 10:09:28 -0400
IronPort-SDR: Gyj4mawADLZNprhqTfDFXNTEoVi6iHUzqYcuibaBzlG3ZNNKWvOoGyVa3j/EAO87KC5WstJUkr
 rHQ+fjWCIdog==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="198144793"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="198144793"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 07:03:07 -0700
IronPort-SDR: wkfWrmzoOmnWUuN1tqsH5xsRwZ9dfXE7MMlizUqm7SyCXjAQD0/g/kbNkOn1GHdfM6IuCSk4Sa
 M0lNqWI8+dwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="631407654"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by fmsmga005.fm.intel.com with ESMTP; 20 May 2021 07:03:05 -0700
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Subject: [PATCH V3 14/16] net: iosm: uevent support
Date:   Thu, 20 May 2021 19:31:56 +0530
Message-Id: <20210520140158.10132-15-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210520140158.10132-1-m.chetan.kumar@intel.com>
References: <20210520140158.10132-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report modem status via uevent.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
v3: no change.
v2: Removed non-related header file inclusion.
---
 drivers/net/wwan/iosm/iosm_ipc_uevent.c | 44 +++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_uevent.h | 41 +++++++++++++++++++++++
 2 files changed, 85 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_uevent.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_uevent.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_uevent.c b/drivers/net/wwan/iosm/iosm_ipc_uevent.c
new file mode 100644
index 000000000000..2229d752926c
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_uevent.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020-21 Intel Corporation.
+ */
+
+#include <linux/device.h>
+#include <linux/kobject.h>
+#include <linux/slab.h>
+
+#include "iosm_ipc_uevent.h"
+
+/* Update the uevent in work queue context */
+static void ipc_uevent_work(struct work_struct *data)
+{
+	struct ipc_uevent_info *info;
+	char *envp[2] = { NULL, NULL };
+
+	info = container_of(data, struct ipc_uevent_info, work);
+
+	envp[0] = info->uevent;
+
+	if (kobject_uevent_env(&info->dev->kobj, KOBJ_CHANGE, envp))
+		pr_err("uevent %s failed to sent", info->uevent);
+
+	kfree(info);
+}
+
+void ipc_uevent_send(struct device *dev, char *uevent)
+{
+	struct ipc_uevent_info *info = kzalloc(sizeof(*info), GFP_ATOMIC);
+
+	if (!info)
+		return;
+
+	/* Initialize the kernel work queue */
+	INIT_WORK(&info->work, ipc_uevent_work);
+
+	/* Store the device and event information */
+	info->dev = dev;
+	snprintf(info->uevent, MAX_UEVENT_LEN, "%s: %s", dev_name(dev), uevent);
+
+	/* Schedule uevent in process context using work queue */
+	schedule_work(&info->work);
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_uevent.h b/drivers/net/wwan/iosm/iosm_ipc_uevent.h
new file mode 100644
index 000000000000..2e45c051b5f4
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_uevent.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020-21 Intel Corporation.
+ */
+
+#ifndef IOSM_IPC_UEVENT_H
+#define IOSM_IPC_UEVENT_H
+
+/* Baseband event strings */
+#define UEVENT_MDM_NOT_READY "MDM_NOT_READY"
+#define UEVENT_ROM_READY "ROM_READY"
+#define UEVENT_MDM_READY "MDM_READY"
+#define UEVENT_CRASH "CRASH"
+#define UEVENT_CD_READY "CD_READY"
+#define UEVENT_CD_READY_LINK_DOWN "CD_READY_LINK_DOWN"
+#define UEVENT_MDM_TIMEOUT "MDM_TIMEOUT"
+
+/* Maximum length of user events */
+#define MAX_UEVENT_LEN 64
+
+/**
+ * struct ipc_uevent_info - Uevent information structure.
+ * @dev:	Pointer to device structure
+ * @uevent:	Uevent information
+ * @work:	Uevent work struct
+ */
+struct ipc_uevent_info {
+	struct device *dev;
+	char uevent[MAX_UEVENT_LEN];
+	struct work_struct work;
+};
+
+/**
+ * ipc_uevent_send - Send modem event to user space.
+ * @dev:	Generic device pointer
+ * @uevent:	Uevent information
+ *
+ */
+void ipc_uevent_send(struct device *dev, char *uevent);
+
+#endif
-- 
2.25.1

