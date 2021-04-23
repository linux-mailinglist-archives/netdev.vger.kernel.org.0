Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F8F368F58
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 11:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241749AbhDWJ2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 05:28:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230032AbhDWJ2P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 05:28:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA4606145E;
        Fri, 23 Apr 2021 09:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619170058;
        bh=uSO9NtVGykADtblu1hYIMvVRLCvbZiO5+pUb1Ap4dKc=;
        h=From:To:Cc:Subject:Date:From;
        b=pktQmnEWf9WAiYuFcB6y1uw9XC6cP33Qd44BPG0zmmAvXGrCFKxN7MmM30dsp/k4c
         orqkc5R3/yju8jkYPP3gsJkuXi0loXe0Ch3ECnI/2XO0dOpX4GekWPmILvi7K2YIc5
         WSBRLTwDDEfvs6MS3jTDahW1pbyou579dy5hnebBDa3d3UjzJFDaN/B8siueCw/4XE
         QsJdt6JXUygz2hOVa2KTg36qXB6xe0rVBBFEv5SOG1gC6ytmtpz8Qc1TpbeEHgCeV8
         dsmYpsR5EFNVX0L5b/zjFYXxxa0i8Tj7RWTtKnoETI3qWR81ynBDRX60ZQJ2EMr+4j
         Jc5KgqPlhi3Kw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        song@kernel.org
Subject: [PATCH v4 bpf-next] cpumap: bulk skb using netif_receive_skb_list
Date:   Fri, 23 Apr 2021 11:27:27 +0200
Message-Id: <c729f83e5d7482d9329e0f165bdbe5adcefd1510.1619169700.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rely on netif_receive_skb_list routine to send skbs converted from
xdp_frames in cpu_map_kthread_run in order to improve i-cache usage.
The proposed patch has been tested running xdp_redirect_cpu bpf sample
available in the kernel tree that is used to redirect UDP frames from
ixgbe driver to a cpumap entry and then to the networking stack.
UDP frames are generated using pkt_gen. Packets are discarded by the
UDP layer.

$xdp_redirect_cpu  --cpu <cpu> --progname xdp_cpu_map0 --dev <eth>

bpf-next: ~2.35Mpps
bpf-next + cpumap skb-list: ~2.72Mpps

Rename drops counter in kmem_alloc_drops since now it reports just
kmem_cache_alloc_bulk failures

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v3:
- drop tracepoint layout/xdp samples changes and rename drops
  variable in kmem_alloc_drops

Changes since v2:
- remove drop counter and update related xdp samples
- rebased on top of bpf-next

Changes since v1:
- fixed comment
- rebased on top of bpf-next tree
---
 kernel/bpf/cpumap.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 0cf2791d5099..5dd3e866599a 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -27,7 +27,7 @@
 #include <linux/capability.h>
 #include <trace/events/xdp.h>
 
-#include <linux/netdevice.h>   /* netif_receive_skb_core */
+#include <linux/netdevice.h>   /* netif_receive_skb_list */
 #include <linux/etherdevice.h> /* eth_type_trans */
 
 /* General idea: XDP packets getting XDP redirected to another CPU,
@@ -252,11 +252,12 @@ static int cpu_map_kthread_run(void *data)
 	 */
 	while (!kthread_should_stop() || !__ptr_ring_empty(rcpu->queue)) {
 		struct xdp_cpumap_stats stats = {}; /* zero stats */
+		unsigned int kmem_alloc_drops = 0, sched = 0;
 		gfp_t gfp = __GFP_ZERO | GFP_ATOMIC;
-		unsigned int drops = 0, sched = 0;
 		void *frames[CPUMAP_BATCH];
 		void *skbs[CPUMAP_BATCH];
 		int i, n, m, nframes;
+		LIST_HEAD(list);
 
 		/* Release CPU reschedule checks */
 		if (__ptr_ring_empty(rcpu->queue)) {
@@ -297,7 +298,7 @@ static int cpu_map_kthread_run(void *data)
 			if (unlikely(m == 0)) {
 				for (i = 0; i < nframes; i++)
 					skbs[i] = NULL; /* effect: xdp_return_frame */
-				drops += nframes;
+				kmem_alloc_drops += nframes;
 			}
 		}
 
@@ -305,7 +306,6 @@ static int cpu_map_kthread_run(void *data)
 		for (i = 0; i < nframes; i++) {
 			struct xdp_frame *xdpf = frames[i];
 			struct sk_buff *skb = skbs[i];
-			int ret;
 
 			skb = __xdp_build_skb_from_frame(xdpf, skb,
 							 xdpf->dev_rx);
@@ -314,13 +314,13 @@ static int cpu_map_kthread_run(void *data)
 				continue;
 			}
 
-			/* Inject into network stack */
-			ret = netif_receive_skb_core(skb);
-			if (ret == NET_RX_DROP)
-				drops++;
+			list_add_tail(&skb->list, &list);
 		}
+		netif_receive_skb_list(&list);
+
 		/* Feedback loop via tracepoint */
-		trace_xdp_cpumap_kthread(rcpu->map_id, n, drops, sched, &stats);
+		trace_xdp_cpumap_kthread(rcpu->map_id, n, kmem_alloc_drops,
+					 sched, &stats);
 
 		local_bh_enable(); /* resched point, may call do_softirq() */
 	}
-- 
2.30.2

