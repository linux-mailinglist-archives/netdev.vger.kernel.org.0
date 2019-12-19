Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E92125B4B
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 07:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfLSGKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 01:10:38 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33791 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfLSGKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 01:10:37 -0500
Received: by mail-pl1-f196.google.com with SMTP id c13so2075798pls.0;
        Wed, 18 Dec 2019 22:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+vgdd+bX2QVgDu2mRDHMMkCHnmBd8piReaVXlrpd7kU=;
        b=oSOeQ2rCt1/vBvguKls45RJeOW2apqWzpG8PO2tPpsdyGwx+v80wxKsNW9kQPlpHjU
         NbRJ4j0QR/oDE2+ot1D3fLTYQCE0CwUrX/mQ98xILuhBsjZwj8flRJKeJ4D4rOVTH7hD
         SGb8jxf9JXFhgDV17bcd5PLX+MSl24KqFkN3ENMgAhn6luw540zIZsi6kmfqK0pjBmnM
         ux2EclVB2iwDP9ccnGnytmD5yP/gSeqrLcglTlam4tnJYquJheF80jPXuQAtYGUREePi
         S5MZe2GQhtNDJidQvw7WrASlxqJbd9hUcOx0x7qj8isvJc+3siPzXoBPPTVL196K7Exw
         +66A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+vgdd+bX2QVgDu2mRDHMMkCHnmBd8piReaVXlrpd7kU=;
        b=Vu/v5DYC1FUqrMp0HpWWgSk7gmDKCZN4GdpAtWRug1Ft8yRA9i7bGR99bfEB1MTiwJ
         VBDE6OXBU4Bqz8PJyBOI+XSS8dob0wus0cEFusRJCewsuy48ZQuIP5Gmct7JN+ssiQFP
         V9oYzE8EAu5IT+jpx0JIOwx9L/hzl7bEUt+B8+PmbPb6gOqsdKncE2HKEAe4c/Fao/j8
         6LwJKk3/lIxBB6dD8GW7w1cwmLHnHbaCWJIymIOhfZ3GMt8U72/0OWOMsyFn68c2tEgw
         ME6Aw/cjpPNqgEf2cecMdrYWFbszM8FYd5yGj43jx7l00bQQZuS2Svqk5aBf8BVsqteD
         iO7A==
X-Gm-Message-State: APjAAAUz3uYyJ0Kr/ZyXZZVZ3nyupRON7xoaYXd51lYlCSl86wRyeUeX
        V00G1pJyT9eqHifGMIqe0z252bXJkPirjw==
X-Google-Smtp-Source: APXvYqyFAIHcr5JdPsMD6iUfLwQiDMe1BF4gh1BVN+hjo8vXfGe9qdan0r55/tcA5ZYAmjnT5jvIPw==
X-Received: by 2002:a17:902:8eca:: with SMTP id x10mr7378459plo.248.1576735836794;
        Wed, 18 Dec 2019 22:10:36 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id t23sm6465062pfq.106.2019.12.18.22.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 22:10:36 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v2 4/8] xsk: make xskmap flush_list common for all map instances
Date:   Thu, 19 Dec 2019 07:10:02 +0100
Message-Id: <20191219061006.21980-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191219061006.21980-1-bjorn.topel@gmail.com>
References: <20191219061006.21980-1-bjorn.topel@gmail.com>
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

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xdp_sock.h | 11 ++++-------
 kernel/bpf/xskmap.c    | 18 +++---------------
 net/core/filter.c      |  9 ++++-----
 net/xdp/xsk.c          | 17 +++++++++--------
 4 files changed, 20 insertions(+), 35 deletions(-)

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
index 90c4fce1c981..2cc5c8f4c800 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -72,9 +72,9 @@ static void xsk_map_sock_delete(struct xdp_sock *xs,
 static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 {
 	struct bpf_map_memory mem;
-	int cpu, err, numa_node;
+	int err, numa_node;
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

