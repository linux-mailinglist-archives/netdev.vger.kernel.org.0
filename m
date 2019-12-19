Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB64C125B47
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 07:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfLSGKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 01:10:30 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42151 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfLSGKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 01:10:30 -0500
Received: by mail-pg1-f195.google.com with SMTP id s64so2540053pgb.9;
        Wed, 18 Dec 2019 22:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/dsmUVNAhSI59hVwRMdIKQKHjkCYBDKeIK0lHIqsUtg=;
        b=C4ZxPnG4scgXIdJxmsUwKfTtIDTPf+5bz2kJVyBTK0IVhDyZDV7V9seNCnMKfScF4Q
         xfHiFQobP5pWyf1yrB0aORXSP4oJ3NQxT7Mmu29V3lpF59AGo58Fze8PRtryI6ENEVM9
         wGd31JmEsL333x584bn1OdSECjM+9vSZC0EmA7ihTVc8MCQeLVHhyrXy4I8nkP62g4OA
         3K/Pwnb7V8s5N2cnpUFvWOuLE29lWlEUy/8NGuq26Vmc+LcYODcquQv54HytvO0uURql
         748/d2FBN9S/xNcBmLLbDNM/zypb+tOmHm55G7opwgyKqfeNbd7j3bJchk8zzTxbVYRe
         3oUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/dsmUVNAhSI59hVwRMdIKQKHjkCYBDKeIK0lHIqsUtg=;
        b=UX0UK5j2GPugKQqB+DzROmQpMcgPnKLRO0tj/aw0sVzOSVNveYkeLiKksFx2XkgWr4
         UryQeVvSOrYHe4z7nWuVgKSYycLMA3SDVpAGwdviGjuEkvgGDuKIVZzBTepAJw7D+oZM
         8fXh7MQd5/XsHBkYzfT8jAMlWkltRwhMXcR13/f2AYCNS4ZkbdGO3WYywO6Kr22idZ0+
         S6urecOpks0NWB6hF5uj4v1R745Cu2s1V/U+kBWWbEZZQ0hEJkbYMo8ZCQUDCX3oPm33
         WR3gC3oAMIXy0l6+pINqUvivykVz/Ubi4hcHv3bYhaFDBneyY6W4Q7HH90JaONyNbnRi
         sB5A==
X-Gm-Message-State: APjAAAVldVPCevHmcCufKjTFJVagFAdWZ1dy7+yxP7hPXZmVyXvYcf8x
        LLk7UxfYiiOqWW75q9JOZnNg1PUVBnkUsw==
X-Google-Smtp-Source: APXvYqx7qXJmReHUFjmYV7tEzGjNSfxnwcjvNyemXuAS19fBHTOA+3HPyyLbv0FibpWtyQ5H8/JHVQ==
X-Received: by 2002:a63:181a:: with SMTP id y26mr7513754pgl.423.1576735829053;
        Wed, 18 Dec 2019 22:10:29 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id t23sm6465062pfq.106.2019.12.18.22.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 22:10:28 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v2 2/8] xdp: simplify cpumap cleanup
Date:   Thu, 19 Dec 2019 07:10:00 +0100
Message-Id: <20191219061006.21980-3-bjorn.topel@gmail.com>
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

After the RCU flavor consolidation [1], call_rcu() and
synchronize_rcu() waits for preempt-disable regions (NAPI) in addition
to the read-side critical sections. As a result of this, the cleanup
code in cpumap can be simplified

* There is no longer a need to flush in __cpu_map_entry_free, since we
  know that this has been done when the call_rcu() callback is
  triggered.

* When freeing the map, there is no need to explicitly wait for a
  flush. It's guaranteed to be done after the synchronize_rcu() call
  in cpu_map_free().

[1] https://lwn.net/Articles/777036/

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 kernel/bpf/cpumap.c | 34 +++++-----------------------------
 1 file changed, 5 insertions(+), 29 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index ef49e17ae47c..04c8eb11cd90 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -75,7 +75,7 @@ struct bpf_cpu_map {
 	struct list_head __percpu *flush_list;
 };
 
-static int bq_flush_to_queue(struct xdp_bulk_queue *bq, bool in_napi_ctx);
+static int bq_flush_to_queue(struct xdp_bulk_queue *bq);
 
 static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 {
@@ -399,7 +399,6 @@ static struct bpf_cpu_map_entry *__cpu_map_entry_alloc(u32 qsize, u32 cpu,
 static void __cpu_map_entry_free(struct rcu_head *rcu)
 {
 	struct bpf_cpu_map_entry *rcpu;
-	int cpu;
 
 	/* This cpu_map_entry have been disconnected from map and one
 	 * RCU graze-period have elapsed.  Thus, XDP cannot queue any
@@ -408,13 +407,6 @@ static void __cpu_map_entry_free(struct rcu_head *rcu)
 	 */
 	rcpu = container_of(rcu, struct bpf_cpu_map_entry, rcu);
 
-	/* Flush remaining packets in percpu bulkq */
-	for_each_online_cpu(cpu) {
-		struct xdp_bulk_queue *bq = per_cpu_ptr(rcpu->bulkq, cpu);
-
-		/* No concurrent bq_enqueue can run at this point */
-		bq_flush_to_queue(bq, false);
-	}
 	free_percpu(rcpu->bulkq);
 	/* Cannot kthread_stop() here, last put free rcpu resources */
 	put_cpu_map_entry(rcpu);
@@ -507,7 +499,6 @@ static int cpu_map_update_elem(struct bpf_map *map, void *key, void *value,
 static void cpu_map_free(struct bpf_map *map)
 {
 	struct bpf_cpu_map *cmap = container_of(map, struct bpf_cpu_map, map);
-	int cpu;
 	u32 i;
 
 	/* At this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
@@ -522,18 +513,6 @@ static void cpu_map_free(struct bpf_map *map)
 	bpf_clear_redirect_map(map);
 	synchronize_rcu();
 
-	/* To ensure all pending flush operations have completed wait for flush
-	 * list be empty on _all_ cpus. Because the above synchronize_rcu()
-	 * ensures the map is disconnected from the program we can assume no new
-	 * items will be added to the list.
-	 */
-	for_each_online_cpu(cpu) {
-		struct list_head *flush_list = per_cpu_ptr(cmap->flush_list, cpu);
-
-		while (!list_empty(flush_list))
-			cond_resched();
-	}
-
 	/* For cpu_map the remote CPUs can still be using the entries
 	 * (struct bpf_cpu_map_entry).
 	 */
@@ -599,7 +578,7 @@ const struct bpf_map_ops cpu_map_ops = {
 	.map_check_btf		= map_check_no_btf,
 };
 
-static int bq_flush_to_queue(struct xdp_bulk_queue *bq, bool in_napi_ctx)
+static int bq_flush_to_queue(struct xdp_bulk_queue *bq)
 {
 	struct bpf_cpu_map_entry *rcpu = bq->obj;
 	unsigned int processed = 0, drops = 0;
@@ -620,10 +599,7 @@ static int bq_flush_to_queue(struct xdp_bulk_queue *bq, bool in_napi_ctx)
 		err = __ptr_ring_produce(q, xdpf);
 		if (err) {
 			drops++;
-			if (likely(in_napi_ctx))
-				xdp_return_frame_rx_napi(xdpf);
-			else
-				xdp_return_frame(xdpf);
+			xdp_return_frame_rx_napi(xdpf);
 		}
 		processed++;
 	}
@@ -646,7 +622,7 @@ static int bq_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf)
 	struct xdp_bulk_queue *bq = this_cpu_ptr(rcpu->bulkq);
 
 	if (unlikely(bq->count == CPU_MAP_BULK_SIZE))
-		bq_flush_to_queue(bq, true);
+		bq_flush_to_queue(bq);
 
 	/* Notice, xdp_buff/page MUST be queued here, long enough for
 	 * driver to code invoking us to finished, due to driver
@@ -688,7 +664,7 @@ void __cpu_map_flush(struct bpf_map *map)
 	struct xdp_bulk_queue *bq, *tmp;
 
 	list_for_each_entry_safe(bq, tmp, flush_list, flush_node) {
-		bq_flush_to_queue(bq, true);
+		bq_flush_to_queue(bq);
 
 		/* If already running, costs spin_lock_irqsave + smb_mb */
 		wake_up_process(bq->obj->kthread);
-- 
2.20.1

