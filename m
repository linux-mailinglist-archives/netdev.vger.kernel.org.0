Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5D78443F
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 08:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfHGGGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 02:06:38 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39030 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbfHGGGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 02:06:38 -0400
Received: by mail-qt1-f194.google.com with SMTP id l9so87144253qtu.6
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 23:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hgroBfpWaCEWL4o3rLEyzshU6zo1bfqmroJ4xss/vbo=;
        b=hTw0IHk0rnAf6+E9dI3JzwdXiMe07pEF5A1flca/HPHVb+GH+NkHJfiXeKpT3shu2e
         cTm7wv0XQkF+WmZaUa1fp5VQPEILgdBF8aKRK94ji+Hxngi1Jbosc+H1UlT8K8zWkNBE
         DfE5KdLuyfBdIg9ax8WgeQ08gNVlXodAVu7UETQIVl8qkAHyka56XzJAvfLPkHsflUfa
         32Ml99HlfA8Mz0jPHUsPRuzT6N+vTJrLineXcJJN5zOvIw9BCtwlxmH/nQD629tPBi9S
         FswNclNMVrtL5CaqF8+wDCU+jmtA5AnmxCDINs9W1pS/MDR6lrepji88Teit+BnvmIxJ
         phVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hgroBfpWaCEWL4o3rLEyzshU6zo1bfqmroJ4xss/vbo=;
        b=ij4YKDyRnqSbTgAfE9/MU9EIyxTQemyUQnbsHTkn+h5j/0v4qUbBc/mEbLnBREMbQJ
         P8B46OKZTTh270eXvS9+l7dbTf4DBiFRIy/tZxDaZmwgqWCObGrQzMlOknkkJz5eZISj
         wqjq8xpHYczviOmKx/OqSrCRuNR6VHiN2m9WAqP5Y4Z3QIFCsGyuhDAWCUO/tk7q36+F
         cB9OP4LldYhK5URg1glzpnFLi/+vHi8e3WW99NfjLB/MiBMHowiLoky3/z9E+yx4q3Pc
         dHjv0/vEavX9dtegFaDFfhu4IzyAb/7+Vjd21YuF9QPN6aqm03Kl9LRyzeVLpT7VYcT3
         LSHA==
X-Gm-Message-State: APjAAAXlfRZIIMZesvfUN4AvCl49aazSnhMz8fT0ofbdAoS9lVOlbs1E
        pEuv16QEAUTuOYwJGDvTVDlIkg==
X-Google-Smtp-Source: APXvYqwnFDgp6NniwvkkjATiv79eMMzIXeGnuJeoxLYQRVxodt1J/aeka05DJFsTQxEwaata2ointQ==
X-Received: by 2002:a0c:b88e:: with SMTP id y14mr6271538qvf.93.1565157997024;
        Tue, 06 Aug 2019 23:06:37 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q12sm35830241qkm.126.2019.08.06.23.06.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 23:06:36 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, davejwatson@fb.com, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, willemb@google.com, edumazet@google.com,
        alexei.starovoitov@gmail.com, oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net v2] net/tls: prevent skb_orphan() from leaking TLS plain text with offload
Date:   Tue,  6 Aug 2019 23:06:12 -0700
Message-Id: <20190807060612.19397-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_validate_xmit_skb() and drivers depend on the sk member of
struct sk_buff to identify segments requiring encryption.
Any operation which removes or does not preserve the original TLS
socket such as skb_orphan() or skb_clone() will cause clear text
leaks.

Make the TCP socket underlying an offloaded TLS connection
mark all skbs as decrypted, if TLS TX is in offload mode.
Then in sk_validate_xmit_skb() catch skbs which have no socket
(or a socket with no validation) and decrypted flag set.

Note that CONFIG_SOCK_VALIDATE_XMIT, CONFIG_TLS_DEVICE and
sk->sk_validate_xmit_skb are slightly interchangeable right now,
they all imply TLS offload. The new checks are guarded by
CONFIG_TLS_DEVICE because that's the option guarding the
sk_buff->decrypted member.

Second, smaller issue with orphaning is that it breaks
the guarantee that packets will be delivered to device
queues in-order. All TLS offload drivers depend on that
scheduling property. This means skb_orphan_partial()'s
trick of preserving partial socket references will cause
issues in the drivers. We need a full orphan, and as a
result netem delay/throttling will cause all TLS offload
skbs to be dropped.

Reusing the sk_buff->decrypted flag also protects from
leaking clear text when incoming, decrypted skb is redirected
(e.g. by TC).

See commit 0608c69c9a80 ("bpf: sk_msg, sock{map|hash} redirect
through ULP") for justification why the internal flag is safe.

v2:
 - remove superfluous decrypted mark copy (Willem);
 - remove the stale doc entry (Boris);
 - rely entirely on EOR marking to prevent coalescing (Boris);
 - use an internal sendpages flag instead of marking the socket
   (Boris).

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 Documentation/networking/tls-offload.rst | 18 ------------------
 include/linux/skbuff.h                   |  8 ++++++++
 include/linux/socket.h                   |  3 +++
 include/net/sock.h                       | 10 +++++++++-
 net/core/sock.c                          | 20 +++++++++++++++-----
 net/ipv4/tcp.c                           |  3 +++
 net/ipv4/tcp_output.c                    |  3 +++
 net/tls/tls_device.c                     |  9 +++++++--
 8 files changed, 48 insertions(+), 26 deletions(-)

diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
index b70b70dc4524..0dd3f748239f 100644
--- a/Documentation/networking/tls-offload.rst
+++ b/Documentation/networking/tls-offload.rst
@@ -506,21 +506,3 @@ Drivers should ignore the changes to TLS the device feature flags.
 These flags will be acted upon accordingly by the core ``ktls`` code.
 TLS device feature flags only control adding of new TLS connection
 offloads, old connections will remain active after flags are cleared.
-
-Known bugs
-==========
-
-skb_orphan() leaks clear text
------------------------------
-
-Currently drivers depend on the :c:member:`sk` member of
-:c:type:`struct sk_buff <sk_buff>` to identify segments requiring
-encryption. Any operation which removes or does not preserve the socket
-association such as :c:func:`skb_orphan` or :c:func:`skb_clone`
-will cause the driver to miss the packets and lead to clear text leaks.
-
-Redirects leak clear text
--------------------------
-
-In the RX direction, if segment has already been decrypted by the device
-and it gets redirected or mirrored - clear text will be transmitted out.
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index d8af86d995d6..ba5583522d24 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1374,6 +1374,14 @@ static inline void skb_copy_hash(struct sk_buff *to, const struct sk_buff *from)
 	to->l4_hash = from->l4_hash;
 };
 
+static inline void skb_copy_decrypted(struct sk_buff *to,
+				      const struct sk_buff *from)
+{
+#ifdef CONFIG_TLS_DEVICE
+	to->decrypted = from->decrypted;
+#endif
+}
+
 #ifdef NET_SKBUFF_DATA_USES_OFFSET
 static inline unsigned char *skb_end_pointer(const struct sk_buff *skb)
 {
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 97523818cb14..fc0bed59fc84 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -292,6 +292,9 @@ struct ucred {
 #define MSG_BATCH	0x40000 /* sendmmsg(): more messages coming */
 #define MSG_EOF         MSG_FIN
 #define MSG_NO_SHARED_FRAGS 0x80000 /* sendpage() internal : page frags are not shared */
+#define MSG_SENDPAGE_DECRYPTED	0x100000 /* sendpage() internal : page may carry
+					  * plain text and require encryption
+					  */
 
 #define MSG_ZEROCOPY	0x4000000	/* Use user data in kernel path */
 #define MSG_FASTOPEN	0x20000000	/* Send data in TCP SYN */
diff --git a/include/net/sock.h b/include/net/sock.h
index 228db3998e46..2c53f1a1d905 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2482,6 +2482,7 @@ static inline bool sk_fullsock(const struct sock *sk)
 
 /* Checks if this SKB belongs to an HW offloaded socket
  * and whether any SW fallbacks are required based on dev.
+ * Check decrypted mark in case skb_orphan() cleared socket.
  */
 static inline struct sk_buff *sk_validate_xmit_skb(struct sk_buff *skb,
 						   struct net_device *dev)
@@ -2489,8 +2490,15 @@ static inline struct sk_buff *sk_validate_xmit_skb(struct sk_buff *skb,
 #ifdef CONFIG_SOCK_VALIDATE_XMIT
 	struct sock *sk = skb->sk;
 
-	if (sk && sk_fullsock(sk) && sk->sk_validate_xmit_skb)
+	if (sk && sk_fullsock(sk) && sk->sk_validate_xmit_skb) {
 		skb = sk->sk_validate_xmit_skb(sk, dev, skb);
+#ifdef CONFIG_TLS_DEVICE
+	} else if (unlikely(skb->decrypted)) {
+		pr_warn_ratelimited("unencrypted skb with no associated socket - dropping\n");
+		kfree_skb(skb);
+		skb = NULL;
+#endif
+	}
 #endif
 
 	return skb;
diff --git a/net/core/sock.c b/net/core/sock.c
index d57b0cc995a0..0f9619b0892f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1992,6 +1992,20 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
 }
 EXPORT_SYMBOL(skb_set_owner_w);
 
+static bool can_skb_orphan_partial(const struct sk_buff *skb)
+{
+#ifdef CONFIG_TLS_DEVICE
+	/* Drivers depend on in-order delivery for crypto offload,
+	 * partial orphan breaks out-of-order-OK logic.
+	 */
+	if (skb->decrypted)
+		return false;
+#endif
+	return (IS_ENABLED(CONFIG_INET) &&
+		skb->destructor == tcp_wfree) ||
+		skb->destructor == sock_wfree;
+}
+
 /* This helper is used by netem, as it can hold packets in its
  * delay queue. We want to allow the owner socket to send more
  * packets, as if they were already TX completed by a typical driver.
@@ -2003,11 +2017,7 @@ void skb_orphan_partial(struct sk_buff *skb)
 	if (skb_is_tcp_pure_ack(skb))
 		return;
 
-	if (skb->destructor == sock_wfree
-#ifdef CONFIG_INET
-	    || skb->destructor == tcp_wfree
-#endif
-		) {
+	if (can_skb_orphan_partial(skb)) {
 		struct sock *sk = skb->sk;
 
 		if (refcount_inc_not_zero(&sk->sk_refcnt)) {
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 776905899ac0..77b485d60b9d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -984,6 +984,9 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 			if (!skb)
 				goto wait_for_memory;
 
+#ifdef CONFIG_TLS_DEVICE
+			skb->decrypted = !!(flags & MSG_SENDPAGE_DECRYPTED);
+#endif
 			skb_entail(sk, skb);
 			copy = size_goal;
 		}
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6e4afc48d7bb..979520e46e33 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1320,6 +1320,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 	buff = sk_stream_alloc_skb(sk, nsize, gfp, true);
 	if (!buff)
 		return -ENOMEM; /* We'll just try again later. */
+	skb_copy_decrypted(buff, skb);
 
 	sk->sk_wmem_queued += buff->truesize;
 	sk_mem_charge(sk, buff->truesize);
@@ -1874,6 +1875,7 @@ static int tso_fragment(struct sock *sk, struct sk_buff *skb, unsigned int len,
 	buff = sk_stream_alloc_skb(sk, 0, gfp, true);
 	if (unlikely(!buff))
 		return -ENOMEM;
+	skb_copy_decrypted(buff, skb);
 
 	sk->sk_wmem_queued += buff->truesize;
 	sk_mem_charge(sk, buff->truesize);
@@ -2143,6 +2145,7 @@ static int tcp_mtu_probe(struct sock *sk)
 	sk_mem_charge(sk, nskb->truesize);
 
 	skb = tcp_send_head(sk);
+	skb_copy_decrypted(nskb, skb);
 
 	TCP_SKB_CB(nskb)->seq = TCP_SKB_CB(skb)->seq;
 	TCP_SKB_CB(nskb)->end_seq = TCP_SKB_CB(skb)->seq + probe_size;
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 7c0b2b778703..43922d86e510 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -373,9 +373,9 @@ static int tls_push_data(struct sock *sk,
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct tls_offload_context_tx *ctx = tls_offload_ctx_tx(tls_ctx);
-	int tls_push_record_flags = flags | MSG_SENDPAGE_NOTLAST;
 	int more = flags & (MSG_SENDPAGE_NOTLAST | MSG_MORE);
 	struct tls_record_info *record = ctx->open_record;
+	int tls_push_record_flags;
 	struct page_frag *pfrag;
 	size_t orig_size = size;
 	u32 max_open_record_len;
@@ -390,6 +390,9 @@ static int tls_push_data(struct sock *sk,
 	if (sk->sk_err)
 		return -sk->sk_err;
 
+	flags |= MSG_SENDPAGE_DECRYPTED;
+	tls_push_record_flags = flags | MSG_SENDPAGE_NOTLAST;
+
 	timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
 	if (tls_is_partially_sent_record(tls_ctx)) {
 		rc = tls_push_partial_record(sk, tls_ctx, flags);
@@ -576,7 +579,9 @@ void tls_device_write_space(struct sock *sk, struct tls_context *ctx)
 		gfp_t sk_allocation = sk->sk_allocation;
 
 		sk->sk_allocation = GFP_ATOMIC;
-		tls_push_partial_record(sk, ctx, MSG_DONTWAIT | MSG_NOSIGNAL);
+		tls_push_partial_record(sk, ctx,
+					MSG_DONTWAIT | MSG_NOSIGNAL |
+					MSG_SENDPAGE_DECRYPTED);
 		sk->sk_allocation = sk_allocation;
 	}
 }
-- 
2.21.0

