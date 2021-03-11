Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC583369C2
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 02:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbhCKBgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 20:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhCKBfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 20:35:41 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D697AC061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 17:35:40 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id e26so4770033pfd.9
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 17:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=rA4T5qcIqS2gI5AvnHhMW6L1JSpG84sD27zQhKbg484=;
        b=Fg205LMfNoZLQN20U3NMOpXyrIVye5TkIHHIK/Mfaq/kF6JbfMrGBFgtPXVxXIKlW0
         5/lH/EHJdOiZc0bCIzfl0sxm6cSKfk7OtPHauJ5jLQGvSNIT9vAHTzCiyRIjYkc3CUPW
         27GwErg5eModRMrRXsweETQrxwZK9n3RgN1kwlVPfH6Rq7VEslahuYz/jI94OFBpijHs
         oBXrfiL58vq4nrHt5QPAvPAp5Io0+qLgI3nKrdXgVEFdRFWY3+c0+JE9mnL+/P6Zi9K4
         dOPG8kMcPlvVGFTS3cnFh7mOYmsZT0MrvTGBWoo2Tp4xmjzMgq60jvQlnz4k41MsXjSE
         twqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=rA4T5qcIqS2gI5AvnHhMW6L1JSpG84sD27zQhKbg484=;
        b=JTRBjWWsz2xJP3+0gkOIpXTIa07jQsE20UW2rarH7+AiantRjovT+sdcAiPtgAskHH
         03AsMbHzOFJS/6fVtGQGhNtGQiRsk6YZpKV7kvm1s0si0EaNqBVGP1+408iTYx0tTXK6
         +9kIugJ7N9pA0UObgCmEi9lmISzOdNkZUH9MUdLrNkGHO3Ilomlo8fS0Vw8cStoR3vD6
         EGcWyRojA98gZayCm9WXBRe29fThAP+J67MlvR/NSlVDfbF2tKoMwwQtIlTpo4n8NoMX
         nMposD0AA8jqzn2WRTc6A7XNO8aX5LhhXhd3SUkaiCCmMJScEs71FIhOJlnSPBC14+Lo
         bGxw==
X-Gm-Message-State: AOAM531Z20BIiJ8BdC5gDyqf5zpzl3/NmfSxU+fZzFkjUEma1/yN+VhV
        3dYspaFbhfze0fDPNFN/DCM=
X-Google-Smtp-Source: ABdhPJwaiinn7wPj/6Hfy1Dp7q3Rwl6N8IgsVMF56rVEhPUIKKQAApuJJxiATExLLJgBpUvINgAPPw==
X-Received: by 2002:a62:5b43:0:b029:1ef:21ad:846 with SMTP id p64-20020a625b430000b02901ef21ad0846mr5473363pfb.51.1615426540283;
        Wed, 10 Mar 2021 17:35:40 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id c16sm632775pfc.112.2021.03.10.17.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 17:35:39 -0800 (PST)
Subject: [RFC PATCH 04/10] hisilicon: Update drivers to use ethtool_gsprintf
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        simon.horman@netronome.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        drivers@pensando.io, snelson@pensando.io, netanel@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com, saeedb@amazon.com,
        GR-Linux-NIC-Dev@marvell.com, skalluru@marvell.com,
        rmody@marvell.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, mst@redhat.com,
        jasowang@redhat.com, pv-drivers@vmware.com, doshir@vmware.com,
        alexanderduyck@fb.com
Date:   Wed, 10 Mar 2021 17:35:39 -0800
Message-ID: <161542653900.13546.2854682520330690964.stgit@localhost.localdomain>
In-Reply-To: <161542634192.13546.4185974647834631704.stgit@localhost.localdomain>
References: <161542634192.13546.4185974647834631704.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

Update the hisilicon drivers to make use of ethtool_gsprintf. The general
idea is to reduce code size and overhead by replacing the repeated pattern
of string printf statements and ETH_STRING_LEN counter increments.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c |    7 -
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c  |   37 +++-----
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c  |   89 ++++++------------
 .../net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c    |    6 -
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |   97 +++++++-------------
 5 files changed, 82 insertions(+), 154 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c
index 7fb7a419607d..c43acb73f1e3 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c
@@ -693,11 +693,8 @@ static void hns_gmac_get_strings(u32 stringset, u8 *data)
 	if (stringset != ETH_SS_STATS)
 		return;
 
-	for (i = 0; i < ARRAY_SIZE(g_gmac_stats_string); i++) {
-		snprintf(buff, ETH_GSTRING_LEN, "%s",
-			 g_gmac_stats_string[i].desc);
-		buff = buff + ETH_GSTRING_LEN;
-	}
+	for (i = 0; i < ARRAY_SIZE(g_gmac_stats_string); i++)
+		ethtool_gsprintf(&buff, g_gmac_stats_string[i].desc);
 }
 
 static int hns_gmac_get_sset_count(int stringset)
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c
index d0f8b1fff333..35a149e31a43 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c
@@ -465,30 +465,19 @@ void hns_ppe_get_strings(struct hns_ppe_cb *ppe_cb, int stringset, u8 *data)
 	char *buff = (char *)data;
 	int index = ppe_cb->index;
 
-	snprintf(buff, ETH_GSTRING_LEN, "ppe%d_rx_sw_pkt", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "ppe%d_rx_pkt_ok", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "ppe%d_rx_drop_pkt_no_bd", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "ppe%d_rx_alloc_buf_fail", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "ppe%d_rx_alloc_buf_wait", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "ppe%d_rx_pkt_drop_no_buf", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "ppe%d_rx_pkt_err_fifo_full", index);
-	buff = buff + ETH_GSTRING_LEN;
-
-	snprintf(buff, ETH_GSTRING_LEN, "ppe%d_tx_bd", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "ppe%d_tx_pkt", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "ppe%d_tx_pkt_ok", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "ppe%d_tx_pkt_err_fifo_empty", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "ppe%d_tx_pkt_err_csum_fail", index);
+	ethtool_gsprintf(&buff, "ppe%d_rx_sw_pkt", index);
+	ethtool_gsprintf(&buff, "ppe%d_rx_pkt_ok", index);
+	ethtool_gsprintf(&buff, "ppe%d_rx_drop_pkt_no_bd", index);
+	ethtool_gsprintf(&buff, "ppe%d_rx_alloc_buf_fail", index);
+	ethtool_gsprintf(&buff, "ppe%d_rx_alloc_buf_wait", index);
+	ethtool_gsprintf(&buff, "ppe%d_rx_pkt_drop_no_buf", index);
+	ethtool_gsprintf(&buff, "ppe%d_rx_pkt_err_fifo_full", index);
+
+	ethtool_gsprintf(&buff, "ppe%d_tx_bd", index);
+	ethtool_gsprintf(&buff, "ppe%d_tx_pkt", index);
+	ethtool_gsprintf(&buff, "ppe%d_tx_pkt_ok", index);
+	ethtool_gsprintf(&buff, "ppe%d_tx_pkt_err_fifo_empty", index);
+	ethtool_gsprintf(&buff, "ppe%d_tx_pkt_err_csum_fail", index);
 }
 
 void hns_ppe_get_stats(struct hns_ppe_cb *ppe_cb, u64 *data)
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c
index b6c8910cf7ba..a7232b906be4 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c
@@ -934,64 +934,37 @@ void hns_rcb_get_strings(int stringset, u8 *data, int index)
 	if (stringset != ETH_SS_STATS)
 		return;
 
-	snprintf(buff, ETH_GSTRING_LEN, "tx_ring%d_rcb_pkt_num", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "tx_ring%d_ppe_tx_pkt_num", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "tx_ring%d_ppe_drop_pkt_num", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "tx_ring%d_fbd_num", index);
-	buff = buff + ETH_GSTRING_LEN;
-
-	snprintf(buff, ETH_GSTRING_LEN, "tx_ring%d_pkt_num", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "tx_ring%d_bytes", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "tx_ring%d_err_cnt", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "tx_ring%d_io_err", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "tx_ring%d_sw_err", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "tx_ring%d_seg_pkt", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "tx_ring%d_restart_queue", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "tx_ring%d_tx_busy", index);
-	buff = buff + ETH_GSTRING_LEN;
-
-	snprintf(buff, ETH_GSTRING_LEN, "rx_ring%d_rcb_pkt_num", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "rx_ring%d_ppe_pkt_num", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "rx_ring%d_ppe_drop_pkt_num", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "rx_ring%d_fbd_num", index);
-	buff = buff + ETH_GSTRING_LEN;
-
-	snprintf(buff, ETH_GSTRING_LEN, "rx_ring%d_pkt_num", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "rx_ring%d_bytes", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "rx_ring%d_err_cnt", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "rx_ring%d_io_err", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "rx_ring%d_sw_err", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "rx_ring%d_seg_pkt", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "rx_ring%d_reuse_pg", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "rx_ring%d_len_err", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "rx_ring%d_non_vld_desc_err", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "rx_ring%d_bd_num_err", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "rx_ring%d_l2_err", index);
-	buff = buff + ETH_GSTRING_LEN;
-	snprintf(buff, ETH_GSTRING_LEN, "rx_ring%d_l3l4csum_err", index);
+	ethtool_gsprintf(&buff, "tx_ring%d_rcb_pkt_num", index);
+	ethtool_gsprintf(&buff, "tx_ring%d_ppe_tx_pkt_num", index);
+	ethtool_gsprintf(&buff, "tx_ring%d_ppe_drop_pkt_num", index);
+	ethtool_gsprintf(&buff, "tx_ring%d_fbd_num", index);
+
+	ethtool_gsprintf(&buff, "tx_ring%d_pkt_num", index);
+	ethtool_gsprintf(&buff, "tx_ring%d_bytes", index);
+	ethtool_gsprintf(&buff, "tx_ring%d_err_cnt", index);
+	ethtool_gsprintf(&buff, "tx_ring%d_io_err", index);
+	ethtool_gsprintf(&buff, "tx_ring%d_sw_err", index);
+	ethtool_gsprintf(&buff, "tx_ring%d_seg_pkt", index);
+	ethtool_gsprintf(&buff, "tx_ring%d_restart_queue", index);
+	ethtool_gsprintf(&buff, "tx_ring%d_tx_busy", index);
+
+	ethtool_gsprintf(&buff, "rx_ring%d_rcb_pkt_num", index);
+	ethtool_gsprintf(&buff, "rx_ring%d_ppe_pkt_num", index);
+	ethtool_gsprintf(&buff, "rx_ring%d_ppe_drop_pkt_num", index);
+	ethtool_gsprintf(&buff, "rx_ring%d_fbd_num", index);
+
+	ethtool_gsprintf(&buff, "rx_ring%d_pkt_num", index);
+	ethtool_gsprintf(&buff, "rx_ring%d_bytes", index);
+	ethtool_gsprintf(&buff, "rx_ring%d_err_cnt", index);
+	ethtool_gsprintf(&buff, "rx_ring%d_io_err", index);
+	ethtool_gsprintf(&buff, "rx_ring%d_sw_err", index);
+	ethtool_gsprintf(&buff, "rx_ring%d_seg_pkt", index);
+	ethtool_gsprintf(&buff, "rx_ring%d_reuse_pg", index);
+	ethtool_gsprintf(&buff, "rx_ring%d_len_err", index);
+	ethtool_gsprintf(&buff, "rx_ring%d_non_vld_desc_err", index);
+	ethtool_gsprintf(&buff, "rx_ring%d_bd_num_err", index);
+	ethtool_gsprintf(&buff, "rx_ring%d_l2_err", index);
+	ethtool_gsprintf(&buff, "rx_ring%d_l3l4csum_err", index);
 }
 
 void hns_rcb_get_common_regs(struct rcb_common_cb *rcb_com, void *data)
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
index 7e3609ce112a..c2d475fd4963 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
@@ -764,10 +764,8 @@ static void hns_xgmac_get_strings(u32 stringset, u8 *data)
 	if (stringset != ETH_SS_STATS)
 		return;
 
-	for (i = 0; i < ARRAY_SIZE(g_xgmac_stats_string); i++) {
-		snprintf(buff, ETH_GSTRING_LEN, g_xgmac_stats_string[i].desc);
-		buff = buff + ETH_GSTRING_LEN;
-	}
+	for (i = 0; i < ARRAY_SIZE(g_xgmac_stats_string); i++)
+		ethtool_gsprintf(&buff, g_xgmac_stats_string[i].desc);
 }
 
 /**
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index a6e3f07caf99..e9a5264306e7 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -903,72 +903,43 @@ static void hns_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 	}
 
 	if (stringset == ETH_SS_TEST) {
-		if (priv->ae_handle->phy_if != PHY_INTERFACE_MODE_XGMII) {
-			memcpy(buff, hns_nic_test_strs[MAC_INTERNALLOOP_MAC],
-			       ETH_GSTRING_LEN);
-			buff += ETH_GSTRING_LEN;
-		}
-		memcpy(buff, hns_nic_test_strs[MAC_INTERNALLOOP_SERDES],
-		       ETH_GSTRING_LEN);
-		buff += ETH_GSTRING_LEN;
+		if (priv->ae_handle->phy_if != PHY_INTERFACE_MODE_XGMII)
+			ethtool_gsprintf(&buff,
+					 hns_nic_test_strs[MAC_INTERNALLOOP_MAC]);
+		ethtool_gsprintf(&buff,
+				 hns_nic_test_strs[MAC_INTERNALLOOP_SERDES]);
 		if ((netdev->phydev) && (!netdev->phydev->is_c45))
-			memcpy(buff, hns_nic_test_strs[MAC_INTERNALLOOP_PHY],
-			       ETH_GSTRING_LEN);
+			ethtool_gsprintf(&buff,
+					 hns_nic_test_strs[MAC_INTERNALLOOP_PHY]);
 
 	} else {
-		snprintf(buff, ETH_GSTRING_LEN, "rx_packets");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "tx_packets");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "rx_bytes");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "tx_bytes");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "rx_errors");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "tx_errors");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "rx_dropped");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "tx_dropped");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "multicast");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "collisions");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "rx_over_errors");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "rx_crc_errors");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "rx_frame_errors");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "rx_fifo_errors");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "rx_missed_errors");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "tx_aborted_errors");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "tx_carrier_errors");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "tx_fifo_errors");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "tx_heartbeat_errors");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "rx_length_errors");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "tx_window_errors");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "rx_compressed");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "tx_compressed");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "netdev_rx_dropped");
-		buff = buff + ETH_GSTRING_LEN;
-		snprintf(buff, ETH_GSTRING_LEN, "netdev_tx_dropped");
-		buff = buff + ETH_GSTRING_LEN;
-
-		snprintf(buff, ETH_GSTRING_LEN, "netdev_tx_timeout");
-		buff = buff + ETH_GSTRING_LEN;
+		ethtool_gsprintf(&buff, "rx_packets");
+		ethtool_gsprintf(&buff, "tx_packets");
+		ethtool_gsprintf(&buff, "rx_bytes");
+		ethtool_gsprintf(&buff, "tx_bytes");
+		ethtool_gsprintf(&buff, "rx_errors");
+		ethtool_gsprintf(&buff, "tx_errors");
+		ethtool_gsprintf(&buff, "rx_dropped");
+		ethtool_gsprintf(&buff, "tx_dropped");
+		ethtool_gsprintf(&buff, "multicast");
+		ethtool_gsprintf(&buff, "collisions");
+		ethtool_gsprintf(&buff, "rx_over_errors");
+		ethtool_gsprintf(&buff, "rx_crc_errors");
+		ethtool_gsprintf(&buff, "rx_frame_errors");
+		ethtool_gsprintf(&buff, "rx_fifo_errors");
+		ethtool_gsprintf(&buff, "rx_missed_errors");
+		ethtool_gsprintf(&buff, "tx_aborted_errors");
+		ethtool_gsprintf(&buff, "tx_carrier_errors");
+		ethtool_gsprintf(&buff, "tx_fifo_errors");
+		ethtool_gsprintf(&buff, "tx_heartbeat_errors");
+		ethtool_gsprintf(&buff, "rx_length_errors");
+		ethtool_gsprintf(&buff, "tx_window_errors");
+		ethtool_gsprintf(&buff, "rx_compressed");
+		ethtool_gsprintf(&buff, "tx_compressed");
+		ethtool_gsprintf(&buff, "netdev_rx_dropped");
+		ethtool_gsprintf(&buff, "netdev_tx_dropped");
+
+		ethtool_gsprintf(&buff, "netdev_tx_timeout");
 
 		h->dev->ops->get_strings(h, stringset, (u8 *)buff);
 	}


