Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A08D3125B4F
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 07:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfLSGKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 01:10:46 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40739 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfLSGKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 01:10:46 -0500
Received: by mail-pl1-f194.google.com with SMTP id g6so2060533plp.7;
        Wed, 18 Dec 2019 22:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QVpnQFhRTxud6ADELWUJl5eIkAl+UW4zPWAV/J/JugY=;
        b=mVID5vn5p0eVMFn5ay6aflAuoaS20E7LYxDmOH74Vt2ndb65N52JTPyzEBe0NoGake
         oiYD/sw28qWe8UXFAY5lwlXi91kFJhv72syyA+TnB/+u0s/jaSgOPqtg3pfhss/46bLj
         oTEsBQMIcd60gI/f5Ff7IH/ENZIfmoQT4F/E1mgTNgTpbdXDjLJDUscAViIA2Pr3obPt
         ji70kZoYE9QzLsX8DwQZbmCCEUlB7SDStWfHR39y5UrukWk0PifNGSh8kFoOl50Hvcgx
         pMUyWENdAbuVTG+WkucEf3USBEuurHQDaH+FKGNYMz/la9lTaOKvwjGjT39eeE5pU8Zt
         ow6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QVpnQFhRTxud6ADELWUJl5eIkAl+UW4zPWAV/J/JugY=;
        b=ojBK7xmlOpriere33sJB2A3JaC8NQAhqOs2xVLa/jWEQfRycsERVeIy0BEgt5srteH
         RY9mw1gC/17biLEtyfh6JUwzFiG30zyKqfGWlQ4UTK6pXzGrd0UOrWEI9Q2vq8T5+XVt
         +N8TQ2o3jzZRWEsKLsmoSCftX/2taQk1sHmZME8U/b+q89FIhx4gjGVN6thaow1yD9Us
         yVI7fkXsxRI4pyduYvdaI72KuTnAVt8QxTch6kLLKOxSDJZH4UOAPTfHKDe0JuWtCOad
         v+4gd5faRG6NGswB2OnIo8y5X2JGj2aVnOl7sDte5Lq16F2YUQAcX8hbRNEtKh48q6Yf
         Sr6g==
X-Gm-Message-State: APjAAAX77Of6eGjrbLZiyE9U8psSVI6VQbx3Cb36sdlm/5R1mZXioqBo
        RE1S5jT2ISTNos12RYNZyJ5iOS5DhFI9gQ==
X-Google-Smtp-Source: APXvYqyE41RqP+zSpnFDrCHuZJcOOvnWQh1u3kHCzOwKpFiA6lW0k6KF1pqlMdlGvoWtO6jX0zHjQw==
X-Received: by 2002:a17:90a:3945:: with SMTP id n5mr3814938pjf.34.1576735844614;
        Wed, 18 Dec 2019 22:10:44 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id t23sm6465062pfq.106.2019.12.18.22.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 22:10:43 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v2 6/8] xdp: make cpumap flush_list common for all map instances
Date:   Thu, 19 Dec 2019 07:10:04 +0100
Message-Id: <20191219061006.21980-7-bjorn.topel@gmail.com>
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

The cpumap flush list is used to track entries that need to flushed
from via the xdp_do_flush_map() function. This list used to be
per-map, but there is really no reason for that. Instead make the
flush list global for all devmaps, which simplifies __cpu_map_flush()
and cpu_map_alloc().

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/bpf.h |  4 ++--
 kernel/bpf/cpumap.c | 36 ++++++++++++++++++------------------
 net/core/filter.c   |  2 +-
 3 files changed, 21 insertions(+), 21 deletions(-)

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
index f9deed659798..70f71b154fa5 100644
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
@@ -526,7 +517,6 @@ static void cpu_map_free(struct bpf_map *map)
 		/* bq flush and cleanup happens after RCU grace-period */
 		__cpu_map_entry_replace(cmap, i, NULL); /* call_rcu */
 	}
-	free_percpu(cmap->flush_list);
 	bpf_map_area_free(cmap->cpu_map);
 	kfree(cmap);
 }
@@ -618,7 +608,7 @@ static int bq_flush_to_queue(struct xdp_bulk_queue *bq)
  */
 static int bq_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf)
 {
-	struct list_head *flush_list = this_cpu_ptr(rcpu->cmap->flush_list);
+	struct list_head *flush_list = this_cpu_ptr(&cpu_map_flush_list);
 	struct xdp_bulk_queue *bq = this_cpu_ptr(rcpu->bulkq);
 
 	if (unlikely(bq->count == CPU_MAP_BULK_SIZE))
@@ -657,10 +647,9 @@ int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
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
@@ -670,3 +659,14 @@ void __cpu_map_flush(struct bpf_map *map)
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

