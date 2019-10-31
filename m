Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28DD0EABC0
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfJaIsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 04:48:31 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39489 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbfJaIsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 04:48:31 -0400
Received: by mail-pl1-f195.google.com with SMTP id t12so2403826plo.6;
        Thu, 31 Oct 2019 01:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mE6wMYtBtAqzjYaNK2J6A8ATDUPWYwa6vHdy7luQrH4=;
        b=caTDRDluUTcwL8Xu9TJVKlw+PGZNi3i8ucnbGpwqHuc+BeyCdXVPqKY8Rg9xRnUpxz
         nK/GJqERHsBDgN8GN7Ed9PrV2GbAeuMDhZw9g5WWw1cqdKl1ICVBlU9HL7YtrI3fEq8j
         rA1w2XWlpkA1E3sjwaAbZnKhSz2QTyHG5xgB7oQKvEYoQXp14UzIAXSvsg1ujksZ5htD
         LhywCPMi3EWjLMliAbat1Dt9OFL+UO9Ch4MlKVQ5B9qp5nPBiSlohzQp/yJGxDcx3OgZ
         X1Qa07MDIvEKnNK4avsRjg2N6sEhRwXfxG6AojcRTwjqvK/F4WaXRep6Cbi29Zkm0Zmd
         zk7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mE6wMYtBtAqzjYaNK2J6A8ATDUPWYwa6vHdy7luQrH4=;
        b=roosHfUyBCrYxjzixclHXNnWZYaZ8D9P0yR7NblJA2jaSMdpM+z2bzk2Ef1XZeYw1z
         d1vb5QKdnfRi8nuNK8EfpLh5chuQYUI6bDTJVqmnrbK9fTJfzj1a4g+HicRTOfmqbFHF
         1BFEcWMlHPmpR5VZvQ5CG+RrIKT8AwLfNm1mCEnFtX4RVEc9W0Z3WO+8R/ND+Vp/VB8K
         HrWF7TM3j6zarWhGvzgDw2Lv3RGr+dwGMGrHrYPnid2o9BDIWwc69NSPynjmgy84LVgl
         cLAJMhZXAW+fTE4d3fy9iFBT/5eUHKwBYCeKeDtOTZj9xFljLBNr6l3SiolmFCmD30YX
         +lNQ==
X-Gm-Message-State: APjAAAV4cMN1XRvssalBc25E7hgfwgV+65QxXYr3y8YRI/b66cOZaTKG
        p0TtPRWyWWFOn4om5YMBXAM0806BDcnn7g==
X-Google-Smtp-Source: APXvYqyBacaem/9Wp5Hd2WC65olM7EwM/2QLuK+VOo1PTjDW3wrUIJvI0fRpWjAwbnqjwB8LgdFYxw==
X-Received: by 2002:a17:902:59d9:: with SMTP id d25mr4999382plj.250.1572511709724;
        Thu, 31 Oct 2019 01:48:29 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id 4sm3335507pfz.185.2019.10.31.01.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 01:48:29 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        jonathan.lemon@gmail.com, toke@redhat.com
Subject: [PATCH bpf-next v4 3/3] xsk: restructure/inline XSKMAP lookup/redirect/flush
Date:   Thu, 31 Oct 2019 09:47:49 +0100
Message-Id: <20191031084749.14626-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191031084749.14626-1-bjorn.topel@gmail.com>
References: <20191031084749.14626-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

In this commit the XSKMAP entry lookup function used by the XDP
redirect code is moved from the xskmap.c file to the xdp_sock.h
header, so the lookup can be inlined from, e.g., the
bpf_xdp_redirect_map() function.

Further the __xsk_map_redirect() and __xsk_map_flush() is moved to the
xsk.c, which lets the compiler inline the xsk_rcv() and xsk_flush()
functions.

Finally, all the XDP socket functions were moved from linux/bpf.h to
net/xdp_sock.h, where most of the XDP sockets functions are anyway.

This yields a ~2% performance boost for the xdpsock "rx_drop"
scenario.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/bpf.h    | 25 ---------------------
 include/net/xdp_sock.h | 51 ++++++++++++++++++++++++++++++++----------
 kernel/bpf/xskmap.c    | 48 ---------------------------------------
 net/xdp/xsk.c          | 33 +++++++++++++++++++++++++--
 4 files changed, 70 insertions(+), 87 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 171be30fe0ae..ab8ee7543258 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1004,31 +1004,6 @@ static inline int sock_map_get_from_fd(const union bpf_attr *attr,
 }
 #endif
 
-#if defined(CONFIG_XDP_SOCKETS)
-struct xdp_sock;
-struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map, u32 key);
-int __xsk_map_redirect(struct bpf_map *map, struct xdp_buff *xdp,
-		       struct xdp_sock *xs);
-void __xsk_map_flush(struct bpf_map *map);
-#else
-struct xdp_sock;
-static inline struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map,
-						     u32 key)
-{
-	return NULL;
-}
-
-static inline int __xsk_map_redirect(struct bpf_map *map, struct xdp_buff *xdp,
-				     struct xdp_sock *xs)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline void __xsk_map_flush(struct bpf_map *map)
-{
-}
-#endif
-
 #if defined(CONFIG_INET) && defined(CONFIG_BPF_SYSCALL)
 void bpf_sk_reuseport_detach(struct sock *sk);
 int bpf_fd_reuseport_array_lookup_elem(struct bpf_map *map, void *key,
diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index c9398ce7960f..e3780e4b74e1 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -69,7 +69,14 @@ struct xdp_umem {
 /* Nodes are linked in the struct xdp_sock map_list field, and used to
  * track which maps a certain socket reside in.
  */
-struct xsk_map;
+
+struct xsk_map {
+	struct bpf_map map;
+	struct list_head __percpu *flush_list;
+	spinlock_t lock; /* Synchronize map updates */
+	struct xdp_sock *xsk_map[];
+};
+
 struct xsk_map_node {
 	struct list_head node;
 	struct xsk_map *map;
@@ -109,8 +116,6 @@ struct xdp_sock {
 struct xdp_buff;
 #ifdef CONFIG_XDP_SOCKETS
 int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp);
-int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp);
-void xsk_flush(struct xdp_sock *xs);
 bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs);
 /* Used from netdev driver */
 bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt);
@@ -134,6 +139,22 @@ void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
 			     struct xdp_sock **map_entry);
 int xsk_map_inc(struct xsk_map *map);
 void xsk_map_put(struct xsk_map *map);
+int __xsk_map_redirect(struct bpf_map *map, struct xdp_buff *xdp,
+		       struct xdp_sock *xs);
+void __xsk_map_flush(struct bpf_map *map);
+
+static inline struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map,
+						     u32 key)
+{
+	struct xsk_map *m = container_of(map, struct xsk_map, map);
+	struct xdp_sock *xs;
+
+	if (key >= map->max_entries)
+		return NULL;
+
+	xs = READ_ONCE(m->xsk_map[key]);
+	return xs;
+}
 
 static inline u64 xsk_umem_extract_addr(u64 addr)
 {
@@ -224,15 +245,6 @@ static inline int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	return -ENOTSUPP;
 }
 
-static inline int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
-{
-	return -ENOTSUPP;
-}
-
-static inline void xsk_flush(struct xdp_sock *xs)
-{
-}
-
 static inline bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs)
 {
 	return false;
@@ -357,6 +369,21 @@ static inline u64 xsk_umem_adjust_offset(struct xdp_umem *umem, u64 handle,
 	return 0;
 }
 
+static inline int __xsk_map_redirect(struct bpf_map *map, struct xdp_buff *xdp,
+				     struct xdp_sock *xs)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void __xsk_map_flush(struct bpf_map *map)
+{
+}
+
+static inline struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map,
+						     u32 key)
+{
+	return NULL;
+}
 #endif /* CONFIG_XDP_SOCKETS */
 
 #endif /* _LINUX_XDP_SOCK_H */
diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index fa32f775b4de..e3a9eb411586 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -9,13 +9,6 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 
-struct xsk_map {
-	struct bpf_map map;
-	struct list_head __percpu *flush_list;
-	spinlock_t lock; /* Synchronize map updates */
-	struct xdp_sock *xsk_map[];
-};
-
 int xsk_map_inc(struct xsk_map *map)
 {
 	struct bpf_map *m = &map->map;
@@ -151,18 +144,6 @@ static int xsk_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 	return 0;
 }
 
-struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map, u32 key)
-{
-	struct xsk_map *m = container_of(map, struct xsk_map, map);
-	struct xdp_sock *xs;
-
-	if (key >= map->max_entries)
-		return NULL;
-
-	xs = READ_ONCE(m->xsk_map[key]);
-	return xs;
-}
-
 static u32 xsk_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
 {
 	const int ret = BPF_REG_0, mp = BPF_REG_1, index = BPF_REG_2;
@@ -179,35 +160,6 @@ static u32 xsk_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
 	return insn - insn_buf;
 }
 
-int __xsk_map_redirect(struct bpf_map *map, struct xdp_buff *xdp,
-		       struct xdp_sock *xs)
-{
-	struct xsk_map *m = container_of(map, struct xsk_map, map);
-	struct list_head *flush_list = this_cpu_ptr(m->flush_list);
-	int err;
-
-	err = xsk_rcv(xs, xdp);
-	if (err)
-		return err;
-
-	if (!xs->flush_node.prev)
-		list_add(&xs->flush_node, flush_list);
-
-	return 0;
-}
-
-void __xsk_map_flush(struct bpf_map *map)
-{
-	struct xsk_map *m = container_of(map, struct xsk_map, map);
-	struct list_head *flush_list = this_cpu_ptr(m->flush_list);
-	struct xdp_sock *xs, *tmp;
-
-	list_for_each_entry_safe(xs, tmp, flush_list, flush_node) {
-		xsk_flush(xs);
-		__list_del_clearprev(&xs->flush_node);
-	}
-}
-
 static void *xsk_map_lookup_elem(struct bpf_map *map, void *key)
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 9044073fbf22..6040bc2b0088 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -196,7 +196,7 @@ static bool xsk_is_bound(struct xdp_sock *xs)
 	return false;
 }
 
-int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
+static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
 	u32 len;
 
@@ -212,7 +212,7 @@ int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 		__xsk_rcv_zc(xs, xdp, len) : __xsk_rcv(xs, xdp, len);
 }
 
-void xsk_flush(struct xdp_sock *xs)
+static void xsk_flush(struct xdp_sock *xs)
 {
 	xskq_produce_flush_desc(xs->rx);
 	xs->sk.sk_data_ready(&xs->sk);
@@ -264,6 +264,35 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	return err;
 }
 
+int __xsk_map_redirect(struct bpf_map *map, struct xdp_buff *xdp,
+		       struct xdp_sock *xs)
+{
+	struct xsk_map *m = container_of(map, struct xsk_map, map);
+	struct list_head *flush_list = this_cpu_ptr(m->flush_list);
+	int err;
+
+	err = xsk_rcv(xs, xdp);
+	if (err)
+		return err;
+
+	if (!xs->flush_node.prev)
+		list_add(&xs->flush_node, flush_list);
+
+	return 0;
+}
+
+void __xsk_map_flush(struct bpf_map *map)
+{
+	struct xsk_map *m = container_of(map, struct xsk_map, map);
+	struct list_head *flush_list = this_cpu_ptr(m->flush_list);
+	struct xdp_sock *xs, *tmp;
+
+	list_for_each_entry_safe(xs, tmp, flush_list, flush_node) {
+		xsk_flush(xs);
+		__list_del_clearprev(&xs->flush_node);
+	}
+}
+
 void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries)
 {
 	xskq_produce_flush_addr_n(umem->cq, nb_entries);
-- 
2.20.1

