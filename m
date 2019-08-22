Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A76B9A0E5
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390310AbfHVUNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:13:51 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38888 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731739AbfHVUNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 16:13:51 -0400
Received: by mail-qt1-f196.google.com with SMTP id x4so9146699qts.5
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 13:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=udGaDidHG+DteFuoYCc7Agc/DgUZVcH0uT3aEmBIPEQ=;
        b=hPXGGL4kxOWd6X9/9tzmMQFT6tnO9InhkKduMFEWAp+z3aOxeH2L/Y0FDq9eSApIVC
         042lQmQTZgrd5i1dCUBCL0YJiMHULetYiT69DE+TqXNXDXxl7D+xvJZh9Si9hrdFlEvd
         wCivYHhhf8WHau09l5CS4B4tR3SdXVxz3ifsWxNX+9jC3svHZhkdKv1AWD9M3khsvhkA
         +280Tc48gvMOUzADVW6BjZjWXusvq3l4zxd47uoQ2Swx5kTHcmLG8IfdEjrDx9P76P/S
         6Oa3sgiIQzEyCK40Ma62SYXy1nLUm35hoW/YrV2Ng2oyhVlZ2AqrrPddsJu1KolvlgGA
         fLfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=udGaDidHG+DteFuoYCc7Agc/DgUZVcH0uT3aEmBIPEQ=;
        b=Ye+Osz+ZyhjAd+6hipPT3uZSuG3ebVenLVcnXo6TXyB6/HtPEwkC0fL8Ph0hcqZT6E
         H/OvzwhnVGDkrYYVTsNmgd9uN9Rj/OyByq8M/TDbi9plJU3fJntXnS40kUfH7et7ODOl
         Sh+OV3VcKHJ5vgSLc5uXyJYV3LgM3iaq2TXKvDBp3u7Q8VhPhVNP6zyqJjbmmeF40OTH
         bEvNVsBiFb2/esvSStB/C+JYkb0VE8PsGD5v7bT8e+xfylOqcGecwiHEiec7HDczEIJx
         J4tO3G7abynIplzyIgIxQ8yRC9HON0CIMD0LRHaL84vRpcOZzzeZcGBKgxc5NAXLVvlM
         ciQQ==
X-Gm-Message-State: APjAAAXoKzPln4CpHShtAw0Nhf8bKWG/rUxHCCg0NYVKCRIsbBUT3+7c
        ox42txAGjaBFRRvcHYCT4nK5jrJa
X-Google-Smtp-Source: APXvYqw18pu+QyJxrvIx6ciDA/Ve396U3oioTPnIamgYRbKAoGRhZ0olrcLXVhLkaOFk79OPV4iU3w==
X-Received: by 2002:ad4:4641:: with SMTP id y1mr1094251qvv.155.1566504829228;
        Thu, 22 Aug 2019 13:13:49 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id e15sm284528qtr.51.2019.08.22.13.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 13:13:48 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 1/6] net: dsa: remove bitmap operations
Date:   Thu, 22 Aug 2019 16:13:18 -0400
Message-Id: <20190822201323.1292-2-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822201323.1292-1-vivien.didelot@gmail.com>
References: <20190822201323.1292-1-vivien.didelot@gmail.com>
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

