Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4E326ACA2
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgIOSyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 14:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727797AbgIORXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 13:23:40 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7464FC0611BD;
        Tue, 15 Sep 2020 10:11:01 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id l9so250920wme.3;
        Tue, 15 Sep 2020 10:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FEzyiF7OmjpRlNiPY9pIV++IKMq9JRTJltU75hyPACU=;
        b=GIRxODmuuH11cWnNxCuTV9hBc8/7sqxYKcJkbUwyQExZ3IlevP5H72yPule0so/wqZ
         D6ORUscIHbQ3FxV0mWdz6VCwN+0I1IeGpy/klOj0mndJGo4/zCrM0vW7NtKqR7eivArW
         xOF8Gjd/pOrjCEG/bPiAgVtUvm3BWrLxmtscFhl8HRL9LPy50Fvia4EgwTZpuhK5Bz6C
         z26Vzk6EGzbn4K6lSc2FP4afP7R5uqYD64F7tBa3PnwkSwB2K16ywFnIGELBfhXiL7VL
         mp2S5T4gjSIh6CtbSy8IYVlcgoYknYEpkIypA30hvGkj01UlXl2l/NFTxFKJMM6vvKz7
         Q3Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FEzyiF7OmjpRlNiPY9pIV++IKMq9JRTJltU75hyPACU=;
        b=M5xsGjJDOq6gZByjF69Wd3c2G6wd5vl+UPCuoOAq6vRGZ0noFR1K/2QZ7ybjbMmKzS
         92G6kJKldcH40/AlWIgojaJ2jLINQ8vPMVXZ8pimoF6jHdU3eANqezks/kiEJ5n72aBh
         QmRMhYanLqnntElD0Wk7q0CrUqQogA9XNVp7EUnv3YK4ubmnlcb0R9qYK1wMBVObNCIc
         d5pR6hL3Cc8WxvS1d3igvv08jR/wf2XYlGk+I8vRsTqvnm/KVt5yOl/luaoU1V2i8eeJ
         ncLWaE+tJJ8YgoYuKWDDTCyhKEI7Ela503Ad2yjt+YxZU5N8VLKCTm7/SDGdf2SfwUol
         rmIg==
X-Gm-Message-State: AOAM531/Vsod8L10QG5FkddFR6o1Je2KQotqMksN98kQdgV0IqjCcwLU
        EKWAqmFrfWEpXEYHQYxj3ncJPE2qm4qSlg==
X-Google-Smtp-Source: ABdhPJx5PtYwSv3I7hRt95MoHyEZNPr4sqgwItCbm6FwXaxg0FX5qITjEK3qzDaWmcs4JPdqXENQNA==
X-Received: by 2002:a7b:c1d3:: with SMTP id a19mr354193wmj.19.1600189858999;
        Tue, 15 Sep 2020 10:10:58 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id b194sm356558wmd.42.2020.09.15.10.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 10:10:57 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH v3 12/14] habanalabs/gaudi: Add ethtool support using coresight
Date:   Tue, 15 Sep 2020 20:10:20 +0300
Message-Id: <20200915171022.10561-13-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200915171022.10561-1-oded.gabbay@gmail.com>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

The driver supports ethtool callbacks and provides statistics using the
device's profiling infrastructure (coresight).

We support the basic ethtool functionality and counters, as far as our H/W
provides support.

A summary of the supported callbacks:

- get_drvinfo: fill some basic information regarding the driver
- get_link_ksettings: get basic settings like speed, duplex,
                      Auto-negotiation and link modes.
- set_link_ksettings: only speed and Auto-negotiation setting is supported.
- get_link: returns link indication.
- get_strings: get counters strings.
- get_sset_count: get counters number.
- get_ethtool_stats: get counters values.
- get_module_info: get EEPROM type and length.
- get_module_eeprom: get EEPROM (supported in raw mode only).

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
---
Changes in v3:
  - verify the offset and length before copying the eeprom dump to the user
    to prevent kernel memroy leakage
  - Remove the Tx/Rx counters titles from ethtool statistics

 drivers/misc/habanalabs/gaudi/Makefile        |   3 +-
 drivers/misc/habanalabs/gaudi/gaudi.c         |   1 +
 drivers/misc/habanalabs/gaudi/gaudiP.h        |   7 +
 .../misc/habanalabs/gaudi/gaudi_coresight.c   | 144 ++++
 drivers/misc/habanalabs/gaudi/gaudi_nic.c     |   5 +
 .../misc/habanalabs/gaudi/gaudi_nic_ethtool.c | 616 ++++++++++++++++++
 6 files changed, 775 insertions(+), 1 deletion(-)
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_ethtool.c

diff --git a/drivers/misc/habanalabs/gaudi/Makefile b/drivers/misc/habanalabs/gaudi/Makefile
index c5143cf6f025..df674c5973e0 100644
--- a/drivers/misc/habanalabs/gaudi/Makefile
+++ b/drivers/misc/habanalabs/gaudi/Makefile
@@ -2,4 +2,5 @@
 HL_GAUDI_FILES := gaudi/gaudi.o gaudi/gaudi_hwmgr.o gaudi/gaudi_security.o \
 	gaudi/gaudi_coresight.o
 
-HL_GAUDI_FILES += gaudi/gaudi_nic.o gaudi/gaudi_phy.o
+HL_GAUDI_FILES += gaudi/gaudi_nic.o gaudi/gaudi_phy.o \
+	gaudi/gaudi_nic_ethtool.o
diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 71c9e2d18032..2af07eb4165c 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -1044,6 +1044,7 @@ static int gaudi_sw_init(struct hl_device *hdev)
 	gaudi->cpucp_info_get = gaudi_cpucp_info_get;
 	gaudi->nic_handle_rx = gaudi_nic_handle_rx;
 	gaudi->nic_handle_tx = gaudi_nic_handle_tx;
+	gaudi->nic_spmu_init = gaudi_nic_spmu_init;
 
 	gaudi->max_freq_value = GAUDI_MAX_CLK_FREQ;
 
diff --git a/drivers/misc/habanalabs/gaudi/gaudiP.h b/drivers/misc/habanalabs/gaudi/gaudiP.h
index 7d7439da88bc..8b420a86c11b 100644
--- a/drivers/misc/habanalabs/gaudi/gaudiP.h
+++ b/drivers/misc/habanalabs/gaudi/gaudiP.h
@@ -438,6 +438,7 @@ struct gaudi_internal_qman_info {
  * @cpucp_info_get: get information on device from CPU-CP
  * @nic_handle_rx: NIC handler for incoming packet.
  * @nic_handle_tx: NIC handler for outgoing packet.
+ * @nic_spmu_init: initialize NIC CoreSight spmu counters.
  * @nic_devices: array that holds all NIC ports manage structures.
  * @nic_macros: array that holds all NIC macros manage structures.
  * @nic_pam4_tx_taps: array that holds all PAM4 Tx taps of all NIC lanes.
@@ -501,6 +502,7 @@ struct gaudi_device {
 	int (*cpucp_info_get)(struct hl_device *hdev);
 	void (*nic_handle_rx)(struct gaudi_nic_device *gaudi_nic);
 	int (*nic_handle_tx)(struct gaudi_nic_device *gaudi_nic, void *data);
+	void (*nic_spmu_init)(struct hl_device *hdev, int port);
 	struct gaudi_nic_device		nic_devices[NIC_NUMBER_OF_PORTS];
 	struct gaudi_nic_macro		nic_macros[NIC_NUMBER_OF_MACROS];
 	struct gaudi_nic_tx_taps	nic_pam4_tx_taps[NIC_MAX_NUM_OF_LANES];
@@ -574,8 +576,13 @@ irqreturn_t gaudi_nic_rx_irq_handler(int irq, void *arg);
 irqreturn_t gaudi_nic_cq_irq_handler(int irq, void *arg);
 netdev_tx_t gaudi_nic_handle_tx_pkt(struct gaudi_nic_device *gaudi_nic,
 					struct sk_buff *skb);
+void gaudi_nic_spmu_init(struct hl_device *hdev, int port);
 int gaudi_nic_sw_init(struct hl_device *hdev);
 void gaudi_nic_sw_fini(struct hl_device *hdev);
 void gaudi_nic_handle_qp_err(struct hl_device *hdev, u16 event_type);
+int gaudi_config_spmu_nic(struct hl_device *hdev, u32 port,
+		u32 num_event_types, u32 event_types[]);
+int gaudi_sample_spmu_nic(struct hl_device *hdev, u32 port,
+		u32 num_out_data, u64 out_data[]);
 
 #endif /* GAUDIP_H_ */
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_coresight.c b/drivers/misc/habanalabs/gaudi/gaudi_coresight.c
index 881531d4d9da..6b43501d20ad 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi_coresight.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi_coresight.c
@@ -16,6 +16,11 @@
 #define SPMU_SECTION_SIZE		MME0_ACC_SPMU_MAX_OFFSET
 #define SPMU_EVENT_TYPES_OFFSET		0x400
 #define SPMU_MAX_COUNTERS		6
+#define PMSCR				0x6F0	/* Snapshot Control */
+#define PMEVCNTSR0			0x620	/* Event Counters Snapshot */
+#define PMOVSSR				0x614	/* Overflow Status Snapshot */
+#define PMCCNTSR_L			0x618	/* Cycle Counter Snapshot */
+#define PMCCNTSR_H			0x61c	/* Cycle Counter Snapshot */
 
 static u64 debug_stm_regs[GAUDI_STM_LAST + 1] = {
 	[GAUDI_STM_MME0_ACC]	= mmMME0_ACC_STM_BASE,
@@ -752,6 +757,27 @@ static int gaudi_config_bmon(struct hl_device *hdev,
 	return 0;
 }
 
+static bool gaudi_reg_is_nic_spmu(enum gaudi_debug_spmu_regs_index reg_idx)
+{
+	switch (reg_idx) {
+	case GAUDI_SPMU_NIC0_0:
+	case GAUDI_SPMU_NIC0_1:
+	case GAUDI_SPMU_NIC1_0:
+	case GAUDI_SPMU_NIC1_1:
+	case GAUDI_SPMU_NIC2_0:
+	case GAUDI_SPMU_NIC2_1:
+	case GAUDI_SPMU_NIC3_0:
+	case GAUDI_SPMU_NIC3_1:
+	case GAUDI_SPMU_NIC4_0:
+	case GAUDI_SPMU_NIC4_1:
+		return true;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 static int gaudi_config_spmu(struct hl_device *hdev,
 		struct hl_debug_params *params)
 {
@@ -769,6 +795,16 @@ static int gaudi_config_spmu(struct hl_device *hdev,
 		return -EINVAL;
 	}
 
+	/*
+	 * NIC spmus are now configured by driver at init
+	 * and not accessible to user in dbg mode
+	 */
+	if (hdev->in_debug && gaudi_reg_is_nic_spmu(params->reg_idx)) {
+		dev_err(hdev->dev,
+			"Rejecting user debug configuration for NIC spmu\n");
+		return -EFAULT;
+	}
+
 	base_reg = debug_spmu_regs[params->reg_idx] - CFG_BASE;
 
 	if (params->enable) {
@@ -837,6 +873,114 @@ static int gaudi_config_spmu(struct hl_device *hdev,
 	return 0;
 }
 
+static int gaudi_sample_spmu(struct hl_device *hdev,
+		struct hl_debug_params *params)
+{
+	u32 output_arr_len;
+	u32 cycle_cnt_idx;
+	u32 overflow_idx;
+	u32 events_num;
+	u64 base_reg;
+	u64 *output;
+	int i;
+
+	if (params->reg_idx >= ARRAY_SIZE(debug_spmu_regs)) {
+		dev_err(hdev->dev, "Invalid register index in SPMU\n");
+		return -EINVAL;
+	}
+
+	base_reg = debug_spmu_regs[params->reg_idx] - CFG_BASE;
+
+	output = params->output;
+	output_arr_len = params->output_size / 8;
+	events_num = output_arr_len - 2;
+	overflow_idx = output_arr_len - 2;
+	cycle_cnt_idx = output_arr_len - 1;
+
+	if (!output)
+		return -EINVAL;
+
+	if (output_arr_len < 1) {
+		dev_err(hdev->dev,
+			"not enough values for SPMU sample\n");
+		return -EINVAL;
+	}
+
+	if (events_num > SPMU_MAX_COUNTERS) {
+		dev_err(hdev->dev,
+			"too many events values for SPMU sample\n");
+		return -EINVAL;
+	}
+
+	/* capture */
+	WREG32(base_reg + PMSCR, 1);
+
+	/* read the shadow registers */
+	for (i = 0 ; i < events_num ; i++)
+		output[i] = RREG32(base_reg + PMEVCNTSR0 + i * 4);
+
+	/* also get overflow and cyclecount */
+	if (output_arr_len == SPMU_MAX_COUNTERS + 2) {
+		output[overflow_idx] = RREG32(base_reg + PMOVSSR);
+
+		output[cycle_cnt_idx] = RREG32(base_reg + PMCCNTSR_H);
+		output[cycle_cnt_idx] <<= 32;
+		output[cycle_cnt_idx] |= RREG32(base_reg + PMCCNTSR_L);
+	}
+
+	return 0;
+}
+
+int gaudi_config_spmu_nic(struct hl_device *hdev, u32 port,
+		u32 num_event_types, u32 event_types[])
+{
+	struct hl_debug_params_spmu spmu;
+	struct hl_debug_params params;
+	int i;
+
+	/* validate nic port */
+	if  (!gaudi_reg_is_nic_spmu(GAUDI_SPMU_NIC0_0 + port)) {
+		dev_err(hdev->dev, "Invalid nic port %u\n", port);
+		return -EFAULT;
+	}
+
+	memset(&params, 0, sizeof(struct hl_debug_params));
+	params.op = HL_DEBUG_OP_SPMU;
+	params.input = &spmu;
+	params.enable = true;
+	params.reg_idx = GAUDI_SPMU_NIC0_0 + port;
+
+	memset(&spmu, 0, sizeof(struct hl_debug_params_spmu));
+	spmu.event_types_num  = num_event_types;
+
+	for (i = 0 ; i < spmu.event_types_num ; i++)
+		spmu.event_types[i] = event_types[i];
+
+	return gaudi_config_spmu(hdev, &params);
+}
+
+int gaudi_sample_spmu_nic(struct hl_device *hdev, u32 port,
+		u32 num_out_data, u64 out_data[])
+{
+	struct hl_debug_params params;
+
+	if (!hdev->supports_coresight)
+		return 0;
+
+	/* validate nic port */
+	if  (!gaudi_reg_is_nic_spmu(GAUDI_SPMU_NIC0_0 + port)) {
+		dev_err(hdev->dev, "Invalid nic port %u\n", port);
+		return -EFAULT;
+	}
+
+	memset(&params, 0, sizeof(struct hl_debug_params));
+	params.output = out_data;
+	params.output_size = num_out_data * sizeof(uint64_t);
+	params.reg_idx = GAUDI_SPMU_NIC0_0 + port;
+
+	return gaudi_sample_spmu(hdev, &params);
+}
+
 int gaudi_debug_coresight(struct hl_device *hdev, void *data)
 {
 	struct hl_debug_params *params = data;
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_nic.c b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
index 49e94e9c786a..c97e5f0e1c53 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi_nic.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
@@ -2778,6 +2778,7 @@ static int port_register(struct hl_device *hdev, int port)
 	ndev->dev_port = port;
 
 	ndev->netdev_ops = &gaudi_nic_netdev_ops;
+	ndev->ethtool_ops = &gaudi_nic_ethtool_ops;
 	ndev->watchdog_timeo = NIC_TX_TIMEOUT;
 	ndev->min_mtu = ETH_MIN_MTU;
 	ndev->max_mtu = NIC_MAX_MTU;
@@ -2801,6 +2802,8 @@ static int port_register(struct hl_device *hdev, int port)
 				port);
 	}
 
+	gaudi->nic_spmu_init(hdev, port);
+
 	if (register_netdev(ndev)) {
 		dev_err(hdev->dev,
 			"Could not register netdevice, port: %d\n", port);
@@ -3265,6 +3268,8 @@ void gaudi_nic_ports_reopen(struct hl_device *hdev)
 			continue;
 		}
 
+		gaudi->nic_spmu_init(hdev, port);
+
 		schedule_delayed_work(&gaudi_nic->port_open_work,
 					msecs_to_jiffies(1));
 	}
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_nic_ethtool.c b/drivers/misc/habanalabs/gaudi/gaudi_nic_ethtool.c
new file mode 100644
index 000000000000..62c8cd40c927
--- /dev/null
+++ b/drivers/misc/habanalabs/gaudi/gaudi_nic_ethtool.c
@@ -0,0 +1,616 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright 2018-2020 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ */
+
+#include "gaudi_nic.h"
+#include "../include/gaudi/asic_reg/gaudi_regs.h"
+#include <linux/pci.h>
+
+#define NIC_STATS_LEN		ARRAY_SIZE(gaudi_nic_ethtool_stats)
+#define NIC_SPMU0_STATS_LEN	ARRAY_SIZE(gaudi_nic0_spmu_event_type)
+#define NIC_SPMU1_STATS_LEN	ARRAY_SIZE(gaudi_nic1_spmu_event_type)
+#define NIC_SPMU_STATS_LEN_MAX	6
+#define NIC_MAC_STATS_RX_LEN	ARRAY_SIZE(gaudi_nic_mac_stats_rx)
+#define NIC_MAC_STATS_TX_LEN	ARRAY_SIZE(gaudi_nic_mac_stats_tx)
+#define NIC_XPCS91_REGS_CNT_LEN	ARRAY_SIZE(gaudi_nic_xpcs91_reg_type)
+#define NIC_SW_CNT_LEN		ARRAY_SIZE(gaudi_nic_sw_cnt_type)
+
+#define NIC_MAC_STAT_BLOCK_SIZE	(mmNIC1_STAT_BASE - mmNIC0_STAT_BASE)
+#define NIC_MAC_STAT_HI_PART	mmNIC0_STAT_DATA_HI_REG
+#define NIC_MAC_RX_PORT0_OFFSET	mmNIC0_STAT_ETHERSTATSOCTETS
+#define NIC_MAC_RX_PORT1_OFFSET	mmNIC0_STAT_ETHERSTATSOCTETS_2
+#define NIC_MAC_TX_PORT0_OFFSET	mmNIC0_STAT_ETHERSTATSOCTETS_4
+#define NIC_MAC_TX_PORT1_OFFSET	mmNIC0_STAT_ETHERSTATSOCTETS_6
+
+#define NIC_MAC_STAT_BASE(port) \
+			((u64) (NIC_MAC_STAT_BLOCK_SIZE * (u64) ((port) >> 1)))
+
+#define NIC_MAC_STAT_RREG32(port, reg) \
+			RREG32(NIC_MAC_STAT_BASE(port) + (reg))
+
+#define ethtool_add_mode ethtool_link_ksettings_add_link_mode
+
+struct gaudi_nic_ethtool_stats {
+	char stat_string[ETH_GSTRING_LEN];
+	int stat_offset;
+};
+
+struct gaudi_nic_spmu_event_type {
+	char stat_string[ETH_GSTRING_LEN];
+	int index;
+};
+
+struct gaudi_nic_xpcs91_reg_type {
+	char stat_string[ETH_GSTRING_LEN];
+	int lo_offset;
+	int hi_offset;
+};
+
+struct gaudi_nic_sw_cnt_type {
+	char stat_string[ETH_GSTRING_LEN];
+};
+
+#define NIC_STAT(m) {__stringify(m), offsetof(struct net_device, stats.m)}
+
+static struct gaudi_nic_ethtool_stats gaudi_nic_ethtool_stats[] = {
+	NIC_STAT(rx_packets),
+	NIC_STAT(tx_packets),
+	NIC_STAT(rx_bytes),
+	NIC_STAT(tx_bytes),
+	NIC_STAT(rx_errors),
+	NIC_STAT(tx_errors),
+	NIC_STAT(rx_dropped),
+	NIC_STAT(tx_dropped),
+	NIC_STAT(multicast),
+	NIC_STAT(collisions),
+	NIC_STAT(rx_length_errors),
+	NIC_STAT(rx_over_errors),
+	NIC_STAT(rx_crc_errors),
+	NIC_STAT(rx_frame_errors),
+	NIC_STAT(rx_fifo_errors),
+	NIC_STAT(rx_missed_errors),
+	NIC_STAT(tx_aborted_errors),
+	NIC_STAT(tx_carrier_errors),
+	NIC_STAT(tx_fifo_errors),
+	NIC_STAT(tx_heartbeat_errors),
+	NIC_STAT(tx_window_errors)
+};
+
+static struct gaudi_nic_ethtool_stats gaudi_nic_mac_stats_rx[] = {
+	{"etherStatsOctets", 0x0},
+	{"OctetsReceivedOK", 0x4},
+	{"aAlignmentErrors", 0x8},
+	{"aPAUSEMACCtrlFramesReceived", 0xC},
+	{"aFrameTooLongErrors", 0x10},
+	{"aInRangeLengthErrors", 0x14},
+	{"aFramesReceivedOK", 0x18},
+	{"VLANReceivedOK", 0x1C},
+	{"aFrameCheckSequenceErrors", 0x20},
+	{"ifInErrors", 0x24},
+	{"ifInUcastPkts", 0x28},
+	{"ifInMulticastPkts", 0x2C},
+	{"ifInBroadcastPkts", 0x30},
+	{"etherStatsDropEvents", 0x34},
+	{"etherStatsUndersizePkts", 0x38},
+	{"etherStatsPkts", 0x3C},
+	{"etherStatsPkts64Octets", 0x40},
+	{"etherStatsPkts65to127Octets", 0x44},
+	{"etherStatsPkts128to255Octets", 0x48},
+	{"etherStatsPkts256to511Octets", 0x4C},
+	{"etherStatsPkts512to1023Octets", 0x50},
+	{"etherStatsPkts1024to1518Octets", 0x54},
+	{"etherStatsPkts1519toMaxOctets", 0x58},
+	{"etherStatsOversizePkts", 0x5C},
+	{"etherStatsJabbers", 0x60},
+	{"etherStatsFragments", 0x64},
+	{"aCBFCPAUSEFramesReceived_0", 0x68},
+	{"aCBFCPAUSEFramesReceived_1", 0x6C},
+	{"aCBFCPAUSEFramesReceived_2", 0x70},
+	{"aCBFCPAUSEFramesReceived_3", 0x74},
+	{"aCBFCPAUSEFramesReceived_4", 0x78},
+	{"aCBFCPAUSEFramesReceived_5", 0x7C},
+	{"aCBFCPAUSEFramesReceived_6", 0x80},
+	{"aCBFCPAUSEFramesReceived_7", 0x84},
+	{"aMACControlFramesReceived", 0x88}
+};
+
+static struct gaudi_nic_ethtool_stats gaudi_nic_mac_stats_tx[] = {
+	{"etherStatsOctets", 0x0},
+	{"OctetsTransmittedOK", 0x4},
+	{"aPAUSEMACCtrlFramesTransmitted", 0x8},
+	{"aFramesTransmittedOK", 0xC},
+	{"VLANTransmittedOK", 0x10},
+	{"ifOutErrors", 0x14},
+	{"ifOutUcastPkts", 0x18},
+	{"ifOutMulticastPkts", 0x1C},
+	{"ifOutBroadcastPkts", 0x20},
+	{"etherStatsPkts64Octets", 0x24},
+	{"etherStatsPkts65to127Octets", 0x28},
+	{"etherStatsPkts128to255Octets", 0x2C},
+	{"etherStatsPkts256to511Octets", 0x30},
+	{"etherStatsPkts512to1023Octets", 0x34},
+	{"etherStatsPkts1024to1518Octets", 0x38},
+	{"etherStatsPkts1519toMaxOctets", 0x3C},
+	{"aCBFCPAUSEFramesTransmitted_0", 0x40},
+	{"aCBFCPAUSEFramesTransmitted_1", 0x44},
+	{"aCBFCPAUSEFramesTransmitted_2", 0x48},
+	{"aCBFCPAUSEFramesTransmitted_3", 0x4C},
+	{"aCBFCPAUSEFramesTransmitted_4", 0x50},
+	{"aCBFCPAUSEFramesTransmitted_5", 0x54},
+	{"aCBFCPAUSEFramesTransmitted_6", 0x58},
+	{"aCBFCPAUSEFramesTransmitted_7", 0x5C},
+	{"aMACControlFramesTransmitted", 0x60},
+	{"etherStatsPkts", 0x64}
+};
+
+static struct gaudi_nic_spmu_event_type gaudi_nic0_spmu_event_type[] = {
+	{"requester_psn_out_of_range", 18},
+	{"responder_duplicate_psn", 21},
+	{"responder_out_of_sequence_psn", 22}
+};
+
+static struct gaudi_nic_spmu_event_type gaudi_nic1_spmu_event_type[] = {
+	{"requester_psn_out_of_range", 6},
+	{"responder_duplicate_psn", 9},
+	{"responder_out_of_sequence_psn", 10}
+};
+
+static struct gaudi_nic_xpcs91_reg_type gaudi_nic_xpcs91_reg_type[] = {
+	{"correctable_errors", 0x2, 0x3},
+	{"uncorrectable_errors", 0x4, 0x5}
+};
+
+static struct gaudi_nic_sw_cnt_type gaudi_nic_sw_cnt_type[] = {
+	{"pcs_local_faults"},
+	{"pcs_remote_faults"},
+};
+
+static void gaudi_nic_get_drvinfo(struct net_device *netdev,
+					struct ethtool_drvinfo *drvinfo)
+{
+	struct gaudi_nic_device **ptr = netdev_priv(netdev);
+	struct gaudi_nic_device *gaudi_nic = *ptr;
+	struct hl_device *hdev = gaudi_nic->hdev;
+
+	strlcpy(drvinfo->driver, HL_NAME, sizeof(drvinfo->driver));
+	strlcpy(drvinfo->fw_version, hdev->asic_prop.cpucp_info.cpucp_version,
+		sizeof(drvinfo->fw_version));
+	if (hdev->pdev)
+		strlcpy(drvinfo->bus_info, pci_name(hdev->pdev),
+				sizeof(drvinfo->bus_info));
+}
+
+static int gaudi_nic_get_link_ksettings(struct net_device *netdev,
+					struct ethtool_link_ksettings *cmd)
+{
+	struct gaudi_nic_device **ptr = netdev_priv(netdev);
+	struct gaudi_nic_device *gaudi_nic = *ptr;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 port, speed;
+
+	port = gaudi_nic->port;
+	speed = gaudi_nic->speed;
+
+	cmd->base.speed = speed;
+	cmd->base.duplex = DUPLEX_FULL;
+
+	ethtool_link_ksettings_zero_link_mode(cmd, supported);
+	ethtool_link_ksettings_zero_link_mode(cmd, advertising);
+
+	ethtool_add_mode(cmd, supported, 100000baseCR4_Full);
+	ethtool_add_mode(cmd, supported, 100000baseSR4_Full);
+	ethtool_add_mode(cmd, supported, 100000baseKR4_Full);
+	ethtool_add_mode(cmd, supported, 100000baseLR4_ER4_Full);
+
+	ethtool_add_mode(cmd, supported, 50000baseSR2_Full);
+	ethtool_add_mode(cmd, supported, 50000baseCR2_Full);
+	ethtool_add_mode(cmd, supported, 50000baseKR2_Full);
+
+	if (speed == SPEED_100000) {
+		ethtool_add_mode(cmd, advertising, 100000baseCR4_Full);
+		ethtool_add_mode(cmd, advertising, 100000baseSR4_Full);
+		ethtool_add_mode(cmd, advertising, 100000baseKR4_Full);
+		ethtool_add_mode(cmd, advertising, 100000baseLR4_ER4_Full);
+
+		cmd->base.port = PORT_FIBRE;
+
+		ethtool_add_mode(cmd, supported, FIBRE);
+		ethtool_add_mode(cmd, advertising, FIBRE);
+
+		ethtool_add_mode(cmd, supported, Backplane);
+		ethtool_add_mode(cmd, advertising, Backplane);
+	} else if (speed == SPEED_50000) {
+		ethtool_add_mode(cmd, advertising, 50000baseSR2_Full);
+		ethtool_add_mode(cmd, advertising, 50000baseCR2_Full);
+		ethtool_add_mode(cmd, advertising, 50000baseKR2_Full);
+	} else {
+		dev_err(hdev->dev, "unknown speed %d, port %d\n", speed, port);
+		return -EFAULT;
+	}
+
+	ethtool_add_mode(cmd, supported, Autoneg);
+
+	if (gaudi_nic->auto_neg_enable) {
+		ethtool_add_mode(cmd, advertising, Autoneg);
+		cmd->base.autoneg = AUTONEG_ENABLE;
+		if (gaudi_nic->auto_neg_resolved)
+			ethtool_add_mode(cmd, lp_advertising, Autoneg);
+	} else {
+		cmd->base.autoneg = AUTONEG_DISABLE;
+	}
+
+	ethtool_add_mode(cmd, supported, Pause);
+
+	if (gaudi_nic->pfc_enable)
+		ethtool_add_mode(cmd, advertising, Pause);
+
+	return 0;
+}
+
+static bool check_ksettings(const struct ethtool_link_ksettings *old_cmd,
+				const struct ethtool_link_ksettings *new_cmd)
+{
+	/* only autoneg and speed are mutable */
+	return (old_cmd->base.duplex == new_cmd->base.duplex) &&
+		(old_cmd->base.port == new_cmd->base.port) &&
+		(old_cmd->base.phy_address == new_cmd->base.phy_address) &&
+		(old_cmd->base.eth_tp_mdix_ctrl ==
+				new_cmd->base.eth_tp_mdix_ctrl) &&
+		bitmap_empty(new_cmd->link_modes.advertising,
+				__ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static int gaudi_nic_set_link_ksettings(struct net_device *netdev,
+				const struct ethtool_link_ksettings *cmd)
+{
+	struct gaudi_nic_device **ptr = netdev_priv(netdev);
+	struct ethtool_link_ksettings curr_cmd = {0};
+	struct gaudi_nic_device *gaudi_nic = *ptr;
+	u32 port = gaudi_nic->port;
+	struct hl_device *hdev;
+	bool auto_neg;
+	int rc, speed;
+
+	hdev = gaudi_nic->hdev;
+
+	rc = gaudi_nic_get_link_ksettings(netdev, &curr_cmd);
+	if (rc)
+		return rc;
+
+	if (!check_ksettings(&curr_cmd, cmd))
+		return -EOPNOTSUPP;
+
+	speed = cmd->base.speed;
+	auto_neg = cmd->base.autoneg == AUTONEG_ENABLE;
+
+	switch (speed) {
+	case SPEED_10000:
+	case SPEED_25000:
+	case SPEED_50000:
+		if (gaudi_nic->nic_macro->num_of_lanes == NIC_LANES_4) {
+			dev_err(hdev->dev,
+				"NIC %d with 4 lanes should be used only with speed of 100000Mb/s\n",
+				port);
+			return -EFAULT;
+		}
+		break;
+	case SPEED_100000:
+		break;
+	default:
+		dev_err(hdev->dev, "got invalid speed %dMb/s for NIC %d",
+			speed, port);
+		return -EINVAL;
+	}
+
+	if ((gaudi_nic->speed == speed) &&
+			(gaudi_nic->auto_neg_enable == auto_neg))
+		return 0;
+
+	if (atomic_cmpxchg(&gaudi_nic->in_reset, 0, 1)) {
+		dev_err(hdev->dev, "port %d is in reset, can't change speed",
+			port);
+		return -EBUSY;
+	}
+
+	gaudi_nic->speed = speed;
+	if (auto_neg)
+		hdev->nic_auto_neg_mask |= BIT(port);
+	else
+		hdev->nic_auto_neg_mask &= ~BIT(port);
+
+	if (gaudi_nic->enabled) {
+		rc = gaudi_nic_port_reset(gaudi_nic);
+		if (rc)
+			dev_err(hdev->dev,
+				"Failed to reset NIC %d for speed change, rc %d",
+				port, rc);
+	}
+
+	atomic_set(&gaudi_nic->in_reset, 0);
+
+	return rc;
+}
+
+static u32 gaudi_nic_get_link(struct net_device *netdev)
+{
+	return netif_carrier_ok(netdev);
+}
+
+static void gaudi_nic_get_internal_strings(struct net_device *netdev,
+					u8 *data)
+{
+	struct gaudi_nic_device **ptr = netdev_priv(netdev);
+	struct gaudi_nic_spmu_event_type *spmu_stats;
+	struct gaudi_nic_device *gaudi_nic = *ptr;
+	u32 port = gaudi_nic->port;
+	u32 num_spmus;
+	u32 i;
+
+	if (port & 1) {
+		num_spmus = NIC_SPMU1_STATS_LEN;
+		spmu_stats = gaudi_nic1_spmu_event_type;
+	} else {
+		num_spmus = NIC_SPMU0_STATS_LEN;
+		spmu_stats = gaudi_nic0_spmu_event_type;
+	}
+
+	for (i = 0 ; i < num_spmus ; i++)
+		memcpy(data + i * ETH_GSTRING_LEN,
+				spmu_stats[i].stat_string,
+				ETH_GSTRING_LEN);
+	data += i * ETH_GSTRING_LEN;
+	for (i = 0 ; i < NIC_MAC_STATS_RX_LEN ; i++)
+		memcpy(data + i * ETH_GSTRING_LEN,
+				gaudi_nic_mac_stats_rx[i].stat_string,
+				ETH_GSTRING_LEN);
+	data += i * ETH_GSTRING_LEN;
+	for (i = 0 ; i < NIC_XPCS91_REGS_CNT_LEN ; i++)
+		memcpy(data + i * ETH_GSTRING_LEN,
+				gaudi_nic_xpcs91_reg_type[i].stat_string,
+				ETH_GSTRING_LEN);
+	data += i * ETH_GSTRING_LEN;
+	for (i = 0 ; i < NIC_SW_CNT_LEN ; i++)
+		memcpy(data + i * ETH_GSTRING_LEN,
+				gaudi_nic_sw_cnt_type[i].stat_string,
+				ETH_GSTRING_LEN);
+	data += i * ETH_GSTRING_LEN;
+	for (i = 0 ; i < NIC_MAC_STATS_TX_LEN ; i++)
+		memcpy(data + i * ETH_GSTRING_LEN,
+				gaudi_nic_mac_stats_tx[i].stat_string,
+				ETH_GSTRING_LEN);
+
+}
+
+static void gaudi_nic_get_strings(struct net_device *netdev, u32 stringset,
+					u8 *data)
+{
+	int i;
+
+	if (stringset == ETH_SS_STATS) {
+		for (i = 0; i < NIC_STATS_LEN; i++)
+			memcpy(data + i * ETH_GSTRING_LEN,
+					gaudi_nic_ethtool_stats[i].stat_string,
+					ETH_GSTRING_LEN);
+		gaudi_nic_get_internal_strings(netdev,
+					data + i * ETH_GSTRING_LEN);
+	}
+}
+
+static int gaudi_nic_get_sset_count(struct net_device *netdev, int sset)
+{
+	int num_spmus, mac_counters, xpcs91_counters, sw_counetrs;
+	struct gaudi_nic_device **ptr = netdev_priv(netdev);
+	struct gaudi_nic_device *gaudi_nic = *ptr;
+	u32 port = gaudi_nic->port;
+
+	num_spmus = (port & 1) ? NIC_SPMU1_STATS_LEN : NIC_SPMU0_STATS_LEN;
+	mac_counters = NIC_MAC_STATS_RX_LEN + NIC_MAC_STATS_TX_LEN;
+	xpcs91_counters = NIC_XPCS91_REGS_CNT_LEN;
+	sw_counetrs = NIC_SW_CNT_LEN;
+
+	switch (sset) {
+	case ETH_SS_STATS:
+		return NIC_STATS_LEN + num_spmus + mac_counters +
+			xpcs91_counters + sw_counetrs;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+static u64 gaudi_nic_read_mac_counter(struct hl_device *hdev, u32 port,
+						int offset, bool is_rx)
+{
+	u64 lo_part, hi_part;
+	u64 start_reg;
+
+	if (!hdev->supports_coresight)
+		return 0;
+
+	if (is_rx)
+		if (port & 1)
+			start_reg = NIC_MAC_RX_PORT1_OFFSET;
+		else
+			start_reg = NIC_MAC_RX_PORT0_OFFSET;
+	else
+		if (port & 1)
+			start_reg = NIC_MAC_TX_PORT1_OFFSET;
+		else
+			start_reg = NIC_MAC_TX_PORT0_OFFSET;
+
+	lo_part = NIC_MAC_STAT_RREG32(port, start_reg + offset);
+	/* Volatile read: MUST read high part after low */
+	hi_part = NIC_MAC_STAT_RREG32(port, NIC_MAC_STAT_HI_PART);
+
+	return lo_part | (hi_part << 32);
+}
+
+static void gaudi_nic_read_xpcs91_regs(struct gaudi_nic_device *gaudi_nic,
+					u64 *out_data)
+{
+	u32 lo_part, hi_part, start_lane = __ffs(gaudi_nic->fw_tuning_mask);
+
+	lo_part = gaudi_nic_mac_read(gaudi_nic, start_lane, "xpcs91",
+			gaudi_nic_xpcs91_reg_type[0].lo_offset);
+	hi_part = gaudi_nic_mac_read(gaudi_nic, start_lane, "xpcs91",
+			gaudi_nic_xpcs91_reg_type[0].hi_offset);
+	gaudi_nic->correctable_errors_cnt +=
+					(hi_part << 16) | lo_part;
+	out_data[0] = gaudi_nic->correctable_errors_cnt;
+
+	lo_part = gaudi_nic_mac_read(gaudi_nic, start_lane, "xpcs91",
+			gaudi_nic_xpcs91_reg_type[1].lo_offset);
+	hi_part = gaudi_nic_mac_read(gaudi_nic, start_lane, "xpcs91",
+			gaudi_nic_xpcs91_reg_type[1].hi_offset);
+	gaudi_nic->uncorrectable_errors_cnt +=
+					(hi_part << 16) | lo_part;
+	out_data[1] = gaudi_nic->uncorrectable_errors_cnt;
+}
+
+static void gaudi_nic_read_sw_counters(struct gaudi_nic_device *gaudi_nic,
+					u64 *out_data)
+{
+	out_data[0] = gaudi_nic->pcs_local_fault_cnt;
+	out_data[1] = gaudi_nic->pcs_remote_fault_cnt;
+}
+
+static void gaudi_nic_get_internal_stats(struct net_device *netdev, u64 *data)
+{
+	struct gaudi_nic_device **ptr = netdev_priv(netdev);
+	struct gaudi_nic_device *gaudi_nic = *ptr;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 port = gaudi_nic->port;
+	u32 num_spmus;
+	int i;
+
+	num_spmus = (port & 1) ? NIC_SPMU1_STATS_LEN : NIC_SPMU0_STATS_LEN;
+
+	gaudi_sample_spmu_nic(hdev, port, num_spmus, data);
+	data += num_spmus;
+
+	for (i = 1 ; i < NIC_MAC_STATS_RX_LEN ; i++)
+		data[i] = gaudi_nic_read_mac_counter(hdev, port,
+				gaudi_nic_mac_stats_rx[i].stat_offset, true);
+	data += i;
+
+	gaudi_nic_read_xpcs91_regs(gaudi_nic, data);
+	data += NIC_XPCS91_REGS_CNT_LEN;
+
+	gaudi_nic_read_sw_counters(gaudi_nic, data);
+	data += NIC_SW_CNT_LEN;
+
+	for (i = 1 ; i < NIC_MAC_STATS_TX_LEN ; i++)
+		data[i] = gaudi_nic_read_mac_counter(hdev, port,
+				gaudi_nic_mac_stats_tx[i].stat_offset, false);
+}
+
+static void gaudi_nic_get_ethtool_stats(struct net_device *netdev,
+					struct ethtool_stats *stats, u64 *data)
+{
+	struct gaudi_nic_device **ptr = netdev_priv(netdev);
+	struct gaudi_nic_device *gaudi_nic = *ptr;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 port = gaudi_nic->port;
+	char *p;
+	int i;
+
+	if (disabled_or_in_reset(gaudi_nic)) {
+		dev_info_ratelimited(hdev->dev,
+			"port %d is in reset, can't get ethtool stats", port);
+		return;
+	}
+
+	for (i = 0; i < NIC_STATS_LEN ; i++) {
+		p = (char *) netdev + gaudi_nic_ethtool_stats[i].stat_offset;
+		data[i] = *(u32 *) p;
+	}
+
+	gaudi_nic_get_internal_stats(netdev, data + i);
+}
+
+static int gaudi_nic_get_module_info(struct net_device *netdev,
+					struct ethtool_modinfo *modinfo)
+{
+	modinfo->type = ETH_MODULE_SFF_8636;
+	modinfo->eeprom_len = ETH_MODULE_SFF_8636_LEN;
+
+	return 0;
+}
+
+static int gaudi_nic_get_module_eeprom(struct net_device *netdev,
+					struct ethtool_eeprom *ee, u8 *data)
+{
+	struct gaudi_nic_device **ptr = netdev_priv(netdev);
+	struct gaudi_nic_device *gaudi_nic = *ptr;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 first, last, len;
+
+	if (ee->len == 0)
+		return -EINVAL;
+
+	first = ee->offset;
+	last = ee->offset + ee->len;
+
+	if (first < ETH_MODULE_SFF_8636_LEN) {
+		len = min_t(unsigned int, last, ETH_MODULE_SFF_8079_LEN);
+		len -= first;
+
+		memcpy(data, hdev->asic_prop.cpucp_nic_info.qsfp_eeprom + first,
+			len);
+	}
+
+	return 0;
+}
+
+/* enable spmus for ethtool monitoring */
+void gaudi_nic_spmu_init(struct hl_device *hdev, int port)
+{
+	u32 spmu_events[NIC_SPMU_STATS_LEN_MAX], num_event_types;
+	struct gaudi_nic_spmu_event_type *event_types;
+	int rc, i;
+
+	if (port & 1) {
+		num_event_types = NIC_SPMU1_STATS_LEN;
+		event_types = gaudi_nic1_spmu_event_type;
+	} else {
+		num_event_types = NIC_SPMU0_STATS_LEN;
+		event_types = gaudi_nic0_spmu_event_type;
+	}
+
+	if (num_event_types > NIC_SPMU_STATS_LEN_MAX)
+		num_event_types = NIC_SPMU_STATS_LEN_MAX;
+
+	for (i = 0 ; i < num_event_types ; i++)
+		spmu_events[i] = event_types[i].index;
+
+	rc = gaudi_config_spmu_nic(hdev, port, num_event_types,
+			spmu_events);
+	if (rc)
+		dev_err(hdev->dev,
+			"Failed to configure spmu for NIC port %d\n",
+			port);
+}
+
+u64 gaudi_nic_read_mac_stat_counter(struct hl_device *hdev, u32 port, int idx,
+					bool is_rx)
+{
+	struct gaudi_nic_ethtool_stats *stat = is_rx ?
+						&gaudi_nic_mac_stats_rx[idx] :
+						&gaudi_nic_mac_stats_tx[idx];
+
+	return gaudi_nic_read_mac_counter(hdev, port, stat->stat_offset, is_rx);
+}
+
+const struct ethtool_ops gaudi_nic_ethtool_ops = {
+	.get_drvinfo = gaudi_nic_get_drvinfo,
+	.get_link_ksettings = gaudi_nic_get_link_ksettings,
+	.set_link_ksettings = gaudi_nic_set_link_ksettings,
+	.get_link = gaudi_nic_get_link,
+	.get_strings = gaudi_nic_get_strings,
+	.get_sset_count = gaudi_nic_get_sset_count,
+	.get_ethtool_stats = gaudi_nic_get_ethtool_stats,
+	.get_module_info   = gaudi_nic_get_module_info,
+	.get_module_eeprom = gaudi_nic_get_module_eeprom,
+};
+
-- 
2.17.1

