Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABEA69A998
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 12:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjBQLC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 06:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjBQLCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 06:02:17 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6353028D;
        Fri, 17 Feb 2023 03:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676631731; x=1708167731;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TvhosYpnCmaq54jP9gfBjQ65AsWAKLJ0NHHkCvJYYsE=;
  b=02i8fHAMnIOCfyGqS8UJ0QkFaAGsB+0AEbhmpkN6vb7DXXmaEdVo/ApL
   Utv9kWRqzuP2fD5ZtX9ibSBTk9VZpthUJjDODR0Lda62vXFZIxekevgvY
   gurmeNau07If7VUybKvE74EHQxwNEwRwWvYotmY7cWlAuJeg8yYmOKfDo
   20LcTa9r2PyOmQ4/oLOvS9svyqakWVkw2AhFI1YA2157nZrNs+X03keom
   J3l5bkNdlPNimbdcnBawm1ZgyfaRnl8fnXeDk0lwAatTqrC1gHIgJiDfW
   ex092jZ6353EQEdpOSpQDTgDGXrYY6znvVJcoO0qGi5PQDgusRVUjVDfj
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,304,1669100400"; 
   d="scan'208";a="212497761"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Feb 2023 04:02:10 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 04:02:10 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 04:02:07 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [PATCH v2 net-next 3/5] net: dsa: microchip: add eth mac grouping for ethtool statistics
Date:   Fri, 17 Feb 2023 16:32:09 +0530
Message-ID: <20230217110211.433505-4-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

    Add support for ethtool standard device statistics grouping.
    Support ethernet mac statistics grouping using eth-mac groups
    parameter in ethtool command.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c  | 13 ++++
 drivers/net/dsa/microchip/ksz_common.h  |  2 +
 drivers/net/dsa/microchip/ksz_ethtool.c | 90 +++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ethtool.h |  4 ++
 4 files changed, 109 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 91fc7eed79f0..e4a51f13afa4 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -207,6 +207,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.fdb_dump = ksz8_fdb_dump,
 	.get_rmon_stats = ksz8_get_rmon_stats,
 	.get_eth_ctrl_stats = ksz8_get_eth_ctrl_stats,
+	.get_eth_mac_stats = ksz8_get_eth_mac_stats,
 	.mdb_add = ksz8_mdb_add,
 	.mdb_del = ksz8_mdb_del,
 	.vlan_filtering = ksz8_port_vlan_filtering,
@@ -246,6 +247,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.port_init_cnt = ksz9477_port_init_cnt,
 	.get_rmon_stats = ksz9477_get_rmon_stats,
 	.get_eth_ctrl_stats = ksz9477_get_eth_ctrl_stats,
+	.get_eth_mac_stats = ksz9477_get_eth_mac_stats,
 	.vlan_filtering = ksz9477_port_vlan_filtering,
 	.vlan_add = ksz9477_port_vlan_add,
 	.vlan_del = ksz9477_port_vlan_del,
@@ -284,6 +286,7 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.port_init_cnt = ksz9477_port_init_cnt,
 	.get_rmon_stats = ksz9477_get_rmon_stats,
 	.get_eth_ctrl_stats = ksz9477_get_eth_ctrl_stats,
+	.get_eth_mac_stats = ksz9477_get_eth_mac_stats,
 	.vlan_filtering = ksz9477_port_vlan_filtering,
 	.vlan_add = ksz9477_port_vlan_add,
 	.vlan_del = ksz9477_port_vlan_del,
@@ -1756,6 +1759,15 @@ static void ksz_get_eth_ctrl_stats(struct dsa_switch *ds, int port,
 		dev->dev_ops->get_eth_ctrl_stats(dev, port, ctrl_stats);
 }
 
+static void ksz_get_eth_mac_stats(struct dsa_switch *ds, int port,
+				  struct ethtool_eth_mac_stats *mac_stats)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (dev->dev_ops->get_eth_mac_stats)
+		dev->dev_ops->get_eth_mac_stats(dev, port, mac_stats);
+}
+
 static void ksz_get_strings(struct dsa_switch *ds, int port,
 			    u32 stringset, uint8_t *buf)
 {
@@ -3214,6 +3226,7 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.get_pause_stats	= ksz_get_pause_stats,
 	.get_rmon_stats		= ksz_get_rmon_stats,
 	.get_eth_ctrl_stats	= ksz_get_eth_ctrl_stats,
+	.get_eth_mac_stats	= ksz_get_eth_mac_stats,
 	.port_change_mtu	= ksz_change_mtu,
 	.port_max_mtu		= ksz_max_mtu,
 	.get_ts_info		= ksz_get_ts_info,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 7b0219947c7a..738e81923c31 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -366,6 +366,8 @@ struct ksz_dev_ops {
 			       const struct ethtool_rmon_hist_range **ranges);
 	void (*get_eth_ctrl_stats)(struct ksz_device *dev, int port,
 				   struct ethtool_eth_ctrl_stats *ctrl_stats);
+	void (*get_eth_mac_stats)(struct ksz_device *dev, int port,
+				  struct ethtool_eth_mac_stats *mac_stats);
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv);
diff --git a/drivers/net/dsa/microchip/ksz_ethtool.c b/drivers/net/dsa/microchip/ksz_ethtool.c
index 122c4371810a..42954bbfb9b4 100644
--- a/drivers/net/dsa/microchip/ksz_ethtool.c
+++ b/drivers/net/dsa/microchip/ksz_ethtool.c
@@ -160,6 +160,50 @@ void ksz8_get_eth_ctrl_stats(struct ksz_device *dev, int port,
 	mutex_unlock(&mib->cnt_mutex);
 }
 
+void ksz8_get_eth_mac_stats(struct ksz_device *dev, int port,
+			    struct ethtool_eth_mac_stats *mac_stats)
+{
+	struct ksz_port_mib *mib;
+	u64 *ctr;
+
+	mib = &dev->ports[port].mib;
+
+	mutex_lock(&mib->cnt_mutex);
+	ctr = mib->counters;
+
+	while (mib->cnt_ptr < dev->info->mib_cnt) {
+		dev->dev_ops->r_mib_pkt(dev, port, mib->cnt_ptr,
+			       NULL, &mib->counters[mib->cnt_ptr]);
+		++mib->cnt_ptr;
+	}
+
+	mac_stats->FramesTransmittedOK = ctr[KSZ8_TX_MCAST] +
+					 ctr[KSZ8_TX_BCAST] +
+					 ctr[KSZ8_TX_UCAST] +
+					 ctr[KSZ8_TX_PAUSE] -
+					 ctr[KSZ8_TX_DISCARDS];
+	mac_stats->SingleCollisionFrames = ctr[KSZ8_TX_SINGLE_COL];
+	mac_stats->MultipleCollisionFrames = ctr[KSZ8_TX_MULT_COL];
+	mac_stats->FramesReceivedOK = ctr[KSZ8_RX_MCAST] +
+				      ctr[KSZ8_RX_BCAST] +
+				      ctr[KSZ8_RX_UCAST] +
+				      ctr[KSZ8_RX_PAUSE] +
+				      ctr[KSZ8_RX_DISCARDS];
+	mac_stats->FrameCheckSequenceErrors = ctr[KSZ8_RX_CRC_ERR];
+	mac_stats->AlignmentErrors = ctr[KSZ8_RX_ALIGN_ERR];
+	mac_stats->FramesWithDeferredXmissions = ctr[KSZ8_TX_DEFERRED];
+	mac_stats->LateCollisions = ctr[KSZ8_TX_LATE_COL];
+	mac_stats->FramesAbortedDueToXSColls = ctr[KSZ8_TX_EXC_COL];
+	mac_stats->MulticastFramesXmittedOK = ctr[KSZ8_TX_MCAST];
+	mac_stats->BroadcastFramesXmittedOK = ctr[KSZ8_TX_BCAST];
+	mac_stats->MulticastFramesReceivedOK = ctr[KSZ8_RX_MCAST];
+	mac_stats->BroadcastFramesReceivedOK = ctr[KSZ8_RX_BCAST];
+
+	mib->cnt_ptr = 0;
+
+	mutex_unlock(&mib->cnt_mutex);
+}
+
 void ksz9477_get_rmon_stats(struct ksz_device *dev, int port,
 			    struct ethtool_rmon_stats *rmon_stats,
 			    const struct ethtool_rmon_hist_range **ranges)
@@ -220,3 +264,49 @@ void ksz9477_get_eth_ctrl_stats(struct ksz_device *dev, int port,
 
 	mutex_unlock(&mib->cnt_mutex);
 }
+
+void ksz9477_get_eth_mac_stats(struct ksz_device *dev, int port,
+			       struct ethtool_eth_mac_stats *mac_stats)
+{
+	struct ksz_port_mib *mib;
+	u64 *ctr;
+
+	mib = &dev->ports[port].mib;
+	ctr = mib->counters;
+
+	mutex_lock(&mib->cnt_mutex);
+
+	while (mib->cnt_ptr < dev->info->mib_cnt) {
+		dev->dev_ops->r_mib_pkt(dev, port, mib->cnt_ptr,
+			       NULL, &mib->counters[mib->cnt_ptr]);
+		++mib->cnt_ptr;
+	}
+
+	mac_stats->FramesTransmittedOK = ctr[KSZ9477_TX_MCAST] +
+					 ctr[KSZ9477_TX_BCAST] +
+					 ctr[KSZ9477_TX_UCAST] +
+					 ctr[KSZ9477_TX_PAUSE] -
+					 ctr[KSZ9477_TX_DISCARDS];
+	mac_stats->SingleCollisionFrames = ctr[KSZ9477_TX_SINGLE_COL];
+	mac_stats->MultipleCollisionFrames = ctr[KSZ9477_TX_MULT_COL];
+	mac_stats->FramesReceivedOK = ctr[KSZ9477_RX_MCAST] +
+				      ctr[KSZ9477_RX_BCAST] +
+				      ctr[KSZ9477_RX_UCAST] +
+				      ctr[KSZ9477_RX_PAUSE] +
+				      ctr[KSZ9477_RX_DISCARDS];
+	mac_stats->FrameCheckSequenceErrors = ctr[KSZ9477_RX_CRC_ERR];
+	mac_stats->AlignmentErrors = ctr[KSZ9477_RX_ALIGN_ERR];
+	mac_stats->OctetsTransmittedOK = ctr[KSZ9477_TX_TOTAL] -
+					 (18 * mac_stats->FramesTransmittedOK);
+	mac_stats->FramesWithDeferredXmissions = ctr[KSZ9477_TX_DEFERRED];
+	mac_stats->LateCollisions = ctr[KSZ9477_TX_LATE_COL];
+	mac_stats->FramesAbortedDueToXSColls = ctr[KSZ9477_TX_EXC_COL];
+	mac_stats->MulticastFramesXmittedOK = ctr[KSZ9477_TX_MCAST];
+	mac_stats->BroadcastFramesXmittedOK = ctr[KSZ9477_TX_BCAST];
+	mac_stats->MulticastFramesReceivedOK = ctr[KSZ9477_RX_MCAST];
+	mac_stats->BroadcastFramesReceivedOK = ctr[KSZ9477_RX_BCAST];
+
+	mib->cnt_ptr = 0;
+
+	mutex_unlock(&mib->cnt_mutex);
+}
diff --git a/drivers/net/dsa/microchip/ksz_ethtool.h b/drivers/net/dsa/microchip/ksz_ethtool.h
index 18dc155d60b9..2dcfe8922b4e 100644
--- a/drivers/net/dsa/microchip/ksz_ethtool.h
+++ b/drivers/net/dsa/microchip/ksz_ethtool.h
@@ -13,10 +13,14 @@ void ksz8_get_rmon_stats(struct ksz_device *dev, int port,
 			 const struct ethtool_rmon_hist_range **ranges);
 void ksz8_get_eth_ctrl_stats(struct ksz_device *dev, int port,
 			     struct ethtool_eth_ctrl_stats *ctrl_stats);
+void ksz8_get_eth_mac_stats(struct ksz_device *dev, int port,
+			    struct ethtool_eth_mac_stats *mac_stats);
 
 void ksz9477_get_rmon_stats(struct ksz_device *dev, int port,
 			    struct ethtool_rmon_stats *rmon_stats,
 			    const struct ethtool_rmon_hist_range **ranges);
 void ksz9477_get_eth_ctrl_stats(struct ksz_device *dev, int port,
 				struct ethtool_eth_ctrl_stats *ctrl_stats);
+void ksz9477_get_eth_mac_stats(struct ksz_device *dev, int port,
+			       struct ethtool_eth_mac_stats *mac_stats);
 #endif
-- 
2.34.1

