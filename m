Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D18C33957B
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbhCLRsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbhCLRs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 12:48:29 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6F3C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:48:29 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id ha17so4742337pjb.2
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=3AHErhEHGN938tIzQruxid7y1CsGWelYDXd4QUDtm4g=;
        b=EWndKXAfNQ3ulOCiXNcp8uZ7EVChMMDTPLsNuCJYunNkErZjaEvO9X8FyJ0pn5X/VP
         +ISeUWxSfNGmJ5uOvXMTfi47+PKGCu78Wr6pjby/1vPPejESDlZA4hiC3PBVfK3zI4Vc
         wIkdUJkkNrCTh1/53C9hxaQFQSbVZpz5xb2n3vVbixb9i7Qp3NO8T49GyNas0TMLXS1V
         VVljr+esnguBuBC5Z46BxLYAWF1ZuN8B4AcYOVd79Bum68AtgWSHkA4M4xR58BsUABs1
         ak7TpCNYl7Cd87O/S3gWxD0evsogeoh18o5NfV+I6GLW6ExQ1ews3wS+Sf1yyLee6ZTR
         Qk+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=3AHErhEHGN938tIzQruxid7y1CsGWelYDXd4QUDtm4g=;
        b=J/u5Cp5st9xSP8dz8kA//hJzvlV8Q15lLwGqYppmKYwhaUzzsMo101qIn+6QehVof2
         y30oQa7ULvRt4dkASHjWzWCpnskxyuMLLZd2ZSTR18YMZ1B9jTo6xCovU6mwa673Ykif
         1bLl6Y9nfDpDlF9I63b8ZYA45WZsx57ySCsgVYGQhwaTTIe6hyAWmbV7fclUv04U3Uf5
         UcBZzyXVLOl+Pkp3dU6MP9i7bcj7k3CWz1vmAzKQFbwuAiFXyQtcOTC/Dp1MZm0oVz7y
         MInc37ZZILYpwQETaKz5WloOid+wkGfVgymoS3nizpSpyxZ4KRbota0Bm2vfwWGRVvIq
         XBYQ==
X-Gm-Message-State: AOAM533UnX00kqOAYMtVkgOUIAAEDvirHsGFJvranlNjSlD68vJEbdQS
        J8vlT7yzs+d0JKbZjIS0Cxk=
X-Google-Smtp-Source: ABdhPJzZcCepy+mQTHtU5zRYzc1sZ7rsmQyBKJUh5/alsPH/3YiX8YuCxFn5RnhmxflhMAKbez6Nyw==
X-Received: by 2002:a17:902:7881:b029:e6:2bc6:b74 with SMTP id q1-20020a1709027881b02900e62bc60b74mr180906pll.13.1615571308486;
        Fri, 12 Mar 2021 09:48:28 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id q205sm6469834pfc.126.2021.03.12.09.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 09:48:28 -0800 (PST)
Subject: [net-next PATCH 04/10] hisilicon: Update drivers to use
 ethtool_sprintf
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
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
        alexanderduyck@fb.com, Kernel-team@fb.com
Date:   Fri, 12 Mar 2021 09:48:27 -0800
Message-ID: <161557130706.10304.2066531484179147837.stgit@localhost.localdomain>
In-Reply-To: <161557111604.10304.1798900949114188676.stgit@localhost.localdomain>
References: <161557111604.10304.1798900949114188676.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

Update the hisilicon drivers to make use of ethtool_sprintf. The general
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
index 7fb7a419607d..91b64db91e51 100644
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
+		ethtool_sprintf(&buff, g_gmac_stats_string[i].desc);
 }
 
 static int hns_gmac_get_sset_count(int stringset)
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c
index d0f8b1fff333..f331621fcc41 100644
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
+	ethtool_sprintf(&buff, "ppe%d_rx_sw_pkt", index);
+	ethtool_sprintf(&buff, "ppe%d_rx_pkt_ok", index);
+	ethtool_sprintf(&buff, "ppe%d_rx_drop_pkt_no_bd", index);
+	ethtool_sprintf(&buff, "ppe%d_rx_alloc_buf_fail", index);
+	ethtool_sprintf(&buff, "ppe%d_rx_alloc_buf_wait", index);
+	ethtool_sprintf(&buff, "ppe%d_rx_pkt_drop_no_buf", index);
+	ethtool_sprintf(&buff, "ppe%d_rx_pkt_err_fifo_full", index);
+
+	ethtool_sprintf(&buff, "ppe%d_tx_bd", index);
+	ethtool_sprintf(&buff, "ppe%d_tx_pkt", index);
+	ethtool_sprintf(&buff, "ppe%d_tx_pkt_ok", index);
+	ethtool_sprintf(&buff, "ppe%d_tx_pkt_err_fifo_empty", index);
+	ethtool_sprintf(&buff, "ppe%d_tx_pkt_err_csum_fail", index);
 }
 
 void hns_ppe_get_stats(struct hns_ppe_cb *ppe_cb, u64 *data)
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c
index b6c8910cf7ba..f9f0736a2c63 100644
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
+	ethtool_sprintf(&buff, "tx_ring%d_rcb_pkt_num", index);
+	ethtool_sprintf(&buff, "tx_ring%d_ppe_tx_pkt_num", index);
+	ethtool_sprintf(&buff, "tx_ring%d_ppe_drop_pkt_num", index);
+	ethtool_sprintf(&buff, "tx_ring%d_fbd_num", index);
+
+	ethtool_sprintf(&buff, "tx_ring%d_pkt_num", index);
+	ethtool_sprintf(&buff, "tx_ring%d_bytes", index);
+	ethtool_sprintf(&buff, "tx_ring%d_err_cnt", index);
+	ethtool_sprintf(&buff, "tx_ring%d_io_err", index);
+	ethtool_sprintf(&buff, "tx_ring%d_sw_err", index);
+	ethtool_sprintf(&buff, "tx_ring%d_seg_pkt", index);
+	ethtool_sprintf(&buff, "tx_ring%d_restart_queue", index);
+	ethtool_sprintf(&buff, "tx_ring%d_tx_busy", index);
+
+	ethtool_sprintf(&buff, "rx_ring%d_rcb_pkt_num", index);
+	ethtool_sprintf(&buff, "rx_ring%d_ppe_pkt_num", index);
+	ethtool_sprintf(&buff, "rx_ring%d_ppe_drop_pkt_num", index);
+	ethtool_sprintf(&buff, "rx_ring%d_fbd_num", index);
+
+	ethtool_sprintf(&buff, "rx_ring%d_pkt_num", index);
+	ethtool_sprintf(&buff, "rx_ring%d_bytes", index);
+	ethtool_sprintf(&buff, "rx_ring%d_err_cnt", index);
+	ethtool_sprintf(&buff, "rx_ring%d_io_err", index);
+	ethtool_sprintf(&buff, "rx_ring%d_sw_err", index);
+	ethtool_sprintf(&buff, "rx_ring%d_seg_pkt", index);
+	ethtool_sprintf(&buff, "rx_ring%d_reuse_pg", index);
+	ethtool_sprintf(&buff, "rx_ring%d_len_err", index);
+	ethtool_sprintf(&buff, "rx_ring%d_non_vld_desc_err", index);
+	ethtool_sprintf(&buff, "rx_ring%d_bd_num_err", index);
+	ethtool_sprintf(&buff, "rx_ring%d_l2_err", index);
+	ethtool_sprintf(&buff, "rx_ring%d_l3l4csum_err", index);
 }
 
 void hns_rcb_get_common_regs(struct rcb_common_cb *rcb_com, void *data)
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
index 7e3609ce112a..ecba680e2573 100644
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
+		ethtool_sprintf(&buff, g_xgmac_stats_string[i].desc);
 }
 
 /**
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index a6e3f07caf99..2f04247b0fe0 100644
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
+			ethtool_sprintf(&buff,
+					hns_nic_test_strs[MAC_INTERNALLOOP_MAC]);
+		ethtool_sprintf(&buff,
+				hns_nic_test_strs[MAC_INTERNALLOOP_SERDES]);
 		if ((netdev->phydev) && (!netdev->phydev->is_c45))
-			memcpy(buff, hns_nic_test_strs[MAC_INTERNALLOOP_PHY],
-			       ETH_GSTRING_LEN);
+			ethtool_sprintf(&buff,
+					hns_nic_test_strs[MAC_INTERNALLOOP_PHY]);
 
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
+		ethtool_sprintf(&buff, "rx_packets");
+		ethtool_sprintf(&buff, "tx_packets");
+		ethtool_sprintf(&buff, "rx_bytes");
+		ethtool_sprintf(&buff, "tx_bytes");
+		ethtool_sprintf(&buff, "rx_errors");
+		ethtool_sprintf(&buff, "tx_errors");
+		ethtool_sprintf(&buff, "rx_dropped");
+		ethtool_sprintf(&buff, "tx_dropped");
+		ethtool_sprintf(&buff, "multicast");
+		ethtool_sprintf(&buff, "collisions");
+		ethtool_sprintf(&buff, "rx_over_errors");
+		ethtool_sprintf(&buff, "rx_crc_errors");
+		ethtool_sprintf(&buff, "rx_frame_errors");
+		ethtool_sprintf(&buff, "rx_fifo_errors");
+		ethtool_sprintf(&buff, "rx_missed_errors");
+		ethtool_sprintf(&buff, "tx_aborted_errors");
+		ethtool_sprintf(&buff, "tx_carrier_errors");
+		ethtool_sprintf(&buff, "tx_fifo_errors");
+		ethtool_sprintf(&buff, "tx_heartbeat_errors");
+		ethtool_sprintf(&buff, "rx_length_errors");
+		ethtool_sprintf(&buff, "tx_window_errors");
+		ethtool_sprintf(&buff, "rx_compressed");
+		ethtool_sprintf(&buff, "tx_compressed");
+		ethtool_sprintf(&buff, "netdev_rx_dropped");
+		ethtool_sprintf(&buff, "netdev_tx_dropped");
+
+		ethtool_sprintf(&buff, "netdev_tx_timeout");
 
 		h->dev->ops->get_strings(h, stringset, (u8 *)buff);
 	}


