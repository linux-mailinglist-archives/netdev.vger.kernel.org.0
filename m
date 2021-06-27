Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1693B53A0
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 16:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhF0OND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 10:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbhF0OM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 10:12:58 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B763BC061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:30 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id v20so5863182eji.10
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VRkXnB59qFjqX42ibUxjzJNEhNvtydeCOXBbnDtVDJc=;
        b=CV8/hVBHkvn4wZCGDcAuWNUOG2kiGMKMJKyS5Xt/DwcXGK8G9v9W3oDhGiKWbkb4No
         1prilsrs6/2mZn6uRlyPiMCyshJWyxCnboZaS86deEdGwzxO36y2uf/cQUd9pS1oDJX4
         FhdoG3YS/Cx+Qtm4M6HSDQgOh1lJVPeGL/ZwjPP9MOk/katQIaZvJ5JePambNa27EdRt
         gg27yUz57alBw15dYAaOesO/DDQgKDpd/IoCwGq9pfWXbhzUK2tPCaf3SzQEnyMjeoIu
         A8mGwmy5tYBalAjN8xrd0KkZWGJG/+QVZhOUQWGrKc3g4Ep5ga/2CJ4zsCUII6MvIdRL
         2c7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VRkXnB59qFjqX42ibUxjzJNEhNvtydeCOXBbnDtVDJc=;
        b=QsOXaaHb/Z/xwyczuHTSPjLOmeMsc42Wm7HyFQTpsqyOPQbtbr6HzfMsuDu2HuvI1C
         Ou7L4j0cVnuuQqMYDru3AcbdM1nB7IjU8wHJTQarg+yB+fwBuZZA+oB8jlfqE+9Vh18u
         0rsPOcmNeKsiagT8+ta3jtDZKTZl/kq708a3UU8kPEY+y+vD7WAsf9qhWkL5NfzDG+oF
         /KpNfDcjGd7G6C++3CbRQA3WlY1O5SOziyq8ZTinB/y9ffyKjgRg0xzjR2nFY2zB4gob
         UCarsPCEGpT6Sn1wKdv9zIPhTnTTW5weAxKRI5tdNHye0G00pQak1wdpc71kKl86sVwi
         B7Uw==
X-Gm-Message-State: AOAM530UQF4+2Dck0ttJEpJVIHyf+hIjtkZOtdydWTH5gMPwkwKBCl77
        dNhfrY4aYog+0hG4dyTKCdfjlnIQ60k=
X-Google-Smtp-Source: ABdhPJwmiFvAQqxUMRzO+jCB9kdHh8vWYhmADJk/Y9rINwtXPv6XBVriYVn35sbJupGqwQmHaH9ALw==
X-Received: by 2002:a17:906:dbd9:: with SMTP id yc25mr20513737ejb.267.1624803029086;
        Sun, 27 Jun 2021 07:10:29 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7857389edu.49.2021.06.27.07.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 07:10:28 -0700 (PDT)
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
Subject: [RFC PATCH v3 net-next 08/15] net: dsa: introduce a separate cross-chip notifier type for host FDBs
Date:   Sun, 27 Jun 2021 17:10:06 +0300
Message-Id: <20210627141013.1273942-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627141013.1273942-1-olteanv@gmail.com>
References: <20210627141013.1273942-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

DSA treats some bridge FDB entries by trapping them to the CPU port.
Currently, the only class of such entries are FDB addresses learnt by
the software bridge on a foreign interface. However there are many more
to be added:

- FDB entries with the is_local flag (for termination) added by the
  bridge on the user ports (typically containing the MAC address of the
  bridge port)
- FDB entries pointing towards the bridge net device (for termination).
  Typically these contain the MAC address of the bridge net device.
- Static FDB entries installed on a foreign interface that is in the
  same bridge with a DSA user port.

The reason why a separate cross-chip notifier for host FDBs is justified
compared to normal FDBs is the same as in the case of host MDBs: the
cross-chip notifier matching function in switch.c should avoid
installing these entries on routing ports that route towards the
targeted switch, but not towards the CPU. This is required in order to
have proper support for H-like multi-chip topologies.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h |  7 +++++++
 net/dsa/port.c     | 26 ++++++++++++++++++++++++++
 net/dsa/slave.c    | 21 ++++++++++++++++-----
 net/dsa/switch.c   | 41 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 90 insertions(+), 5 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index cd65933d269b..36e667ea94db 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -20,6 +20,8 @@ enum {
 	DSA_NOTIFIER_BRIDGE_LEAVE,
 	DSA_NOTIFIER_FDB_ADD,
 	DSA_NOTIFIER_FDB_DEL,
+	DSA_NOTIFIER_HOST_FDB_ADD,
+	DSA_NOTIFIER_HOST_FDB_DEL,
 	DSA_NOTIFIER_HSR_JOIN,
 	DSA_NOTIFIER_HSR_LEAVE,
 	DSA_NOTIFIER_LAG_CHANGE,
@@ -121,6 +123,7 @@ struct dsa_switchdev_event_work {
 	 */
 	unsigned char addr[ETH_ALEN];
 	u16 vid;
+	bool host_addr;
 };
 
 /* DSA_NOTIFIER_HSR_* */
@@ -211,6 +214,10 @@ int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid);
 int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid);
+int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
+			  u16 vid);
+int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+			  u16 vid);
 int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data);
 int dsa_port_mdb_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 47f45f795f44..1b80e0fbdfaa 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -646,6 +646,32 @@ int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	return dsa_port_notify(dp, DSA_NOTIFIER_FDB_DEL, &info);
 }
 
+int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
+			  u16 vid)
+{
+	struct dsa_notifier_fdb_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.addr = addr,
+		.vid = vid,
+	};
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_ADD, &info);
+}
+
+int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+			  u16 vid)
+{
+	struct dsa_notifier_fdb_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.addr = addr,
+		.vid = vid,
+	};
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_DEL, &info);
+}
+
 int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data)
 {
 	struct dsa_switch *ds = dp->ds;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4b1d738bc3bc..ac7f4f200ab1 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2315,8 +2315,12 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 	rtnl_lock();
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-		err = dsa_port_fdb_add(dp, switchdev_work->addr,
-				       switchdev_work->vid);
+		if (switchdev_work->host_addr)
+			err = dsa_port_host_fdb_add(dp, switchdev_work->addr,
+						    switchdev_work->vid);
+		else
+			err = dsa_port_fdb_add(dp, switchdev_work->addr,
+					       switchdev_work->vid);
 		if (err) {
 			dev_err(ds->dev,
 				"port %d failed to add %pM vid %d to fdb: %d\n",
@@ -2328,8 +2332,12 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		break;
 
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		err = dsa_port_fdb_del(dp, switchdev_work->addr,
-				       switchdev_work->vid);
+		if (switchdev_work->host_addr)
+			err = dsa_port_host_fdb_del(dp, switchdev_work->addr,
+						    switchdev_work->vid);
+		else
+			err = dsa_port_fdb_del(dp, switchdev_work->addr,
+					       switchdev_work->vid);
 		if (err) {
 			dev_err(ds->dev,
 				"port %d failed to delete %pM vid %d from fdb: %d\n",
@@ -2375,6 +2383,7 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
 	const struct switchdev_notifier_fdb_info *fdb_info;
 	struct dsa_switchdev_event_work *switchdev_work;
+	bool host_addr = false;
 	struct dsa_port *dp;
 	int err;
 
@@ -2412,7 +2421,8 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 			if (!p)
 				return NOTIFY_DONE;
 
-			dp = p->dp->cpu_dp;
+			dp = p->dp;
+			host_addr = true;
 
 			if (!dp->ds->assisted_learning_on_cpu_port)
 				return NOTIFY_DONE;
@@ -2442,6 +2452,7 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 		ether_addr_copy(switchdev_work->addr,
 				fdb_info->addr);
 		switchdev_work->vid = fdb_info->vid;
+		switchdev_work->host_addr = host_addr;
 
 		/* Hold a reference on the slave for dsa_fdb_offload_notify */
 		if (dsa_is_user_port(dp->ds, dp->index))
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 10602a6da5e3..af1edb6082df 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -256,6 +256,41 @@ static int dsa_switch_do_mdb_del(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
+				   struct dsa_notifier_fdb_info *info)
+{
+	int err = 0;
+	int port;
+
+	if (!ds->ops->port_fdb_add)
+		return -EOPNOTSUPP;
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_switch_host_address_match(ds, port, info->sw_index,
+						  info->port)) {
+			err = ds->ops->port_fdb_add(ds, port, info->addr,
+						    info->vid);
+			if (err)
+				break;
+		}
+	}
+
+	return err;
+}
+
+static int dsa_switch_host_fdb_del(struct dsa_switch *ds,
+				   struct dsa_notifier_fdb_info *info)
+{
+	if (!ds->ops->port_fdb_del)
+		return -EOPNOTSUPP;
+
+	if (ds->index == info->sw_index)
+		return ds->ops->port_fdb_del(ds, info->port, info->addr,
+					     info->vid);
+
+	return 0;
+}
+
 static int dsa_switch_fdb_add(struct dsa_switch *ds,
 			      struct dsa_notifier_fdb_info *info)
 {
@@ -563,6 +598,12 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_FDB_DEL:
 		err = dsa_switch_fdb_del(ds, info);
 		break;
+	case DSA_NOTIFIER_HOST_FDB_ADD:
+		err = dsa_switch_host_fdb_add(ds, info);
+		break;
+	case DSA_NOTIFIER_HOST_FDB_DEL:
+		err = dsa_switch_host_fdb_del(ds, info);
+		break;
 	case DSA_NOTIFIER_HSR_JOIN:
 		err = dsa_switch_hsr_join(ds, info);
 		break;
-- 
2.25.1

