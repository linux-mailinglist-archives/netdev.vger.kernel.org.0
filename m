Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91F13D3E2D
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhGWQ1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:27:01 -0400
Received: from mga05.intel.com ([192.55.52.43]:12326 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231174AbhGWQ1A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 12:27:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10054"; a="297489716"
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="297489716"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2021 10:07:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="502586225"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Jul 2021 10:07:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>
Subject: [PATCH net 4/5] i40e: Fix queue-to-TC mapping on Tx
Date:   Fri, 23 Jul 2021 10:10:22 -0700
Message-Id: <20210723171023.296927-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210723171023.296927-1-anthony.l.nguyen@intel.com>
References: <20210723171023.296927-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

In SW DCB mode the packets sent receive incorrect UP tags. They are
constructed correctly and put into tx_ring, but UP is later remapped by
HW on the basis of TCTUPR register contents according to Tx queue
selected, and BW used is consistent with the new UP values. This is
caused by Tx queue selection in kernel not taking into account DCB
configuration. This patch fixes the issue by implementing the
ndo_select_queue NDO callback.

Fixes: fd0a05ce74ef ("i40e: transmit, receive, and NAPI")
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |  1 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 50 +++++++++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.h |  2 +
 3 files changed, 53 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 5297e6c59083..278077208f37 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13271,6 +13271,7 @@ static const struct net_device_ops i40e_netdev_ops = {
 	.ndo_poll_controller	= i40e_netpoll,
 #endif
 	.ndo_setup_tc		= __i40e_setup_tc,
+	.ndo_select_queue	= i40e_lan_select_queue,
 	.ndo_set_features	= i40e_set_features,
 	.ndo_set_vf_mac		= i40e_ndo_set_vf_mac,
 	.ndo_set_vf_vlan	= i40e_ndo_set_vf_port_vlan,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 38eb8151ee9a..3f25bd8c4924 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3631,6 +3631,56 @@ static inline int i40e_tx_map(struct i40e_ring *tx_ring, struct sk_buff *skb,
 	return -1;
 }
 
+static u16 i40e_swdcb_skb_tx_hash(struct net_device *dev,
+				  const struct sk_buff *skb,
+				  u16 num_tx_queues)
+{
+	u32 jhash_initval_salt = 0xd631614b;
+	u32 hash;
+
+	if (skb->sk && skb->sk->sk_hash)
+		hash = skb->sk->sk_hash;
+	else
+		hash = (__force u16)skb->protocol ^ skb->hash;
+
+	hash = jhash_1word(hash, jhash_initval_salt);
+
+	return (u16)(((u64)hash * num_tx_queues) >> 32);
+}
+
+u16 i40e_lan_select_queue(struct net_device *netdev,
+			  struct sk_buff *skb,
+			  struct net_device __always_unused *sb_dev)
+{
+	struct i40e_netdev_priv *np = netdev_priv(netdev);
+	struct i40e_vsi *vsi = np->vsi;
+	struct i40e_hw *hw;
+	u16 qoffset;
+	u16 qcount;
+	u8 tclass;
+	u16 hash;
+	u8 prio;
+
+	/* is DCB enabled at all? */
+	if (vsi->tc_config.numtc == 1)
+		return i40e_swdcb_skb_tx_hash(netdev, skb,
+					      netdev->real_num_tx_queues);
+
+	prio = skb->priority;
+	hw = &vsi->back->hw;
+	tclass = hw->local_dcbx_config.etscfg.prioritytable[prio];
+	/* sanity check */
+	if (unlikely(!(vsi->tc_config.enabled_tc & BIT(tclass))))
+		tclass = 0;
+
+	/* select a queue assigned for the given TC */
+	qcount = vsi->tc_config.tc_info[tclass].qcount;
+	hash = i40e_swdcb_skb_tx_hash(netdev, skb, qcount);
+
+	qoffset = vsi->tc_config.tc_info[tclass].qoffset;
+	return qoffset + hash;
+}
+
 /**
  * i40e_xmit_xdp_ring - transmits an XDP buffer to an XDP Tx ring
  * @xdpf: data to transmit
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 86fed05b4f19..bfc2845c99d1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -451,6 +451,8 @@ static inline unsigned int i40e_rx_pg_order(struct i40e_ring *ring)
 
 bool i40e_alloc_rx_buffers(struct i40e_ring *rxr, u16 cleaned_count);
 netdev_tx_t i40e_lan_xmit_frame(struct sk_buff *skb, struct net_device *netdev);
+u16 i40e_lan_select_queue(struct net_device *netdev, struct sk_buff *skb,
+			  struct net_device *sb_dev);
 void i40e_clean_tx_ring(struct i40e_ring *tx_ring);
 void i40e_clean_rx_ring(struct i40e_ring *rx_ring);
 int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring);
-- 
2.26.2

