Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11E93369CA
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 02:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhCKBgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 20:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbhCKBgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 20:36:19 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABD4C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 17:36:19 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id l7so13437349pfd.3
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 17:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=zwmi3JuPnTfduGik1QpBW0Dj/Zas5L1dP4lxc4Bo/Vs=;
        b=i4G35mw/8BI/K7IRD8mxtGPoZ3WhZrM1+xPmXQbsjDp38uqH0L+G8bAycOsStHzfZM
         z8PoUY9ighgV7plV1V1XegX1IzaWG+rXAuUKPqGk1Sb1upJX1R3LU7N0I6/TdfnPq5JT
         oYq2vGqUPNuyhh6KTTw9eneYlDBLaO1/ALpoVGcapnsSHspcYpuKVAoMRCw+DOdnwA55
         5d4OnRuOdbDAT67Cm5OdVLCg+89Hlqwjf6aPNobPBuJFcqgm8ED3aGeeZQZHouR2Hfcr
         NgXSJ5PpgOFyxiObAjxgNSSBRFoH1JElrl8zh5YXxR18eBdDBEIvQ7LERtg0U8soKrvt
         dBRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=zwmi3JuPnTfduGik1QpBW0Dj/Zas5L1dP4lxc4Bo/Vs=;
        b=CvPseak1tqBk/i2580JV7mdyxWyGH0A9DgyF4+CpScuY2H+/rTt5NgLyFmwQgq3ORx
         McRALpSnXZYNHizCLIJTUSzaohz66nZNMg4t/TXSEltlYQQ7m6lrOP46Z6vXO91hTAMa
         MdmpvJApdfiHm2x0f4RmAjD8nB7NcOomdQd/swHUnmmqiCq91sz7RPYUh5gMVztfO3uy
         PIX0GN1sJ2aOLI+E+o4vH0PiFKSbBSfwgF682HqaHsxBtbKI+bYb2e5EN0lbz8p9sO+2
         kUr4Qv/j6eUkyeJYLQDQYLsQ/ggcBXV4lz/ssIURcboH981y1g6dwMG9UcDeGAgRdU+e
         dqIw==
X-Gm-Message-State: AOAM53007DtQjRtCTIZc0wthUE+MbPie6AnRUOVzDnW5RfgFmce7LQsc
        GdLnOiBBK1qsTv0E8scA/S4=
X-Google-Smtp-Source: ABdhPJzK4EkTkJtt9aP4Ni5V8SaqhKldWhBhRqKKxLz96ZlccdDyVk5oHYBCdFpvS0za6aU4PbCdTA==
X-Received: by 2002:a62:e805:0:b029:1f8:16ba:4518 with SMTP id c5-20020a62e8050000b02901f816ba4518mr5290933pfi.37.1615426578576;
        Wed, 10 Mar 2021 17:36:18 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id gg22sm532748pjb.20.2021.03.10.17.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 17:36:18 -0800 (PST)
Subject: [RFC PATCH 10/10] ionic: Update driver to use ethtool_gsprintf
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
Date:   Wed, 10 Mar 2021 17:36:17 -0800
Message-ID: <161542657729.13546.14928347259921159903.stgit@localhost.localdomain>
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

Update the ionic driver to make use of ethtool_gsprintf. In addition add
separate functions for Tx/Rx stats strings in order to reduce the total
amount of indenting needed in the driver code.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_stats.c |  145 +++++++++------------
 1 file changed, 60 insertions(+), 85 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.c b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
index 6ae75b771a15..1dac960386df 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_stats.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
@@ -246,98 +246,73 @@ static u64 ionic_sw_stats_get_count(struct ionic_lif *lif)
 	return total;
 }
 
+static void ionic_sw_stats_get_tx_strings(struct ionic_lif *lif, u8 **buf,
+					  int q_num)
+{
+	int i;
+
+	for (i = 0; i < IONIC_NUM_TX_STATS; i++)
+		ethtool_gsprintf(buf, "tx_%d_%s", q_num,
+				 ionic_tx_stats_desc[i].name);
+
+	if (!test_bit(IONIC_LIF_F_UP, lif->state) ||
+	    !test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state))
+		return;
+
+	for (i = 0; i < IONIC_NUM_TX_Q_STATS; i++)
+		ethtool_gsprintf(buf, "txq_%d_%s", q_num,
+				 ionic_txq_stats_desc[i].name);
+	for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++)
+		ethtool_gsprintf(buf, "txq_%d_cq_%s", q_num,
+				 ionic_dbg_cq_stats_desc[i].name);
+	for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++)
+		ethtool_gsprintf(buf, "txq_%d_intr_%s", q_num,
+				 ionic_dbg_intr_stats_desc[i].name);
+	for (i = 0; i < IONIC_MAX_NUM_SG_CNTR; i++)
+		ethtool_gsprintf(buf, "txq_%d_sg_cntr_%d", q_num, i);
+}
+
+static void ionic_sw_stats_get_rx_strings(struct ionic_lif *lif, u8 **buf,
+					  int q_num)
+{
+	int i;
+
+	for (i = 0; i < IONIC_NUM_RX_STATS; i++)
+		ethtool_gsprintf(buf, "rx_%d_%s", q_num,
+				 ionic_rx_stats_desc[i].name);
+
+	if (!test_bit(IONIC_LIF_F_UP, lif->state) ||
+	    !test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state))
+		return;
+
+	for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++)
+		ethtool_gsprintf(buf, "rxq_%d_cq_%s", q_num,
+				 ionic_dbg_cq_stats_desc[i].name);
+	for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++)
+		ethtool_gsprintf(buf, "rxq_%d_intr_%s", q_num,
+				 ionic_dbg_intr_stats_desc[i].name);
+	for (i = 0; i < IONIC_NUM_DBG_NAPI_STATS; i++)
+		ethtool_gsprintf(buf, "rxq_%d_napi_%s", q_num,
+				 ionic_dbg_napi_stats_desc[i].name);
+	for (i = 0; i < IONIC_MAX_NUM_NAPI_CNTR; i++)
+		ethtool_gsprintf(buf, "rxq_%d_napi_work_done_%d", q_num, i);
+}
+
 static void ionic_sw_stats_get_strings(struct ionic_lif *lif, u8 **buf)
 {
 	int i, q_num;
 
-	for (i = 0; i < IONIC_NUM_LIF_STATS; i++) {
-		snprintf(*buf, ETH_GSTRING_LEN, ionic_lif_stats_desc[i].name);
-		*buf += ETH_GSTRING_LEN;
-	}
+	for (i = 0; i < IONIC_NUM_LIF_STATS; i++)
+		ethtool_gsprintf(buf, ionic_lif_stats_desc[i].name);
 
-	for (i = 0; i < IONIC_NUM_PORT_STATS; i++) {
-		snprintf(*buf, ETH_GSTRING_LEN,
-			 ionic_port_stats_desc[i].name);
-		*buf += ETH_GSTRING_LEN;
-	}
+	for (i = 0; i < IONIC_NUM_PORT_STATS; i++)
+		ethtool_gsprintf(buf, ionic_port_stats_desc[i].name);
 
-	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
-		for (i = 0; i < IONIC_NUM_TX_STATS; i++) {
-			snprintf(*buf, ETH_GSTRING_LEN, "tx_%d_%s",
-				 q_num, ionic_tx_stats_desc[i].name);
-			*buf += ETH_GSTRING_LEN;
-		}
+	for (q_num = 0; q_num < MAX_Q(lif); q_num++)
+		ionic_sw_stats_get_tx_strings(lif, buf, q_num);
 
-		if (test_bit(IONIC_LIF_F_UP, lif->state) &&
-		    test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state)) {
-			for (i = 0; i < IONIC_NUM_TX_Q_STATS; i++) {
-				snprintf(*buf, ETH_GSTRING_LEN,
-					 "txq_%d_%s",
-					 q_num,
-					 ionic_txq_stats_desc[i].name);
-				*buf += ETH_GSTRING_LEN;
-			}
-			for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
-				snprintf(*buf, ETH_GSTRING_LEN,
-					 "txq_%d_cq_%s",
-					 q_num,
-					 ionic_dbg_cq_stats_desc[i].name);
-				*buf += ETH_GSTRING_LEN;
-			}
-			for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++) {
-				snprintf(*buf, ETH_GSTRING_LEN,
-					 "txq_%d_intr_%s",
-					 q_num,
-					 ionic_dbg_intr_stats_desc[i].name);
-				*buf += ETH_GSTRING_LEN;
-			}
-			for (i = 0; i < IONIC_MAX_NUM_SG_CNTR; i++) {
-				snprintf(*buf, ETH_GSTRING_LEN,
-					 "txq_%d_sg_cntr_%d",
-					 q_num, i);
-				*buf += ETH_GSTRING_LEN;
-			}
-		}
-	}
-	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
-		for (i = 0; i < IONIC_NUM_RX_STATS; i++) {
-			snprintf(*buf, ETH_GSTRING_LEN,
-				 "rx_%d_%s",
-				 q_num, ionic_rx_stats_desc[i].name);
-			*buf += ETH_GSTRING_LEN;
-		}
-
-		if (test_bit(IONIC_LIF_F_UP, lif->state) &&
-		    test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state)) {
-			for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
-				snprintf(*buf, ETH_GSTRING_LEN,
-					 "rxq_%d_cq_%s",
-					 q_num,
-					 ionic_dbg_cq_stats_desc[i].name);
-				*buf += ETH_GSTRING_LEN;
-			}
-			for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++) {
-				snprintf(*buf, ETH_GSTRING_LEN,
-					 "rxq_%d_intr_%s",
-					 q_num,
-					 ionic_dbg_intr_stats_desc[i].name);
-				*buf += ETH_GSTRING_LEN;
-			}
-			for (i = 0; i < IONIC_NUM_DBG_NAPI_STATS; i++) {
-				snprintf(*buf, ETH_GSTRING_LEN,
-					 "rxq_%d_napi_%s",
-					 q_num,
-					 ionic_dbg_napi_stats_desc[i].name);
-				*buf += ETH_GSTRING_LEN;
-			}
-			for (i = 0; i < IONIC_MAX_NUM_NAPI_CNTR; i++) {
-				snprintf(*buf, ETH_GSTRING_LEN,
-					 "rxq_%d_napi_work_done_%d",
-					 q_num, i);
-				*buf += ETH_GSTRING_LEN;
-			}
-		}
-	}
+	for (q_num = 0; q_num < MAX_Q(lif); q_num++)
+		ionic_sw_stats_get_rx_strings(lif, buf, q_num);
 }
 
 static void ionic_sw_stats_get_values(struct ionic_lif *lif, u64 **buf)


