Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 930E21970EB
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 00:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgC2Wx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 18:53:56 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:54778 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbgC2Wxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 18:53:55 -0400
Received: by mail-pj1-f65.google.com with SMTP id np9so6728719pjb.4;
        Sun, 29 Mar 2020 15:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g6s4kfFeQsm2zTjuoVkgmF3mGhrJ7uY8FHMSRBRtNsA=;
        b=e4bMMzJ+dvBvnlIYrtr3HiLpftmCdJeT+LVQy6dcgR9HgUXu236Ks/X1L+KgR4M/V4
         qNJatBkrZWvAeGipcyfRNE76zaF2/vfcxbjAJ3juwZk/c6Ndps4NuV5gbdjqkD8kVEO6
         2mrTfE1xCkh9BzNe/AT/2/L0OZ/EVxJVrPQfLwd6JTVC9jCKnCy7x44Wt89TvdtcyfhJ
         GEi1H8tJmNfLBsI6qbNwD6i3gxONEdaIV4ZLyg3K7nX6ZbL0Q1lcHgiXGfeCXKrQW4tc
         mn1mMz686wBVQKQBeIP0S+TQdwUWAcTDLyP7J5dmINYQ0kHfilvXz4CU4zs+yEktItAk
         VMAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=g6s4kfFeQsm2zTjuoVkgmF3mGhrJ7uY8FHMSRBRtNsA=;
        b=kRb9/m8opJy52N7zzcc/eRKfcLZmzo4XfIwALhy/4OPZ5jDZqsgjK6ptaUZgkb5gwr
         DK5eCGekXDTSIQU4IhSSMM6Xt1ikjf0kGRwotfROgBt0W6HAMCYIaY1D/kZlLfhEsKIw
         yiTNv0wWtxHb+iG294eAyPe1MBZSWzN8bd9UpfyUnoqeiO8vQYPwM56MtVMGJohPOsuv
         Q6zK8DdfD3BWU8X6jCADNFu4tMo+jAn1wDSQuZnfRwnNlMNyNFgXJEqsRAwMHvBk2OEJ
         hSs28zeEouwstAbPw1adooOKyNW6HHic/PQwPGVSxrbqQqfcQbVt1Zg1llyeVpo0GBjJ
         vmSA==
X-Gm-Message-State: ANhLgQ1IEeZQAr5U20IVqGcLwkDDkt0y7w/Jd/u/3yGSPFzgJwfEXik2
        ogzgQi7/H6WX8bA5XOUWxKi3sHKs
X-Google-Smtp-Source: ADFU+vto6Sad/DUe2Sh1U/oKdpU4oQp18mim3hqidPeqAt94vil2Tde/9cTvZoh9CZSBcYcV3+tDOQ==
X-Received: by 2002:a17:90a:2103:: with SMTP id a3mr12713082pje.181.1585522432426;
        Sun, 29 Mar 2020 15:53:52 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id i187sm8710386pfg.33.2020.03.29.15.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 15:53:51 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com, kafai@fb.com
Subject: [PATCHv5 bpf-next 3/5] bpf: Don't refcount LISTEN sockets in sk_assign()
Date:   Sun, 29 Mar 2020 15:53:40 -0700
Message-Id: <20200329225342.16317-4-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200329225342.16317-1-joe@wand.net.nz>
References: <20200329225342.16317-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid taking a reference on listen sockets by checking the socket type
in the sk_assign and in the corresponding skb_steal_sock() code in the
the transport layer, and by ensuring that the prefetch free (sock_pfree)
function uses the same logic to check whether the socket is refcounted.

Suggested-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Joe Stringer <joe@wand.net.nz>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
v5: Guard sock_gen_put() with #ifdef for CONFIG_INET
v4: Directly use sock_gen_put() from sock_pfree()
    Acked
v3: No changes
v2: Initial version
---
 include/net/sock.h | 25 +++++++++++++++++--------
 net/core/filter.c  |  6 +++---
 net/core/sock.c    |  3 ++-
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index f81d528845f6..6d84784d33fa 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2537,6 +2537,21 @@ skb_sk_is_prefetched(struct sk_buff *skb)
 #endif /* CONFIG_INET */
 }
 
+/* This helper checks if a socket is a full socket,
+ * ie _not_ a timewait or request socket.
+ */
+static inline bool sk_fullsock(const struct sock *sk)
+{
+	return (1 << sk->sk_state) & ~(TCPF_TIME_WAIT | TCPF_NEW_SYN_RECV);
+}
+
+static inline bool
+sk_is_refcounted(struct sock *sk)
+{
+	/* Only full sockets have sk->sk_flags. */
+	return !sk_fullsock(sk) || !sock_flag(sk, SOCK_RCU_FREE);
+}
+
 /**
  * skb_steal_sock
  * @skb to steal the socket from
@@ -2549,6 +2564,8 @@ skb_steal_sock(struct sk_buff *skb, bool *refcounted)
 		struct sock *sk = skb->sk;
 
 		*refcounted = true;
+		if (skb_sk_is_prefetched(skb))
+			*refcounted = sk_is_refcounted(sk);
 		skb->destructor = NULL;
 		skb->sk = NULL;
 		return sk;
@@ -2557,14 +2574,6 @@ skb_steal_sock(struct sk_buff *skb, bool *refcounted)
 	return NULL;
 }
 
-/* This helper checks if a socket is a full socket,
- * ie _not_ a timewait or request socket.
- */
-static inline bool sk_fullsock(const struct sock *sk)
-{
-	return (1 << sk->sk_state) & ~(TCPF_TIME_WAIT | TCPF_NEW_SYN_RECV);
-}
-
 /* Checks if this SKB belongs to an HW offloaded socket
  * and whether any SW fallbacks are required based on dev.
  * Check decrypted mark in case skb_orphan() cleared socket.
diff --git a/net/core/filter.c b/net/core/filter.c
index ac5c1633f8d2..7628b947dbc3 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5401,8 +5401,7 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
 
 BPF_CALL_1(bpf_sk_release, struct sock *, sk)
 {
-	/* Only full sockets have sk->sk_flags. */
-	if (!sk_fullsock(sk) || !sock_flag(sk, SOCK_RCU_FREE))
+	if (sk_is_refcounted(sk))
 		sock_gen_put(sk);
 	return 0;
 }
@@ -5928,7 +5927,8 @@ BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
 		return -ENETUNREACH;
 	if (unlikely(sk->sk_reuseport))
 		return -ESOCKTNOSUPPORT;
-	if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
+	if (sk_is_refcounted(sk) &&
+	    unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
 		return -ENOENT;
 
 	skb_orphan(skb);
diff --git a/net/core/sock.c b/net/core/sock.c
index 87e3a03c9056..da32d9b6d09f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2077,7 +2077,8 @@ EXPORT_SYMBOL(sock_efree);
 #ifdef CONFIG_INET
 void sock_pfree(struct sk_buff *skb)
 {
-	sock_gen_put(skb->sk);
+	if (sk_is_refcounted(skb->sk))
+		sock_gen_put(skb->sk);
 }
 EXPORT_SYMBOL(sock_pfree);
 #endif /* CONFIG_INET */
-- 
2.20.1

