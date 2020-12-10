Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4A12D5006
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 02:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731194AbgLJBEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 20:04:35 -0500
Received: from mga12.intel.com ([192.55.52.136]:15984 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730495AbgLJBEM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 20:04:12 -0500
IronPort-SDR: 93pXWcx15Rk/Smo4of5eEmXUxS2R1xGkoZ/IoN8BU/MlpToXjVyBa86kt1rl21clyuWSc9suUN
 hzziit6fuPTw==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="153414666"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="153414666"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 17:02:59 -0800
IronPort-SDR: 7RDmZhzhTZt0i5mmxYXGPH/B+rtNRfyQNcjX2UnjQsSDFJ3FirV6z/1J5nUuw3xZGoViODDY0X
 +lmYx8Xzwq8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="338203376"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 09 Dec 2020 17:02:59 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sven Auhagen <sven.auhagen@voleatech.de>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [net 2/9] igb: take VLAN double header into account
Date:   Wed,  9 Dec 2020 17:02:45 -0800
Message-Id: <20201210010252.4029245-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201210010252.4029245-1-anthony.l.nguyen@intel.com>
References: <20201210010252.4029245-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

Increase the packet header padding to include double VLAN tagging.
This patch uses a macro for this.

Fixes: 9cbc948b5a20 ("igb: add XDP support")
Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb.h      | 5 +++++
 drivers/net/ethernet/intel/igb/igb_main.c | 7 +++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
index 0286d2fceee4..aaa954aae574 100644
--- a/drivers/net/ethernet/intel/igb/igb.h
+++ b/drivers/net/ethernet/intel/igb/igb.h
@@ -138,6 +138,8 @@ struct vf_mac_filter {
 /* this is the size past which hardware will drop packets when setting LPE=0 */
 #define MAXIMUM_ETHERNET_VLAN_SIZE 1522
 
+#define IGB_ETH_PKT_HDR_PAD	(ETH_HLEN + ETH_FCS_LEN + (VLAN_HLEN * 2))
+
 /* Supported Rx Buffer Sizes */
 #define IGB_RXBUFFER_256	256
 #define IGB_RXBUFFER_1536	1536
@@ -247,6 +249,9 @@ enum igb_tx_flags {
 #define IGB_SFF_ADDRESSING_MODE		0x4
 #define IGB_SFF_8472_UNSUP		0x00
 
+/* TX resources are shared between XDP and netstack
+ * and we need to tag the buffer type to distinguish them
+ */
 enum igb_tx_buf_type {
 	IGB_TYPE_SKB = 0,
 	IGB_TYPE_XDP,
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 08cc6f59aa2e..0a9198037b98 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2826,7 +2826,7 @@ static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 
 static int igb_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 {
-	int i, frame_size = dev->mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
+	int i, frame_size = dev->mtu + IGB_ETH_PKT_HDR_PAD;
 	struct igb_adapter *adapter = netdev_priv(dev);
 	bool running = netif_running(dev);
 	struct bpf_prog *old_prog;
@@ -3950,8 +3950,7 @@ static int igb_sw_init(struct igb_adapter *adapter)
 	/* set default work limits */
 	adapter->tx_work_limit = IGB_DEFAULT_TX_WORK;
 
-	adapter->max_frame_size = netdev->mtu + ETH_HLEN + ETH_FCS_LEN +
-				  VLAN_HLEN;
+	adapter->max_frame_size = netdev->mtu + IGB_ETH_PKT_HDR_PAD;
 	adapter->min_frame_size = ETH_ZLEN + ETH_FCS_LEN;
 
 	spin_lock_init(&adapter->nfc_lock);
@@ -6491,7 +6490,7 @@ static void igb_get_stats64(struct net_device *netdev,
 static int igb_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
-	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
+	int max_frame = new_mtu + IGB_ETH_PKT_HDR_PAD;
 
 	if (adapter->xdp_prog) {
 		int i;
-- 
2.26.2

