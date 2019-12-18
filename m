Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66F6F124524
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfLRKyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:54:36 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40208 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfLRKyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:54:35 -0500
Received: by mail-pg1-f194.google.com with SMTP id k25so1066707pgt.7;
        Wed, 18 Dec 2019 02:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CFptD5VMBrgxsiklhFlu+20zkzfOIgtFOkPz86thMKA=;
        b=itr3kaUnXcPpTVyQq4W6JxNGomgy8qleI88xzrHmx3sv4xqWHK8tDDq1ZoDVZREaUO
         Cc9oXIdEZqC2qukn3upilbwQ7aTSAjzUJdYJm7CD6ayHBv0E8BvXZm0RAZ/EBk0FfTyF
         dMS6c4pFIkqb2kd9mvCK4lqMRFxXCplbX3YXFWEFZ0GX5rwe/MmYIbZiqT+TeIdz9j2o
         h7O5T10Jj5p2jyWjgDpoLRb8MMoxIKRClPU+mFzMs4mQsV4/bC/ND79yVU0HvY+IlQCg
         2bz/COE9Wo+8Z0TY9fOyVqI/o7SqfyW9AOeKqNZnqq6RU722vNEwJ89S5yes0JrxmSa1
         K+9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CFptD5VMBrgxsiklhFlu+20zkzfOIgtFOkPz86thMKA=;
        b=h+ZNRxp3hXDcJ4NFPC6yuNNcUWyC4Hw2TprXLgkYmGIt8YYJJyWmSy55AE3Fu02kEc
         /sryWnspz1Z+izcPGgRtPCYRvg5KPkUoGK/vYv1z2ISdpouZcIRFc0Xg4x+9bqTcwJkn
         buHDj1a8rIgfgrZKx3GpB2zOVmV/h9RBT0/JcZ7fQhqT9mTySlHpmPs7cTqeBMY+0+0x
         DDXYcT2KKwwYDLaTS1pFsVIOtxflKj+8WvpK2kD2CBPRAoSQiIcRyCq0rqPjX320C8He
         4xWDZlheFJTOQMdc+la6l+M+CnqE5+xPwI+NewqJNWRfkdLqjQZqplsi5cZkI9UzTVyb
         vZsg==
X-Gm-Message-State: APjAAAV/I0T9tf13Qw7zOlpRzL/K678bHOuDpD0v2Krn2dV2YysYXLtx
        jvri4KuDdWjuqchXiMM4Lpt+Q9e/IKL8IQ==
X-Google-Smtp-Source: APXvYqwbBQHlbzVZlzdsy6zAc1kM9AbUARftSz7AYIjTePGXdVu1ilvQPtsBr4haTYhhD59ITTfohw==
X-Received: by 2002:aa7:93ce:: with SMTP id y14mr2284340pff.185.1576666474528;
        Wed, 18 Dec 2019 02:54:34 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id k9sm2339000pje.26.2019.12.18.02.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 02:54:34 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 6/8] xdp: make cpumap flush_list common for all map instances
Date:   Wed, 18 Dec 2019 11:53:58 +0100
Message-Id: <20191218105400.2895-7-bjorn.topel@gmail.com>
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

The cpumap flush list is used to track entries that need to flushed
from via the xdp_do_flush_map() function. This list used to be
per-map, but there is really no reason for that. Instead make the
flush list global for all devmaps, which simplifies __cpu_map_flush()
and cpu_map_alloc().

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/bpf.h |  4 ++--
 kernel/bpf/cpumap.c | 37 ++++++++++++++++++-------------------
 net/core/filter.c   |  2 +-
 3 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 31191804ca09..8f3e00c84f39 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -966,7 +966,7 @@ int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 			     struct bpf_prog *xdp_prog);
 
 struct bpf_cpu_map_entry *__cpu_map_lookup_elem(struct bpf_map *map, u32 key);
-void __cpu_map_flush(struct bpf_map *map);
+void __cpu_map_flush(void);
 int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
 
@@ -1097,7 +1097,7 @@ struct bpf_cpu_map_entry *__cpu_map_lookup_elem(struct bpf_map *map, u32 key)
 	return NULL;
 }
 
-static inline void __cpu_map_flush(struct bpf_map *map)
+static inline void __cpu_map_flush(void)
 {
 }
 
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 66948fbc58d8..70f71b154fa5 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -72,17 +72,18 @@ struct bpf_cpu_map {
 	struct bpf_map map;
 	/* Below members specific for map type */
 	struct bpf_cpu_map_entry **cpu_map;
-	struct list_head __percpu *flush_list;
 };
 
+static DEFINE_PER_CPU(struct list_head, cpu_map_flush_list);
+
 static int bq_flush_to_queue(struct xdp_bulk_queue *bq);
 
 static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 {
 	struct bpf_cpu_map *cmap;
 	int err = -ENOMEM;
-	int ret, cpu;
 	u64 cost;
+	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return ERR_PTR(-EPERM);
@@ -106,7 +107,6 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 
 	/* make sure page count doesn't overflow */
 	cost = (u64) cmap->map.max_entries * sizeof(struct bpf_cpu_map_entry *);
-	cost += sizeof(struct list_head) * num_possible_cpus();
 
 	/* Notice returns -EPERM on if map size is larger than memlock limit */
 	ret = bpf_map_charge_init(&cmap->map.memory, cost);
@@ -115,23 +115,14 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 		goto free_cmap;
 	}
 
-	cmap->flush_list = alloc_percpu(struct list_head);
-	if (!cmap->flush_list)
-		goto free_charge;
-
-	for_each_possible_cpu(cpu)
-		INIT_LIST_HEAD(per_cpu_ptr(cmap->flush_list, cpu));
-
 	/* Alloc array for possible remote "destination" CPUs */
 	cmap->cpu_map = bpf_map_area_alloc(cmap->map.max_entries *
 					   sizeof(struct bpf_cpu_map_entry *),
 					   cmap->map.numa_node);
 	if (!cmap->cpu_map)
-		goto free_percpu;
+		goto free_charge;
 
 	return &cmap->map;
-free_percpu:
-	free_percpu(cmap->flush_list);
 free_charge:
 	bpf_map_charge_finish(&cmap->map.memory);
 free_cmap:
@@ -499,7 +490,6 @@ static int cpu_map_update_elem(struct bpf_map *map, void *key, void *value,
 static void cpu_map_free(struct bpf_map *map)
 {
 	struct bpf_cpu_map *cmap = container_of(map, struct bpf_cpu_map, map);
-	int cpu;
 	u32 i;
 
 	/* At this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
@@ -527,7 +517,6 @@ static void cpu_map_free(struct bpf_map *map)
 		/* bq flush and cleanup happens after RCU grace-period */
 		__cpu_map_entry_replace(cmap, i, NULL); /* call_rcu */
 	}
-	free_percpu(cmap->flush_list);
 	bpf_map_area_free(cmap->cpu_map);
 	kfree(cmap);
 }
@@ -619,7 +608,7 @@ static int bq_flush_to_queue(struct xdp_bulk_queue *bq)
  */
 static int bq_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf)
 {
-	struct list_head *flush_list = this_cpu_ptr(rcpu->cmap->flush_list);
+	struct list_head *flush_list = this_cpu_ptr(&cpu_map_flush_list);
 	struct xdp_bulk_queue *bq = this_cpu_ptr(rcpu->bulkq);
 
 	if (unlikely(bq->count == CPU_MAP_BULK_SIZE))
@@ -658,10 +647,9 @@ int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
 	return 0;
 }
 
-void __cpu_map_flush(struct bpf_map *map)
+void __cpu_map_flush(void)
 {
-	struct bpf_cpu_map *cmap = container_of(map, struct bpf_cpu_map, map);
-	struct list_head *flush_list = this_cpu_ptr(cmap->flush_list);
+	struct list_head *flush_list = this_cpu_ptr(&cpu_map_flush_list);
 	struct xdp_bulk_queue *bq, *tmp;
 
 	list_for_each_entry_safe(bq, tmp, flush_list, flush_node) {
@@ -671,3 +659,14 @@ void __cpu_map_flush(struct bpf_map *map)
 		wake_up_process(bq->obj->kthread);
 	}
 }
+
+static int __init cpu_map_init(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		INIT_LIST_HEAD(&per_cpu(cpu_map_flush_list, cpu));
+	return 0;
+}
+
+subsys_initcall(cpu_map_init);
diff --git a/net/core/filter.c b/net/core/filter.c
index b7570cb84902..c706325b3e66 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3558,7 +3558,7 @@ void xdp_do_flush_map(void)
 			__dev_map_flush();
 			break;
 		case BPF_MAP_TYPE_CPUMAP:
-			__cpu_map_flush(map);
+			__cpu_map_flush();
 			break;
 		case BPF_MAP_TYPE_XSKMAP:
 			__xsk_map_flush();
-- 
2.20.1

