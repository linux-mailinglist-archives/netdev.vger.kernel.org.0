Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67203B539F
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 16:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhF0ONC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 10:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhF0OMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 10:12:54 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4352C061767
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:29 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id i5so21273049eds.1
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+cGJ9JAiA7Sl2Lwm6rK5BJXR6mXB4qxtpp8wj3bA/Kk=;
        b=TgLiuSZOl10Bo0B/9cBH8iYsupBsF5ozCH/q5e9BEM2+0sOpKWmtk61Npsaon/S+rc
         THCzOaPIykcqhUeGcDvFZvAfJjfYASHSJPUonBxFCh7n79Km6/polgexTzmBGyvFwGz3
         VqyvCLLpELgN0TAcb97DN+POxlXzfsOu8wRNdryjVG7TiHC9dfExRYwJoffeSl7t37tE
         gwx9k86R1lqAmVHYQz3WBvu/sItjTHBbApfAsairpQvQ7pq3/q6bPgCtO0jGyaEBEnb2
         yZjyO0U2nz0ooOFox8YfN0+tnbmWZDOOGK5kLExUeoEFmcNTrnyZccsOWw6uqBbkljhm
         UNRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+cGJ9JAiA7Sl2Lwm6rK5BJXR6mXB4qxtpp8wj3bA/Kk=;
        b=bGRGXDHM6w+wUYDO7HOo+/up+Bk+YvcbsP+aHrm0qmEyWOarfB1N3rA43eoTSCztsK
         SmWYMwdjs1VJQQVStuGgYWvbXTqZbpsppK2vTYsfWFgvaW3FtNzBag1uJhPgo5pP2zmC
         fdy3/g01WhHvfnEbl77wouohs3RoTKtWFIFLBzmPNiPe7SzkHGdl0OuuKwhHl5DJ8Mob
         DA7O5COfGVPwAGVMKjtgk+TknSNzQMXxvCFodetiibd/MfuXCT4iZygX/fJygrW5AOgy
         Ky7QnxQab0skfwbiknWH+wKBJxHlJd3Lhnd2YCGLbHuX5fBquB1idc8a9GnrYVeuly5e
         Nadg==
X-Gm-Message-State: AOAM531t11pnpveEyWvcK/PwIZXznyE89oWyI4rUCQrSlj1HjDpDE2X2
        UvyCvdjdz2HA+A612wPqDOR+m+10pjs=
X-Google-Smtp-Source: ABdhPJwncvAbzr1uyO0Rd+dsgtmVHeqfTlwjnJOZgMf+vc0fNoSLg/y0m9weOIIoD0CrlyAut7f/Og==
X-Received: by 2002:a05:6402:896:: with SMTP id e22mr27193677edy.201.1624803028019;
        Sun, 27 Jun 2021 07:10:28 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7857389edu.49.2021.06.27.07.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 07:10:27 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v3 net-next 07/15] net: dsa: reference count the MDB entries at the cross-chip notifier level
Date:   Sun, 27 Jun 2021 17:10:05 +0300
Message-Id: <20210627141013.1273942-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627141013.1273942-1-olteanv@gmail.com>
References: <20210627141013.1273942-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Ever since the cross-chip notifiers were introduced, the design was
meant to be simplistic and just get the job done without worrying too
much about dangling resources left behind.

For example, somebody installs an MDB entry on sw0p0 in this daisy chain
topology. It gets installed using ds->ops->port_mdb_add() on sw0p0,
sw1p4 and sw2p4.

                                                    |
           sw0p0     sw0p1     sw0p2     sw0p3     sw0p4
        [  user ] [  user ] [  user ] [  dsa  ] [  cpu  ]
        [   x   ] [       ] [       ] [       ] [       ]
                                          |
                                          +---------+
                                                    |
           sw1p0     sw1p1     sw1p2     sw1p3     sw1p4
        [  user ] [  user ] [  user ] [  dsa  ] [  dsa  ]
        [       ] [       ] [       ] [       ] [   x   ]
                                          |
                                          +---------+
                                                    |
           sw2p0     sw2p1     sw2p2     sw2p3     sw2p4
        [  user ] [  user ] [  user ] [  user ] [  dsa  ]
        [       ] [       ] [       ] [       ] [   x   ]

Then the same person deletes that MDB entry. The cross-chip notifier for
deletion only matches sw0p0:

                                                    |
           sw0p0     sw0p1     sw0p2     sw0p3     sw0p4
        [  user ] [  user ] [  user ] [  dsa  ] [  cpu  ]
        [   x   ] [       ] [       ] [       ] [       ]
                                          |
                                          +---------+
                                                    |
           sw1p0     sw1p1     sw1p2     sw1p3     sw1p4
        [  user ] [  user ] [  user ] [  dsa  ] [  dsa  ]
        [       ] [       ] [       ] [       ] [       ]
                                          |
                                          +---------+
                                                    |
           sw2p0     sw2p1     sw2p2     sw2p3     sw2p4
        [  user ] [  user ] [  user ] [  user ] [  dsa  ]
        [       ] [       ] [       ] [       ] [       ]

Why?

Because the DSA links are 'trunk' ports, if we just go ahead and delete
the MDB from sw1p4 and sw2p4 directly, we might delete those multicast
entries when they are still needed. Just consider the fact that somebody
does:

- add a multicast MAC address towards sw0p0 [ via the cross-chip
  notifiers it gets installed on the DSA links too ]
- add the same multicast MAC address towards sw0p1 (another port of that
  same switch)
- delete the same multicast MAC address from sw0p0.

At this point, if we deleted the MAC address from the DSA links, it
would be flooded, even though there is still an entry on switch 0 which
needs it not to.

So that is why deletions only match the targeted source port and nothing
on DSA links. Of course, dangling resources means that the hardware
tables will eventually run out given enough additions/removals, but hey,
at least it's simple.

But there is a bigger concern which needs to be addressed, and that is
our support for SWITCHDEV_OBJ_ID_HOST_MDB. DSA simply translates such an
object into a dsa_port_host_mdb_add() which ends up as ds->ops->port_mdb_add()
on the upstream port, and a similar thing happens on deletion:
dsa_port_host_mdb_del() will trigger ds->ops->port_mdb_del() on the
upstream port.

When there are 2 VLAN-unaware bridges spanning the same switch (which is
a use case DSA proudly supports), each bridge will install its own
SWITCHDEV_OBJ_ID_HOST_MDB entries. But upon deletion, DSA goes ahead and
emits a DSA_NOTIFIER_MDB_DEL for dp->cpu_dp, which is shared between the
user ports enslaved to br0 and the user ports enslaved to br1. Not good.
The host-trapped multicast addresses installed by br1 will be deleted
when any state changes in br0 (IGMP timers expire, or ports leave, etc).

To avoid this, we could of course go the route of the zero-sum game and
delete the DSA_NOTIFIER_MDB_DEL call for dp->cpu_dp. But the better
design is to just admit that on shared ports like DSA links and CPU
ports, we should be reference counting calls, even if this consumes some
dynamic memory which DSA has traditionally avoided. On the flip side,
the hardware tables of switches are limited in size, so it would be good
if the OS managed them properly instead of having them eventually
overflow.

To address the memory usage concern, we only apply the refcounting of
MDB entries on ports that are really shared (CPU ports and DSA links)
and not on user ports. In a typical single-switch setup, this means only
the CPU port (and the host MDB entries are not that many, really).

The name of the newly introduced data structures (dsa_mac_addr) is
chosen in such a way that will be reusable for host FDB entries (next
patch).

With this change, we can finally have the same matching logic for the
MDB additions and deletions, as well as for their host-trapped variants.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h |  12 ++++++
 net/dsa/dsa2.c    |   8 ++++
 net/dsa/switch.c  | 104 ++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 115 insertions(+), 9 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 5f632cfd33c7..2c50546f9667 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -285,6 +285,11 @@ struct dsa_port {
 	 */
 	const struct dsa_netdevice_ops *netdev_ops;
 
+	/* List of MAC addresses that must be forwarded on this port.
+	 * These are only valid on CPU ports and DSA links.
+	 */
+	struct list_head	mdbs;
+
 	bool setup;
 };
 
@@ -299,6 +304,13 @@ struct dsa_link {
 	struct list_head list;
 };
 
+struct dsa_mac_addr {
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+	refcount_t refcount;
+	struct list_head list;
+};
+
 struct dsa_switch {
 	bool setup;
 
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 9000a8c84baf..2035d132682f 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -348,6 +348,8 @@ static int dsa_port_setup(struct dsa_port *dp)
 	if (dp->setup)
 		return 0;
 
+	INIT_LIST_HEAD(&dp->mdbs);
+
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
 		dsa_port_disable(dp);
@@ -443,6 +445,7 @@ static int dsa_port_devlink_setup(struct dsa_port *dp)
 static void dsa_port_teardown(struct dsa_port *dp)
 {
 	struct devlink_port *dlp = &dp->devlink_port;
+	struct dsa_mac_addr *a, *tmp;
 
 	if (!dp->setup)
 		return;
@@ -468,6 +471,11 @@ static void dsa_port_teardown(struct dsa_port *dp)
 		break;
 	}
 
+	list_for_each_entry_safe(a, tmp, &dp->mdbs, list) {
+		list_del(&a->list);
+		kfree(a);
+	}
+
 	dp->setup = false;
 }
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 7c5fe60a3763..10602a6da5e3 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -178,6 +178,84 @@ static bool dsa_switch_host_address_match(struct dsa_switch *ds, int port,
 	return false;
 }
 
+static struct dsa_mac_addr *dsa_mac_addr_find(struct list_head *addr_list,
+					      const unsigned char *addr,
+					      u16 vid)
+{
+	struct dsa_mac_addr *a;
+
+	list_for_each_entry(a, addr_list, list)
+		if (ether_addr_equal(a->addr, addr) && a->vid == vid)
+			return a;
+
+	return NULL;
+}
+
+static int dsa_switch_do_mdb_add(struct dsa_switch *ds, int port,
+				 const struct switchdev_obj_port_mdb *mdb)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_mac_addr *a;
+	int err;
+
+	/* No need to bother with refcounting for user ports */
+	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
+		return ds->ops->port_mdb_add(ds, port, mdb);
+
+	a = dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid);
+	if (a) {
+		refcount_inc(&a->refcount);
+		return 0;
+	}
+
+	a = kzalloc(sizeof(*a), GFP_KERNEL);
+	if (!a)
+		return -ENOMEM;
+
+	err = ds->ops->port_mdb_add(ds, port, mdb);
+	if (err) {
+		kfree(a);
+		return err;
+	}
+
+	ether_addr_copy(a->addr, mdb->addr);
+	a->vid = mdb->vid;
+	refcount_set(&a->refcount, 1);
+	list_add_tail(&a->list, &dp->mdbs);
+
+	return 0;
+}
+
+static int dsa_switch_do_mdb_del(struct dsa_switch *ds, int port,
+				 const struct switchdev_obj_port_mdb *mdb)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_mac_addr *a;
+	int err;
+
+	/* No need to bother with refcounting for user ports */
+	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
+		return ds->ops->port_mdb_del(ds, port, mdb);
+
+	a = dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid);
+	if (!a)
+		return -ENOENT;
+
+	if (!refcount_dec_and_test(&a->refcount))
+		return 0;
+
+	err = ds->ops->port_mdb_del(ds, port, mdb);
+	if (err) {
+		refcount_inc(&a->refcount);
+		return err;
+	}
+
+	list_del(&a->list);
+	kfree(a);
+
+	return 0;
+}
+
 static int dsa_switch_fdb_add(struct dsa_switch *ds,
 			      struct dsa_notifier_fdb_info *info)
 {
@@ -267,19 +345,18 @@ static int dsa_switch_mdb_add(struct dsa_switch *ds,
 	if (!ds->ops->port_mdb_add)
 		return -EOPNOTSUPP;
 
-	return ds->ops->port_mdb_add(ds, port, info->mdb);
+	return dsa_switch_do_mdb_add(ds, port, info->mdb);
 }
 
 static int dsa_switch_mdb_del(struct dsa_switch *ds,
 			      struct dsa_notifier_mdb_info *info)
 {
+	int port = dsa_towards_port(ds, info->sw_index, info->port);
+
 	if (!ds->ops->port_mdb_del)
 		return -EOPNOTSUPP;
 
-	if (ds->index == info->sw_index)
-		return ds->ops->port_mdb_del(ds, info->port, info->mdb);
-
-	return 0;
+	return dsa_switch_do_mdb_del(ds, port, info->mdb);
 }
 
 static int dsa_switch_host_mdb_add(struct dsa_switch *ds,
@@ -294,7 +371,7 @@ static int dsa_switch_host_mdb_add(struct dsa_switch *ds,
 	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_switch_host_address_match(ds, port, info->sw_index,
 						  info->port)) {
-			err = ds->ops->port_mdb_add(ds, port, info->mdb);
+			err = dsa_switch_do_mdb_add(ds, port, info->mdb);
 			if (err)
 				break;
 		}
@@ -306,13 +383,22 @@ static int dsa_switch_host_mdb_add(struct dsa_switch *ds,
 static int dsa_switch_host_mdb_del(struct dsa_switch *ds,
 				   struct dsa_notifier_mdb_info *info)
 {
+	int err = 0;
+	int port;
+
 	if (!ds->ops->port_mdb_del)
 		return -EOPNOTSUPP;
 
-	if (ds->index == info->sw_index)
-		return ds->ops->port_mdb_del(ds, info->port, info->mdb);
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_switch_host_address_match(ds, port, info->sw_index,
+						  info->port)) {
+			err = dsa_switch_do_mdb_del(ds, port, info->mdb);
+			if (err)
+				break;
+		}
+	}
 
-	return 0;
+	return err;
 }
 
 static bool dsa_switch_vlan_match(struct dsa_switch *ds, int port,
-- 
2.25.1

