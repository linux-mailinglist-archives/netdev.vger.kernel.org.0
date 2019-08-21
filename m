Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D117F9723B
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 08:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbfHUGYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 02:24:35 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45944 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbfHUGYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 02:24:35 -0400
Received: by mail-qk1-f194.google.com with SMTP id m2so855746qki.12
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 23:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=udGaDidHG+DteFuoYCc7Agc/DgUZVcH0uT3aEmBIPEQ=;
        b=HW+/vWp9NufVqwDmKx40s1xhOwga8PoYCq6yH1d838QvagBFCpldDQQCT2bp8wHdr0
         AftoW3pEIdZChlXj8wtPDOR82wLWYUXnMrzr+RxOhReyEKRGaXzelnTAcR/X6qiLzgXu
         37sz+xEKbEClXMBnjx3tAixPs1Hd+yN3BzRXnQz0V6vt9e3ltk5OLrPfYhTw8YDywTO0
         X6ZgsXKLkeDMNjQG1FIOVcu+zB88iWnvomGNzb60TsFDEK6tMbL1R5xq6UltySG0Wny3
         uYnzvagXlUJYik9932EuXl3HH2hIn2E12yxNsT68lVbO0ZPsBWHim/j0BtT1SgpCcKqI
         xtMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=udGaDidHG+DteFuoYCc7Agc/DgUZVcH0uT3aEmBIPEQ=;
        b=qtMwMCGp5fM95MpNCOrei9vKtTIrG3ec2XfQNoNwFZEoFrTNb+u2jZx6GDTR2/CXZw
         09qoCEdWRPbTmfYORHngljqe68jT+MzedsQ1e8cvXm9k+46Nn1sRH7oYVCU+sYJzmQYx
         ajx6Fu32ZvoOkZX+tiBjHySRCT3AYUOaGAqQGxx1q16yOxTBJc3xbnXm31uMEVzMOioc
         vAB8OtGS7m0QPHccQ89VKb1muoPWjtwUFenh6raZ3bDLa7wE9V2e5wFbxRUq3/5/gfiy
         UfkOXhkoVkbuTors2Q+Ok8UcRwA6SeIjQzn210iCtGzqrqMnjD+wuzXPy/GW0SAq5IvF
         RGgg==
X-Gm-Message-State: APjAAAWA/FwLS5Ygv+oe6OD8g+6MWnawYjHoN9GgdI9vItgY890Wd3Yr
        epMTQU4MF9yEwFW4S3d5806LxzWA6PQ=
X-Google-Smtp-Source: APXvYqwp8GZq7bevNFJbub3OVWic6Y/Ufdypw3ciEUpipnnvgMM1iXKuYi9BUagrJWlkwdpYbkYv6w==
X-Received: by 2002:a05:620a:1599:: with SMTP id d25mr30486399qkk.396.1566368673515;
        Tue, 20 Aug 2019 23:24:33 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id x26sm9358503qkn.116.2019.08.20.23.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 23:24:32 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next] net: dsa: remove bitmap operations
Date:   Wed, 21 Aug 2019 02:24:23 -0400
Message-Id: <20190821062423.18735-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bitmap operations were introduced to simplify the switch drivers
in the future, since most of them could implement the common VLAN and
MDB operations (add, del, dump) with simple functions taking all target
ports at once, and thus limiting the number of hardware accesses.

Programming an MDB or VLAN this way in a single operation would clearly
simplify the drivers a lot but would require a new get-set interface
in DSA. The usage of such bitmap from the stack also raised concerned
in the past, leading to the dynamic allocation of a new ds->_bitmap
member in the dsa_switch structure. So let's get rid of them for now.

This commit nicely wraps the ds->ops->port_{mdb,vlan}_{prepare,add}
switch operations into new dsa_switch_{mdb,vlan}_{prepare,add}
variants not using any bitmap argument anymore.

New dsa_switch_{mdb,vlan}_match helpers have been introduced to make
clear which local port of a switch must be programmed with the target
object. While the targeted user port is an obvious candidate, the
DSA links must also be programmed, as well as the CPU port for VLANs.

While at it, also remove local variables that are only used once.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/net/dsa.h |   3 --
 net/dsa/dsa2.c    |  14 -----
 net/dsa/switch.c  | 132 +++++++++++++++++++++-------------------------
 3 files changed, 59 insertions(+), 90 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 147b757ef8ea..96acb14ec1a8 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -275,9 +275,6 @@ struct dsa_switch {
 	 */
 	bool			vlan_filtering;
 
-	unsigned long		*bitmap;
-	unsigned long		_bitmap;
-
 	/* Dynamically allocated ports, keep last */
 	size_t num_ports;
 	struct dsa_port ports[];
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 8c4eccb0cfe6..f8445fa73448 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -834,20 +834,6 @@ struct dsa_switch *dsa_switch_alloc(struct device *dev, size_t n)
 	if (!ds)
 		return NULL;
 
-	/* We avoid allocating memory outside dsa_switch
-	 * if it is not needed.
-	 */
-	if (n <= sizeof(ds->_bitmap) * 8) {
-		ds->bitmap = &ds->_bitmap;
-	} else {
-		ds->bitmap = devm_kcalloc(dev,
-					  BITS_TO_LONGS(n),
-					  sizeof(unsigned long),
-					  GFP_KERNEL);
-		if (unlikely(!ds->bitmap))
-			return NULL;
-	}
-
 	ds->dev = dev;
 	ds->num_ports = n;
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 09d9286b27cc..489eb7b430a4 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -128,57 +128,51 @@ static int dsa_switch_fdb_del(struct dsa_switch *ds,
 	return ds->ops->port_fdb_del(ds, port, info->addr, info->vid);
 }
 
-static int
-dsa_switch_mdb_prepare_bitmap(struct dsa_switch *ds,
-			      const struct switchdev_obj_port_mdb *mdb,
-			      const unsigned long *bitmap)
+static bool dsa_switch_mdb_match(struct dsa_switch *ds, int port,
+				 struct dsa_notifier_mdb_info *info)
+{
+	if (ds->index == info->sw_index && port == info->port)
+		return true;
+
+	if (dsa_is_dsa_port(ds, port))
+		return true;
+
+	return false;
+}
+
+static int dsa_switch_mdb_prepare(struct dsa_switch *ds,
+				  struct dsa_notifier_mdb_info *info)
 {
 	int port, err;
 
 	if (!ds->ops->port_mdb_prepare || !ds->ops->port_mdb_add)
 		return -EOPNOTSUPP;
 
-	for_each_set_bit(port, bitmap, ds->num_ports) {
-		err = ds->ops->port_mdb_prepare(ds, port, mdb);
-		if (err)
-			return err;
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_switch_mdb_match(ds, port, info)) {
+			err = ds->ops->port_mdb_prepare(ds, port, info->mdb);
+			if (err)
+				return err;
+		}
 	}
 
 	return 0;
 }
 
-static void dsa_switch_mdb_add_bitmap(struct dsa_switch *ds,
-				      const struct switchdev_obj_port_mdb *mdb,
-				      const unsigned long *bitmap)
-{
-	int port;
-
-	if (!ds->ops->port_mdb_add)
-		return;
-
-	for_each_set_bit(port, bitmap, ds->num_ports)
-		ds->ops->port_mdb_add(ds, port, mdb);
-}
-
 static int dsa_switch_mdb_add(struct dsa_switch *ds,
 			      struct dsa_notifier_mdb_info *info)
 {
-	const struct switchdev_obj_port_mdb *mdb = info->mdb;
-	struct switchdev_trans *trans = info->trans;
 	int port;
 
-	/* Build a mask of Multicast group members */
-	bitmap_zero(ds->bitmap, ds->num_ports);
-	if (ds->index == info->sw_index)
-		set_bit(info->port, ds->bitmap);
-	for (port = 0; port < ds->num_ports; port++)
-		if (dsa_is_dsa_port(ds, port))
-			set_bit(port, ds->bitmap);
+	if (switchdev_trans_ph_prepare(info->trans))
+		return dsa_switch_mdb_prepare(ds, info);
 
-	if (switchdev_trans_ph_prepare(trans))
-		return dsa_switch_mdb_prepare_bitmap(ds, mdb, ds->bitmap);
+	if (!ds->ops->port_mdb_add)
+		return 0;
 
-	dsa_switch_mdb_add_bitmap(ds, mdb, ds->bitmap);
+	for (port = 0; port < ds->num_ports; port++)
+		if (dsa_switch_mdb_match(ds, port, info))
+			ds->ops->port_mdb_add(ds, port, info->mdb);
 
 	return 0;
 }
@@ -186,13 +180,11 @@ static int dsa_switch_mdb_add(struct dsa_switch *ds,
 static int dsa_switch_mdb_del(struct dsa_switch *ds,
 			      struct dsa_notifier_mdb_info *info)
 {
-	const struct switchdev_obj_port_mdb *mdb = info->mdb;
-
 	if (!ds->ops->port_mdb_del)
 		return -EOPNOTSUPP;
 
 	if (ds->index == info->sw_index)
-		return ds->ops->port_mdb_del(ds, info->port, mdb);
+		return ds->ops->port_mdb_del(ds, info->port, info->mdb);
 
 	return 0;
 }
@@ -234,59 +226,55 @@ static int dsa_port_vlan_check(struct dsa_switch *ds, int port,
 			     (void *)vlan);
 }
 
-static int
-dsa_switch_vlan_prepare_bitmap(struct dsa_switch *ds,
-			       const struct switchdev_obj_port_vlan *vlan,
-			       const unsigned long *bitmap)
+static bool dsa_switch_vlan_match(struct dsa_switch *ds, int port,
+				  struct dsa_notifier_vlan_info *info)
+{
+	if (ds->index == info->sw_index && port == info->port)
+		return true;
+
+	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
+		return true;
+
+	return false;
+}
+
+static int dsa_switch_vlan_prepare(struct dsa_switch *ds,
+				   struct dsa_notifier_vlan_info *info)
 {
 	int port, err;
 
 	if (!ds->ops->port_vlan_prepare || !ds->ops->port_vlan_add)
 		return -EOPNOTSUPP;
 
-	for_each_set_bit(port, bitmap, ds->num_ports) {
-		err = dsa_port_vlan_check(ds, port, vlan);
-		if (err)
-			return err;
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_switch_vlan_match(ds, port, info)) {
+			err = dsa_port_vlan_check(ds, port, info->vlan);
+			if (err)
+				return err;
 
-		err = ds->ops->port_vlan_prepare(ds, port, vlan);
-		if (err)
-			return err;
+			err = ds->ops->port_vlan_prepare(ds, port, info->vlan);
+			if (err)
+				return err;
+		}
 	}
 
 	return 0;
 }
 
-static void
-dsa_switch_vlan_add_bitmap(struct dsa_switch *ds,
-			   const struct switchdev_obj_port_vlan *vlan,
-			   const unsigned long *bitmap)
-{
-	int port;
-
-	for_each_set_bit(port, bitmap, ds->num_ports)
-		ds->ops->port_vlan_add(ds, port, vlan);
-}
-
 static int dsa_switch_vlan_add(struct dsa_switch *ds,
 			       struct dsa_notifier_vlan_info *info)
 {
-	const struct switchdev_obj_port_vlan *vlan = info->vlan;
-	struct switchdev_trans *trans = info->trans;
 	int port;
 
-	/* Build a mask of VLAN members */
-	bitmap_zero(ds->bitmap, ds->num_ports);
-	if (ds->index == info->sw_index)
-		set_bit(info->port, ds->bitmap);
-	for (port = 0; port < ds->num_ports; port++)
-		if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
-			set_bit(port, ds->bitmap);
+	if (switchdev_trans_ph_prepare(info->trans))
+		return dsa_switch_vlan_prepare(ds, info);
 
-	if (switchdev_trans_ph_prepare(trans))
-		return dsa_switch_vlan_prepare_bitmap(ds, vlan, ds->bitmap);
+	if (!ds->ops->port_vlan_add)
+		return 0;
 
-	dsa_switch_vlan_add_bitmap(ds, vlan, ds->bitmap);
+	for (port = 0; port < ds->num_ports; port++)
+		if (dsa_switch_vlan_match(ds, port, info))
+			ds->ops->port_vlan_add(ds, port, info->vlan);
 
 	return 0;
 }
@@ -294,13 +282,11 @@ static int dsa_switch_vlan_add(struct dsa_switch *ds,
 static int dsa_switch_vlan_del(struct dsa_switch *ds,
 			       struct dsa_notifier_vlan_info *info)
 {
-	const struct switchdev_obj_port_vlan *vlan = info->vlan;
-
 	if (!ds->ops->port_vlan_del)
 		return -EOPNOTSUPP;
 
 	if (ds->index == info->sw_index)
-		return ds->ops->port_vlan_del(ds, info->port, vlan);
+		return ds->ops->port_vlan_del(ds, info->port, info->vlan);
 
 	return 0;
 }
-- 
2.23.0

