Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF22A4DC426
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 11:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbiCQKok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 06:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbiCQKoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 06:44:38 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FCFDEBAB;
        Thu, 17 Mar 2022 03:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647513801; x=1679049801;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=14m99kcHI6ZGbLkN68EBLVL0nsCW8sI0ecyNMHrnROs=;
  b=arq9zUJ7Anc3RouBR/bmmOMIfanQsm6rxDeh2y5ISGKIw+KqPxl4BAE/
   lcowzIzSU4fyT2I2tb6sS7rsMwQh8Fg+1tOPOiGweqlFM6yaSJSZZ2HbN
   EoIV323k3QnzIFhQqlubgQhABoBJJoh+OK/tx8BdXi7KKgbpisCIufp6m
   cNAm9XqHDNkyNptnRvqPmFC8FazDyROSi1pnrtK7alWnQ13PskzKog9/p
   n8jYnIz6WUYilblaLh1BihrSWFENkkz26Q4aYluIJEOd0sYEV9xfXNp1t
   d2nLLD24Vw6e3FNrohwbgnk5jblCh7RmFMhdfzCuqes58edGVK3cCmQcS
   A==;
X-IronPort-AV: E=Sophos;i="5.90,188,1643698800"; 
   d="scan'208";a="89248102"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2022 03:43:19 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 17 Mar 2022 03:43:19 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 17 Mar 2022 03:43:16 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V1 1/5] net: lan743x: Add support to display Tx Queue statistics
Date:   Thu, 17 Mar 2022 16:13:06 +0530
Message-ID: <20220317104310.61091-2-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220317104310.61091-1-Raju.Lakkaraju@microchip.com>
References: <20220317104310.61091-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tx 4 queue statistics display through ethtool application

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
 .../net/ethernet/microchip/lan743x_ethtool.c  | 31 +++++++++++++++++++
 drivers/net/ethernet/microchip/lan743x_main.c |  1 +
 drivers/net/ethernet/microchip/lan743x_main.h |  1 +
 3 files changed, 33 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index 5f1e7b8bad4f..d13d284cdaea 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -365,6 +365,14 @@ static const char lan743x_set1_sw_cnt_strings[][ETH_GSTRING_LEN] = {
 	"RX Queue 3 Frames",
 };
 
+static const char lan743x_tx_queue_cnt_strings[][ETH_GSTRING_LEN] = {
+	"TX Queue 0 Frames",
+	"TX Queue 1 Frames",
+	"TX Queue 2 Frames",
+	"TX Queue 3 Frames",
+	"TX Total Queue Frames",
+};
+
 static const char lan743x_set2_hw_cnt_strings[][ETH_GSTRING_LEN] = {
 	"RX Total Frames",
 	"EEE RX LPI Transitions",
@@ -462,6 +470,8 @@ static const char lan743x_priv_flags_strings[][ETH_GSTRING_LEN] = {
 static void lan743x_ethtool_get_strings(struct net_device *netdev,
 					u32 stringset, u8 *data)
 {
+	struct lan743x_adapter *adapter = netdev_priv(netdev);
+
 	switch (stringset) {
 	case ETH_SS_STATS:
 		memcpy(data, lan743x_set0_hw_cnt_strings,
@@ -473,6 +483,13 @@ static void lan743x_ethtool_get_strings(struct net_device *netdev,
 		       sizeof(lan743x_set1_sw_cnt_strings)],
 		       lan743x_set2_hw_cnt_strings,
 		       sizeof(lan743x_set2_hw_cnt_strings));
+		if (adapter->is_pci11x1x) {
+			memcpy(&data[sizeof(lan743x_set0_hw_cnt_strings) +
+			       sizeof(lan743x_set1_sw_cnt_strings) +
+			       sizeof(lan743x_set2_hw_cnt_strings)],
+			       lan743x_tx_queue_cnt_strings,
+			       sizeof(lan743x_tx_queue_cnt_strings));
+		}
 		break;
 	case ETH_SS_PRIV_FLAGS:
 		memcpy(data, lan743x_priv_flags_strings,
@@ -486,7 +503,9 @@ static void lan743x_ethtool_get_ethtool_stats(struct net_device *netdev,
 					      u64 *data)
 {
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
+	u64 total_queue_count = 0;
 	int data_index = 0;
+	u64 pkt_cnt;
 	u32 buf;
 	int i;
 
@@ -500,6 +519,14 @@ static void lan743x_ethtool_get_ethtool_stats(struct net_device *netdev,
 		buf = lan743x_csr_read(adapter, lan743x_set2_hw_cnt_addr[i]);
 		data[data_index++] = (u64)buf;
 	}
+	if (adapter->is_pci11x1x) {
+		for (i = 0; i < ARRAY_SIZE(adapter->tx); i++) {
+			pkt_cnt = (u64)(adapter->tx[i].frame_count);
+			data[data_index++] = pkt_cnt;
+			total_queue_count += pkt_cnt;
+		}
+		data[data_index++] = total_queue_count;
+	}
 }
 
 static u32 lan743x_ethtool_get_priv_flags(struct net_device *netdev)
@@ -520,6 +547,8 @@ static int lan743x_ethtool_set_priv_flags(struct net_device *netdev, u32 flags)
 
 static int lan743x_ethtool_get_sset_count(struct net_device *netdev, int sset)
 {
+	struct lan743x_adapter *adapter = netdev_priv(netdev);
+
 	switch (sset) {
 	case ETH_SS_STATS:
 	{
@@ -528,6 +557,8 @@ static int lan743x_ethtool_get_sset_count(struct net_device *netdev, int sset)
 		ret = ARRAY_SIZE(lan743x_set0_hw_cnt_strings);
 		ret += ARRAY_SIZE(lan743x_set1_sw_cnt_strings);
 		ret += ARRAY_SIZE(lan743x_set2_hw_cnt_strings);
+		if (adapter->is_pci11x1x)
+			ret += ARRAY_SIZE(lan743x_tx_queue_cnt_strings);
 		return ret;
 	}
 	case ETH_SS_PRIV_FLAGS:
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 5282d25a6f9b..7ace3ed35778 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1776,6 +1776,7 @@ static netdev_tx_t lan743x_tx_xmit_frame(struct lan743x_tx *tx,
 		dev_kfree_skb_irq(skb);
 		goto unlock;
 	}
+	tx->frame_count++;
 
 	if (gso)
 		lan743x_tx_frame_add_lso(tx, frame_length, nr_frags);
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 2c8e76b4e1f7..bca9f105900c 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -715,6 +715,7 @@ struct lan743x_tx {
 	int		last_tail;
 
 	struct napi_struct napi;
+	u32 frame_count;
 
 	struct sk_buff *overflow_skb;
 };
-- 
2.25.1

