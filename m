Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77B51C3DE9
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 17:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbgEDPAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 11:00:41 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21078 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729315AbgEDPAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 11:00:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588604439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rD9VYkezYm68DLy5dph4tU1iJLMZjlUwyGss8oFF0Sg=;
        b=SfQu/tCmqh6YFzsQYOxG6MFMbKAK6POjQx3OS/U3e57V71KC/T9SRuCdOgpfHx7Rx4JydJ
        AkGRA+IlVf1Xqfs5nK7RzWz4YD1JVhSW7irhxXg6T53wqJSr+F7GAVLTES+k/F3SUOnPOH
        pExSqi6tTgLhzGluKIc+/fHSlI2OTDc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-z-JY57fLOyiW7uKZwuDzFA-1; Mon, 04 May 2020 11:00:36 -0400
X-MC-Unique: z-JY57fLOyiW7uKZwuDzFA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BAFA1005510;
        Mon,  4 May 2020 15:00:34 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B1E46FF1E;
        Mon,  4 May 2020 15:00:33 +0000 (UTC)
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
Subject: [RFC PATCH net-next 3/3] bonding: support hardware encryption offload to slaves
Date:   Mon,  4 May 2020 10:59:43 -0400
Message-Id: <20200504145943.8841-4-jarod@redhat.com>
In-Reply-To: <20200504145943.8841-1-jarod@redhat.com>
References: <20200504145943.8841-1-jarod@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
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
 drivers/net/bonding/bond_main.c | 103 +++++++++++++++++++++++++++++++-
 include/net/bonding.h           |   1 +
 2 files changed, 101 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
index 2e70e43c5df5..781da5beb484 100644
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
=20
-/*---------------------------------- VLAN ------------------------------=
-----*/
-
 /**
  * bond_dev_queue_xmit - Prepare skb for xmit.
  *
@@ -302,6 +301,8 @@ void bond_dev_queue_xmit(struct bonding *bond, struct=
 sk_buff *skb,
 		dev_queue_xmit(skb);
 }
=20
+/*---------------------------------- VLAN ------------------------------=
-----*/
+
 /* In the following 2 functions, bond_vlan_rx_add_vid and bond_vlan_rx_k=
ill_vid,
  * We don't protect the slave list iteration with a lock because:
  * a. This operation is performed in IOCTL context,
@@ -372,6 +373,82 @@ static int bond_vlan_rx_kill_vid(struct net_device *=
bond_dev,
 	return 0;
 }
=20
+/*---------------------------------- XFRM ------------------------------=
-----*/
+
+/**
+ * bond_ipsec_add_sa - program device with a security association
+ * @xs: pointer to transformer state struct
+ **/
+static int bond_ipsec_add_sa(struct xfrm_state *xs)
+{
+	struct net_device *bond_dev =3D xs->xso.dev;
+	struct bonding *bond =3D netdev_priv(bond_dev);
+	struct slave *slave =3D rtnl_dereference(bond->curr_active_slave);
+
+	xs->xso.slave_dev =3D slave->dev;
+	bond->xs =3D xs;
+
+	if (!(slave->dev->xfrmdev_ops
+	      && slave->dev->xfrmdev_ops->xdo_dev_state_add)) {
+		slave_warn(bond_dev, slave->dev, "Slave does not support ipsec offload=
\n");
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
+	struct net_device *bond_dev =3D xs->xso.dev;
+	struct bonding *bond =3D netdev_priv(bond_dev);
+	struct slave *slave =3D rtnl_dereference(bond->curr_active_slave);
+
+	if (!slave)
+		return;
+
+	xs->xso.slave_dev =3D slave->dev;
+
+	if (!(slave->dev->xfrmdev_ops
+	      && slave->dev->xfrmdev_ops->xdo_dev_state_delete)) {
+		slave_warn(bond_dev, slave->dev, "%s: no slave xdo_dev_state_delete\n"=
, __func__);
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
+static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state=
 *xs)
+{
+	struct net_device *bond_dev =3D xs->xso.dev;
+	struct bonding *bond =3D netdev_priv(bond_dev);
+	struct slave *curr_active =3D rtnl_dereference(bond->curr_active_slave)=
;
+	struct net_device *slave_dev =3D curr_active->dev;
+
+	if (!(slave_dev->xfrmdev_ops
+	      && slave_dev->xfrmdev_ops->xdo_dev_offload_ok)) {
+		slave_warn(bond_dev, slave_dev, "%s: no slave xdo_dev_offload_ok\n", _=
_func__);
+		return false;
+	}
+
+	xs->xso.slave_dev =3D slave_dev;
+	return slave_dev->xfrmdev_ops->xdo_dev_offload_ok(skb, xs);
+}
+
+static const struct xfrmdev_ops bond_xfrmdev_ops =3D {
+	.xdo_dev_state_add =3D bond_ipsec_add_sa,
+	.xdo_dev_state_delete =3D bond_ipsec_del_sa,
+	.xdo_dev_offload_ok =3D bond_ipsec_offload_ok,
+};
+
 /*------------------------------- Link status --------------------------=
-----*/
=20
 /* Set the carrier state for the master according to the state of its
@@ -878,6 +955,9 @@ void bond_change_active_slave(struct bonding *bond, s=
truct slave *new_active)
 	if (old_active =3D=3D new_active)
 		return;
=20
+	if ((BOND_MODE(bond) =3D=3D BOND_MODE_ACTIVEBACKUP) && bond->xs)
+		bond_ipsec_del_sa(bond->xs);
+
 	if (new_active) {
 		new_active->last_link_up =3D jiffies;
=20
@@ -941,6 +1021,11 @@ void bond_change_active_slave(struct bonding *bond,=
 struct slave *new_active)
 					bond_should_notify_peers(bond);
 			}
=20
+			if (old_active && bond->xs) {
+				xfrm_dev_state_flush(dev_net(bond->dev), bond->dev, true);
+				bond_ipsec_add_sa(bond->xs);
+			}
+
 			call_netdevice_notifiers(NETDEV_BONDING_FAILOVER, bond->dev);
 			if (should_notify_peers) {
 				bond->send_peer_notif--;
@@ -1125,7 +1210,9 @@ static netdev_features_t bond_fix_features(struct n=
et_device *dev,
 				 NETIF_F_HIGHDMA | NETIF_F_LRO)
=20
 #define BOND_ENC_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
-				 NETIF_F_RXCSUM | NETIF_F_ALL_TSO)
+				 NETIF_F_RXCSUM | NETIF_F_ALL_TSO | \
+				 NETIF_F_HW_ESP | NETIF_F_HW_ESP_TX_CSUM | \
+				 NETIF_F_GSO_ESP)
=20
 #define BOND_MPLS_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
 				 NETIF_F_ALL_TSO)
@@ -1464,6 +1551,9 @@ int bond_enslave(struct net_device *bond_dev, struc=
t net_device *slave_dev,
 		slave_dbg(bond_dev, slave_dev, "is !NETIF_F_VLAN_CHALLENGED\n");
 	}
=20
+	if (slave_dev->features & NETIF_F_HW_ESP)
+		slave_dbg(bond_dev, slave_dev, "is esp-hw-offload capable\n");
+
 	/* Old ifenslave binaries are no longer supported.  These can
 	 * be identified with moderate accuracy by the state of the slave:
 	 * the current ifenslave will set the interface down prior to
@@ -4444,6 +4534,11 @@ void bond_setup(struct net_device *bond_dev)
 	bond_dev->priv_flags |=3D IFF_BONDING | IFF_UNICAST_FLT | IFF_NO_QUEUE;
 	bond_dev->priv_flags &=3D ~(IFF_XMIT_DST_RELEASE | IFF_TX_SKB_SHARING);
=20
+	/* set up xfrm device ops (only supported in active-backup right now */
+	if ((BOND_MODE(bond) =3D=3D BOND_MODE_ACTIVEBACKUP))
+		bond_dev->xfrmdev_ops =3D &bond_xfrmdev_ops;
+	bond->xs =3D NULL;
+
 	/* don't acquire bond device's netif_tx_lock when transmitting */
 	bond_dev->features |=3D NETIF_F_LLTX;
=20
@@ -4462,6 +4557,8 @@ void bond_setup(struct net_device *bond_dev)
 				NETIF_F_HW_VLAN_CTAG_FILTER;
=20
 	bond_dev->hw_features |=3D NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
+	if ((BOND_MODE(bond) =3D=3D BOND_MODE_ACTIVEBACKUP))
+		bond_dev->hw_features |=3D BOND_ENC_FEATURES;
 	bond_dev->features |=3D bond_dev->hw_features;
 	bond_dev->features |=3D NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_=
TX;
 }
diff --git a/include/net/bonding.h b/include/net/bonding.h
index dc2ce31a1f52..854b46511bd8 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -238,6 +238,7 @@ struct bonding {
 #endif /* CONFIG_DEBUG_FS */
 	struct rtnl_link_stats64 bond_stats;
 	struct lock_class_key stats_lock_key;
+	struct xfrm_state *xs;
 };
=20
 #define bond_slave_get_rcu(dev) \
--=20
2.20.1

