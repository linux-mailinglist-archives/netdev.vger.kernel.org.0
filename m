Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C259D1968BF
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 19:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgC1SzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 14:55:25 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39361 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgC1SzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 14:55:21 -0400
Received: by mail-pf1-f193.google.com with SMTP id k15so1197851pfh.6;
        Sat, 28 Mar 2020 11:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rpc5FwUDghS88yLMu/1zEjqjbewtIUw68zZAzoteuFA=;
        b=XmRaqMzl3w8WlPZ2YCoKY0O/UjZKmuObWQd4WunuVJ1s3O/0Fxm4EmFpa4VQwlTccU
         08821NjChoLoZKPixbBbRT0KCvgmlRu8aZm2dmQm02I9CLG6my1PbQ1WgKpEiwLudRfm
         0ANSTqeKpENRP8y9R3o2yaqmHOAa7lm99DkeoJgwdapb+BZWVNtf9kVjjqOggXuiL8qi
         VFC6VCPP+qKV2uYYMTjdTIqPNdV9G6xrfdTSeOVChjrsNLQsriJuvcuLdKT9KxufWB1K
         xzyVvMYa8VAiWNSz+OzmQvyH1JhSojTYocDi4d1jMKNqj1ZmT9GfhX4VG/hKASXD2c4c
         y3Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Rpc5FwUDghS88yLMu/1zEjqjbewtIUw68zZAzoteuFA=;
        b=Bl2aC2ybf18bEqOT1Ebt6DTTcm7aMl6F4zaYdIZUy6w3WjRlkz2xNlbRyFkfy070VL
         /ATqXAvlBjA3YXA90oRP/CAddPoCjxSchkNgLqyuH+HsTFv/eUw9r4mQO5XDra2frOSp
         uvaKt5whdwIUSrcDd0dVhgePslDWBg3fDlcPpvDL1YbLBPm7XuoZbF/m4OFYg+T7yZYZ
         sbq84rBlE0FD02OvHMrDFJ/wDaxAijmjzRKOYNsGmz5tguU9swxyAoXlZpjygW4Umw4b
         iWBk7ygGenWPNJq2ddxsEHBGJahpHQOrhfrVJzw8EPDjeSNUG+kMII5S+lRyiyG7A244
         DsEQ==
X-Gm-Message-State: ANhLgQ2BG2IkGeDhYTd7ff+Iygvh0KjMI8Wf9c7WhWxuKvTxD/kYTeDC
        nQxSE5p22Bkupds9/kMKR1BW0ruA
X-Google-Smtp-Source: ADFU+vv47xmHpgHRSpNxivwkEvgov7f5ejg1MO6fWUZvaIyU0ttFzGLRVOuHz2EZAofw+KHzz7PgXw==
X-Received: by 2002:aa7:9f94:: with SMTP id z20mr5042099pfr.261.1585421720267;
        Sat, 28 Mar 2020 11:55:20 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id d7sm6682022pfo.86.2020.03.28.11.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 11:55:19 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com, kafai@fb.com
Subject: [PATCHv4 bpf-next 3/5] bpf: Don't refcount LISTEN sockets in sk_assign()
Date:   Sat, 28 Mar 2020 11:55:06 -0700
Message-Id: <20200328185509.20892-4-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200328185509.20892-1-joe@wand.net.nz>
References: <20200328185509.20892-1-joe@wand.net.nz>
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
v4: Directly use sock_gen_put() from sock_pfree()
v3: No changes
v2: Initial version
---
 include/net/sock.h | 25 +++++++++++++++++--------
 net/core/filter.c  |  6 +++---
 net/core/sock.c    |  3 ++-
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 1ca2e808cb8e..3ec1865f173e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2533,6 +2533,21 @@ skb_sk_is_prefetched(struct sk_buff *skb)
 	return skb->destructor == sock_pfree;
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
@@ -2545,6 +2560,8 @@ skb_steal_sock(struct sk_buff *skb, bool *refcounted)
 		struct sock *sk = skb->sk;
 
 		*refcounted = true;
+		if (skb_sk_is_prefetched(skb))
+			*refcounted = sk_is_refcounted(sk);
 		skb->destructor = NULL;
 		skb->sk = NULL;
 		return sk;
@@ -2553,14 +2570,6 @@ skb_steal_sock(struct sk_buff *skb, bool *refcounted)
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
index a95ac2ec7beb..c33b6afdb774 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2076,7 +2076,8 @@ EXPORT_SYMBOL(sock_efree);
  */
 void sock_pfree(struct sk_buff *skb)
 {
-	sock_gen_put(skb->sk);
+	if (sk_is_refcounted(skb->sk))
+		sock_gen_put(skb->sk);
 }
 EXPORT_SYMBOL(sock_pfree);
 
-- 
2.20.1

