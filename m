Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5E28195F5A
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgC0T4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:56:06 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51031 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgC0T4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 15:56:00 -0400
Received: by mail-wm1-f68.google.com with SMTP id d198so12786497wmd.0
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 12:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uKT4sM2a4Y3Y4DQf/tZwSDT5tBzfx2Q86J/zyAIHVt0=;
        b=soUoCOqZkG1gmK7mz+g9sO/Rs7qglhnz67ahnd6d4R+py6yja+4/QIiti/d1l1ptSN
         3HwSkdo487XKs4caRXvpFsWZHq97Qzpv578lMZ7Ed4/YmVKnVhOF/aWeBz2Y7v3fd/+J
         Hh+/vIhAs7JOk1BAXIsSy50qWhHPd8w2yow2og9pxlgB4D1pmR5DqyTEcsNovIQqQivM
         gwLhPhDJuVU2z6tV2fJyiLihbYQyU1VrJ+rowB0ZV6cXJN+NkERc8ChaZ32CkLorAwXZ
         zw5lT/IKuLCAEaNVKFU4SHHmnvXsdXWBslkqsRvH/fM/JGdgysQQsYinK5MhYvfN9vpy
         xDQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uKT4sM2a4Y3Y4DQf/tZwSDT5tBzfx2Q86J/zyAIHVt0=;
        b=syE9KI8UdYd7HR8BoE1+rZ1Def7InAQDBKVvmcp1+dkRIFHCXcxbClJFYdRCMBwGPj
         eGbCx3WH6CQu0TkKPMmPmlf53d3gqHFhDhpkYtKHz8ZdmRNpas3Ym0FUbiw6S3NIXrSK
         KAwfIxgNtSkXiE2Cn9OhpPzZwV0xdiz5ya58rzH9lLFmY1dMRdO8nbcwJh7nzN/4KeUZ
         f0leBcyct85V9gU0QjR7H6QDrKYrMMKyrNfJfC57KA2rpytBvQY1YtD33jOBK01DxdBh
         jT6bAdJDg8yszjkqjepGjra9J9C3nOsJAOV4GLhWyE/RXLeV6zgM3siH0J6waVxYkaEo
         PETA==
X-Gm-Message-State: ANhLgQ3qiGaqg6EtHb2CdqxSWZ6uMrjhTk2zIyuAw/B0DjvkYtO8ec3T
        x0wwneOMl+AHXGd5U51ga7A=
X-Google-Smtp-Source: ADFU+vvIC8nSpCsYoEuQcwYJtAC53XCuaaUm21sylFEkNgXzavfkcm/DIO7FtbdoVlRlH897eaR7QQ==
X-Received: by 2002:a05:600c:24c:: with SMTP id 12mr290911wmj.186.1585338959174;
        Fri, 27 Mar 2020 12:55:59 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id z19sm10089479wrg.28.2020.03.27.12.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 12:55:58 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v4 net-next 4/8] net: dsa: implement auto-normalization of MTU for bridge hardware datapath
Date:   Fri, 27 Mar 2020 21:55:43 +0200
Message-Id: <20200327195547.11583-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327195547.11583-1-olteanv@gmail.com>
References: <20200327195547.11583-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Many switches don't have an explicit knob for configuring the MTU
(maximum transmission unit per interface).  Instead, they do the
length-based packet admission checks on the ingress interface, for
reasons that are easy to understand (why would you accept a packet in
the queuing subsystem if you know you're going to drop it anyway).

So it is actually the MRU that these switches permit configuring.

In Linux there only exists the IFLA_MTU netlink attribute and the
associated dev_set_mtu function. The comments like to play blind and say
that it's changing the "maximum transfer unit", which is to say that
there isn't any directionality in the meaning of the MTU word. So that
is the interpretation that this patch is giving to things: MTU == MRU.

When 2 interfaces having different MTUs are bridged, the bridge driver
MTU auto-adjustment logic kicks in: what br_mtu_auto_adjust() does is it
adjusts the MTU of the bridge net device itself (and not that of the
slave net devices) to the minimum value of all slave interfaces, in
order for forwarded packets to not exceed the MTU regardless of the
interface they are received and send on.

The idea behind this behavior, and why the slave MTUs are not adjusted,
is that normal termination from Linux over the L2 forwarding domain
should happen over the bridge net device, which _is_ properly limited by
the minimum MTU. And termination over individual slave devices is
possible even if those are bridged. But that is not "forwarding", so
there's no reason to do normalization there, since only a single
interface sees that packet.

The problem with those switches that can only control the MRU is with
the offloaded data path, where a packet received on an interface with
MRU 9000 would still be forwarded to an interface with MRU 1500. And the
br_mtu_auto_adjust() function does not really help, since the MTU
configured on the bridge net device is ignored.

In order to enforce the de-facto MTU == MRU rule for these switches, we
need to do MTU normalization, which means: in order for no packet larger
than the MTU configured on this port to be sent, then we need to limit
the MRU on all ports that this packet could possibly come from. AKA
since we are configuring the MRU via MTU, it means that all ports within
a bridge forwarding domain should have the same MTU.

And that is exactly what this patch is trying to do.

From an implementation perspective, we try to follow the intent of the
user, otherwise there is a risk that we might livelock them (they try to
change the MTU on an already-bridged interface, but we just keep
changing it back in an attempt to keep the MTU normalized). So the MTU
that the bridge is normalized to is either:

 - The most recently changed one:

   ip link set dev swp0 master br0
   ip link set dev swp1 master br0
   ip link set dev swp0 mtu 1400

   This sequence will make swp1 inherit MTU 1400 from swp0.

 - The one of the most recently added interface to the bridge:

   ip link set dev swp0 master br0
   ip link set dev swp1 mtu 1400
   ip link set dev swp1 master br0

   The above sequence will make swp0 inherit MTU 1400 as well.

Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
None.

Changes in v3:
Moved the implementation to the DSA core (it was in the bridge driver
previously).
Added a variable by which drivers should denote if they require this
behavior or not.

Changes in v2:
Patch is new.

 include/net/dsa.h  |   6 +++
 net/dsa/dsa2.c     |   2 +-
 net/dsa/dsa_priv.h |   4 ++
 net/dsa/slave.c    | 114 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 125 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 8fc34d70a77d..aeb411e77b9a 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -284,6 +284,12 @@ struct dsa_switch {
 	 */
 	bool			pcs_poll;
 
+	/* For switches that only have the MRU configurable. To ensure the
+	 * configured MTU is not exceeded, normalization of MRU on all bridged
+	 * interfaces is needed.
+	 */
+	bool			mtu_enforcement_ingress;
+
 	size_t num_ports;
 };
 
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index e7c30b472034..9a271a58a41d 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -18,8 +18,8 @@
 
 #include "dsa_priv.h"
 
-static LIST_HEAD(dsa_tree_list);
 static DEFINE_MUTEX(dsa2_mutex);
+LIST_HEAD(dsa_tree_list);
 
 static const struct devlink_ops dsa_devlink_ops = {
 };
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index da3be60beefe..904cc7c9b882 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -194,4 +194,8 @@ dsa_slave_to_master(const struct net_device *dev)
 /* switch.c */
 int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
+
+/* dsa2.c */
+extern struct list_head dsa_tree_list;
+
 #endif
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 1a99bbab0722..8ced165a7908 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1218,6 +1218,116 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	return dsa_port_vid_del(dp, vid);
 }
 
+struct dsa_hw_port {
+	struct list_head list;
+	struct net_device *dev;
+	int old_mtu;
+};
+
+static int dsa_hw_port_list_set_mtu(struct list_head *hw_port_list, int mtu)
+{
+	const struct dsa_hw_port *p;
+	int err;
+
+	list_for_each_entry(p, hw_port_list, list) {
+		if (p->dev->mtu == mtu)
+			continue;
+
+		err = dev_set_mtu(p->dev, mtu);
+		if (err)
+			goto rollback;
+	}
+
+	return 0;
+
+rollback:
+	list_for_each_entry_continue_reverse(p, hw_port_list, list) {
+		if (p->dev->mtu == p->old_mtu)
+			continue;
+
+		if (dev_set_mtu(p->dev, p->old_mtu))
+			netdev_err(p->dev, "Failed to restore MTU\n");
+	}
+
+	return err;
+}
+
+static void dsa_hw_port_list_free(struct list_head *hw_port_list)
+{
+	struct dsa_hw_port *p, *n;
+
+	list_for_each_entry_safe(p, n, hw_port_list, list)
+		kfree(p);
+}
+
+/* Make the hardware datapath to/from @dev limited to a common MTU */
+void dsa_bridge_mtu_normalization(struct dsa_port *dp)
+{
+	struct list_head hw_port_list;
+	struct dsa_switch_tree *dst;
+	int min_mtu = ETH_MAX_MTU;
+	struct dsa_port *other_dp;
+	int err;
+
+	if (!dp->ds->mtu_enforcement_ingress)
+		return;
+
+	if (!dp->bridge_dev)
+		return;
+
+	INIT_LIST_HEAD(&hw_port_list);
+
+	/* Populate the list of ports that are part of the same bridge
+	 * as the newly added/modified port
+	 */
+	list_for_each_entry(dst, &dsa_tree_list, list) {
+		list_for_each_entry(other_dp, &dst->ports, list) {
+			struct dsa_hw_port *hw_port;
+			struct net_device *slave;
+
+			if (other_dp->type != DSA_PORT_TYPE_USER)
+				continue;
+
+			if (other_dp->bridge_dev != dp->bridge_dev)
+				continue;
+
+			if (!other_dp->ds->mtu_enforcement_ingress)
+				continue;
+
+			slave = other_dp->slave;
+
+			if (min_mtu > slave->mtu)
+				min_mtu = slave->mtu;
+
+			hw_port = kzalloc(sizeof(*hw_port), GFP_KERNEL);
+			if (!hw_port)
+				goto out;
+
+			hw_port->dev = slave;
+			hw_port->old_mtu = slave->mtu;
+
+			list_add(&hw_port->list, &hw_port_list);
+		}
+	}
+
+	/* Attempt to configure the entire hardware bridge to the newly added
+	 * interface's MTU first, regardless of whether the intention of the
+	 * user was to raise or lower it.
+	 */
+	err = dsa_hw_port_list_set_mtu(&hw_port_list, dp->slave->mtu);
+	if (!err)
+		goto out;
+
+	/* Clearly that didn't work out so well, so just set the minimum MTU on
+	 * all hardware bridge ports now. If this fails too, then all ports will
+	 * still have their old MTU rolled back anyway.
+	 */
+	dsa_hw_port_list_set_mtu(&hw_port_list, min_mtu);
+
+out:
+	dsa_hw_port_list_free(&hw_port_list);
+}
+
 static int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
@@ -1294,6 +1404,8 @@ static int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 
 	dev->mtu = new_mtu;
 
+	dsa_bridge_mtu_normalization(dp);
+
 	return 0;
 
 out_port_failed:
@@ -1648,6 +1760,8 @@ static int dsa_slave_changeupper(struct net_device *dev,
 	if (netif_is_bridge_master(info->upper_dev)) {
 		if (info->linking) {
 			err = dsa_port_bridge_join(dp, info->upper_dev);
+			if (!err)
+				dsa_bridge_mtu_normalization(dp);
 			err = notifier_from_errno(err);
 		} else {
 			dsa_port_bridge_leave(dp, info->upper_dev);
-- 
2.17.1

