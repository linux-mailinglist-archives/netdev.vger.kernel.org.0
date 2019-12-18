Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3F8124520
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfLRKy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:54:28 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39725 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfLRKy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:54:28 -0500
Received: by mail-pl1-f193.google.com with SMTP id z3so804449plk.6;
        Wed, 18 Dec 2019 02:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/YjCXVv+uOihZ50ctG/6piwPgqsBGgthVMgNHNysIhY=;
        b=Lmo2q2v7ClL30RHJ73+khG8mcEBaQPGEc+WW9TVAsjFPPeE3k0oPyQd6wN43zQImot
         G8nTuF+AD0fH5n0ioJCBKVvJnZT4VwSGAOF6GLuKU8duc/Ntgk7R+OWpdYj85zrERDzq
         f8klz26RBLSZHvJCnyliBQJMifjytYuCLzkAtBl6IOuPFgcxdkLL87rB+xgW3BOKBTW/
         ZKeRI3s3gAfg6Tp5QEW8QB24IUKLKuWb38j02oaEBRRVdQkLQW5/gCBvcPF63airKX5+
         89RyD2qRHCD7Ku4bXlQKWUl22skf59Ar/VDLTes7bMUrL1hWn72MuZvpKkH5fUT3CJnY
         xffA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/YjCXVv+uOihZ50ctG/6piwPgqsBGgthVMgNHNysIhY=;
        b=diNQsdWWPiubFXU/00Ob5MwdtPVekBQVYBdzSaBBN12EE0cnvTWsXP3SJJBCpNbABT
         kiyGA9KFQ2+i82jHNUuYsW4sLDuJygjFmsuQCweWn6PnQqCWGiYk49f1Y9PhXvf76i9Y
         jbW3We1evdUTmJAb7/Df7V2QNyQHW6HH5ZU4UYhrqiRzSxHWnMWTNI/Zv32sTwVGsiha
         GZIVK2z+57LFjDpgfk6hRccTFM4VtcW5pyug2wfC9vRvDBEdjx7WlKQfgbwYvcaNwyWL
         EwEars24WXPJjQh/tgDAQfl2vqVGpN99Ksy58Q9F5h6Jdtfx4AwNWfBLP9rPvp1vt+WO
         TRtg==
X-Gm-Message-State: APjAAAXosIuD6PN+8EatAxXo34ur/YrL1FsEPHEv4co06XBqLTei5gH1
        P2/UnGKPbTflNV+gFAfjN7Py38GP2geLiA==
X-Google-Smtp-Source: APXvYqy6IE57sbTpTbOH9FB78lpF2PdxvIoUrp3PJHZNagXKRr22Q0kQouLlUosu3yJpknUBA26xXg==
X-Received: by 2002:a17:902:b087:: with SMTP id p7mr2132285plr.10.1576666467218;
        Wed, 18 Dec 2019 02:54:27 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id k9sm2339000pje.26.2019.12.18.02.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 02:54:26 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 4/8] xsk: make xskmap flush_list common for all map instances
Date:   Wed, 18 Dec 2019 11:53:56 +0100
Message-Id: <20191218105400.2895-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191218105400.2895-1-bjorn.topel@gmail.com>
References: <20191218105400.2895-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The xskmap flush list is used to track entries that need to flushed
from via the xdp_do_flush_map() function. This list used to be
per-map, but there is really no reason for that. Instead make the
flush list global for all xskmaps, which simplifies __xsk_map_flush()
and xsk_map_alloc().

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xdp_sock.h | 11 ++++-------
 kernel/bpf/xskmap.c    | 16 ++--------------
 net/core/filter.c      |  9 ++++-----
 net/xdp/xsk.c          | 17 +++++++++--------
 4 files changed, 19 insertions(+), 34 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index e3780e4b74e1..48594740d67c 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -72,7 +72,6 @@ struct xdp_umem {
 
 struct xsk_map {
 	struct bpf_map map;
-	struct list_head __percpu *flush_list;
 	spinlock_t lock; /* Synchronize map updates */
 	struct xdp_sock *xsk_map[];
 };
@@ -139,9 +138,8 @@ void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
 			     struct xdp_sock **map_entry);
 int xsk_map_inc(struct xsk_map *map);
 void xsk_map_put(struct xsk_map *map);
-int __xsk_map_redirect(struct bpf_map *map, struct xdp_buff *xdp,
-		       struct xdp_sock *xs);
-void __xsk_map_flush(struct bpf_map *map);
+int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp);
+void __xsk_map_flush(void);
 
 static inline struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map,
 						     u32 key)
@@ -369,13 +367,12 @@ static inline u64 xsk_umem_adjust_offset(struct xdp_umem *umem, u64 handle,
 	return 0;
 }
 
-static inline int __xsk_map_redirect(struct bpf_map *map, struct xdp_buff *xdp,
-				     struct xdp_sock *xs)
+static inline int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline void __xsk_map_flush(struct bpf_map *map)
+static inline void __xsk_map_flush(void)
 {
 }
 
diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index 90c4fce1c981..3757a7a50ab7 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -74,7 +74,7 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 	struct bpf_map_memory mem;
 	int cpu, err, numa_node;
 	struct xsk_map *m;
-	u64 cost, size;
+	u64 size;
 
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
@@ -86,9 +86,8 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 
 	numa_node = bpf_map_attr_numa_node(attr);
 	size = struct_size(m, xsk_map, attr->max_entries);
-	cost = size + array_size(sizeof(*m->flush_list), num_possible_cpus());
 
-	err = bpf_map_charge_init(&mem, cost);
+	err = bpf_map_charge_init(&mem, size);
 	if (err < 0)
 		return ERR_PTR(err);
 
@@ -102,16 +101,6 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 	bpf_map_charge_move(&m->map.memory, &mem);
 	spin_lock_init(&m->lock);
 
-	m->flush_list = alloc_percpu(struct list_head);
-	if (!m->flush_list) {
-		bpf_map_charge_finish(&m->map.memory);
-		bpf_map_area_free(m);
-		return ERR_PTR(-ENOMEM);
-	}
-
-	for_each_possible_cpu(cpu)
-		INIT_LIST_HEAD(per_cpu_ptr(m->flush_list, cpu));
-
 	return &m->map;
 }
 
@@ -121,7 +110,6 @@ static void xsk_map_free(struct bpf_map *map)
 
 	bpf_clear_redirect_map(map);
 	synchronize_net();
-	free_percpu(m->flush_list);
 	bpf_map_area_free(m);
 }
 
diff --git a/net/core/filter.c b/net/core/filter.c
index a411f7835dee..c51678c473c5 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3511,8 +3511,7 @@ xdp_do_redirect_slow(struct net_device *dev, struct xdp_buff *xdp,
 
 static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
 			    struct bpf_map *map,
-			    struct xdp_buff *xdp,
-			    u32 index)
+			    struct xdp_buff *xdp)
 {
 	int err;
 
@@ -3537,7 +3536,7 @@ static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
 	case BPF_MAP_TYPE_XSKMAP: {
 		struct xdp_sock *xs = fwd;
 
-		err = __xsk_map_redirect(map, xdp, xs);
+		err = __xsk_map_redirect(xs, xdp);
 		return err;
 	}
 	default:
@@ -3562,7 +3561,7 @@ void xdp_do_flush_map(void)
 			__cpu_map_flush(map);
 			break;
 		case BPF_MAP_TYPE_XSKMAP:
-			__xsk_map_flush(map);
+			__xsk_map_flush();
 			break;
 		default:
 			break;
@@ -3619,7 +3618,7 @@ static int xdp_do_redirect_map(struct net_device *dev, struct xdp_buff *xdp,
 	if (ri->map_to_flush && unlikely(ri->map_to_flush != map))
 		xdp_do_flush_map();
 
-	err = __bpf_tx_xdp_map(dev, fwd, map, xdp, index);
+	err = __bpf_tx_xdp_map(dev, fwd, map, xdp);
 	if (unlikely(err))
 		goto err;
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 956793893c9d..e45c27f5cfca 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -31,6 +31,8 @@
 
 #define TX_BATCH_SIZE 16
 
+static DEFINE_PER_CPU(struct list_head, xskmap_flush_list);
+
 bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs)
 {
 	return READ_ONCE(xs->rx) &&  READ_ONCE(xs->umem) &&
@@ -264,11 +266,9 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	return err;
 }
 
-int __xsk_map_redirect(struct bpf_map *map, struct xdp_buff *xdp,
-		       struct xdp_sock *xs)
+int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
-	struct xsk_map *m = container_of(map, struct xsk_map, map);
-	struct list_head *flush_list = this_cpu_ptr(m->flush_list);
+	struct list_head *flush_list = this_cpu_ptr(&xskmap_flush_list);
 	int err;
 
 	err = xsk_rcv(xs, xdp);
@@ -281,10 +281,9 @@ int __xsk_map_redirect(struct bpf_map *map, struct xdp_buff *xdp,
 	return 0;
 }
 
-void __xsk_map_flush(struct bpf_map *map)
+void __xsk_map_flush(void)
 {
-	struct xsk_map *m = container_of(map, struct xsk_map, map);
-	struct list_head *flush_list = this_cpu_ptr(m->flush_list);
+	struct list_head *flush_list = this_cpu_ptr(&xskmap_flush_list);
 	struct xdp_sock *xs, *tmp;
 
 	list_for_each_entry_safe(xs, tmp, flush_list, flush_node) {
@@ -1177,7 +1176,7 @@ static struct pernet_operations xsk_net_ops = {
 
 static int __init xsk_init(void)
 {
-	int err;
+	int err, cpu;
 
 	err = proto_register(&xsk_proto, 0 /* no slab */);
 	if (err)
@@ -1195,6 +1194,8 @@ static int __init xsk_init(void)
 	if (err)
 		goto out_pernet;
 
+	for_each_possible_cpu(cpu)
+		INIT_LIST_HEAD(&per_cpu(xskmap_flush_list, cpu));
 	return 0;
 
 out_pernet:
-- 
2.20.1

