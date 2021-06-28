Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F4A3B6AB4
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 00:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238006AbhF1WDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 18:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237157AbhF1WDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 18:03:11 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2599EC061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:44 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id bu12so32605759ejb.0
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jem2EutGvuK7ZAi4ooTGiXUOEEFNnBNXpCnfc2RJP6c=;
        b=LptZCoB8mff7/j/j+TQ7ijHXE5wij1BZwSvlOWsdZEUd2GJBKFlXkvtl0VLM61j2/s
         8YdVEgk4QEZrrtKVmZ3MoiOEPtr7N5q5ezJSsMeFIR3Qj1evtutp1AHjtVdkzamLf3qa
         Yjct1i6Z6U2sYeKEhndczf1r5WLKjXYc+Tj5X2gq1oPwJ+RfOt61erZVSE0gsIsBh+Ss
         dbsOSbhH+6xVadjZ/FINlv0mskyB277pNdtJkPQbPJcyPYLFNMuThy9iGKY+Ff54DOFa
         cJVrsArJ7qvKuzj7uE/J3xL3E4O7FLn/o0CUctIlUxP6Z2viGrjRj7pjfgvif2CpTYw6
         GWtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jem2EutGvuK7ZAi4ooTGiXUOEEFNnBNXpCnfc2RJP6c=;
        b=pqUUGFSrawWsO0ANd5j5KxLc/rC+WM57NhHADt9jfGwH5jasIlc5anNlwRYRBq8rUJ
         XaGeNy5vmGWioXJO92nKyboOdNO9RLxi5UCwF/MWSC4A4xzHve5SWM6lfr3TURSMy8t8
         vCtPDWxNcajg1thJwd8IHeXuJ/qxM1JYy776yQ2CpSmYvNWMTjjwaxR15otIUj4fAaKg
         QJkM0b7V64oVB88mZxoKbFjMGws9EwJGkMgqWuo8vJEW+9C/RxqiPZQXKxyUKhUC2qQw
         lPYku1+/9uR9mBq8XosNRPn1LSE/itLy7ZqzQXQ+bvW0h0XEYHfaCwUAcKEKZ3mj+R0o
         PNhQ==
X-Gm-Message-State: AOAM531qABzGrYBEdmsGnRGjBRTA6LUa315VyncJCOH71defb3kbgQJi
        B2D7lBgvnhlQcffWNOli2Aw4DSuqLHk=
X-Google-Smtp-Source: ABdhPJx7VPLLIHaVwXpcAiNTYzZjLpS/fAwCmhgNLiKj4qDcICafFOLh4gENGlqndDRvTYwNRs775Q==
X-Received: by 2002:a17:907:1610:: with SMTP id hb16mr25935682ejc.147.1624917642589;
        Mon, 28 Jun 2021 15:00:42 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id dn7sm10146615edb.29.2021.06.28.15.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 15:00:42 -0700 (PDT)
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
Subject: [PATCH v4 net-next 08/14] net: dsa: reference count the FDB addresses at the cross-chip notifier level
Date:   Tue, 29 Jun 2021 01:00:05 +0300
Message-Id: <20210628220011.1910096-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628220011.1910096-1-olteanv@gmail.com>
References: <20210628220011.1910096-1-olteanv@gmail.com>
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

