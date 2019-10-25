Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4252BE4440
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 09:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406786AbfJYHTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 03:19:06 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34404 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733140AbfJYHTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 03:19:05 -0400
Received: by mail-pf1-f196.google.com with SMTP id b128so988934pfa.1;
        Fri, 25 Oct 2019 00:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vNEBs/qFpn9Y9vRVg1d5sutV2N1vzXfFiDABtbw2mp4=;
        b=OI/1URL20ON/0j7lgnp9IFqInd1nTIiWAxzLfsI0rZNWclW43uir2L/LHhXGDfa6NG
         lO4stjKB4LAB38KFko83rDwVyLpRXUowxjL3i3rdfISWstsoFazBTaWmWhQ3/RGHL7b9
         KUvHZ/TffVEtUVaPkvucS8SzkKsmO19DwNR+5dQOQeAwXY8M+f/hFqgHG/pPUAS2t45O
         JY+BZY4cTQugW/PQekOTxT8twGSHGDBzvH/87jCJQC1Frfs6syWKdNYHAmSgwMDRUdWg
         5+iUws6lHjoBCby6oAyhYvTRsF9P8lMSq2g51bI+UwsLP5tZ/yfFLcc3KQtDh40kBQeN
         +5GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vNEBs/qFpn9Y9vRVg1d5sutV2N1vzXfFiDABtbw2mp4=;
        b=bgYl4oYuBbo6ohoxfFSX+TSr9Bd1YGnuCfzPgZhCgmwo72IqgSWTOd80DIZUHWqMeV
         a9uhmoCHWIIL7Vsl0122ZsJIs7fYcJEhclracqHPVD5j7VoXUx02TRmRVVyo065WNc2X
         RrQSQcNWDM6j5oeHzcifXn59OsSJ04s59+xIVeWCb/jtmNtZkMSQ3VzkPY7O8Jc4lgIL
         RLWxBVfkTTiIujkz9X6D/xB3WxQTv7eqUUgFPGN+s+cj96Mz6tNrvw4anyyVxsPqmxmT
         2MXC/l2+gFQIDteh5lwOOT/LCZ44hintTryzv1cCHghwOhN/E68X9+is4CjwYssoDTP0
         ccxQ==
X-Gm-Message-State: APjAAAW0oqCYFRbMH036bTc8osV8OPEPSiYvzw5ZcQ9NPqk6BpcTOh6w
        z8Y4H28ANT60u6CnnDRnq/GxTy0Srk8gyQ==
X-Google-Smtp-Source: APXvYqyMrnvwDgoLZrCdg4vNKgxhD/J6bgDji9SOkfaYiDAxpI4r8lzVXP0xP3+RfJ71HvTkObtLmQ==
X-Received: by 2002:a62:1646:: with SMTP id 67mr2488282pfw.216.1571987944747;
        Fri, 25 Oct 2019 00:19:04 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id t27sm1165065pfq.169.2019.10.25.00.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 00:19:04 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        toke@redhat.com
Subject: [PATCH bpf-next v2 1/2] xsk: store struct xdp_sock as a flexible array member of the XSKMAP
Date:   Fri, 25 Oct 2019 09:18:40 +0200
Message-Id: <20191025071842.7724-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025071842.7724-1-bjorn.topel@gmail.com>
References: <20191025071842.7724-1-bjorn.topel@gmail.com>
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

