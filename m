Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADAA1F297E
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732789AbgFIAAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730528AbgFHXWc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:22:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0A73208A9;
        Mon,  8 Jun 2020 23:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658551;
        bh=o2gxWJBXPWPGQxWLqWkSnsINHs4N9EI7SU51pcZvNaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p52QAWWgcx9Z6kF6foaZwtx3wdxi8Zsc4Gxhtp0sz03QFLM7RK8AABtktmzADJWjn
         0BqT6ArEBD5b4g+7lkFhyiRcEqDAtpwkNrm29lw1SINaI9/fmcVrgKcD2gXY6W02lL
         jqv8McSD0VyhpPFKXlKtAKx3IB4CR6RYwazdfRiY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 171/175] bpf: Fix running sk_skb program types with ktls
Date:   Mon,  8 Jun 2020 19:18:44 -0400
Message-Id: <20200608231848.3366970-171-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit e91de6afa81c10e9f855c5695eb9a53168d96b73 ]

KTLS uses a stream parser to collect TLS messages and send them to
the upper layer tls receive handler. This ensures the tls receiver
has a full TLS header to parse when it is run. However, when a
socket has BPF_SK_SKB_STREAM_VERDICT program attached before KTLS
is enabled we end up with two stream parsers running on the same
socket.

The result is both try to run on the same socket. First the KTLS
stream parser runs and calls read_sock() which will tcp_read_sock
which in turn calls tcp_rcv_skb(). This dequeues the skb from the
sk_receive_queue. When this is done KTLS code then data_ready()
callback which because we stacked KTLS on top of the bpf stream
verdict program has been replaced with sk_psock_start_strp(). This
will in turn kick the stream parser again and eventually do the
same thing KTLS did above calling into tcp_rcv_skb() and dequeuing
a skb from the sk_receive_queue.

At this point the data stream is broke. Part of the stream was
handled by the KTLS side some other bytes may have been handled
by the BPF side. Generally this results in either missing data
or more likely a "Bad Message" complaint from the kTLS receive
handler as the BPF program steals some bytes meant to be in a
TLS header and/or the TLS header length is no longer correct.

We've already broke the idealized model where we can stack ULPs
in any order with generic callbacks on the TX side to handle this.
So in this patch we do the same thing but for RX side. We add
a sk_psock_strp_enabled() helper so TLS can learn a BPF verdict
program is running and add a tls_sw_has_ctx_rx() helper so BPF
side can learn there is a TLS ULP on the socket.

Then on BPF side we omit calling our stream parser to avoid
breaking the data stream for the KTLS receiver. Then on the
KTLS side we call BPF_SK_SKB_STREAM_VERDICT once the KTLS
receiver is done with the packet but before it posts the
msg to userspace. This gives us symmetry between the TX and
RX halfs and IMO makes it usable again. On the TX side we
process packets in this order BPF -> TLS -> TCP and on
the receive side in the reverse order TCP -> TLS -> BPF.

Discovered while testing OpenSSL 3.0 Alpha2.0 release.

Fixes: d829e9c4112b5 ("tls: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/159079361946.5745.605854335665044485.stgit@john-Precision-5820-Tower
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skmsg.h |  8 ++++++++
 include/net/tls.h     |  9 +++++++++
 net/core/skmsg.c      | 43 ++++++++++++++++++++++++++++++++++++++++---
 net/tls/tls_sw.c      | 20 ++++++++++++++++++--
 4 files changed, 75 insertions(+), 5 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index a3adbe593505..4bdb5e4bbd6a 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -457,4 +457,12 @@ static inline void psock_progs_drop(struct sk_psock_progs *progs)
 	psock_set_prog(&progs->skb_verdict, NULL);
 }
 
+int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb);
+
+static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
+{
+	if (!psock)
+		return false;
+	return psock->parser.enabled;
+}
 #endif /* _LINUX_SKMSG_H */
diff --git a/include/net/tls.h b/include/net/tls.h
index db26e3ec918f..0a065bdffa39 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -590,6 +590,15 @@ static inline bool tls_sw_has_ctx_tx(const struct sock *sk)
 	return !!tls_sw_ctx_tx(ctx);
 }
 
+static inline bool tls_sw_has_ctx_rx(const struct sock *sk)
+{
+	struct tls_context *ctx = tls_get_ctx(sk);
+
+	if (!ctx)
+		return false;
+	return !!tls_sw_ctx_rx(ctx);
+}
+
 void tls_sw_write_space(struct sock *sk, struct tls_context *ctx);
 void tls_device_write_space(struct sock *sk, struct tls_context *ctx);
 
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 8e538a28fe0d..0536ea9298e4 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -7,6 +7,7 @@
 
 #include <net/sock.h>
 #include <net/tcp.h>
+#include <net/tls.h>
 
 static bool sk_msg_try_coalesce_ok(struct sk_msg *msg, int elem_first_coalesce)
 {
@@ -718,6 +719,38 @@ static void sk_psock_skb_redirect(struct sk_psock *psock, struct sk_buff *skb)
 	}
 }
 
+static void sk_psock_tls_verdict_apply(struct sk_psock *psock,
+				       struct sk_buff *skb, int verdict)
+{
+	switch (verdict) {
+	case __SK_REDIRECT:
+		sk_psock_skb_redirect(psock, skb);
+		break;
+	case __SK_PASS:
+	case __SK_DROP:
+	default:
+		break;
+	}
+}
+
+int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
+{
+	struct bpf_prog *prog;
+	int ret = __SK_PASS;
+
+	rcu_read_lock();
+	prog = READ_ONCE(psock->progs.skb_verdict);
+	if (likely(prog)) {
+		tcp_skb_bpf_redirect_clear(skb);
+		ret = sk_psock_bpf_run(psock, prog, skb);
+		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+	}
+	rcu_read_unlock();
+	sk_psock_tls_verdict_apply(psock, skb, ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
+
 static void sk_psock_verdict_apply(struct sk_psock *psock,
 				   struct sk_buff *skb, int verdict)
 {
@@ -796,9 +829,13 @@ static void sk_psock_strp_data_ready(struct sock *sk)
 	rcu_read_lock();
 	psock = sk_psock(sk);
 	if (likely(psock)) {
-		write_lock_bh(&sk->sk_callback_lock);
-		strp_data_ready(&psock->parser.strp);
-		write_unlock_bh(&sk->sk_callback_lock);
+		if (tls_sw_has_ctx_rx(sk)) {
+			psock->parser.saved_data_ready(sk);
+		} else {
+			write_lock_bh(&sk->sk_callback_lock);
+			strp_data_ready(&psock->parser.strp);
+			write_unlock_bh(&sk->sk_callback_lock);
+		}
 	}
 	rcu_read_unlock();
 }
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index fbf6a496ee8b..70b203e5d5fd 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1737,6 +1737,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	long timeo;
 	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
 	bool is_peek = flags & MSG_PEEK;
+	bool bpf_strp_enabled;
 	int num_async = 0;
 	int pending;
 
@@ -1747,6 +1748,7 @@ int tls_sw_recvmsg(struct sock *sk,
 
 	psock = sk_psock_get(sk);
 	lock_sock(sk);
+	bpf_strp_enabled = sk_psock_strp_enabled(psock);
 
 	/* Process pending decrypted records. It must be non-zero-copy */
 	err = process_rx_list(ctx, msg, &control, &cmsg, 0, len, false,
@@ -1800,11 +1802,12 @@ int tls_sw_recvmsg(struct sock *sk,
 
 		if (to_decrypt <= len && !is_kvec && !is_peek &&
 		    ctx->control == TLS_RECORD_TYPE_DATA &&
-		    prot->version != TLS_1_3_VERSION)
+		    prot->version != TLS_1_3_VERSION &&
+		    !bpf_strp_enabled)
 			zc = true;
 
 		/* Do not use async mode if record is non-data */
-		if (ctx->control == TLS_RECORD_TYPE_DATA)
+		if (ctx->control == TLS_RECORD_TYPE_DATA && !bpf_strp_enabled)
 			async_capable = ctx->async_capable;
 		else
 			async_capable = false;
@@ -1854,6 +1857,19 @@ int tls_sw_recvmsg(struct sock *sk,
 			goto pick_next_record;
 
 		if (!zc) {
+			if (bpf_strp_enabled) {
+				err = sk_psock_tls_strp_read(psock, skb);
+				if (err != __SK_PASS) {
+					rxm->offset = rxm->offset + rxm->full_len;
+					rxm->full_len = 0;
+					if (err == __SK_DROP)
+						consume_skb(skb);
+					ctx->recv_pkt = NULL;
+					__strp_unpause(&ctx->strp);
+					continue;
+				}
+			}
+
 			if (rxm->full_len > len) {
 				retain_skb = true;
 				chunk = len;
-- 
2.25.1

