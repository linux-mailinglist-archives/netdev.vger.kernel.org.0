Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194C626ACE8
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 21:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgIOTC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 15:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgIORLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 13:11:42 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09587C061226;
        Tue, 15 Sep 2020 10:10:45 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id q9so240355wmj.2;
        Tue, 15 Sep 2020 10:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uNU+JJ7ORloc2Y4HzW84r/JvcvbBK2tdVUIS7PXbqTQ=;
        b=EgQv95KmrjM9swwjij06pWXoL16wxZQE8MjRUw9wCHIYDqYxlINElv4kJDWPkLf6ha
         EgXOLg6mbPfDp6ng/WEbeZo/eMhCeZsiz+Q7VEsIvA8nYzwd9VHYt/CCfdr/20Zqi4J5
         O6HNHCTfKqZliaoJXPA19I3yCG2OoetpD8pb8S7YTEyQYziOZoMJ3ob4Wl5bVygiiZMz
         LfflYWebMjfU9XMfKqHCMDqdXtNYw1JccUV3cxjUFnZrz6+Z6y2IGk9UmeSq2wihjKtH
         dqWsRIBDe0SYzZwP24D9WFpMViQYSaqF+n9DbwoayhV9jbdo0hVAQOYX/cbL7e5GCyyK
         LcVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uNU+JJ7ORloc2Y4HzW84r/JvcvbBK2tdVUIS7PXbqTQ=;
        b=GDK+JYuQmes0QVp9EaDTIe1k26J7C7qmnjIcFx2AUviTKT6ADiJIyl80L8hGs3lulY
         W2M9+Q+aWLhg/0Vxqex/svtiQqnlr+OZEC72h/H15G0RG1C52JpApj1Cb6A/Ab6PaUUe
         rwpI1JeX0DAYODSgHZl/kC1u4ozIC6SzCVS0H4Qby9dwQjP5wQmdxbXN2qhYTqLrrRoS
         6AjXYTQegIj8Sfv/BsKEitP3hRUVTZF0GaxP9eExrzDlqr1uzOUY81bo9WaEZ/CefBq2
         f80K5Dbf5zwp07wEQjuyYAIrZACKPJBEoxWTp9tKE6s2ZhaycrNA1Om+SPfyoPeVEeLR
         4V9Q==
X-Gm-Message-State: AOAM531DEaIGVAtPXL1EJp7YVABuABuVEwTJ9CpiYXzzheUhQoc1a9ET
        ZCxcQZkVd+So8OPpXYxkmU2b8k15rdYOOQ==
X-Google-Smtp-Source: ABdhPJx8B4r3hWG6ueftFusckZf7lpk0qDkD4AGuOZMq/B9Vx78s8Jr+Z2f8igL9pQlqYX7nRD/Yfg==
X-Received: by 2002:a1c:c906:: with SMTP id f6mr381796wmb.9.1600189840962;
        Tue, 15 Sep 2020 10:10:40 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id b194sm356558wmd.42.2020.09.15.10.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 10:10:39 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH v3 05/14] habanalabs/gaudi: add NIC Ethernet support
Date:   Tue, 15 Sep 2020 20:10:13 +0300
Message-Id: <20200915171022.10561-6-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200915171022.10561-1-oded.gabbay@gmail.com>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

Basic NIC driver which handles Ethernet packet of several types like IPv4,
IPv6, LLDP, VLAN and ARP.

The NIC HW is composed of 5 NIC macros, in each macro 2 NIC engines of
100GbE each. Each engine exposes a single port of 100GbE, so in total we
have 10 ports per GAUDI device.

The driver gets the needed information for initialization from the firmware
such as card type, available ports, Auto-negotiation support, polarity and
Tx taps configuration.

Two card types are supported: standalone PCI and PCI Mezzanine Card (PMC)
which is part of a server called HLS-1. Each type has its own unique
configurations.

We define two types of port connectivity - internal and external. Internal
port is connected to a port on another Gaudi card and external port is
connected to a switch.

The Ethernet support is needed only for control flows e.g. get IP. Hence it
is implemented in a very simple way - the packets are copied rather than
using descriptors.

The Rx flow uses NAPI by default and polling mode is supported by a
kernel module parameter.

Because we must not access the HW while doing hard reset to the device, a
new stage of stopping all NIC activity is added at the beginning of the
reset flow.

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
---
 drivers/misc/habanalabs/common/context.c      |    1 +
 drivers/misc/habanalabs/common/firmware_if.c  |   44 +
 drivers/misc/habanalabs/common/habanalabs.h   |   13 +-
 .../misc/habanalabs/common/habanalabs_drv.c   |    4 +
 drivers/misc/habanalabs/gaudi/Makefile        |    2 +
 drivers/misc/habanalabs/gaudi/gaudi.c         |  176 +-
 drivers/misc/habanalabs/gaudi/gaudiP.h        |  286 +-
 drivers/misc/habanalabs/gaudi/gaudi_nic.c     | 2327 +++++++++++++++++
 drivers/misc/habanalabs/gaudi/gaudi_nic.h     |  336 +++
 drivers/misc/habanalabs/goya/goya.c           |    6 +
 include/uapi/misc/habanalabs.h                |    3 +
 11 files changed, 3190 insertions(+), 8 deletions(-)
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic.c
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic.h

diff --git a/drivers/misc/habanalabs/common/context.c b/drivers/misc/habanalabs/common/context.c
index df8171a2226c..39b12d00e287 100644
--- a/drivers/misc/habanalabs/common/context.c
+++ b/drivers/misc/habanalabs/common/context.c
@@ -37,6 +37,7 @@ static void hl_ctx_fini(struct hl_ctx *ctx)
 		if ((hdev->in_debug) && (hdev->compute_ctx == ctx))
 			hl_device_set_debug_mode(hdev, false);
 
+		hdev->asic_funcs->ctx_fini(ctx);
 		hl_cb_va_pool_fini(ctx);
 		hl_vm_ctx_fini(ctx);
 		hl_asid_free(hdev, ctx->asid);
diff --git a/drivers/misc/habanalabs/common/firmware_if.c b/drivers/misc/habanalabs/common/firmware_if.c
index 4409962d30ae..95260dc0458b 100644
--- a/drivers/misc/habanalabs/common/firmware_if.c
+++ b/drivers/misc/habanalabs/common/firmware_if.c
@@ -364,6 +364,50 @@ int hl_fw_get_eeprom_data(struct hl_device *hdev, void *data, size_t max_size)
 	return rc;
 }
 
+int hl_fw_cpucp_nic_info_get(struct hl_device *hdev)
+{
+	struct asic_fixed_properties *prop = &hdev->asic_prop;
+	struct cpucp_packet pkt = {};
+	void *cpucp_nic_info_cpu_addr;
+	dma_addr_t cpucp_nic_info_dma_addr;
+	long result;
+	int rc;
+
+	cpucp_nic_info_cpu_addr =
+			hdev->asic_funcs->cpu_accessible_dma_pool_alloc(hdev,
+					sizeof(struct cpucp_nic_info),
+					&cpucp_nic_info_dma_addr);
+	if (!cpucp_nic_info_cpu_addr) {
+		dev_err(hdev->dev,
+			"Failed to allocate DMA memory for CPU-CP NIC info packet\n");
+		return -ENOMEM;
+	}
+
+	memset(cpucp_nic_info_cpu_addr, 0, sizeof(struct cpucp_nic_info));
+
+	pkt.ctl = cpu_to_le32(CPUCP_PACKET_NIC_INFO_GET <<
+				CPUCP_PKT_CTL_OPCODE_SHIFT);
+	pkt.addr = cpu_to_le64(cpucp_nic_info_dma_addr);
+	pkt.data_max_size = cpu_to_le32(sizeof(struct cpucp_nic_info));
+
+	rc = hdev->asic_funcs->send_cpu_message(hdev, (u32 *) &pkt, sizeof(pkt),
+					HL_CPUCP_INFO_TIMEOUT_USEC, &result);
+	if (rc) {
+		dev_err(hdev->dev,
+			"Failed to handle CPU-CP NIC info pkt, error %d\n", rc);
+		goto out;
+	}
+
+	memcpy(&prop->cpucp_nic_info, cpucp_nic_info_cpu_addr,
+			sizeof(prop->cpucp_nic_info));
+
+out:
+	hdev->asic_funcs->cpu_accessible_dma_pool_free(hdev,
+			sizeof(struct cpucp_nic_info), cpucp_nic_info_cpu_addr);
+
+	return rc;
+}
+
 int hl_fw_cpucp_pci_counters_get(struct hl_device *hdev,
 		struct hl_info_pci_counters *counters)
 {
diff --git a/drivers/misc/habanalabs/common/habanalabs.h b/drivers/misc/habanalabs/common/habanalabs.h
index 146cf14d4d81..45feb4884ab3 100644
--- a/drivers/misc/habanalabs/common/habanalabs.h
+++ b/drivers/misc/habanalabs/common/habanalabs.h
@@ -270,6 +270,8 @@ struct hl_mmu_properties {
  * @hw_queues_props: H/W queues properties.
  * @cpucp_info: received various information from CPU-CP regarding the H/W, e.g.
  *		available sensors.
+ * @cpucp_nic_info: received various information from CPU-CP regarding the NIC
+ *                  H/W, e.g. MAC addresses.
  * @uboot_ver: F/W U-boot version.
  * @preboot_ver: F/W Preboot version.
  * @dmmu: DRAM MMU address translation properties.
@@ -284,7 +286,7 @@ struct hl_mmu_properties {
  * @dram_user_base_address: DRAM physical start address for user access.
  * @dram_size: DRAM total size.
  * @dram_pci_bar_size: size of PCI bar towards DRAM.
- * @max_power_default: max power of the device after reset
+ * @max_power_default: max power of the device after reset.
  * @dram_size_for_default_page_mapping: DRAM size needed to map to avoid page
  *                                      fault.
  * @pcie_dbi_base_address: Base address of the PCIE_DBI block.
@@ -324,6 +326,7 @@ struct hl_mmu_properties {
 struct asic_fixed_properties {
 	struct hw_queue_properties	*hw_queues_props;
 	struct cpucp_info		cpucp_info;
+	struct cpucp_nic_info		cpucp_nic_info;
 	char				uboot_ver[VERSION_MAX_LEN];
 	char				preboot_ver[VERSION_MAX_LEN];
 	struct hl_mmu_properties	dmmu;
@@ -697,6 +700,7 @@ enum div_select_defs {
  * @wreg: Write a register. Needed for simulator support.
  * @halt_coresight: stop the ETF and ETR traces.
  * @ctx_init: context dependent initialization.
+ * @ctx_fini: context dependent cleanup.
  * @get_clk_rate: Retrieve the ASIC current and maximum clock rate in MHz
  * @get_queue_id_for_cq: Get the H/W queue id related to the given CQ index.
  * @read_device_fw_version: read the device's firmware versions that are
@@ -799,6 +803,7 @@ struct hl_asic_funcs {
 	void (*wreg)(struct hl_device *hdev, u32 reg, u32 val);
 	void (*halt_coresight)(struct hl_device *hdev);
 	int (*ctx_init)(struct hl_ctx *ctx);
+	void (*ctx_fini)(struct hl_ctx *ctx);
 	int (*get_clk_rate)(struct hl_device *hdev, u32 *cur_clk, u32 *max_clk);
 	u32 (*get_queue_id_for_cq)(struct hl_device *hdev, u32 cq_idx);
 	void (*read_device_fw_version)(struct hl_device *hdev,
@@ -1586,6 +1591,7 @@ struct hl_mmu_funcs {
  * @sync_stream_queue_idx: helper index for sync stream queues initialization.
  * @supports_coresight: is CoreSight supported.
  * @supports_soft_reset: is soft reset supported.
+ * @nic_rx_poll: enable NIC Rx in polling mode rather than IRQ.
  * @supports_cb_mapping: is mapping a CB to the device's MMU supported.
  */
 struct hl_device {
@@ -1686,10 +1692,13 @@ struct hl_device {
 	u8				sync_stream_queue_idx;
 	u8				supports_coresight;
 	u8				supports_soft_reset;
+	u8				nic_rx_poll;
 	u8				supports_cb_mapping;
 
 	/* Parameters for bring-up */
 	u64				nic_ports_mask;
+	u64				nic_ports_ext_mask;
+	u64				nic_auto_neg_mask;
 	u8				mmu_enable;
 	u8				mmu_huge_page_opt;
 	u8				cpu_enable;
@@ -1702,6 +1711,7 @@ struct hl_device {
 	u8				dram_scrambler_enable;
 	u8				hard_reset_on_fw_events;
 	u8				bmc_enable;
+	u8				nic_load_fw;
 	u8				rl_enable;
 };
 
@@ -1924,6 +1934,7 @@ void hl_fw_cpu_accessible_dma_pool_free(struct hl_device *hdev, size_t size,
 int hl_fw_send_heartbeat(struct hl_device *hdev);
 int hl_fw_cpucp_info_get(struct hl_device *hdev);
 int hl_fw_get_eeprom_data(struct hl_device *hdev, void *data, size_t max_size);
+int hl_fw_cpucp_nic_info_get(struct hl_device *hdev);
 int hl_fw_cpucp_pci_counters_get(struct hl_device *hdev,
 		struct hl_info_pci_counters *counters);
 int hl_fw_cpucp_total_energy_get(struct hl_device *hdev,
diff --git a/drivers/misc/habanalabs/common/habanalabs_drv.c b/drivers/misc/habanalabs/common/habanalabs_drv.c
index f9067d3ef437..b7fbbe8f2577 100644
--- a/drivers/misc/habanalabs/common/habanalabs_drv.c
+++ b/drivers/misc/habanalabs/common/habanalabs_drv.c
@@ -241,6 +241,10 @@ static void set_driver_behavior_per_device(struct hl_device *hdev)
 	hdev->dram_scrambler_enable = 1;
 	hdev->bmc_enable = 1;
 	hdev->hard_reset_on_fw_events = 1;
+	hdev->card_type = cpucp_card_type_pci;
+	hdev->nic_ports_ext_mask = 0x3FF;
+	hdev->nic_auto_neg_mask = 0x3FF;
+	hdev->nic_load_fw = 0;
 }
 
 /*
diff --git a/drivers/misc/habanalabs/gaudi/Makefile b/drivers/misc/habanalabs/gaudi/Makefile
index c9f4703cff24..24e14cff563d 100644
--- a/drivers/misc/habanalabs/gaudi/Makefile
+++ b/drivers/misc/habanalabs/gaudi/Makefile
@@ -1,3 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 HL_GAUDI_FILES := gaudi/gaudi.o gaudi/gaudi_hwmgr.o gaudi/gaudi_security.o \
 	gaudi/gaudi_coresight.o
+
+HL_GAUDI_FILES += gaudi/gaudi_nic.o
diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index ecf89d1e37c8..eee83e0a8c6d 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -78,6 +78,7 @@
 #define GAUDI_PLDM_MMU_TIMEOUT_USEC	(MMU_CONFIG_TIMEOUT_USEC * 100)
 #define GAUDI_PLDM_QMAN0_TIMEOUT_USEC	(HL_DEVICE_TIMEOUT_USEC * 30)
 #define GAUDI_PLDM_TPC_KERNEL_WAIT_USEC	(HL_DEVICE_TIMEOUT_USEC * 30)
+#define GAUDI_PLDM_NIC_QPC_INV_USEC	(NIC_QPC_INV_USEC * 10)
 #define GAUDI_BOOT_FIT_REQ_TIMEOUT_USEC	1000000		/* 1s */
 #define GAUDI_MSG_TO_CPU_TIMEOUT_USEC	4000000		/* 4s */
 
@@ -458,7 +459,10 @@ static int gaudi_get_fixed_properties(struct hl_device *hdev)
 	prop->num_of_events = GAUDI_EVENT_SIZE;
 	prop->tpc_enabled_mask = TPC_ENABLED_MASK;
 
-	prop->max_power_default = MAX_POWER_DEFAULT_PCI;
+	if (hdev->card_type == cpucp_card_type_pmc)
+		prop->max_power_default = MAX_POWER_DEFAULT_PMC;
+	else
+		prop->max_power_default = MAX_POWER_DEFAULT_PCI;
 
 	prop->cb_pool_cb_cnt = GAUDI_CB_POOL_CB_CNT;
 	prop->cb_pool_cb_size = GAUDI_CB_POOL_CB_SIZE;
@@ -782,6 +786,14 @@ static int gaudi_init_tpc_mem(struct hl_device *hdev)
 	return rc;
 }
 
+static int gaudi_nic_clear_mem(struct hl_device *hdev)
+{
+	if (!hdev->nic_ports_mask)
+		return 0;
+
+	return gaudi_memset_device_memory(hdev, NIC_DRV_ADDR, NIC_DRV_SIZE, 0);
+}
+
 static int gaudi_late_init(struct hl_device *hdev)
 {
 	struct gaudi_device *gaudi = hdev->asic_specific;
@@ -836,6 +848,12 @@ static int gaudi_late_init(struct hl_device *hdev)
 		goto disable_pci_access;
 	}
 
+	rc = gaudi_nic_clear_mem(hdev);
+	if (rc) {
+		dev_err(hdev->dev, "Failed to clear NIC memory\n");
+		goto disable_pci_access;
+	}
+
 	return 0;
 
 disable_pci_access:
@@ -865,6 +883,17 @@ static void gaudi_late_fini(struct hl_device *hdev)
 	hdev->hl_chip_info->info = NULL;
 }
 
+static void gaudi_nic_handle_rx(struct gaudi_nic_device *gaudi_nic)
+{
+	/* at this point, interrupts were disabled by the H/W */
+	napi_schedule(&gaudi_nic->napi);
+}
+
+static int gaudi_nic_handle_tx(struct gaudi_nic_device *gaudi_nic, void *data)
+{
+	return gaudi_nic_handle_tx_pkt(gaudi_nic, data);
+}
+
 static int gaudi_alloc_cpu_accessible_dma_mem(struct hl_device *hdev)
 {
 	dma_addr_t dma_addr_arr[GAUDI_ALLOC_CPU_MEM_RETRY_CNT] = {}, end_addr;
@@ -1013,6 +1042,8 @@ static int gaudi_sw_init(struct hl_device *hdev)
 	}
 
 	gaudi->cpucp_info_get = gaudi_cpucp_info_get;
+	gaudi->nic_handle_rx = gaudi_nic_handle_rx;
+	gaudi->nic_handle_tx = gaudi_nic_handle_tx;
 
 	gaudi->max_freq_value = GAUDI_MAX_CLK_FREQ;
 
@@ -1053,14 +1084,29 @@ static int gaudi_sw_init(struct hl_device *hdev)
 	if (rc)
 		goto free_cpu_accessible_dma_pool;
 
+	rc = gaudi_nic_sw_init(hdev);
+	if (rc) {
+		dev_err(hdev->dev, "Failed to init NIC S/W\n");
+		rc = -ENOMEM;
+		goto free_internal_qmans_pq_mem;
+	}
+
 	spin_lock_init(&gaudi->hw_queues_lock);
 	mutex_init(&gaudi->clk_gate_mutex);
 
+	/* Device CPU loads the PHY F/W at boot */
+	gaudi->nic_phy_load_fw = (!hdev->cpu_enable && !hdev->pldm) ||
+					(hdev->nic_load_fw);
+	gaudi->nic_phy_config_fw = !hdev->pldm;
+	gaudi->nic_qpc_cache_inv_timeout = hdev->pldm ?
+			GAUDI_PLDM_NIC_QPC_INV_USEC : NIC_QPC_INV_USEC;
 	hdev->supports_sync_stream = true;
 	hdev->supports_coresight = true;
 
 	return 0;
 
+free_internal_qmans_pq_mem:
+	gaudi_free_internal_qmans_pq_mem(hdev);
 free_cpu_accessible_dma_pool:
 	gen_pool_destroy(hdev->cpu_accessible_dma_pool);
 free_cpu_dma_mem:
@@ -1081,6 +1127,8 @@ static int gaudi_sw_fini(struct hl_device *hdev)
 {
 	struct gaudi_device *gaudi = hdev->asic_specific;
 
+	gaudi_nic_sw_fini(hdev);
+
 	gaudi_free_internal_qmans_pq_mem(hdev);
 
 	gen_pool_destroy(hdev->cpu_accessible_dma_pool);
@@ -1104,6 +1152,8 @@ static int gaudi_sw_fini(struct hl_device *hdev)
 static irqreturn_t gaudi_irq_handler_single(int irq, void *arg)
 {
 	struct hl_device *hdev = arg;
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct gaudi_nic_device *gaudi_nic;
 	int i;
 
 	if (hdev->disabled)
@@ -1112,6 +1162,16 @@ static irqreturn_t gaudi_irq_handler_single(int irq, void *arg)
 	for (i = 0 ; i < hdev->asic_prop.completion_queues_count ; i++)
 		hl_irq_handler_cq(irq, &hdev->completion_queue[i]);
 
+	for (i = 0 ; i < NIC_NUMBER_OF_PORTS ; i++) {
+		gaudi_nic = &gaudi->nic_devices[i];
+
+		if (!(hdev->nic_ports_mask & BIT(i)) || (!gaudi_nic->port_open))
+			continue;
+
+		gaudi_nic_rx_irq_handler(irq, gaudi_nic);
+	}
+
+	gaudi_nic_cq_irq_handler(irq, hdev);
 	hl_irq_handler_eq(irq, &hdev->event_queue);
 
 	return IRQ_HANDLED;
@@ -1271,6 +1331,8 @@ static void gaudi_disable_msi(struct hl_device *hdev)
 static void gaudi_init_scrambler_sram(struct hl_device *hdev)
 {
 	struct gaudi_device *gaudi = hdev->asic_specific;
+	u32 status;
+	int rc;
 
 	if (gaudi->hw_cap_initialized & HW_CAP_SRAM_SCRAMBLER)
 		return;
@@ -1278,6 +1340,36 @@ static void gaudi_init_scrambler_sram(struct hl_device *hdev)
 	if (!hdev->sram_scrambler_enable)
 		return;
 
+	/* In case we don't load F/W, we must wait for uboot to finish before
+	 * we enable scrambling. Otherwise, we risk interrupting it in the
+	 * middle of initialization, which can cause the device to get stuck
+	 */
+	if ((!hdev->pldm) && (hdev->cpu_enable) && (!hdev->fw_loading)) {
+		dev_info(hdev->dev,
+			"Waiting for u-boot to finish before enabling SRAM scrambler\n");
+
+		rc = hl_poll_timeout(
+			hdev,
+			mmPSOC_GLOBAL_CONF_CPU_BOOT_STATUS,
+			status,
+			(status == CPU_BOOT_STATUS_NIC_FW_RDY) ||
+			(status == CPU_BOOT_STATUS_READY_TO_BOOT) ||
+			(status == CPU_BOOT_STATUS_SRAM_AVAIL),
+			10000,
+			GAUDI_NIC_FW_TIMEOUT_USEC);
+
+		if (rc)
+			dev_warn(hdev->dev,
+				"Failed to detect u-boot has finished loading NIC F/W. Maybe running old F/W?\n");
+
+		if (status != CPU_BOOT_STATUS_SRAM_AVAIL)
+			ssleep(1);
+
+		/* Stop the device CPU to make sure nothing bad happens */
+		WREG32(mmPSOC_GLOBAL_CONF_KMD_MSG_TO_CPU, KMD_MSG_GOTO_WFE);
+		msleep(GAUDI_CPU_RESET_WAIT_MSEC);
+	}
+
 	WREG32(mmNIF_RTR_CTRL_0_SCRAM_SRAM_EN,
 			1 << IF_RTR_CTRL_SCRAM_SRAM_EN_VAL_SHIFT);
 	WREG32(mmNIF_RTR_CTRL_1_SCRAM_SRAM_EN,
@@ -2874,6 +2966,13 @@ static void gaudi_halt_engines(struct hl_device *hdev, bool hard_reset)
 	else
 		wait_timeout_ms = GAUDI_RESET_WAIT_MSEC;
 
+	/*
+	 * Mark the NIC as in reset to avoid any new NIC accesses to the
+	 * H/W. This must be done before we stop the CPU as the NIC
+	 * might use it e.g. get/set EEPROM data.
+	 */
+	gaudi_nic_hard_reset_prepare(hdev);
+
 	gaudi_stop_nic_qmans(hdev);
 
 	gaudi_stop_mme_qmans(hdev);
@@ -2900,6 +2999,8 @@ static void gaudi_halt_engines(struct hl_device *hdev, bool hard_reset)
 
 	gaudi_disable_timestamp(hdev);
 
+	/* NIC stop must be called before MSI is disabled */
+	gaudi_nic_stop(hdev);
 	gaudi_disable_msi(hdev);
 }
 
@@ -3184,6 +3285,16 @@ static int gaudi_hw_init(struct hl_device *hdev)
 
 	gaudi_init_hbm_dma_qmans(hdev);
 
+	/*
+	 * Before pushing u-boot/linux to device, need to set the hbm bar to
+	 * base address of dram
+	 */
+	if (gaudi_set_hbm_bar_base(hdev, DRAM_PHYS_BASE) == U64_MAX) {
+		dev_err(hdev->dev,
+			"failed to map HBM bar to DRAM base address\n");
+		return -EIO;
+	}
+
 	rc = gaudi_init_cpu(hdev);
 	if (rc) {
 		dev_err(hdev->dev, "failed to initialize CPU\n");
@@ -3315,7 +3426,7 @@ static void gaudi_hw_fini(struct hl_device *hdev, bool hard_reset)
 					HW_CAP_HBM_DMA | HW_CAP_PLL |
 					HW_CAP_NIC_MASK | HW_CAP_MMU |
 					HW_CAP_SRAM_SCRAMBLER |
-					HW_CAP_HBM_SCRAMBLER |
+					HW_CAP_HBM_SCRAMBLER | HW_CAP_NIC_DRV |
 					HW_CAP_CLK_GATE);
 
 	memset(gaudi->events_stat, 0, sizeof(gaudi->events_stat));
@@ -6107,6 +6218,45 @@ static void gaudi_print_irq_info(struct hl_device *hdev, u16 event_type,
 	}
 }
 
+static void gaudi_print_nic_axi_irq_info(struct hl_device *hdev, u16 event_type,
+						void *data)
+{
+	char desc[64] = "", *type;
+	struct eq_nic_sei_event *eq_nic_sei = data;
+	u16 nic_id = event_type - GAUDI_EVENT_NIC_SEI_0;
+
+	switch (eq_nic_sei->axi_error_cause) {
+	case RXB:
+		type = "RXB";
+		break;
+	case RXE:
+		type = "RXE";
+		break;
+	case TXS:
+		type = "TXS";
+		break;
+	case TXE:
+		type = "TXE";
+		break;
+	case QPC_RESP:
+		type = "QPC_RESP";
+		break;
+	case NON_AXI_ERR:
+		type = "NON_AXI_ERR";
+		break;
+	default:
+		dev_err(hdev->dev, "unknown NIC AXI cause %d\n",
+			eq_nic_sei->axi_error_cause);
+		type = "N/A";
+		break;
+	}
+
+	snprintf(desc, sizeof(desc), "NIC%d_%s%d", nic_id, type,
+			eq_nic_sei->id);
+	dev_err_ratelimited(hdev->dev, "Received H/W interrupt %d [\"%s\"]\n",
+		event_type, desc);
+}
+
 static int gaudi_soft_reset_late_init(struct hl_device *hdev)
 {
 	struct gaudi_device *gaudi = hdev->asic_specific;
@@ -6305,6 +6455,7 @@ static void gaudi_handle_eqe(struct hl_device *hdev,
 				struct hl_eq_entry *eq_entry)
 {
 	struct gaudi_device *gaudi = hdev->asic_specific;
+	u64 data = le64_to_cpu(eq_entry->data[0]);
 	u32 ctl = le32_to_cpu(eq_entry->hdr.ctl);
 	u16 event_type = ((ctl & EQ_CTL_EVENT_TYPE_MASK)
 			>> EQ_CTL_EVENT_TYPE_SHIFT);
@@ -6333,6 +6484,7 @@ static void gaudi_handle_eqe(struct hl_device *hdev,
 	case GAUDI_EVENT_PSOC_MEM_DERR:
 	case GAUDI_EVENT_PSOC_CORESIGHT_DERR:
 	case GAUDI_EVENT_SRAM0_DERR ... GAUDI_EVENT_SRAM28_DERR:
+	case GAUDI_EVENT_NIC0_DERR ... GAUDI_EVENT_NIC4_DERR:
 	case GAUDI_EVENT_DMA_IF0_DERR ... GAUDI_EVENT_DMA_IF3_DERR:
 	case GAUDI_EVENT_HBM_0_DERR ... GAUDI_EVENT_HBM_3_DERR:
 	case GAUDI_EVENT_MMU_DERR:
@@ -6434,6 +6586,7 @@ static void gaudi_handle_eqe(struct hl_device *hdev,
 	case GAUDI_EVENT_PSOC_MEM_SERR:
 	case GAUDI_EVENT_PSOC_CORESIGHT_SERR:
 	case GAUDI_EVENT_SRAM0_SERR ... GAUDI_EVENT_SRAM28_SERR:
+	case GAUDI_EVENT_NIC0_SERR ... GAUDI_EVENT_NIC4_SERR:
 	case GAUDI_EVENT_DMA_IF0_SERR ... GAUDI_EVENT_DMA_IF3_SERR:
 	case GAUDI_EVENT_HBM_0_SERR ... GAUDI_EVENT_HBM_3_SERR:
 		fallthrough;
@@ -6497,6 +6650,11 @@ static void gaudi_handle_eqe(struct hl_device *hdev,
 		hl_fw_unmask_irq(hdev, event_type);
 		break;
 
+	case GAUDI_EVENT_NIC_SEI_0 ... GAUDI_EVENT_NIC_SEI_4:
+		gaudi_print_nic_axi_irq_info(hdev, event_type, &data);
+		hl_fw_unmask_irq(hdev, event_type);
+		break;
+
 	case GAUDI_EVENT_FIX_POWER_ENV_S ... GAUDI_EVENT_FIX_THERMAL_ENV_E:
 		gaudi_print_clk_change_info(hdev, event_type);
 		hl_fw_unmask_irq(hdev, event_type);
@@ -7002,6 +7160,19 @@ static int gaudi_ctx_init(struct hl_ctx *ctx)
 	return 0;
 }
 
+static void gaudi_ctx_fini(struct hl_ctx *ctx)
+{
+	struct hl_device *hdev = ctx->hdev;
+
+	/* Gaudi will NEVER support more then a single compute context.
+	 * Therefore, don't clear anything unless it is the compute context
+	 */
+	if (hdev->compute_ctx != ctx)
+		return;
+
+	gaudi_nic_ctx_fini(ctx);
+}
+
 static u32 gaudi_get_queue_id_for_cq(struct hl_device *hdev, u32 cq_idx)
 {
 	return gaudi_cq_assignment[cq_idx];
@@ -7305,6 +7476,7 @@ static const struct hl_asic_funcs gaudi_funcs = {
 	.wreg = hl_wreg,
 	.halt_coresight = gaudi_halt_coresight,
 	.ctx_init = gaudi_ctx_init,
+	.ctx_fini = gaudi_ctx_fini,
 	.get_clk_rate = gaudi_get_clk_rate,
 	.get_queue_id_for_cq = gaudi_get_queue_id_for_cq,
 	.read_device_fw_version = gaudi_read_device_fw_version,
diff --git a/drivers/misc/habanalabs/gaudi/gaudiP.h b/drivers/misc/habanalabs/gaudi/gaudiP.h
index 858434d50b59..6dea73c5682f 100644
--- a/drivers/misc/habanalabs/gaudi/gaudiP.h
+++ b/drivers/misc/habanalabs/gaudi/gaudiP.h
@@ -15,6 +15,9 @@
 #include "../include/gaudi/gaudi.h"
 #include "../include/gaudi/gaudi_async_events.h"
 
+#include <linux/netdevice.h>
+#include <linux/kfifo.h>
+
 #define NUMBER_OF_EXT_HW_QUEUES		12
 #define NUMBER_OF_CMPLT_QUEUES		NUMBER_OF_EXT_HW_QUEUES
 #define NUMBER_OF_CPU_HW_QUEUES		1
@@ -27,9 +30,12 @@
  * Number of MSI interrupts IDS:
  * Each completion queue has 1 ID
  * The event queue has 1 ID
+ * Each NIC engine has 1 ID for Rx
+ * The NIC CQ has 1 ID
  */
 #define NUMBER_OF_INTERRUPTS		(NUMBER_OF_CMPLT_QUEUES + \
-						NUMBER_OF_CPU_HW_QUEUES)
+						NUMBER_OF_CPU_HW_QUEUES + \
+						NIC_NUMBER_OF_ENGINES + 1)
 
 #if (NUMBER_OF_INTERRUPTS > GAUDI_MSI_ENTRIES)
 #error "Number of MSI interrupts must be smaller or equal to GAUDI_MSI_ENTRIES"
@@ -44,6 +50,10 @@
 
 #define GAUDI_CPU_TIMEOUT_USEC		30000000	/* 30s */
 
+#define GAUDI_NIC_FW_TIMEOUT_USEC	12000000	/* 12s */
+
+#define NIC_QPC_INV_USEC		1000000		/* 1s */
+
 #define TPC_ENABLED_MASK		0xFF
 
 #define GAUDI_HBM_SIZE_32GB		0x800000000ull
@@ -100,20 +110,22 @@
 	(((mmSYNC_MNGR_E_N_SYNC_MNGR_OBJS_MON_STATUS_511 - \
 	mmSYNC_MNGR_E_N_SYNC_MNGR_OBJS_MON_STATUS_0) + 4) >> 2)
 
+#define NIC_NUMBER_OF_PORTS	NIC_NUMBER_OF_ENGINES
+#define NIC_MAX_NUM_OF_LANES	(NIC_NUMBER_OF_MACROS * NIC_MAC_NUM_OF_LANES)
 
 /* DRAM Memory Map */
 
 #define CPU_FW_IMAGE_SIZE	0x10000000	/* 256MB */
 #define MMU_PAGE_TABLES_SIZE	0x0BF00000	/* 191MB */
 #define MMU_CACHE_MNG_SIZE	0x00100000	/* 1MB */
-#define RESERVED		0x04000000	/* 64MB */
+#define NIC_DRV_SIZE		0x04000000	/* 64MB */
 
 #define CPU_FW_IMAGE_ADDR	DRAM_PHYS_BASE
 #define MMU_PAGE_TABLES_ADDR	(CPU_FW_IMAGE_ADDR + CPU_FW_IMAGE_SIZE)
 #define MMU_CACHE_MNG_ADDR	(MMU_PAGE_TABLES_ADDR + MMU_PAGE_TABLES_SIZE)
+#define NIC_DRV_ADDR		(MMU_CACHE_MNG_ADDR + MMU_CACHE_MNG_SIZE)
 
-#define DRAM_DRIVER_END_ADDR	(MMU_CACHE_MNG_ADDR + MMU_CACHE_MNG_SIZE +\
-								RESERVED)
+#define DRAM_DRIVER_END_ADDR	(NIC_DRV_ADDR + NIC_DRV_SIZE)
 
 #define DRAM_BASE_ADDR_USER	0x20000000
 
@@ -145,6 +157,8 @@
 #define VA_HOST_SPACE_SIZE	(VA_HOST_SPACE_END - \
 					VA_HOST_SPACE_START) /* 767TB */
 
+#define VA_NIC_MEM_ADDR		0x10000000000ull /* 1TB */
+
 #define HW_CAP_PLL		BIT(0)
 #define HW_CAP_HBM		BIT(1)
 #define HW_CAP_MMU		BIT(2)
@@ -157,6 +171,7 @@
 #define HW_CAP_CLK_GATE		BIT(9)
 #define HW_CAP_SRAM_SCRAMBLER	BIT(10)
 #define HW_CAP_HBM_SCRAMBLER	BIT(11)
+#define HW_CAP_NIC_DRV		BIT(12)
 
 #define HW_CAP_NIC0		BIT(14)
 #define HW_CAP_NIC1		BIT(15)
@@ -232,6 +247,180 @@ enum gaudi_nic_mask {
 	GAUDI_NIC_MASK_ALL = 0x3FF
 };
 
+/**
+ * struct gaudi_nic_tx_taps - holds the NIC Tx taps values for a specific lane.
+ *                            Currently used for PAM4 only.
+ * @taps: holds all taps - tx_pre2, tx_pre1, tx_main, tx_post1 and tx_post2.
+ */
+struct gaudi_nic_tx_taps {
+	s32	taps[NIC_PHY_TX_TAPS_NUM];
+};
+
+/**
+ * struct gaudi_nic_macro - manage specific NIC macro that holds two NIC
+ *                          engines.
+ * @idx: index of the NIC macro.
+ * @num_of_lanes: number of lanes in the NIC macro.
+ */
+struct gaudi_nic_macro {
+	u8	idx;
+	u8	num_of_lanes;
+};
+
+/**
+ * struct gaudi_nic_device - manage specific NIC port.
+ * @hdev: habanalabs device structure.
+ * @ndev: pointer to network device.
+ * @nic_macro: pointer to the manage structure of the containing NIC macro.
+ * @napi: New API structure.
+ * @tx_wq: Tx work queue for handling packet transmission outside interrupt
+ *         context (for simulator only).
+ * @rx_wq: Rx work queue for handling incoming packets outside interrupt
+ *         context (for simulator only).
+ * @cq_wq: CQ work queue for handling CQEs outside interrupt context.
+ * @rx_mem_cpu: CPU address of RX memory.
+ * @rx_mem_dma: DMA address of RX memory.
+ * @cq_mem_cpu: CPU address of CQ memory.
+ * @cq_mem_dma: DMA address of CQ memory.
+ * @qp_err_mem_cpu: CPU address of QP error memory.
+ * @qp_err_mem_dma: DMA address of QP error memory.
+ * @in_reset: 1 if the NIC is currently in reset, 0 otherwise.
+ * @rx_poll_work: Rx work for polling mode.
+ * @cq_work: CQ work for processing CQEs.
+ * @link_status_work: work for checking NIC link status.
+ * @port_open_work: work for initializing the port H/W.
+ * @idr_lock: Protects qp_ids.
+ * @user_wq_lock: protects the user WQ configuration.
+ * @qp_ids: IDR to hold all connections IDs.
+ * @pcs_fail_fifo: queue for keeping the PCS link failures time stamps in order
+ *                 to reconfigure F/W if needed.
+ * @last_cqe_ts: time stamp of last processed CQE.
+ * @last_fw_tuning_ts: time stamp of last F/W tuning.
+ * @last_pcs_link_drop_ts: time stamp of last PCS link drop.
+ * @rx_msi_addr: Rx MSI address.
+ * @tx_swq_mem_device_va: device virtual address of Tx SWQ memory.
+ * @cq_mem_device_va: device virtual address of CQ memory.
+ * @rx_mem_size: Rx memory size.
+ * @cq_mem_size: CQ memory size.
+ * @qp_err_mem_size: QP error buffer memory size.
+ * @rx_ci: incremented by S/W for each received packet from the H/W.
+ * @tx_pi: incremented by S/W for each sent packet to the H/W.
+ * @tx_ci: incremented by H/W for each sent packet from the H/W.
+ * @cq_ci: incremented by S/W for each consumed CQE.
+ * @port: NIC specific port.
+ * @data_rate: NIC data rate according to speed and number of lanes.
+ * @tx_wq_pi: TX work queue PI for transmitting packets by their order (for
+ *            simulator only).
+ * @tx_wq_ci: TX work queue CI for transmitting packets by their order (for
+ *            simulator only).
+ * @qp_err_ci: next index of the QP error to fetch.
+ * @retry_cnt: counts the number of retries during link establishment.
+ * @pcs_fail_cnt: counter of PCS link failures since last F/W configuration.
+ * @pcs_local_fault_cnt: counter of PCS link local errors since last F/W
+ *                       configuration. These errors can appear even when link
+ *                       is up.
+ * @pcs_remote_fault_cnt: counter of PCS link remote errors since last F/W
+ *                        configuration. These errors can appear even when link
+ *                        is up.
+ * @speed: the bandwidth of the port in Mb/s.
+ * @last_cqe_cnt: the last number of processed CQEs.
+ * @cq_delay: the time between two invocations of the CQ polling work when not
+ *            idle.
+ * @cq_delay_idle: the time between two invocations of the CQ polling work when
+ *                 idle.
+ * @correctable_errors_cnt: count the correctable FEC blocks.
+ * @uncorrectable_errors_cnt: count the uncorrectable FEC blocks.
+ * @enabled: true if the NIC is enabled by the S/W, false otherwise. Can be
+ *           changed only from ndo_open/ndo_stop callbacks.
+ * @active: true if the NIC H/W is operational, false otherwise.
+ * @port_open: true if the port H/W is initialized, false otherwise.
+ * @do_macro_cfg: true if this port should handle the macro configuration, false
+ *              otherwise. Each NIC macro contains two ports - even and odd, and
+ *              only one of them should handle the shared configuration.
+ *              The default is for the even port to handle it, but in case that
+ *              the even port is disabled, the odd port will do it.
+ * @phy_fw_tuned: true if F/W is tuned, false otherwise.
+ * @pcs_link: true if the NIC has PCS link, false otherwise.
+ * @mac_loopback: true if port in MAC loopback mode, false otherwise.
+ * @auto_neg_enable: true if this port supports Autonegotiation, false
+ *                   otherwise.
+ * @auto_neg_resolved: true if this port completed Autonegotiation, false
+ *                     otherwise.
+ * @power_up_mask: represents which MAC channels should be configured during PHY
+ *                 power up.
+ * @fw_tuning_mask: represents which MAC channels should be configured during
+ *                  F/W tuning.
+ * @auto_neg_mask: represents which MAC channels should be configured during
+ *                 Autonegotiation.
+ * @pfc_enable: true if this port supports Priority Flow Control, false
+ *              otherwise.
+ */
+struct gaudi_nic_device {
+	struct hl_device	*hdev;
+	struct net_device	*ndev;
+	struct gaudi_nic_macro	*nic_macro;
+	struct napi_struct	napi;
+	struct workqueue_struct	*tx_wq;
+	struct workqueue_struct	*rx_wq;
+	struct workqueue_struct	*cq_wq;
+	void			*rx_mem_cpu;
+	dma_addr_t		rx_mem_dma;
+	void			*cq_mem_cpu;
+	dma_addr_t		cq_mem_dma;
+	void			*qp_err_mem_cpu;
+	dma_addr_t		qp_err_mem_dma;
+	atomic_t		in_reset;
+	struct delayed_work	rx_poll_work;
+	struct delayed_work	cq_work;
+	struct delayed_work	link_status_work;
+	struct delayed_work	port_open_work;
+	struct mutex		idr_lock;
+	struct mutex		user_wq_lock;
+	struct idr		qp_ids;
+	struct kfifo		pcs_fail_fifo;
+	ktime_t			last_cqe_ts;
+	ktime_t			last_fw_tuning_ts;
+	ktime_t			last_pcs_link_drop_ts;
+	u64			rx_msi_addr;
+	u64			tx_swq_mem_device_va;
+	u64			cq_mem_device_va;
+	u32			rx_mem_size;
+	u32			cq_mem_size;
+	u32			qp_err_mem_size;
+	u32			rx_ci;
+	u32			tx_pi;
+	u32			tx_ci;
+	u32			cq_ci;
+	u32			port;
+	u32			data_rate;
+	u32			tx_wq_pi;
+	u32			tx_wq_ci;
+	u32			qp_err_ci;
+	u32			retry_cnt;
+	u32			pcs_fail_cnt;
+	u32			pcs_local_fault_cnt;
+	u32			pcs_remote_fault_cnt;
+	u32			speed;
+	u32			last_cqe_cnt;
+	u32			cq_delay;
+	u32			cq_delay_idle;
+	u32			correctable_errors_cnt;
+	u32			uncorrectable_errors_cnt;
+	u8			enabled;
+	u8			active;
+	u8			port_open;
+	u8			do_macro_cfg;
+	u8			phy_fw_tuned;
+	u8			pcs_link;
+	u8			mac_loopback;
+	u8			auto_neg_enable;
+	u8			auto_neg_resolved;
+	u8			power_up_mask;
+	u8			fw_tuning_mask;
+	u8			auto_neg_mask;
+	u8			pfc_enable;
+};
+
 /**
  * struct gaudi_internal_qman_info - Internal QMAN information.
  * @pq_kernel_addr: Kernel address of the PQ memory area in the host.
@@ -247,14 +436,29 @@ struct gaudi_internal_qman_info {
 /**
  * struct gaudi_device - ASIC specific manage structure.
  * @cpucp_info_get: get information on device from CPU-CP
+ * @nic_handle_rx: NIC handler for incoming packet.
+ * @nic_handle_tx: NIC handler for outgoing packet.
+ * @nic_devices: array that holds all NIC ports manage structures.
+ * @nic_macros: array that holds all NIC macros manage structures.
+ * @nic_pam4_tx_taps: array that holds all PAM4 Tx taps of all NIC lanes.
+ * @nic_cq_comp: completion queue to handle wait/poll NIC CQ IOCTL.
+ * @nic_cq_lock: for serial copying of the CQEs from the NIC buffer to the user
+ *               queue.
  * @hw_queues_lock: protects the H/W queues from concurrent access.
  * @clk_gate_mutex: protects code areas that require clock gating to be disabled
  *                  temporarily
+ * @nic_cq_user_lock: protects the NIC CQ from concurrent operations that may
+ *               interfere with each other such as wait/mmap/destroy etc.
+ * @nic_qp_err_lock: protects the NIC QP error handler from pushing error
+ *                   entries to the CQ while it is under destruction.
+ * @nic_cq_buf: NIC CQ buffer, shared for all ports.
  * @internal_qmans: Internal QMANs information. The array size is larger than
  *                  the actual number of internal queues because they are not in
  *                  consecutive order.
  * @hbm_bar_cur_addr: current address of HBM PCI bar.
  * @max_freq_value: current max clk frequency.
+ * @nic_mac_loopback: enable MAC loopback on specific NIC ports.
+ * @nic_cq_user_new_cqes: number of available CQEs to process.
  * @events: array that holds all event id's
  * @events_stat: array that holds histogram of all received events.
  * @events_stat_aggregate: same as events_stat but doesn't get cleared on reset
@@ -263,29 +467,86 @@ struct gaudi_internal_qman_info {
  *                      signal we can use this engine in later code paths.
  *                      Each bit is cleared upon reset of its corresponding H/W
  *                      engine.
+ * @nic_cq_user_num_of_entries: number of CQ entries in the user CQ buffer
+ *                              (received from the user).
+ * @nic_cq_user_pi: producer index of the NIC CQ user buffer.
+ * @nic_cq_user_ci: consumer index of the NIC CQ user buffer.
+ * @nic_cq_status: return status of the CQ.
+ * @nic_cq_mmap_size: size of the mmapped CQ buffer.
+ * @nic_pcs_fail_time_frame: time frame is seconds to count PCS link failure.
+ * @nic_pcs_fail_threshold: PCS link failures threshold to reset link.
+ * @nic_qpc_cache_inv_timeout: timeout for NIC QPC cache invalidation.
+ * @nic_phy_load_fw: true if the NIC PHY F/W should be loaded, false otherwise.
+ * @nic_phy_config_fw: true if the NIC PHY F/W should be configured, false
+ *                     otherwise. The NIC PHY F/W should be configured on ASIC
+ *                     only, in contrary to simulator/Palladium.
+ * @nic_cq_enable: true if NIC CQ is enabled, false otherwise.
+ * @nic_cq_mmap: true if NIC CQ is mmapped, false otherwise.
+ * @nic_use_fw_polarity: true if NIC should use polarity values from F/W,
+ *                       false if NIC should use hard coded values.
  * @multi_msi_mode: whether we are working in multi MSI single MSI mode.
  *                  Multi MSI is possible only with IOMMU enabled.
+ * @nic_in_reset: true if the NIC was marked as in reset, false otherwise. Used
+ *                to avoid an additional stopping of the NIC if a hard reset was
+ *                re-initiated.
  * @mmu_cache_inv_pi: PI for MMU cache invalidation flow. The H/W expects an
  *                    8-bit value so use u8.
+ * @nic_check_link: true if the PCS link should be checked periodically.
+ * @nic_cq_irq_enable: true if an interrupt was allocated for the NIC CQ.
+ * @nic_in_teardown: true if the NIC is in teardown (during device remove).
+ * @nic_phy_auto_neg_lpbk: true if the NIC PHY should support Autoneg in
+ *                         loopback mode.
  */
 struct gaudi_device {
 	int (*cpucp_info_get)(struct hl_device *hdev);
-
+	void (*nic_handle_rx)(struct gaudi_nic_device *gaudi_nic);
+	int (*nic_handle_tx)(struct gaudi_nic_device *gaudi_nic, void *data);
+	struct gaudi_nic_device		nic_devices[NIC_NUMBER_OF_PORTS];
+	struct gaudi_nic_macro		nic_macros[NIC_NUMBER_OF_MACROS];
+	struct gaudi_nic_tx_taps	nic_pam4_tx_taps[NIC_MAX_NUM_OF_LANES];
+	struct completion		nic_cq_comp;
+
+	spinlock_t			nic_cq_lock;
 	/* TODO: remove hw_queues_lock after moving to scheduler code */
 	spinlock_t			hw_queues_lock;
 	struct mutex			clk_gate_mutex;
 
+	struct mutex			nic_cq_user_lock;
+	struct mutex			nic_qp_err_lock;
+
+	struct hl_nic_cqe		*nic_cq_buf;
 	struct gaudi_internal_qman_info	internal_qmans[GAUDI_QUEUE_ID_SIZE];
 
 	u64				hbm_bar_cur_addr;
 	u64				max_freq_value;
+	u64				nic_mac_loopback;
+
+	atomic_t			nic_cq_user_new_cqes;
 
 	u32				events[GAUDI_EVENT_SIZE];
 	u32				events_stat[GAUDI_EVENT_SIZE];
 	u32				events_stat_aggregate[GAUDI_EVENT_SIZE];
 	u32				hw_cap_initialized;
+	u32				nic_cq_user_num_of_entries;
+	u32				nic_cq_user_pi;
+	u32				nic_cq_user_ci;
+	u32				nic_cq_status;
+	u32				nic_cq_mmap_size;
+	u32				nic_pcs_fail_time_frame;
+	u32				nic_pcs_fail_threshold;
+	u32				nic_qpc_cache_inv_timeout;
+	u8				nic_phy_load_fw;
+	u8				nic_phy_config_fw;
+	u8				nic_cq_enable;
+	u8				nic_cq_mmap;
+	u8				nic_use_fw_polarity;
 	u8				multi_msi_mode;
+	u8				nic_in_reset;
 	u8				mmu_cache_inv_pi;
+	u8				nic_check_link;
+	u8				nic_cq_irq_enable;
+	u8				nic_in_teardown;
+	u8				nic_phy_auto_neg_lpbk;
 };
 
 void gaudi_init_security(struct hl_device *hdev);
@@ -296,4 +557,19 @@ int gaudi_debug_coresight(struct hl_device *hdev, void *data);
 void gaudi_halt_coresight(struct hl_device *hdev);
 int gaudi_get_clk_rate(struct hl_device *hdev, u32 *cur_clk, u32 *max_clk);
 
+/* NIC functions */
+
+int gaudi_nic_ports_init(struct hl_device *hdev);
+void gaudi_nic_ports_fini(struct hl_device *hdev);
+int gaudi_nic_hard_reset_prepare(struct hl_device *hdev);
+void gaudi_nic_stop(struct hl_device *hdev);
+void gaudi_nic_ports_reopen(struct hl_device *hdev);
+void gaudi_nic_ctx_fini(struct hl_ctx *ctx);
+irqreturn_t gaudi_nic_rx_irq_handler(int irq, void *arg);
+irqreturn_t gaudi_nic_cq_irq_handler(int irq, void *arg);
+netdev_tx_t gaudi_nic_handle_tx_pkt(struct gaudi_nic_device *gaudi_nic,
+					struct sk_buff *skb);
+int gaudi_nic_sw_init(struct hl_device *hdev);
+void gaudi_nic_sw_fini(struct hl_device *hdev);
+
 #endif /* GAUDIP_H_ */
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_nic.c b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
new file mode 100644
index 000000000000..9fc6e9fe7ac4
--- /dev/null
+++ b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
@@ -0,0 +1,2327 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright 2018-2020 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ */
+
+#include "gaudi_nic.h"
+#include "../include/gaudi/asic_reg/gaudi_regs.h"
+#include "../include/hw_ip/mmu/mmu_general.h"
+#include "../include/hw_ip/nic/nic_general.h"
+#include <uapi/misc/habanalabs.h>
+
+#include <linux/vmalloc.h>
+#include <linux/etherdevice.h>
+#include <linux/pci.h>
+#include <linux/ipv6.h>
+#include <linux/if_vlan.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
+
+#define HL_NIC_DEBUG 0
+
+/*
+ * enum link_status - PCS link status.
+ * @LINK_UP: PHY is ready and PCS has link.
+ * @PCS_DOWN: PCS has no link.
+ * @PHY_DON: PHY is not ready.
+ * @FAIL_RECONFIG: need to reconfigure the PHY due to PCS link failures.
+ * @FAULT_RECONFIG: need to reconfigure the PHY due to PCS link faults.
+ */
+enum link_status {
+	LINK_UP,
+	PCS_DOWN,
+	PHY_DOWN,
+	FAIL_RECONFIG,
+	FAULT_RECONFIG
+};
+
+/*
+ * enum eth_pkt_status - status of Rx Ethernet packet.
+ * ETH_PKT_OK: packet was received successfully.
+ * ETH_PKT_DROP: packet should be dropped.
+ * ETH_PKT_NONE: no available packet.
+ */
+enum eth_pkt_status {
+	ETH_PKT_OK,
+	ETH_PKT_DROP,
+	ETH_PKT_NONE
+};
+
+#define HLS1_EXT_PORTS_MASK		0x302
+#define FW_LINK_TRAINING_CNT		200
+#define FW_TUNING_CNT			3000
+#define PCS_LINK_CNT			10
+#define PCS_FAIL_TIME_FRAME_SEC		(60 * 5) /* 5 minutes */
+#define PCS_FAIL_THRESHOLD		8
+#define PCS_FAULT_THRESHOLD		20
+#define PCS_LINK_RETRY_MSEC		20
+
+/* NIC_MAX_MTU equals 8K minus eth header */
+#define NIC_MAX_MTU	((1 << 13) - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN))
+
+/* MAC configuration */
+#define MAC_CFG_MAC(addr, data)		\
+				mac_write(gaudi_nic, i, "mac", addr, data)
+#define MAC_CFG_MAC_CORE(addr, data)	\
+				mac_write(gaudi_nic, i, "mac_core", addr, data)
+#define MAC_CFG_XPCS(addr, data)	\
+				mac_write(gaudi_nic, i, "xpcs", addr, data)
+#define MAC_CFG_XPCS91(addr, data)	\
+				mac_write(gaudi_nic, i, "xpcs91", addr, data)
+
+bool disabled_or_in_reset(struct gaudi_nic_device *gaudi_nic)
+{
+	return atomic_read(&gaudi_nic->in_reset) ||
+			hl_device_disabled_or_in_reset(gaudi_nic->hdev);
+}
+
+static void qpc_cache_inv(struct gaudi_nic_device *gaudi_nic, bool is_req)
+{
+	struct gaudi_device *gaudi = gaudi_nic->hdev->asic_specific;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 status, port = gaudi_nic->port;
+	u64 inv_reg, status_reg, base;
+	int rc;
+
+	if (is_req) {
+		inv_reg = mmNIC0_QPC0_REQ_QPC_CACHE_INVALIDATE;
+		status_reg = mmNIC0_QPC0_REQ_QPC_CACHE_INV_STATUS;
+	} else {
+		inv_reg = mmNIC0_QPC0_RES_QPC_CACHE_INVALIDATE;
+		status_reg = mmNIC0_QPC0_RES_QPC_CACHE_INV_STATUS;
+	}
+
+	/* fix the address to the correct NIC */
+	base = NIC_CFG_BASE(port);
+	inv_reg += base;
+	status_reg += base;
+
+	WREG32(inv_reg, 1);
+	WREG32(inv_reg, 0);
+
+	/* no need to wait for the status in case of hard reset */
+	if (hdev->hard_reset_pending)
+		return;
+
+	rc = hl_poll_timeout(
+		hdev,
+		status_reg,
+		status,
+		status &
+			NIC0_QPC0_REQ_QPC_CACHE_INV_STATUS_INVALIDATE_DONE_MASK,
+		1000,
+		gaudi->nic_qpc_cache_inv_timeout);
+
+	if (rc)
+		dev_warn(hdev->dev,
+			"NIC %s QPC cache invalidation timeout, port: %d\n",
+			is_req ? "requester" : "responder", port);
+}
+
+static void eth_start_stop(struct gaudi_nic_device *gaudi_nic, bool is_start)
+{
+	struct gaudi_device *gaudi = gaudi_nic->hdev->asic_specific;
+	u64 *qpc_addr, req_qpc_addr, res_qpc_addr;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	struct qpc_requester req_qp;
+	struct qpc_responder res_qp;
+	u32 port = gaudi_nic->port;
+	int i;
+
+	/*
+	 * Due to H/W bug, odd ports cannot generate MSI interrupts.
+	 * Hence they generate wire interrupts and CPU-CP converts them to MSI
+	 * interrupts. In order to avoid CPU-CP from generating MSI interrupts
+	 * after the odd port went down, clear here the interrupt enable bit.
+	 */
+	if (!is_start && !hdev->nic_rx_poll && (port & 1))
+		NIC_RMWREG32(mmNIC0_QPC0_INTERRUPT_EN, 0,
+				NIC0_QPC0_INTERRUPT_EN_INTERRUPT4_WIRE_EN_MASK);
+
+	/* ETH uses QP 0 */
+	req_qpc_addr = REQ_QPC_ADDR(port, 0);
+
+	memset(&req_qp, 0, sizeof(req_qp));
+	REQ_QPC_SET_TRANSPORT_SERVICE(req_qp, TS_RAW);
+	REQ_QPC_SET_LAST_IDX(req_qp, (WQ_BUFFER_SIZE - 1));
+	/*
+	 * See comment regarding the NIC_HW_MAX_QP_NUM value in the sction of
+	 * TXE configuration in config_port_hw().
+	 */
+	REQ_QPC_SET_WQ_BASE_ADDR(req_qp, NIC_HW_MAX_QP_NUM);
+	REQ_QPC_SET_VALID(req_qp, (u64) is_start);
+	REQ_QPC_SET_SECURED(req_qp, SECURED);
+	REQ_QPC_SET_PORT(req_qp, 0);
+
+	qpc_addr = (u64 *) &req_qp;
+	for (i = 0 ; i < (sizeof(req_qp) / sizeof(u64)) ; i++)
+		writeq(qpc_addr[i], hdev->pcie_bar[HBM_BAR_ID] +
+			((req_qpc_addr + i * 8) - gaudi->hbm_bar_cur_addr));
+
+	readq(hdev->pcie_bar[HBM_BAR_ID]);
+
+	qpc_cache_inv(gaudi_nic, true);
+
+	/* ETH uses QP 0 */
+	res_qpc_addr = RES_QPC_ADDR(port, 0);
+
+	memset(&res_qp, 0, sizeof(res_qp));
+	RES_QPC_SET_TRANSPORT_SERVICE(res_qp, TS_RAW);
+	RES_QPC_SET_LOG_BUF_SIZE_MASK(res_qp, QPC_RES_LOG_BUF_SIZE_MASK);
+	RES_QPC_SET_VALID(res_qp, (u64) is_start);
+	RES_QPC_SET_SECURED(res_qp, SECURED);
+	RES_QPC_SET_PORT(res_qp, 0);
+
+	qpc_addr = (u64 *) &res_qp;
+	for (i = 0 ; i < (sizeof(res_qp) / sizeof(u64)) ; i++)
+		writeq(qpc_addr[i], hdev->pcie_bar[HBM_BAR_ID] +
+			((res_qpc_addr + i * 8) - gaudi->hbm_bar_cur_addr));
+
+	readq(hdev->pcie_bar[HBM_BAR_ID]);
+
+	qpc_cache_inv(gaudi_nic, false);
+}
+
+static u32 mac_addr_convert(int mac, char *cfg_type, u32 addr)
+{
+	if (!strcmp(cfg_type, "xpcs")) {
+		if (addr >= 200 && addr <= 219)
+			addr = addr - 200 + 54;
+		else if (addr >= 400 && addr <= 419)
+			addr = addr - 400 + 74;
+		else if (addr >= (1 << 15))
+			addr = addr - (1 << 15) + 95;
+
+		addr = addr * 4 + mac * (1 << 12);
+	} else if (!strcmp(cfg_type, "mac")) {
+		addr = addr + mac * (1 << 12) + (1 << 10);
+	} else if (!strcmp(cfg_type, "mac_core")) {
+		addr = addr + (1 << 15);
+	} else if (!strcmp(cfg_type, "xpcs91")) {
+		addr = addr * 4 + (1 << 11) * 10;
+	}
+
+	return addr + 0xCC0000;
+}
+
+static void mac_write(struct gaudi_nic_device *gaudi_nic, int mac,
+			char *cfg_type, u32 addr, u32 data)
+{
+	struct hl_device *hdev = gaudi_nic->hdev;
+
+	addr = mac_addr_convert(mac, cfg_type, addr);
+
+	NIC_MACRO_WREG32(addr, data);
+}
+
+u32 gaudi_nic_mac_read(struct gaudi_nic_device *gaudi_nic, int mac,
+			char *cfg_type, u32 addr)
+{
+	struct hl_device *hdev = gaudi_nic->hdev;
+
+	addr = mac_addr_convert(mac, cfg_type, addr);
+
+	return NIC_MACRO_RREG32(addr);
+}
+
+static void config_port_hw(struct gaudi_nic_device *gaudi_nic, u64 mac_addr)
+{
+	u64 swq_base_addr = SWQ_BASE_ADDR + gaudi_nic->port * SWQ_BASE_SIZE;
+	u32 rx_mem_addr_lo, rx_mem_addr_hi, txs_fence_idx, txs_pi, txs_ci,
+		txs_tail, txs_head, txs_timeout_31_0, timeout_47_32, prio,
+		txs_port, rl_en_log_time, txs_schedq, port = gaudi_nic->port;
+	u64 txs_addr, cq_msi_addr,
+		req_qpc_base_addr = REQ_QPC_ADDR(gaudi_nic->port, 0),
+		res_qpc_base_addr = RES_QPC_ADDR(gaudi_nic->port, 0);
+	struct gaudi_device *gaudi = gaudi_nic->hdev->asic_specific;
+	u64 tx_swq_base, cq_mem_addr = gaudi_nic->cq_mem_device_va;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	int i;
+
+	if (gaudi->multi_msi_mode) {
+		gaudi_nic->rx_msi_addr = RX_MSI_ADDRESS + port * 4;
+		cq_msi_addr = CQ_MSI_ADDRESS;
+	} else {
+		gaudi_nic->rx_msi_addr = cq_msi_addr = mmPCIE_MSI_INTR_0;
+	}
+
+	/* TXS Configuration */
+	txs_addr = TXS_BASE_ADDR + port * TXS_BASE_SIZE;
+
+	/* Timer free list */
+	for (i = 0 ; i < TXS_FREE_NUM_ENTRIES ; i++) {
+		writel(TXS_GRANULARITY + i, hdev->pcie_bar[HBM_BAR_ID] +
+			((txs_addr + TXS_FREE_OFFS + i * 4) -
+				gaudi->hbm_bar_cur_addr));
+	}
+
+	/* Perform read to flush the writes */
+	readq(hdev->pcie_bar[HBM_BAR_ID]);
+
+	NIC_WREG32(mmNIC0_TXS0_BASE_ADDRESS_49_18,
+				(txs_addr + TXS_FIFO_OFFS) >> 18);
+	NIC_WREG32(mmNIC0_TXS0_BASE_ADDRESS_17_7,
+				((txs_addr + TXS_FIFO_OFFS) >> 7) & 0x7FF);
+	NIC_WREG32(mmNIC0_TXS0_FREE_LIST_PUSH_MASK_EN, 1);
+
+	txs_fence_idx = 0;
+	txs_pi = 0;
+	txs_ci = 0;
+	txs_tail = 0;
+	txs_head = 0;
+	txs_timeout_31_0 = 0;
+	timeout_47_32 = 0;
+	prio = 0;
+	txs_port = 0;
+	rl_en_log_time = 0;
+	txs_schedq = (timeout_47_32 & 0xFFFF) | ((prio & 0x3) << 16) |
+			((txs_port & 1) << 18) |
+			((rl_en_log_time & 0x3F) << 19);
+
+	for (i = 0 ; i < TXS_SCHEDQ ; i++) {
+		txs_tail = txs_head = i;
+		NIC_WREG32(mmNIC0_TXS0_SCHEDQ_UPDATE_DESC_31_0, txs_fence_idx);
+		NIC_WREG32(mmNIC0_TXS0_SCHEDQ_UPDATE_DESC_63_32, txs_pi);
+		NIC_WREG32(mmNIC0_TXS0_SCHEDQ_UPDATE_DESC_95_64, txs_ci);
+		NIC_WREG32(mmNIC0_TXS0_SCHEDQ_UPDATE_DESC_127_96, txs_tail);
+		NIC_WREG32(mmNIC0_TXS0_SCHEDQ_UPDATE_DESC_159_128, txs_head);
+		NIC_WREG32(mmNIC0_TXS0_SCHEDQ_UPDATE_DESC_191_160,
+							txs_timeout_31_0);
+		NIC_WREG32(mmNIC0_TXS0_SCHEDQ_UPDATE_DESC_217_192, txs_schedq);
+		NIC_WREG32(mmNIC0_TXS0_SCHEDQ_UPDATE_FIFO, i);
+		NIC_WREG32(mmNIC0_TXS0_SCHEDQ_UPDATE_EN, 1);
+	}
+
+	NIC_WREG32(mmNIC0_TXS0_TICK_WRAP, 100);
+	NIC_WREG32(mmNIC0_TXS0_FIRST_SCHEDQ_ID,
+			0 << NIC0_TXS0_FIRST_SCHEDQ_ID_R0_SHIFT |
+			64 << NIC0_TXS0_FIRST_SCHEDQ_ID_R1_SHIFT |
+			128 << NIC0_TXS0_FIRST_SCHEDQ_ID_R2_SHIFT |
+			192 << NIC0_TXS0_FIRST_SCHEDQ_ID_R3_SHIFT);
+	NIC_WREG32(mmNIC0_TXS0_LAST_SCHEDQ_ID,
+			63 << NIC0_TXS0_FIRST_SCHEDQ_ID_R0_SHIFT |
+			127 << NIC0_TXS0_FIRST_SCHEDQ_ID_R1_SHIFT |
+			191 << NIC0_TXS0_FIRST_SCHEDQ_ID_R2_SHIFT |
+			155 << NIC0_TXS0_FIRST_SCHEDQ_ID_R3_SHIFT);
+	NIC_WREG32(mmNIC0_TXS0_SCAN_TIME_COMPARE_0, 4);
+	NIC_WREG32(mmNIC0_TXS0_SCAN_TIME_COMPARE_1, 0);
+	NIC_WREG32(mmNIC0_TXS0_TMR_SCAN_EN, 1);
+
+	NIC_WREG32(mmNIC0_TXS0_BASE_ADDRESS_FREE_LIST_49_32,
+				(txs_addr + TXS_FREE_OFFS) >> 32);
+	NIC_WREG32(mmNIC0_TXS0_BASE_ADDRESS_FREE_LIST_31_0,
+				(txs_addr + TXS_FREE_OFFS) & 0xFFFFFFFF);
+
+	NIC_WREG32(mmNIC0_TXS0_LIST_MASK,
+			~(0xFFFFFFFF << (ilog2(TXS_FREE_NUM_ENTRIES) - 5)));
+	NIC_WREG32(mmNIC0_TXS0_PRODUCER_UPDATE, TXS_FREE_NUM_ENTRIES);
+	NIC_WREG32(mmNIC0_TXS0_PRODUCER_UPDATE_EN, 1);
+	NIC_WREG32(mmNIC0_TXS0_PRODUCER_UPDATE_EN, 0);
+	NIC_WREG32(mmNIC0_TXS0_LIST_MEM_READ_MASK, 0);
+	NIC_WREG32(mmNIC0_TXS0_PUSH_LOCK_EN, 1);
+
+	/* Consider burst size */
+	NIC_WREG32(mmNIC0_TXS0_IGNORE_BURST_EN, 0);
+
+	/* TXE Configuration */
+
+	/*
+	 * We want to separate the driver WQ from the user WQs.
+	 * Since the NIC supports 4 different WQ base addresses, base address 0
+	 * will be used by the user and base address 1 by the driver.
+	 * The WQ base address index is inferred by two bits that are taken from
+	 * QPC.WQ_BASE_ADDR and are configurable by SQ_BASE_ADDRESS_SEL.
+	 * Since we support up to NIC_HW_MAX_QP_NUM user QPs and the single
+	 * driver QP is located after them, we configure the driver
+	 * QPC.WQ_BASE_ADDR to the value NIC_HW_MAX_QP_NUM, and
+	 * SQ_BASE_ADDRESS_SEL to have the right shift value so the driver will
+	 * indeed use base address 1.
+	 */
+
+	/*
+	 * Need to subtract the size of the user WQs because the driver uses WQ
+	 * base address 1.
+	 */
+	tx_swq_base = swq_base_addr -
+			(1 << (WQ_BUFFER_LOG_SIZE - 2)) * NIC_HW_MAX_QP_NUM *
+				DEVICE_CACHE_LINE_SIZE;
+
+	NIC_WREG32(mmNIC0_TXE0_SQ_BASE_ADDRESS_49_32_1,
+			(tx_swq_base >> 32) & 0x3FFFFF);
+	NIC_WREG32(mmNIC0_TXE0_SQ_BASE_ADDRESS_31_0_1,
+			tx_swq_base & 0xFFFFFFFF);
+
+	/*
+	 * This register should contain the value of the shift that the H/W will
+	 * apply on QPC.WQ_BASE_ADDR in order to get the WQ base address index.
+	 * The driver uses WQ base address 1 so we need to trim the leading
+	 * zero bits.
+	 */
+	NIC_WREG32(mmNIC0_TXE0_SQ_BASE_ADDRESS_SEL, ffs(NIC_HW_MAX_QP_NUM) - 1);
+
+	NIC_WREG32(mmNIC0_TXE0_LOG_MAX_WQ_SIZE_1, WQ_BUFFER_LOG_SIZE - 2);
+	NIC_WREG32(mmNIC0_TXE0_PORT0_MAC_CFG_47_32, (mac_addr >> 32) & 0xFFFF);
+	NIC_WREG32(mmNIC0_TXE0_PORT0_MAC_CFG_31_0, mac_addr & 0xFFFFFFFF);
+	NIC_WREG32(mmNIC0_TXE0_PORT1_MAC_CFG_47_32, (mac_addr >> 32) & 0xFFFF);
+	NIC_WREG32(mmNIC0_TXE0_PORT1_MAC_CFG_31_0, mac_addr & 0xFFFFFFFF);
+
+	/* Since the user WQs are mapped via MMU by the user, its AXI_USER
+	 * registers are set without MMU bypass and with the user ASID.
+	 * Because these configuration registers are shared between the user WQs
+	 * and the ETH Tx WQ, the latter can't be mapped via MMU as we need to
+	 * configure the LKD ASID for that.
+	 * In addition, the ETH Tx WQ is secured so the user shouldn't be able
+	 * to access it. Hence we place the ETH Tx WQ on HBM in the LKD reserved
+	 * section.
+	 */
+	NIC_WREG32(mmNIC0_TXE0_WQE_FETCH_AXI_USER, 1);
+	/*
+	 * The Tx data is placed on HBM. Hence configure it without MMU bypass
+	 * and with the user ASID to avoid any successful access to the host
+	 */
+	NIC_WREG32(mmNIC0_TXE0_DATA_FETCH_AXI_USER, 1);
+	NIC_WREG32(mmNIC0_TXE0_INTERRUPT_MASK, 3);
+
+	/* Make sure data fetch can never be privileged */
+	NIC_WREG32(mmNIC0_TXE0_DATA_FETCH_AXI_PROT, 0x80);
+	/* Make sure WQE fetch can never be privileged */
+	NIC_WREG32(mmNIC0_TXE0_WQE_FETCH_AXI_PROT, 0x80);
+
+	/* QPC Configuration */
+	NIC_WREG32(mmNIC0_QPC0_REQ_BASE_ADDRESS_49_18,
+			(req_qpc_base_addr >> 18) & 0xFFFFFFFF);
+	NIC_WREG32(mmNIC0_QPC0_REQ_BASE_ADDRESS_17_7,
+			(req_qpc_base_addr >> 7) & 0x7FF);
+	NIC_WREG32(mmNIC0_QPC0_RES_BASE_ADDRESS_49_18,
+			(res_qpc_base_addr >> 18) & 0xFFFFFFFF);
+	NIC_WREG32(mmNIC0_QPC0_RES_BASE_ADDRESS_17_7,
+			(res_qpc_base_addr >> 7) & 0x7FF);
+	NIC_WREG32(mmNIC0_QPC0_RES_QPC_CACHE_INVALIDATE, 1);
+	NIC_WREG32(mmNIC0_QPC0_REQ_QPC_CACHE_INVALIDATE, 1);
+	NIC_WREG32(mmNIC0_QPC0_RES_QPC_CACHE_INVALIDATE, 0);
+	NIC_WREG32(mmNIC0_QPC0_REQ_QPC_CACHE_INVALIDATE, 0);
+	NIC_WREG32(mmNIC0_QPC0_INTERRUPT_BASE_4, gaudi_nic->rx_msi_addr);
+	NIC_WREG32(mmNIC0_QPC0_INTERRUPT_DATA_4, 1);
+	NIC_WREG32(mmNIC0_QPC0_RES_RING0_CFG, RAW_QPN);
+	/* Interrupt each packet */
+	NIC_WREG32(mmNIC0_QPC0_INTERRUPT_CFG, 0x1FF);
+	NIC_WREG32(mmNIC0_QPC0_INTERRUPT_CAUSE, 0);
+	/* enable only the QP error interrupt, other interrupts are unused */
+	NIC_WREG32(mmNIC0_QPC0_INTERRUPT_MASK, 0x110);
+	NIC_WREG32(mmNIC0_QPC0_AXI_PROT, 0); /* secured */
+
+	NIC_WREG32(mmNIC0_QPC0_ERR_FIFO_BASE_ADDR_49_18,
+			(gaudi_nic->qp_err_mem_dma >> 18) & 0xFFFFFFFF);
+	NIC_WREG32(mmNIC0_QPC0_ERR_FIFO_BASE_ADDR_17_7,
+			gaudi_nic->qp_err_mem_dma & 0x3FF80);
+	NIC_WREG32(mmNIC0_QPC0_ERR_FIFO_PRODUCER_INDEX, 0);
+	NIC_WREG32(mmNIC0_QPC0_ERR_FIFO_CONSUMER_INDEX, 0);
+	NIC_WREG32(mmNIC0_QPC0_ERR_FIFO_WRITE_INDEX, 0);
+	NIC_WREG32(mmNIC0_QPC0_ERR_FIFO_MASK, QP_ERR_BUF_SIZE - 1);
+	/* The error FIFO is unmapped, hence the bypass */
+	NIC_WREG32(mmNIC0_QPC0_AXI_USER, 0x400);
+	NIC_WREG32(mmNIC0_QPC0_RETRY_COUNT_MAX, 0xFEFE);
+
+	/*
+	 * Generate wire interrupt in case of a QP error.
+	 * CPU-CP converts it to event.
+	 */
+	NIC_WREG32(mmNIC0_QPC0_INTERRUPT_EN,
+		1 << NIC0_QPC0_INTERRUPT_EN_INTERRUPT8_WIRE_EN_SHIFT);
+
+	/* RXE Configuration */
+	rx_mem_addr_lo = lower_32_bits(gaudi_nic->rx_mem_dma);
+	/* discard packets above the max size */
+	rx_mem_addr_hi = (upper_32_bits(gaudi_nic->rx_mem_dma) <<
+			NIC0_RXE0_RAW_BASE_HI_P1_RAW_BASE_ADDR_HI_P1_SHIFT) |
+		(ilog2(NIC_MAX_PKT_SIZE) <<
+			NIC0_RXE0_RAW_BASE_HI_P1_LOG_RAW_ENTRY_SIZE_P1_SHIFT);
+
+	NIC_WREG32(mmNIC0_RXE0_ARUSER_HBW_10_0, 1);
+	NIC_WREG32(mmNIC0_RXE0_ARUSER_HBW_31_11, 0);
+
+	/* Make sure LBW write access (for SM) can never be privileged */
+	NIC_WREG32(mmNIC0_RXE0_AWPROT_LBW, 0x2);
+
+	/* Make sure HBW read access (for WQE) is always unsecured */
+	NIC_WREG32(mmNIC0_RXE0_ARPROT_HBW, 0x222);
+
+	NIC_WREG32(mmNIC0_RXE0_RAW_QPN_P0_0, RAW_QPN);
+	NIC_WREG32(mmNIC0_RXE0_RAW_QPN_P0_1, RAW_QPN);
+	NIC_WREG32(mmNIC0_RXE0_RAW_QPN_P1_0, RAW_QPN);
+	NIC_WREG32(mmNIC0_RXE0_RAW_QPN_P1_1, RAW_QPN);
+	NIC_WREG32(mmNIC0_RXE0_RAW_QPN_P2_0, RAW_QPN);
+	NIC_WREG32(mmNIC0_RXE0_RAW_QPN_P2_1, RAW_QPN);
+	NIC_WREG32(mmNIC0_RXE0_RAW_QPN_P3_0, RAW_QPN);
+	NIC_WREG32(mmNIC0_RXE0_RAW_QPN_P3_1, RAW_QPN);
+	NIC_WREG32(mmNIC0_RXE0_RAW_BASE_LO_P0_0, rx_mem_addr_lo);
+	NIC_WREG32(mmNIC0_RXE0_RAW_BASE_LO_P0_1, rx_mem_addr_lo);
+	NIC_WREG32(mmNIC0_RXE0_RAW_BASE_HI_P0_0, rx_mem_addr_hi);
+	NIC_WREG32(mmNIC0_RXE0_RAW_BASE_HI_P0_1, rx_mem_addr_hi);
+
+	NIC_WREG32(mmNIC0_RXE0_RAW_BASE_LO_P1_0, rx_mem_addr_lo);
+	NIC_WREG32(mmNIC0_RXE0_RAW_BASE_LO_P1_1, rx_mem_addr_lo);
+	NIC_WREG32(mmNIC0_RXE0_RAW_BASE_HI_P1_0, rx_mem_addr_hi);
+	NIC_WREG32(mmNIC0_RXE0_RAW_BASE_HI_P1_1, rx_mem_addr_hi);
+
+	NIC_WREG32(mmNIC0_RXE0_RAW_BASE_LO_P2_0, rx_mem_addr_lo);
+	NIC_WREG32(mmNIC0_RXE0_RAW_BASE_LO_P2_1, rx_mem_addr_lo);
+	NIC_WREG32(mmNIC0_RXE0_RAW_BASE_HI_P2_0, rx_mem_addr_hi);
+	NIC_WREG32(mmNIC0_RXE0_RAW_BASE_HI_P2_1, rx_mem_addr_hi);
+
+	NIC_WREG32(mmNIC0_RXE0_RAW_BASE_LO_P3_0, rx_mem_addr_lo);
+	NIC_WREG32(mmNIC0_RXE0_RAW_BASE_LO_P3_1, rx_mem_addr_lo);
+	NIC_WREG32(mmNIC0_RXE0_RAW_BASE_HI_P3_0, rx_mem_addr_hi);
+	NIC_WREG32(mmNIC0_RXE0_RAW_BASE_HI_P3_1, rx_mem_addr_hi);
+
+	/*
+	 * See the comment for mmNIC0_TXE0_SQ_BASE_ADDRESS_SEL. The same applies
+	 * for the Rx.
+	 */
+	NIC_WREG32(mmNIC0_RXE0_WQ_BASE_WINDOW_SEL, ffs(NIC_HW_MAX_QP_NUM) - 1);
+
+	NIC_WREG32(mmNIC0_RXE0_PKT_DROP,
+			(0 << NIC0_RXE0_PKT_DROP_ERR_QP_INVALID_SHIFT) |
+			(1 << NIC0_RXE0_PKT_DROP_ERR_TS_MISMATCH_SHIFT) |
+			(0 << NIC0_RXE0_PKT_DROP_ERR_CS_INVALID_SHIFT) |
+			(0 << NIC0_RXE0_PKT_DROP_ERR_REQ_PSN_INVALID_SHIFT) |
+			(1 << NIC0_RXE0_PKT_DROP_ERR_RES_RKEY_INVALID_SHIFT) |
+			(0 << NIC0_RXE0_PKT_DROP_ERR_RES_RESYNC_INVALID_SHIFT) |
+			/* H/W WA for check priority order */
+			(0 << NIC0_RXE0_PKT_DROP_ERR_INV_OPCODE_SHIFT) |
+			(0 << NIC0_RXE0_PKT_DROP_ERR_INV_SYNDROME_SHIFT) |
+			(0 << NIC0_RXE0_PKT_DROP_ERR_INV_RAW_SIZE_SHIFT));
+
+	/* CQ */
+	NIC_WREG32(mmNIC0_RXE0_CQ_BASE_ADDR_31_7, cq_mem_addr &
+					NIC0_RXE0_CQ_BASE_ADDR_31_7_R_MASK);
+	NIC_WREG32(mmNIC0_RXE0_CA_BASE_ADDR_49_32, cq_mem_addr >> 32);
+	NIC_WREG32(mmNIC0_RXE0_CQ_WRITE_INDEX, 0);
+	NIC_WREG32(mmNIC0_RXE0_CQ_PRODUCER_INDEX, 0);
+	NIC_WREG32(mmNIC0_RXE0_CQ_CONSUMER_INDEX, 0);
+	NIC_WREG32(mmNIC0_RXE0_CQ_CFG0,
+			(1 << NIC0_RXE0_CQ_CFG0_ENABLE_SHIFT) |
+			(1 << NIC0_RXE0_CQ_CFG0_INTERRUPT_MASK_SHIFT) |
+			(8 << NIC0_RXE0_CQ_CFG0_CREDIT_SHIFT) |
+			(1 << NIC0_RXE0_CQ_CFG0_WRAPAROUND_EN_SHIFT) |
+			(1 << NIC0_RXE0_CQ_CFG0_SOB_CQ_MUTEX_SHIFT) |
+			(24 << NIC0_RXE0_CQ_CFG0_CQ_SELECT_SHIFT));
+	NIC_WREG32(mmNIC0_RXE0_CQ_MASK, CQ_PORT_BUF_LEN - 1);
+	/* CQ overrun interrupt only */
+	NIC_WREG32(mmNIC0_RXE0_CQ_MSI_ADDR_1, cq_msi_addr);
+	NIC_WREG32(mmNIC0_RXE0_CQ_MSI_DATA_1, 1);
+	NIC_WREG32(mmNIC0_RXE0_MSI_CASUE_MASK, 2);
+	NIC_WREG32(mmNIC0_RXE0_MSI_CAUSE, 0);
+
+	/*
+	 * Due to H/W bug, odd ports cannot generate MSI interrupts.
+	 * Hence they generate wire interrupts and CPU-CP converts them to MSI
+	 * interrupts.
+	 */
+	if (!hdev->nic_rx_poll && (port & 1))
+		NIC_RMWREG32(mmNIC0_QPC0_INTERRUPT_EN, 1,
+			NIC0_QPC0_INTERRUPT_EN_INTERRUPT4_WIRE_EN_MASK);
+	else
+		NIC_RMWREG32(mmNIC0_QPC0_INTERRUPT_EN, 1,
+			NIC0_QPC0_INTERRUPT_EN_INTERRUPT4_MSI_EN_MASK);
+
+	/* MAC filtering */
+	if (port & 1) {
+		NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_31_0_2,
+					mac_addr & 0xFFFFFFFF);
+		NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_31_0_3,
+					mac_addr & 0xFFFFFFFF);
+
+		NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_47_32_2,
+					(mac_addr >> 32) & 0xFFFF);
+		NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_47_32_3,
+					(mac_addr >> 32) & 0xFFFF);
+	} else {
+		NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_31_0_0,
+					mac_addr & 0xFFFFFFFF);
+		NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_31_0_1,
+					mac_addr & 0xFFFFFFFF);
+
+		NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_47_32_0,
+					(mac_addr >> 32) & 0xFFFF);
+		NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_47_32_1,
+					(mac_addr >> 32) & 0xFFFF);
+	}
+
+	for (i = NIC_MAC_LANES_START ; i < NIC_MAC_NUM_OF_LANES ; i++) {
+		if (!(gaudi_nic->fw_tuning_mask & BIT(i)))
+			continue;
+
+		MAC_CFG_XPCS(0, gaudi_nic->mac_loopback ? 0xC000 : 0x8000);
+	}
+
+	gaudi_nic_set_pfc(gaudi_nic);
+}
+
+void gaudi_nic_set_pfc(struct gaudi_nic_device *gaudi_nic)
+{
+	int i;
+
+	for (i = NIC_MAC_LANES_START ; i < NIC_MAC_NUM_OF_LANES ; i++) {
+		if (!(gaudi_nic->fw_tuning_mask & BIT(i)))
+			continue;
+
+		MAC_CFG_MAC(0x8, gaudi_nic->pfc_enable ? 0x80813 : 0x2913);
+	}
+}
+
+static void config_port_mac(struct gaudi_nic_device *gaudi_nic)
+{
+	u32 port = gaudi_nic->port, speed = gaudi_nic->speed;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	int i;
+
+	for (i = NIC_MAC_LANES_START ; i < NIC_MAC_NUM_OF_LANES ; i++) {
+		/* H/W WA for error length */
+		MAC_CFG_MAC(0x14, 8192);
+
+		/* Disable FC FEC */
+		MAC_CFG_MAC_CORE(0x10, 0);
+
+		MAC_CFG_MAC(0x20, 4);
+		MAC_CFG_MAC(0x1C, 4);
+
+		switch (speed) {
+		case SPEED_10000:
+			MAC_CFG_XPCS(0x8010, 3);
+			break;
+		case SPEED_25000:
+			MAC_CFG_XPCS(0x8002, 0x4FFF);
+			MAC_CFG_XPCS(0x8010, 5);
+			MAC_CFG_XPCS(0x8008, 0x68C1);
+			MAC_CFG_XPCS(0x8009, 0x21);
+			MAC_CFG_XPCS(0x800A, 0xC4F0);
+			MAC_CFG_XPCS(0x800B, 0xE6);
+			MAC_CFG_XPCS(0x800C, 0x65C5);
+			MAC_CFG_XPCS(0x800D, 0x9B);
+			MAC_CFG_XPCS(0x800E, 0x79A2);
+			MAC_CFG_XPCS(0x800F, 0x3D);
+			break;
+		case SPEED_50000:
+			MAC_CFG_XPCS(0x8002, 0x4FFF);
+			MAC_CFG_XPCS(0x8010, 0);
+			MAC_CFG_XPCS(0x8008, 0x7690);
+			MAC_CFG_XPCS(0x8009, 0x47);
+			MAC_CFG_XPCS(0x800A, 0xC4F0);
+			MAC_CFG_XPCS(0x800B, 0xE6);
+			MAC_CFG_XPCS(0x800C, 0x65C5);
+			MAC_CFG_XPCS(0x800D, 0x9B);
+			MAC_CFG_XPCS(0x800E, 0x79A2);
+			MAC_CFG_XPCS(0x800F, 0x3D);
+			break;
+		case SPEED_100000:
+			MAC_CFG_XPCS(0x8002, 0x3FFF);
+			MAC_CFG_XPCS(0x8010, 0);
+			MAC_CFG_XPCS(0x8008, 0x68C1);
+			MAC_CFG_XPCS(0x8009, 0x21);
+			MAC_CFG_XPCS(0x800A, 0x719D);
+			MAC_CFG_XPCS(0x800B, 0x8E);
+			MAC_CFG_XPCS(0x800C, 0x4B59);
+			MAC_CFG_XPCS(0x800D, 0xE8);
+			MAC_CFG_XPCS(0x800E, 0x954D);
+			MAC_CFG_XPCS(0x800F, 0x7B);
+			MAC_CFG_XPCS(0x8048, 0x07F5);
+			MAC_CFG_XPCS(0x8049, 0x09);
+			MAC_CFG_XPCS(0x804A, 0x14DD);
+			MAC_CFG_XPCS(0x804B, 0xC2);
+			MAC_CFG_XPCS(0x804C, 0x4A9A);
+			MAC_CFG_XPCS(0x804D, 0x26);
+			MAC_CFG_XPCS(0x804E, 0x457B);
+			MAC_CFG_XPCS(0x804F, 0x66);
+			MAC_CFG_XPCS(0x8050, 0x24A0);
+			MAC_CFG_XPCS(0x8051, 0x76);
+			MAC_CFG_XPCS(0x8052, 0xC968);
+			MAC_CFG_XPCS(0x8053, 0xFB);
+			MAC_CFG_XPCS(0x8054, 0x6CFD);
+			MAC_CFG_XPCS(0x8055, 0x99);
+			MAC_CFG_XPCS(0x8056, 0x91B9);
+			MAC_CFG_XPCS(0x8057, 0x55);
+			MAC_CFG_XPCS(0x8058, 0xB95C);
+			MAC_CFG_XPCS(0x8059, 0xB2);
+			MAC_CFG_XPCS(0x805A, 0xF81A);
+			MAC_CFG_XPCS(0x805B, 0xBD);
+			MAC_CFG_XPCS(0x805C, 0xC783);
+			MAC_CFG_XPCS(0x805D, 0xCA);
+			MAC_CFG_XPCS(0x805E, 0x3635);
+			MAC_CFG_XPCS(0x805F, 0xCD);
+			MAC_CFG_XPCS(0x8060, 0x31C4);
+			MAC_CFG_XPCS(0x8061, 0x4C);
+			MAC_CFG_XPCS(0x8062, 0xD6AD);
+			MAC_CFG_XPCS(0x8063, 0xB7);
+			MAC_CFG_XPCS(0x8064, 0x665F);
+			MAC_CFG_XPCS(0x8065, 0x2A);
+			MAC_CFG_XPCS(0x8066, 0xF0C0);
+			MAC_CFG_XPCS(0x8067, 0xE5);
+			break;
+		default:
+			dev_err(hdev->dev,
+				"unknown NIC port %d speed %dMb/s, cannot configure MAC XPCS\n",
+				port, speed);
+			break;
+		}
+	}
+
+	switch (speed) {
+	case SPEED_10000:
+		MAC_CFG_MAC_CORE(0, 0xF0FF00);
+		MAC_CFG_MAC_CORE(0x1C, 0);
+		MAC_CFG_MAC_CORE(0x10, 0);
+		break;
+	case SPEED_25000:
+		MAC_CFG_MAC_CORE(0, 0xF0FF00);
+		MAC_CFG_MAC_CORE(0x18, 0x60F);
+		MAC_CFG_MAC_CORE(0x1C, 0);
+		MAC_CFG_MAC_CORE(0x10, 0);
+		break;
+	case SPEED_50000:
+		MAC_CFG_MAC_CORE(0x18, 0xFF);
+		MAC_CFG_MAC_CORE(0, 0xF0FFF0);
+		MAC_CFG_MAC_CORE(0x1C, 0);
+		MAC_CFG_XPCS91(0, 0x400);
+		MAC_CFG_XPCS91(0x8, 0x400);
+		MAC_CFG_XPCS91(0x10, 0x400);
+		MAC_CFG_XPCS91(0x18, 0x400);
+		break;
+	case SPEED_100000:
+		if (gaudi_nic->nic_macro->num_of_lanes == NIC_LANES_4) {
+			MAC_CFG_MAC_CORE(0, 0xF0FF00);
+			MAC_CFG_MAC_CORE(0x18, 0x0F);
+		} else {
+			MAC_CFG_MAC_CORE(0x18, 0xFF);
+		}
+		break;
+	default:
+		dev_err(hdev->dev,
+			"unknown NIC port %d speed %dMb/s, cannot configure MAC CORE\n",
+			port, speed);
+		break;
+	}
+}
+
+static int hw_config(struct gaudi_nic_device *gaudi_nic)
+{
+	u32 port = gaudi_nic->port, data_rate, speed = gaudi_nic->speed;
+	struct gaudi_device *gaudi = gaudi_nic->hdev->asic_specific;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u64 mac_addr = 0, tmr_addr;
+	int i;
+
+	for (i = 0 ; i < ETH_ALEN ; i++) {
+		mac_addr <<= 8;
+		mac_addr |= gaudi_nic->ndev->dev_addr[i];
+	}
+
+	switch (speed) {
+	case SPEED_10000:
+		data_rate = NIC_DR_10;
+		break;
+	case SPEED_25000:
+		data_rate = NIC_DR_25;
+		break;
+	case SPEED_50000:
+		data_rate = NIC_DR_50;
+		break;
+	case SPEED_100000:
+		if (gaudi_nic->nic_macro->num_of_lanes == NIC_LANES_4)
+			data_rate = NIC_DR_25;
+		else
+			data_rate = NIC_DR_50;
+		break;
+	default:
+		data_rate = NIC_DR_50;
+		dev_err(hdev->dev,
+			"unknown NIC port %d speed, continue with 50 GHz\n",
+			port);
+		break;
+	}
+
+	dev_dbg(hdev->dev, "NIC port %d, speed %d data rate %d\n",
+		port, speed, data_rate);
+
+	gaudi_nic->data_rate = data_rate;
+
+	/* if no need in macro configuration, do only port configuration */
+	if (gaudi_nic->do_macro_cfg) {
+		config_port_mac(gaudi_nic);
+		config_port_hw(gaudi_nic, mac_addr);
+	} else {
+		config_port_hw(gaudi_nic, mac_addr);
+		goto out;
+	}
+
+	/*
+	 * the following registers are shared between each pair of ports,
+	 * hence need to configure only once per NIC macro
+	 */
+	/* RXB Configuration */
+	NIC_MACRO_WREG32(mmNIC0_RXB_LBW_OFFSET_0, CFG_BASE & 0xFFFFFFFF);
+	NIC_MACRO_WREG32(mmNIC0_RXB_LBW_OFFSET_1, (CFG_BASE >> 32) & 0x3FFFF);
+	NIC_MACRO_WREG32(mmNIC0_RXB_ICRC_CFG, 0);
+	NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_31_0_MASK_0, 0xFFFFFFFF);
+	NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_31_0_MASK_1, 0xFFFFFFFF);
+	NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_31_0_MASK_2, 0xFFFFFFFF);
+	NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_31_0_MASK_3, 0xFFFFFFFF);
+	NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_47_32_MASK_0, 0xFFFF);
+	NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_47_32_MASK_1, 0xFFFF);
+	NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_47_32_MASK_2, 0xFFFF);
+	NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_47_32_MASK_3, 0xFFFF);
+	/* H/W WA for credit leakage */
+	NIC_MACRO_WREG32(mmNIC0_RXB_DROP_THRESHOLD_0, 0xB37 | (0xB37 << 13));
+	NIC_MACRO_WREG32(mmNIC0_RXB_DROP_THRESHOLD_1, 0xB37 | (0xB37 << 13));
+	NIC_MACRO_WREG32(mmNIC0_RXB_DROP_THRESHOLD_2, 0xB37 | (0xB37 << 13));
+	NIC_MACRO_WREG32(mmNIC0_RXB_DROP_THRESHOLD_3, 0xB37 | (0xB37 << 13));
+	NIC_MACRO_WREG32(mmNIC0_RXB_DROP_THRESHOLD_4, 0xB37 | (0xB37 << 13));
+	NIC_MACRO_WREG32(mmNIC0_RXB_DROP_THRESHOLD_5, 0xB37 | (0xB37 << 13));
+	NIC_MACRO_WREG32(mmNIC0_RXB_DROP_THRESHOLD_6, 0xB37 | (0xB37 << 13));
+	NIC_MACRO_WREG32(mmNIC0_RXB_DROP_THRESHOLD_7, 0xB37 | (0xB37 << 13));
+	NIC_MACRO_WREG32(mmNIC0_RXB_DROP_THRESHOLD_8, 0xB37 | (0xB37 << 13));
+	NIC_MACRO_WREG32(mmNIC0_RXB_DROP_THRESHOLD_9, 0xB37 | (0xB37 << 13));
+	NIC_MACRO_WREG32(mmNIC0_RXB_DROP_THRESHOLD_10, 0xB37 | (0xB37 << 13));
+	NIC_MACRO_WREG32(mmNIC0_RXB_DROP_THRESHOLD_11, 0xB37 | (0xB37 << 13));
+	NIC_MACRO_WREG32(mmNIC0_RXB_DROP_THRESHOLD_12, 0xB37 | (0xB37 << 13));
+	NIC_MACRO_WREG32(mmNIC0_RXB_DROP_THRESHOLD_13, 0xB37 | (0xB37 << 13));
+	NIC_MACRO_WREG32(mmNIC0_RXB_DROP_THRESHOLD_14, 0xB37 | (0xB37 << 13));
+	NIC_MACRO_WREG32(mmNIC0_RXB_DROP_THRESHOLD_15, 0xB37 | (0xB37 << 13));
+	NIC_MACRO_WREG32(mmNIC0_RXB_AXI_AXUSER_10_0_UNTRUST, 1);
+	NIC_MACRO_WREG32(mmNIC0_RXB_AXI_AXUSER_10_0_TRUST, 0x400);
+	NIC_MACRO_WREG32(mmNIC0_RXB_AXI_AXUSER_10_0_PRIV, 0x400);
+	NIC_MACRO_WREG32(mmNIC0_RXB_AXI_AXPROT_PRIV, 0);
+	NIC_MACRO_WREG32(mmNIC0_RXB_AXI_AXPROT_TRUST, 0);
+	NIC_MACRO_WREG32(mmNIC0_RXB_AXI_AXPROT_UNTRUST, 2);
+
+	/* MAC filtering */
+	NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_31_0_MASK_0, 0);
+	NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_31_0_MASK_1, 0);
+	NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_31_0_MASK_2, 0);
+	NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_31_0_MASK_3, 0);
+	NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_47_32_MASK_0, 0);
+	NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_47_32_MASK_1, 0);
+	NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_47_32_MASK_2, 0);
+	NIC_MACRO_WREG32(mmNIC0_RXB_TS_RC_MAC_47_32_MASK_3, 0);
+
+	/* Credits allocation - all dynamic */
+	/* H/W WA for credit leakage */
+	NIC_MACRO_WREG32(mmNIC0_RXB_MAX_DYNAMIC, 0xB36);
+	NIC_MACRO_WREG32(mmNIC0_RXB_MAX_STATIC_CREDITS_0, 0x41);
+	NIC_MACRO_WREG32(mmNIC0_RXB_MAX_STATIC_CREDITS_1, 0x41);
+	NIC_MACRO_WREG32(mmNIC0_RXB_MAX_STATIC_CREDITS_2, 0x41);
+	NIC_MACRO_WREG32(mmNIC0_RXB_MAX_STATIC_CREDITS_3, 0x41);
+	NIC_MACRO_WREG32(mmNIC0_RXB_MAX_STATIC_CREDITS_4, 0x41);
+	NIC_MACRO_WREG32(mmNIC0_RXB_MAX_STATIC_CREDITS_5, 0x41);
+	NIC_MACRO_WREG32(mmNIC0_RXB_MAX_STATIC_CREDITS_6, 0x41);
+	NIC_MACRO_WREG32(mmNIC0_RXB_MAX_STATIC_CREDITS_7, 0x41);
+	NIC_MACRO_WREG32(mmNIC0_RXB_MAX_STATIC_CREDITS_8, 0x41);
+	NIC_MACRO_WREG32(mmNIC0_RXB_MAX_STATIC_CREDITS_9, 0x41);
+	NIC_MACRO_WREG32(mmNIC0_RXB_MAX_STATIC_CREDITS_10, 0x41);
+	NIC_MACRO_WREG32(mmNIC0_RXB_MAX_STATIC_CREDITS_11, 0x41);
+	NIC_MACRO_WREG32(mmNIC0_RXB_MAX_STATIC_CREDITS_12, 0x41);
+	NIC_MACRO_WREG32(mmNIC0_RXB_MAX_STATIC_CREDITS_13, 0x41);
+	NIC_MACRO_WREG32(mmNIC0_RXB_MAX_STATIC_CREDITS_14, 0x41);
+	NIC_MACRO_WREG32(mmNIC0_RXB_MAX_STATIC_CREDITS_15, 0x41);
+
+	/* TMR Configuration */
+	tmr_addr = TMR_BASE_ADDR + gaudi_nic->nic_macro->idx * TMR_BASE_SIZE;
+
+	/* Clear timer FSM0 */
+	for (i = 0 ; i < NIC_HW_MAX_QP_NUM ; i++)
+		writeb(0, hdev->pcie_bar[HBM_BAR_ID] +
+			((tmr_addr + TMR_FSM0_OFFS + i) -
+				gaudi->hbm_bar_cur_addr));
+
+	/* Clear timer FSM1 */
+	for (i = 0 ; i < NIC_HW_MAX_QP_NUM ; i++)
+		writeb(0, hdev->pcie_bar[HBM_BAR_ID] +
+			((tmr_addr + TMR_FSM1_OFFS + i) -
+				gaudi->hbm_bar_cur_addr));
+
+	/* Timer free list */
+	for (i = 0 ; i < TMR_FREE_NUM_ENTRIES ; i++)
+		writel(TMR_GRANULARITY + i, hdev->pcie_bar[HBM_BAR_ID] +
+			((tmr_addr + TMR_FREE_OFFS + i * 4) -
+				gaudi->hbm_bar_cur_addr));
+
+	/* Perform read to flush the writes */
+	readq(hdev->pcie_bar[HBM_BAR_ID]);
+
+	NIC_MACRO_WREG32(mmNIC0_TMR_TMR_BASE_ADDRESS_49_18,
+				(tmr_addr + TMR_FIFO_OFFS) >> 18);
+	NIC_MACRO_WREG32(mmNIC0_TMR_TMR_BASE_ADDRESS_17_7,
+				((tmr_addr + TMR_FIFO_OFFS) >> 7) & 0x7FF);
+	NIC_MACRO_WREG32(mmNIC0_TMR_TMR_BASE_ADDRESS_FREE_LIST_49_32,
+				(tmr_addr + TMR_FREE_OFFS) >> 32);
+	NIC_MACRO_WREG32(mmNIC0_TMR_TMR_BASE_ADDRESS_FREE_LIST_31_0,
+				(tmr_addr + TMR_FREE_OFFS) & 0xFFFFFFFF);
+	NIC_MACRO_WREG32(mmNIC0_TMR_TMR_CACHE_BASE_ADDR_49_32,
+				(tmr_addr + TMR_FSM0_OFFS) >> 32);
+	NIC_MACRO_WREG32(mmNIC0_TMR_TMR_CACHE_BASE_ADDR_31_7,
+				((tmr_addr + TMR_FSM0_OFFS) >> 7) & 0xFFFFFF);
+
+	NIC_MACRO_WREG32(mmNIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_31_0, 0);
+	NIC_MACRO_WREG32(mmNIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_63_32, 0);
+	NIC_MACRO_WREG32(mmNIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_95_64, 0);
+	NIC_MACRO_WREG32(mmNIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_191_160, 1000);
+	NIC_MACRO_WREG32(mmNIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_216_192, 0);
+
+	for (i = 0 ; i < TMR_GRANULARITY ; i++) {
+		NIC_MACRO_WREG32(mmNIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_127_96, i);
+		NIC_MACRO_WREG32(mmNIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_159_128, i);
+		NIC_MACRO_WREG32(mmNIC0_TMR_TMR_SCHEDQ_UPDATE_FIFO, i);
+		NIC_MACRO_WREG32(mmNIC0_TMR_TMR_SCHEDQ_UPDATE_EN, 1);
+	}
+
+	NIC_MACRO_WREG32(mmNIC0_TMR_TMR_SCAN_TIMER_COMP_31_0, 10);
+	NIC_MACRO_WREG32(mmNIC0_TMR_TMR_TICK_WRAP, 500);
+	NIC_MACRO_WREG32(mmNIC0_TMR_TMR_LIST_MASK,
+			~(0xFFFFFFFF << (ilog2(TMR_FREE_NUM_ENTRIES) - 5)));
+	NIC_MACRO_WREG32(mmNIC0_TMR_TMR_PRODUCER_UPDATE, TMR_FREE_NUM_ENTRIES);
+	NIC_MACRO_WREG32(mmNIC0_TMR_TMR_PRODUCER_UPDATE_EN, 1);
+	NIC_MACRO_WREG32(mmNIC0_TMR_TMR_PRODUCER_UPDATE_EN, 0);
+	NIC_MACRO_WREG32(mmNIC0_TMR_TMR_LIST_MEM_READ_MASK, 0);
+	NIC_MACRO_WREG32(mmNIC0_TMR_TMR_PUSH_LOCK_EN, 1);
+	NIC_MACRO_WREG32(mmNIC0_TMR_TMR_TIMER_EN, 1);
+	NIC_MACRO_WREG32(mmNIC0_TMR_FREE_LIST_PUSH_MASK_EN, 0);
+
+out:
+	/* Perform read from the device to flush all configurations */
+	NIC_MACRO_RREG32(mmNIC0_TMR_TMR_TIMER_EN);
+
+	return 0;
+}
+
+static bool write_pkt_to_hw(struct gaudi_nic_device *gaudi_nic, u64 *data,
+				u64 size)
+{
+	u32 port = gaudi_nic->port, pi = gaudi_nic->tx_pi, diff, new_pi,
+		ci = gaudi_nic->tx_ci;
+	struct gaudi_device *gaudi = gaudi_nic->hdev->asic_specific;
+	u64 swq_addr, sb_base_address, swq_base_addr;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	struct sq_wqe swq;
+	u64 *swq_p;
+	int i;
+
+	swq_p = (u64 *) &swq;
+
+	if (pi >= ci)
+		diff = pi - ci;
+	else
+		diff = WQ_BUFFER_SIZE - ci + pi;
+
+	/* update CI once in a while */
+	if (diff > (WQ_BUFFER_SIZE >> 1))
+		gaudi_nic->tx_ci = ci = NIC_RREG32(mmNIC0_QPC0_REQ_RING0_CI);
+
+	new_pi = (pi + 1) & (WQ_BUFFER_SIZE - 1);
+	if (new_pi == ci)
+		return false;
+
+	gaudi_nic->tx_pi = new_pi;
+
+	sb_base_address = (SB_BASE_ADDR + port * SB_BASE_SIZE) +
+				pi * NIC_MAX_PKT_SIZE;
+	swq_base_addr = SWQ_BASE_ADDR + port * SWQ_BASE_SIZE;
+
+	/* Create SWQ */
+	memset(&swq, 0, sizeof(swq));
+	CFG_SQ_WQE_OPCODE(swq, WQE_LINEAR);
+	CFG_SQ_WQE_LOCAL_ADDRESS_31_0(swq, sb_base_address & 0xFFFFFFFF);
+	CFG_SQ_WQE_LOCAL_ADDRESS_49_32(swq, (sb_base_address >> 32) & 0x3FFFF);
+	CFG_SQ_WQE_SIZE(swq, size);
+
+	/* Copy packet to SB */
+	for (i = 0 ; i < size ; i++)
+		writeq(data[i], hdev->pcie_bar[HBM_BAR_ID] +
+			((sb_base_address + i * 8) - gaudi->hbm_bar_cur_addr));
+
+	/* Copy WQE to SWQ Buffer */
+	for (i = 0 ; i < (sizeof(swq) / sizeof(u64)) ; i++) {
+		swq_addr = swq_base_addr +
+				(pi * sizeof(struct sq_wqe) + i * 8);
+		writeq(swq_p[i], hdev->pcie_bar[HBM_BAR_ID] +
+				(swq_addr - gaudi->hbm_bar_cur_addr));
+	}
+
+	readq(hdev->pcie_bar[HBM_BAR_ID]);
+
+	/* Make sure we ring the doorbell after the data copying */
+	mb();
+
+	/* Doorbell push */
+	NIC_WREG32(mmNIC0_QPC0_SECURED_DOORBELL_PI, new_pi);
+	NIC_WREG32(mmNIC0_QPC0_SECURED_DOORBELL_QPN, 0x80000000 | RAW_QPN);
+
+	return true;
+}
+
+static enum eth_pkt_status get_pkt_from_hw(struct gaudi_nic_device *gaudi_nic,
+						u64 *ppkt_addr, u32 *ppkt_size,
+						u32 *pi)
+{
+	u64 pkt_addr, mem_addr = (u64) (uintptr_t) gaudi_nic->rx_mem_cpu;
+	u32 ci = gaudi_nic->rx_ci, ether_type, tpid, ipv4_len, ipv6_len,
+		pkt_size, hdr_size = ETH_HLEN, port = gaudi_nic->port;
+	enum eth_pkt_status pkt_status = ETH_PKT_OK;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	bool vlan_double_tag = false;
+	__be32 *data;
+	int idx;
+
+	/*
+	 * check if packet is available by reading the PI, but do it only if
+	 * needed as it is expensive
+	 */
+	if (*pi == ci) {
+		*pi = NIC_RREG32(mmNIC0_QPC0_RES_RING0_PI) & (NIC_RX_SIZE - 1);
+		if (*pi == ci)
+			return ETH_PKT_NONE;
+	}
+
+	pkt_addr = mem_addr + ci * NIC_MAX_PKT_SIZE;
+	data = (__be32 *) pkt_addr;
+
+	/* skip MAC header */
+	idx = (ETH_ALEN * 2) / 4;
+
+	/* handle VLAN tagging */
+	tpid = ntohl(data[idx++]) >> 16;
+	if (tpid == ETH_P_8021AD) {
+		/* skip VLAN double tagging */
+		tpid = ntohl(data[idx++]) >> 16;
+		vlan_double_tag = true;
+		hdr_size += 4;
+	}
+
+	if (tpid == ETH_P_8021Q) {
+		/* skip VLAN tagging */
+		ether_type = ntohl(data[idx++]) >> 16;
+		hdr_size += 4;
+	} else if (vlan_double_tag) {
+		dev_dbg_ratelimited(hdev->dev,
+					"Wrong VLAN TPID double tagging 0x%x\n",
+					tpid);
+		ether_type = UINT_MAX;
+	} else {
+		ether_type = tpid;
+	}
+
+	if (ether_type <= ETH_DATA_LEN) {
+		pkt_size = ether_type;
+	} else if (ether_type == ETH_P_ARP) {
+		pkt_size = hdr_size + NIC_ARP_PKT_SIZE;
+	} else if (ether_type == ETH_P_IP) {
+		ipv4_len = ntohl(data[idx]) >> 16;
+		pkt_size = hdr_size + ipv4_len;
+	} else if (ether_type == ETH_P_IPV6) {
+		ipv6_len = ntohl(data[idx]) & 0xFFFF;
+		pkt_size = hdr_size + ipv6_len + sizeof(struct ipv6hdr);
+	} else if ((ether_type == ETH_P_LLDP) ||
+			(ether_type == ETH_P_LOOPBACK)) {
+		pkt_size = hdr_size + ETH_DATA_LEN;
+	} else {
+		dev_dbg_ratelimited(hdev->dev,
+					"error, unsupported EtherType 0x%x, port %d\n",
+					ether_type, port);
+		pkt_status = ETH_PKT_DROP;
+		goto out;
+	}
+
+	if (pkt_size > NIC_MAX_PKT_SIZE) {
+		dev_dbg_ratelimited(hdev->dev,
+				"error, packet size %uB exceeds maximum of %uB, port %d\n",
+				pkt_size, NIC_MAX_PKT_SIZE, port);
+		pkt_status = ETH_PKT_DROP;
+		goto out;
+	}
+
+#if HL_NIC_DEBUG
+	dev_dbg_ratelimited(hdev->dev,
+				"port %d packet_size %d ether_type 0x%x\n",
+				gaudi_nic->port, pkt_size,
+				ether_type);
+#endif
+
+	*ppkt_addr = pkt_addr;
+	*ppkt_size = pkt_size;
+out:
+	gaudi_nic->rx_ci = (ci + 1) & (NIC_RX_SIZE - 1);
+
+	return pkt_status;
+}
+
+static int gaudi_nic_handle_rx_pkt(struct gaudi_nic_device *gaudi_nic,
+					int budget, u32 *last_pi)
+{
+	struct net_device_stats *stats = &gaudi_nic->ndev->stats;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 pkt_size, pi = gaudi_nic->rx_ci;
+	enum eth_pkt_status pkt_status;
+	int rc, pkt_count = 0;
+	struct sk_buff *skb;
+	u64 pkt_address;
+
+	if (!gaudi_nic->active)
+		return 0;
+
+	while (1) {
+		if (pkt_count >= budget || disabled_or_in_reset(gaudi_nic))
+			break;
+
+		pkt_status = get_pkt_from_hw(gaudi_nic, &pkt_address, &pkt_size,
+						&pi);
+
+		if (pkt_status == ETH_PKT_NONE)
+			break;
+
+		pkt_count++;
+
+		if (pkt_status == ETH_PKT_DROP) {
+			stats->rx_dropped++;
+			continue;
+		}
+
+		if (hdev->nic_rx_poll)
+			skb = netdev_alloc_skb_ip_align(gaudi_nic->ndev,
+							pkt_size);
+		else
+			skb = napi_alloc_skb(&gaudi_nic->napi, pkt_size);
+
+		if (!skb)
+			break;
+
+		skb_copy_to_linear_data(skb, (void *) pkt_address, pkt_size);
+		skb_put(skb, pkt_size);
+		skb->protocol = eth_type_trans(skb, gaudi_nic->ndev);
+
+#if HL_NIC_DEBUG
+		dev_dbg_ratelimited(hdev->dev,
+					"port: %d, addr: 0x%llx, size: %d, rx_ci: %d\n",
+					gaudi_nic->port, pkt_address, pkt_size,
+					gaudi_nic->rx_ci);
+#endif
+
+		rc = netif_receive_skb(skb);
+		if (rc == NET_RX_SUCCESS) {
+			stats->rx_packets++;
+			stats->rx_bytes += pkt_size;
+			pkt_count++;
+		} else {
+			stats->rx_dropped++;
+		}
+	}
+
+	*last_pi = pi;
+
+	return pkt_count;
+}
+
+static void rx_pkt_poll(struct work_struct *work)
+{
+	struct gaudi_nic_device *gaudi_nic = container_of(work,
+							struct gaudi_nic_device,
+							rx_poll_work.work);
+	u32 ignore;
+
+	gaudi_nic_handle_rx_pkt(gaudi_nic, NIC_NAPI_MAX_RX_BUDGET, &ignore);
+	schedule_delayed_work(&gaudi_nic->rx_poll_work, msecs_to_jiffies(1));
+}
+
+static void gaudi_nic_reenable_rx_irq(struct gaudi_nic_device *gaudi_nic,
+								u32 last_pi)
+{
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 new_pi;
+
+	NIC_WREG32(mmNIC0_QPC0_INTERRUPT_CLR, 0xFFFF);
+
+	if (gaudi_nic->active) {
+		/*
+		 * packets can still arrive when IRQ is disabled. Hence if the
+		 * PI has changed since we finished to handle the Rx ring, it
+		 * means we have more packets to process. Hence we generate an
+		 * IRQ to handle them.
+		 */
+		new_pi = NIC_RREG32(mmNIC0_QPC0_RES_RING0_PI) &
+				(NIC_RX_SIZE - 1);
+		if (last_pi != new_pi)
+			WREG32(gaudi_nic->rx_msi_addr, 1);
+	}
+}
+
+static int napi_clean(struct napi_struct *napi, int budget)
+{
+	struct gaudi_nic_device *gaudi_nic =
+			container_of(napi, struct gaudi_nic_device, napi);
+	int work_done;
+	u32 last_pi;
+
+	work_done = gaudi_nic_handle_rx_pkt(gaudi_nic, budget, &last_pi);
+
+	/* If budget not fully consumed, exit the polling mode */
+	if (work_done < budget) {
+		napi_complete_done(napi, work_done);
+		gaudi_nic_reenable_rx_irq(gaudi_nic, last_pi);
+	}
+
+	return work_done;
+}
+
+irqreturn_t gaudi_nic_rx_irq_handler(int irq, void *arg)
+{
+	struct gaudi_nic_device *gaudi_nic = arg;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	struct gaudi_device *gaudi;
+
+	gaudi = gaudi_nic->hdev->asic_specific;
+
+	if (!hdev->nic_rx_poll)
+		gaudi->nic_handle_rx(gaudi_nic);
+
+	return IRQ_HANDLED;
+}
+
+static void set_port_status(struct gaudi_nic_device *gaudi_nic, bool active)
+{
+	if (gaudi_nic->active == active)
+		return;
+
+	if (active) {
+		netif_wake_queue(gaudi_nic->ndev);
+		netif_start_queue(gaudi_nic->ndev);
+		netif_carrier_on(gaudi_nic->ndev);
+		gaudi_nic->active = true;
+	} else {
+		netif_stop_queue(gaudi_nic->ndev);
+		netif_carrier_off(gaudi_nic->ndev);
+		gaudi_nic->active = false;
+	}
+}
+
+static void port_reset_state(struct gaudi_nic_device *gaudi_nic)
+{
+	kfifo_reset(&gaudi_nic->pcs_fail_fifo);
+	gaudi_nic->pcs_link = false;
+	gaudi_nic->auto_neg_resolved = false;
+	gaudi_nic->phy_fw_tuned = false;
+	gaudi_nic->retry_cnt = 0;
+	gaudi_nic->pcs_fail_cnt = 0;
+	gaudi_nic->pcs_local_fault_cnt = 0;
+	gaudi_nic->pcs_remote_fault_cnt = 0;
+	gaudi_nic->correctable_errors_cnt = 0;
+	gaudi_nic->uncorrectable_errors_cnt = 0;
+}
+
+static int _gaudi_nic_sw_init(struct gaudi_nic_device *gaudi_nic)
+{
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 port = gaudi_nic->port;
+	int rc;
+
+	gaudi_nic->rx_mem_size = NIC_RX_SIZE * NIC_MAX_PKT_SIZE;
+
+	gaudi_nic->rx_mem_cpu = hdev->asic_funcs->asic_dma_alloc_coherent(hdev,
+							gaudi_nic->rx_mem_size,
+							&gaudi_nic->rx_mem_dma,
+							GFP_KERNEL);
+	if (!gaudi_nic->rx_mem_cpu) {
+		dev_err(hdev->dev, "Failed to allocate Rx memory, port: %d\n",
+			port);
+		return -ENOMEM;
+	}
+
+	gaudi_nic->cq_mem_size = CQ_PORT_BUF_SIZE;
+
+	if (!IS_ALIGNED(gaudi_nic->cq_mem_size, PAGE_SIZE_4KB)) {
+		dev_err(hdev->dev,
+			"NIC CQ port buffer size should be aligned to 4KB, port: %d\n",
+			port);
+		rc = -EFAULT;
+		goto free_rx;
+	}
+
+	gaudi_nic->cq_mem_cpu = hdev->asic_funcs->asic_dma_alloc_coherent(hdev,
+							gaudi_nic->cq_mem_size,
+							&gaudi_nic->cq_mem_dma,
+							GFP_KERNEL);
+	if (!gaudi_nic->cq_mem_cpu) {
+		dev_err(hdev->dev, "Failed to allocate CQ memory, port: %d\n",
+			port);
+		rc = -ENOMEM;
+		goto free_rx;
+	}
+
+	gaudi_nic->qp_err_mem_size = QP_ERR_BUF_SIZE;
+
+	gaudi_nic->qp_err_mem_cpu = hdev->asic_funcs->asic_dma_alloc_coherent(
+						hdev,
+						gaudi_nic->qp_err_mem_size,
+						&gaudi_nic->qp_err_mem_dma,
+						GFP_KERNEL);
+	if (!gaudi_nic->qp_err_mem_cpu) {
+		dev_err(hdev->dev,
+			"Failed to allocate QP error memory, port: %d\n",
+			port);
+		rc = -ENOMEM;
+		goto free_cq;
+	}
+
+	mutex_init(&gaudi_nic->user_wq_lock);
+
+	mutex_init(&gaudi_nic->idr_lock);
+	idr_init(&gaudi_nic->qp_ids);
+
+	return 0;
+
+free_cq:
+	hdev->asic_funcs->asic_dma_free_coherent(hdev, gaudi_nic->cq_mem_size,
+							gaudi_nic->cq_mem_cpu,
+							gaudi_nic->cq_mem_dma);
+free_rx:
+	hdev->asic_funcs->asic_dma_free_coherent(hdev, gaudi_nic->rx_mem_size,
+							gaudi_nic->rx_mem_cpu,
+							gaudi_nic->rx_mem_dma);
+
+	return rc;
+}
+
+static void _gaudi_nic_sw_fini(struct gaudi_nic_device *gaudi_nic)
+{
+	struct hl_device *hdev = gaudi_nic->hdev;
+
+	idr_destroy(&gaudi_nic->qp_ids);
+	mutex_destroy(&gaudi_nic->idr_lock);
+
+	mutex_destroy(&gaudi_nic->user_wq_lock);
+
+	hdev->asic_funcs->asic_dma_free_coherent(hdev,
+						gaudi_nic->qp_err_mem_size,
+						gaudi_nic->qp_err_mem_cpu,
+						gaudi_nic->qp_err_mem_dma);
+
+	hdev->asic_funcs->asic_dma_free_coherent(hdev, gaudi_nic->cq_mem_size,
+							gaudi_nic->cq_mem_cpu,
+							gaudi_nic->cq_mem_dma);
+
+	hdev->asic_funcs->asic_dma_free_coherent(hdev, gaudi_nic->rx_mem_size,
+							gaudi_nic->rx_mem_cpu,
+							gaudi_nic->rx_mem_dma);
+}
+
+int gaudi_nic_sw_init(struct hl_device *hdev)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct gaudi_nic_device *gaudi_nic;
+	int rc, i, init_cnt = 0;
+
+	/* At this stage, we don't know how many links we have, so we must
+	 * allocate for the maximum number of links (and also free all of them
+	 * in sw_fini
+	 */
+	for (i = 0 ; i < NIC_NUMBER_OF_PORTS ; i++, init_cnt++) {
+		gaudi_nic = &gaudi->nic_devices[i];
+		gaudi_nic->hdev = hdev;
+		gaudi_nic->port = i;
+
+		rc = _gaudi_nic_sw_init(gaudi_nic);
+		if (rc) {
+			dev_err(hdev->dev,
+				"NIC S/W init failed, port: %d, rc: %d\n", i,
+				rc);
+			goto err;
+		}
+	}
+
+	mutex_init(&gaudi->nic_cq_user_lock);
+	mutex_init(&gaudi->nic_qp_err_lock);
+
+	return 0;
+
+err:
+	for (i = 0 ; i < init_cnt ; i++)
+		_gaudi_nic_sw_fini(&gaudi->nic_devices[i]);
+
+	return rc;
+}
+
+void gaudi_nic_sw_fini(struct hl_device *hdev)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	int i;
+
+	mutex_destroy(&gaudi->nic_qp_err_lock);
+	mutex_destroy(&gaudi->nic_cq_user_lock);
+
+	for (i = 0 ; i < NIC_NUMBER_OF_PORTS ; i++)
+		_gaudi_nic_sw_fini(&gaudi->nic_devices[i]);
+}
+
+
+/* used for physically contiguous memory only */
+static int map_nic_mem(struct hl_device *hdev, u64 va, dma_addr_t pa, u32 size)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct hl_ctx *ctx = hdev->kernel_ctx;
+	s64 off;
+	int rc;
+
+	if (!(gaudi->hw_cap_initialized & HW_CAP_MMU))
+		return 0;
+
+	mutex_lock(&ctx->mmu_lock);
+
+	for (off = 0 ; off < size ; off += PAGE_SIZE_4KB) {
+		rc = hl_mmu_map(ctx, va + off, pa + off, PAGE_SIZE_4KB,
+				(off + PAGE_SIZE_4KB) >= size);
+		if (rc) {
+			dev_err(hdev->dev,
+				"Map failed for va 0x%llx to pa 0x%llx\n",
+				va + off, pa + off);
+			goto unmap;
+		}
+	}
+
+	hdev->asic_funcs->mmu_invalidate_cache(hdev, false, 0);
+
+	mutex_unlock(&ctx->mmu_lock);
+
+	return 0;
+
+unmap:
+	for (; off >= 0 ; off -= PAGE_SIZE_4KB)
+		if (hl_mmu_unmap(ctx, va + off, PAGE_SIZE_4KB,
+					(off - (s32) PAGE_SIZE_4KB) < 0))
+			dev_warn_ratelimited(hdev->dev,
+					"failed to unmap va 0x%llx\n",
+					va + off);
+
+	hdev->asic_funcs->mmu_invalidate_cache(hdev, true, 0);
+
+	mutex_unlock(&ctx->mmu_lock);
+
+	return rc;
+}
+
+static void unmap_nic_mem(struct hl_device *hdev, u64 va, u32 size)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct hl_ctx *ctx = hdev->kernel_ctx;
+	s64 off;
+
+	if (!(gaudi->hw_cap_initialized & HW_CAP_MMU))
+		return;
+
+	mutex_lock(&ctx->mmu_lock);
+
+	for (off = 0 ; off < size ; off += PAGE_SIZE_4KB)
+		if (hl_mmu_unmap(ctx, va + off, PAGE_SIZE_4KB,
+				       (off + PAGE_SIZE_4KB) >= size))
+			dev_warn_ratelimited(hdev->dev,
+					"Failed to unmap va 0x%llx\n",
+					va + off);
+
+	hdev->asic_funcs->mmu_invalidate_cache(hdev, true, 0);
+
+	mutex_unlock(&ctx->mmu_lock);
+}
+
+static int map_cq_mem(struct gaudi_nic_device *gaudi_nic)
+{
+	struct gaudi_device *gaudi = gaudi_nic->hdev->asic_specific;
+	struct hl_device *hdev = gaudi_nic->hdev;
+
+	if (!(gaudi->hw_cap_initialized & HW_CAP_MMU)) {
+		gaudi_nic->cq_mem_device_va = gaudi_nic->cq_mem_dma;
+		return 0;
+	}
+
+	gaudi_nic->cq_mem_device_va = CQ_VIRTUAL_ADDRESS +
+				gaudi_nic->port * gaudi_nic->cq_mem_size;
+
+	return map_nic_mem(hdev, gaudi_nic->cq_mem_device_va,
+				gaudi_nic->cq_mem_dma, gaudi_nic->cq_mem_size);
+}
+
+static void unmap_cq_mem(struct gaudi_nic_device *gaudi_nic)
+{
+	struct gaudi_device *gaudi = gaudi_nic->hdev->asic_specific;
+	struct hl_device *hdev = gaudi_nic->hdev;
+
+	if (!(gaudi->hw_cap_initialized & HW_CAP_MMU))
+		return;
+
+	unmap_nic_mem(hdev, gaudi_nic->cq_mem_device_va,
+			gaudi_nic->cq_mem_size);
+}
+
+static void mac_channels_init(struct gaudi_nic_device *gaudi_nic)
+{
+	struct gaudi_nic_macro *nic_macro = gaudi_nic->nic_macro;
+	u32 port = gaudi_nic->port;
+
+	if (gaudi_nic->auto_neg_enable) {
+		if (gaudi_nic->speed == SPEED_100000) {
+			if (nic_macro->num_of_lanes == NIC_LANES_4) {
+				gaudi_nic->power_up_mask = 0x1;
+				gaudi_nic->fw_tuning_mask = 0xF;
+			} else {
+				gaudi_nic->power_up_mask =
+							(port & 1) ? 0xC : 0x3;
+				gaudi_nic->fw_tuning_mask =
+							(port & 1) ? 0xC : 0x3;
+				gaudi_nic->auto_neg_mask =
+							(port & 1) ? 0x4 : 0x1;
+			}
+		} else {
+			gaudi_nic->fw_tuning_mask = gaudi_nic->power_up_mask =
+				(port & 1) ? 0xC : 0x3;
+		}
+	} else {
+		if (nic_macro->num_of_lanes == NIC_LANES_2)
+			gaudi_nic->power_up_mask = (port & 1) ? 0xC : 0x3;
+		else
+			/*
+			 * in the special mode of 100000Mb/s with 4 lanes, only
+			 * the even port should be up and should configure all
+			 * the lanes
+			 */
+			gaudi_nic->power_up_mask = 0xF;
+
+		gaudi_nic->fw_tuning_mask = gaudi_nic->power_up_mask;
+	}
+}
+
+static int port_open(struct gaudi_nic_device *gaudi_nic)
+{
+	struct gaudi_device *gaudi = gaudi_nic->hdev->asic_specific;
+	u32 port = gaudi_nic->port, pcs_fifo_size;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	char cq_wq_name[15] = {0};
+	int rc, rx_irq = 0;
+
+	if (gaudi_nic->port_open)
+		return 0;
+
+	/*
+	 * Temporary WA until DevOps starts to use nic_mac_loopback properly by
+	 * writing a bitmask rather than a boolean (SW-15223).
+	 * When they implement that, the following code should be used:
+	 * !!(gaudi->nic_mac_loopback_mask & BIT(port))
+	 */
+	gaudi_nic->mac_loopback = !!gaudi->nic_mac_loopback;
+
+	gaudi_nic->auto_neg_enable = !!(hdev->nic_auto_neg_mask & BIT(port));
+	mac_channels_init(gaudi_nic);
+
+	pcs_fifo_size = gaudi->nic_pcs_fail_threshold * sizeof(ktime_t);
+	if (!is_power_of_2(pcs_fifo_size)) {
+		dev_err(hdev->dev,
+			"PCS fifo size must be a power of 2, port: %d\n", port);
+		return -EFAULT;
+	}
+
+	rc = kfifo_alloc(&gaudi_nic->pcs_fail_fifo, pcs_fifo_size, GFP_KERNEL);
+	if (rc) {
+		dev_err(hdev->dev, "PCS fifo alloc failed, port: %d\n", port);
+		return rc;
+	}
+
+	/*
+	 * Workaround for H3 #HW-2061 bug.
+	 * MMU bypass cannot be set to the NIC CQ. But since it uses ASID 0, we
+	 * solve it by mapping the CQ buffer.
+	 */
+	rc = map_cq_mem(gaudi_nic);
+	if (rc) {
+		dev_err(hdev->dev, "Failed to map NIC CQ buffer, port: %d\n",
+			port);
+		goto pcs_fifo_free;
+	}
+
+	memset(gaudi_nic->rx_mem_cpu, 0, gaudi_nic->rx_mem_size);
+	memset(gaudi_nic->cq_mem_cpu, 0, gaudi_nic->cq_mem_size);
+
+	snprintf(cq_wq_name, sizeof(cq_wq_name) - 1, "nic%d-cq",
+			gaudi_nic->port);
+
+	/*
+	 * Use only one thread because cq_irq_work() should not be executed
+	 * concurrently for the same port.
+	 */
+	gaudi_nic->cq_wq = create_singlethread_workqueue(cq_wq_name);
+	if (!gaudi_nic->cq_wq) {
+		dev_err(hdev->dev, "Failed to create CQ WQ, port: %d, %d\n",
+			port, rc);
+		goto cq_unmap;
+	}
+
+	if ((hdev->pdev) && (gaudi->multi_msi_mode)) {
+		rx_irq = pci_irq_vector(hdev->pdev, RX_MSI_IDX + port);
+
+		rc = request_irq(rx_irq, gaudi_nic_rx_irq_handler, 0,
+					gaudi_nic->ndev->name,
+					gaudi_nic);
+		if (rc) {
+			dev_err(hdev->dev,
+				"Failed to request Rx IRQ %d, port: %d, %d\n",
+				rx_irq, port, rc);
+			goto cq_wq_free;
+		}
+	}
+
+	gaudi_nic->rx_ci = gaudi_nic->tx_pi = gaudi_nic->tx_ci =
+		gaudi_nic->cq_ci = gaudi_nic->last_cqe_cnt = 0;
+
+	gaudi_nic->cq_delay = usecs_to_jiffies(1);
+	gaudi_nic->cq_delay_idle = msecs_to_jiffies(1);
+
+	/* after hw_config(), interrupts may arrive */
+	rc = hw_config(gaudi_nic);
+	if (rc) {
+		dev_err(hdev->dev, "Failed to configure NIC H/W, port: %d, %d",
+					port, rc);
+		goto rx_irq_free;
+	}
+
+	eth_start_stop(gaudi_nic, true);
+
+	if (hdev->nic_rx_poll) {
+		/*
+		 * init the delayed work here to support on the fly switch
+		 * between NAPI and polling mode.
+		 */
+		INIT_DELAYED_WORK(&gaudi_nic->rx_poll_work, rx_pkt_poll);
+		schedule_delayed_work(&gaudi_nic->rx_poll_work,
+					msecs_to_jiffies(1));
+	} else {
+		napi_enable(&gaudi_nic->napi);
+	}
+
+	set_port_status(gaudi_nic, true);
+
+	gaudi_nic->port_open = true;
+
+	return 0;
+
+rx_irq_free:
+	if ((hdev->pdev) && (gaudi->multi_msi_mode)) {
+		synchronize_irq(rx_irq);
+		free_irq(rx_irq, gaudi_nic);
+	}
+cq_wq_free:
+	destroy_workqueue(gaudi_nic->cq_wq);
+cq_unmap:
+	unmap_cq_mem(gaudi_nic);
+pcs_fifo_free:
+	kfifo_free(&gaudi_nic->pcs_fail_fifo);
+
+	return rc;
+}
+
+static void port_open_work(struct work_struct *work)
+{
+	struct gaudi_nic_device *gaudi_nic = container_of(work,
+							struct gaudi_nic_device,
+							port_open_work.work);
+	struct hl_device *hdev = gaudi_nic->hdev;
+	int rc;
+
+	rc = port_open(gaudi_nic);
+	if (rc)
+		dev_err(hdev->dev, "Failed to init NIC H/W, port: %d\n",
+			gaudi_nic->port);
+
+	atomic_set(&gaudi_nic->in_reset, 0);
+}
+
+static void port_close(struct gaudi_nic_device *gaudi_nic)
+{
+	struct gaudi_device *gaudi = gaudi_nic->hdev->asic_specific;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 port = gaudi_nic->port;
+	int irq;
+
+	cancel_delayed_work_sync(&gaudi_nic->port_open_work);
+
+	if (!gaudi_nic->port_open)
+		return;
+
+	gaudi_nic->port_open = false;
+	gaudi_nic->active = false;
+
+	/* Print if not in hard reset flow e.g. from ifconfig */
+	if (gaudi_nic->pcs_link && !hdev->hard_reset_pending)
+		dev_info(hdev->dev, "port %d was closed\n", port);
+
+	port_reset_state(gaudi_nic);
+
+	kfifo_free(&gaudi_nic->pcs_fail_fifo);
+
+	/* disable Tx in S/W */
+	netif_stop_queue(gaudi_nic->ndev);
+
+	/* disable Rx/Tx in H/W */
+	eth_start_stop(gaudi_nic, false);
+
+	if (hdev->nic_rx_poll) {
+		cancel_delayed_work_sync(&gaudi_nic->rx_poll_work);
+	} else {
+		napi_synchronize(&gaudi_nic->napi);
+		napi_disable(&gaudi_nic->napi);
+	}
+
+	/* disable Rx in S/W */
+	if (hdev->pdev) {
+		if (gaudi->multi_msi_mode) {
+			irq = pci_irq_vector(hdev->pdev, RX_MSI_IDX + port);
+			synchronize_irq(irq);
+			free_irq(irq, gaudi_nic);
+		} else {
+			irq = pci_irq_vector(hdev->pdev, 0);
+			synchronize_irq(irq);
+		}
+	}
+
+	netif_carrier_off(gaudi_nic->ndev);
+
+	flush_workqueue(gaudi_nic->cq_wq);
+	destroy_workqueue(gaudi_nic->cq_wq);
+
+	unmap_cq_mem(gaudi_nic);
+}
+
+int gaudi_nic_port_reset(struct gaudi_nic_device *gaudi_nic)
+{
+	port_close(gaudi_nic);
+	return port_open(gaudi_nic);
+}
+
+static int gaudi_nic_open(struct net_device *netdev)
+{
+	struct gaudi_nic_device **ptr = netdev_priv(netdev);
+	struct gaudi_nic_device *gaudi_nic = *ptr;
+	struct hl_device *hdev = gaudi_nic->hdev;
+
+	if (gaudi_nic->enabled)
+		return 0;
+
+	if (atomic_cmpxchg(&gaudi_nic->in_reset, 0, 1)) {
+		dev_err(hdev->dev, "port %d is in reset, can't open it\n",
+			gaudi_nic->port);
+		return -EBUSY;
+	}
+
+	netif_carrier_off(netdev);
+
+	/* in_reset will be set to 0 in port_open_work() */
+	INIT_DELAYED_WORK(&gaudi_nic->port_open_work, port_open_work);
+	schedule_delayed_work(&gaudi_nic->port_open_work, msecs_to_jiffies(1));
+
+	gaudi_nic->enabled = true;
+
+	return 0;
+}
+
+static int gaudi_nic_close(struct net_device *netdev)
+{
+	struct gaudi_nic_device **ptr = netdev_priv(netdev);
+	struct gaudi_nic_device *gaudi_nic = *ptr;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	struct gaudi_device *gaudi;
+
+	gaudi = hdev->asic_specific;
+
+	if (!gaudi_nic->enabled)
+		return 0;
+
+	if (atomic_cmpxchg(&gaudi_nic->in_reset, 0, 1)) {
+		if (!gaudi->nic_in_teardown)
+			dev_err(hdev->dev,
+				"port %d is in reset, can't close it\n",
+				gaudi_nic->port);
+		return -EBUSY;
+	}
+
+	/*
+	 * this function may be called from 'ifconfig <nic_name> down', hence
+	 * the cleanup
+	 */
+	port_close(gaudi_nic);
+
+	gaudi_nic->enabled = false;
+
+	atomic_set(&gaudi_nic->in_reset, 0);
+
+	return 0;
+}
+
+netdev_tx_t gaudi_nic_handle_tx_pkt(struct gaudi_nic_device *gaudi_nic,
+					struct sk_buff *skb)
+{
+	struct net_device_stats *stats = &gaudi_nic->ndev->stats;
+	bool pkt_sent;
+
+	if (!gaudi_nic->active || gaudi_nic->mac_loopback)
+		return NETDEV_TX_OK;
+
+	if (disabled_or_in_reset(gaudi_nic))
+		return NETDEV_TX_BUSY;
+
+	if (skb->len <= 0) {
+		dev_kfree_skb_any(skb);
+		return NETDEV_TX_OK;
+	}
+
+#if HL_NIC_DEBUG
+	{
+		struct hl_device *hdev = gaudi_nic->hdev;
+
+		dev_dbg_ratelimited(hdev->dev,
+			"port: %d, addr: 0x%p, size: %d, tx_pi: %d, tx_ci: %d\n",
+			gaudi_nic->port, skb->data, skb->len,
+			gaudi_nic->tx_pi, gaudi_nic->tx_ci);
+	}
+#endif
+
+	pkt_sent = write_pkt_to_hw(gaudi_nic, (u64 *) skb->data, skb->len);
+	if (pkt_sent) {
+		stats->tx_packets++;
+		stats->tx_bytes += skb->len;
+	}
+
+	dev_kfree_skb_any(skb);
+
+	return NETDEV_TX_OK;
+}
+
+static netdev_tx_t gaudi_nic_xmit_frame(struct sk_buff *skb,
+					struct net_device *netdev)
+{
+	struct gaudi_nic_device **ptr = netdev_priv(netdev);
+	struct gaudi_nic_device *gaudi_nic = *ptr;
+	struct gaudi_device *gaudi;
+
+	gaudi = gaudi_nic->hdev->asic_specific;
+
+	return (netdev_tx_t) gaudi->nic_handle_tx(gaudi_nic, skb);
+}
+
+static int gaudi_nic_change_mtu(struct net_device *netdev, int new_mtu)
+{
+	struct gaudi_nic_device **ptr = netdev_priv(netdev);
+	struct gaudi_nic_device *gaudi_nic = *ptr;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 port = gaudi_nic->port;
+	int rc;
+
+#ifndef _HAS_MIN_MAX_MTU
+	if (new_mtu < (ETH_ZLEN + ETH_FCS_LEN + VLAN_HLEN) ||
+			new_mtu > NIC_MAX_MTU)
+		return -EOPNOTSUPP;
+#endif
+
+	if (atomic_cmpxchg(&gaudi_nic->in_reset, 0, 1)) {
+		dev_err(hdev->dev, "port %d is in reset, can't change MTU",
+			port);
+		return -EBUSY;
+	}
+
+	if (gaudi_nic->enabled) {
+		port_close(gaudi_nic);
+		netdev->mtu = new_mtu;
+		rc = port_open(gaudi_nic);
+		if (rc)
+			dev_err(hdev->dev,
+				"Failed to reinit port %d for MTU change, rc %d",
+				port, rc);
+	}
+
+	atomic_set(&gaudi_nic->in_reset, 0);
+
+	return 0;
+}
+
+static const struct net_device_ops gaudi_nic_netdev_ops = {
+	.ndo_open		= gaudi_nic_open,
+	.ndo_stop		= gaudi_nic_close,
+	.ndo_start_xmit		= gaudi_nic_xmit_frame,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_change_mtu		= gaudi_nic_change_mtu,
+};
+
+static int port_register(struct hl_device *hdev, int port)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct gaudi_nic_device *gaudi_nic;
+	struct gaudi_nic_device **ptr;
+	struct net_device *ndev;
+	int rc;
+
+	gaudi_nic = &gaudi->nic_devices[port];
+
+	ndev = alloc_etherdev(sizeof(struct gaudi_nic_device *));
+	if (!ndev) {
+		dev_err(hdev->dev, "netdevice %d alloc failed\n", port);
+		return -ENOMEM;
+	}
+
+	gaudi_nic->ndev = ndev;
+	gaudi_nic->speed = hdev->pldm ? SPEED_50000 : SPEED_100000;
+	gaudi_nic->nic_macro = &gaudi->nic_macros[port >> 1];
+
+	if (gaudi_nic->speed != SPEED_100000 &&
+		gaudi_nic->nic_macro->num_of_lanes == NIC_LANES_4) {
+		dev_err(hdev->dev,
+			"NIC %d with 4 lanes should be used only with speed of 100000Mb/s\n",
+			port);
+		rc = -EFAULT;
+		goto netdev_free;
+	}
+
+	if (gaudi_nic->speed == SPEED_100000 &&
+			gaudi_nic->nic_macro->num_of_lanes == NIC_LANES_4 &&
+			(port & 1)) {
+		dev_err(hdev->dev,
+			"only even NIC ports should be up for speed of 100000Mb/s with 4 lanes\n");
+		rc = -EFAULT;
+		goto netdev_free;
+	}
+
+	gaudi_nic->pfc_enable = true;
+
+	SET_NETDEV_DEV(ndev, hdev->pdev ? &hdev->pdev->dev : NULL);
+	ptr = netdev_priv(ndev);
+	*ptr = gaudi_nic;
+
+	/* this is necessary for creating multiple NICs by the same driver */
+	ndev->dev_port = port;
+
+	ndev->netdev_ops = &gaudi_nic_netdev_ops;
+	ndev->watchdog_timeo = NIC_TX_TIMEOUT;
+	ndev->min_mtu = ETH_MIN_MTU;
+	ndev->max_mtu = NIC_MAX_MTU;
+
+	netif_napi_add(ndev, &gaudi_nic->napi, napi_clean,
+			NIC_NAPI_MAX_RX_BUDGET);
+
+	ether_addr_copy(ndev->dev_addr,
+		hdev->asic_prop.cpucp_nic_info.mac_addrs[port].mac_addr);
+
+	if (register_netdev(ndev)) {
+		dev_err(hdev->dev,
+			"Could not register netdevice, port: %d\n", port);
+		rc = -EFAULT;
+		goto netdev_free;
+	}
+
+	netif_carrier_off(ndev);
+
+	return 0;
+
+netdev_free:
+	free_netdev(ndev);
+	gaudi_nic->ndev = NULL;
+
+	return rc;
+}
+
+static void port_unregister(struct gaudi_nic_device *gaudi_nic)
+{
+	unregister_netdev(gaudi_nic->ndev);
+
+	free_netdev(gaudi_nic->ndev);
+	gaudi_nic->ndev = NULL;
+}
+
+irqreturn_t gaudi_nic_cq_irq_handler(int irq, void *arg)
+{
+	return IRQ_HANDLED;
+}
+
+/**
+ * gaudi_nic_ports_init() - initialize NIC ports.
+ * @hdev: habanalabs device structure.
+ *
+ * Allocate and initialize the NIC ports.
+ *
+ * Return: 0 for success, non-zero for failure.
+ */
+int gaudi_nic_ports_init(struct hl_device *hdev)
+{
+	struct cpucp_nic_info *nic_info = &hdev->asic_prop.cpucp_nic_info;
+	struct cpucp_info *cpucp_info = &hdev->asic_prop.cpucp_info;
+	struct cpucp_mac_addr *mac_arr = nic_info->mac_addrs;
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	int rc, i, nics_init = 0, cq_irq = 0;
+	bool read_card_location = false;
+	u8 mac[ETH_ALEN];
+	s32 *taps;
+
+	if (!hdev->nic_ports_mask)
+		return 0;
+
+	if (NIC_DRV_END_ADDR - NIC_DRV_BASE_ADDR > NIC_DRV_SIZE) {
+		dev_err(hdev->dev,
+			"DRAM allocation for NIC shouldn't exceed %dMB\n",
+			NIC_DRV_SIZE / 1024 / 1024);
+		return -ENOMEM;
+	}
+
+	if (TMR_FSM_SIZE + TMR_FREE_SIZE + TMR_FIFO_SIZE +
+			TMR_FIFO_STATIC_SIZE >
+		TMR_FSM_ENGINE_OFFS) {
+		dev_err(hdev->dev,
+			"NIC TMR data shouldn't be bigger than %dMB\n",
+			TMR_FSM_ENGINE_OFFS / 1024 / 1024);
+		return -ENOMEM;
+	}
+
+	/* set the default PAM4 Tx taps */
+	for (i = 0 ; i < NIC_MAX_NUM_OF_LANES ; i++) {
+		taps = gaudi->nic_pam4_tx_taps[i].taps;
+		taps[0] = 0;
+		taps[1] = -6;
+		taps[2] = 25;
+		taps[3] = 0;
+		taps[4] = 0;
+	}
+
+	/* copy the MAC OUI in reverse */
+	for (i = 0 ; i < 3 ; i++)
+		mac[i] = HABANALABS_MAC_OUI_1 >> (8 * (2 - i));
+
+	if (gaudi->hw_cap_initialized & HW_CAP_CPU_Q) {
+		char buf[VERSION_MAX_LEN] = {0}, *str;
+		u8 *mac_addr;
+
+		rc = hl_fw_cpucp_nic_info_get(hdev);
+		if (rc)
+			return rc;
+
+		for (i = 0 ; i < NIC_NUMBER_OF_PORTS ; i++) {
+			if (!(hdev->nic_ports_mask & BIT(i)))
+				continue;
+
+			mac_addr = mac_arr[i].mac_addr;
+			if (strncmp(mac, mac_addr, 3)) {
+				dev_err(hdev->dev,
+					"bad MAC OUI %02x:%02x:%02x:%02x:%02x:%02x, port %d\n",
+					mac_addr[0], mac_addr[1], mac_addr[2],
+					mac_addr[3], mac_addr[4], mac_addr[5],
+					i);
+				return -EFAULT;
+			}
+		}
+
+		hdev->nic_ports_mask &= le64_to_cpu(nic_info->link_mask[0]);
+		hdev->nic_ports_ext_mask &=
+					le64_to_cpu(nic_info->link_ext_mask[0]);
+		hdev->nic_auto_neg_mask &=
+					le64_to_cpu(nic_info->auto_neg_mask[0]);
+		gaudi->nic_use_fw_polarity = true;
+
+		for (i = 1 ; i < 11 ; i++) {
+			sprintf(buf, "hl-gaudi-0.%d.", i);
+			str = strstr(cpucp_info->kernel_version, buf);
+			if (!str)
+				continue;
+
+			/*
+			 * No PMC polarity and external ports mask prior to F/W
+			 * version 0.9.0.
+			 */
+			if (i < 9) {
+				hdev->nic_ports_ext_mask = HLS1_EXT_PORTS_MASK;
+				gaudi->nic_use_fw_polarity = false;
+			}
+
+			/* No Autoneg mask prior to F/W version 0.11.0, hence:
+			 * - No Autoneg on external ports on PMC card prior to
+			 *   that version.
+			 * - No Autoneg at all on PCI card prior to that
+			 *   version.
+			 */
+			if (hdev->card_type == cpucp_card_type_pmc)
+				hdev->nic_auto_neg_mask = hdev->nic_ports_mask &
+						~hdev->nic_ports_ext_mask;
+			else
+				hdev->nic_auto_neg_mask = 0;
+
+			/*
+			 * No privileged protection prior to F/W version 0.11.0
+			 * so we can read the card location from a register.
+			 */
+			read_card_location = true;
+			break;
+		}
+	} else {
+		/*
+		 * No CPU, hence set the MAC addresses manually.
+		 * Each device will have its own unique MAC random.
+		 */
+		get_random_bytes(&mac[3], 2);
+
+		for (i = 0 ; i < NIC_NUMBER_OF_PORTS ; i++) {
+			mac[ETH_ALEN - 1] = i;
+			memcpy(mac_arr[i].mac_addr, mac, ETH_ALEN);
+		}
+
+		read_card_location = true;
+	}
+
+	if (read_card_location) {
+		u32 card_location = RREG32(mmPSOC_GLOBAL_CONF_BOOT_STRAP_PINS);
+
+		cpucp_info->card_location =
+				cpu_to_le32((card_location >> 22) & 0x7);
+	}
+
+	for (i = 0 ; i < NIC_NUMBER_OF_MACROS ; i++) {
+		gaudi->nic_macros[i].idx = i;
+		gaudi->nic_macros[i].num_of_lanes = NIC_LANES_2;
+	}
+
+	/*
+	 * for each NIC macro, set the even port to handle the macro
+	 * configuration, unless the even port is disabled and in this case the
+	 * odd port will handle the configuration.
+	 */
+	for (i = 0 ; i < NIC_NUMBER_OF_PORTS ; i++)
+		if ((hdev->nic_ports_mask & BIT(i)) &&
+			(!(i & 1) || !(hdev->nic_ports_mask & BIT(i - 1))))
+			gaudi->nic_devices[i].do_macro_cfg = true;
+
+	gaudi->nic_pcs_fail_time_frame = PCS_FAIL_TIME_FRAME_SEC;
+	gaudi->nic_pcs_fail_threshold = PCS_FAIL_THRESHOLD;
+	gaudi->nic_check_link = true;
+
+	if ((hdev->pdev) && (gaudi->multi_msi_mode)) {
+		/* One IRQ for all ports to indicate a CQ overrun */
+		cq_irq = pci_irq_vector(hdev->pdev, CQ_MSI_IDX);
+		rc = request_irq(cq_irq, gaudi_nic_cq_irq_handler, 0,
+					"gaudi nic cq", hdev);
+		if (rc) {
+			dev_err(hdev->dev, "Failed to request CQ IRQ %d, %d\n",
+				cq_irq, rc);
+			return rc;
+		}
+
+		gaudi->nic_cq_irq_enable = true;
+	}
+
+	/* Must be called here as it depends on the earlier initializations */
+	for (i = 0 ; i < NIC_NUMBER_OF_PORTS ; i++, nics_init++)
+		if (hdev->nic_ports_mask & BIT(i)) {
+			rc = port_register(hdev, i);
+			if (rc) {
+				dev_err(hdev->dev, "NIC port %d init failed\n",
+							i);
+				goto unregister_ports;
+			}
+		}
+
+	gaudi->hw_cap_initialized |= HW_CAP_NIC_DRV;
+
+	return 0;
+
+unregister_ports:
+	for (i = 0 ; i < nics_init ; i++)
+		if (hdev->nic_ports_mask & BIT(i))
+			port_unregister(&gaudi->nic_devices[i]);
+
+	if (gaudi->nic_cq_irq_enable) {
+		synchronize_irq(cq_irq);
+		free_irq(cq_irq, hdev);
+	}
+
+	return rc;
+}
+
+/**
+ * gaudi_nic_ports_fini() - cleanup NIC ports.
+ * @hdev: habanalabs device structure.
+ *
+ * Perform cleanup and freeing of the NIC ports.
+ */
+void gaudi_nic_ports_fini(struct hl_device *hdev)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	int i, cq_irq;
+
+	gaudi->nic_in_teardown = true;
+
+	/* The HW_CAP_NIC_DRV bit of gaudi->hw_cap_initialized cannot be used as
+	 * a prerequisite for this function, as we may arrive here after a
+	 * failing hard reset w/o calling to gaudi_nic_ports_reopen().
+	 */
+
+	for (i = 0 ; i < NIC_NUMBER_OF_PORTS ; i++) {
+		if (!(hdev->nic_ports_mask & BIT(i)) ||
+				!gaudi->nic_devices[i].ndev)
+			continue;
+
+		port_unregister(&gaudi->nic_devices[i]);
+	}
+
+	if (gaudi->nic_cq_irq_enable) {
+		cq_irq = pci_irq_vector(hdev->pdev, CQ_MSI_IDX);
+		synchronize_irq(cq_irq);
+		free_irq(cq_irq, hdev);
+		gaudi->nic_cq_irq_enable = false;
+	}
+}
+
+/**
+ * gaudi_nic_hard_reset_prepare() - stop the NIC Rx, Tx, CQ and synchronize
+ *                                  with other NIC reset flows.
+ * @hdev: habanalabs device structure.
+ *
+ * This function makes sure that during the reset no packets will be processed
+ * and that ndo_open/ndo_close do not open/close the NIC.
+ * A hard reset might occur right after the driver was loaded, which means
+ * before the NICs initialization was finished. Therefore, even if the NIC is
+ * not yet enabled, we mark it as in reset to avoid races. We clear the in reset
+ * flag later on when reopening the NICs.
+ *
+ * Return: 0 for success, non-zero for failure.
+ */
+int gaudi_nic_hard_reset_prepare(struct hl_device *hdev)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct gaudi_nic_device *gaudi_nic;
+	ktime_t timeout;
+	int i;
+
+	if (!(gaudi->hw_cap_initialized & HW_CAP_NIC_DRV) ||
+			(gaudi->nic_in_reset))
+		return 0;
+
+	for (i = 0 ; i < NIC_NUMBER_OF_PORTS ; i++) {
+		if (!(hdev->nic_ports_mask & BIT(i)))
+			continue;
+
+		gaudi_nic = &gaudi->nic_devices[i];
+
+		/*
+		 * This function is competing with the NIC reset from ethtool,
+		 * so try to take the in_reset atomic and if we are already in a
+		 * middle of reset, wait until reset function is finished.
+		 * Reset function is designed to always finish (could take up to
+		 * a few seconds in worst case).
+		 */
+
+		timeout = ktime_add_ms(ktime_get(),
+					HL_PENDING_RESET_PER_SEC * 1000 * 4);
+		while (atomic_cmpxchg(&gaudi_nic->in_reset, 0, 1)) {
+			usleep_range(50, 200);
+			if (ktime_compare(ktime_get(), timeout) > 0) {
+				WARN(1,
+					"Timeout while waiting for port %d to finish reset\n",
+					gaudi_nic->port);
+				return -EBUSY;
+			}
+		}
+	}
+
+	gaudi->nic_in_reset = true;
+
+	return 0;
+}
+
+/**
+ * gaudi_nic_stop() - stop the NIC S/W and H/W.
+ * @hdev: habanalabs device structure.
+ *
+ * This function stops the operation of the NIC S/W and H/W, no packets are
+ * processed after this call.
+ */
+void gaudi_nic_stop(struct hl_device *hdev)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct gaudi_nic_device *gaudi_nic;
+	int i, cq_irq;
+
+	if (!(gaudi->hw_cap_initialized & HW_CAP_NIC_DRV))
+		return;
+
+	for (i = 0 ; i < NIC_NUMBER_OF_PORTS ; i++) {
+		gaudi_nic = &gaudi->nic_devices[i];
+
+		if ((hdev->nic_ports_mask & BIT(i)) && gaudi_nic->enabled)
+			port_close(gaudi_nic);
+	}
+
+	if (gaudi->nic_cq_irq_enable) {
+		cq_irq = pci_irq_vector(hdev->pdev, CQ_MSI_IDX);
+		synchronize_irq(cq_irq);
+		free_irq(cq_irq, hdev);
+		gaudi->nic_cq_irq_enable = false;
+	}
+}
+
+/**
+ * gaudi_nic_ports_reopen() - reopen the NIC ports.
+ * @hdev: habanalabs device structure.
+ *
+ * This function start the operation of the NIC ports, packets will be processed
+ * after this call.
+ * Called after hard reset to reopen the NIC ports that were closed during the
+ * reset.
+ */
+void gaudi_nic_ports_reopen(struct hl_device *hdev)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct gaudi_nic_device *gaudi_nic;
+	int rc, i, nics_init = 0, cq_irq;
+	u32 port;
+
+	if (gaudi->hw_cap_initialized & HW_CAP_NIC_DRV)
+		return;
+
+	if ((hdev->pdev) && (gaudi->multi_msi_mode)) {
+		/* One IRQ for all ports to indicate a CQ overrun */
+		cq_irq = pci_irq_vector(hdev->pdev, CQ_MSI_IDX);
+		rc = request_irq(cq_irq, gaudi_nic_cq_irq_handler, 0,
+					"gaudi nic cq", hdev);
+		if (rc)
+			dev_err(hdev->dev, "Failed to request CQ IRQ %d, %d\n",
+				cq_irq, rc);
+		else
+			gaudi->nic_cq_irq_enable = true;
+	}
+
+	for (i = 0 ; i < NIC_NUMBER_OF_PORTS ; i++, nics_init++) {
+		if (!(hdev->nic_ports_mask & BIT(i)))
+			continue;
+
+		gaudi_nic = &gaudi->nic_devices[i];
+		port = gaudi_nic->port;
+
+		/*
+		 * It could be that the port was shutdown by 'ifconfig down',
+		 * and there is no need in reopening it.
+		 * Since we mark the ports as in reset even if they are
+		 * disabled, we clear the flag here anyway.
+		 * See gaudi_nic_hard_reset_prepare() for more info.
+		 */
+		if (!gaudi_nic->enabled) {
+			atomic_set(&gaudi_nic->in_reset, 0);
+			continue;
+		}
+
+		schedule_delayed_work(&gaudi_nic->port_open_work,
+					msecs_to_jiffies(1));
+	}
+
+	gaudi->nic_in_reset = false;
+
+	gaudi->hw_cap_initialized |= HW_CAP_NIC_DRV;
+}
+
+void gaudi_nic_ctx_fini(struct hl_ctx *ctx)
+{
+}
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_nic.h b/drivers/misc/habanalabs/gaudi/gaudi_nic.h
new file mode 100644
index 000000000000..7259b01b78fb
--- /dev/null
+++ b/drivers/misc/habanalabs/gaudi/gaudi_nic.h
@@ -0,0 +1,336 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2018-2020 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+#ifndef GAUDI_NIC_DRV_H_
+#define GAUDI_NIC_DRV_H_
+
+#include "gaudiP.h"
+#include "../include/gaudi/gaudi_fw_if.h"
+
+/* Time in jiffies before concluding the transmitter is hung */
+#define NIC_TX_TIMEOUT			(5 * HZ)
+
+#define NIC_RX_SIZE			1024
+#define NIC_NAPI_MAX_RX_BUDGET		64
+#define NIC_MAX_PKT_SIZE		2048
+#define NIC_ARP_PKT_SIZE		28
+
+#if (NIC_MAX_PKT_SIZE & (NIC_MAX_PKT_SIZE - 1))
+#error "Max ETH packet size is not a power of 2"
+#endif
+
+#define ETH_P_LLDP		0x88CC
+
+#define NIC_MACRO_CFG_SIZE	(mmNIC1_QM0_GLBL_CFG0 - mmNIC0_QM0_GLBL_CFG0)
+#define NIC_CFG_SIZE		(mmNIC0_QPC1_REQ_STATIC_CONFIG - \
+					mmNIC0_QPC0_REQ_STATIC_CONFIG)
+
+#define NIC_MAX_QP_NUM		(HL_NIC_MAX_CONN_ID + 1)
+#define NIC_HW_MAX_QP_NUM	0x8000 /* 32K */
+
+#if (NIC_MAX_QP_NUM > NIC_HW_MAX_QP_NUM)
+#error "Number of available QPs must be smaller or equal to NIC_HW_MAX_QP_NUM"
+#endif
+
+/* The '*_SIZE' defines are per NIC port */
+#define REQ_QPC_BASE_SIZE	(NIC_MAX_QP_NUM * sizeof(struct qpc_requester))
+#define RES_QPC_BASE_SIZE	(NIC_MAX_QP_NUM * sizeof(struct qpc_responder))
+#define SWQ_BASE_SIZE		(WQ_BUFFER_SIZE * sizeof(struct sq_wqe))
+#define SB_BASE_SIZE		(WQ_BUFFER_SIZE * NIC_MAX_PKT_SIZE)
+
+#define TMR_BASE_SIZE		(TMR_FSM_ENGINE_OFFS + TMR_FSM_SIZE)
+
+#define TMR_FSM_ENGINE_OFFS	(1 << 22) /* H/W constraint */
+
+#define TMR_FSM_SIZE		ALIGN(NIC_HW_MAX_QP_NUM, DEVICE_CACHE_LINE_SIZE)
+#define TMR_FREE_SIZE		ALIGN(TMR_FREE_NUM_ENTRIES * 4, \
+					DEVICE_CACHE_LINE_SIZE)
+/* each timer serves two NICs, hence multiply by 2 */
+#define TMR_FIFO_SIZE		ALIGN((NIC_MAX_QP_NUM * 2 * 4), \
+					DEVICE_CACHE_LINE_SIZE)
+#define TMR_FIFO_STATIC_SIZE	(DEVICE_CACHE_LINE_SIZE * TMR_GRANULARITY)
+
+#define TMR_FSM0_OFFS		0
+#define TMR_FREE_OFFS		(TMR_FSM0_OFFS + TMR_FSM_SIZE)
+#define TMR_FIFO_OFFS		(TMR_FREE_OFFS + TMR_FREE_SIZE)
+#define TMR_FSM1_OFFS		(TMR_FSM0_OFFS + TMR_FSM_ENGINE_OFFS)
+
+#define TMR_FREE_NUM_ENTRIES	(TMR_FIFO_SIZE / DEVICE_CACHE_LINE_SIZE)
+#define TMR_GRANULARITY		128
+
+#define TXS_BASE_SIZE		(TXS_FREE_SIZE + TXS_FIFO_SIZE + \
+					TXS_FIFO_STATIC_SIZE)
+
+
+#define TXS_FREE_SIZE		ALIGN(TXS_FREE_NUM_ENTRIES * 4, \
+					DEVICE_CACHE_LINE_SIZE)
+/* TXS serves requester and responder QPs, hence multiply by 2 */
+#define TXS_FIFO_SIZE		ALIGN((NIC_MAX_QP_NUM * 2 * 4), \
+					DEVICE_CACHE_LINE_SIZE)
+#define TXS_FIFO_STATIC_SIZE	(DEVICE_CACHE_LINE_SIZE * TXS_GRANULARITY)
+
+#define TXS_FREE_OFFS		0
+#define TXS_FIFO_OFFS		(TXS_FREE_OFFS + TXS_FREE_SIZE)
+
+#define TXS_FREE_NUM_ENTRIES	(TXS_FIFO_SIZE / DEVICE_CACHE_LINE_SIZE)
+#define TXS_GRANULARITY		256
+#define TXS_SCHEDQ		256
+
+#define SECTION_ALIGN_SIZE	0x100000ull
+#define NIC_DRV_BASE_ADDR	ALIGN(NIC_DRV_ADDR, SECTION_ALIGN_SIZE)
+
+#define REQ_QPC_BASE_ADDR	NIC_DRV_BASE_ADDR
+
+#define RES_QPC_BASE_ADDR	ALIGN(REQ_QPC_BASE_ADDR + \
+					NIC_NUMBER_OF_ENGINES * \
+					REQ_QPC_BASE_SIZE, SECTION_ALIGN_SIZE)
+
+#define TMR_BASE_ADDR		ALIGN(RES_QPC_BASE_ADDR + \
+					NIC_NUMBER_OF_ENGINES * \
+					RES_QPC_BASE_SIZE, SECTION_ALIGN_SIZE)
+
+#define TXS_BASE_ADDR		ALIGN(TMR_BASE_ADDR + \
+					NIC_NUMBER_OF_MACROS * \
+					TMR_BASE_SIZE, SECTION_ALIGN_SIZE)
+
+#define SWQ_BASE_ADDR		ALIGN(TXS_BASE_ADDR + \
+					NIC_NUMBER_OF_ENGINES * \
+					TXS_BASE_SIZE, SECTION_ALIGN_SIZE)
+
+#define SB_BASE_ADDR		ALIGN(SWQ_BASE_ADDR + \
+					NIC_MAX_NUMBER_OF_PORTS * \
+					SWQ_BASE_SIZE, SECTION_ALIGN_SIZE)
+
+#define NIC_DRV_END_ADDR	ALIGN(SB_BASE_ADDR + NIC_MAX_NUMBER_OF_PORTS * \
+					SB_BASE_SIZE, SECTION_ALIGN_SIZE)
+
+#define WQ_BUFFER_LOG_SIZE		8
+#define WQ_BUFFER_SIZE			(1 << WQ_BUFFER_LOG_SIZE)
+#define CQ_PORT_BUF_LEN			(1 << 18)
+#define CQE_SIZE			sizeof(struct cqe)
+#define CQ_PORT_BUF_SIZE		(CQ_PORT_BUF_LEN * CQE_SIZE)
+#define CQ_USER_MAX_SIZE		(1 << 30) /* 1GB */
+#define CQ_USER_MIN_ENTRIES		128
+#define CQ_USER_MAX_ENTRIES		(CQ_USER_MAX_SIZE / CQE_SIZE)
+#define QP_ERR_BUF_SIZE			(QP_ERR_SIZE * QP_ERR_BUF_LEN)
+#define QP_ERR_SIZE			sizeof(struct qp_err)
+#define QP_ERR_BUF_LEN			1024
+#define RX_PKT_MAX_SIZE			2048
+#define QPC_RES_LOG_BUF_SIZE_MASK	10
+#define RAW_QPN				0
+#define RX_MSI_IDX			(GAUDI_EVENT_QUEUE_MSI_IDX + 1)
+#define RX_MSI_ADDRESS			(mmPCIE_MSI_INTR_0 + RX_MSI_IDX * 4)
+#define CQ_MSI_IDX			(NUMBER_OF_CMPLT_QUEUES + \
+						NUMBER_OF_CPU_HW_QUEUES + \
+						NIC_NUMBER_OF_ENGINES)
+#define CQ_MSI_ADDRESS			(mmPCIE_MSI_INTR_0 + CQ_MSI_IDX * 4)
+
+#define WQE_MAX_SIZE			max(NIC_SEND_WQE_SIZE, \
+						NIC_RECV_WQE_SIZE)
+#define USER_WQES_MAX_NUM		(1 << 21) /* 2MB */
+#define USER_WQ_ARR_MAX_SIZE		ALIGN((1ull * NIC_HW_MAX_QP_NUM * \
+					USER_WQES_MAX_NUM * \
+						WQE_MAX_SIZE), PAGE_SIZE_2MB)
+
+#define CQ_VIRTUAL_ADDRESS		VA_NIC_MEM_ADDR
+
+#define USER_SWQ_VIRTUAL_ADDRESS	ALIGN(CQ_VIRTUAL_ADDRESS + \
+					NIC_NUMBER_OF_ENGINES * \
+						CQ_PORT_BUF_SIZE, \
+							SECTION_ALIGN_SIZE)
+
+#define USER_RWQ_VIRTUAL_ADDRESS	ALIGN(USER_SWQ_VIRTUAL_ADDRESS + \
+					NIC_NUMBER_OF_ENGINES * \
+						USER_WQ_ARR_MAX_SIZE, \
+							SECTION_ALIGN_SIZE)
+
+#define REQ_QPC_ADDR(port, conn_id) \
+	(REQ_QPC_BASE_ADDR + (port) * REQ_QPC_BASE_SIZE + (conn_id) * \
+			sizeof(struct qpc_requester))
+
+#define RES_QPC_ADDR(port, conn_id) \
+	(RES_QPC_BASE_ADDR + (port) * RES_QPC_BASE_SIZE + (conn_id) * \
+			sizeof(struct qpc_responder))
+
+#define NIC_DR_10		1031250
+#define NIC_DR_25		2578125
+#define NIC_DR_26		2656250
+#define NIC_DR_50		5312500
+
+#define NIC_LANES_2		2
+#define NIC_LANES_4		4
+
+/*
+ * change WQ_BUFFER_LOG_SIZE to log2(SWQ_BASE_SIZE/WQE_BB_SIZE).
+ * can use WQ_BUFFER_SIZE/WQE_BB_SIZE instead.
+ */
+
+enum ts_type {
+	TS_RC = 0,
+	TS_RAW = 1
+};
+
+enum wqe_opcode {
+	WQE_NOP = 0,
+	WQE_SEND = 1,
+	WQE_LINEAR = 2,
+	WQE_STRIDE = 3,
+	WQE_MULTI_STRIDE = 4,
+	WQE_RATE_UPDATE  = 5
+};
+
+enum trust_level {
+	UNSECURED = 0,
+	SECURED = 1,
+	PRIVILEGE = 2
+};
+
+struct qpc_requester {
+	u64	data[8];
+};
+
+#define QPC_SET(qpc, idx, shift, val, len) \
+		((qpc).data[idx] |= (u64) ((val) & (BIT(len) - 1)) << (shift))
+
+#define REQ_QPC_SET_DST_QP(req, val)		QPC_SET(req, 0, 0, val, 24)
+#define REQ_QPC_SET_PORT(req, val)		QPC_SET(req, 0, 24, val, 4)
+#define REQ_QPC_SET_PRIORITY(req, val)		QPC_SET(req, 0, 28, val, 2)
+#define REQ_QPC_SET_RKEY(req, val)		QPC_SET(req, 0, 32, val, 32)
+#define REQ_QPC_SET_DST_IP(req, val)		QPC_SET(req, 1, 0, val, 32)
+#define REQ_QPC_SET_SRC_IP(req, val)		QPC_SET(req, 1, 32, val, 32)
+#define REQ_QPC_SET_DST_MAC_31_0(req, val)	QPC_SET(req, 2, 0, val, 32)
+#define REQ_QPC_SET_DST_MAC_47_32(req, val)	QPC_SET(req, 2, 32, val, 16)
+#define REQ_QPC_SET_SQ_NUM(req, val)		QPC_SET(req, 3, 24, val, 8)
+#define REQ_QPC_SET_TM_GRANULARITY(req, val)	QPC_SET(req, 3, 56, val, 7)
+#define REQ_QPC_SET_SOB_EN(req, val)		QPC_SET(req, 3, 63, val, 1)
+#define REQ_QPC_SET_TRANSPORT_SERVICE(req, val)	QPC_SET(req, 5, 49, val, 1)
+#define REQ_QPC_SET_BURST_SIZE(req, val)	QPC_SET(req, 5, 50, val, 22)
+#define REQ_QPC_SET_LAST_IDX(req, val)		QPC_SET(req, 6, 8, val, 22)
+#define REQ_QPC_SET_SWQ_GRANULARITY(req, val)	QPC_SET(req, 7, 58, val, 1)
+#define REQ_QPC_SET_WQ_BASE_ADDR(req, val)	QPC_SET(req, 7, 32, val, 24)
+#define REQ_QPC_SET_SECURED(req, val)		QPC_SET(req, 7, 59, val, 2)
+#define REQ_QPC_SET_VALID(req, val)		QPC_SET(req, 7, 63, val, 1)
+
+struct qpc_responder {
+	u64	data[4];
+};
+
+#define RES_QPC_SET_DST_QP(res, val)		QPC_SET(res, 0, 0, val, 24)
+#define RES_QPC_SET_PORT(res, val)		QPC_SET(res, 0, 24, val, 4)
+#define RES_QPC_SET_PRIORITY(res, val)		QPC_SET(res, 0, 28, val, 2)
+#define RES_QPC_SET_SQ_NUM(res, val)		QPC_SET(res, 2, 48, val, 8)
+#define RES_QPC_SET_LKEY(res, val)		QPC_SET(res, 0, 32, val, 32)
+#define RES_QPC_SET_DST_IP(res, val)		QPC_SET(res, 1, 0, val, 32)
+#define RES_QPC_SET_SRC_IP(res, val)		QPC_SET(res, 1, 32, val, 32)
+#define RES_QPC_SET_DST_MAC_31_0(res, val)	QPC_SET(res, 2, 0, val, 32)
+#define RES_QPC_SET_DST_MAC_47_32(res, val)	QPC_SET(res, 2, 32, val, 16)
+#define RES_QPC_SET_TRANSPORT_SERVICE(res, val)	QPC_SET(res, 2, 63, val, 1)
+#define RES_QPC_SET_LOG_BUF_SIZE_MASK(res, val)	QPC_SET(res, 3, 24, val, 5)
+#define RES_QPC_SET_SOB_EN(res, val)		QPC_SET(res, 3, 59, val, 1)
+#define RES_QPC_SET_VALID(res, val)		QPC_SET(res, 3, 63, val, 1)
+#define RES_QPC_SET_SECURED(res, val)		QPC_SET(res, 3, 60, val, 2)
+
+/**
+ * struct hl_qp - Describes a NIC Queue Pair.
+ * @qpc_lock: Mutex to protect accessing the QP context.
+ * @refcount: Reference counter for the QP usage.
+ * @gaudi_nic: Pointer to NIC device this QP belongs to.
+ * @port: The port number this QP belongs to.
+ * @conn_id: The QP number within its port.
+ * @local_key: Key for local access.
+ * @remote_key: Key for remote access.
+ * @is_req: is requester context was set for the QP.
+ * @is_res: is responder context was set for the QP.
+ */
+struct hl_qp {
+	struct mutex qpc_lock;
+	struct kref refcount;
+	struct gaudi_nic_device *gaudi_nic;
+	u32 port;
+	u32 conn_id;
+	u32 local_key;
+	u32 remote_key;
+	u8 is_req;
+	u8 is_res;
+};
+
+struct sq_wqe {
+	u64	data[4];
+};
+
+#define CFG_SQ_WQE_OPCODE(swq, val) \
+						((swq).data[0] |= (val) << 28)
+#define CFG_SQ_WQE_LOCAL_ADDRESS_31_0(swq, val) \
+						((swq).data[0] |= (val) << 32)
+#define CFG_SQ_WQE_LOCAL_ADDRESS_49_32(swq, val) \
+						((swq).data[1] |= (val))
+#define CFG_SQ_WQE_SIZE(swq, val) \
+						((swq).data[1] |= (val) << 18)
+
+struct cqe {
+	u64	data;
+};
+
+#define CQE_IS_VALID(cqe)		(((cqe)->data >> 63) & 1)
+#define CQE_TYPE(cqe)			(((cqe)->data >> 23) & 1)
+#define CQE_RES_NIC(cqe)		(((cqe)->data >> 10) & 1)
+#define CQE_RES_IMDT_21_0(cqe)		(((cqe)->data >> 32) & 0x3FFFFF)
+#define CQE_RES_IMDT_31_22(cqe)		((cqe)->data & 0x3FF)
+#define CQE_REQ_WQE_IDX(cqe)		(((cqe)->data >> 32) & 0x3FFFFF)
+#define CQE_REQ_QPN(cqe)		((cqe)->data & 0x7FFFFF)
+#define CQE_SET_INVALID(cqe)		((cqe)->data &= ~(1ull << 63))
+
+struct qp_err {
+	u32	data;
+};
+
+#define QP_ERR_QP_NUM(qp_err)		((qp_err).data & 0xFFFFFF)
+#define QP_ERR_ERR_NUM(qp_err)		(((qp_err).data >> 24) & 0x7F)
+#define QP_ERR_IS_REQ(qp_err)		(((qp_err).data >> 31) & 1)
+
+/*
+ * Some registers are specific for each NIC port, and some are shared for all
+ * the NIC macro (a pair of even and odd port).
+ * Therefore we need different methods to handle these registers.
+ */
+
+/* read/write port specific registers */
+#define NIC_CFG_BASE(port) \
+			((u64) (NIC_MACRO_CFG_SIZE * (u64) ((port) >> 1) + \
+					NIC_CFG_SIZE * (u64) ((port) & 1)))
+
+#define NIC_RREG32(reg)		RREG32(NIC_CFG_BASE(gaudi_nic->port) + (reg))
+#define NIC_WREG32(reg, val)	WREG32(NIC_CFG_BASE(gaudi_nic->port) + (reg), \
+					(val))
+#define NIC_RMWREG32(reg, val, mask)	\
+		RMWREG32(NIC_CFG_BASE(gaudi_nic->port) + (reg), (val), (mask))
+
+/* read/write shared registers */
+#define NIC_MACRO_CFG_BASE(port) \
+			((u64) (NIC_MACRO_CFG_SIZE * (u64) ((port) >> 1)))
+
+#define NIC_MACRO_RREG32_PORT(reg, port) \
+			RREG32(NIC_MACRO_CFG_BASE(port) + reg)
+#define NIC_MACRO_WREG32_PORT(reg, val, port) \
+			WREG32(NIC_MACRO_CFG_BASE(port) + reg, val)
+
+#define NIC_MACRO_RREG32(reg) NIC_MACRO_RREG32_PORT(reg, gaudi_nic->port)
+#define NIC_MACRO_WREG32(reg, val) \
+				NIC_MACRO_WREG32_PORT(reg, val, gaudi_nic->port)
+
+extern const struct ethtool_ops gaudi_nic_ethtool_ops;
+extern const struct dcbnl_rtnl_ops gaudi_nic_dcbnl_ops;
+
+void gaudi_nic_set_pfc(struct gaudi_nic_device *gaudi_nic);
+u32 gaudi_nic_mac_read(struct gaudi_nic_device *gaudi_nic, int mac,
+			char *cfg_type, u32 addr);
+int gaudi_nic_port_reset(struct gaudi_nic_device *gaudi_nic);
+bool disabled_or_in_reset(struct gaudi_nic_device *gaudi_nic);
+u64 gaudi_nic_read_mac_stat_counter(struct hl_device *hdev, u32 port, int idx,
+					bool is_rx);
+
+#endif /* GAUDI_NIC_DRV_H_ */
diff --git a/drivers/misc/habanalabs/goya/goya.c b/drivers/misc/habanalabs/goya/goya.c
index 5cddd46a8fb8..f82212310114 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -5274,6 +5274,11 @@ static int goya_ctx_init(struct hl_ctx *ctx)
 	return 0;
 }
 
+static void goya_ctx_fini(struct hl_ctx *ctx)
+{
+
+}
+
 u32 goya_get_queue_id_for_cq(struct hl_device *hdev, u32 cq_idx)
 {
 	return cq_idx;
@@ -5387,6 +5392,7 @@ static const struct hl_asic_funcs goya_funcs = {
 	.wreg = hl_wreg,
 	.halt_coresight = goya_halt_coresight,
 	.ctx_init = goya_ctx_init,
+	.ctx_fini = goya_ctx_fini,
 	.get_clk_rate = goya_get_clk_rate,
 	.get_queue_id_for_cq = goya_get_queue_id_for_cq,
 	.read_device_fw_version = goya_read_device_fw_version,
diff --git a/include/uapi/misc/habanalabs.h b/include/uapi/misc/habanalabs.h
index 9705b8adb60c..cd9d05e03464 100644
--- a/include/uapi/misc/habanalabs.h
+++ b/include/uapi/misc/habanalabs.h
@@ -831,6 +831,9 @@ struct hl_debug_args {
 	__u32 ctx_id;
 };
 
+#define HL_NIC_MIN_CONN_ID	1
+#define HL_NIC_MAX_CONN_ID	1023
+
 /*
  * Various information operations such as:
  * - H/W IP information
-- 
2.17.1

