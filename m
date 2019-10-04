Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03F69CC669
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 01:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731345AbfJDXTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 19:19:46 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36521 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDXTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 19:19:45 -0400
Received: by mail-qk1-f193.google.com with SMTP id y189so7407615qkc.3
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 16:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gcp4XuNJfB3xqTC6u+c8esqIXeYIJ8b3NGcR584ASdY=;
        b=IgRM7c2oJYZLWjlkVhhUbB+o8xXFMSatAe45rrGDEm0Emyu+SYyCFsilxOFoGpdfv2
         7XZbEKIuOTUveGYCHoF2nWmjoHPvurdN/mB8GEUGn5WCPeU+kVLA6o+mrCylukjpivRs
         gdBRejXxnGlZ5MKYnxBhH3PQAhdRwgo4EkgqE0n8+eHJjQVxvZgTn+e8T07kaJO7wc8f
         wbLm8mNviozAnzN2CkJOw0hpF4dCLu2wt0ZDcpb7G9jvo5IrXMsjV0hZCwBVY6zcZfrE
         IckW837jwWYR35Tbq6+6L6JKsHBR6UChL8YlPWNq/p2euMqMf72EV3kPIeCN2JtWiKyo
         TK9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gcp4XuNJfB3xqTC6u+c8esqIXeYIJ8b3NGcR584ASdY=;
        b=WFPFJbUPZPlqtwXlSyooboCiwb3BunIZ/FpcI3N3mlWYzL3L4SJbX+Cg4x01LbrjMX
         Y4LOXj0BMCBi3NJC6jKqsDT3RfsEhWITS666sFlywedSWkiMdVgVktZNJ5CkV94t8nMk
         OcEYtv9uIN9XX6cZTna0PieEXDRBCmQ5VRlSNJ05yQDd6TCsEYIj/mpJenxDqjk/K1/S
         fJWiukvFYZIY2U6tDtaZNFPyoEHK/td35tgeZTPhiOgAI2oMEeYF61IUFDJpyjrC3hLM
         ph9DUrqPYf7vQESFxnS4f8QyCLTsp+AgcWWlVEU2kYCfMdWQN070BVADwJejc+BLb1FK
         f0Qg==
X-Gm-Message-State: APjAAAULl/a6rx1UdSj2At01gj7HEqqP6kOjHG5pVFHkcRCCtTeaN4pA
        7OD12oyCCJP8Xon4soanxBaitw==
X-Google-Smtp-Source: APXvYqzMIbUNKFyq9f2T/89Hw6cakt2O1Q7FABEsSKoFA7Gvr29boRWUld6cJIhZ6we44syYR0NaCQ==
X-Received: by 2002:a37:b41:: with SMTP id 62mr12750497qkl.451.1570231184329;
        Fri, 04 Oct 2019 16:19:44 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z46sm4653398qth.62.2019.10.04.16.19.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 16:19:43 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, davejwatson@fb.com, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 1/6] net/tls: add tracing for device/offload events
Date:   Fri,  4 Oct 2019 16:19:22 -0700
Message-Id: <20191004231927.21134-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191004231927.21134-1-jakub.kicinski@netronome.com>
References: <20191004231927.21134-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tracing of device-related interaction to aid performance
analysis, especially around resync:

 tls:tls_device_offload_set
 tls:tls_device_rx_resync_send
 tls:tls_device_rx_resync_nh_schedule
 tls:tls_device_rx_resync_nh_delay
 tls:tls_device_tx_resync_req
 tls:tls_device_tx_resync_send

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../ethernet/netronome/nfp/nfp_net_common.c   |   3 +-
 include/net/tls.h                             |   8 +-
 net/tls/Makefile                              |   4 +-
 net/tls/tls_device.c                          |  30 +++-
 net/tls/trace.c                               |  10 ++
 net/tls/trace.h                               | 169 ++++++++++++++++++
 6 files changed, 213 insertions(+), 11 deletions(-)
 create mode 100644 net/tls/trace.c
 create mode 100644 net/tls/trace.h

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 61aabffc8888..bcdcd6de7dea 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -872,7 +872,8 @@ nfp_net_tls_tx(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 
 		/* jump forward, a TX may have gotten lost, need to sync TX */
 		if (!resync_pending && seq - ntls->next_seq < U32_MAX / 4)
-			tls_offload_tx_resync_request(nskb->sk);
+			tls_offload_tx_resync_request(nskb->sk, seq,
+						      ntls->next_seq);
 
 		*nr_frags = 0;
 		return nskb;
diff --git a/include/net/tls.h b/include/net/tls.h
index 5c48cb9e0c18..38086ade65ce 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -594,13 +594,6 @@ tls_offload_rx_resync_set_type(struct sock *sk, enum tls_offload_sync_type type)
 	tls_offload_ctx_rx(tls_ctx)->resync_type = type;
 }
 
-static inline void tls_offload_tx_resync_request(struct sock *sk)
-{
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
-
-	WARN_ON(test_and_set_bit(TLS_TX_SYNC_SCHED, &tls_ctx->flags));
-}
-
 /* Driver's seq tracking has to be disabled until resync succeeded */
 static inline bool tls_offload_tx_resync_pending(struct sock *sk)
 {
@@ -634,6 +627,7 @@ void tls_device_free_resources_tx(struct sock *sk);
 int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx);
 void tls_device_offload_cleanup_rx(struct sock *sk);
 void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq);
+void tls_offload_tx_resync_request(struct sock *sk, u32 got_seq, u32 exp_seq);
 int tls_device_decrypted(struct sock *sk, struct sk_buff *skb);
 #else
 static inline void tls_device_init(void) {}
diff --git a/net/tls/Makefile b/net/tls/Makefile
index 95d8c06a14b9..0606d43d7582 100644
--- a/net/tls/Makefile
+++ b/net/tls/Makefile
@@ -3,9 +3,11 @@
 # Makefile for the TLS subsystem.
 #
 
+CFLAGS_trace.o := -I$(src)
+
 obj-$(CONFIG_TLS) += tls.o
 
-tls-y := tls_main.o tls_sw.o
+tls-y := tls_main.o tls_sw.o trace.o
 
 tls-$(CONFIG_TLS_TOE) += tls_toe.o
 tls-$(CONFIG_TLS_DEVICE) += tls_device.o tls_device_fallback.o
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index f959487c5cd1..9f423caf48e3 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -38,6 +38,8 @@
 #include <net/tcp.h>
 #include <net/tls.h>
 
+#include "trace.h"
+
 /* device_offload_lock is used to synchronize tls_dev_add
  * against NETDEV_DOWN notifications.
  */
@@ -202,6 +204,15 @@ void tls_device_free_resources_tx(struct sock *sk)
 	tls_free_partial_record(sk, tls_ctx);
 }
 
+void tls_offload_tx_resync_request(struct sock *sk, u32 got_seq, u32 exp_seq)
+{
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
+
+	trace_tls_device_tx_resync_req(sk, got_seq, exp_seq);
+	WARN_ON(test_and_set_bit(TLS_TX_SYNC_SCHED, &tls_ctx->flags));
+}
+EXPORT_SYMBOL_GPL(tls_offload_tx_resync_request);
+
 static void tls_device_resync_tx(struct sock *sk, struct tls_context *tls_ctx,
 				 u32 seq)
 {
@@ -216,6 +227,7 @@ static void tls_device_resync_tx(struct sock *sk, struct tls_context *tls_ctx,
 
 	rcd_sn = tls_ctx->tx.rec_seq;
 
+	trace_tls_device_tx_resync_send(sk, seq, rcd_sn);
 	down_read(&device_offload_lock);
 	netdev = tls_ctx->netdev;
 	if (netdev)
@@ -637,10 +649,13 @@ void tls_device_write_space(struct sock *sk, struct tls_context *ctx)
 static void tls_device_resync_rx(struct tls_context *tls_ctx,
 				 struct sock *sk, u32 seq, u8 *rcd_sn)
 {
+	struct tls_offload_context_rx *rx_ctx = tls_offload_ctx_rx(tls_ctx);
 	struct net_device *netdev;
 
 	if (WARN_ON(test_and_set_bit(TLS_RX_SYNC_RUNNING, &tls_ctx->flags)))
 		return;
+
+	trace_tls_device_rx_resync_send(sk, seq, rcd_sn, rx_ctx->resync_type);
 	netdev = READ_ONCE(tls_ctx->netdev);
 	if (netdev)
 		netdev->tlsdev_ops->tls_dev_resync(netdev, sk, seq, rcd_sn,
@@ -653,8 +668,8 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_offload_context_rx *rx_ctx;
 	u8 rcd_sn[TLS_MAX_REC_SEQ_SIZE];
+	u32 sock_data, is_req_pending;
 	struct tls_prot_info *prot;
-	u32 is_req_pending;
 	s64 resync_req;
 	u32 req_seq;
 
@@ -683,8 +698,12 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 		/* head of next rec is already in, note that the sock_inq will
 		 * include the currently parsed message when called from parser
 		 */
-		if (tcp_inq(sk) > rcd_len)
+		sock_data = tcp_inq(sk);
+		if (sock_data > rcd_len) {
+			trace_tls_device_rx_resync_nh_delay(sk, sock_data,
+							    rcd_len);
 			return;
+		}
 
 		rx_ctx->resync_nh_do_now = 0;
 		seq += rcd_len;
@@ -728,6 +747,7 @@ static void tls_device_core_ctrl_rx_resync(struct tls_context *tls_ctx,
 
 	/* head of next rec is already in, parser will sync for us */
 	if (tcp_inq(sk) > rxm->full_len) {
+		trace_tls_device_rx_resync_nh_schedule(sk);
 		ctx->resync_nh_do_now = 1;
 	} else {
 		struct tls_prot_info *prot = &tls_ctx->prot_info;
@@ -1013,6 +1033,8 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	rc = netdev->tlsdev_ops->tls_dev_add(netdev, sk, TLS_OFFLOAD_CTX_DIR_TX,
 					     &ctx->crypto_send.info,
 					     tcp_sk(sk)->write_seq);
+	trace_tls_device_offload_set(sk, TLS_OFFLOAD_CTX_DIR_TX,
+				     tcp_sk(sk)->write_seq, rec_seq, rc);
 	if (rc)
 		goto release_lock;
 
@@ -1049,6 +1071,7 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 
 int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
 {
+	struct tls12_crypto_info_aes_gcm_128 *info;
 	struct tls_offload_context_rx *context;
 	struct net_device *netdev;
 	int rc = 0;
@@ -1096,6 +1119,9 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
 	rc = netdev->tlsdev_ops->tls_dev_add(netdev, sk, TLS_OFFLOAD_CTX_DIR_RX,
 					     &ctx->crypto_recv.info,
 					     tcp_sk(sk)->copied_seq);
+	info = (void *)&ctx->crypto_recv.info;
+	trace_tls_device_offload_set(sk, TLS_OFFLOAD_CTX_DIR_RX,
+				     tcp_sk(sk)->copied_seq, info->rec_seq, rc);
 	if (rc)
 		goto free_sw_resources;
 
diff --git a/net/tls/trace.c b/net/tls/trace.c
new file mode 100644
index 000000000000..e374913cf9c9
--- /dev/null
+++ b/net/tls/trace.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2019 Netronome Systems, Inc. */
+
+#include <linux/module.h>
+
+#ifndef __CHECKER__
+#define CREATE_TRACE_POINTS
+#include "trace.h"
+
+#endif
diff --git a/net/tls/trace.h b/net/tls/trace.h
new file mode 100644
index 000000000000..95b6ded2f9b2
--- /dev/null
+++ b/net/tls/trace.h
@@ -0,0 +1,169 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
+/* Copyright (C) 2019 Netronome Systems, Inc. */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM tls
+
+#if !defined(_TLS_TRACE_H_) || defined(TRACE_HEADER_MULTI_READ)
+#define _TLS_TRACE_H_
+
+#include <asm/unaligned.h>
+#include <linux/tracepoint.h>
+
+struct sock;
+
+TRACE_EVENT(tls_device_offload_set,
+
+	TP_PROTO(struct sock *sk, int dir, u32 tcp_seq, u8 *rec_no, int ret),
+
+	TP_ARGS(sk, dir, tcp_seq, rec_no, ret),
+
+	TP_STRUCT__entry(
+		__field(	struct sock *,	sk		)
+		__field(	u64,		rec_no		)
+		__field(	int,		dir		)
+		__field(	u32,		tcp_seq		)
+		__field(	int,		ret		)
+	),
+
+	TP_fast_assign(
+		__entry->sk = sk;
+		__entry->rec_no = get_unaligned_be64(rec_no);
+		__entry->dir = dir;
+		__entry->tcp_seq = tcp_seq;
+		__entry->ret = ret;
+	),
+
+	TP_printk(
+		"sk=%p direction=%d tcp_seq=%u rec_no=%llu ret=%d",
+		__entry->sk, __entry->dir, __entry->tcp_seq, __entry->rec_no,
+		__entry->ret
+	)
+);
+
+TRACE_EVENT(tls_device_rx_resync_send,
+
+	TP_PROTO(struct sock *sk, u32 tcp_seq, u8 *rec_no, int sync_type),
+
+	TP_ARGS(sk, tcp_seq, rec_no, sync_type),
+
+	TP_STRUCT__entry(
+		__field(	struct sock *,	sk		)
+		__field(	u64,		rec_no		)
+		__field(	u32,		tcp_seq		)
+		__field(	int,		sync_type	)
+	),
+
+	TP_fast_assign(
+		__entry->sk = sk;
+		__entry->rec_no = get_unaligned_be64(rec_no);
+		__entry->tcp_seq = tcp_seq;
+		__entry->sync_type = sync_type;
+	),
+
+	TP_printk(
+		"sk=%p tcp_seq=%u rec_no=%llu sync_type=%d",
+		__entry->sk, __entry->tcp_seq, __entry->rec_no,
+		__entry->sync_type
+	)
+);
+
+TRACE_EVENT(tls_device_rx_resync_nh_schedule,
+
+	TP_PROTO(struct sock *sk),
+
+	TP_ARGS(sk),
+
+	TP_STRUCT__entry(
+		__field(	struct sock *,	sk		)
+	),
+
+	TP_fast_assign(
+		__entry->sk = sk;
+	),
+
+	TP_printk(
+		"sk=%p", __entry->sk
+	)
+);
+
+TRACE_EVENT(tls_device_rx_resync_nh_delay,
+
+	TP_PROTO(struct sock *sk, u32 sock_data, u32 rec_len),
+
+	TP_ARGS(sk, sock_data, rec_len),
+
+	TP_STRUCT__entry(
+		__field(	struct sock *,	sk		)
+		__field(	u32,		sock_data	)
+		__field(	u32,		rec_len		)
+	),
+
+	TP_fast_assign(
+		__entry->sk = sk;
+		__entry->sock_data = sock_data;
+		__entry->rec_len = rec_len;
+	),
+
+	TP_printk(
+		"sk=%p sock_data=%u rec_len=%u",
+		__entry->sk, __entry->sock_data, __entry->rec_len
+	)
+);
+
+TRACE_EVENT(tls_device_tx_resync_req,
+
+	TP_PROTO(struct sock *sk, u32 tcp_seq, u32 exp_tcp_seq),
+
+	TP_ARGS(sk, tcp_seq, exp_tcp_seq),
+
+	TP_STRUCT__entry(
+		__field(	struct sock *,	sk		)
+		__field(	u32,		tcp_seq		)
+		__field(	u32,		exp_tcp_seq	)
+	),
+
+	TP_fast_assign(
+		__entry->sk = sk;
+		__entry->tcp_seq = tcp_seq;
+		__entry->exp_tcp_seq = exp_tcp_seq;
+	),
+
+	TP_printk(
+		"sk=%p tcp_seq=%u exp_tcp_seq=%u",
+		__entry->sk, __entry->tcp_seq, __entry->exp_tcp_seq
+	)
+);
+
+TRACE_EVENT(tls_device_tx_resync_send,
+
+	TP_PROTO(struct sock *sk, u32 tcp_seq, u8 *rec_no),
+
+	TP_ARGS(sk, tcp_seq, rec_no),
+
+	TP_STRUCT__entry(
+		__field(	struct sock *,	sk		)
+		__field(	u64,		rec_no		)
+		__field(	u32,		tcp_seq		)
+	),
+
+	TP_fast_assign(
+		__entry->sk = sk;
+		__entry->rec_no = get_unaligned_be64(rec_no);
+		__entry->tcp_seq = tcp_seq;
+	),
+
+	TP_printk(
+		"sk=%p tcp_seq=%u rec_no=%llu",
+		__entry->sk, __entry->tcp_seq, __entry->rec_no
+	)
+);
+
+#endif /* _TLS_TRACE_H_ */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace
+
+#include <trace/define_trace.h>
-- 
2.21.0

