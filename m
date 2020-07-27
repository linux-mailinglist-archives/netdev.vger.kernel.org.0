Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A328722E945
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgG0JlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG0JlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:41:09 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA2DC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:41:09 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 74so523718pfx.13
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5ehjWmpfD+vv37y9fplu9sx1jtI3E8i6K0lrnAzmwqU=;
        b=CuqfzY/FrRvVVPdQOubasO+Km3b4cZ9xgrhbTpUCWHbPL4Wpw68sg8/cyC3LBMb8aK
         aciQYHCdgTv7c029VG1c1PLMGFLOqAMEkZdt4nIXaUjtOzmJSrsJTEqc+x8WTX0TxqjW
         XLlTCxeRuBi8ODWlI8zjsxa08BArRlG9Qcbu4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5ehjWmpfD+vv37y9fplu9sx1jtI3E8i6K0lrnAzmwqU=;
        b=H5eKD9OkrPntCimURBiEkegxlxuJ5RN7nBBzuw9Tu0RZ9Ox/KDzoMLUeLv9paRQQjc
         A/FbvhB4JEwLYsrEruOA9eFAWYBLddEp3WLH3GMD3rKa3zRXQ6x2g+xUBwd1/7T0t+7S
         BnWtYMwwuh+B0hg+r1rU1fgp6BHuR672VnowMstpRF/fgOvyVn+TBN4oECuzuVMED4r0
         e5TBmG3hlhPi8Gn1MAr7kXNqVvbi8RI89ZVAsIjTnM8KBy2OVPjhMuDUuVDH7LLTQVmP
         ttwsBzqOEB32CWPbFbmhEethFaJHQQjwNgCU4c97ga194/yva2VdyzfBOPTDUqnnnLUk
         b75A==
X-Gm-Message-State: AOAM532XxDfHbzgUCK4TN0aFFqa3W3WcvRbRgNa+5bzHie+Vg/WesKmF
        YtwdizKcWoAzbFD+BH1lUc7p7w==
X-Google-Smtp-Source: ABdhPJwnqux8hgTjRPYjib/98PgSAHt+v8U3LWcCtnb1/3+qHW4Q5kZHJjIvPfvCRX+4k2Ujf4XedQ==
X-Received: by 2002:aa7:9a03:: with SMTP id w3mr18963729pfj.228.1595842868413;
        Mon, 27 Jul 2020 02:41:08 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f131sm14560945pgc.14.2020.07.27.02.41.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jul 2020 02:41:07 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next v2 01/10] bnxt_en: Remove PCIe non-counters from ethtool statistics
Date:   Mon, 27 Jul 2020 05:40:36 -0400
Message-Id: <1595842845-19403-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595842845-19403-1-git-send-email-michael.chan@broadcom.com>
References: <1595842845-19403-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Remove PCIe non-counters display from ethtool statistics, as
they are not simple counters but register dump.  The next few
patches will add logic to detect counter roll-over and it won't
work with these PCIe non-counters.

There will be a follow up patch to get PCIe information via
ethtool register dump.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 35 +-------------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  6 ----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 39 -----------------------
 3 files changed, 1 insertion(+), 79 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a7e5ebe..b294de1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3730,12 +3730,6 @@ static void bnxt_free_port_stats(struct bnxt *bp)
 				  bp->hw_rx_port_stats_ext_map);
 		bp->hw_rx_port_stats_ext = NULL;
 	}
-
-	if (bp->hw_pcie_stats) {
-		dma_free_coherent(&pdev->dev, sizeof(struct pcie_ctx_hw_stats),
-				  bp->hw_pcie_stats, bp->hw_pcie_stats_map);
-		bp->hw_pcie_stats = NULL;
-	}
 }
 
 static void bnxt_free_ring_stats(struct bnxt *bp)
@@ -3818,7 +3812,7 @@ static int bnxt_alloc_stats(struct bnxt *bp)
 
 alloc_tx_ext_stats:
 	if (bp->hw_tx_port_stats_ext)
-		goto alloc_pcie_stats;
+		return 0;
 
 	if (bp->hwrm_spec_code >= 0x10902 ||
 	    (bp->fw_cap & BNXT_FW_CAP_EXT_STATS_SUPPORTED)) {
@@ -3829,19 +3823,6 @@ static int bnxt_alloc_stats(struct bnxt *bp)
 					   GFP_KERNEL);
 	}
 	bp->flags |= BNXT_FLAG_PORT_STATS_EXT;
-
-alloc_pcie_stats:
-	if (bp->hw_pcie_stats ||
-	    !(bp->fw_cap & BNXT_FW_CAP_PCIE_STATS_SUPPORTED))
-		return 0;
-
-	bp->hw_pcie_stats =
-		dma_alloc_coherent(&pdev->dev, sizeof(struct pcie_ctx_hw_stats),
-				   &bp->hw_pcie_stats_map, GFP_KERNEL);
-	if (!bp->hw_pcie_stats)
-		return 0;
-
-	bp->flags |= BNXT_FLAG_PCIE_STATS;
 	return 0;
 }
 
@@ -7566,19 +7547,6 @@ static int bnxt_hwrm_port_qstats_ext(struct bnxt *bp)
 	return rc;
 }
 
-static int bnxt_hwrm_pcie_qstats(struct bnxt *bp)
-{
-	struct hwrm_pcie_qstats_input req = {0};
-
-	if (!(bp->flags & BNXT_FLAG_PCIE_STATS))
-		return 0;
-
-	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_PCIE_QSTATS, -1, -1);
-	req.pcie_stat_size = cpu_to_le16(sizeof(struct pcie_ctx_hw_stats));
-	req.pcie_stat_host_addr = cpu_to_le64(bp->hw_pcie_stats_map);
-	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-}
-
 static void bnxt_hwrm_free_tunnel_ports(struct bnxt *bp)
 {
 	if (bp->vxlan_fw_dst_port_id != INVALID_HW_RING_ID)
@@ -10458,7 +10426,6 @@ static void bnxt_sp_task(struct work_struct *work)
 	if (test_and_clear_bit(BNXT_PERIODIC_STATS_SP_EVENT, &bp->sp_event)) {
 		bnxt_hwrm_port_qstats(bp);
 		bnxt_hwrm_port_qstats_ext(bp);
-		bnxt_hwrm_pcie_qstats(bp);
 	}
 
 	if (test_and_clear_bit(BNXT_LINK_CHNG_SP_EVENT, &bp->sp_event)) {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 2acd7f9..10286cb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1566,7 +1566,6 @@ struct bnxt {
 	#define BNXT_FLAG_DIM		0x2000000
 	#define BNXT_FLAG_ROCE_MIRROR_CAP	0x4000000
 	#define BNXT_FLAG_PORT_STATS_EXT	0x10000000
-	#define BNXT_FLAG_PCIE_STATS	0x40000000
 
 	#define BNXT_FLAG_ALL_CONFIG_FEATS (BNXT_FLAG_TPA |		\
 					    BNXT_FLAG_RFS |		\
@@ -1737,12 +1736,10 @@ struct bnxt {
 	struct tx_port_stats	*hw_tx_port_stats;
 	struct rx_port_stats_ext	*hw_rx_port_stats_ext;
 	struct tx_port_stats_ext	*hw_tx_port_stats_ext;
-	struct pcie_ctx_hw_stats	*hw_pcie_stats;
 	dma_addr_t		hw_rx_port_stats_map;
 	dma_addr_t		hw_tx_port_stats_map;
 	dma_addr_t		hw_rx_port_stats_ext_map;
 	dma_addr_t		hw_tx_port_stats_ext_map;
-	dma_addr_t		hw_pcie_stats_map;
 	int			hw_port_stats_size;
 	u16			fw_rx_stats_ext_size;
 	u16			fw_tx_stats_ext_size;
@@ -1898,9 +1895,6 @@ struct bnxt {
 #define BNXT_TX_STATS_EXT_OFFSET(counter)		\
 	(offsetof(struct tx_port_stats_ext, counter) / 8)
 
-#define BNXT_PCIE_STATS_OFFSET(counter)			\
-	(offsetof(struct pcie_ctx_hw_stats, counter) / 8)
-
 #define BNXT_HW_FEATURE_VLAN_ALL_RX				\
 	(NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_STAG_RX)
 #define BNXT_HW_FEATURE_VLAN_ALL_TX				\
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 538c976..dded170 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -293,9 +293,6 @@ static int bnxt_set_coalesce(struct net_device *dev,
 	BNXT_TX_STATS_PRI_ENTRY(counter, 6),		\
 	BNXT_TX_STATS_PRI_ENTRY(counter, 7)
 
-#define BNXT_PCIE_STATS_ENTRY(counter)	\
-	{ BNXT_PCIE_STATS_OFFSET(counter), __stringify(counter) }
-
 enum {
 	RX_TOTAL_DISCARDS,
 	TX_TOTAL_DISCARDS,
@@ -454,24 +451,6 @@ enum {
 	BNXT_TX_STATS_PRI_ENTRIES(tx_packets),
 };
 
-static const struct {
-	long offset;
-	char string[ETH_GSTRING_LEN];
-} bnxt_pcie_stats_arr[] = {
-	BNXT_PCIE_STATS_ENTRY(pcie_pl_signal_integrity),
-	BNXT_PCIE_STATS_ENTRY(pcie_dl_signal_integrity),
-	BNXT_PCIE_STATS_ENTRY(pcie_tl_signal_integrity),
-	BNXT_PCIE_STATS_ENTRY(pcie_link_integrity),
-	BNXT_PCIE_STATS_ENTRY(pcie_tx_traffic_rate),
-	BNXT_PCIE_STATS_ENTRY(pcie_rx_traffic_rate),
-	BNXT_PCIE_STATS_ENTRY(pcie_tx_dllp_statistics),
-	BNXT_PCIE_STATS_ENTRY(pcie_rx_dllp_statistics),
-	BNXT_PCIE_STATS_ENTRY(pcie_equalization_time),
-	BNXT_PCIE_STATS_ENTRY(pcie_ltssm_histogram[0]),
-	BNXT_PCIE_STATS_ENTRY(pcie_ltssm_histogram[2]),
-	BNXT_PCIE_STATS_ENTRY(pcie_recovery_histogram),
-};
-
 #define BNXT_NUM_SW_FUNC_STATS	ARRAY_SIZE(bnxt_sw_func_stats)
 #define BNXT_NUM_PORT_STATS ARRAY_SIZE(bnxt_port_stats_arr)
 #define BNXT_NUM_STATS_PRI			\
@@ -479,7 +458,6 @@ enum {
 	 ARRAY_SIZE(bnxt_rx_pkts_pri_arr) +	\
 	 ARRAY_SIZE(bnxt_tx_bytes_pri_arr) +	\
 	 ARRAY_SIZE(bnxt_tx_pkts_pri_arr))
-#define BNXT_NUM_PCIE_STATS ARRAY_SIZE(bnxt_pcie_stats_arr)
 
 static int bnxt_get_num_tpa_ring_stats(struct bnxt *bp)
 {
@@ -526,9 +504,6 @@ static int bnxt_get_num_stats(struct bnxt *bp)
 			num_stats += BNXT_NUM_STATS_PRI;
 	}
 
-	if (bp->flags & BNXT_FLAG_PCIE_STATS)
-		num_stats += BNXT_NUM_PCIE_STATS;
-
 	return num_stats;
 }
 
@@ -674,14 +649,6 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 			}
 		}
 	}
-	if (bp->flags & BNXT_FLAG_PCIE_STATS) {
-		__le64 *pcie_stats = (__le64 *)bp->hw_pcie_stats;
-
-		for (i = 0; i < BNXT_NUM_PCIE_STATS; i++, j++) {
-			buf[j] = le64_to_cpu(*(pcie_stats +
-					       bnxt_pcie_stats_arr[i].offset));
-		}
-	}
 }
 
 static void bnxt_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
@@ -782,12 +749,6 @@ static void bnxt_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 				}
 			}
 		}
-		if (bp->flags & BNXT_FLAG_PCIE_STATS) {
-			for (i = 0; i < BNXT_NUM_PCIE_STATS; i++) {
-				strcpy(buf, bnxt_pcie_stats_arr[i].string);
-				buf += ETH_GSTRING_LEN;
-			}
-		}
 		break;
 	case ETH_SS_TEST:
 		if (bp->num_tests)
-- 
1.8.3.1

