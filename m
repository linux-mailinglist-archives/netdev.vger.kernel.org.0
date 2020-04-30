Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAE31BFBEC
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbgD3OCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:02:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727911AbgD3Nxm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 09:53:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 506FC2063A;
        Thu, 30 Apr 2020 13:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254821;
        bh=1Oh3xPMOfPQqPMxE+LU10jFahdIXB/IA9MARC8qt+cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YjW07hAshZhENSnfI+Atm1VH7KTmuvEGlYYfJbHWM2X+WtUITEYsu5G4+fLBwqd0D
         16mTYJ1ZmZlNVffhGuYGyaLhAZXTsOjJcP4621syk7/X20zj0koy2fIHuYSiB/L8I/
         eN6eZpGHABijQpMPLhuwLZrZLx892PH/rh0HRNWs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/30] svcrdma: Fix trace point use-after-free race
Date:   Thu, 30 Apr 2020 09:53:08 -0400
Message-Id: <20200430135325.20762-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135325.20762-1-sashal@kernel.org>
References: <20200430135325.20762-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit e28b4fc652c1830796a4d3e09565f30c20f9a2cf ]

I hit this while testing nfsd-5.7 with kernel memory debugging
enabled on my server:

Mar 30 13:21:45 klimt kernel: BUG: unable to handle page fault for address: ffff8887e6c279a8
Mar 30 13:21:45 klimt kernel: #PF: supervisor read access in kernel mode
Mar 30 13:21:45 klimt kernel: #PF: error_code(0x0000) - not-present page
Mar 30 13:21:45 klimt kernel: PGD 3601067 P4D 3601067 PUD 87c519067 PMD 87c3e2067 PTE 800ffff8193d8060
Mar 30 13:21:45 klimt kernel: Oops: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
Mar 30 13:21:45 klimt kernel: CPU: 2 PID: 1933 Comm: nfsd Not tainted 5.6.0-rc6-00040-g881e87a3c6f9 #1591
Mar 30 13:21:45 klimt kernel: Hardware name: Supermicro Super Server/X10SRL-F, BIOS 1.0c 09/09/2015
Mar 30 13:21:45 klimt kernel: RIP: 0010:svc_rdma_post_chunk_ctxt+0xab/0x284 [rpcrdma]
Mar 30 13:21:45 klimt kernel: Code: c1 83 34 02 00 00 29 d0 85 c0 7e 72 48 8b bb a0 02 00 00 48 8d 54 24 08 4c 89 e6 48 8b 07 48 8b 40 20 e8 5a 5c 2b e1 41 89 c6 <8b> 45 20 89 44 24 04 8b 05 02 e9 01 00 85 c0 7e 33 e9 5e 01 00 00
Mar 30 13:21:45 klimt kernel: RSP: 0018:ffffc90000dfbdd8 EFLAGS: 00010286
Mar 30 13:21:45 klimt kernel: RAX: 0000000000000000 RBX: ffff8887db8db400 RCX: 0000000000000030
Mar 30 13:21:45 klimt kernel: RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000246
Mar 30 13:21:45 klimt kernel: RBP: ffff8887e6c27988 R08: 0000000000000000 R09: 0000000000000004
Mar 30 13:21:45 klimt kernel: R10: ffffc90000dfbdd8 R11: 00c068ef00000000 R12: ffff8887eb4e4a80
Mar 30 13:21:45 klimt kernel: R13: ffff8887db8db634 R14: 0000000000000000 R15: ffff8887fc931000
Mar 30 13:21:45 klimt kernel: FS:  0000000000000000(0000) GS:ffff88885bd00000(0000) knlGS:0000000000000000
Mar 30 13:21:45 klimt kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Mar 30 13:21:45 klimt kernel: CR2: ffff8887e6c279a8 CR3: 000000081b72e002 CR4: 00000000001606e0
Mar 30 13:21:45 klimt kernel: Call Trace:
Mar 30 13:21:45 klimt kernel: ? svc_rdma_vec_to_sg+0x7f/0x7f [rpcrdma]
Mar 30 13:21:45 klimt kernel: svc_rdma_send_write_chunk+0x59/0xce [rpcrdma]
Mar 30 13:21:45 klimt kernel: svc_rdma_sendto+0xf9/0x3ae [rpcrdma]
Mar 30 13:21:45 klimt kernel: ? nfsd_destroy+0x51/0x51 [nfsd]
Mar 30 13:21:45 klimt kernel: svc_send+0x105/0x1e3 [sunrpc]
Mar 30 13:21:45 klimt kernel: nfsd+0xf2/0x149 [nfsd]
Mar 30 13:21:45 klimt kernel: kthread+0xf6/0xfb
Mar 30 13:21:45 klimt kernel: ? kthread_queue_delayed_work+0x74/0x74
Mar 30 13:21:45 klimt kernel: ret_from_fork+0x3a/0x50
Mar 30 13:21:45 klimt kernel: Modules linked in: ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue ib_umad ib_ipoib mlx4_ib sb_edac x86_pkg_temp_thermal iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel glue_helper crypto_simd cryptd pcspkr rpcrdma i2c_i801 rdma_ucm lpc_ich mfd_core ib_iser rdma_cm iw_cm ib_cm mei_me raid0 libiscsi mei sg scsi_transport_iscsi ioatdma wmi ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter nfsd nfs_acl lockd auth_rpcgss grace sunrpc ip_tables xfs libcrc32c mlx4_en sd_mod sr_mod cdrom mlx4_core crc32c_intel igb nvme i2c_algo_bit ahci i2c_core libahci nvme_core dca libata t10_pi qedr dm_mirror dm_region_hash dm_log dm_mod dax qede qed crc8 ib_uverbs ib_core
Mar 30 13:21:45 klimt kernel: CR2: ffff8887e6c279a8
Mar 30 13:21:45 klimt kernel: ---[ end trace 87971d2ad3429424 ]---

It's absolutely not safe to use resources pointed to by the @send_wr
argument of ib_post_send() _after_ that function returns. Those
resources are typically freed by the Send completion handler, which
can run before ib_post_send() returns.

Thus the trace points currently around ib_post_send() in the
server's RPC/RDMA transport are a hazard, even when they are
disabled. Rearrange them so that they touch the Work Request only
_before_ ib_post_send() is invoked.

Fixes: bd2abef33394 ("svcrdma: Trace key RDMA API events")
Fixes: 4201c7464753 ("svcrdma: Introduce svc_rdma_send_ctxt")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rpcrdma.h        | 50 +++++++++++++++++++--------
 net/sunrpc/xprtrdma/svc_rdma_rw.c     |  3 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c | 16 +++++----
 3 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/include/trace/events/rpcrdma.h b/include/trace/events/rpcrdma.h
index 4c91cadd1871d..4a0b18921e06a 100644
--- a/include/trace/events/rpcrdma.h
+++ b/include/trace/events/rpcrdma.h
@@ -1322,17 +1322,15 @@ DECLARE_EVENT_CLASS(svcrdma_sendcomp_event,
 
 TRACE_EVENT(svcrdma_post_send,
 	TP_PROTO(
-		const struct ib_send_wr *wr,
-		int status
+		const struct ib_send_wr *wr
 	),
 
-	TP_ARGS(wr, status),
+	TP_ARGS(wr),
 
 	TP_STRUCT__entry(
 		__field(const void *, cqe)
 		__field(unsigned int, num_sge)
 		__field(u32, inv_rkey)
-		__field(int, status)
 	),
 
 	TP_fast_assign(
@@ -1340,12 +1338,11 @@ TRACE_EVENT(svcrdma_post_send,
 		__entry->num_sge = wr->num_sge;
 		__entry->inv_rkey = (wr->opcode == IB_WR_SEND_WITH_INV) ?
 					wr->ex.invalidate_rkey : 0;
-		__entry->status = status;
 	),
 
-	TP_printk("cqe=%p num_sge=%u inv_rkey=0x%08x status=%d",
+	TP_printk("cqe=%p num_sge=%u inv_rkey=0x%08x",
 		__entry->cqe, __entry->num_sge,
-		__entry->inv_rkey, __entry->status
+		__entry->inv_rkey
 	)
 );
 
@@ -1410,26 +1407,23 @@ TRACE_EVENT(svcrdma_wc_receive,
 TRACE_EVENT(svcrdma_post_rw,
 	TP_PROTO(
 		const void *cqe,
-		int sqecount,
-		int status
+		int sqecount
 	),
 
-	TP_ARGS(cqe, sqecount, status),
+	TP_ARGS(cqe, sqecount),
 
 	TP_STRUCT__entry(
 		__field(const void *, cqe)
 		__field(int, sqecount)
-		__field(int, status)
 	),
 
 	TP_fast_assign(
 		__entry->cqe = cqe;
 		__entry->sqecount = sqecount;
-		__entry->status = status;
 	),
 
-	TP_printk("cqe=%p sqecount=%d status=%d",
-		__entry->cqe, __entry->sqecount, __entry->status
+	TP_printk("cqe=%p sqecount=%d",
+		__entry->cqe, __entry->sqecount
 	)
 );
 
@@ -1525,6 +1519,34 @@ DECLARE_EVENT_CLASS(svcrdma_sendqueue_event,
 DEFINE_SQ_EVENT(full);
 DEFINE_SQ_EVENT(retry);
 
+TRACE_EVENT(svcrdma_sq_post_err,
+	TP_PROTO(
+		const struct svcxprt_rdma *rdma,
+		int status
+	),
+
+	TP_ARGS(rdma, status),
+
+	TP_STRUCT__entry(
+		__field(int, avail)
+		__field(int, depth)
+		__field(int, status)
+		__string(addr, rdma->sc_xprt.xpt_remotebuf)
+	),
+
+	TP_fast_assign(
+		__entry->avail = atomic_read(&rdma->sc_sq_avail);
+		__entry->depth = rdma->sc_sq_depth;
+		__entry->status = status;
+		__assign_str(addr, rdma->sc_xprt.xpt_remotebuf);
+	),
+
+	TP_printk("addr=%s sc_sq_avail=%d/%d status=%d",
+		__get_str(addr), __entry->avail, __entry->depth,
+		__entry->status
+	)
+);
+
 #endif /* _TRACE_RPCRDMA_H */
 
 #include <trace/define_trace.h>
diff --git a/net/sunrpc/xprtrdma/svc_rdma_rw.c b/net/sunrpc/xprtrdma/svc_rdma_rw.c
index dc1951759a8ef..4fc0ce1270894 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -331,8 +331,6 @@ static int svc_rdma_post_chunk_ctxt(struct svc_rdma_chunk_ctxt *cc)
 		if (atomic_sub_return(cc->cc_sqecount,
 				      &rdma->sc_sq_avail) > 0) {
 			ret = ib_post_send(rdma->sc_qp, first_wr, &bad_wr);
-			trace_svcrdma_post_rw(&cc->cc_cqe,
-					      cc->cc_sqecount, ret);
 			if (ret)
 				break;
 			return 0;
@@ -345,6 +343,7 @@ static int svc_rdma_post_chunk_ctxt(struct svc_rdma_chunk_ctxt *cc)
 		trace_svcrdma_sq_retry(rdma);
 	} while (1);
 
+	trace_svcrdma_sq_post_err(rdma, ret);
 	set_bit(XPT_CLOSE, &xprt->xpt_flags);
 
 	/* If even one was posted, there will be a completion. */
diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index e8ad7ddf347ad..840bd352ef6ec 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -310,15 +310,17 @@ int svc_rdma_send(struct svcxprt_rdma *rdma, struct ib_send_wr *wr)
 		}
 
 		svc_xprt_get(&rdma->sc_xprt);
+		trace_svcrdma_post_send(wr);
 		ret = ib_post_send(rdma->sc_qp, wr, NULL);
-		trace_svcrdma_post_send(wr, ret);
-		if (ret) {
-			set_bit(XPT_CLOSE, &rdma->sc_xprt.xpt_flags);
-			svc_xprt_put(&rdma->sc_xprt);
-			wake_up(&rdma->sc_send_wait);
-		}
-		break;
+		if (ret)
+			break;
+		return 0;
 	}
+
+	trace_svcrdma_sq_post_err(rdma, ret);
+	set_bit(XPT_CLOSE, &rdma->sc_xprt.xpt_flags);
+	svc_xprt_put(&rdma->sc_xprt);
+	wake_up(&rdma->sc_send_wait);
 	return ret;
 }
 
-- 
2.20.1

