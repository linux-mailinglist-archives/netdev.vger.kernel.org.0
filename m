Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C332ED522
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbhAGRHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:07:30 -0500
Received: from mga14.intel.com ([192.55.52.115]:53942 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729081AbhAGRH3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 12:07:29 -0500
IronPort-SDR: K6ccX36oliDOaFiDjBQZaKzex/9KJuxdsCFK2mMOBs6tp6fVhe88/N8WoWytPYt9RUVITTTgi4
 6YBih9qFeQkQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="176681037"
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="176681037"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 09:06:36 -0800
IronPort-SDR: /l/Z8dND4oajdoCjl27XrY0mFcrifLPhMkfyiL6+N7xUvBMpItRo9FYLd0bUSDJZa2+HpiBJjN
 VCf9G4bDnFdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="422644052"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga001.jf.intel.com with ESMTP; 07 Jan 2021 09:06:34 -0800
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com
Subject: [PATCH 15/18] net: iosm: uevent support
Date:   Thu,  7 Jan 2021 22:35:20 +0530
Message-Id: <20210107170523.26531-16-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210107170523.26531-1-m.chetan.kumar@intel.com>
References: <20210107170523.26531-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report modem status via uevent.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_uevent.c | 43 +++++++++++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_uevent.h | 41 +++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_uevent.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_uevent.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_uevent.c b/drivers/net/wwan/iosm/iosm_ipc_uevent.c
new file mode 100644
index 000000000000..9040ee6f6065
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_uevent.c
@@ -0,0 +1,43 @@
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

