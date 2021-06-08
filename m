Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E15639FD32
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 19:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbhFHRIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 13:08:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:45943 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233914AbhFHRIK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 13:08:10 -0400
IronPort-SDR: Pb4yE6L1f4T//Xo0KIDMff6Dewfu/rx7spk36t4KzS5shfyEFGPUKFQtYbnSiGy5SQ69nefIrA
 NKvgpH9LFI6Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10009"; a="204855377"
X-IronPort-AV: E=Sophos;i="5.83,258,1616482800"; 
   d="scan'208";a="204855377"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2021 10:05:53 -0700
IronPort-SDR: kL3dmvgz9Ntl1NpiwmaG5hINSVd2CQqOlqtgdTp5oK7T86PNRTwsMiZMgX4m7dtsoNQsWGB49z
 54FZHOEJj6HA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,258,1616482800"; 
   d="scan'208";a="482035582"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga001.jf.intel.com with ESMTP; 08 Jun 2021 10:05:50 -0700
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Subject: [PATCH V4 14/16] net: iosm: uevent support
Date:   Tue,  8 Jun 2021 22:34:47 +0530
Message-Id: <20210608170449.28031-15-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210608170449.28031-1-m.chetan.kumar@intel.com>
References: <20210608170449.28031-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report modem status via uevent.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
v4: no change.
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

