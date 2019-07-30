Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7DE7B4D8
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 23:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbfG3VNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 17:13:06 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42136 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbfG3VNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 17:13:06 -0400
Received: by mail-qt1-f196.google.com with SMTP id h18so64433665qtm.9
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 14:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KC4zuCUy3YCH5+FqSYiymvXDdGqcVwUPfchc00Vt9dU=;
        b=Nn8hhcV4LfhR9WioIESlNdoGtvloDSZNJKD6/Bf5Sy0j1FL1GS9kdtqAUVxrx5EDIZ
         8+iQl8ZPWZZGFHhYw5myFpr2KGM3q6FYj9WfrOXy3zBEbENa1eFDYC6agq/pMuW+Rg3c
         Cq960U13R2HQGS3guHtyfAhQebBVM1nEqYQ+829J/BQQF+Wu2o+UUJe1eZFq4IAbHbtR
         JQ+plDWcfPJXFsabXcvdI5h8Pg8W9kSliHyhW6aJI8Qx0dGPWq1bhAWkAs5zH7d4FRq9
         hTmAxhMfwt9zlbGAqAEp/Jn/4HObztQCZXD8wGBuwLSfUUGnf4S7mP1R+PQEw0hTwZPI
         AjLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KC4zuCUy3YCH5+FqSYiymvXDdGqcVwUPfchc00Vt9dU=;
        b=i8InkqlGzoTdKSskR/qX1bPv3NrbPDQIQbUvBgs/e+Y3j+p3SBMMcK7Yg9yH1mIXbl
         WjBR9W3Ly62ITa95C3CTXkaTk+vMHpVbMnbA11fVYfZlZeVJ7ZGC1nVIqptl1gSaZwdI
         RfMLc5pcpwUVMlM1Zw+Rx/1n2mitSe45lnOgwj7uOg1dX7mSp2mx0cDpJX0pKW1P8sun
         y5SRZAOoQv4Zzq6Al7hs3X+b6WxUcKuV7RTmcnGv6hsiZPelkbuoqLWmM2jH7xpaw//e
         U0HCeu5656WISDy/q4UgecGoBxRieYeTmzrm/9CmY9n+sdJnM1PblK7dXpV/MNuAou1/
         Fr4g==
X-Gm-Message-State: APjAAAUSiQ/es9klgLH7uh5o60ei2j6fGNkyTgf/bWkjOA7oYNZj9Fj0
        tkTThdTz/r6GbfK51l/Natm+nA==
X-Google-Smtp-Source: APXvYqySCNYSUEwkQiMCswcR2u31yisLGTlA08jBf8VKlNmUNQP51zEMm2inn2kFAjIBAJVB0ZedLw==
X-Received: by 2002:ac8:31d6:: with SMTP id i22mr85472110qte.338.1564521184989;
        Tue, 30 Jul 2019 14:13:04 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c20sm22494762qkk.69.2019.07.30.14.13.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 14:13:04 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        edumazet@google.com, borisp@mellanox.com, aviadye@mellanox.com,
        davejwatson@fb.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        willemb@google.com, xiyou.wangcong@gmail.com, fw@strlen.de,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next] net/tls: prevent skb_orphan() from leaking TLS plain text with offload
Date:   Tue, 30 Jul 2019 14:12:58 -0700
Message-Id: <20190730211258.13748-1-jakub.kicinski@netronome.com>
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

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
I'm sending this for net-next because of lack of confidence
in my own abilities. It should apply cleanly to net... :)

 Documentation/networking/tls-offload.rst |  9 --------
 include/net/sock.h                       | 28 +++++++++++++++++++++++-
 net/core/skbuff.c                        |  3 +++
 net/core/sock.c                          | 22 ++++++++++++++-----
 net/ipv4/tcp.c                           |  4 +++-
 net/ipv4/tcp_output.c                    |  3 +++
 net/tls/tls_device.c                     |  2 ++
 7 files changed, 55 insertions(+), 16 deletions(-)

diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
index 048e5ca44824..2bc3ab5515d8 100644
--- a/Documentation/networking/tls-offload.rst
+++ b/Documentation/networking/tls-offload.rst
@@ -499,15 +499,6 @@ offloads, old connections will remain active after flags are cleared.
 Known bugs
 ==========
 
-skb_orphan() leaks clear text
------------------------------
-
-Currently drivers depend on the :c:member:`sk` member of
-:c:type:`struct sk_buff <sk_buff>` to identify segments requiring
-encryption. Any operation which removes or does not preserve the socket
-association such as :c:func:`skb_orphan` or :c:func:`skb_clone`
-will cause the driver to miss the packets and lead to clear text leaks.
-
 Redirects leak clear text
 -------------------------
 
diff --git a/include/net/sock.h b/include/net/sock.h
index 228db3998e46..90f3f552c789 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -814,6 +814,7 @@ enum sock_flags {
 	SOCK_TXTIME,
 	SOCK_XDP, /* XDP is attached */
 	SOCK_TSTAMP_NEW, /* Indicates 64 bit timestamps always */
+	SOCK_CRYPTO_TX_PLAIN_TEXT, /* Generate skbs with decrypted flag set */
 };
 
 #define SK_FLAGS_TIMESTAMP ((1UL << SOCK_TIMESTAMP) | (1UL << SOCK_TIMESTAMPING_RX_SOFTWARE))
@@ -2480,8 +2481,26 @@ static inline bool sk_fullsock(const struct sock *sk)
 	return (1 << sk->sk_state) & ~(TCPF_TIME_WAIT | TCPF_NEW_SYN_RECV);
 }
 
+static inline void sk_set_tx_crypto(const struct sock *sk, struct sk_buff *skb)
+{
+#ifdef CONFIG_TLS_DEVICE
+	skb->decrypted = sock_flag(sk, SOCK_CRYPTO_TX_PLAIN_TEXT);
+#endif
+}
+
+static inline bool sk_tx_crypto_match(const struct sock *sk,
+				      const struct sk_buff *skb)
+{
+#ifdef CONFIG_TLS_DEVICE
+	return sock_flag(sk, SOCK_CRYPTO_TX_PLAIN_TEXT) == !!skb->decrypted;
+#else
+	return true;
+#endif
+}
+
 /* Checks if this SKB belongs to an HW offloaded socket
  * and whether any SW fallbacks are required based on dev.
+ * Check decrypted mark in case skb_orphan() cleared socket.
  */
 static inline struct sk_buff *sk_validate_xmit_skb(struct sk_buff *skb,
 						   struct net_device *dev)
@@ -2489,8 +2508,15 @@ static inline struct sk_buff *sk_validate_xmit_skb(struct sk_buff *skb,
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
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 0b788df5a75b..9e92684479b9 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3794,6 +3794,9 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 
 			skb_reserve(nskb, headroom);
 			__skb_put(nskb, doffset);
+#ifdef CONFIG_TLS_DEVICE
+			nskb->decrypted = head_skb->decrypted;
+#endif
 		}
 
 		if (segs)
diff --git a/net/core/sock.c b/net/core/sock.c
index d57b0cc995a0..b0c10b518e65 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1992,6 +1992,22 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
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
+#ifdef CONFIG_INET
+	if (skb->destructor == tcp_wfree)
+		return true;
+#endif
+	return skb->destructor == sock_wfree;
+}
+
 /* This helper is used by netem, as it can hold packets in its
  * delay queue. We want to allow the owner socket to send more
  * packets, as if they were already TX completed by a typical driver.
@@ -2003,11 +2019,7 @@ void skb_orphan_partial(struct sk_buff *skb)
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
index f62f0e7e3cdd..dee93eab02fe 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -984,6 +984,7 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 			if (!skb)
 				goto wait_for_memory;
 
+			sk_set_tx_crypto(sk, skb);
 			skb_entail(sk, skb);
 			copy = size_goal;
 		}
@@ -993,7 +994,8 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 
 		i = skb_shinfo(skb)->nr_frags;
 		can_coalesce = skb_can_coalesce(skb, i, page, offset);
-		if (!can_coalesce && i >= sysctl_max_skb_frags) {
+		if ((!can_coalesce && i >= sysctl_max_skb_frags) ||
+		    !sk_tx_crypto_match(sk, skb)) {
 			tcp_mark_push(tp, skb);
 			goto new_segment;
 		}
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6e4afc48d7bb..9efd0ca44d49 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1320,6 +1320,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 	buff = sk_stream_alloc_skb(sk, nsize, gfp, true);
 	if (!buff)
 		return -ENOMEM; /* We'll just try again later. */
+	sk_set_tx_crypto(sk, buff);
 
 	sk->sk_wmem_queued += buff->truesize;
 	sk_mem_charge(sk, buff->truesize);
@@ -1874,6 +1875,7 @@ static int tso_fragment(struct sock *sk, struct sk_buff *skb, unsigned int len,
 	buff = sk_stream_alloc_skb(sk, 0, gfp, true);
 	if (unlikely(!buff))
 		return -ENOMEM;
+	sk_set_tx_crypto(sk, buff);
 
 	sk->sk_wmem_queued += buff->truesize;
 	sk_mem_charge(sk, buff->truesize);
@@ -2139,6 +2141,7 @@ static int tcp_mtu_probe(struct sock *sk)
 	nskb = sk_stream_alloc_skb(sk, probe_size, GFP_ATOMIC, false);
 	if (!nskb)
 		return -1;
+	sk_set_tx_crypto(sk, nskb);
 	sk->sk_wmem_queued += nskb->truesize;
 	sk_mem_charge(sk, nskb->truesize);
 
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 4ec8a06fa5d1..3d78742b3b1b 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -970,6 +970,8 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 
 	tls_device_attach(ctx, sk, netdev);
 
+	sock_set_flag(sk, SOCK_CRYPTO_TX_PLAIN_TEXT);
+
 	/* following this assignment tls_is_sk_tx_device_offloaded
 	 * will return true and the context might be accessed
 	 * by the netdev's xmit function.
-- 
2.21.0

