Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3224EABBC
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfJaIsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 04:48:19 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45117 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbfJaIsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 04:48:18 -0400
Received: by mail-pf1-f194.google.com with SMTP id c7so3859624pfo.12;
        Thu, 31 Oct 2019 01:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XFbSumR9ISrKf/5NvOR+v+x480Y0EkreI9Iu42ht9ck=;
        b=Vl4XoDTkBiFdY7gndYA5lA4Z2rEWSpiFSBF0xHzviAiL96EgLBihGGUACWTjsyiy9R
         UVn3DOAOjnndLuusk2sqEFen8o4g9KSOG96Ji7SFrLNp+49R1q6oLR1BnDmpHC4GNrqb
         thqGgSqL21GaRleZQ6+ty+Gz9JTrt/DhUdL8K0wF17jSMt6BFiNjjpFo6mTvcoareFMj
         NI5K/MIvz2Oz58QogmQgwYDrGwdQ7YJwogrzswS+bn1dCVCc7akRUuYyNV9llGNz29Ii
         9d6QLH5z/6G483NTMHbyxl6COFUE7Uhk3J+zNeANNuAEyT2kz7z4dpMvTY3XKRO64UUO
         azag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XFbSumR9ISrKf/5NvOR+v+x480Y0EkreI9Iu42ht9ck=;
        b=ItzGknqibgHKLk8mNU8KsdCyAbIjvTvNcCKg4R83AWCwKonp66Ev8znlohFqHT+kI0
         SN5f+EpMcE+Liq2Fa/T9kLr/5dNvnJ7AuhKWKpa1yL+JAcuchtXn/TGDm7KrmxDq5P4J
         JWoQfLK9y6N2v9VWJOWFHB8MFJGsXKf9jho8FY9yIieJkYK7pjhCn1UXcL+x5uhr6gZM
         unfrUYa1gcH4Vv5xTs3JrowSVF/GgWjVSgVYGlWbtkg4zuPtXmCx/GZnfZeoThfDWnju
         icFa7xrBeqkfoG4iw1ULE1oleXjokZRwdROVsIEhhO97KYAltwj01KjPJXsrmbH+95ch
         AzyA==
X-Gm-Message-State: APjAAAWN0nNEfGn4/knuPJK+3XvIBkS9XGohGcIkO19iqbxr73BwdNiS
        pnkE/U65ym6E8OE+ceWDawREKwpRLpLsTA==
X-Google-Smtp-Source: APXvYqyueablN5hfz+B1kguYwUSljPEd3ajm2FVMV+nwQ+OP9xpmdLsUM11C0Vgr9Jc+MXPZbJ1RrA==
X-Received: by 2002:a63:6a86:: with SMTP id f128mr5039884pgc.295.1572511697837;
        Thu, 31 Oct 2019 01:48:17 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id 4sm3335507pfz.185.2019.10.31.01.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 01:48:17 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        jonathan.lemon@gmail.com, toke@redhat.com
Subject: [PATCH bpf-next v4 1/3] xsk: store struct xdp_sock as a flexible array member of the XSKMAP
Date:   Thu, 31 Oct 2019 09:47:47 +0100
Message-Id: <20191031084749.14626-2-bjorn.topel@gmail.com>
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

Prior this commit, the array storing XDP socket instances were stored
in a separate allocated array of the XSKMAP. Now, we store the sockets
as a flexible array member in a similar fashion as the arraymap. Doing
so, we do less pointer chasing in the lookup.

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 kernel/bpf/xskmap.c | 55 +++++++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 32 deletions(-)

diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index 82a1ffe15dfa..edcbd863650e 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -11,9 +11,9 @@
 
 struct xsk_map {
 	struct bpf_map map;
-	struct xdp_sock **xsk_map;
 	struct list_head __percpu *flush_list;
 	spinlock_t lock; /* Synchronize map updates */
+	struct xdp_sock *xsk_map[];
 };
 
 int xsk_map_inc(struct xsk_map *map)
@@ -80,9 +80,10 @@ static void xsk_map_sock_delete(struct xdp_sock *xs,
 
 static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 {
+	struct bpf_map_memory mem;
+	int cpu, err, numa_node;
 	struct xsk_map *m;
-	int cpu, err;
-	u64 cost;
+	u64 cost, size;
 
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
@@ -92,44 +93,35 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 	    attr->map_flags & ~(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY))
 		return ERR_PTR(-EINVAL);
 
-	m = kzalloc(sizeof(*m), GFP_USER);
-	if (!m)
+	numa_node = bpf_map_attr_numa_node(attr);
+	size = struct_size(m, xsk_map, attr->max_entries);
+	cost = size + array_size(sizeof(*m->flush_list), num_possible_cpus());
+
+	err = bpf_map_charge_init(&mem, cost);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	m = bpf_map_area_alloc(size, numa_node);
+	if (!m) {
+		bpf_map_charge_finish(&mem);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	bpf_map_init_from_attr(&m->map, attr);
+	bpf_map_charge_move(&m->map.memory, &mem);
 	spin_lock_init(&m->lock);
 
-	cost = (u64)m->map.max_entries * sizeof(struct xdp_sock *);
-	cost += sizeof(struct list_head) * num_possible_cpus();
-
-	/* Notice returns -EPERM on if map size is larger than memlock limit */
-	err = bpf_map_charge_init(&m->map.memory, cost);
-	if (err)
-		goto free_m;
-
-	err = -ENOMEM;
-
 	m->flush_list = alloc_percpu(struct list_head);
-	if (!m->flush_list)
-		goto free_charge;
+	if (!m->flush_list) {
+		bpf_map_charge_finish(&m->map.memory);
+		bpf_map_area_free(m);
+		return ERR_PTR(-ENOMEM);
+	}
 
 	for_each_possible_cpu(cpu)
 		INIT_LIST_HEAD(per_cpu_ptr(m->flush_list, cpu));
 
-	m->xsk_map = bpf_map_area_alloc(m->map.max_entries *
-					sizeof(struct xdp_sock *),
-					m->map.numa_node);
-	if (!m->xsk_map)
-		goto free_percpu;
 	return &m->map;
-
-free_percpu:
-	free_percpu(m->flush_list);
-free_charge:
-	bpf_map_charge_finish(&m->map.memory);
-free_m:
-	kfree(m);
-	return ERR_PTR(err);
 }
 
 static void xsk_map_free(struct bpf_map *map)
@@ -139,8 +131,7 @@ static void xsk_map_free(struct bpf_map *map)
 	bpf_clear_redirect_map(map);
 	synchronize_net();
 	free_percpu(m->flush_list);
-	bpf_map_area_free(m->xsk_map);
-	kfree(m);
+	bpf_map_area_free(m);
 }
 
 static int xsk_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
-- 
2.20.1

