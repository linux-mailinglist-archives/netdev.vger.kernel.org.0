Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7492135114D
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 10:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbhDAI41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 04:56:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233610AbhDAI4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 04:56:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AF6961055;
        Thu,  1 Apr 2021 08:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617267378;
        bh=dLK+gkD9yjbg+ylZLufKb81JzFoxbR6dl3EUaz7fH6w=;
        h=From:To:Cc:Subject:Date:From;
        b=oxm4a/XWSILSo/QFShVPP5HFjPFMPupkuOjg93k9WECwo5GGil08DkMWYDhk7OsTJ
         p7hH8Xr5eLvvp3sykgqErJeplkDnmOUI9rFu5rTlGJQLM7CqomjSyXeonZNpJUaK/x
         HTxBE6grdL8ZOu0jNSL9q0zQdu7IV3WQTjHMCmHVN1dxdWOOzOOdwSg9U4aZFNrHYr
         RHMi2TWxbU8etQF7MkKQFaox+RXwq/dWupZq0lMcuvJDSOb6hwLDycQM75HVIwvzUO
         6u/EL8uRAxK4q23wIXUrRETK5OIJSpwHsl7QpQdNtdr+DUT6mryTmd/PLHBSK05ezA
         ryaZVkc1YzyMA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com
Subject: [PATCH bpf-next] cpumap: bulk skb using netif_receive_skb_list
Date:   Thu,  1 Apr 2021 10:56:08 +0200
Message-Id: <e01b1a562c523f64049fa45da6c031b0749ca412.1617267115.git.lorenzo@kernel.org>
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
 kernel/bpf/cpumap.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 0cf2791d5099..b33114ce2e2b 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
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

