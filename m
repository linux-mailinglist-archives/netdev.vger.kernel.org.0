Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55CD83C26F
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 06:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391109AbfFKEk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 00:40:58 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40207 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391095AbfFKEk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 00:40:56 -0400
Received: by mail-qt1-f195.google.com with SMTP id a15so13004880qtn.7
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g49fW1utAJwSylLF9dXYgNY/TfXi92AV1sYBhPR2bB0=;
        b=CstpvQS6HTOWlUqYLYT8HDLsUepgry3NQattJUoWrQGJl9NjMbNXXw55+gTVKb8hNN
         JkvQEeHOCwyv0wNpmlM3sDTc2ygQdlK+MGO+4Yy62gp9fEtRepvP+RE94VUcDSRvpuQm
         Aq5W7LE43W/QobkG551Wii0Wk/oeSsNxUwZRfz2LYC1KWUlzgCeDmbhzPgDlSj/x9P7B
         v8eeonymEU/6NQh/NTyMP3MthKhoOPfhg54m9SAE+iKGOD1MqayZ63+UcWRHU+yjtYo6
         ACLLyx0ctptTxvbhwTIavay+G8moc4MbTvECrg/DzfIddtxIzMiEwHcbbUUC3YjSc0HS
         7QDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g49fW1utAJwSylLF9dXYgNY/TfXi92AV1sYBhPR2bB0=;
        b=Xx67u2FVQyG1fiVUDQomokoHW8umkBTsOdFmqrsE+GXYWBWUadRjLFf8vOO1hSwzE7
         InI0yphFbED4CSqRt/VZE+mnaO8ESk+5ZEuwaFbvrw9f7da3gtMTQXQSV67Rr3VnrcxA
         MKffN4dDjYUlUCeEOhPaBUeYV5wDqpcOmjYEJx7f/BZXneSGdyglpSV6zoUE53WYn8ZK
         zsaTSfEWFPaICAnbHU4XFNDzJCixdkZFVrKuve+7MYfrO1tJNbMCPSASNiDZYXh1ppWJ
         qrWp6DMl/yblfxw1mBUe0MGbGtz8xsUV1clJJNhOfMMeIZdhC2C69HxCX5W4Lv5bepq5
         8REw==
X-Gm-Message-State: APjAAAXHU8EW7Tm6EZ2k5vEgM/ZC3juKbTIJtu0RQqYU+edf0Bm0lT05
        S8fRH2a+EWsCOztNRfEfd4tIIA==
X-Google-Smtp-Source: APXvYqwYAnio+05BHYopSM8vk7fT95/JrZR7XeLaf4T40ShoJSbY2hqvlAP70WMlACcdLV5Wv6p3mg==
X-Received: by 2002:ac8:3636:: with SMTP id m51mr61663344qtb.102.1560228055282;
        Mon, 10 Jun 2019 21:40:55 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm2463375qtj.46.2019.06.10.21.40.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 21:40:54 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        borisp@mellanox.com, Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 04/12] net/tls: add kernel-driven TLS RX resync
Date:   Mon, 10 Jun 2019 21:40:02 -0700
Message-Id: <20190611044010.29161-5-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611044010.29161-1-jakub.kicinski@netronome.com>
References: <20190611044010.29161-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLS offload device may lose sync with the TCP stream if packets
arrive out of order.  Drivers can currently request a resync at
a specific TCP sequence number.  When a record is found starting
at that sequence number kernel will inform the device of the
corresponding record number.

This requires the device to constantly scan the stream for a
known pattern (constant bytes of the header) after sync is lost.

This patch adds an alternative approach which is entirely under
the control of the kernel.  Kernel tracks records it had to fully
decrypt, even though TLS socket is in TLS_HW mode.  If multiple
records did not have any decrypted parts - it's a pretty strong
indication that the device is out of sync.

We choose the min number of fully encrypted records to be 2,
which should hopefully be more than will get retransmitted at
a time.

After kernel decides the device is out of sync it schedules a
resync request.  If the TCP socket is empty the resync gets
performed immediately.  If socket is not empty we leave the
record parser to resync when next record comes.

Before resync in message parser we peek at the TCP socket and
don't attempt the sync if the socket already has some of the
next record queued.

On resync failure (encrypted data continues to flow in) we
retry with exponential backoff, up to once every 128 records
(with a 16k record thats at most once every 2M of data).

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 Documentation/networking/tls-offload.rst |  19 ++++
 include/net/tls.h                        |  34 +++++++-
 net/tls/tls_device.c                     | 105 ++++++++++++++++++++---
 net/tls/tls_sw.c                         |   2 +-
 4 files changed, 145 insertions(+), 15 deletions(-)

diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
index eb7c9b81ccf5..d134d63307e7 100644
--- a/Documentation/networking/tls-offload.rst
+++ b/Documentation/networking/tls-offload.rst
@@ -268,6 +268,9 @@ Device can only detect that segment 4 also contains a TLS header
 if it knows the length of the previous record from segment 2. In this case
 the device will lose synchronization with the stream.
 
+Stream scan resynchronization
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
 When the device gets out of sync and the stream reaches TCP sequence
 numbers more than a max size record past the expected TCP sequence number,
 the device starts scanning for a known header pattern. For example
@@ -298,6 +301,22 @@ Special care has to be taken if the confirmation request is passed
 asynchronously to the packet stream and record may get processed
 by the kernel before the confirmation request.
 
+Stack-driven resynchronization
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The driver may also request the stack to perform resynchronization
+whenever it sees the records are no longer getting decrypted.
+If the connection is configured in this mode the stack automatically
+schedules resynchronization after it has received two completely encrypted
+records.
+
+The stack waits for the socket to drain and informs the device about
+the next expected record number and its TCP sequence number. If the
+records continue to be received fully encrypted stack retries the
+synchronization with an exponential back off (first after 2 encrypted
+records, then after 4 records, after 8, after 16... up until every
+128 records).
+
 Error handling
 ==============
 
diff --git a/include/net/tls.h b/include/net/tls.h
index 1c512da5e4f4..28eca6a3b615 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -303,10 +303,33 @@ struct tlsdev_ops {
 				  struct sock *sk, u32 seq, u8 *rcd_sn);
 };
 
+enum tls_offload_sync_type {
+	TLS_OFFLOAD_SYNC_TYPE_DRIVER_REQ = 0,
+	TLS_OFFLOAD_SYNC_TYPE_CORE_NEXT_HINT = 1,
+};
+
+#define TLS_DEVICE_RESYNC_NH_START_IVAL		2
+#define TLS_DEVICE_RESYNC_NH_MAX_IVAL		128
+
 struct tls_offload_context_rx {
 	/* sw must be the first member of tls_offload_context_rx */
 	struct tls_sw_context_rx sw;
-	atomic64_t resync_req;
+	enum tls_offload_sync_type resync_type;
+	/* this member is set regardless of resync_type, to avoid branches */
+	u8 resync_nh_reset:1;
+	/* CORE_NEXT_HINT-only member, but use the hole here */
+	u8 resync_nh_do_now:1;
+	union {
+		/* TLS_OFFLOAD_SYNC_TYPE_DRIVER_REQ */
+		struct {
+			atomic64_t resync_req;
+		};
+		/* TLS_OFFLOAD_SYNC_TYPE_CORE_NEXT_HINT */
+		struct {
+			u32 decrypted_failed;
+			u32 decrypted_tgt;
+		} resync_nh;
+	};
 	u8 driver_state[] __aligned(8);
 	/* The TLS layer reserves room for driver specific state
 	 * Currently the belief is that there is not enough
@@ -587,6 +610,13 @@ static inline void tls_offload_rx_resync_request(struct sock *sk, __be32 seq)
 	atomic64_set(&rx_ctx->resync_req, ((u64)ntohl(seq) << 32) | 1);
 }
 
+static inline void
+tls_offload_rx_resync_set_type(struct sock *sk, enum tls_offload_sync_type type)
+{
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
+
+	tls_offload_ctx_rx(tls_ctx)->resync_type = type;
+}
 
 int tls_proccess_cmsg(struct sock *sk, struct msghdr *msg,
 		      unsigned char *record_type);
@@ -608,6 +638,6 @@ int tls_sw_fallback_init(struct sock *sk,
 int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx);
 
 void tls_device_offload_cleanup_rx(struct sock *sk);
-void tls_device_rx_resync_new_rec(struct sock *sk, u32 seq);
+void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq);
 
 #endif /* _TLS_OFFLOAD_H */
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 0ecfa0ee415d..477c869c69c8 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -563,10 +563,12 @@ static void tls_device_resync_rx(struct tls_context *tls_ctx,
 	clear_bit_unlock(TLS_RX_SYNC_RUNNING, &tls_ctx->flags);
 }
 
-void tls_device_rx_resync_new_rec(struct sock *sk, u32 seq)
+void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_offload_context_rx *rx_ctx;
+	u8 rcd_sn[TLS_MAX_REC_SEQ_SIZE];
+	struct tls_prot_info *prot;
 	u32 is_req_pending;
 	s64 resync_req;
 	u32 req_seq;
@@ -574,15 +576,84 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 seq)
 	if (tls_ctx->rx_conf != TLS_HW)
 		return;
 
+	prot = &tls_ctx->prot_info;
 	rx_ctx = tls_offload_ctx_rx(tls_ctx);
-	resync_req = atomic64_read(&rx_ctx->resync_req);
-	req_seq = resync_req >> 32;
-	seq += TLS_HEADER_SIZE - 1;
-	is_req_pending = resync_req;
-
-	if (unlikely(is_req_pending) && req_seq == seq &&
-	    atomic64_try_cmpxchg(&rx_ctx->resync_req, &resync_req, 0))
-		tls_device_resync_rx(tls_ctx, sk, seq, tls_ctx->rx.rec_seq);
+	memcpy(rcd_sn, tls_ctx->rx.rec_seq, prot->rec_seq_size);
+
+	switch (rx_ctx->resync_type) {
+	case TLS_OFFLOAD_SYNC_TYPE_DRIVER_REQ:
+		resync_req = atomic64_read(&rx_ctx->resync_req);
+		req_seq = resync_req >> 32;
+		seq += TLS_HEADER_SIZE - 1;
+		is_req_pending = resync_req;
+
+		if (likely(!is_req_pending) || req_seq != seq ||
+		    !atomic64_try_cmpxchg(&rx_ctx->resync_req, &resync_req, 0))
+			return;
+		break;
+	case TLS_OFFLOAD_SYNC_TYPE_CORE_NEXT_HINT:
+		if (likely(!rx_ctx->resync_nh_do_now))
+			return;
+
+		/* head of next rec is already in, note that the sock_inq will
+		 * include the currently parsed message when called from parser
+		 */
+		if (tcp_inq(sk) > rcd_len)
+			return;
+
+		rx_ctx->resync_nh_do_now = 0;
+		seq += rcd_len;
+		tls_bigint_increment(rcd_sn, prot->rec_seq_size);
+		break;
+	}
+
+	tls_device_resync_rx(tls_ctx, sk, seq, rcd_sn);
+}
+
+static void tls_device_core_ctrl_rx_resync(struct tls_context *tls_ctx,
+					   struct tls_offload_context_rx *ctx,
+					   struct sock *sk, struct sk_buff *skb)
+{
+	struct strp_msg *rxm;
+
+	/* device will request resyncs by itself based on stream scan */
+	if (ctx->resync_type != TLS_OFFLOAD_SYNC_TYPE_CORE_NEXT_HINT)
+		return;
+	/* already scheduled */
+	if (ctx->resync_nh_do_now)
+		return;
+	/* seen decrypted fragments since last fully-failed record */
+	if (ctx->resync_nh_reset) {
+		ctx->resync_nh_reset = 0;
+		ctx->resync_nh.decrypted_failed = 1;
+		ctx->resync_nh.decrypted_tgt = TLS_DEVICE_RESYNC_NH_START_IVAL;
+		return;
+	}
+
+	if (++ctx->resync_nh.decrypted_failed <= ctx->resync_nh.decrypted_tgt)
+		return;
+
+	/* doing resync, bump the next target in case it fails */
+	if (ctx->resync_nh.decrypted_tgt < TLS_DEVICE_RESYNC_NH_MAX_IVAL)
+		ctx->resync_nh.decrypted_tgt *= 2;
+	else
+		ctx->resync_nh.decrypted_tgt += TLS_DEVICE_RESYNC_NH_MAX_IVAL;
+
+	rxm = strp_msg(skb);
+
+	/* head of next rec is already in, parser will sync for us */
+	if (tcp_inq(sk) > rxm->full_len) {
+		ctx->resync_nh_do_now = 1;
+	} else {
+		struct tls_prot_info *prot = &tls_ctx->prot_info;
+		u8 rcd_sn[TLS_MAX_REC_SEQ_SIZE];
+
+		memcpy(rcd_sn, tls_ctx->rx.rec_seq, prot->rec_seq_size);
+		tls_bigint_increment(rcd_sn, prot->rec_seq_size);
+
+		tls_device_resync_rx(tls_ctx, sk, tcp_sk(sk)->copied_seq,
+				     rcd_sn);
+	}
 }
 
 static int tls_device_reencrypt(struct sock *sk, struct sk_buff *skb)
@@ -686,12 +757,21 @@ int tls_device_decrypted(struct sock *sk, struct sk_buff *skb)
 
 	ctx->sw.decrypted |= is_decrypted;
 
-	/* Return immedeatly if the record is either entirely plaintext or
+	/* Return immediately if the record is either entirely plaintext or
 	 * entirely ciphertext. Otherwise handle reencrypt partially decrypted
 	 * record.
 	 */
-	return (is_encrypted || is_decrypted) ? 0 :
-		tls_device_reencrypt(sk, skb);
+	if (is_decrypted) {
+		ctx->resync_nh_reset = 1;
+		return 0;
+	}
+	if (is_encrypted) {
+		tls_device_core_ctrl_rx_resync(tls_ctx, ctx, sk, skb);
+		return 0;
+	}
+
+	ctx->resync_nh_reset = 1;
+	return tls_device_reencrypt(sk, skb);
 }
 
 static void tls_device_attach(struct tls_context *ctx, struct sock *sk,
@@ -917,6 +997,7 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
 		rc = -ENOMEM;
 		goto release_netdev;
 	}
+	context->resync_nh_reset = 1;
 
 	ctx->priv_ctx_rx = context;
 	rc = tls_set_sw_offload(sk, ctx, 0);
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index bc3a1b188d4a..533eaa4826e5 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2015,7 +2015,7 @@ static int tls_read_size(struct strparser *strp, struct sk_buff *skb)
 		goto read_failure;
 	}
 #ifdef CONFIG_TLS_DEVICE
-	tls_device_rx_resync_new_rec(strp->sk,
+	tls_device_rx_resync_new_rec(strp->sk, data_len + TLS_HEADER_SIZE,
 				     TCP_SKB_CB(skb)->seq + rxm->offset);
 #endif
 	return data_len + TLS_HEADER_SIZE;
-- 
2.21.0

