Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BF3410CA2
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 19:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhISR3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 13:29:21 -0400
Received: from mga04.intel.com ([192.55.52.120]:58133 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhISR3T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 13:29:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10112"; a="221149456"
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="221149456"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2021 10:27:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="483585171"
Received: from ccgwwan-adlp2.iind.intel.com ([10.224.174.127])
  by orsmga008.jf.intel.com with ESMTP; 19 Sep 2021 10:27:50 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        linuxwwan@intel.com
Subject: [PATCH V2 net-next 3/6] net: wwan: iosm: coredump collection support
Date:   Sun, 19 Sep 2021 22:57:27 +0530
Message-Id: <20210919172727.26102-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implements protocol for coredump collection.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
v2: no change.
---
 drivers/net/wwan/iosm/iosm_ipc_coredump.c | 110 ++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_coredump.h |  75 +++++++++++++++
 2 files changed, 185 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_coredump.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_coredump.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_coredump.c b/drivers/net/wwan/iosm/iosm_ipc_coredump.c
new file mode 100644
index 000000000000..fba3c3454e80
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_coredump.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020-2021 Intel Corporation.
+ */
+
+#include "iosm_ipc_coredump.h"
+
+/* Collect coredump data from modem */
+int ipc_coredump_collect(struct iosm_devlink *devlink, u8 **data, int entry,
+			 u32 region_size)
+{
+	int ret, bytes_to_read, bytes_read = 0, i = 0;
+	s32 remaining;
+	u8 *data_ptr;
+
+	data_ptr = vmalloc(region_size);
+	if (!data_ptr)
+		return -ENOMEM;
+
+	remaining = devlink->cd_file_info[entry].actual_size;
+	ret = ipc_devlink_send_cmd(devlink, rpsi_cmd_coredump_get, entry);
+	if (ret) {
+		dev_err(devlink->dev, "Send coredump_get cmd failed");
+		goto get_cd_fail;
+	}
+	while (remaining > 0) {
+		bytes_to_read = min(remaining, MAX_DATA_SIZE);
+		bytes_read = 0;
+		ret = ipc_imem_sys_devlink_read(devlink, data_ptr + i,
+						bytes_to_read, &bytes_read);
+		if (ret) {
+			dev_err(devlink->dev, "CD data read failed");
+			goto get_cd_fail;
+		}
+		remaining -= bytes_read;
+		i += bytes_read;
+	}
+
+	*data = data_ptr;
+
+	return ret;
+get_cd_fail:
+	vfree(data_ptr);
+	return ret;
+}
+
+/* Get coredump list to be collected from modem */
+int ipc_coredump_get_list(struct iosm_devlink *devlink, u16 cmd)
+{
+	u32 byte_read, num_entries, file_size;
+	struct iosm_cd_table *cd_table;
+	u8 size[MAX_SIZE_LEN], i;
+	char *filename;
+	int ret = 0;
+
+	cd_table = kzalloc(MAX_CD_LIST_SIZE, GFP_KERNEL);
+	if (!cd_table) {
+		ret = -ENOMEM;
+		goto  cd_init_fail;
+	}
+
+	ret = ipc_devlink_send_cmd(devlink, cmd, MAX_CD_LIST_SIZE);
+	if (ret) {
+		dev_err(devlink->dev, "rpsi_cmd_coredump_start failed");
+		goto cd_init_fail;
+	}
+
+	ret = ipc_imem_sys_devlink_read(devlink, (u8 *)cd_table,
+					MAX_CD_LIST_SIZE, &byte_read);
+	if (ret) {
+		dev_err(devlink->dev, "Coredump data is invalid");
+		goto cd_init_fail;
+	}
+
+	if (byte_read != MAX_CD_LIST_SIZE)
+		goto cd_init_fail;
+
+	if (cmd == rpsi_cmd_coredump_start) {
+		num_entries = le32_to_cpu(cd_table->list.num_entries);
+		if (num_entries == 0 || num_entries > IOSM_NOF_CD_REGION) {
+			ret = -EINVAL;
+			goto cd_init_fail;
+		}
+
+		for (i = 0; i < num_entries; i++) {
+			file_size = le32_to_cpu(cd_table->list.entry[i].size);
+			filename = cd_table->list.entry[i].filename;
+
+			if (file_size > devlink->cd_file_info[i].default_size) {
+				ret = -EINVAL;
+				goto cd_init_fail;
+			}
+
+			devlink->cd_file_info[i].actual_size = file_size;
+			dev_dbg(devlink->dev, "file: %s actual size %d",
+				filename, file_size);
+			devlink_flash_update_status_notify(devlink->devlink_ctx,
+							   filename,
+							   "FILENAME", 0, 0);
+			snprintf(size, sizeof(size), "%d", file_size);
+			devlink_flash_update_status_notify(devlink->devlink_ctx,
+							   size, "FILE SIZE",
+							   0, 0);
+		}
+	}
+
+cd_init_fail:
+	kfree(cd_table);
+	return ret;
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_coredump.h b/drivers/net/wwan/iosm/iosm_ipc_coredump.h
new file mode 100644
index 000000000000..d5028153c8d1
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_coredump.h
@@ -0,0 +1,75 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020-2021 Intel Corporation.
+ */
+
+#ifndef _IOSM_IPC_COREDUMP_H_
+#define _IOSM_IPC_COREDUMP_H_
+
+#include "iosm_ipc_devlink.h"
+
+/* Max number of bytes to receive for Coredump list structure */
+#define MAX_CD_LIST_SIZE  0x1000
+
+/* Max buffer allocated to receive coredump data */
+#define MAX_DATA_SIZE 0x00010000
+
+/* Max number of file entries */
+#define MAX_NOF_ENTRY 256
+
+/* Max length */
+#define MAX_SIZE_LEN 32
+
+/**
+ * struct iosm_cd_list_entry - Structure to hold coredump file info.
+ * @size:       Number of bytes for the entry
+ * @filename:   Coredump filename to be generated on host
+ */
+struct iosm_cd_list_entry {
+	__le32 size;
+	char filename[IOSM_MAX_FILENAME_LEN];
+} __packed;
+
+/**
+ * struct iosm_cd_list - Structure to hold list of coredump files
+ *                      to be collected.
+ * @num_entries:        Number of entries to be received
+ * @entry:              Contains File info
+ */
+struct iosm_cd_list {
+	__le32 num_entries;
+	struct iosm_cd_list_entry entry[MAX_NOF_ENTRY];
+} __packed;
+
+/**
+ * struct iosm_cd_table - Common Coredump table
+ * @version:            Version of coredump structure
+ * @list:               Coredump list structure
+ */
+struct iosm_cd_table {
+	__le32 version;
+	struct iosm_cd_list list;
+} __packed;
+
+/**
+ * ipc_coredump_collect - To collect coredump
+ * @devlink:		Pointer to devlink instance.
+ * @data:		Pointer to snapshot
+ * @entry:		ID of requested snapshot
+ * @region_size:	Region size
+ *
+ * Returns: 0 on success, error on failure
+ */
+int ipc_coredump_collect(struct iosm_devlink *devlink, u8 **data, int entry,
+			 u32 region_size);
+
+/**
+ * ipc_coredump_get_list - Get coredump list
+ * @devlink:         Pointer to devlink instance.
+ * @cmd:	     RPSI command to be sent
+ *
+ * Returns: 0 on success, error on failure
+ */
+int ipc_coredump_get_list(struct iosm_devlink *devlink, u16 cmd);
+
+#endif /* _IOSM_IPC_COREDUMP_H_ */
-- 
2.25.1

