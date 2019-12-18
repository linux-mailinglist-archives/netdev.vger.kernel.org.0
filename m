Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD2C512451A
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfLRKyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:54:18 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44422 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfLRKyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:54:18 -0500
Received: by mail-pl1-f193.google.com with SMTP id az3so795122plb.11;
        Wed, 18 Dec 2019 02:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aMb2WPe0/U7BL/joSYeG447Xvcg/coxoX4bqpvpwhVk=;
        b=Pq3TZgRth15hoVfIa0UPSIxdrezpkG/tiuRRMiOh6e13kcuCaVf/3QgLmKZC8edtgk
         ykj8mpXu00I0dJjlec1AXPSvRw+mQpLvT7LiJR9icDiS9O5WCffcXsbZy/OMOHCzDQma
         NjeVTAdDqH6T6vkuRlC3U3nod59FsR/f0rmZnRZtPmTx1DIC2t3YYhRoZ4/FZVpADewe
         aqom7Mauw92t9TQkD69jtwhqMjHYK3rMKLjp2T0mBLzHpw8pA4tdXFxOj5+nrKtFSS7E
         IlVfUaCjpDG0/JVn6fawL4kXcAMUEDCMrWdkryUJVyNFMoMRqzfQmzyQZf8pQHEPOPkU
         Rl2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aMb2WPe0/U7BL/joSYeG447Xvcg/coxoX4bqpvpwhVk=;
        b=bwNTIYSxhcs/yVwvQNng3HZyK6UuOmSA7knp/SjMS0/y4L/a0wTDNo4S6umqfkYCoX
         +QyUrOmH1FMwF8knhplG422qFrcbEjJZr3CLAFi3VwE8UI64iZfkKWJ/lN1xHOCZb3Lk
         DHYaZ5p6+335nn1HjQK9uYphfbejl2spSBEyDySgKr0HZDi+PeHKs+t+c4mdh3EU5dmP
         srdK00tklLgNorPBfGHyJw7vEKQdTqK6yph//K/vRpjK/OaNUd/LWJNaAtIemMseEJYy
         WGFaRuFavjh9X8J0vWsumGF0pQQXrdJ8+MwKlWv5T+KcCBGH6HarpNQbU+EARSeeEf4H
         VdBA==
X-Gm-Message-State: APjAAAXfPkpuDFaMAa5yAacX5lXbhWPMdoEUqJPZg3SUMkXVCsb4+10+
        v94su4tl5ibUHoEHUBLNUpcDFlJVXnbHlw==
X-Google-Smtp-Source: APXvYqyEpFB6noiD5LTD6gcS7Tjimry7RrZ4cdAVo7MV52gnrPa/7IjBLt+d62iReh24Ws7nuQkpKw==
X-Received: by 2002:a17:902:7896:: with SMTP id q22mr1874545pll.219.1576666456654;
        Wed, 18 Dec 2019 02:54:16 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id k9sm2339000pje.26.2019.12.18.02.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 02:54:16 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 1/8] xdp: simplify devmap cleanup
Date:   Wed, 18 Dec 2019 11:53:53 +0100
Message-Id: <20191218105400.2895-2-bjorn.topel@gmail.com>
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
code in devmap can be simplified

* There is no longer a need to flush in __dev_map_entry_free, since we
  know that this has been done when the call_rcu() callback is
  triggered.

* When freeing the map, there is no need to explicitly wait for a
  flush. It's guaranteed to be done after the synchronize_rcu() call
  in dev_map_free(). The rcu_barrier() is still needed, so that the
  map is not freed prior the elements.

[1] https://lwn.net/Articles/777036/

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 kernel/bpf/devmap.c | 41 ++++-------------------------------------
 1 file changed, 4 insertions(+), 37 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 3d3d61b5985b..1fcafc641c12 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
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

