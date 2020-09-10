Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAF0264DC2
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 20:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgIJSuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgIJQL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:11:57 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7164CC06179A;
        Thu, 10 Sep 2020 09:11:56 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id lo4so9516703ejb.8;
        Thu, 10 Sep 2020 09:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JrSu93bX5OMY9+zzwZ8lpGmMDg5QSi5IMVFkw3vHrJs=;
        b=pHHpf50TPQSfAAR0YJFLjdPTFGP1HtQ7t03aECWAz1hCouY8uMt9oFRM+ld0oFxolf
         p5tbkBJlDNy9SJlLSyVVXvvknWgQbdM+tG4PcK89ebLP48EiEUug6XDhnSDutnBvBRw+
         a5oVS3Ftw0JLMVPLge+qMsjf/dWGcg293czRArux2Uns3aV/dbv2LosNsykWM8dBwJcz
         N+RhnakcxR9IvtneCUqnYpA4+nxolYwGahZo/s2OnU2POKqq7sTKcCr5wws2U7xbkFuW
         2j6TAAf/2AaBnFeTQF4SepVEbDkJ3Xu0chE4uQrT3/rMOLnRTvQwALoIOWUevGAPqmKX
         yjcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JrSu93bX5OMY9+zzwZ8lpGmMDg5QSi5IMVFkw3vHrJs=;
        b=QMLm5Fs1kIWVUMEFMKmJqRxx8NznauipbakfvHL3Xnq1RdJ5GEJ26BdxDBz00Vu6T8
         HCgBvW9oMpoBeQ5LWASS/wII1uJVSgkWYzvW3k8uK0sSpOGf51R3i4dwyu5yeC0kIXWm
         X8034VKZYIF7BFv5IhSw2/OBWiWZMIk8KAoNmqc7IKk6fEfxUb9W6mfcjQwkdGn29rLA
         w9QoPAgFAw/IK7iAA+7SE4eoNSNq6UiSuC2jlIXp+0q6EMA5zHixa7umnrPPLsipeX3w
         Rp1aySTKBWd4BBHPyz6JAAqz5iQ5FYgfIaL3qLmmlWmNXSd6nsKao494jOrbkSPus0vC
         QJeQ==
X-Gm-Message-State: AOAM533asB2IGF27D/8dU8h/gYow7vMZbGPh+UlNU/AOI2ficrxXoHod
        4L3iVFjV+8SEwQkqfmY39fRaYi93NbI=
X-Google-Smtp-Source: ABdhPJynMAlyyvKEh4PtBLQHIWklNPU/+q+f/6GqvjVW8q4eKg/epd0upvOj1hVRir+d4AUnZj9klQ==
X-Received: by 2002:a17:906:ae8f:: with SMTP id md15mr9177862ejb.131.1599754313851;
        Thu, 10 Sep 2020 09:11:53 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id k8sm7282911ejz.60.2020.09.10.09.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 09:11:52 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org,
        Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH 04/15] habanalabs/gaudi: add support for NIC QMANs
Date:   Thu, 10 Sep 2020 19:11:15 +0300
Message-Id: <20200910161126.30948-5-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910161126.30948-1-oded.gabbay@gmail.com>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

Initialize the QMANs that are responsible to submit doorbells to the NIC
engines. Add support for stopping and disabling them, and reset them as
part of the hard-reset procedure of GAUDI. This will allow the user to
submit work to the NICs.

Add support for receiving events on QMAN errors from the firmware.

However, the nic_ports_mask is still initialized to 0. That means this code
won't initialize the QMANs just yet. That will be in a later patch.

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
---
 drivers/misc/habanalabs/common/habanalabs.h |   3 +-
 drivers/misc/habanalabs/gaudi/gaudi.c       | 741 ++++++++++++++++++--
 drivers/misc/habanalabs/gaudi/gaudiP.h      |  32 +
 3 files changed, 731 insertions(+), 45 deletions(-)

diff --git a/drivers/misc/habanalabs/common/habanalabs.h b/drivers/misc/habanalabs/common/habanalabs.h
index ec765320159a..3be39d8b0563 100644
--- a/drivers/misc/habanalabs/common/habanalabs.h
+++ b/drivers/misc/habanalabs/common/habanalabs.h
@@ -1516,8 +1516,6 @@ struct hl_device_idle_busy_ts {
  * @pmmu_huge_range: is a different virtual addresses range used for PMMU with
  *                   huge pages.
  * @init_done: is the initialization of the device done.
- * @mmu_enable: is MMU enabled.
- * @mmu_huge_page_opt: is MMU huge pages optimization enabled.
  * @device_cpu_disabled: is the device CPU disabled (due to timeouts)
  * @dma_mask: the dma mask that was set for this device
  * @in_debug: is device under debug. This, together with fpriv_list, enforces
@@ -1630,6 +1628,7 @@ struct hl_device {
 	u8				supports_soft_reset;
 
 	/* Parameters for bring-up */
+	u64				nic_ports_mask;
 	u8				mmu_enable;
 	u8				mmu_huge_page_opt;
 	u8				cpu_enable;
diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 483989500863..2159e14be4ef 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -301,46 +301,46 @@ static enum hl_queue_type gaudi_queue_type[GAUDI_QUEUE_ID_SIZE] = {
 	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_TPC_7_1 */
 	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_TPC_7_2 */
 	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_TPC_7_3 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_0_0 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_0_1 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_0_2 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_0_3 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_1_0 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_1_1 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_1_2 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_1_3 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_2_0 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_2_1 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_2_2 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_2_3 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_3_0 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_3_1 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_3_2 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_3_3 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_4_0 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_4_1 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_4_2 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_4_3 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_5_0 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_5_1 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_5_2 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_5_3 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_6_0 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_6_1 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_6_2 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_6_3 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_7_0 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_7_1 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_7_2 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_7_3 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_8_0 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_8_1 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_8_2 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_8_3 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_9_0 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_9_1 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_9_2 */
-	QUEUE_TYPE_NA,  /* GAUDI_QUEUE_ID_NIC_9_3 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_0_0 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_0_1 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_0_2 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_0_3 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_1_0 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_1_1 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_1_2 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_1_3 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_2_0 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_2_1 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_2_2 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_2_3 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_3_0 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_3_1 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_3_2 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_3_3 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_4_0 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_4_1 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_4_2 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_4_3 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_5_0 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_5_1 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_5_2 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_5_3 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_6_0 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_6_1 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_6_2 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_6_3 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_7_0 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_7_1 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_7_2 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_7_3 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_8_0 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_8_1 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_8_2 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_8_3 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_9_0 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_9_1 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_9_2 */
+	QUEUE_TYPE_INT, /* GAUDI_QUEUE_ID_NIC_9_3 */
 };
 
 struct ecc_info_extract_params {
@@ -792,6 +792,27 @@ static int gaudi_late_init(struct hl_device *hdev)
 		return rc;
 	}
 
+	if ((hdev->card_type == cpucp_card_type_pci) &&
+			(hdev->nic_ports_mask & 0x3)) {
+		dev_info(hdev->dev,
+			"PCI card detected, only 8 ports are enabled\n");
+		hdev->nic_ports_mask &= ~0x3;
+
+		/* Stop and disable unused NIC QMANs */
+		WREG32(mmNIC0_QM0_GLBL_CFG1, NIC0_QM0_GLBL_CFG1_PQF_STOP_MASK |
+					NIC0_QM0_GLBL_CFG1_CQF_STOP_MASK |
+					NIC0_QM0_GLBL_CFG1_CP_STOP_MASK);
+
+		WREG32(mmNIC0_QM1_GLBL_CFG1, NIC0_QM0_GLBL_CFG1_PQF_STOP_MASK |
+					NIC0_QM0_GLBL_CFG1_CQF_STOP_MASK |
+					NIC0_QM0_GLBL_CFG1_CP_STOP_MASK);
+
+		WREG32(mmNIC0_QM0_GLBL_CFG0, 0);
+		WREG32(mmNIC0_QM1_GLBL_CFG0, 0);
+
+		gaudi->hw_cap_initialized &= ~(HW_CAP_NIC0 | HW_CAP_NIC1);
+	}
+
 	rc = hl_fw_send_pci_access_msg(hdev, CPUCP_PACKET_ENABLE_PCI_ACCESS);
 	if (rc) {
 		dev_err(hdev->dev, "Failed to enable PCI access from CPU\n");
@@ -938,6 +959,9 @@ static int gaudi_alloc_internal_qmans_pq_mem(struct hl_device *hdev)
 		case GAUDI_QUEUE_ID_TPC_0_0 ... GAUDI_QUEUE_ID_TPC_7_3:
 			q->pq_size = TPC_QMAN_SIZE_IN_BYTES;
 			break;
+		case GAUDI_QUEUE_ID_NIC_0_0 ... GAUDI_QUEUE_ID_NIC_9_3:
+			q->pq_size = NIC_QMAN_SIZE_IN_BYTES;
+			break;
 		default:
 			dev_err(hdev->dev, "Bad internal queue index %d", i);
 			rc = -EINVAL;
@@ -2332,6 +2356,133 @@ static void gaudi_init_tpc_qmans(struct hl_device *hdev)
 	}
 }
 
+static void gaudi_init_nic_qman(struct hl_device *hdev, u32 nic_offset,
+				int qman_id, u64 qman_base_addr, int nic_id)
+{
+	u32 mtr_base_lo, mtr_base_hi;
+	u32 so_base_lo, so_base_hi;
+	u32 q_off;
+	u32 nic_qm_err_cfg;
+
+	mtr_base_lo = lower_32_bits(CFG_BASE +
+				mmSYNC_MNGR_E_N_SYNC_MNGR_OBJS_MON_PAY_ADDRL_0);
+	mtr_base_hi = upper_32_bits(CFG_BASE +
+				mmSYNC_MNGR_E_N_SYNC_MNGR_OBJS_MON_PAY_ADDRL_0);
+	so_base_lo = lower_32_bits(CFG_BASE +
+				mmSYNC_MNGR_E_N_SYNC_MNGR_OBJS_SOB_OBJ_0);
+	so_base_hi = upper_32_bits(CFG_BASE +
+				mmSYNC_MNGR_E_N_SYNC_MNGR_OBJS_SOB_OBJ_0);
+
+	q_off = nic_offset + qman_id * 4;
+
+	WREG32(mmNIC0_QM0_PQ_BASE_LO_0 + q_off, lower_32_bits(qman_base_addr));
+	WREG32(mmNIC0_QM0_PQ_BASE_HI_0 + q_off, upper_32_bits(qman_base_addr));
+
+	WREG32(mmNIC0_QM0_PQ_SIZE_0 + q_off, ilog2(NIC_QMAN_LENGTH));
+	WREG32(mmNIC0_QM0_PQ_PI_0 + q_off, 0);
+	WREG32(mmNIC0_QM0_PQ_CI_0 + q_off, 0);
+
+	WREG32(mmNIC0_QM0_CP_LDMA_TSIZE_OFFSET_0 + q_off, 0x74);
+	WREG32(mmNIC0_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_0 + q_off, 0x14);
+	WREG32(mmNIC0_QM0_CP_LDMA_DST_BASE_LO_OFFSET_0 + q_off, 0x1C);
+
+	WREG32(mmNIC0_QM0_CP_MSG_BASE0_ADDR_LO_0 + q_off, mtr_base_lo);
+	WREG32(mmNIC0_QM0_CP_MSG_BASE0_ADDR_HI_0 + q_off, mtr_base_hi);
+	WREG32(mmNIC0_QM0_CP_MSG_BASE1_ADDR_LO_0 + q_off, so_base_lo);
+	WREG32(mmNIC0_QM0_CP_MSG_BASE1_ADDR_HI_0 + q_off, so_base_hi);
+
+	if (qman_id == 0) {
+		/* Configure RAZWI IRQ */
+		nic_qm_err_cfg = NIC_QMAN_GLBL_ERR_CFG_MSG_EN_MASK;
+		if (hdev->stop_on_err) {
+			nic_qm_err_cfg |=
+				NIC_QMAN_GLBL_ERR_CFG_STOP_ON_ERR_EN_MASK;
+		}
+
+		WREG32(mmNIC0_QM0_GLBL_ERR_CFG + nic_offset, nic_qm_err_cfg);
+		WREG32(mmNIC0_QM0_GLBL_ERR_ADDR_LO + nic_offset,
+			lower_32_bits(CFG_BASE +
+				mmGIC_DISTRIBUTOR__5_GICD_SETSPI_NSR));
+		WREG32(mmNIC0_QM0_GLBL_ERR_ADDR_HI + nic_offset,
+			upper_32_bits(CFG_BASE +
+				mmGIC_DISTRIBUTOR__5_GICD_SETSPI_NSR));
+		WREG32(mmNIC0_QM0_GLBL_ERR_WDATA + nic_offset,
+			gaudi_irq_map_table[GAUDI_EVENT_NIC0_QM0].cpu_id +
+									nic_id);
+
+		WREG32(mmNIC0_QM0_ARB_ERR_MSG_EN + nic_offset,
+				QM_ARB_ERR_MSG_EN_MASK);
+
+		/* Increase ARB WDT to support streams architecture */
+		WREG32(mmNIC0_QM0_ARB_SLV_CHOISE_WDT + nic_offset,
+				GAUDI_ARB_WDT_TIMEOUT);
+
+		WREG32(mmNIC0_QM0_GLBL_CFG1 + nic_offset, 0);
+		WREG32(mmNIC0_QM0_GLBL_PROT + nic_offset,
+				QMAN_INTERNAL_MAKE_TRUSTED);
+	}
+}
+
+/**
+ * gaudi_init_nic_qmans - Initialize NIC QMAN registers
+ *
+ * @hdev: pointer to hl_device structure
+ *
+ * Initialize the H/W registers of the NIC QMANs
+ *
+ */
+void gaudi_init_nic_qmans(struct hl_device *hdev)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct gaudi_internal_qman_info *q;
+	u64 qman_base_addr;
+	u32 nic_offset = 0;
+	u32 nic_delta_between_qmans =
+			mmNIC0_QM1_GLBL_CFG0 - mmNIC0_QM0_GLBL_CFG0;
+	u32 nic_delta_between_nics =
+			mmNIC1_QM0_GLBL_CFG0 - mmNIC0_QM0_GLBL_CFG0;
+	int i, nic_id, internal_q_index;
+
+	if (!hdev->nic_ports_mask)
+		return;
+
+	if (gaudi->hw_cap_initialized & HW_CAP_NIC_MASK)
+		return;
+
+	dev_dbg(hdev->dev, "Initializing NIC QMANs\n");
+
+	for (nic_id = 0 ; nic_id < NIC_NUMBER_OF_ENGINES ; nic_id++) {
+		if (!(hdev->nic_ports_mask & (1 << nic_id))) {
+			nic_offset += nic_delta_between_qmans;
+			if (nic_id & 1) {
+				nic_offset -= (nic_delta_between_qmans * 2);
+				nic_offset += nic_delta_between_nics;
+			}
+			continue;
+		}
+
+		for (i = 0 ; i < QMAN_STREAMS ; i++) {
+			internal_q_index = GAUDI_QUEUE_ID_NIC_0_0 +
+						nic_id * QMAN_STREAMS + i;
+			q = &gaudi->internal_qmans[internal_q_index];
+			qman_base_addr = (u64) q->pq_dma_addr;
+			gaudi_init_nic_qman(hdev, nic_offset, (i & 0x3),
+						qman_base_addr, nic_id);
+		}
+
+		/* Enable the QMAN */
+		WREG32(mmNIC0_QM0_GLBL_CFG0 + nic_offset, NIC_QMAN_ENABLE);
+
+		nic_offset += nic_delta_between_qmans;
+		if (nic_id & 1) {
+			nic_offset -= (nic_delta_between_qmans * 2);
+			nic_offset += nic_delta_between_nics;
+		}
+
+		gaudi->hw_cap_initialized |= 1 << (HW_CAP_NIC_SHIFT + nic_id);
+	}
+}
+
 static void gaudi_disable_pci_dma_qmans(struct hl_device *hdev)
 {
 	struct gaudi_device *gaudi = hdev->asic_specific;
@@ -2384,6 +2535,30 @@ static void gaudi_disable_tpc_qmans(struct hl_device *hdev)
 	}
 }
 
+static void gaudi_disable_nic_qmans(struct hl_device *hdev)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	u32 nic_mask, nic_offset = 0;
+	u32 nic_delta_between_qmans =
+			mmNIC0_QM1_GLBL_CFG0 - mmNIC0_QM0_GLBL_CFG0;
+	u32 nic_delta_between_nics =
+			mmNIC1_QM0_GLBL_CFG0 - mmNIC0_QM0_GLBL_CFG0;
+	int nic_id;
+
+	for (nic_id = 0 ; nic_id < NIC_NUMBER_OF_ENGINES ; nic_id++) {
+		nic_mask = 1 << (HW_CAP_NIC_SHIFT + nic_id);
+
+		if (gaudi->hw_cap_initialized & nic_mask)
+			WREG32(mmNIC0_QM0_GLBL_CFG0 + nic_offset, 0);
+
+		nic_offset += nic_delta_between_qmans;
+		if (nic_id & 1) {
+			nic_offset -= (nic_delta_between_qmans * 2);
+			nic_offset += nic_delta_between_nics;
+		}
+	}
+}
+
 static void gaudi_stop_pci_dma_qmans(struct hl_device *hdev)
 {
 	struct gaudi_device *gaudi = hdev->asic_specific;
@@ -2442,6 +2617,73 @@ static void gaudi_stop_tpc_qmans(struct hl_device *hdev)
 	WREG32(mmTPC7_QM_GLBL_CFG1, 0x1F << TPC0_QM_GLBL_CFG1_CP_STOP_SHIFT);
 }
 
+static void gaudi_stop_nic_qmans(struct hl_device *hdev)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+
+	/* Stop upper CPs of QMANs */
+
+	if (gaudi->hw_cap_initialized & HW_CAP_NIC0)
+		WREG32(mmNIC0_QM0_GLBL_CFG1,
+				NIC0_QM0_GLBL_CFG1_PQF_STOP_MASK |
+				NIC0_QM0_GLBL_CFG1_CQF_STOP_MASK |
+				NIC0_QM0_GLBL_CFG1_CP_STOP_MASK);
+
+	if (gaudi->hw_cap_initialized & HW_CAP_NIC1)
+		WREG32(mmNIC0_QM1_GLBL_CFG1,
+				NIC0_QM0_GLBL_CFG1_PQF_STOP_MASK |
+				NIC0_QM0_GLBL_CFG1_CQF_STOP_MASK |
+				NIC0_QM0_GLBL_CFG1_CP_STOP_MASK);
+
+	if (gaudi->hw_cap_initialized & HW_CAP_NIC2)
+		WREG32(mmNIC1_QM0_GLBL_CFG1,
+				NIC0_QM0_GLBL_CFG1_PQF_STOP_MASK |
+				NIC0_QM0_GLBL_CFG1_CQF_STOP_MASK |
+				NIC0_QM0_GLBL_CFG1_CP_STOP_MASK);
+
+	if (gaudi->hw_cap_initialized & HW_CAP_NIC3)
+		WREG32(mmNIC1_QM1_GLBL_CFG1,
+				NIC0_QM0_GLBL_CFG1_PQF_STOP_MASK |
+				NIC0_QM0_GLBL_CFG1_CQF_STOP_MASK |
+				NIC0_QM0_GLBL_CFG1_CP_STOP_MASK);
+
+	if (gaudi->hw_cap_initialized & HW_CAP_NIC4)
+		WREG32(mmNIC2_QM0_GLBL_CFG1,
+				NIC0_QM0_GLBL_CFG1_PQF_STOP_MASK |
+				NIC0_QM0_GLBL_CFG1_CQF_STOP_MASK |
+				NIC0_QM0_GLBL_CFG1_CP_STOP_MASK);
+
+	if (gaudi->hw_cap_initialized & HW_CAP_NIC5)
+		WREG32(mmNIC2_QM1_GLBL_CFG1,
+				NIC0_QM0_GLBL_CFG1_PQF_STOP_MASK |
+				NIC0_QM0_GLBL_CFG1_CQF_STOP_MASK |
+				NIC0_QM0_GLBL_CFG1_CP_STOP_MASK);
+
+	if (gaudi->hw_cap_initialized & HW_CAP_NIC6)
+		WREG32(mmNIC3_QM0_GLBL_CFG1,
+				NIC0_QM0_GLBL_CFG1_PQF_STOP_MASK |
+				NIC0_QM0_GLBL_CFG1_CQF_STOP_MASK |
+				NIC0_QM0_GLBL_CFG1_CP_STOP_MASK);
+
+	if (gaudi->hw_cap_initialized & HW_CAP_NIC7)
+		WREG32(mmNIC3_QM1_GLBL_CFG1,
+				NIC0_QM0_GLBL_CFG1_PQF_STOP_MASK |
+				NIC0_QM0_GLBL_CFG1_CQF_STOP_MASK |
+				NIC0_QM0_GLBL_CFG1_CP_STOP_MASK);
+
+	if (gaudi->hw_cap_initialized & HW_CAP_NIC8)
+		WREG32(mmNIC4_QM0_GLBL_CFG1,
+				NIC0_QM0_GLBL_CFG1_PQF_STOP_MASK |
+				NIC0_QM0_GLBL_CFG1_CQF_STOP_MASK |
+				NIC0_QM0_GLBL_CFG1_CP_STOP_MASK);
+
+	if (gaudi->hw_cap_initialized & HW_CAP_NIC9)
+		WREG32(mmNIC4_QM1_GLBL_CFG1,
+				NIC0_QM0_GLBL_CFG1_PQF_STOP_MASK |
+				NIC0_QM0_GLBL_CFG1_CQF_STOP_MASK |
+				NIC0_QM0_GLBL_CFG1_CP_STOP_MASK);
+}
+
 static void gaudi_pci_dma_stall(struct hl_device *hdev)
 {
 	struct gaudi_device *gaudi = hdev->asic_specific;
@@ -2631,6 +2873,7 @@ static void gaudi_halt_engines(struct hl_device *hdev, bool hard_reset)
 	else
 		wait_timeout_ms = GAUDI_RESET_WAIT_MSEC;
 
+	gaudi_stop_nic_qmans(hdev);
 
 	gaudi_stop_mme_qmans(hdev);
 	gaudi_stop_tpc_qmans(hdev);
@@ -2648,6 +2891,7 @@ static void gaudi_halt_engines(struct hl_device *hdev, bool hard_reset)
 
 	msleep(wait_timeout_ms);
 
+	gaudi_disable_nic_qmans(hdev);
 	gaudi_disable_mme_qmans(hdev);
 	gaudi_disable_tpc_qmans(hdev);
 	gaudi_disable_hbm_dma_qmans(hdev);
@@ -2963,11 +3207,13 @@ static int gaudi_hw_init(struct hl_device *hdev)
 
 	gaudi_init_tpc_qmans(hdev);
 
+	gaudi_init_nic_qmans(hdev);
+
 	hdev->asic_funcs->set_clock_gating(hdev);
 
 	gaudi_enable_timestamp(hdev);
 
-	/* MSI must be enabled before CPU queues are initialized */
+	/* MSI must be enabled before CPU queues and NIC are initialized */
 	rc = gaudi_enable_msi(hdev);
 	if (rc)
 		goto disable_queues;
@@ -3066,7 +3312,7 @@ static void gaudi_hw_fini(struct hl_device *hdev, bool hard_reset)
 					HW_CAP_HBM | HW_CAP_PCI_DMA |
 					HW_CAP_MME | HW_CAP_TPC_MASK |
 					HW_CAP_HBM_DMA | HW_CAP_PLL |
-					HW_CAP_MMU |
+					HW_CAP_NIC_MASK | HW_CAP_MMU |
 					HW_CAP_SRAM_SCRAMBLER |
 					HW_CAP_HBM_SCRAMBLER |
 					HW_CAP_CLK_GATE);
@@ -3336,6 +3582,166 @@ static void gaudi_ring_doorbell(struct hl_device *hdev, u32 hw_queue_id, u32 pi)
 		db_reg_offset = mmTPC7_QM_PQ_PI_3;
 		break;
 
+	case GAUDI_QUEUE_ID_NIC_0_0:
+		db_reg_offset = mmNIC0_QM0_PQ_PI_0;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_0_1:
+		db_reg_offset = mmNIC0_QM0_PQ_PI_1;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_0_2:
+		db_reg_offset = mmNIC0_QM0_PQ_PI_2;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_0_3:
+		db_reg_offset = mmNIC0_QM0_PQ_PI_3;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_1_0:
+		db_reg_offset = mmNIC0_QM1_PQ_PI_0;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_1_1:
+		db_reg_offset = mmNIC0_QM1_PQ_PI_1;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_1_2:
+		db_reg_offset = mmNIC0_QM1_PQ_PI_2;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_1_3:
+		db_reg_offset = mmNIC0_QM1_PQ_PI_3;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_2_0:
+		db_reg_offset = mmNIC1_QM0_PQ_PI_0;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_2_1:
+		db_reg_offset = mmNIC1_QM0_PQ_PI_1;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_2_2:
+		db_reg_offset = mmNIC1_QM0_PQ_PI_2;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_2_3:
+		db_reg_offset = mmNIC1_QM0_PQ_PI_3;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_3_0:
+		db_reg_offset = mmNIC1_QM1_PQ_PI_0;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_3_1:
+		db_reg_offset = mmNIC1_QM1_PQ_PI_1;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_3_2:
+		db_reg_offset = mmNIC1_QM1_PQ_PI_2;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_3_3:
+		db_reg_offset = mmNIC1_QM1_PQ_PI_3;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_4_0:
+		db_reg_offset = mmNIC2_QM0_PQ_PI_0;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_4_1:
+		db_reg_offset = mmNIC2_QM0_PQ_PI_1;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_4_2:
+		db_reg_offset = mmNIC2_QM0_PQ_PI_2;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_4_3:
+		db_reg_offset = mmNIC2_QM0_PQ_PI_3;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_5_0:
+		db_reg_offset = mmNIC2_QM1_PQ_PI_0;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_5_1:
+		db_reg_offset = mmNIC2_QM1_PQ_PI_1;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_5_2:
+		db_reg_offset = mmNIC2_QM1_PQ_PI_2;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_5_3:
+		db_reg_offset = mmNIC2_QM1_PQ_PI_3;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_6_0:
+		db_reg_offset = mmNIC3_QM0_PQ_PI_0;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_6_1:
+		db_reg_offset = mmNIC3_QM0_PQ_PI_1;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_6_2:
+		db_reg_offset = mmNIC3_QM0_PQ_PI_2;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_6_3:
+		db_reg_offset = mmNIC3_QM0_PQ_PI_3;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_7_0:
+		db_reg_offset = mmNIC3_QM1_PQ_PI_0;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_7_1:
+		db_reg_offset = mmNIC3_QM1_PQ_PI_1;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_7_2:
+		db_reg_offset = mmNIC3_QM1_PQ_PI_2;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_7_3:
+		db_reg_offset = mmNIC3_QM1_PQ_PI_3;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_8_0:
+		db_reg_offset = mmNIC4_QM0_PQ_PI_0;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_8_1:
+		db_reg_offset = mmNIC4_QM0_PQ_PI_1;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_8_2:
+		db_reg_offset = mmNIC4_QM0_PQ_PI_2;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_8_3:
+		db_reg_offset = mmNIC4_QM0_PQ_PI_3;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_9_0:
+		db_reg_offset = mmNIC4_QM1_PQ_PI_0;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_9_1:
+		db_reg_offset = mmNIC4_QM1_PQ_PI_1;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_9_2:
+		db_reg_offset = mmNIC4_QM1_PQ_PI_2;
+		break;
+
+	case GAUDI_QUEUE_ID_NIC_9_3:
+		db_reg_offset = mmNIC4_QM1_PQ_PI_3;
+		break;
+
 	default:
 		invalid_queue = true;
 	}
@@ -4230,6 +4636,17 @@ static int gaudi_parse_cb_no_ext_queue(struct hl_device *hdev,
 					struct hl_cs_parser *parser)
 {
 	struct asic_fixed_properties *asic_prop = &hdev->asic_prop;
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	u32 nic_mask_q_id = 1 << (HW_CAP_NIC_SHIFT +
+		((parser->hw_queue_id - GAUDI_QUEUE_ID_NIC_0_0) >> 2));
+
+	if ((parser->hw_queue_id >= GAUDI_QUEUE_ID_NIC_0_0) &&
+			(parser->hw_queue_id <= GAUDI_QUEUE_ID_NIC_9_3) &&
+			(!(gaudi->hw_cap_initialized & nic_mask_q_id))) {
+		dev_err(hdev->dev, "h/w queue %d is disabled\n",
+				parser->hw_queue_id);
+		return -EINVAL;
+	}
 
 	/* For internal queue jobs just check if CB address is valid */
 	if (hl_mem_area_inside_range((u64) (uintptr_t) parser->user_cb,
@@ -4463,6 +4880,12 @@ static void gaudi_restore_qm_registers(struct hl_device *hdev)
 		qman_offset = i * TPC_QMAN_OFFSET;
 		WREG32(mmTPC0_QM_ARB_CFG_0 + qman_offset, 0);
 	}
+
+	for (i = 0 ; i < NIC_NUMBER_OF_ENGINES ; i++) {
+		qman_offset = (i >> 1) * NIC_MACRO_QMAN_OFFSET +
+				(i & 0x1) * NIC_ENGINE_QMAN_OFFSET;
+		WREG32(mmNIC0_QM0_ARB_CFG_0 + qman_offset, 0);
+	}
 }
 
 static void gaudi_restore_user_registers(struct hl_device *hdev)
@@ -4897,6 +5320,136 @@ static void gaudi_mmu_prepare(struct hl_device *hdev, u32 asid)
 	gaudi_mmu_prepare_reg(hdev, mmMME2_ACC_WBC, asid);
 	gaudi_mmu_prepare_reg(hdev, mmMME3_ACC_WBC, asid);
 
+	if (hdev->nic_ports_mask & GAUDI_NIC_MASK_NIC0) {
+		gaudi_mmu_prepare_reg(hdev, mmNIC0_QM0_GLBL_NON_SECURE_PROPS_0,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC0_QM0_GLBL_NON_SECURE_PROPS_1,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC0_QM0_GLBL_NON_SECURE_PROPS_2,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC0_QM0_GLBL_NON_SECURE_PROPS_3,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC0_QM0_GLBL_NON_SECURE_PROPS_4,
+				asid);
+	}
+
+	if (hdev->nic_ports_mask & GAUDI_NIC_MASK_NIC1) {
+		gaudi_mmu_prepare_reg(hdev, mmNIC0_QM1_GLBL_NON_SECURE_PROPS_0,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC0_QM1_GLBL_NON_SECURE_PROPS_1,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC0_QM1_GLBL_NON_SECURE_PROPS_2,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC0_QM1_GLBL_NON_SECURE_PROPS_3,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC0_QM1_GLBL_NON_SECURE_PROPS_4,
+				asid);
+	}
+
+	if (hdev->nic_ports_mask & GAUDI_NIC_MASK_NIC2) {
+		gaudi_mmu_prepare_reg(hdev, mmNIC1_QM0_GLBL_NON_SECURE_PROPS_0,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC1_QM0_GLBL_NON_SECURE_PROPS_1,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC1_QM0_GLBL_NON_SECURE_PROPS_2,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC1_QM0_GLBL_NON_SECURE_PROPS_3,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC1_QM0_GLBL_NON_SECURE_PROPS_4,
+				asid);
+	}
+
+	if (hdev->nic_ports_mask & GAUDI_NIC_MASK_NIC3) {
+		gaudi_mmu_prepare_reg(hdev, mmNIC1_QM1_GLBL_NON_SECURE_PROPS_0,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC1_QM1_GLBL_NON_SECURE_PROPS_1,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC1_QM1_GLBL_NON_SECURE_PROPS_2,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC1_QM1_GLBL_NON_SECURE_PROPS_3,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC1_QM1_GLBL_NON_SECURE_PROPS_4,
+				asid);
+	}
+
+	if (hdev->nic_ports_mask & GAUDI_NIC_MASK_NIC4) {
+		gaudi_mmu_prepare_reg(hdev, mmNIC2_QM0_GLBL_NON_SECURE_PROPS_0,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC2_QM0_GLBL_NON_SECURE_PROPS_1,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC2_QM0_GLBL_NON_SECURE_PROPS_2,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC2_QM0_GLBL_NON_SECURE_PROPS_3,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC2_QM0_GLBL_NON_SECURE_PROPS_4,
+				asid);
+	}
+
+	if (hdev->nic_ports_mask & GAUDI_NIC_MASK_NIC5) {
+		gaudi_mmu_prepare_reg(hdev, mmNIC2_QM1_GLBL_NON_SECURE_PROPS_0,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC2_QM1_GLBL_NON_SECURE_PROPS_1,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC2_QM1_GLBL_NON_SECURE_PROPS_2,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC2_QM1_GLBL_NON_SECURE_PROPS_3,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC2_QM1_GLBL_NON_SECURE_PROPS_4,
+				asid);
+	}
+
+	if (hdev->nic_ports_mask & GAUDI_NIC_MASK_NIC6) {
+		gaudi_mmu_prepare_reg(hdev, mmNIC3_QM0_GLBL_NON_SECURE_PROPS_0,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC3_QM0_GLBL_NON_SECURE_PROPS_1,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC3_QM0_GLBL_NON_SECURE_PROPS_2,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC3_QM0_GLBL_NON_SECURE_PROPS_3,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC3_QM0_GLBL_NON_SECURE_PROPS_4,
+				asid);
+	}
+
+	if (hdev->nic_ports_mask & GAUDI_NIC_MASK_NIC7) {
+		gaudi_mmu_prepare_reg(hdev, mmNIC3_QM1_GLBL_NON_SECURE_PROPS_0,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC3_QM1_GLBL_NON_SECURE_PROPS_1,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC3_QM1_GLBL_NON_SECURE_PROPS_2,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC3_QM1_GLBL_NON_SECURE_PROPS_3,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC3_QM1_GLBL_NON_SECURE_PROPS_4,
+				asid);
+	}
+
+	if (hdev->nic_ports_mask & GAUDI_NIC_MASK_NIC8) {
+		gaudi_mmu_prepare_reg(hdev, mmNIC4_QM0_GLBL_NON_SECURE_PROPS_0,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC4_QM0_GLBL_NON_SECURE_PROPS_1,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC4_QM0_GLBL_NON_SECURE_PROPS_2,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC4_QM0_GLBL_NON_SECURE_PROPS_3,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC4_QM0_GLBL_NON_SECURE_PROPS_4,
+				asid);
+	}
+
+	if (hdev->nic_ports_mask & GAUDI_NIC_MASK_NIC9) {
+		gaudi_mmu_prepare_reg(hdev, mmNIC4_QM1_GLBL_NON_SECURE_PROPS_0,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC4_QM1_GLBL_NON_SECURE_PROPS_1,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC4_QM1_GLBL_NON_SECURE_PROPS_2,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC4_QM1_GLBL_NON_SECURE_PROPS_3,
+				asid);
+		gaudi_mmu_prepare_reg(hdev, mmNIC4_QM1_GLBL_NON_SECURE_PROPS_4,
+				asid);
+	}
+
 	gaudi_mmu_prepare_reg(hdev, mmPSOC_GLOBAL_CONF_TRACE_ARUSER, asid);
 	gaudi_mmu_prepare_reg(hdev, mmPSOC_GLOBAL_CONF_TRACE_AWUSER, asid);
 
@@ -5426,6 +5979,8 @@ static void gaudi_handle_ecc_event(struct hl_device *hdev, u16 event_type,
 		params.num_memories = 33;
 		params.derr = true;
 		params.disable_clock_gating = true;
+		extract_info_from_fw = false;
+		break;
 	default:
 		return;
 	}
@@ -5477,6 +6032,56 @@ static void gaudi_handle_qman_err(struct hl_device *hdev, u16 event_type)
 			mmDMA0_QM_ARB_ERR_CAUSE + index * DMA_QMAN_OFFSET;
 		snprintf(desc, ARRAY_SIZE(desc), "%s%d", "DMA_QM", index);
 		break;
+	case GAUDI_EVENT_NIC0_QM0:
+		glbl_sts_addr = mmNIC0_QM0_GLBL_STS1_0;
+		arb_err_addr = mmNIC0_QM0_ARB_ERR_CAUSE;
+		snprintf(desc, ARRAY_SIZE(desc), "NIC0_QM0");
+		break;
+	case GAUDI_EVENT_NIC0_QM1:
+		glbl_sts_addr = mmNIC0_QM1_GLBL_STS1_0;
+		arb_err_addr = mmNIC0_QM1_ARB_ERR_CAUSE;
+		snprintf(desc, ARRAY_SIZE(desc), "NIC0_QM1");
+		break;
+	case GAUDI_EVENT_NIC1_QM0:
+		glbl_sts_addr = mmNIC1_QM0_GLBL_STS1_0;
+		arb_err_addr = mmNIC1_QM0_ARB_ERR_CAUSE;
+		snprintf(desc, ARRAY_SIZE(desc), "NIC1_QM0");
+		break;
+	case GAUDI_EVENT_NIC1_QM1:
+		glbl_sts_addr = mmNIC1_QM1_GLBL_STS1_0;
+		arb_err_addr = mmNIC1_QM1_ARB_ERR_CAUSE;
+		snprintf(desc, ARRAY_SIZE(desc), "NIC1_QM1");
+		break;
+	case GAUDI_EVENT_NIC2_QM0:
+		glbl_sts_addr = mmNIC2_QM0_GLBL_STS1_0;
+		arb_err_addr = mmNIC2_QM0_ARB_ERR_CAUSE;
+		snprintf(desc, ARRAY_SIZE(desc), "NIC2_QM0");
+		break;
+	case GAUDI_EVENT_NIC2_QM1:
+		glbl_sts_addr = mmNIC2_QM1_GLBL_STS1_0;
+		arb_err_addr = mmNIC2_QM1_ARB_ERR_CAUSE;
+		snprintf(desc, ARRAY_SIZE(desc), "NIC2_QM1");
+		break;
+	case GAUDI_EVENT_NIC3_QM0:
+		glbl_sts_addr = mmNIC3_QM0_GLBL_STS1_0;
+		arb_err_addr = mmNIC3_QM0_ARB_ERR_CAUSE;
+		snprintf(desc, ARRAY_SIZE(desc), "NIC3_QM0");
+		break;
+	case GAUDI_EVENT_NIC3_QM1:
+		glbl_sts_addr = mmNIC3_QM1_GLBL_STS1_0;
+		arb_err_addr = mmNIC3_QM1_ARB_ERR_CAUSE;
+		snprintf(desc, ARRAY_SIZE(desc), "NIC3_QM1");
+		break;
+	case GAUDI_EVENT_NIC4_QM0:
+		glbl_sts_addr = mmNIC4_QM0_GLBL_STS1_0;
+		arb_err_addr = mmNIC4_QM0_ARB_ERR_CAUSE;
+		snprintf(desc, ARRAY_SIZE(desc), "NIC4_QM0");
+		break;
+	case GAUDI_EVENT_NIC4_QM1:
+		glbl_sts_addr = mmNIC4_QM1_GLBL_STS1_0;
+		arb_err_addr = mmNIC4_QM1_ARB_ERR_CAUSE;
+		snprintf(desc, ARRAY_SIZE(desc), "NIC4_QM1");
+		break;
 	default:
 		return;
 	}
@@ -5854,6 +6459,16 @@ static void gaudi_handle_eqe(struct hl_device *hdev,
 	case GAUDI_EVENT_MME0_QM ... GAUDI_EVENT_MME2_QM:
 	case GAUDI_EVENT_DMA0_QM ... GAUDI_EVENT_DMA7_QM:
 		fallthrough;
+	case GAUDI_EVENT_NIC0_QM0:
+	case GAUDI_EVENT_NIC0_QM1:
+	case GAUDI_EVENT_NIC1_QM0:
+	case GAUDI_EVENT_NIC1_QM1:
+	case GAUDI_EVENT_NIC2_QM0:
+	case GAUDI_EVENT_NIC2_QM1:
+	case GAUDI_EVENT_NIC3_QM0:
+	case GAUDI_EVENT_NIC3_QM1:
+	case GAUDI_EVENT_NIC4_QM0:
+	case GAUDI_EVENT_NIC4_QM1:
 	case GAUDI_EVENT_DMA0_CORE ... GAUDI_EVENT_DMA7_CORE:
 		gaudi_print_irq_info(hdev, event_type, true);
 		gaudi_handle_qman_err(hdev, event_type);
@@ -6087,10 +6702,11 @@ static bool gaudi_is_device_idle(struct hl_device *hdev, u64 *mask,
 	struct gaudi_device *gaudi = hdev->asic_specific;
 	const char *fmt = "%-5d%-9s%#-14x%#-12x%#x\n";
 	const char *mme_slave_fmt = "%-5d%-9s%-14s%-12s%#x\n";
+	const char *nic_fmt = "%-5d%-9s%#-14x%#x\n";
 	u32 qm_glbl_sts0, qm_cgm_sts, dma_core_sts0, tpc_cfg_sts, mme_arch_sts;
 	bool is_idle = true, is_eng_idle, is_slave;
 	u64 offset;
-	int i, dma_id;
+	int i, dma_id, port;
 
 	mutex_lock(&gaudi->clk_gate_mutex);
 
@@ -6179,6 +6795,45 @@ static bool gaudi_is_device_idle(struct hl_device *hdev, u64 *mask,
 		}
 	}
 
+	if (s)
+		seq_puts(s, "\nNIC  is_idle  QM_GLBL_STS0  QM_CGM_STS\n"
+				"---  -------  ------------  ----------\n");
+
+	for (i = 0 ; i < (NIC_NUMBER_OF_ENGINES / 2) ; i++) {
+		offset = i * NIC_MACRO_QMAN_OFFSET;
+		port = 2 * i;
+		if (hdev->nic_ports_mask & BIT(port)) {
+			qm_glbl_sts0 = RREG32(mmNIC0_QM0_GLBL_STS0 + offset);
+			qm_cgm_sts = RREG32(mmNIC0_QM0_CGM_STS + offset);
+			is_eng_idle = IS_QM_IDLE(qm_glbl_sts0, qm_cgm_sts);
+			is_idle &= is_eng_idle;
+
+			if (mask)
+				*mask |= ((u64) !is_eng_idle) <<
+						(GAUDI_ENGINE_ID_NIC_0 + port);
+			if (s)
+				seq_printf(s, nic_fmt, port,
+						is_eng_idle ? "Y" : "N",
+						qm_glbl_sts0, qm_cgm_sts);
+		}
+
+		port = 2 * i + 1;
+		if (hdev->nic_ports_mask & BIT(port)) {
+			qm_glbl_sts0 = RREG32(mmNIC0_QM1_GLBL_STS0 + offset);
+			qm_cgm_sts = RREG32(mmNIC0_QM1_CGM_STS + offset);
+			is_eng_idle = IS_QM_IDLE(qm_glbl_sts0, qm_cgm_sts);
+			is_idle &= is_eng_idle;
+
+			if (mask)
+				*mask |= ((u64) !is_eng_idle) <<
+						(GAUDI_ENGINE_ID_NIC_0 + port);
+			if (s)
+				seq_printf(s, nic_fmt, port,
+						is_eng_idle ? "Y" : "N",
+						qm_glbl_sts0, qm_cgm_sts);
+		}
+	}
+
 	if (s)
 		seq_puts(s, "\n");
 
diff --git a/drivers/misc/habanalabs/gaudi/gaudiP.h b/drivers/misc/habanalabs/gaudi/gaudiP.h
index dd222bc128f9..2ccf7e5a97c7 100644
--- a/drivers/misc/habanalabs/gaudi/gaudiP.h
+++ b/drivers/misc/habanalabs/gaudi/gaudiP.h
@@ -79,6 +79,7 @@
 #define TPC_QMAN_OFFSET		(mmTPC1_QM_BASE - mmTPC0_QM_BASE)
 #define MME_QMAN_OFFSET		(mmMME1_QM_BASE - mmMME0_QM_BASE)
 #define NIC_MACRO_QMAN_OFFSET	(mmNIC1_QM0_BASE - mmNIC0_QM0_BASE)
+#define NIC_ENGINE_QMAN_OFFSET	(mmNIC0_QM1_BASE - mmNIC0_QM0_BASE)
 
 #define TPC_CFG_OFFSET		(mmTPC1_CFG_BASE - mmTPC0_CFG_BASE)
 
@@ -132,6 +133,10 @@
 #define TPC_QMAN_LENGTH			1024
 #define TPC_QMAN_SIZE_IN_BYTES		(TPC_QMAN_LENGTH * QMAN_PQ_ENTRY_SIZE)
 
+#define NIC_QMAN_LENGTH			1024
+#define NIC_QMAN_SIZE_IN_BYTES		(NIC_QMAN_LENGTH * QMAN_PQ_ENTRY_SIZE)
+
+
 #define SRAM_USER_BASE_OFFSET  GAUDI_DRIVER_SRAM_RESERVED_SIZE_FROM_START
 
 /* Virtual address space */
@@ -153,6 +158,19 @@
 #define HW_CAP_SRAM_SCRAMBLER	BIT(10)
 #define HW_CAP_HBM_SCRAMBLER	BIT(11)
 
+#define HW_CAP_NIC0		BIT(14)
+#define HW_CAP_NIC1		BIT(15)
+#define HW_CAP_NIC2		BIT(16)
+#define HW_CAP_NIC3		BIT(17)
+#define HW_CAP_NIC4		BIT(18)
+#define HW_CAP_NIC5		BIT(19)
+#define HW_CAP_NIC6		BIT(20)
+#define HW_CAP_NIC7		BIT(21)
+#define HW_CAP_NIC8		BIT(22)
+#define HW_CAP_NIC9		BIT(23)
+#define HW_CAP_NIC_MASK		GENMASK(23, 14)
+#define HW_CAP_NIC_SHIFT	14
+
 #define HW_CAP_TPC0		BIT(24)
 #define HW_CAP_TPC1		BIT(25)
 #define HW_CAP_TPC2		BIT(26)
@@ -200,6 +218,20 @@ enum gaudi_tpc_mask {
 	GAUDI_TPC_MASK_ALL = 0xFF
 };
 
+enum gaudi_nic_mask {
+	GAUDI_NIC_MASK_NIC0 = 0x01,
+	GAUDI_NIC_MASK_NIC1 = 0x02,
+	GAUDI_NIC_MASK_NIC2 = 0x04,
+	GAUDI_NIC_MASK_NIC3 = 0x08,
+	GAUDI_NIC_MASK_NIC4 = 0x10,
+	GAUDI_NIC_MASK_NIC5 = 0x20,
+	GAUDI_NIC_MASK_NIC6 = 0x40,
+	GAUDI_NIC_MASK_NIC7 = 0x80,
+	GAUDI_NIC_MASK_NIC8 = 0x100,
+	GAUDI_NIC_MASK_NIC9 = 0x200,
+	GAUDI_NIC_MASK_ALL = 0x3FF
+};
+
 /**
  * struct gaudi_internal_qman_info - Internal QMAN information.
  * @pq_kernel_addr: Kernel address of the PQ memory area in the host.
-- 
2.17.1

