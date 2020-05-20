Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A31F1DBDCD
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgETTV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgETTV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 15:21:28 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AE5C061A0E;
        Wed, 20 May 2020 12:21:28 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id n11so1886665pgl.9;
        Wed, 20 May 2020 12:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G1YteGz4CGkw/1QFx3GPFqvKGrYaD6ii2xE0mrFwzAc=;
        b=M0Xw/x99wHSWz5/ZRlF2wcBHZTI1Y6fYdxaspCzRJ1F29ic2FNlivy6KlsZuFnMKjS
         5G3pzdeCRWxlGp43C4aJvgLmrAOjJ6/UfMfdtCjrKZ/hfCKxSOqilX1YqkPcQGp1nSW9
         dYIItEk1yOlieDHeO8TMNGG4TAAt8bz8w/fP9PGGgyDiJIKH8nnPvHhXGJwkxLxglL5t
         Do6gtbdKzjYgLtFEKpZR1cwHGqPYiEgJjQfwTDhxQRwPzOH/2+yMd7vD4Hn5BlTLUB7x
         HiRaplqCG44LJanIZVSxZngaASsIyoxiBul58hDstKPiHdaO4lMjOcuFj++9ORMQPR11
         GK+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G1YteGz4CGkw/1QFx3GPFqvKGrYaD6ii2xE0mrFwzAc=;
        b=oqO6bok2EYgOvcIgqI2xp9veXc7c1wYmTRCXZui60ELHgprY3RTC0max1AP7liAr2O
         syQnRGhE2xEh5xbQWtIfGuTOZ29QZBAkCLigXH3yT2fFQ4JyhOlhw6gYT7gkr8Xog6A+
         IIhYzgNZ5GP/KCoD8krYggvHnVFRxwHglRumZxYtvjH3Pj//PgNm1tX1QXjMccyiTsHn
         qNRberZzrj12jUR7RWeg516qQk8oNai7ZIaPOvWVVsaTzW51t25VUDDJhjkKkwtdA5X3
         afazd4MkLCsD41YhXQceCK6NE5QwJssN+oIjGoIIdYHdpqvmkg0Bb0F28P0PkVf/CiTB
         AwJg==
X-Gm-Message-State: AOAM533Nyuj42LxKyouoUiKBVpzhmtNL9B3Lsjdik5mNFfhslAN6BPlf
        k8IHrGr1lY09Rik8ATY1KWU=
X-Google-Smtp-Source: ABdhPJxeFHbjInJ526lKrcs8beM4IzRse9pMOn0JXEod82sdEzU597y1u0SMvi8GrBb8nfhSK8+FyQ==
X-Received: by 2002:a62:c145:: with SMTP id i66mr5536242pfg.23.1590002487528;
        Wed, 20 May 2020 12:21:27 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id 62sm2762424pfc.204.2020.05.20.12.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 12:21:26 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Subject: [PATCH bpf-next v5 02/15] xsk: move xskmap.c to net/xdp/
Date:   Wed, 20 May 2020 21:20:50 +0200
Message-Id: <20200520192103.355233-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200520192103.355233-1-bjorn.topel@gmail.com>
References: <20200520192103.355233-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The XSKMAP is partly implemented by net/xdp/xsk.c. Move xskmap.c from
kernel/bpf/ to net/xdp/, which is the logical place for AF_XDP related
code. Also, move AF_XDP struct definitions, and function declarations
only used by AF_XDP internals into net/xdp/xsk.h.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xdp_sock.h           | 20 --------------------
 kernel/bpf/Makefile              |  3 ---
 net/xdp/Makefile                 |  2 +-
 net/xdp/xsk.h                    | 16 ++++++++++++++++
 {kernel/bpf => net/xdp}/xskmap.c |  2 ++
 5 files changed, 19 insertions(+), 24 deletions(-)
 rename {kernel/bpf => net/xdp}/xskmap.c (99%)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 6b1137ce1692..8f3f6f5b0dfe 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -65,22 +65,12 @@ struct xdp_umem {
 	struct list_head xsk_tx_list;
 };
 
-/* Nodes are linked in the struct xdp_sock map_list field, and used to
- * track which maps a certain socket reside in.
- */
-
 struct xsk_map {
 	struct bpf_map map;
 	spinlock_t lock; /* Synchronize map updates */
 	struct xdp_sock *xsk_map[];
 };
 
-struct xsk_map_node {
-	struct list_head node;
-	struct xsk_map *map;
-	struct xdp_sock **map_entry;
-};
-
 struct xdp_sock {
 	/* struct sock must be the first member of struct xdp_sock */
 	struct sock sk;
@@ -114,7 +104,6 @@ struct xdp_sock {
 struct xdp_buff;
 #ifdef CONFIG_XDP_SOCKETS
 int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp);
-bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs);
 /* Used from netdev driver */
 bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt);
 bool xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr);
@@ -133,10 +122,6 @@ void xsk_clear_rx_need_wakeup(struct xdp_umem *umem);
 void xsk_clear_tx_need_wakeup(struct xdp_umem *umem);
 bool xsk_umem_uses_need_wakeup(struct xdp_umem *umem);
 
-void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
-			     struct xdp_sock **map_entry);
-int xsk_map_inc(struct xsk_map *map);
-void xsk_map_put(struct xsk_map *map);
 int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp);
 void __xsk_map_flush(void);
 
@@ -248,11 +233,6 @@ static inline int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	return -ENOTSUPP;
 }
 
-static inline bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs)
-{
-	return false;
-}
-
 static inline bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt)
 {
 	return false;
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 37b2d8620153..375b933010dd 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -12,9 +12,6 @@ obj-$(CONFIG_BPF_JIT) += dispatcher.o
 ifeq ($(CONFIG_NET),y)
 obj-$(CONFIG_BPF_SYSCALL) += devmap.o
 obj-$(CONFIG_BPF_SYSCALL) += cpumap.o
-ifeq ($(CONFIG_XDP_SOCKETS),y)
-obj-$(CONFIG_BPF_SYSCALL) += xskmap.o
-endif
 obj-$(CONFIG_BPF_SYSCALL) += offload.o
 endif
 ifeq ($(CONFIG_PERF_EVENTS),y)
diff --git a/net/xdp/Makefile b/net/xdp/Makefile
index 71e2bdafb2ce..90b5460d6166 100644
--- a/net/xdp/Makefile
+++ b/net/xdp/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_XDP_SOCKETS) += xsk.o xdp_umem.o xsk_queue.o
+obj-$(CONFIG_XDP_SOCKETS) += xsk.o xdp_umem.o xsk_queue.o xskmap.o
 obj-$(CONFIG_XDP_SOCKETS_DIAG) += xsk_diag.o
diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
index 4cfd106bdb53..d6a0979050e6 100644
--- a/net/xdp/xsk.h
+++ b/net/xdp/xsk.h
@@ -17,9 +17,25 @@ struct xdp_mmap_offsets_v1 {
 	struct xdp_ring_offset_v1 cr;
 };
 
+/* Nodes are linked in the struct xdp_sock map_list field, and used to
+ * track which maps a certain socket reside in.
+ */
+
+struct xsk_map_node {
+	struct list_head node;
+	struct xsk_map *map;
+	struct xdp_sock **map_entry;
+};
+
 static inline struct xdp_sock *xdp_sk(struct sock *sk)
 {
 	return (struct xdp_sock *)sk;
 }
 
+bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs);
+void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
+			     struct xdp_sock **map_entry);
+int xsk_map_inc(struct xsk_map *map);
+void xsk_map_put(struct xsk_map *map);
+
 #endif /* XSK_H_ */
diff --git a/kernel/bpf/xskmap.c b/net/xdp/xskmap.c
similarity index 99%
rename from kernel/bpf/xskmap.c
rename to net/xdp/xskmap.c
index 2cc5c8f4c800..1dc7208c71ba 100644
--- a/kernel/bpf/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -9,6 +9,8 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 
+#include "xsk.h"
+
 int xsk_map_inc(struct xsk_map *map)
 {
 	bpf_map_inc(&map->map);
-- 
2.25.1

