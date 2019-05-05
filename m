Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3FB13F28
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 13:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfEELR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 07:17:27 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44162 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbfEELRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 07:17:24 -0400
Received: by mail-pf1-f196.google.com with SMTP id y13so5205011pfm.11
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 04:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=J3HMKj04Mu1kz2vyHvcvX2eN9Jhi37W+Fybi0SzNKcs=;
        b=BWelvbnwdfWyVwAwQBExJ//Zv0usY1uqPzr8v7VHLGyy/IOSmb6OWTZIWJ915mO/+0
         zbnhyDpHQq1ys3/oECfisPfPn794SW2f3pIehXzf5fif22o7E9F+n1iSCzqBNRgHuDNA
         lII2LxQ/RevaeElK2zJ0+Z+aDibQy6ENlpzrA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=J3HMKj04Mu1kz2vyHvcvX2eN9Jhi37W+Fybi0SzNKcs=;
        b=Mlhyf3CjCcYlJDnwvDrCPNYhL+Hbjo+zd4I+Y7HksGqsCbtMGqTI2yuyroGlRy0ZML
         CbJXlPCvZqxAL5B0yLw5fP7BIFZ+13twOqGTyu7+ejxr5Sv9f16QmoJ0AqBlL49MpB2O
         lwaYc3SS8CRbL/WRzO8a8PQZIC/j5GV2Jfqg5GF8ypx+87Bzw2I4r8+DQG7apUx4cNqT
         v6j0fMMewJKDeqa+R5QKx5Um8+UpRaaUHC7iDGqq8TvbtsAHj8Jgll7wpPwp+ORRUSXz
         /yqQvewOEW2tcPbTs+DGS8icaAgKTVXRLyUaZ0K0RL7yfynlofzYB4+M+ICqEpLCrIX4
         815A==
X-Gm-Message-State: APjAAAUFbIIvtNcT/rjn0hY4s89+PbBK/Zl+i7wvsTqnsQPNb5VJAI6y
        W10PjgWrwdVv9F3BqLPZjOcIsdRqpA0=
X-Google-Smtp-Source: APXvYqz0Hjn+k2mylYYGVHCz+aMcSPb21VOeQhjUgl3ZYVA2PMMfym5uhvCOjKY2kUd+GD3GMQJIPw==
X-Received: by 2002:a63:d10:: with SMTP id c16mr23645142pgl.156.1557055042940;
        Sun, 05 May 2019 04:17:22 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id 10sm9378902pfh.14.2019.05.05.04.17.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 04:17:22 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 03/11] bnxt_en: Add support for PCIe statistics
Date:   Sun,  5 May 2019 07:17:00 -0400
Message-Id: <1557055028-14816-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
References: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Gather periodic PCIe statistics for ethtool -S.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 37 ++++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  7 ++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 39 +++++++++++++++++++++++
 3 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 1fb6d5e..b7a6005 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3396,6 +3396,12 @@ static void bnxt_free_port_stats(struct bnxt *bp)
 				  bp->hw_rx_port_stats_ext_map);
 		bp->hw_rx_port_stats_ext = NULL;
 	}
+
+	if (bp->hw_pcie_stats) {
+		dma_free_coherent(&pdev->dev, sizeof(struct pcie_ctx_hw_stats),
+				  bp->hw_pcie_stats, bp->hw_pcie_stats_map);
+		bp->hw_pcie_stats = NULL;
+	}
 }
 
 static void bnxt_free_ring_stats(struct bnxt *bp)
@@ -3477,7 +3483,7 @@ static int bnxt_alloc_stats(struct bnxt *bp)
 
 alloc_tx_ext_stats:
 	if (bp->hw_tx_port_stats_ext)
-		return 0;
+		goto alloc_pcie_stats;
 
 	if (bp->hwrm_spec_code >= 0x10902) {
 		bp->hw_tx_port_stats_ext =
@@ -3487,6 +3493,19 @@ static int bnxt_alloc_stats(struct bnxt *bp)
 					   GFP_KERNEL);
 	}
 	bp->flags |= BNXT_FLAG_PORT_STATS_EXT;
+
+alloc_pcie_stats:
+	if (bp->hw_pcie_stats ||
+	    !(bp->fw_cap & BNXT_FW_CAP_PCIE_STATS_SUPPORTED))
+		return 0;
+
+	bp->hw_pcie_stats =
+		dma_alloc_coherent(&pdev->dev, sizeof(struct pcie_ctx_hw_stats),
+				   &bp->hw_pcie_stats_map, GFP_KERNEL);
+	if (!bp->hw_pcie_stats)
+		return 0;
+
+	bp->flags |= BNXT_FLAG_PCIE_STATS;
 	return 0;
 }
 
@@ -6505,6 +6524,8 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 		bp->flags |= BNXT_FLAG_ROCEV1_CAP;
 	if (flags & FUNC_QCAPS_RESP_FLAGS_ROCE_V2_SUPPORTED)
 		bp->flags |= BNXT_FLAG_ROCEV2_CAP;
+	if (flags & FUNC_QCAPS_RESP_FLAGS_PCIE_STATS_SUPPORTED)
+		bp->fw_cap |= BNXT_FW_CAP_PCIE_STATS_SUPPORTED;
 
 	bp->tx_push_thresh = 0;
 	if (flags & FUNC_QCAPS_RESP_FLAGS_PUSH_MODE_SUPPORTED)
@@ -6805,6 +6826,19 @@ static int bnxt_hwrm_port_qstats_ext(struct bnxt *bp)
 	return rc;
 }
 
+static int bnxt_hwrm_pcie_qstats(struct bnxt *bp)
+{
+	struct hwrm_pcie_qstats_input req = {0};
+
+	if (!(bp->flags & BNXT_FLAG_PCIE_STATS))
+		return 0;
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_PCIE_QSTATS, -1, -1);
+	req.pcie_stat_size = cpu_to_le16(sizeof(struct pcie_ctx_hw_stats));
+	req.pcie_stat_host_addr = cpu_to_le64(bp->hw_pcie_stats_map);
+	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+}
+
 static void bnxt_hwrm_free_tunnel_ports(struct bnxt *bp)
 {
 	if (bp->vxlan_port_cnt) {
@@ -9395,6 +9429,7 @@ static void bnxt_sp_task(struct work_struct *work)
 	if (test_and_clear_bit(BNXT_PERIODIC_STATS_SP_EVENT, &bp->sp_event)) {
 		bnxt_hwrm_port_qstats(bp);
 		bnxt_hwrm_port_qstats_ext(bp);
+		bnxt_hwrm_pcie_qstats(bp);
 	}
 
 	if (test_and_clear_bit(BNXT_LINK_CHNG_SP_EVENT, &bp->sp_event)) {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index cf81ace..178ece3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1354,6 +1354,7 @@ struct bnxt {
 	#define BNXT_FLAG_DIM		0x2000000
 	#define BNXT_FLAG_ROCE_MIRROR_CAP	0x4000000
 	#define BNXT_FLAG_PORT_STATS_EXT	0x10000000
+	#define BNXT_FLAG_PCIE_STATS	0x40000000
 
 	#define BNXT_FLAG_ALL_CONFIG_FEATS (BNXT_FLAG_TPA |		\
 					    BNXT_FLAG_RFS |		\
@@ -1480,6 +1481,7 @@ struct bnxt {
 	#define BNXT_FW_CAP_KONG_MB_CHNL		0x00000080
 	#define BNXT_FW_CAP_OVS_64BIT_HANDLE		0x00000400
 	#define BNXT_FW_CAP_TRUSTED_VF			0x00000800
+	#define BNXT_FW_CAP_PCIE_STATS_SUPPORTED	0x00020000
 
 #define BNXT_NEW_RM(bp)		((bp)->fw_cap & BNXT_FW_CAP_NEW_RM)
 	u32			hwrm_spec_code;
@@ -1498,10 +1500,12 @@ struct bnxt {
 	struct tx_port_stats	*hw_tx_port_stats;
 	struct rx_port_stats_ext	*hw_rx_port_stats_ext;
 	struct tx_port_stats_ext	*hw_tx_port_stats_ext;
+	struct pcie_ctx_hw_stats	*hw_pcie_stats;
 	dma_addr_t		hw_rx_port_stats_map;
 	dma_addr_t		hw_tx_port_stats_map;
 	dma_addr_t		hw_rx_port_stats_ext_map;
 	dma_addr_t		hw_tx_port_stats_ext_map;
+	dma_addr_t		hw_pcie_stats_map;
 	int			hw_port_stats_size;
 	u16			fw_rx_stats_ext_size;
 	u16			fw_tx_stats_ext_size;
@@ -1634,6 +1638,9 @@ struct bnxt {
 #define BNXT_TX_STATS_EXT_OFFSET(counter)		\
 	(offsetof(struct tx_port_stats_ext, counter) / 8)
 
+#define BNXT_PCIE_STATS_OFFSET(counter)			\
+	(offsetof(struct pcie_ctx_hw_stats, counter) / 8)
+
 #define I2C_DEV_ADDR_A0				0xa0
 #define I2C_DEV_ADDR_A2				0xa2
 #define SFF_DIAG_SUPPORT_OFFSET			0x5c
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index a3e6a7d..bdd9d16 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -235,6 +235,9 @@ static int bnxt_set_coalesce(struct net_device *dev,
 	BNXT_TX_STATS_PRI_ENTRY(counter, 6),		\
 	BNXT_TX_STATS_PRI_ENTRY(counter, 7)
 
+#define BNXT_PCIE_STATS_ENTRY(counter)	\
+	{ BNXT_PCIE_STATS_OFFSET(counter), __stringify(counter) }
+
 enum {
 	RX_TOTAL_DISCARDS,
 	TX_TOTAL_DISCARDS,
@@ -387,6 +390,24 @@ static const struct {
 	BNXT_TX_STATS_PRI_ENTRIES(tx_packets),
 };
 
+static const struct {
+	long offset;
+	char string[ETH_GSTRING_LEN];
+} bnxt_pcie_stats_arr[] = {
+	BNXT_PCIE_STATS_ENTRY(pcie_pl_signal_integrity),
+	BNXT_PCIE_STATS_ENTRY(pcie_dl_signal_integrity),
+	BNXT_PCIE_STATS_ENTRY(pcie_tl_signal_integrity),
+	BNXT_PCIE_STATS_ENTRY(pcie_link_integrity),
+	BNXT_PCIE_STATS_ENTRY(pcie_tx_traffic_rate),
+	BNXT_PCIE_STATS_ENTRY(pcie_rx_traffic_rate),
+	BNXT_PCIE_STATS_ENTRY(pcie_tx_dllp_statistics),
+	BNXT_PCIE_STATS_ENTRY(pcie_rx_dllp_statistics),
+	BNXT_PCIE_STATS_ENTRY(pcie_equalization_time),
+	BNXT_PCIE_STATS_ENTRY(pcie_ltssm_histogram[0]),
+	BNXT_PCIE_STATS_ENTRY(pcie_ltssm_histogram[2]),
+	BNXT_PCIE_STATS_ENTRY(pcie_recovery_histogram),
+};
+
 #define BNXT_NUM_SW_FUNC_STATS	ARRAY_SIZE(bnxt_sw_func_stats)
 #define BNXT_NUM_PORT_STATS ARRAY_SIZE(bnxt_port_stats_arr)
 #define BNXT_NUM_STATS_PRI			\
@@ -394,6 +415,7 @@ static const struct {
 	 ARRAY_SIZE(bnxt_rx_pkts_pri_arr) +	\
 	 ARRAY_SIZE(bnxt_tx_bytes_pri_arr) +	\
 	 ARRAY_SIZE(bnxt_tx_pkts_pri_arr))
+#define BNXT_NUM_PCIE_STATS ARRAY_SIZE(bnxt_pcie_stats_arr)
 
 static int bnxt_get_num_stats(struct bnxt *bp)
 {
@@ -411,6 +433,9 @@ static int bnxt_get_num_stats(struct bnxt *bp)
 			num_stats += BNXT_NUM_STATS_PRI;
 	}
 
+	if (bp->flags & BNXT_FLAG_PCIE_STATS)
+		num_stats += BNXT_NUM_PCIE_STATS;
+
 	return num_stats;
 }
 
@@ -513,6 +538,14 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 			}
 		}
 	}
+	if (bp->flags & BNXT_FLAG_PCIE_STATS) {
+		__le64 *pcie_stats = (__le64 *)bp->hw_pcie_stats;
+
+		for (i = 0; i < BNXT_NUM_PCIE_STATS; i++, j++) {
+			buf[j] = le64_to_cpu(*(pcie_stats +
+					       bnxt_pcie_stats_arr[i].offset));
+		}
+	}
 }
 
 static void bnxt_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
@@ -613,6 +646,12 @@ static void bnxt_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 				}
 			}
 		}
+		if (bp->flags & BNXT_FLAG_PCIE_STATS) {
+			for (i = 0; i < BNXT_NUM_PCIE_STATS; i++) {
+				strcpy(buf, bnxt_pcie_stats_arr[i].string);
+				buf += ETH_GSTRING_LEN;
+			}
+		}
 		break;
 	case ETH_SS_TEST:
 		if (bp->num_tests)
-- 
2.5.1

