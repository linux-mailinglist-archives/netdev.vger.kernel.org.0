Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013B635E3B8
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 18:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243927AbhDMQWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 12:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241597AbhDMQWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 12:22:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5DAA61004;
        Tue, 13 Apr 2021 16:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618330931;
        bh=rAXwyBauwU2YoFfTfHi6sbsmdGePSz+G8Q09owNXChw=;
        h=From:To:Cc:Subject:Date:From;
        b=SiRDgprUW14so9XgIDAqC04bsBcBvc7K06giyfcsLGnVn6mNXo5eHRhomTSihmjZy
         3Adlp7RRq92xSLUrjlhF47Qe1VmUidKNpN4Cfl73agNobHuuaqjl6ijL5mqD+8aaP7
         t+dq0Vo4dZRZvmiEm60ONdBQU0PGnyOi9eG5I8SNVeMFJJTIWQCo6X1BX8IGKggTAx
         YsvfAXjtypYdKNQ8utvUNSxzImC9S9ne8lbwxvblrCDFtnhxUwlAaSbR7BmM11kbMp
         JhKtpszh1DDfP0D4YOb32IGlCn7e+xM4LR5SbcKxuXyuk1l6o3UmXDK5rPask8XfZG
         K6YezKNs9j9ig==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, song@kernel.org
Subject: [PATCH v2 bpf-next] cpumap: bulk skb using netif_receive_skb_list
Date:   Tue, 13 Apr 2021 18:22:02 +0200
Message-Id: <bb627106428ea3223610f5623142c24270f0e14e.1618330734.git.lorenzo@kernel.org>
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
UDP frames are generated using pkt_gen.

$xdp_redirect_cpu  --cpu <cpu> --progname xdp_cpu_map0 --dev <eth>

bpf-next: ~2.2Mpps
bpf-next + cpumap skb-list: ~3.15Mpps

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- fixed comment
- rebased on top of bpf-next tree
---
 kernel/bpf/cpumap.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 0cf2791d5099..d89551a508b2 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -27,7 +27,7 @@
 #include <linux/capability.h>
 #include <trace/events/xdp.h>
 
-#include <linux/netdevice.h>   /* netif_receive_skb_core */
+#include <linux/netdevice.h>   /* netif_receive_skb_list */
 #include <linux/etherdevice.h> /* eth_type_trans */
 
 /* General idea: XDP packets getting XDP redirected to another CPU,
@@ -257,6 +257,7 @@ static int cpu_map_kthread_run(void *data)
 		void *frames[CPUMAP_BATCH];
 		void *skbs[CPUMAP_BATCH];
 		int i, n, m, nframes;
+		LIST_HEAD(list);
 
 		/* Release CPU reschedule checks */
 		if (__ptr_ring_empty(rcpu->queue)) {
@@ -305,7 +306,6 @@ static int cpu_map_kthread_run(void *data)
 		for (i = 0; i < nframes; i++) {
 			struct xdp_frame *xdpf = frames[i];
 			struct sk_buff *skb = skbs[i];
-			int ret;
 
 			skb = __xdp_build_skb_from_frame(xdpf, skb,
 							 xdpf->dev_rx);
@@ -314,11 +314,10 @@ static int cpu_map_kthread_run(void *data)
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
 		trace_xdp_cpumap_kthread(rcpu->map_id, n, drops, sched, &stats);
 
-- 
2.30.2

