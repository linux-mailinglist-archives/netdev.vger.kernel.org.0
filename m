Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E062048D
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 13:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfEPLVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 07:21:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:34038 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726383AbfEPLVu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 07:21:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6D8EAAEC6;
        Thu, 16 May 2019 11:21:48 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
Cc:     Michal Rostecki <mrostecki@opensuse.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Jiong Wang <jiong.wang@netronome.com>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, xdp-newbies@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next 2/2] samples: bpf: Do not define bpf_printk macro
Date:   Thu, 16 May 2019 13:20:58 +0200
Message-Id: <20190516112105.12887-3-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190516112105.12887-1-mrostecki@opensuse.org>
References: <20190516112105.12887-1-mrostecki@opensuse.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_printk macro was moved to bpf_helpers.h which is included in all
example programs.

Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
---
 samples/bpf/hbm_kern.h             | 12 +++---------
 samples/bpf/hbm_out_kern.c         |  2 ++
 samples/bpf/tcp_basertt_kern.c     |  7 -------
 samples/bpf/tcp_bufs_kern.c        |  7 -------
 samples/bpf/tcp_clamp_kern.c       |  7 -------
 samples/bpf/tcp_cong_kern.c        |  7 -------
 samples/bpf/tcp_iw_kern.c          |  7 -------
 samples/bpf/tcp_rwnd_kern.c        |  7 -------
 samples/bpf/tcp_synrto_kern.c      |  7 -------
 samples/bpf/tcp_tos_reflect_kern.c |  7 -------
 samples/bpf/xdp_sample_pkts_kern.c |  7 -------
 11 files changed, 5 insertions(+), 72 deletions(-)

diff --git a/samples/bpf/hbm_kern.h b/samples/bpf/hbm_kern.h
index c5635d924193..0ac6823abbb7 100644
--- a/samples/bpf/hbm_kern.h
+++ b/samples/bpf/hbm_kern.h
@@ -30,16 +30,8 @@
 #define ALLOW_PKT	1
 #define TCP_ECN_OK	1
 
+#ifndef HBM_DEBUG
 #define HBM_DEBUG 0  // Set to 1 to enable debugging
-#if HBM_DEBUG
-#define bpf_printk(fmt, ...)					\
-({								\
-	char ____fmt[] = fmt;					\
-	bpf_trace_printk(____fmt, sizeof(____fmt),		\
-			 ##__VA_ARGS__);			\
-})
-#else
-#define bpf_printk(fmt, ...)
 #endif
 
 #define INITIAL_CREDIT_PACKETS	100
@@ -102,7 +94,9 @@ static __always_inline void hbm_get_pkt_info(struct __sk_buff *skb,
 
 static __always_inline void hbm_init_vqueue(struct hbm_vqueue *qdp, int rate)
 {
+#if HBM_DEBUG
 		bpf_printk("Initializing queue_state, rate:%d\n", rate * 128);
+#endif
 		qdp->lasttime = bpf_ktime_get_ns();
 		qdp->credit = INIT_CREDIT;
 		qdp->rate = rate * 128;
diff --git a/samples/bpf/hbm_out_kern.c b/samples/bpf/hbm_out_kern.c
index f806863d0b79..4374583b4242 100644
--- a/samples/bpf/hbm_out_kern.c
+++ b/samples/bpf/hbm_out_kern.c
@@ -111,9 +111,11 @@ int _hbm_out_cg(struct __sk_buff *skb)
 	// Check if we should update rate
 	if (qsp != NULL && (qsp->rate * 128) != qdp->rate) {
 		qdp->rate = qsp->rate * 128;
+#if HBM_DEBUG
 		bpf_printk("Updating rate: %d (1sec:%llu bits)\n",
 			   (int)qdp->rate,
 			   CREDIT_PER_NS(1000000000, qdp->rate) * 8);
+#endif
 	}
 
 	// Set flags (drop, congestion, cwr)
diff --git a/samples/bpf/tcp_basertt_kern.c b/samples/bpf/tcp_basertt_kern.c
index 6ef1625e8b2c..9dba48c2b920 100644
--- a/samples/bpf/tcp_basertt_kern.c
+++ b/samples/bpf/tcp_basertt_kern.c
@@ -21,13 +21,6 @@
 
 #define DEBUG 1
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 SEC("sockops")
 int bpf_basertt(struct bpf_sock_ops *skops)
 {
diff --git a/samples/bpf/tcp_bufs_kern.c b/samples/bpf/tcp_bufs_kern.c
index e03e204739fa..af8486f33771 100644
--- a/samples/bpf/tcp_bufs_kern.c
+++ b/samples/bpf/tcp_bufs_kern.c
@@ -22,13 +22,6 @@
 
 #define DEBUG 1
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 SEC("sockops")
 int bpf_bufs(struct bpf_sock_ops *skops)
 {
diff --git a/samples/bpf/tcp_clamp_kern.c b/samples/bpf/tcp_clamp_kern.c
index a0dc2d254aca..26c0fd091f3c 100644
--- a/samples/bpf/tcp_clamp_kern.c
+++ b/samples/bpf/tcp_clamp_kern.c
@@ -22,13 +22,6 @@
 
 #define DEBUG 1
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 SEC("sockops")
 int bpf_clamp(struct bpf_sock_ops *skops)
 {
diff --git a/samples/bpf/tcp_cong_kern.c b/samples/bpf/tcp_cong_kern.c
index 4fd3ca979a06..6d4dc4c7dd1e 100644
--- a/samples/bpf/tcp_cong_kern.c
+++ b/samples/bpf/tcp_cong_kern.c
@@ -21,13 +21,6 @@
 
 #define DEBUG 1
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 SEC("sockops")
 int bpf_cong(struct bpf_sock_ops *skops)
 {
diff --git a/samples/bpf/tcp_iw_kern.c b/samples/bpf/tcp_iw_kern.c
index 9b139ec69560..da61d53378b3 100644
--- a/samples/bpf/tcp_iw_kern.c
+++ b/samples/bpf/tcp_iw_kern.c
@@ -22,13 +22,6 @@
 
 #define DEBUG 1
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 SEC("sockops")
 int bpf_iw(struct bpf_sock_ops *skops)
 {
diff --git a/samples/bpf/tcp_rwnd_kern.c b/samples/bpf/tcp_rwnd_kern.c
index cc71ee96e044..d011e38b80d2 100644
--- a/samples/bpf/tcp_rwnd_kern.c
+++ b/samples/bpf/tcp_rwnd_kern.c
@@ -21,13 +21,6 @@
 
 #define DEBUG 1
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 SEC("sockops")
 int bpf_rwnd(struct bpf_sock_ops *skops)
 {
diff --git a/samples/bpf/tcp_synrto_kern.c b/samples/bpf/tcp_synrto_kern.c
index ca87ed34f896..720d1950322d 100644
--- a/samples/bpf/tcp_synrto_kern.c
+++ b/samples/bpf/tcp_synrto_kern.c
@@ -21,13 +21,6 @@
 
 #define DEBUG 1
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 SEC("sockops")
 int bpf_synrto(struct bpf_sock_ops *skops)
 {
diff --git a/samples/bpf/tcp_tos_reflect_kern.c b/samples/bpf/tcp_tos_reflect_kern.c
index de788be6f862..369faca70a15 100644
--- a/samples/bpf/tcp_tos_reflect_kern.c
+++ b/samples/bpf/tcp_tos_reflect_kern.c
@@ -20,13 +20,6 @@
 
 #define DEBUG 1
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 SEC("sockops")
 int bpf_basertt(struct bpf_sock_ops *skops)
 {
diff --git a/samples/bpf/xdp_sample_pkts_kern.c b/samples/bpf/xdp_sample_pkts_kern.c
index f7ca8b850978..6c7c7e0aaeda 100644
--- a/samples/bpf/xdp_sample_pkts_kern.c
+++ b/samples/bpf/xdp_sample_pkts_kern.c
@@ -7,13 +7,6 @@
 #define SAMPLE_SIZE 64ul
 #define MAX_CPUS 128
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 struct bpf_map_def SEC("maps") my_map = {
 	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
 	.key_size = sizeof(int),
-- 
2.21.0

