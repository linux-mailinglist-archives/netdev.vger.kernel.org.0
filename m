Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7A93B53A2
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 16:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhF0ONF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 10:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbhF0OM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 10:12:56 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CEDC061766
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:31 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id bu12so24533329ejb.0
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jem2EutGvuK7ZAi4ooTGiXUOEEFNnBNXpCnfc2RJP6c=;
        b=HOEbiuQiFJFiEuaPZyVdeUGm+qah4/NEeAbv5ov00cSDksxJGyzTn/XXLEF1lQIeyL
         2UEPpPVgF9Q5h1o/xSJNyau9MRwZ2B8Wtuf0QddQ4WuaoN0FPnCSlSUPpMN4ow4XCe57
         PwQ45Wa2yrCzZqkmR+mIY0R4shh26KG2O2Z1UXZdQUWVfu4xCKyAnHzjmuVf7LXeARaf
         fsvq8gsL1tc82C5s/p2b2RB3S2QvkzwmlrgIB1CuvY6is7ZFmpQ5oSBb3F2Oa3qO3aKt
         WyKfbc3d+i9H4KxNkSeOD1NG71ZoBb0ntOEihJorRPsnpNeddK4KWvsjJR2veFmDPpoE
         C7tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jem2EutGvuK7ZAi4ooTGiXUOEEFNnBNXpCnfc2RJP6c=;
        b=srTL8u70XRkFb3FLxqUzgaingPLp4rZorufG2n/XdIV+m86eLzKu1MhfjtYhxC/UVK
         cBz35D0ekBARAijEkPxJ/Fkfo6gB4TK7OttPzu+Xj2ekWusqs67QE9IA9yP8DDrkz/aO
         x6x4tQgfpGP6WTjWLOYUtGDWhMawWeRg7LOMmGzRq0XPe8U97RhWrad+mT1/5ERju7pY
         n0z1V1BTRXgbrE3ynbQZH8E2iOdgayAZ0GecdgrJPlDeImnjmX8Rpt9dZsRxtkisFlG2
         0EzrbFsMaD0yvzPp9ZOUnE3CV/xQB557WMBOvoaI0QQVODX56I+31a/l5PzGISN5bm2x
         w0Tg==
X-Gm-Message-State: AOAM5332Cjgv7UJpmVZgzIW83We7OMNRigtgv632zp0+EKVMBPtQuv1r
        7rqFMZ/jjI+WIhm4hrWv+yYRBxbjpO4=
X-Google-Smtp-Source: ABdhPJzhaRU/Pg10kpxC8vvwQBa+HKZ1htRJgGGtxAvObjvztnDK7k+zvgGHAEyv5gGokaJpebz+jQ==
X-Received: by 2002:a17:906:3181:: with SMTP id 1mr20503537ejy.36.1624803030196;
        Sun, 27 Jun 2021 07:10:30 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7857389edu.49.2021.06.27.07.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 07:10:29 -0700 (PDT)
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
Subject: [RFC PATCH v3 net-next 09/15] net: dsa: reference count the FDB addresses at the cross-chip notifier level
Date:   Sun, 27 Jun 2021 17:10:07 +0300
Message-Id: <20210627141013.1273942-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627141013.1273942-1-olteanv@gmail.com>
References: <20210627141013.1273942-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The same concerns expressed for host MDB entries are valid for host FDBs
just as well:

- in the case of multiple bridges spanning the same switch chip, deleting
  a host FDB entry that belongs to one bridge will result in breakage to
  the other bridge
- not deleting FDB entries across DSA links means that the switch's
  hardware tables will eventually run out, given enough wear&tear

So do the same thing and introduce reference counting for CPU ports and
DSA links using the same data structures as we have for MDB entries.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h |  1 +
 net/dsa/dsa2.c    |  6 ++++
 net/dsa/switch.c  | 88 +++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 88 insertions(+), 7 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 2c50546f9667..33f40c1ec379 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -288,6 +288,7 @@ struct dsa_port {
 	/* List of MAC addresses that must be forwarded on this port.
 	 * These are only valid on CPU ports and DSA links.
 	 */
+	struct list_head	fdbs;
 	struct list_head	mdbs;
 
 	bool setup;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 2035d132682f..185629f27f80 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -348,6 +348,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 	if (dp->setup)
 		return 0;
 
+	INIT_LIST_HEAD(&dp->fdbs);
 	INIT_LIST_HEAD(&dp->mdbs);
 
 	switch (dp->type) {
@@ -471,6 +472,11 @@ static void dsa_port_teardown(struct dsa_port *dp)
 		break;
 	}
 
+	list_for_each_entry_safe(a, tmp, &dp->fdbs, list) {
+		list_del(&a->list);
+		kfree(a);
+	}
+
 	list_for_each_entry_safe(a, tmp, &dp->mdbs, list) {
 		list_del(&a->list);
 		kfree(a);
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index af1edb6082df..b872a9c92d3e 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -256,6 +256,71 @@ static int dsa_switch_do_mdb_del(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static int dsa_switch_do_fdb_add(struct dsa_switch *ds, int port,
+				 const unsigned char *addr, u16 vid)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_mac_addr *a;
+	int err;
+
+	/* No need to bother with refcounting for user ports */
+	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
+		return ds->ops->port_fdb_add(ds, port, addr, vid);
+
+	a = dsa_mac_addr_find(&dp->fdbs, addr, vid);
+	if (a) {
+		refcount_inc(&a->refcount);
+		return 0;
+	}
+
+	a = kzalloc(sizeof(*a), GFP_KERNEL);
+	if (!a)
+		return -ENOMEM;
+
+	err = ds->ops->port_fdb_add(ds, port, addr, vid);
+	if (err) {
+		kfree(a);
+		return err;
+	}
+
+	ether_addr_copy(a->addr, addr);
+	a->vid = vid;
+	refcount_set(&a->refcount, 1);
+	list_add_tail(&a->list, &dp->fdbs);
+
+	return 0;
+}
+
+static int dsa_switch_do_fdb_del(struct dsa_switch *ds, int port,
+				 const unsigned char *addr, u16 vid)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_mac_addr *a;
+	int err;
+
+	/* No need to bother with refcounting for user ports */
+	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
+		return ds->ops->port_fdb_del(ds, port, addr, vid);
+
+	a = dsa_mac_addr_find(&dp->fdbs, addr, vid);
+	if (!a)
+		return -ENOENT;
+
+	if (!refcount_dec_and_test(&a->refcount))
+		return 0;
+
+	err = ds->ops->port_fdb_del(ds, port, addr, vid);
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
 static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
 				   struct dsa_notifier_fdb_info *info)
 {
@@ -268,7 +333,7 @@ static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
 	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_switch_host_address_match(ds, port, info->sw_index,
 						  info->port)) {
-			err = ds->ops->port_fdb_add(ds, port, info->addr,
+			err = dsa_switch_do_fdb_add(ds, port, info->addr,
 						    info->vid);
 			if (err)
 				break;
@@ -281,14 +346,23 @@ static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
 static int dsa_switch_host_fdb_del(struct dsa_switch *ds,
 				   struct dsa_notifier_fdb_info *info)
 {
+	int err = 0;
+	int port;
+
 	if (!ds->ops->port_fdb_del)
 		return -EOPNOTSUPP;
 
-	if (ds->index == info->sw_index)
-		return ds->ops->port_fdb_del(ds, info->port, info->addr,
-					     info->vid);
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_switch_host_address_match(ds, port, info->sw_index,
+						  info->port)) {
+			err = dsa_switch_do_fdb_del(ds, port, info->addr,
+						    info->vid);
+			if (err)
+				break;
+		}
+	}
 
-	return 0;
+	return err;
 }
 
 static int dsa_switch_fdb_add(struct dsa_switch *ds,
@@ -299,7 +373,7 @@ static int dsa_switch_fdb_add(struct dsa_switch *ds,
 	if (!ds->ops->port_fdb_add)
 		return -EOPNOTSUPP;
 
-	return ds->ops->port_fdb_add(ds, port, info->addr, info->vid);
+	return dsa_switch_do_fdb_add(ds, port, info->addr, info->vid);
 }
 
 static int dsa_switch_fdb_del(struct dsa_switch *ds,
@@ -310,7 +384,7 @@ static int dsa_switch_fdb_del(struct dsa_switch *ds,
 	if (!ds->ops->port_fdb_del)
 		return -EOPNOTSUPP;
 
-	return ds->ops->port_fdb_del(ds, port, info->addr, info->vid);
+	return dsa_switch_do_fdb_del(ds, port, info->addr, info->vid);
 }
 
 static int dsa_switch_hsr_join(struct dsa_switch *ds,
-- 
2.25.1

