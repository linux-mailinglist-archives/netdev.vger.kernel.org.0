Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBB0209E31
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 14:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404575AbgFYMLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 08:11:42 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:59514 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404571AbgFYMLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 08:11:40 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05PCBZ51025245;
        Thu, 25 Jun 2020 05:11:36 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next 3/3] cxgb4: add main VI to mirror VI config replication
Date:   Thu, 25 Jun 2020 17:28:43 +0530
Message-Id: <49115de640336dc419200a740b58793ac26a674e.1593085107.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1593085107.git.rahul.lakkireddy@chelsio.com>
References: <cover.1593085107.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1593085107.git.rahul.lakkireddy@chelsio.com>
References: <cover.1593085107.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When mirror VI is enabled, replicate various VI config params
enabled on main VI to mirror VI. These include replicating MTU,
promiscuous mode, all-multicast mode, and enabled netdev Rx
feature offloads.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 155 ++++++++++++++++--
 1 file changed, 143 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 0517eac4c8a5..7e7fd34c04a8 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -431,14 +431,32 @@ static int set_rxmode(struct net_device *dev, int mtu, bool sleep_ok)
 {
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
+	int ret;
 
 	__dev_uc_sync(dev, cxgb4_mac_sync, cxgb4_mac_unsync);
 	__dev_mc_sync(dev, cxgb4_mac_sync, cxgb4_mac_unsync);
 
-	return t4_set_rxmode(adapter, adapter->mbox, pi->viid, mtu,
-			     (dev->flags & IFF_PROMISC) ? 1 : 0,
-			     (dev->flags & IFF_ALLMULTI) ? 1 : 0, 1, -1,
-			     sleep_ok);
+	ret = t4_set_rxmode(adapter, adapter->mbox, pi->viid, mtu,
+			    (dev->flags & IFF_PROMISC) ? 1 : 0,
+			    (dev->flags & IFF_ALLMULTI) ? 1 : 0, 1, -1,
+			    sleep_ok);
+	if (ret)
+		return ret;
+
+	if (refcount_read(&pi->vi_mirror_refcnt)) {
+		ret = t4_set_rxmode(adapter, adapter->mbox, pi->viid_mirror,
+				    mtu, (dev->flags & IFF_PROMISC) ? 1 : 0,
+				    (dev->flags & IFF_ALLMULTI) ? 1 : 0, 1, -1,
+				    sleep_ok);
+		if (ret) {
+			dev_err(adapter->pdev_dev,
+				"Failed setting Rx Mode for Mirror VI 0x%x, ret: %d\n",
+				pi->viid_mirror, ret);
+			return ret;
+		}
+	}
+
+	return ret;
 }
 
 /**
@@ -1270,18 +1288,36 @@ int cxgb4_set_rspq_intr_params(struct sge_rspq *q,
 
 static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
 {
-	const struct port_info *pi = netdev_priv(dev);
 	netdev_features_t changed = dev->features ^ features;
+	const struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
 	int err;
 
 	if (!(changed & NETIF_F_HW_VLAN_CTAG_RX))
 		return 0;
 
-	err = t4_set_rxmode(pi->adapter, pi->adapter->pf, pi->viid, -1,
-			    -1, -1, -1,
+	err = t4_set_rxmode(adap, adap->mbox, pi->viid, -1, -1, -1, -1,
 			    !!(features & NETIF_F_HW_VLAN_CTAG_RX), true);
-	if (unlikely(err))
+	if (err)
+		goto out;
+
+	if (refcount_read(&pi->vi_mirror_refcnt)) {
+		err = t4_set_rxmode(adap, adap->mbox, pi->viid_mirror,
+				    -1, -1, -1, -1,
+				    !!(features & NETIF_F_HW_VLAN_CTAG_RX),
+				    true);
+		if (err) {
+			dev_err(adap->pdev_dev,
+				"Failed setting VLAN Rx mode for Mirror VI 0x%x, ret: %d\n",
+				pi->viid_mirror, err);
+			goto out;
+		}
+	}
+
+out:
+	if (err)
 		dev->features = features ^ NETIF_F_HW_VLAN_CTAG_RX;
+
 	return err;
 }
 
@@ -1452,6 +1488,74 @@ static void cxgb4_port_mirror_free_queues(struct net_device *dev)
 	mutex_unlock(&s->queue_mutex);
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
+	ret = t4_set_rxmode(adap, adap->mbox, pi->viid_mirror, dev->mtu,
+			    (dev->flags & IFF_PROMISC) ? 1 : 0,
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
@@ -1477,10 +1581,17 @@ int cxgb4_port_mirror_alloc(struct net_device *dev)
 		ret = cxgb4_port_mirror_alloc_queues(dev);
 		if (ret < 0)
 			goto out_free_vi;
+
+		ret = cxgb4_port_mirror_start(dev);
+		if (ret < 0)
+			goto out_free_queues;
 	}
 
 	return 0;
 
+out_free_queues:
+	cxgb4_port_mirror_free_queues(dev);
+
 out_free_vi:
 	refcount_set(&pi->vi_mirror_refcnt, 0);
 	t4_free_vi(adap, adap->mbox, adap->pf, 0, pi->viid_mirror);
@@ -1501,6 +1612,7 @@ void cxgb4_port_mirror_free(struct net_device *dev)
 		return;
 	}
 
+	cxgb4_port_mirror_stop(dev);
 	cxgb4_port_mirror_free_queues(dev);
 
 	refcount_set(&pi->vi_mirror_refcnt, 0);
@@ -2786,6 +2898,10 @@ int cxgb_open(struct net_device *dev)
 	if (err)
 		goto out_free;
 
+	err = cxgb4_port_mirror_start(dev);
+	if (err)
+		goto out_free;
+
 	netif_tx_start_all_queues(dev);
 	return err;
 
@@ -2811,6 +2927,7 @@ int cxgb_close(struct net_device *dev)
 	if (ret)
 		return ret;
 
+	cxgb4_port_mirror_stop(dev);
 	cxgb4_port_mirror_free_queues(dev);
 	return ret;
 }
@@ -3078,13 +3195,27 @@ static void cxgb_set_rxmode(struct net_device *dev)
 
 static int cxgb_change_mtu(struct net_device *dev, int new_mtu)
 {
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
 	int ret;
-	struct port_info *pi = netdev_priv(dev);
 
-	ret = t4_set_rxmode(pi->adapter, pi->adapter->pf, pi->viid, new_mtu, -1,
+	ret = t4_set_rxmode(adap, adap->mbox, pi->viid, new_mtu, -1,
 			    -1, -1, -1, true);
-	if (!ret)
-		dev->mtu = new_mtu;
+	if (ret)
+		return ret;
+
+	if (refcount_read(&pi->vi_mirror_refcnt)) {
+		ret = t4_set_rxmode(adap, adap->mbox, pi->viid_mirror,
+				    new_mtu, -1, -1, -1, -1, true);
+		if (ret) {
+			dev_err(adap->pdev_dev,
+				"MTU change for Mirror VI 0x%x error: %d\n",
+				pi->viid_mirror, ret);
+			return ret;
+		}
+	}
+
+	dev->mtu = new_mtu;
 	return ret;
 }
 
-- 
2.24.0

