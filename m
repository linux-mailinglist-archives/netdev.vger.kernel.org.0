Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072E020E911
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 01:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbgF2XDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 19:03:01 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:63608 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728318AbgF2XC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 19:02:58 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05TN2s1V012073;
        Mon, 29 Jun 2020 16:02:55 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: [PATCH net-next v2 3/3] cxgb4: add main VI to mirror VI config replication
Date:   Tue, 30 Jun 2020 04:19:53 +0530
Message-Id: <424999debcf44fe186a67f735b1913ceae8581bb.1593469163.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1593469163.git.rahul.lakkireddy@chelsio.com>
References: <cover.1593469163.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1593469163.git.rahul.lakkireddy@chelsio.com>
References: <cover.1593469163.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When mirror VI is enabled, replicate various VI config params
enabled on main VI to mirror VI. These include replicating MTU,
promiscuous mode, all-multicast mode, and enabled netdev Rx
feature offloads.

v2:
- Simplify the replication code by refactoring t4_set_rxmode()
  to handle mirror VI, instead of duplicating the t4_set_rxmode()
  calls in multiple places.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   4 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 100 ++++++++++++++++--
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    |  27 ++++-
 3 files changed, 114 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 8985d85a1530..cc009f7fa530 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -1984,8 +1984,8 @@ int t4_free_vi(struct adapter *adap, unsigned int mbox,
 	       unsigned int pf, unsigned int vf,
 	       unsigned int viid);
 int t4_set_rxmode(struct adapter *adap, unsigned int mbox, unsigned int viid,
-		int mtu, int promisc, int all_multi, int bcast, int vlanex,
-		bool sleep_ok);
+		  unsigned int viid_mirror, int mtu, int promisc, int all_multi,
+		  int bcast, int vlanex, bool sleep_ok);
 int t4_free_raw_mac_filt(struct adapter *adap, unsigned int viid,
 			 const u8 *addr, const u8 *mask, unsigned int idx,
 			 u8 lookup_type, u8 port_id, bool sleep_ok);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 00d8badc666c..3742e849547b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -435,8 +435,8 @@ static int set_rxmode(struct net_device *dev, int mtu, bool sleep_ok)
 	__dev_uc_sync(dev, cxgb4_mac_sync, cxgb4_mac_unsync);
 	__dev_mc_sync(dev, cxgb4_mac_sync, cxgb4_mac_unsync);
 
-	return t4_set_rxmode(adapter, adapter->mbox, pi->viid, mtu,
-			     (dev->flags & IFF_PROMISC) ? 1 : 0,
+	return t4_set_rxmode(adapter, adapter->mbox, pi->viid, pi->viid_mirror,
+			     mtu, (dev->flags & IFF_PROMISC) ? 1 : 0,
 			     (dev->flags & IFF_ALLMULTI) ? 1 : 0, 1, -1,
 			     sleep_ok);
 }
@@ -503,15 +503,16 @@ int cxgb4_change_mac(struct port_info *pi, unsigned int viid,
  */
 static int link_start(struct net_device *dev)
 {
-	int ret;
 	struct port_info *pi = netdev_priv(dev);
-	unsigned int mb = pi->adapter->pf;
+	unsigned int mb = pi->adapter->mbox;
+	int ret;
 
 	/*
 	 * We do not set address filters and promiscuity here, the stack does
 	 * that step explicitly.
 	 */
-	ret = t4_set_rxmode(pi->adapter, mb, pi->viid, dev->mtu, -1, -1, -1,
+	ret = t4_set_rxmode(pi->adapter, mb, pi->viid, pi->viid_mirror,
+			    dev->mtu, -1, -1, -1,
 			    !!(dev->features & NETIF_F_HW_VLAN_CTAG_RX), true);
 	if (ret == 0)
 		ret = cxgb4_update_mac_filt(pi, pi->viid, &pi->xact_addr_filt,
@@ -1270,15 +1271,15 @@ int cxgb4_set_rspq_intr_params(struct sge_rspq *q,
 
 static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
 {
-	const struct port_info *pi = netdev_priv(dev);
 	netdev_features_t changed = dev->features ^ features;
+	const struct port_info *pi = netdev_priv(dev);
 	int err;
 
 	if (!(changed & NETIF_F_HW_VLAN_CTAG_RX))
 		return 0;
 
-	err = t4_set_rxmode(pi->adapter, pi->adapter->pf, pi->viid, -1,
-			    -1, -1, -1,
+	err = t4_set_rxmode(pi->adapter, pi->adapter->mbox, pi->viid,
+			    pi->viid_mirror, -1, -1, -1, -1,
 			    !!(features & NETIF_F_HW_VLAN_CTAG_RX), true);
 	if (unlikely(err))
 		dev->features = features ^ NETIF_F_HW_VLAN_CTAG_RX;
@@ -1441,6 +1442,74 @@ static void cxgb4_port_mirror_free_queues(struct net_device *dev)
 	s->mirror_rxq[pi->port_id] = NULL;
 }
 
+static int cxgb4_port_mirror_start(struct net_device *dev)
+{
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	int ret, idx = -1;
+
+	if (!refcount_read(&pi->vi_mirror_refcnt))
+		return 0;
+
+	/* Mirror VIs can be created dynamically after stack had
+	 * already setup Rx modes like MTU, promisc, allmulti, etc.
+	 * on main VI. So, parse what the stack had setup on the
+	 * main VI and update the same on the mirror VI.
+	 */
+	ret = t4_set_rxmode(adap, adap->mbox, pi->viid, pi->viid_mirror,
+			    dev->mtu, (dev->flags & IFF_PROMISC) ? 1 : 0,
+			    (dev->flags & IFF_ALLMULTI) ? 1 : 0, 1,
+			    !!(dev->features & NETIF_F_HW_VLAN_CTAG_RX), true);
+	if (ret) {
+		dev_err(adap->pdev_dev,
+			"Failed start up Rx mode for Mirror VI 0x%x, ret: %d\n",
+			pi->viid_mirror, ret);
+		return ret;
+	}
+
+	/* Enable replication bit for the device's MAC address
+	 * in MPS TCAM, so that the packets for the main VI are
+	 * replicated to mirror VI.
+	 */
+	ret = cxgb4_update_mac_filt(pi, pi->viid_mirror, &idx,
+				    dev->dev_addr, true, NULL);
+	if (ret) {
+		dev_err(adap->pdev_dev,
+			"Failed updating MAC filter for Mirror VI 0x%x, ret: %d\n",
+			pi->viid_mirror, ret);
+		return ret;
+	}
+
+	/* Enabling a Virtual Interface can result in an interrupt
+	 * during the processing of the VI Enable command and, in some
+	 * paths, result in an attempt to issue another command in the
+	 * interrupt context. Thus, we disable interrupts during the
+	 * course of the VI Enable command ...
+	 */
+	local_bh_disable();
+	ret = t4_enable_vi_params(adap, adap->mbox, pi->viid_mirror, true, true,
+				  false);
+	local_bh_enable();
+	if (ret)
+		dev_err(adap->pdev_dev,
+			"Failed starting Mirror VI 0x%x, ret: %d\n",
+			pi->viid_mirror, ret);
+
+	return ret;
+}
+
+static void cxgb4_port_mirror_stop(struct net_device *dev)
+{
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+
+	if (!refcount_read(&pi->vi_mirror_refcnt))
+		return;
+
+	t4_enable_vi_params(adap, adap->mbox, pi->viid_mirror, false, false,
+			    false);
+}
+
 int cxgb4_port_mirror_alloc(struct net_device *dev)
 {
 	struct port_info *pi = netdev2pinfo(dev);
@@ -1467,11 +1536,18 @@ int cxgb4_port_mirror_alloc(struct net_device *dev)
 		ret = cxgb4_port_mirror_alloc_queues(dev);
 		if (ret)
 			goto out_free_vi;
+
+		ret = cxgb4_port_mirror_start(dev);
+		if (ret)
+			goto out_free_queues;
 	}
 
 	mutex_unlock(&pi->vi_mirror_mutex);
 	return 0;
 
+out_free_queues:
+	cxgb4_port_mirror_free_queues(dev);
+
 out_free_vi:
 	refcount_set(&pi->vi_mirror_refcnt, 0);
 	t4_free_vi(adap, adap->mbox, adap->pf, 0, pi->viid_mirror);
@@ -1496,6 +1572,7 @@ void cxgb4_port_mirror_free(struct net_device *dev)
 		goto out_unlock;
 	}
 
+	cxgb4_port_mirror_stop(dev);
 	cxgb4_port_mirror_free_queues(dev);
 
 	refcount_set(&pi->vi_mirror_refcnt, 0);
@@ -2816,6 +2893,7 @@ int cxgb_close(struct net_device *dev)
 
 	if (pi->nmirrorqsets) {
 		mutex_lock(&pi->vi_mirror_mutex);
+		cxgb4_port_mirror_stop(dev);
 		cxgb4_port_mirror_free_queues(dev);
 		mutex_unlock(&pi->vi_mirror_mutex);
 	}
@@ -3086,11 +3164,11 @@ static void cxgb_set_rxmode(struct net_device *dev)
 
 static int cxgb_change_mtu(struct net_device *dev, int new_mtu)
 {
-	int ret;
 	struct port_info *pi = netdev_priv(dev);
+	int ret;
 
-	ret = t4_set_rxmode(pi->adapter, pi->adapter->pf, pi->viid, new_mtu, -1,
-			    -1, -1, -1, true);
+	ret = t4_set_rxmode(pi->adapter, pi->adapter->mbox, pi->viid,
+			    pi->viid_mirror, new_mtu, -1, -1, -1, -1, true);
 	if (!ret)
 		dev->mtu = new_mtu;
 	return ret;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 7876aa392aae..0af5ee9975df 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -7711,6 +7711,7 @@ int t4_free_vi(struct adapter *adap, unsigned int mbox, unsigned int pf,
  *	@adap: the adapter
  *	@mbox: mailbox to use for the FW command
  *	@viid: the VI id
+ *	@viid_mirror: the mirror VI id
  *	@mtu: the new MTU or -1
  *	@promisc: 1 to enable promiscuous mode, 0 to disable it, -1 no change
  *	@all_multi: 1 to enable all-multi mode, 0 to disable it, -1 no change
@@ -7721,10 +7722,11 @@ int t4_free_vi(struct adapter *adap, unsigned int mbox, unsigned int pf,
  *	Sets Rx properties of a virtual interface.
  */
 int t4_set_rxmode(struct adapter *adap, unsigned int mbox, unsigned int viid,
-		  int mtu, int promisc, int all_multi, int bcast, int vlanex,
-		  bool sleep_ok)
+		  unsigned int viid_mirror, int mtu, int promisc, int all_multi,
+		  int bcast, int vlanex, bool sleep_ok)
 {
-	struct fw_vi_rxmode_cmd c;
+	struct fw_vi_rxmode_cmd c, c_mirror;
+	int ret;
 
 	/* convert to FW values */
 	if (mtu < 0)
@@ -7749,7 +7751,24 @@ int t4_set_rxmode(struct adapter *adap, unsigned int mbox, unsigned int viid,
 			    FW_VI_RXMODE_CMD_ALLMULTIEN_V(all_multi) |
 			    FW_VI_RXMODE_CMD_BROADCASTEN_V(bcast) |
 			    FW_VI_RXMODE_CMD_VLANEXEN_V(vlanex));
-	return t4_wr_mbox_meat(adap, mbox, &c, sizeof(c), NULL, sleep_ok);
+
+	if (viid_mirror) {
+		memcpy(&c_mirror, &c, sizeof(c_mirror));
+		c_mirror.op_to_viid =
+			cpu_to_be32(FW_CMD_OP_V(FW_VI_RXMODE_CMD) |
+				    FW_CMD_REQUEST_F | FW_CMD_WRITE_F |
+				    FW_VI_RXMODE_CMD_VIID_V(viid_mirror));
+	}
+
+	ret = t4_wr_mbox_meat(adap, mbox, &c, sizeof(c), NULL, sleep_ok);
+	if (ret)
+		return ret;
+
+	if (viid_mirror)
+		ret = t4_wr_mbox_meat(adap, mbox, &c_mirror, sizeof(c_mirror),
+				      NULL, sleep_ok);
+
+	return ret;
 }
 
 /**
-- 
2.24.0

