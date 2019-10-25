Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF33E4756
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438717AbfJYJct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 05:32:49 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42218 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729612AbfJYJcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 05:32:48 -0400
Received: by mail-pg1-f194.google.com with SMTP id f14so1169362pgi.9;
        Fri, 25 Oct 2019 02:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vNEBs/qFpn9Y9vRVg1d5sutV2N1vzXfFiDABtbw2mp4=;
        b=rcFaOOJ46Tj8nxZ8qElsd3EnwUCbLg+pfTIoxcBMh0iQMCfkZQtSac2Itfk4qdUkrq
         gGEQ/Ybam7DabpH0hUsLYzal+AIOfQ/IvOvACFV2oYsuPzB56CiAapneXx5mCzupvgrx
         7t3noJPChzN6zNyg83pYKH4BoXwoYrDlBLtJUFGs+HkISUzZAqYDTsMgMQz1HwvWXE8u
         eSIALbLaoVbbRfuK0D/jex/KIbknJ2KfLNL0/ZDCK3oKBu//ZF9PbkxC65zB5xnbKDaA
         akb/lYRdNjT/YoKlisJY9K0p0n/+TSa4FQsmivMI0sG50az4gEnuGQdOh6z21H7/W/An
         dXhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vNEBs/qFpn9Y9vRVg1d5sutV2N1vzXfFiDABtbw2mp4=;
        b=tIkcoxZhCeNe9n4UXxUZXQ0uJYX0itjZa1xPDGrWyntzY6IxEmY9VKIpT32Qve3jDK
         s4d+mE+gif1LR9CV+URtncTT8ShVe7lKEU0QZPTD/fdps/TzAaaazgye8RnwCyXnPOMC
         /g4QoJ80nmWChET5rDKpWo7hczQqyUe86jbFt8x77AcfO+0rqOUyct/0l54/xkwjhv5J
         dQ0Ee4rVX/hiniXyyrYKxOTk5MgC9kdisBJMeGEEzxjIhnNM2BHZpHWtScvtuL1K8eRH
         QhhMPlV+IM5NfNkgkWXURmdXYJIWd0x4LW2TUCnkYTdPWYzoRS/4A6TsauJIyF2CLu04
         eVow==
X-Gm-Message-State: APjAAAW8Jpo8LS1wDP5cIent8FeDFe9iC62BXoEFFRKOIpa6tLQVG6DE
        E+7o6oROSmsrHIKpBpCUwGM0rOF0LxlAuQ==
X-Google-Smtp-Source: APXvYqwJ2WMYi3je0GulEKa8B3g0YiaG8zIzLac7TsvMxh7CK3NWjw+JfEBCg2PZwcq5B48EzmD6og==
X-Received: by 2002:aa7:9aa2:: with SMTP id x2mr3140382pfi.103.1571995967647;
        Fri, 25 Oct 2019 02:32:47 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id k24sm1110557pgl.6.2019.10.25.02.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 02:32:47 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        jonathan.lemon@gmail.com, toke@redhat.com
Subject: [PATCH bpf-next v3 1/2] xsk: store struct xdp_sock as a flexible array member of the XSKMAP
Date:   Fri, 25 Oct 2019 11:32:18 +0200
Message-Id: <20191025093219.10290-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025093219.10290-1-bjorn.topel@gmail.com>
References: <20191025093219.10290-1-bjorn.topel@gmail.com>
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

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 kernel/bpf/xskmap.c | 55 +++++++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 32 deletions(-)

diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index 82a1ffe15dfa..a83e92fe2971 100644
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
+	size_t cost, size;
 
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

