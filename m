Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1D2200B8D
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 16:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733152AbgFSOce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 10:32:34 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41296 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733222AbgFSOca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 10:32:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592577147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MfJ802Kpb9Yh8JoL2eNOANQFkrezjDOdO4+KEzduhNU=;
        b=Ibij+qFDAXnEw12Wr134Jz6gmtL77MOHIRKHB6peE5yIJT85Dmjoiy4XlsIJj5zW88tmyS
        nvIkYPJdgty0Nl/H7xe8npR8KXRSHXERgbyQ1IB5r9kb/TzPoJw9tTDFCGQjuL1uGZqymS
        phU8qAaxYwjt1FoJSIKdI473mAK0QPU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-1A88qpeoM6CtUaAQ_IXtdA-1; Fri, 19 Jun 2020 10:32:24 -0400
X-MC-Unique: 1A88qpeoM6CtUaAQ_IXtdA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67D991005513;
        Fri, 19 Jun 2020 14:32:22 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCD1D707C6;
        Fri, 19 Jun 2020 14:32:20 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v3 4/4] bonding: support hardware encryption offload to slaves
Date:   Fri, 19 Jun 2020 10:31:55 -0400
Message-Id: <20200619143155.20726-5-jarod@redhat.com>
In-Reply-To: <20200619143155.20726-1-jarod@redhat.com>
References: <20200619143155.20726-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, this support is limited to active-backup mode, as I'm not sure
about the feasilibity of mapping an xfrm_state's offload handle to
multiple hardware devices simultaneously, and we rely on being able to
pass some hints to both the xfrm and NIC driver about whether or not
they're operating on a slave device.

I've tested this atop an Intel x520 device (ixgbe) using libreswan in
transport mode, succesfully achieving ~4.3Gbps throughput with netperf
(more or less identical to throughput on a bare NIC in this system),
as well as successful failover and recovery mid-netperf.

v2: just use CONFIG_XFRM_OFFLOAD for wrapping, isolate more code with it

CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: "David S. Miller" <davem@davemloft.net>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Steffen Klassert <steffen.klassert@secunet.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: netdev@vger.kernel.org
CC: intel-wired-lan@lists.osuosl.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/bond_main.c | 127 +++++++++++++++++++++++++++++++-
 include/net/bonding.h           |   3 +
 2 files changed, 128 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 004919aea5fb..90939ccf2a94 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -79,6 +79,7 @@
 #include <net/pkt_sched.h>
 #include <linux/rculist.h>
 #include <net/flow_dissector.h>
+#include <net/xfrm.h>
 #include <net/bonding.h>
 #include <net/bond_3ad.h>
 #include <net/bond_alb.h>
@@ -278,8 +279,6 @@ const char *bond_mode_name(int mode)
 	return names[mode];
 }
 
-/*---------------------------------- VLAN -----------------------------------*/
-
 /**
  * bond_dev_queue_xmit - Prepare skb for xmit.
  *
@@ -302,6 +301,8 @@ netdev_tx_t bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb,
 	return dev_queue_xmit(skb);
 }
 
+/*---------------------------------- VLAN -----------------------------------*/
+
 /* In the following 2 functions, bond_vlan_rx_add_vid and bond_vlan_rx_kill_vid,
  * We don't protect the slave list iteration with a lock because:
  * a. This operation is performed in IOCTL context,
@@ -372,6 +373,84 @@ static int bond_vlan_rx_kill_vid(struct net_device *bond_dev,
 	return 0;
 }
 
+/*---------------------------------- XFRM -----------------------------------*/
+
+#ifdef CONFIG_XFRM_OFFLOAD
+/**
+ * bond_ipsec_add_sa - program device with a security association
+ * @xs: pointer to transformer state struct
+ **/
+static int bond_ipsec_add_sa(struct xfrm_state *xs)
+{
+	struct net_device *bond_dev = xs->xso.dev;
+	struct bonding *bond = netdev_priv(bond_dev);
+	struct slave *slave = rtnl_dereference(bond->curr_active_slave);
+
+	xs->xso.slave_dev = slave->dev;
+	bond->xs = xs;
+
+	if (!(slave->dev->xfrmdev_ops
+	      && slave->dev->xfrmdev_ops->xdo_dev_state_add)) {
+		slave_warn(bond_dev, slave->dev, "Slave does not support ipsec offload\n");
+		return -EINVAL;
+	}
+
+	return slave->dev->xfrmdev_ops->xdo_dev_state_add(xs);
+}
+
+/**
+ * bond_ipsec_del_sa - clear out this specific SA
+ * @xs: pointer to transformer state struct
+ **/
+static void bond_ipsec_del_sa(struct xfrm_state *xs)
+{
+	struct net_device *bond_dev = xs->xso.dev;
+	struct bonding *bond = netdev_priv(bond_dev);
+	struct slave *slave = rtnl_dereference(bond->curr_active_slave);
+
+	if (!slave)
+		return;
+
+	xs->xso.slave_dev = slave->dev;
+
+	if (!(slave->dev->xfrmdev_ops
+	      && slave->dev->xfrmdev_ops->xdo_dev_state_delete)) {
+		slave_warn(bond_dev, slave->dev, "%s: no slave xdo_dev_state_delete\n", __func__);
+		return;
+	}
+
+	slave->dev->xfrmdev_ops->xdo_dev_state_delete(xs);
+}
+
+/**
+ * bond_ipsec_offload_ok - can this packet use the xfrm hw offload
+ * @skb: current data packet
+ * @xs: pointer to transformer state struct
+ **/
+static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
+{
+	struct net_device *bond_dev = xs->xso.dev;
+	struct bonding *bond = netdev_priv(bond_dev);
+	struct slave *curr_active = rtnl_dereference(bond->curr_active_slave);
+	struct net_device *slave_dev = curr_active->dev;
+
+	if (!(slave_dev->xfrmdev_ops
+	      && slave_dev->xfrmdev_ops->xdo_dev_offload_ok)) {
+		slave_warn(bond_dev, slave_dev, "%s: no slave xdo_dev_offload_ok\n", __func__);
+		return false;
+	}
+
+	xs->xso.slave_dev = slave_dev;
+	return slave_dev->xfrmdev_ops->xdo_dev_offload_ok(skb, xs);
+}
+
+static const struct xfrmdev_ops bond_xfrmdev_ops = {
+	.xdo_dev_state_add = bond_ipsec_add_sa,
+	.xdo_dev_state_delete = bond_ipsec_del_sa,
+	.xdo_dev_offload_ok = bond_ipsec_offload_ok,
+};
+#endif /* CONFIG_XFRM_OFFLOAD */
+
 /*------------------------------- Link status -------------------------------*/
 
 /* Set the carrier state for the master according to the state of its
@@ -879,6 +958,11 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
 		return;
 
 	if (new_active) {
+#ifdef CONFIG_XFRM_OFFLOAD
+		if ((BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP) && bond->xs)
+			bond_ipsec_del_sa(bond->xs);
+#endif /* CONFIG_XFRM_OFFLOAD */
+
 		new_active->last_link_up = jiffies;
 
 		if (new_active->link == BOND_LINK_BACK) {
@@ -941,6 +1025,13 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
 					bond_should_notify_peers(bond);
 			}
 
+#ifdef CONFIG_XFRM_OFFLOAD
+			if (old_active && bond->xs) {
+				xfrm_dev_state_flush(dev_net(bond->dev), bond->dev, true);
+				bond_ipsec_add_sa(bond->xs);
+			}
+#endif /* CONFIG_XFRM_OFFLOAD */
+
 			call_netdevice_notifiers(NETDEV_BONDING_FAILOVER, bond->dev);
 			if (should_notify_peers) {
 				bond->send_peer_notif--;
@@ -1127,15 +1218,24 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 #define BOND_ENC_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
 				 NETIF_F_RXCSUM | NETIF_F_ALL_TSO)
 
+#ifdef CONFIG_XFRM_OFFLOAD
+#define BOND_XFRM_FEATURES	(NETIF_F_HW_ESP | NETIF_F_HW_ESP_TX_CSUM | \
+				 NETIF_F_GSO_ESP)
+#endif /* CONFIG_XFRM_OFFLOAD */
+
 #define BOND_MPLS_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
 				 NETIF_F_ALL_TSO)
 
+
 static void bond_compute_features(struct bonding *bond)
 {
 	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
 					IFF_XMIT_DST_RELEASE_PERM;
 	netdev_features_t vlan_features = BOND_VLAN_FEATURES;
 	netdev_features_t enc_features  = BOND_ENC_FEATURES;
+#ifdef CONFIG_XFRM_OFFLOAD
+	netdev_features_t xfrm_features  = BOND_XFRM_FEATURES;
+#endif /* CONFIG_XFRM_OFFLOAD */
 	netdev_features_t mpls_features  = BOND_MPLS_FEATURES;
 	struct net_device *bond_dev = bond->dev;
 	struct list_head *iter;
@@ -1157,6 +1257,12 @@ static void bond_compute_features(struct bonding *bond)
 							 slave->dev->hw_enc_features,
 							 BOND_ENC_FEATURES);
 
+#ifdef CONFIG_XFRM_OFFLOAD
+		xfrm_features = netdev_increment_features(xfrm_features,
+							  slave->dev->hw_enc_features,
+							  BOND_XFRM_FEATURES);
+#endif /* CONFIG_XFRM_OFFLOAD */
+
 		mpls_features = netdev_increment_features(mpls_features,
 							  slave->dev->mpls_features,
 							  BOND_MPLS_FEATURES);
@@ -1176,6 +1282,9 @@ static void bond_compute_features(struct bonding *bond)
 				    NETIF_F_HW_VLAN_CTAG_TX |
 				    NETIF_F_HW_VLAN_STAG_TX |
 				    NETIF_F_GSO_UDP_L4;
+#ifdef CONFIG_XFRM_OFFLOAD
+	bond_dev->hw_enc_features |= xfrm_features;
+#endif /* CONFIG_XFRM_OFFLOAD */
 	bond_dev->mpls_features = mpls_features;
 	bond_dev->gso_max_segs = gso_max_segs;
 	netif_set_gso_max_size(bond_dev, gso_max_size);
@@ -1464,6 +1573,9 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		slave_dbg(bond_dev, slave_dev, "is !NETIF_F_VLAN_CHALLENGED\n");
 	}
 
+	if (slave_dev->features & NETIF_F_HW_ESP)
+		slave_dbg(bond_dev, slave_dev, "is esp-hw-offload capable\n");
+
 	/* Old ifenslave binaries are no longer supported.  These can
 	 * be identified with moderate accuracy by the state of the slave:
 	 * the current ifenslave will set the interface down prior to
@@ -4540,6 +4652,13 @@ void bond_setup(struct net_device *bond_dev)
 	bond_dev->priv_flags |= IFF_BONDING | IFF_UNICAST_FLT | IFF_NO_QUEUE;
 	bond_dev->priv_flags &= ~(IFF_XMIT_DST_RELEASE | IFF_TX_SKB_SHARING);
 
+#ifdef CONFIG_XFRM_OFFLOAD
+	/* set up xfrm device ops (only supported in active-backup right now) */
+	if ((BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP))
+		bond_dev->xfrmdev_ops = &bond_xfrmdev_ops;
+	bond->xs = NULL;
+#endif /* CONFIG_XFRM_OFFLOAD */
+
 	/* don't acquire bond device's netif_tx_lock when transmitting */
 	bond_dev->features |= NETIF_F_LLTX;
 
@@ -4558,6 +4677,10 @@ void bond_setup(struct net_device *bond_dev)
 				NETIF_F_HW_VLAN_CTAG_FILTER;
 
 	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
+#ifdef CONFIG_XFRM_OFFLOAD
+	if ((BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP))
+		bond_dev->hw_features |= BOND_XFRM_FEATURES;
+#endif /* CONFIG_XFRM_OFFLOAD */
 	bond_dev->features |= bond_dev->hw_features;
 	bond_dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
 }
diff --git a/include/net/bonding.h b/include/net/bonding.h
index aa854a9c01e2..a00e1764e9b1 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -238,6 +238,9 @@ struct bonding {
 	struct	 dentry *debug_dir;
 #endif /* CONFIG_DEBUG_FS */
 	struct rtnl_link_stats64 bond_stats;
+#ifdef CONFIG_XFRM_OFFLOAD
+	struct xfrm_state *xs;
+#endif /* CONFIG_XFRM_OFFLOAD */
 };
 
 #define bond_slave_get_rcu(dev) \
-- 
2.20.1

