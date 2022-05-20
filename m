Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3891452E1B5
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344367AbiETBQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344333AbiETBQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:16:01 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D13037A3C
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653009360; x=1684545360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ToFrcGDEUel6f39vr/QY0T+19wegr+R6/XL4zDIn5SM=;
  b=BRG884aN2Kunn4Q02UPSvfiblZ1Ogqg1IVS1EqmSbkw9hNddGUrudrQW
   jAwFyxbBbc1pByWjm62AONlvKSvb6oovG3Zbh659lfiRP7ggtWOMKthUS
   S9RNPDe9XXXMaiO//QuDlMPHiMAPiMpWUNV5Ssd6wKdDGtSNtNDRVFgaF
   YNzGf3jdi8M51wm8XAa/lUmldusl4gYN/JppuPSwH4ejb9ywIVLxy6fnO
   I5VZdkAIxrLcwDMMROzqN65FG8zLGd7d+2a8LCsqzk8/SkDUd5nPXfUuW
   x9jA5v0UGietuLEZs2AfCdbv6T9VVDulEvfifLa5qsHpU6WO6oFJRMkat
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="333064162"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="333064162"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 18:15:54 -0700
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="570534555"
Received: from vcostago-mobl3.jf.intel.com ([10.24.14.84])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 18:15:54 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v5 07/11] igc: Add support for enabling frame preemption via ethtool
Date:   Thu, 19 May 2022 18:15:34 -0700
Message-Id: <20220520011538.1098888-8-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220520011538.1098888-1-vinicius.gomes@intel.com>
References: <20220520011538.1098888-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for enabling frame preemption via ethtool. All that's left
for ethtool is to save the settings in the adapter state, and the
request for those settings to be applied.

It's done this because the TSN features (frame preemption is part of
them) interact with one another and it's better to keep track from a
central place.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |  3 ++
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 51 ++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 31e7b4c72894..df2fc71825a6 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -94,6 +94,7 @@ struct igc_ring {
 	u8 queue_index;                 /* logical index of the ring*/
 	u8 reg_idx;                     /* physical index of the ring */
 	bool launchtime_enable;         /* true if LaunchTime is enabled */
+	bool preemptible;               /* true if queue is preemptible */
 
 	u32 start_time;
 	u32 end_time;
@@ -182,6 +183,8 @@ struct igc_adapter {
 
 	ktime_t base_time;
 	ktime_t cycle_time;
+	bool frame_preemption_active;
+	u32 add_frag_size;
 
 	/* OS defined structs */
 	struct pci_dev *pdev;
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 8cc077b712ad..401d2cdb3e81 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -8,6 +8,7 @@
 
 #include "igc.h"
 #include "igc_diag.h"
+#include "igc_tsn.h"
 
 /* forward declaration */
 struct igc_stats {
@@ -1670,6 +1671,54 @@ static int igc_ethtool_set_eee(struct net_device *netdev,
 	return 0;
 }
 
+static int igc_ethtool_get_preempt(struct net_device *netdev,
+				   struct ethtool_fp *fpcmd)
+{
+	struct igc_adapter *adapter = netdev_priv(netdev);
+	u32 mask = 0;
+	int i;
+
+	fpcmd->enabled = adapter->frame_preemption_active;
+	fpcmd->add_frag_size = adapter->add_frag_size;
+
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		struct igc_ring *ring = adapter->tx_ring[i];
+
+		if (ring->preemptible)
+			mask |= BIT(i);
+	}
+
+	fpcmd->preemptible_mask = mask;
+
+	return 0;
+}
+
+static int igc_ethtool_set_preempt(struct net_device *netdev,
+				   struct ethtool_fp *fpcmd,
+				   struct netlink_ext_ack *extack)
+{
+	struct igc_adapter *adapter = netdev_priv(netdev);
+	u32 mask;
+	int i;
+
+	if (fpcmd->add_frag_size < 68 || fpcmd->add_frag_size > 260) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid value for add-frag-size");
+		return -EINVAL;
+	}
+
+	adapter->frame_preemption_active = fpcmd->enabled;
+	adapter->add_frag_size = fpcmd->add_frag_size;
+	mask = fpcmd->preemptible_mask;
+
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		struct igc_ring *ring = adapter->tx_ring[i];
+
+		ring->preemptible = (mask & BIT(i));
+	}
+
+	return igc_tsn_offload_apply(adapter);
+}
+
 static int igc_ethtool_begin(struct net_device *netdev)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
@@ -1963,6 +2012,8 @@ static const struct ethtool_ops igc_ethtool_ops = {
 	.get_ts_info		= igc_ethtool_get_ts_info,
 	.get_channels		= igc_ethtool_get_channels,
 	.set_channels		= igc_ethtool_set_channels,
+	.get_preempt		= igc_ethtool_get_preempt,
+	.set_preempt		= igc_ethtool_set_preempt,
 	.get_priv_flags		= igc_ethtool_get_priv_flags,
 	.set_priv_flags		= igc_ethtool_set_priv_flags,
 	.get_eee		= igc_ethtool_get_eee,
-- 
2.35.3

