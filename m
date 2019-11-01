Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A27CEC181
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 12:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730200AbfKALEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 07:04:12 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41902 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729855AbfKALEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 07:04:11 -0400
Received: by mail-pf1-f193.google.com with SMTP id p26so6812624pfq.8;
        Fri, 01 Nov 2019 04:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XFbSumR9ISrKf/5NvOR+v+x480Y0EkreI9Iu42ht9ck=;
        b=WHiSrAedUdPhq7RJVHPp/tQ8pn/ro78pn2lUtHeyms8Yuk7VZEBIFrjZFZNMhvlq3/
         jJRQs2Z5EywYjuepBWYDjmC0dNWgPkiD1dNtEaq7z+lCkDrJ1zfDz73tbP3nV/Twx39M
         a7kozTtwJ/U7+L6qWygcu4YUKwvYJabim48Bw13xQukumHLnYanWagaUa2O3AvxoI8Fz
         bL25jcce05zF1a4LrGdDGAVU9qk5+Hxoc0mKoJuRA3V7WY7BohgFPqw/wpKlkzt2bBhH
         kfgowwd75TM6430snmB5y4zzWjjR1iGv4xlx2A4GSXOzi4BfRx+CKaz8mL79LdgPTPh4
         wZNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XFbSumR9ISrKf/5NvOR+v+x480Y0EkreI9Iu42ht9ck=;
        b=r0dqWpQI7SpDq7oUcdtep1J6z9Zei5Zxx1ZOrMXeAQTbr6WpVYrF/8aRMLWVMJW+Pf
         Vax2psXPlEVBTtVAcpo0wSVE3YrZwsyT1gZYee6VQI+fRlZW6XutJB6jkDeJ1K2nqwnL
         Drssx87FYFoZkY90e8E+6KDksS1p0rm4cCad9fZDpDaKay2doDAw3/jGn9rQAQ5CHefe
         lRArshFwKsmJpOztCLvge6F5HmkcvYYVjMWFFbEKnit0rz+PR/y79KdVEMFtUrB9iAcC
         R45LkWzn/oJ4HTSj54bs2R9XEGE3+FUUnMCGBoCxNFcHpqy5SiAjulatG0q7Cr9xzPor
         jHrg==
X-Gm-Message-State: APjAAAXQV2LFTrGOYfbLX46Iobx6B7K7PfM1Ul40oep9yz3xry2I0o4p
        xd3jomNhIk/9RwM0/8adGcyRERfFm0cVZg==
X-Google-Smtp-Source: APXvYqzSOrPn/T4hbXUCE/vjaF35aEOZwbe5ZjuFzoysMqQb2W//quMfQaFuMNeG7ZHCAA0GU2KGWw==
X-Received: by 2002:a17:90a:1f0c:: with SMTP id u12mr10058671pja.22.1572606250881;
        Fri, 01 Nov 2019 04:04:10 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (jfdmzpr04-ext.jf.intel.com. [134.134.137.73])
        by smtp.gmail.com with ESMTPSA id c6sm6939767pfj.59.2019.11.01.04.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 04:04:10 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        jonathan.lemon@gmail.com, toke@redhat.com
Subject: [PATCH bpf-next v5 1/3] xsk: store struct xdp_sock as a flexible array member of the XSKMAP
Date:   Fri,  1 Nov 2019 12:03:44 +0100
Message-Id: <20191101110346.15004-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191101110346.15004-1-bjorn.topel@gmail.com>
References: <20191101110346.15004-1-bjorn.topel@gmail.com>
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

