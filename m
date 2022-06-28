Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFC355EE33
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbiF1Ty2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbiF1Tuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4760BA5;
        Tue, 28 Jun 2022 12:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445783; x=1687981783;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=assH3g8cMJnpD/kb79aEpQaxf3/AadyGdz71JUQEZCc=;
  b=k9ItFV9wBsi5bb2jx6jBFlsBOt7P9s9pksSLrsfoKSgw6BiJoL1C+o2Z
   BfF5NEGomXvus5NlfzF27UK9FncQno2FHmxmZ0lFeAX0mpiovB8XAj1wU
   xoyKMadcPSFHwAB3nziGKhAUBqKr04RY/8eOHEs1rOh7SAIhNixApthj5
   beMAi7c5N+ZCsxm+AAUll7kV59mAKXlT7xwfu7xZ2F9klch6hihqVqQGC
   V2ddAcWudk0PkXc1h6G5D4S1oPUk8Oy3iY3jVFGSVlnvpQrCOSWx/NWFx
   O8ldWxru8Cr10LwMTxY0c1CzddJaTNmJ5WrdySX0bTYn9fAXpnZvC3t5W
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="261635707"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="261635707"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="767288164"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 28 Jun 2022 12:49:38 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9W022013;
        Tue, 28 Jun 2022 20:49:36 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 32/52] bpf, cpumap: switch to GRO from netif_receive_skb_list()
Date:   Tue, 28 Jun 2022 21:47:52 +0200
Message-Id: <20220628194812.1453059-33-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cpumap has its own BH context based on kthread. It has a sane batch
size of 8 frames per one cycle.
GRO can be used on its own, adjust cpumap calls to the
upper stack to use GRO API instead of netif_receive_skb_list() which
processes skbs by batches, but doesn't involve GRO layer at all.
It is most beneficial when a NIC which frame come from is XDP
generic metadata-enabled, but in plenty of tests GRO performs better
than listed receiving even given that it has to calculate full frame
checksums on CPU.
As GRO passes the skbs to the upper stack in the batches of
@gro_normal_batch, i.e. 8 by default, and @skb->dev point to the
device where the frame comes from, it is enough to disable GRO
netdev feature on it to completely restore the original behaviour:
untouched frames will be being bulked and passed to the upper stack
by 8, as it was with netif_receive_skb_list().

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 kernel/bpf/cpumap.c | 43 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index f4860ac756cd..2d0edf8f6a05 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -29,8 +29,8 @@
 #include <trace/events/xdp.h>
 #include <linux/btf_ids.h>
 
-#include <linux/netdevice.h>   /* netif_receive_skb_list */
-#include <linux/etherdevice.h> /* eth_type_trans */
+#include <linux/netdevice.h>
+#include <net/gro.h>
 
 /* General idea: XDP packets getting XDP redirected to another CPU,
  * will maximum be stored/queued for one driver ->poll() call.  It is
@@ -67,6 +67,8 @@ struct bpf_cpu_map_entry {
 	struct bpf_cpumap_val value;
 	struct bpf_prog *prog;
 
+	struct gro_node gro;
+
 	atomic_t refcnt; /* Control when this struct can be free'ed */
 	struct rcu_head rcu;
 
@@ -162,6 +164,7 @@ static void put_cpu_map_entry(struct bpf_cpu_map_entry *rcpu)
 	if (atomic_dec_and_test(&rcpu->refcnt)) {
 		if (rcpu->prog)
 			bpf_prog_put(rcpu->prog);
+		gro_cleanup(&rcpu->gro);
 		/* The queue should be empty at this point */
 		__cpu_map_ring_cleanup(rcpu->queue);
 		ptr_ring_cleanup(rcpu->queue, NULL);
@@ -295,6 +298,33 @@ static int cpu_map_bpf_prog_run(struct bpf_cpu_map_entry *rcpu, void **frames,
 	return nframes;
 }
 
+static void cpu_map_gro_flush(struct bpf_cpu_map_entry *rcpu,
+			      struct list_head *list)
+{
+	bool new = !list_empty(list);
+
+	if (likely(new))
+		gro_receive_skb_list(&rcpu->gro, list);
+
+	if (rcpu->gro.bitmask) {
+		bool flush_old = HZ >= 1000;
+
+		/* If the ring is not empty, there'll be a new iteration
+		 * soon, and we only need to do a full flush if a tick is
+		 * long (> 1 ms).
+		 * If the ring is empty, to not hold GRO packets in the
+		 * stack for too long, do a full flush.
+		 * This is equivalent to how NAPI decides whether to perform
+		 * a full flush (by batches of up to 64 frames tho).
+		 */
+		if (__ptr_ring_empty(rcpu->queue))
+			flush_old = false;
+
+		__gro_flush(&rcpu->gro, flush_old);
+	}
+
+	gro_normal_list(&rcpu->gro);
+}
 
 static int cpu_map_kthread_run(void *data)
 {
@@ -384,7 +414,7 @@ static int cpu_map_kthread_run(void *data)
 
 			list_add_tail(&skb->list, &list);
 		}
-		netif_receive_skb_list(&list);
+		cpu_map_gro_flush(rcpu, &list);
 
 		/* Feedback loop via tracepoint */
 		trace_xdp_cpumap_kthread(rcpu->map_id, n, kmem_alloc_drops,
@@ -460,8 +490,10 @@ __cpu_map_entry_alloc(struct bpf_map *map, struct bpf_cpumap_val *value,
 	rcpu->map_id = map->id;
 	rcpu->value.qsize  = value->qsize;
 
+	gro_init(&rcpu->gro, NULL);
+
 	if (fd > 0 && __cpu_map_load_bpf_program(rcpu, map, fd))
-		goto free_ptr_ring;
+		goto free_gro;
 
 	/* Setup kthread */
 	rcpu->kthread = kthread_create_on_node(cpu_map_kthread_run, rcpu, numa,
@@ -482,7 +514,8 @@ __cpu_map_entry_alloc(struct bpf_map *map, struct bpf_cpumap_val *value,
 free_prog:
 	if (rcpu->prog)
 		bpf_prog_put(rcpu->prog);
-free_ptr_ring:
+free_gro:
+	gro_cleanup(&rcpu->gro);
 	ptr_ring_cleanup(rcpu->queue, NULL);
 free_queue:
 	kfree(rcpu->queue);
-- 
2.36.1

