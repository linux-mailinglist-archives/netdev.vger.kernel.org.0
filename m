Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 303FA12451C
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfLRKyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:54:21 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34096 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfLRKyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:54:21 -0500
Received: by mail-pl1-f193.google.com with SMTP id x17so816776pln.1;
        Wed, 18 Dec 2019 02:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Qd5NflARgViIrHC8MwB4Q/qP/0pF3sL/L5rhW4kGOM=;
        b=mSf00JoNxGcHkycXAMjhmgRt7fLNc46tq33/tPeTl7bMyIlye/CDURpKDceWe3zX2i
         OspYR0I9kwux7l5BhGb/1KoCTdChR+3mxZHvQMhomYVNhIldBZgHwqdgYXNaYq3BKXP6
         NJfT6LgwYN9ay7sN9O8OhtzpT6I7t25zfI8EN5YgSdA4nEvM6ozzHDcSo4FgLVzITt7O
         TiEWNn9fRKMyWm6bG472kJtuIEBDIGtI6Y9iodZ+1r1jH1Hllx3GNjB6cOUTlv3/FsF+
         lep1xgNCyfsjjZcWzVJ7H5o22r3ITxLOeP4EVw1y4DBnppHACaZ5Zr3dXOtJp0eoKU0r
         dBdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Qd5NflARgViIrHC8MwB4Q/qP/0pF3sL/L5rhW4kGOM=;
        b=L49rPignB8M+4OiUq9TBdHv1E2be4/hhjeYRq6PbWOq/1i2AEJxuro69K+R/0ZxqaY
         Z+urAR4FGzJvHMYCsvchuq2bQqWX3cAy4PGCNSW6Sh8ePFeDSrCnAINgf3tdZVuFCitZ
         BenliKJHsp1e9SwUnIeWmBoRX4OA4vbqZEy4spQzvo1Mhao3Gi6Rfl0h1WAfyIJf9LUZ
         1xP/lvWWsTc2/aMqsgoCVCwkV9EZxb7AO7k+8Fj8ri5tj2Rbwa5exL958FozYvXpmVNb
         o5+FtmakAQdw7dwo9cDR8pLDDQbkyO9EWWrD3deTvS4vgy5JhzLOZmbPC99+yVMwz3Ws
         vIEw==
X-Gm-Message-State: APjAAAWsJYWX3x09ROuJWOtXTkqUinjLxNjbCWqncoeJl2OulQXL8q7h
        A5v1v+axWNn6Ernbs3fDqavJhk19/YJ65g==
X-Google-Smtp-Source: APXvYqwGGmPJ0bxZoFL8BhqLYqCPFanX7pK7dKAk7rc4XjtQlKabAmK2yK3EFlUvgK/UKpgrnk3mnQ==
X-Received: by 2002:a17:902:7207:: with SMTP id ba7mr2053548plb.254.1576666460204;
        Wed, 18 Dec 2019 02:54:20 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id k9sm2339000pje.26.2019.12.18.02.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 02:54:19 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 2/8] xdp: simplify cpumap cleanup
Date:   Wed, 18 Dec 2019 11:53:54 +0100
Message-Id: <20191218105400.2895-3-bjorn.topel@gmail.com>
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

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 kernel/bpf/cpumap.c | 33 +++++----------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index ef49e17ae47c..fbf176e0a2ab 100644
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
@@ -522,18 +514,6 @@ static void cpu_map_free(struct bpf_map *map)
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
@@ -599,7 +579,7 @@ const struct bpf_map_ops cpu_map_ops = {
 	.map_check_btf		= map_check_no_btf,
 };
 
-static int bq_flush_to_queue(struct xdp_bulk_queue *bq, bool in_napi_ctx)
+static int bq_flush_to_queue(struct xdp_bulk_queue *bq)
 {
 	struct bpf_cpu_map_entry *rcpu = bq->obj;
 	unsigned int processed = 0, drops = 0;
@@ -620,10 +600,7 @@ static int bq_flush_to_queue(struct xdp_bulk_queue *bq, bool in_napi_ctx)
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
@@ -646,7 +623,7 @@ static int bq_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf)
 	struct xdp_bulk_queue *bq = this_cpu_ptr(rcpu->bulkq);
 
 	if (unlikely(bq->count == CPU_MAP_BULK_SIZE))
-		bq_flush_to_queue(bq, true);
+		bq_flush_to_queue(bq);
 
 	/* Notice, xdp_buff/page MUST be queued here, long enough for
 	 * driver to code invoking us to finished, due to driver
@@ -688,7 +665,7 @@ void __cpu_map_flush(struct bpf_map *map)
 	struct xdp_bulk_queue *bq, *tmp;
 
 	list_for_each_entry_safe(bq, tmp, flush_list, flush_node) {
-		bq_flush_to_queue(bq, true);
+		bq_flush_to_queue(bq);
 
 		/* If already running, costs spin_lock_irqsave + smb_mb */
 		wake_up_process(bq->obj->kthread);
-- 
2.20.1

