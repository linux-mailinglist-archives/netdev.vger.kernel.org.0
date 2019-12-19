Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA2F9125B45
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 07:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfLSGK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 01:10:26 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39212 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfLSGK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 01:10:26 -0500
Received: by mail-pl1-f195.google.com with SMTP id z3so2061916plk.6;
        Wed, 18 Dec 2019 22:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bI1lBlitzrrYjkIpzEceVrisd0eOw8p1XXW9cxpJr8E=;
        b=fdTCd10AvCoR+USD7wtB4S5zc+Q5GR8MQITvQKpwREEKOlGqm1/Gjrt2402PhGGElE
         EwUj+ptFws1gKxbudPXHyezaXVmewruNige1uQgRGGL714LZ0GU6KZ/p425Ed9elH19R
         U3CydsU4a+73x6SI4c3vgf4+crgCYqMUuJcsPgrgXa0xWfwLdjf1MdakSvJH9uSAU6ej
         QqdT7K7rKnm2OZjAbInRqJcmdxHbFf30YNKhfK23OVZX13oPhnEyBtO6FhveMMbbrNAf
         5BOB9pSQ30I1wWGahnX5fmzbAu4itdeYCxt9Oa1wceZhNQbrMmZK98n8Ov5ZH+tm2ice
         VPWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bI1lBlitzrrYjkIpzEceVrisd0eOw8p1XXW9cxpJr8E=;
        b=Af8uxVGOO2pUyuy1tOZXOMEZfKGP6yb5DdUAYQphHw7DNZHwWeSfsVs7gpmH7TlEAs
         2PwCEeBjPagQCzvEvJatrwfBDfJvir1T44JmDgScN4kuGfMarV5VH2B5SrDgF7GQX5FZ
         7Fb7cGPgcts85TvERJ9yZB3c5OipfneZgHVutMxFvuYNf34l0oebpbtvuV/M7s/PzwH0
         X0DvsWVYx/KBGujCmFmA6IO1S72lACm7nDLqLk4IHXpof9wF7/fSHEy+645kOCjo9CZZ
         W8zBVRsNmQj4VXGv093qch/WFV1mtwiR+PSaRcBYDRbBpCJHT8UkSLEi+he1JFxbW8fO
         mAeA==
X-Gm-Message-State: APjAAAUYZpQBnSNNAaWd02PdJskq4URfmHmHFtMcfk54Lsawc02cDNNV
        BAuiE42SSyG/gkgMoqqZSeYcCICdezJPsw==
X-Google-Smtp-Source: APXvYqwI63dbH9UUlOh4qI2Lznovu+xx1IY/eO88/ZxrgmRdPOelp9SkKLeD5gQOs5F9o+EV50Mrlw==
X-Received: by 2002:a17:902:6a8c:: with SMTP id n12mr7387397plk.152.1576735825149;
        Wed, 18 Dec 2019 22:10:25 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id t23sm6465062pfq.106.2019.12.18.22.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 22:10:24 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v2 1/8] xdp: simplify devmap cleanup
Date:   Thu, 19 Dec 2019 07:09:59 +0100
Message-Id: <20191219061006.21980-2-bjorn.topel@gmail.com>
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
code in devmap can be simplified

* There is no longer a need to flush in __dev_map_entry_free, since we
  know that this has been done when the call_rcu() callback is
  triggered.

* When freeing the map, there is no need to explicitly wait for a
  flush. It's guaranteed to be done after the synchronize_rcu() call
  in dev_map_free(). The rcu_barrier() is still needed, so that the
  map is not freed prior the elements.

[1] https://lwn.net/Articles/777036/

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 kernel/bpf/devmap.c | 43 +++++--------------------------------------
 1 file changed, 5 insertions(+), 38 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 3d3d61b5985b..b7595de6a91a 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -201,7 +201,7 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 static void dev_map_free(struct bpf_map *map)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
-	int i, cpu;
+	int i;
 
 	/* At this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
 	 * so the programs (can be more than one that used this map) were
@@ -221,18 +221,6 @@ static void dev_map_free(struct bpf_map *map)
 	/* Make sure prior __dev_map_entry_free() have completed. */
 	rcu_barrier();
 
-	/* To ensure all pending flush operations have completed wait for flush
-	 * list to empty on _all_ cpus.
-	 * Because the above synchronize_rcu() ensures the map is disconnected
-	 * from the program we can assume no new items will be added.
-	 */
-	for_each_online_cpu(cpu) {
-		struct list_head *flush_list = per_cpu_ptr(dtab->flush_list, cpu);
-
-		while (!list_empty(flush_list))
-			cond_resched();
-	}
-
 	if (dtab->map.map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
 		for (i = 0; i < dtab->n_buckets; i++) {
 			struct bpf_dtab_netdev *dev;
@@ -345,8 +333,7 @@ static int dev_map_hash_get_next_key(struct bpf_map *map, void *key,
 	return -ENOENT;
 }
 
-static int bq_xmit_all(struct xdp_bulk_queue *bq, u32 flags,
-		       bool in_napi_ctx)
+static int bq_xmit_all(struct xdp_bulk_queue *bq, u32 flags)
 {
 	struct bpf_dtab_netdev *obj = bq->obj;
 	struct net_device *dev = obj->dev;
@@ -384,11 +371,7 @@ static int bq_xmit_all(struct xdp_bulk_queue *bq, u32 flags,
 	for (i = 0; i < bq->count; i++) {
 		struct xdp_frame *xdpf = bq->q[i];
 
-		/* RX path under NAPI protection, can return frames faster */
-		if (likely(in_napi_ctx))
-			xdp_return_frame_rx_napi(xdpf);
-		else
-			xdp_return_frame(xdpf);
+		xdp_return_frame_rx_napi(xdpf);
 		drops++;
 	}
 	goto out;
@@ -409,7 +392,7 @@ void __dev_map_flush(struct bpf_map *map)
 
 	rcu_read_lock();
 	list_for_each_entry_safe(bq, tmp, flush_list, flush_node)
-		bq_xmit_all(bq, XDP_XMIT_FLUSH, true);
+		bq_xmit_all(bq, XDP_XMIT_FLUSH);
 	rcu_read_unlock();
 }
 
@@ -440,7 +423,7 @@ static int bq_enqueue(struct bpf_dtab_netdev *obj, struct xdp_frame *xdpf,
 	struct xdp_bulk_queue *bq = this_cpu_ptr(obj->bulkq);
 
 	if (unlikely(bq->count == DEV_MAP_BULK_SIZE))
-		bq_xmit_all(bq, 0, true);
+		bq_xmit_all(bq, 0);
 
 	/* Ingress dev_rx will be the same for all xdp_frame's in
 	 * bulk_queue, because bq stored per-CPU and must be flushed
@@ -509,27 +492,11 @@ static void *dev_map_hash_lookup_elem(struct bpf_map *map, void *key)
 	return dev ? &dev->ifindex : NULL;
 }
 
-static void dev_map_flush_old(struct bpf_dtab_netdev *dev)
-{
-	if (dev->dev->netdev_ops->ndo_xdp_xmit) {
-		struct xdp_bulk_queue *bq;
-		int cpu;
-
-		rcu_read_lock();
-		for_each_online_cpu(cpu) {
-			bq = per_cpu_ptr(dev->bulkq, cpu);
-			bq_xmit_all(bq, XDP_XMIT_FLUSH, false);
-		}
-		rcu_read_unlock();
-	}
-}
-
 static void __dev_map_entry_free(struct rcu_head *rcu)
 {
 	struct bpf_dtab_netdev *dev;
 
 	dev = container_of(rcu, struct bpf_dtab_netdev, rcu);
-	dev_map_flush_old(dev);
 	free_percpu(dev->bulkq);
 	dev_put(dev->dev);
 	kfree(dev);
-- 
2.20.1

