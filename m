Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4F963D6B9
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 14:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235767AbiK3NaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 08:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbiK3NaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 08:30:13 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C199071F0C;
        Wed, 30 Nov 2022 05:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669814997; x=1701350997;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GcfHlGYSRmzVmdhXul6GAVE2u5JqJYb0z41bOinu+S4=;
  b=utuKCcr22OeKA+MkmSVMJ6MwCQWm0S4SvlMi4qKTLJuWctiCAM09+Ajm
   Q5fP8YPYlmsbqvOyGNMa4xzE2EEMQiTgsJDtZn+xOey88iAORSZB6m1Ce
   XXtON87IalCA3ytdtsdk6fGu5qmnammFjENqlTtnPgOQlal3XZKgO3VAi
   DxymADpI3laFHbYFZpSAh9DibTIJPmUjVphrdnfSrzpMn9NyCW71NiMSi
   jZxWJbh2M/TyVvscrihEXZf6nncDyrb6KLBIvh6cVdeFRMgqy6FnqEd0S
   kwid4WCQ82RuTrLCWeNiJ3IpIC8/cHHpA/77GS5kR51zS3ACOaFJRLy0n
   g==;
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="191142269"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2022 06:29:57 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 30 Nov 2022 06:29:57 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 30 Nov 2022 06:29:53 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [RFC Patch net-next 3/5] net: dsa: microchip: add eth mac grouping for ethtool statistics
Date:   Wed, 30 Nov 2022 18:59:00 +0530
Message-ID: <20221130132902.2984580-4-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221130132902.2984580-1-rakesh.sankaranarayanan@microchip.com>
References: <20221130132902.2984580-1-rakesh.sankaranarayanan@microchip.com>
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
 drivers/net/dsa/microchip/ksz_ethtool.c | 88 +++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ethtool.h |  4 ++
 4 files changed, 107 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 9b13a38d553d..ceb3c4f120bd 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -160,6 +160,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.port_init_cnt = ksz8_port_init_cnt,
 	.get_rmon_stats = ksz8_get_rmon_stats,
 	.get_eth_ctrl_stats = ksz8_get_eth_ctrl_stats,
+	.get_eth_mac_stats = ksz8_get_eth_mac_stats,
 	.fdb_dump = ksz8_fdb_dump,
 	.mdb_add = ksz8_mdb_add,
 	.mdb_del = ksz8_mdb_del,
@@ -199,6 +200,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.port_init_cnt = ksz9477_port_init_cnt,
 	.get_rmon_stats = ksz9477_get_rmon_stats,
 	.get_eth_ctrl_stats = ksz9477_get_eth_ctrl_stats,
+	.get_eth_mac_stats = ksz9477_get_eth_mac_stats,
 	.vlan_filtering = ksz9477_port_vlan_filtering,
 	.vlan_add = ksz9477_port_vlan_add,
 	.vlan_del = ksz9477_port_vlan_del,
@@ -237,6 +239,7 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.port_init_cnt = ksz9477_port_init_cnt,
 	.get_rmon_stats = ksz9477_get_rmon_stats,
 	.get_eth_ctrl_stats = ksz9477_get_eth_ctrl_stats,
+	.get_eth_mac_stats = ksz9477_get_eth_mac_stats,
 	.vlan_filtering = ksz9477_port_vlan_filtering,
 	.vlan_add = ksz9477_port_vlan_add,
 	.vlan_del = ksz9477_port_vlan_del,
@@ -1635,6 +1638,15 @@ static void ksz_get_eth_ctrl_stats(struct dsa_switch *ds, int port,
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
@@ -2887,6 +2899,7 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.get_pause_stats	= ksz_get_pause_stats,
 	.get_rmon_stats		= ksz_get_rmon_stats,
 	.get_eth_ctrl_stats	= ksz_get_eth_ctrl_stats,
+	.get_eth_mac_stats	= ksz_get_eth_mac_stats,
 	.port_change_mtu	= ksz_change_mtu,
 	.port_max_mtu		= ksz_max_mtu,
 };
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 07627ff1a749..5b77f98483a9 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -344,6 +344,8 @@ struct ksz_dev_ops {
 			       const struct ethtool_rmon_hist_range **ranges);
 	void (*get_eth_ctrl_stats)(struct ksz_device *dev, int port,
 				   struct ethtool_eth_ctrl_stats *ctrl_stats);
+	void (*get_eth_mac_stats)(struct ksz_device *dev, int port,
+				  struct ethtool_eth_mac_stats *mac_stats);
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv);
diff --git a/drivers/net/dsa/microchip/ksz_ethtool.c b/drivers/net/dsa/microchip/ksz_ethtool.c
index 4c9ca21e1806..96529fea8e84 100644
--- a/drivers/net/dsa/microchip/ksz_ethtool.c
+++ b/drivers/net/dsa/microchip/ksz_ethtool.c
@@ -159,6 +159,50 @@ void ksz8_get_eth_ctrl_stats(struct ksz_device *dev, int port,
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
+	mac_stats->FramesTransmittedOK = ctr[ksz8_tx_mcast] +
+					 ctr[ksz8_tx_bcast] +
+					 ctr[ksz8_tx_ucast] +
+					 ctr[ksz8_tx_pause];
+	mac_stats->SingleCollisionFrames = ctr[ksz8_tx_single_col];
+	mac_stats->MultipleCollisionFrames = ctr[ksz8_tx_mult_col];
+	mac_stats->FramesReceivedOK = ctr[ksz8_rx_mcast] +
+				      ctr[ksz8_rx_bcast] +
+				      ctr[ksz8_rx_ucast] +
+				      ctr[ksz8_rx_pause];
+	mac_stats->FrameCheckSequenceErrors = ctr[ksz8_rx_crc_err];
+	mac_stats->AlignmentErrors = ctr[ksz8_rx_align_err];
+	mac_stats->OctetsTransmittedOK = ctr[ksz8_tx_total_col];
+	mac_stats->FramesWithDeferredXmissions = ctr[ksz8_tx_deferred];
+	mac_stats->LateCollisions = ctr[ksz8_tx_late_col];
+	mac_stats->FramesAbortedDueToXSColls = ctr[ksz8_tx_exc_col];
+	mac_stats->MulticastFramesXmittedOK = ctr[ksz8_tx_mcast];
+	mac_stats->BroadcastFramesXmittedOK = ctr[ksz8_tx_bcast];
+	mac_stats->MulticastFramesReceivedOK = ctr[ksz8_rx_mcast];
+	mac_stats->BroadcastFramesReceivedOK = ctr[ksz8_rx_bcast];
+	mac_stats->InRangeLengthErrors = ctr[ksz8_rx_oversize];
+
+	mib->cnt_ptr = 0;
+
+	mutex_unlock(&mib->cnt_mutex);
+}
+
 void ksz9477_get_rmon_stats(struct ksz_device *dev, int port,
 			    struct ethtool_rmon_stats *rmon_stats,
 			    const struct ethtool_rmon_hist_range **ranges)
@@ -218,3 +262,47 @@ void ksz9477_get_eth_ctrl_stats(struct ksz_device *dev, int port,
 
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
+	mac_stats->FramesTransmittedOK = ctr[ksz9477_tx_mcast] +
+					 ctr[ksz9477_tx_bcast] +
+					 ctr[ksz9477_tx_ucast] +
+					 ctr[ksz9477_tx_pause];
+	mac_stats->SingleCollisionFrames = ctr[ksz9477_tx_single_col];
+	mac_stats->MultipleCollisionFrames = ctr[ksz9477_tx_mult_col];
+	mac_stats->FramesReceivedOK = ctr[ksz9477_rx_mcast] +
+				      ctr[ksz9477_rx_bcast] +
+				      ctr[ksz9477_rx_ucast] +
+				      ctr[ksz9477_rx_pause];
+	mac_stats->FrameCheckSequenceErrors = ctr[ksz9477_rx_crc_err];
+	mac_stats->AlignmentErrors = ctr[ksz9477_rx_align_err];
+	mac_stats->OctetsTransmittedOK = ctr[ksz9477_tx_total_col];
+	mac_stats->FramesWithDeferredXmissions = ctr[ksz9477_tx_deferred];
+	mac_stats->LateCollisions = ctr[ksz9477_tx_late_col];
+	mac_stats->FramesAbortedDueToXSColls = ctr[ksz9477_tx_exc_col];
+	mac_stats->MulticastFramesXmittedOK = ctr[ksz9477_tx_mcast];
+	mac_stats->BroadcastFramesXmittedOK = ctr[ksz9477_tx_bcast];
+	mac_stats->MulticastFramesReceivedOK = ctr[ksz9477_rx_mcast];
+	mac_stats->BroadcastFramesReceivedOK = ctr[ksz9477_rx_bcast];
+	mac_stats->InRangeLengthErrors = ctr[ksz9477_rx_oversize];
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

