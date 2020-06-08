Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEBE1F211F
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 23:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgFHVBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 17:01:35 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27427 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726755AbgFHVBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 17:01:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591650074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TSAU50vi8cNVlrHpyyR2bbVyGTypH7X1UI15GDcnP9o=;
        b=X6NJqmEurO86NFgHkBKU3R1IuozgQyt+pw9i11qeUUk8ZNoiQKYSQUVyikq1SyqucvFRCU
        vLHntGopHc/71x4BzQMNXQULDBqBA5wyPdsWthPwtEsTyqP0Xfi73wcLsKBoQZvNZvdQV/
        ZvjdiXN3FWoXHANlqa4stQAjFXb1MZI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-Gio_8GCfN8OP-w7Q3mm5ow-1; Mon, 08 Jun 2020 17:01:13 -0400
X-MC-Unique: Gio_8GCfN8OP-w7Q3mm5ow-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 660981009444;
        Mon,  8 Jun 2020 21:01:11 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2949C6116D;
        Mon,  8 Jun 2020 21:01:10 +0000 (UTC)
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
Subject: [PATCH net-next 3/4] bonding: support hardware encryption offload to slaves
Date:   Mon,  8 Jun 2020 17:00:57 -0400
Message-Id: <20200608210058.37352-4-jarod@redhat.com>
In-Reply-To: <20200608210058.37352-1-jarod@redhat.com>
References: <20200608210058.37352-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

v2: rebase on latest net-next and wrap with #ifdef CONFIG_XFRM_OFFLOAD
v3: add new CONFIG_BOND_XFRM_OFFLOAD option and fix shutdown path

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

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/Kconfig             |  11 ++++
 drivers/net/bonding/bond_main.c | 111 +++++++++++++++++++++++++++++++-
 include/net/bonding.h           |   3 +
 3 files changed, 122 insertions(+), 3 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index c7d310ef1c83..938c4dd9bfb9 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -56,6 +56,17 @@ config BONDING
 	  To compile this driver as a module, choose M here: the module
 	  will be called bonding.
 
+config BONDING_XFRM_OFFLOAD
+	bool "Bonding driver IPSec XFRM cryptography-offload pass-through support"
+	depends on BONDING
+	depends on XFRM_OFFLOAD
+	default y
+	select XFRM_ALGO
+	---help---
+	  Enable support for IPSec offload pass-through in the bonding driver.
+	  Currently limited to active-backup mode only, and requires slave
+	  devices that support hardware crypto offload.
+
 config DUMMY
 	tristate "Dummy net driver support"
 	---help---
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index a25c65d4af71..01b80cef492a 100644
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
+#ifdef CONFIG_BONDING_XFRM_OFFLOAD
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
+#endif /* CONFIG_BONDING_XFRM_OFFLOAD */
+
 /*------------------------------- Link status -------------------------------*/
 
 /* Set the carrier state for the master according to the state of its
@@ -879,6 +958,11 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
 		return;
 
 	if (new_active) {
+#ifdef CONFIG_BONDING_XFRM_OFFLOAD
+		if ((BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP) && bond->xs)
+			bond_ipsec_del_sa(bond->xs);
+#endif /* CONFIG_BONDING_XFRM_OFFLOAD */
+
 		new_active->last_link_up = jiffies;
 
 		if (new_active->link == BOND_LINK_BACK) {
@@ -941,6 +1025,13 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
 					bond_should_notify_peers(bond);
 			}
 
+#ifdef CONFIG_BONDING_XFRM_OFFLOAD
+			if (old_active && bond->xs) {
+				xfrm_dev_state_flush(dev_net(bond->dev), bond->dev, true);
+				bond_ipsec_add_sa(bond->xs);
+			}
+#endif /* CONFIG_BONDING_XFRM_OFFLOAD */
+
 			call_netdevice_notifiers(NETDEV_BONDING_FAILOVER, bond->dev);
 			if (should_notify_peers) {
 				bond->send_peer_notif--;
@@ -1125,7 +1216,9 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 				 NETIF_F_HIGHDMA | NETIF_F_LRO)
 
 #define BOND_ENC_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
-				 NETIF_F_RXCSUM | NETIF_F_ALL_TSO)
+				 NETIF_F_RXCSUM | NETIF_F_ALL_TSO | \
+				 NETIF_F_HW_ESP | NETIF_F_HW_ESP_TX_CSUM | \
+				 NETIF_F_GSO_ESP)
 
 #define BOND_MPLS_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
 				 NETIF_F_ALL_TSO)
@@ -1464,6 +1557,9 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		slave_dbg(bond_dev, slave_dev, "is !NETIF_F_VLAN_CHALLENGED\n");
 	}
 
+	if (slave_dev->features & NETIF_F_HW_ESP)
+		slave_dbg(bond_dev, slave_dev, "is esp-hw-offload capable\n");
+
 	/* Old ifenslave binaries are no longer supported.  These can
 	 * be identified with moderate accuracy by the state of the slave:
 	 * the current ifenslave will set the interface down prior to
@@ -4542,6 +4638,13 @@ void bond_setup(struct net_device *bond_dev)
 	bond_dev->priv_flags |= IFF_BONDING | IFF_UNICAST_FLT | IFF_NO_QUEUE;
 	bond_dev->priv_flags &= ~(IFF_XMIT_DST_RELEASE | IFF_TX_SKB_SHARING);
 
+#ifdef CONFIG_BONDING_XFRM_OFFLOAD
+	/* set up xfrm device ops (only supported in active-backup right now) */
+	if ((BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP))
+		bond_dev->xfrmdev_ops = &bond_xfrmdev_ops;
+	bond->xs = NULL;
+#endif /* CONFIG_BONDING_XFRM_OFFLOAD */
+
 	/* don't acquire bond device's netif_tx_lock when transmitting */
 	bond_dev->features |= NETIF_F_LLTX;
 
@@ -4560,6 +4663,8 @@ void bond_setup(struct net_device *bond_dev)
 				NETIF_F_HW_VLAN_CTAG_FILTER;
 
 	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
+	if ((BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP))
+		bond_dev->hw_features |= BOND_ENC_FEATURES;
 	bond_dev->features |= bond_dev->hw_features;
 	bond_dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
 }
diff --git a/include/net/bonding.h b/include/net/bonding.h
index aa854a9c01e2..29a25098e2a6 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -238,6 +238,9 @@ struct bonding {
 	struct	 dentry *debug_dir;
 #endif /* CONFIG_DEBUG_FS */
 	struct rtnl_link_stats64 bond_stats;
+#ifdef CONFIG_BONDING_XFRM_OFFLOAD
+	struct xfrm_state *xs;
+#endif /* CONFIG_BONDING_XFRM_OFFLOAD */
 };
 
 #define bond_slave_get_rcu(dev) \
-- 
2.20.1

