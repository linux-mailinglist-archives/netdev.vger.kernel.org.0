Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C775D38B101
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 16:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242382AbhETOIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 10:08:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:5245 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243570AbhETOHh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 10:07:37 -0400
IronPort-SDR: j6pCmUx1zSoAlB4EN12NfQZFFEnH1j6xRuF031ciXC93ZpozFrMTnxp8S72aWJuhkY19fBjLP9
 wun+rhy5bqRA==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="198144582"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="198144582"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 07:02:43 -0700
IronPort-SDR: pBH3Nd0mnjVctBddZGbf5R4AcZuql1DxjzQJMUwxeXn8LPC1K75FCc0Vg+GexL2blqeVNv7vQa
 LEc+5qK+hkdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="631407541"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by fmsmga005.fm.intel.com with ESMTP; 20 May 2021 07:02:41 -0700
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Subject: [PATCH V3 06/16] net: iosm: channel configuration
Date:   Thu, 20 May 2021 19:31:48 +0530
Message-Id: <20210520140158.10132-7-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210520140158.10132-1-m.chetan.kumar@intel.com>
References: <20210520140158.10132-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Defines pipes & channel configurations like channel type,
pipe mappings, No. of transfer descriptors and transfer
buffer size etc.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
v3: WWAN port adaptation.
v2:
* Return proper error code instead of returning -1.
* Define IPC channels in serial order.
---
 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c | 88 +++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h | 59 +++++++++++++++
 2 files changed, 147 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c b/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
new file mode 100644
index 000000000000..d408d8967300
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020-21 Intel Corporation.
+ */
+
+#include <linux/wwan.h>
+
+#include "iosm_ipc_chnl_cfg.h"
+
+/* Max. sizes of a downlink buffers */
+#define IPC_MEM_MAX_DL_FLASH_BUF_SIZE (16 * 1024)
+#define IPC_MEM_MAX_DL_LOOPBACK_SIZE (1 * 1024 * 1024)
+#define IPC_MEM_MAX_DL_AT_BUF_SIZE 2048
+#define IPC_MEM_MAX_DL_RPC_BUF_SIZE (32 * 1024)
+#define IPC_MEM_MAX_DL_MBIM_BUF_SIZE IPC_MEM_MAX_DL_RPC_BUF_SIZE
+
+/* Max. transfer descriptors for a pipe. */
+#define IPC_MEM_MAX_TDS_FLASH_DL 3
+#define IPC_MEM_MAX_TDS_FLASH_UL 6
+#define IPC_MEM_MAX_TDS_AT 4
+#define IPC_MEM_MAX_TDS_RPC 4
+#define IPC_MEM_MAX_TDS_MBIM IPC_MEM_MAX_TDS_RPC
+#define IPC_MEM_MAX_TDS_LOOPBACK 11
+
+/* Accumulation backoff usec */
+#define IRQ_ACC_BACKOFF_OFF 0
+
+/* MUX acc backoff 1ms */
+#define IRQ_ACC_BACKOFF_MUX 1000
+
+/* Modem channel configuration table
+ * Always reserve element zero for flash channel.
+ */
+static struct ipc_chnl_cfg modem_cfg[] = {
+	/* IP Mux */
+	{ IPC_MEM_IP_CHL_ID_0, IPC_MEM_PIPE_0, IPC_MEM_PIPE_1,
+	  IPC_MEM_MAX_TDS_MUX_LITE_UL, IPC_MEM_MAX_TDS_MUX_LITE_DL,
+	  IPC_MEM_MAX_DL_MUX_LITE_BUF_SIZE, WWAN_PORT_MAX },
+	/* RPC - 0 */
+	{ IPC_MEM_CTRL_CHL_ID_1, IPC_MEM_PIPE_2, IPC_MEM_PIPE_3,
+	  IPC_MEM_MAX_TDS_RPC, IPC_MEM_MAX_TDS_RPC,
+	  IPC_MEM_MAX_DL_RPC_BUF_SIZE, WWAN_PORT_MAX },
+	/* IAT0 */
+	{ IPC_MEM_CTRL_CHL_ID_2, IPC_MEM_PIPE_4, IPC_MEM_PIPE_5,
+	  IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_DL_AT_BUF_SIZE,
+	  WWAN_PORT_AT },
+	/* Trace */
+	{ IPC_MEM_CTRL_CHL_ID_3, IPC_MEM_PIPE_6, IPC_MEM_PIPE_7,
+	  IPC_MEM_TDS_TRC, IPC_MEM_TDS_TRC, IPC_MEM_MAX_DL_TRC_BUF_SIZE,
+	  WWAN_PORT_MAX },
+	/* IAT1 */
+	{ IPC_MEM_CTRL_CHL_ID_4, IPC_MEM_PIPE_8, IPC_MEM_PIPE_9,
+	  IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_DL_AT_BUF_SIZE,
+	  WWAN_PORT_AT },
+	/* Loopback */
+	{ IPC_MEM_CTRL_CHL_ID_5, IPC_MEM_PIPE_10, IPC_MEM_PIPE_11,
+	  IPC_MEM_MAX_TDS_LOOPBACK, IPC_MEM_MAX_TDS_LOOPBACK,
+	  IPC_MEM_MAX_DL_LOOPBACK_SIZE, WWAN_PORT_MAX },
+	/* MBIM Channel */
+	{ IPC_MEM_CTRL_CHL_ID_6, IPC_MEM_PIPE_12, IPC_MEM_PIPE_13,
+	  IPC_MEM_MAX_TDS_MBIM, IPC_MEM_MAX_TDS_MBIM,
+	  IPC_MEM_MAX_DL_MBIM_BUF_SIZE, WWAN_PORT_MBIM },
+};
+
+int ipc_chnl_cfg_get(struct ipc_chnl_cfg *chnl_cfg, int index)
+{
+	int array_size = ARRAY_SIZE(modem_cfg);
+
+	if (index >= array_size) {
+		pr_err("index: %d and array_size %d", index, array_size);
+		return -ECHRNG;
+	}
+
+	if (index == IPC_MEM_MUX_IP_CH_IF_ID)
+		chnl_cfg->accumulation_backoff = IRQ_ACC_BACKOFF_MUX;
+	else
+		chnl_cfg->accumulation_backoff = IRQ_ACC_BACKOFF_OFF;
+
+	chnl_cfg->ul_nr_of_entries = modem_cfg[index].ul_nr_of_entries;
+	chnl_cfg->dl_nr_of_entries = modem_cfg[index].dl_nr_of_entries;
+	chnl_cfg->dl_buf_size = modem_cfg[index].dl_buf_size;
+	chnl_cfg->id = modem_cfg[index].id;
+	chnl_cfg->ul_pipe = modem_cfg[index].ul_pipe;
+	chnl_cfg->dl_pipe = modem_cfg[index].dl_pipe;
+	chnl_cfg->wwan_port_type = modem_cfg[index].wwan_port_type;
+
+	return 0;
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h b/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h
new file mode 100644
index 000000000000..422471367f78
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020-21 Intel Corporation
+ */
+
+#ifndef IOSM_IPC_CHNL_CFG_H
+#define IOSM_IPC_CHNL_CFG_H
+
+#include "iosm_ipc_mux.h"
+
+/* Number of TDs on the trace channel */
+#define IPC_MEM_TDS_TRC 32
+
+/* Trace channel TD buffer size. */
+#define IPC_MEM_MAX_DL_TRC_BUF_SIZE 8192
+
+/* Channel ID */
+enum ipc_channel_id {
+	IPC_MEM_IP_CHL_ID_0 = 0,
+	IPC_MEM_CTRL_CHL_ID_1,
+	IPC_MEM_CTRL_CHL_ID_2,
+	IPC_MEM_CTRL_CHL_ID_3,
+	IPC_MEM_CTRL_CHL_ID_4,
+	IPC_MEM_CTRL_CHL_ID_5,
+	IPC_MEM_CTRL_CHL_ID_6,
+};
+
+/**
+ * struct ipc_chnl_cfg - IPC channel configuration structure
+ * @id:				Interface ID
+ * @ul_pipe:			Uplink datastream
+ * @dl_pipe:			Downlink datastream
+ * @ul_nr_of_entries:		Number of Transfer descriptor uplink pipe
+ * @dl_nr_of_entries:		Number of Transfer descriptor downlink pipe
+ * @dl_buf_size:		Downlink buffer size
+ * @wwan_port_type:		Wwan subsystem port type
+ * @accumulation_backoff:	Time in usec for data accumalation
+ */
+struct ipc_chnl_cfg {
+	u32 id;
+	u32 ul_pipe;
+	u32 dl_pipe;
+	u32 ul_nr_of_entries;
+	u32 dl_nr_of_entries;
+	u32 dl_buf_size;
+	u32 wwan_port_type;
+	u32 accumulation_backoff;
+};
+
+/**
+ * ipc_chnl_cfg_get - Get pipe configuration.
+ * @chnl_cfg:		Array of ipc_chnl_cfg struct
+ * @index:		Channel index (upto MAX_CHANNELS)
+ *
+ * Return: 0 on success and failure value on error
+ */
+int ipc_chnl_cfg_get(struct ipc_chnl_cfg *chnl_cfg, int index);
+
+#endif
-- 
2.25.1

