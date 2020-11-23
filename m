Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82B32C0C59
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388587AbgKWNwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:52:36 -0500
Received: from mga14.intel.com ([192.55.52.115]:1517 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388215AbgKWNwf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 08:52:35 -0500
IronPort-SDR: +Xj8nF9BtGVC9+3Ard/b3tVYom0F4G6bsmvc6q9/BU0aKVW8PUaDg26ppJ8Vs1xb8UMqx7R5WY
 3TwA97QMFNLA==
X-IronPort-AV: E=McAfee;i="6000,8403,9813"; a="170981507"
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="170981507"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 05:52:35 -0800
IronPort-SDR: ZpFg2E6bbIJ7ajCW1ggTmbmybcU5Y90nPijeaUgndCqKv/GfTQMadC2w5ZUqCpVxNGSkma4X6f
 ZwdLyiy5q+gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="370035655"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga007.jf.intel.com with ESMTP; 23 Nov 2020 05:52:33 -0800
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com
Subject: [RFC 15/18] net: iosm: uevent support
Date:   Mon, 23 Nov 2020 19:21:20 +0530
Message-Id: <20201123135123.48892-16-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20201123135123.48892-1-m.chetan.kumar@intel.com>
References: <20201123135123.48892-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report modem status via uevent.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_uevent.c | 47 +++++++++++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_uevent.h | 41 ++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_uevent.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_uevent.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_uevent.c b/drivers/net/wwan/iosm/iosm_ipc_uevent.c
new file mode 100644
index 000000000000..27542ca27613
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_uevent.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#include <linux/slab.h>
+
+#include "iosm_ipc_sio.h"
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
+	struct ipc_uevent_info *info;
+
+	if (!uevent || !dev)
+		return;
+
+	info = kzalloc(sizeof(*info), GFP_ATOMIC);
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
index 000000000000..422f64411c6e
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_uevent.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020 Intel Corporation.
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
2.12.3

