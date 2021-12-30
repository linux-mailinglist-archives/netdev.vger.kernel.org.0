Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6A3482015
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 20:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240723AbhL3Tzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 14:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237051AbhL3Tzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 14:55:53 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A08C061574;
        Thu, 30 Dec 2021 11:55:52 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id h2so45896606lfv.9;
        Thu, 30 Dec 2021 11:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wf118paxagDJe0BrTL1UFbWHYfGXmH7eOtC5eeaiIgI=;
        b=d+xP+k03ZvWgl5IMd5D2vhU1nsZndGBUloMtFMtDSEpWz2dGXzcwJts3k5j7FdaVM7
         VVHBHpn6SgXXI8+1O+A/OjYLPceom8Akg2angU5/TTQRKpLV3VFIKUHi9ujnGLHYARIz
         Pt7I6fFsrWU2mHMFlMZm0UBWglKYA7kUBI/V5mAujkKiTL0IchOMZgWNeoun8FSqEKcE
         6qqxELTDO29zHwBWYUYvf28K+VUX5VnD8Z1P0fJpxoIZ4Bc/B8keVCx4esqtwEzEMDbs
         3uDkEybpjc2+jxcLns1E5EyCtC8V5haHtLv9Owr4N40XJcq+87DFS+vtIv2xobn5BqTc
         PfVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wf118paxagDJe0BrTL1UFbWHYfGXmH7eOtC5eeaiIgI=;
        b=AP1iW/197CqMuInComDt+zu8r1lLggUyWE+UzPKqR1mgRWl+/y49lVnk2I4VgNdjjA
         ox8hy+/uWXW70btlB65fWFmO+yv0FwUwUxLTJphsL0qxW5Dl0c6NExusRLRuRmbYsaBz
         3E5Sb5zFJEgYQlTYYHV7XCIFkf4WX2Bo2uZTqf3qUSePi6riFxZCbp6mZhmyLrSnENUj
         z+ep4TKTUQr7iOvGu3EzI5pbUqTsE2j/Q2Tp3daDkZyoa8p7yFtOnodfNveVHSy1ir8u
         2x3PqAEK3VBrDYPGodELncq6fh2VD02fnuFpbHyorSzpKVbyGrQesUBWUMC4QYUgVDVW
         rgBA==
X-Gm-Message-State: AOAM533wiWeUlqiyxyFFGuADIL3IqHK/j7En1n2XZADscaLUEien6YyQ
        9D1i5Z9ZxVdYTNNuQWV/Pxs=
X-Google-Smtp-Source: ABdhPJwIOPSrQ/q1lNA3B+Zx9QbSUn8ZPpEzm+qUl8XrQcWtL8SrM5JoVd7A0t62XpgQDP8vyAdnzA==
X-Received: by 2002:ac2:5458:: with SMTP id d24mr28898253lfn.38.1640894151047;
        Thu, 30 Dec 2021 11:55:51 -0800 (PST)
Received: from localhost.localdomain ([94.103.235.97])
        by smtp.gmail.com with ESMTPSA id v2sm2553914ljg.46.2021.12.30.11.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 11:55:50 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        me@bobcopeland.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+860268315ba86ea6b96b@syzkaller.appspotmail.com
Subject: [PATCH] mac80211: mesh: embedd mesh_paths and mpp_paths into ieee80211_if_mesh
Date:   Thu, 30 Dec 2021 22:55:47 +0300
Message-Id: <20211230195547.23977-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot hit NULL deref in rhashtable_free_and_destroy(). The problem was
in mesh_paths and mpp_paths being NULL.

mesh_pathtbl_init() could fail in case of memory allocation failure, but
nobody cared, since ieee80211_mesh_init_sdata() returns void. It led to
leaving 2 pointers as NULL. Syzbot has found null deref on exit path,
but it could happen anywhere else, because code assumes these pointers are
valid.

Since all ieee80211_*_setup_sdata functions are void and do not fail,
let's embedd mesh_paths and mpp_paths into parent struct to avoid
adding error handling on higher levels and follow the pattern of others
setup_sdata functions

Fixes: 60854fd94573 ("mac80211: mesh: convert path table to rhashtable")
Reported-and-tested-by: syzbot+860268315ba86ea6b96b@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Happy New Year and Merry Christmas! :)


With regards,
Pavel Skripkin

---
 net/mac80211/ieee80211_i.h  | 24 +++++++++-
 net/mac80211/mesh.h         | 22 +--------
 net/mac80211/mesh_pathtbl.c | 89 +++++++++++++------------------------
 3 files changed, 54 insertions(+), 81 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5666bbb8860b..482c98ede19b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -647,6 +647,26 @@ struct mesh_csa_settings {
 	struct cfg80211_csa_settings settings;
 };
 
+/**
+ * struct mesh_table
+ *
+ * @known_gates: list of known mesh gates and their mpaths by the station. The
+ * gate's mpath may or may not be resolved and active.
+ * @gates_lock: protects updates to known_gates
+ * @rhead: the rhashtable containing struct mesh_paths, keyed by dest addr
+ * @walk_head: linked list containing all mesh_path objects
+ * @walk_lock: lock protecting walk_head
+ * @entries: number of entries in the table
+ */
+struct mesh_table {
+	struct hlist_head known_gates;
+	spinlock_t gates_lock;
+	struct rhashtable rhead;
+	struct hlist_head walk_head;
+	spinlock_t walk_lock;
+	atomic_t entries;		/* Up to MAX_MESH_NEIGHBOURS */
+};
+
 struct ieee80211_if_mesh {
 	struct timer_list housekeeping_timer;
 	struct timer_list mesh_path_timer;
@@ -721,8 +741,8 @@ struct ieee80211_if_mesh {
 	/* offset from skb->data while building IE */
 	int meshconf_offset;
 
-	struct mesh_table *mesh_paths;
-	struct mesh_table *mpp_paths; /* Store paths for MPP&MAP */
+	struct mesh_table mesh_paths;
+	struct mesh_table mpp_paths; /* Store paths for MPP&MAP */
 	int mesh_paths_generation;
 	int mpp_paths_generation;
 };
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 77080b4f87b8..b2b717a78114 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -127,26 +127,6 @@ struct mesh_path {
 	u32 path_change_count;
 };
 
-/**
- * struct mesh_table
- *
- * @known_gates: list of known mesh gates and their mpaths by the station. The
- * gate's mpath may or may not be resolved and active.
- * @gates_lock: protects updates to known_gates
- * @rhead: the rhashtable containing struct mesh_paths, keyed by dest addr
- * @walk_head: linked list containing all mesh_path objects
- * @walk_lock: lock protecting walk_head
- * @entries: number of entries in the table
- */
-struct mesh_table {
-	struct hlist_head known_gates;
-	spinlock_t gates_lock;
-	struct rhashtable rhead;
-	struct hlist_head walk_head;
-	spinlock_t walk_lock;
-	atomic_t entries;		/* Up to MAX_MESH_NEIGHBOURS */
-};
-
 /* Recent multicast cache */
 /* RMC_BUCKETS must be a power of 2, maximum 256 */
 #define RMC_BUCKETS		256
@@ -308,7 +288,7 @@ int mesh_path_error_tx(struct ieee80211_sub_if_data *sdata,
 void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta);
 void mesh_path_flush_pending(struct mesh_path *mpath);
 void mesh_path_tx_pending(struct mesh_path *mpath);
-int mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata);
+void mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata);
 void mesh_pathtbl_unregister(struct ieee80211_sub_if_data *sdata);
 int mesh_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr);
 void mesh_path_timer(struct timer_list *t);
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 7cab1cf09bf1..acc1c299f1ae 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -47,32 +47,24 @@ static void mesh_path_rht_free(void *ptr, void *tblptr)
 	mesh_path_free_rcu(tbl, mpath);
 }
 
-static struct mesh_table *mesh_table_alloc(void)
+static void mesh_table_init(struct mesh_table *tbl)
 {
-	struct mesh_table *newtbl;
+	INIT_HLIST_HEAD(&tbl->known_gates);
+	INIT_HLIST_HEAD(&tbl->walk_head);
+	atomic_set(&tbl->entries,  0);
+	spin_lock_init(&tbl->gates_lock);
+	spin_lock_init(&tbl->walk_lock);
 
-	newtbl = kmalloc(sizeof(struct mesh_table), GFP_ATOMIC);
-	if (!newtbl)
-		return NULL;
-
-	INIT_HLIST_HEAD(&newtbl->known_gates);
-	INIT_HLIST_HEAD(&newtbl->walk_head);
-	atomic_set(&newtbl->entries,  0);
-	spin_lock_init(&newtbl->gates_lock);
-	spin_lock_init(&newtbl->walk_lock);
-	if (rhashtable_init(&newtbl->rhead, &mesh_rht_params)) {
-		kfree(newtbl);
-		return NULL;
-	}
-
-	return newtbl;
+	/* rhashtable_init() may fail only in case of wrong
+	 * mesh_rht_params
+	 */
+	WARN_ON(rhashtable_init(&tbl->rhead, &mesh_rht_params));
 }
 
 static void mesh_table_free(struct mesh_table *tbl)
 {
 	rhashtable_free_and_destroy(&tbl->rhead,
 				    mesh_path_rht_free, tbl);
-	kfree(tbl);
 }
 
 /**
@@ -238,13 +230,13 @@ static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
 struct mesh_path *
 mesh_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
 {
-	return mpath_lookup(sdata->u.mesh.mesh_paths, dst, sdata);
+	return mpath_lookup(&sdata->u.mesh.mesh_paths, dst, sdata);
 }
 
 struct mesh_path *
 mpp_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
 {
-	return mpath_lookup(sdata->u.mesh.mpp_paths, dst, sdata);
+	return mpath_lookup(&sdata->u.mesh.mpp_paths, dst, sdata);
 }
 
 static struct mesh_path *
@@ -281,7 +273,7 @@ __mesh_path_lookup_by_idx(struct mesh_table *tbl, int idx)
 struct mesh_path *
 mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
 {
-	return __mesh_path_lookup_by_idx(sdata->u.mesh.mesh_paths, idx);
+	return __mesh_path_lookup_by_idx(&sdata->u.mesh.mesh_paths, idx);
 }
 
 /**
@@ -296,7 +288,7 @@ mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
 struct mesh_path *
 mpp_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
 {
-	return __mesh_path_lookup_by_idx(sdata->u.mesh.mpp_paths, idx);
+	return __mesh_path_lookup_by_idx(&sdata->u.mesh.mpp_paths, idx);
 }
 
 /**
@@ -309,7 +301,7 @@ int mesh_path_add_gate(struct mesh_path *mpath)
 	int err;
 
 	rcu_read_lock();
-	tbl = mpath->sdata->u.mesh.mesh_paths;
+	tbl = &mpath->sdata->u.mesh.mesh_paths;
 
 	spin_lock_bh(&mpath->state_lock);
 	if (mpath->is_gate) {
@@ -418,7 +410,7 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 	if (!new_mpath)
 		return ERR_PTR(-ENOMEM);
 
-	tbl = sdata->u.mesh.mesh_paths;
+	tbl = &sdata->u.mesh.mesh_paths;
 	spin_lock_bh(&tbl->walk_lock);
 	mpath = rhashtable_lookup_get_insert_fast(&tbl->rhead,
 						  &new_mpath->rhash,
@@ -460,7 +452,7 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 		return -ENOMEM;
 
 	memcpy(new_mpath->mpp, mpp, ETH_ALEN);
-	tbl = sdata->u.mesh.mpp_paths;
+	tbl = &sdata->u.mesh.mpp_paths;
 
 	spin_lock_bh(&tbl->walk_lock);
 	ret = rhashtable_lookup_insert_fast(&tbl->rhead,
@@ -489,7 +481,7 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 void mesh_plink_broken(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct mesh_table *tbl = sdata->u.mesh.mesh_paths;
+	struct mesh_table *tbl = &sdata->u.mesh.mesh_paths;
 	static const u8 bcast[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	struct mesh_path *mpath;
 
@@ -548,7 +540,7 @@ static void __mesh_path_del(struct mesh_table *tbl, struct mesh_path *mpath)
 void mesh_path_flush_by_nexthop(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct mesh_table *tbl = sdata->u.mesh.mesh_paths;
+	struct mesh_table *tbl = &sdata->u.mesh.mesh_paths;
 	struct mesh_path *mpath;
 	struct hlist_node *n;
 
@@ -563,7 +555,7 @@ void mesh_path_flush_by_nexthop(struct sta_info *sta)
 static void mpp_flush_by_proxy(struct ieee80211_sub_if_data *sdata,
 			       const u8 *proxy)
 {
-	struct mesh_table *tbl = sdata->u.mesh.mpp_paths;
+	struct mesh_table *tbl = &sdata->u.mesh.mpp_paths;
 	struct mesh_path *mpath;
 	struct hlist_node *n;
 
@@ -597,8 +589,8 @@ static void table_flush_by_iface(struct mesh_table *tbl)
  */
 void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata)
 {
-	table_flush_by_iface(sdata->u.mesh.mesh_paths);
-	table_flush_by_iface(sdata->u.mesh.mpp_paths);
+	table_flush_by_iface(&sdata->u.mesh.mesh_paths);
+	table_flush_by_iface(&sdata->u.mesh.mpp_paths);
 }
 
 /**
@@ -644,7 +636,7 @@ int mesh_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr)
 	/* flush relevant mpp entries first */
 	mpp_flush_by_proxy(sdata, addr);
 
-	err = table_path_del(sdata->u.mesh.mesh_paths, sdata, addr);
+	err = table_path_del(&sdata->u.mesh.mesh_paths, sdata, addr);
 	sdata->u.mesh.mesh_paths_generation++;
 	return err;
 }
@@ -682,7 +674,7 @@ int mesh_path_send_to_gates(struct mesh_path *mpath)
 	struct mesh_path *gate;
 	bool copy = false;
 
-	tbl = sdata->u.mesh.mesh_paths;
+	tbl = &sdata->u.mesh.mesh_paths;
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(gate, &tbl->known_gates, gate_list) {
@@ -762,29 +754,10 @@ void mesh_path_fix_nexthop(struct mesh_path *mpath, struct sta_info *next_hop)
 	mesh_path_tx_pending(mpath);
 }
 
-int mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata)
+void mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata)
 {
-	struct mesh_table *tbl_path, *tbl_mpp;
-	int ret;
-
-	tbl_path = mesh_table_alloc();
-	if (!tbl_path)
-		return -ENOMEM;
-
-	tbl_mpp = mesh_table_alloc();
-	if (!tbl_mpp) {
-		ret = -ENOMEM;
-		goto free_path;
-	}
-
-	sdata->u.mesh.mesh_paths = tbl_path;
-	sdata->u.mesh.mpp_paths = tbl_mpp;
-
-	return 0;
-
-free_path:
-	mesh_table_free(tbl_path);
-	return ret;
+	mesh_table_init(&sdata->u.mesh.mesh_paths);
+	mesh_table_init(&sdata->u.mesh.mpp_paths);
 }
 
 static
@@ -806,12 +779,12 @@ void mesh_path_tbl_expire(struct ieee80211_sub_if_data *sdata,
 
 void mesh_path_expire(struct ieee80211_sub_if_data *sdata)
 {
-	mesh_path_tbl_expire(sdata, sdata->u.mesh.mesh_paths);
-	mesh_path_tbl_expire(sdata, sdata->u.mesh.mpp_paths);
+	mesh_path_tbl_expire(sdata, &sdata->u.mesh.mesh_paths);
+	mesh_path_tbl_expire(sdata, &sdata->u.mesh.mpp_paths);
 }
 
 void mesh_pathtbl_unregister(struct ieee80211_sub_if_data *sdata)
 {
-	mesh_table_free(sdata->u.mesh.mesh_paths);
-	mesh_table_free(sdata->u.mesh.mpp_paths);
+	mesh_table_free(&sdata->u.mesh.mesh_paths);
+	mesh_table_free(&sdata->u.mesh.mpp_paths);
 }
-- 
2.34.1

