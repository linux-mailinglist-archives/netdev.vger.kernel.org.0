Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315A6214BB5
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 11:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgGEJyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 05:54:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgGEJyd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 05:54:33 -0400
Received: from localhost.localdomain (unknown [151.48.133.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19FCA2088E;
        Sun,  5 Jul 2020 09:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593942873;
        bh=pPzdrW4uiAX5nmzw/wjLwKOzSTb9k6+7m87+MPQvAko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OtqhQ8AEWyu1XcvR6I/xSGIZyPqF3rqif6DnryIpZDIGyjCo7NuuN4Q/FJE2jK9oT
         mfRTj5wHQB7x1be5burb26DnatgvPoSWDcYp9j4iDKWL15UgbFTASPRhPm4gztxtkP
         zB80C0iXEmCbJqFrVXd4wRhYxOKfWtXBSJyswUZw=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, toke@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org, andrii.nakryiko@gmail.com
Subject: [PATCH v6 bpf-next 6/9] bpf: cpumap: implement XDP_REDIRECT for eBPF programs attached to map entries
Date:   Sun,  5 Jul 2020 11:53:57 +0200
Message-Id: <78075646e34265f8c5d474918534c7db080f3ff1.1593941896.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1593941895.git.lorenzo@kernel.org>
References: <cover.1593941895.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce XDP_REDIRECT support for eBPF programs attached to cpumap
entries.
This patch has been tested on Marvell ESPRESSObin using a modified
version of xdp_redirect_cpu sample in order to attach a XDP program
to CPUMAP entries to perform a redirect on the mvneta interface.
In particular the following scenario has been tested:

rq (cpu0) --> mvneta - XDP_REDIRECT (cpu0) --> CPUMAP - XDP_REDIRECT (cpu1) --> mvneta

$./xdp_redirect_cpu -p xdp_cpu_map0 -d eth0 -c 1 -e xdp_redirect \
	-f xdp_redirect_kern.o -m tx_port -r eth0

tx: 285.2 Kpps rx: 285.2 Kpps

Attaching a simple XDP program on eth0 to perform XDP_TX gives
comparable results:

tx: 288.4 Kpps rx: 288.4 Kpps

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h          |  1 +
 include/trace/events/xdp.h |  6 ++++--
 kernel/bpf/cpumap.c        | 17 +++++++++++++++--
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 83b9e0142b52..5be0d4d65b94 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -99,6 +99,7 @@ struct xdp_frame {
 };
 
 struct xdp_cpumap_stats {
+	unsigned int redirect;
 	unsigned int pass;
 	unsigned int drop;
 };
diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index e2c99f5bee39..cd24e8a59529 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -190,6 +190,7 @@ TRACE_EVENT(xdp_cpumap_kthread,
 		__field(int, sched)
 		__field(unsigned int, xdp_pass)
 		__field(unsigned int, xdp_drop)
+		__field(unsigned int, xdp_redirect)
 	),
 
 	TP_fast_assign(
@@ -201,18 +202,19 @@ TRACE_EVENT(xdp_cpumap_kthread,
 		__entry->sched	= sched;
 		__entry->xdp_pass	= xdp_stats->pass;
 		__entry->xdp_drop	= xdp_stats->drop;
+		__entry->xdp_redirect	= xdp_stats->redirect;
 	),
 
 	TP_printk("kthread"
 		  " cpu=%d map_id=%d action=%s"
 		  " processed=%u drops=%u"
 		  " sched=%d"
-		  " xdp_pass=%u xdp_drop=%u",
+		  " xdp_pass=%u xdp_drop=%u xdp_redirect=%u",
 		  __entry->cpu, __entry->map_id,
 		  __print_symbolic(__entry->act, __XDP_ACT_SYM_TAB),
 		  __entry->processed, __entry->drops,
 		  __entry->sched,
-		  __entry->xdp_pass, __entry->xdp_drop)
+		  __entry->xdp_pass, __entry->xdp_drop, __entry->xdp_redirect)
 );
 
 TRACE_EVENT(xdp_cpumap_enqueue,
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index bafc49d68c89..a82a2335d249 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -238,7 +238,7 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
 	if (!rcpu->prog)
 		return n;
 
-	rcu_read_lock();
+	rcu_read_lock_bh();
 
 	xdp_set_return_frame_no_direct();
 	xdp.rxq = &rxq;
@@ -266,6 +266,16 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
 				stats->pass++;
 			}
 			break;
+		case XDP_REDIRECT:
+			err = xdp_do_redirect(xdpf->dev_rx, &xdp,
+					      rcpu->prog);
+			if (unlikely(err)) {
+				xdp_return_frame(xdpf);
+				stats->drop++;
+			} else {
+				stats->redirect++;
+			}
+			break;
 		default:
 			bpf_warn_invalid_xdp_action(act);
 			/* fallthrough */
@@ -276,9 +286,12 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
 		}
 	}
 
+	if (stats->redirect)
+		xdp_do_flush_map();
+
 	xdp_clear_return_frame_no_direct();
 
-	rcu_read_unlock();
+	rcu_read_unlock_bh(); /* resched point, may call do_softirq() */
 
 	return nframes;
 }
-- 
2.26.2

