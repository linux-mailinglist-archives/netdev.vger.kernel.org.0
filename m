Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF4F195008
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 05:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgC0E0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 00:26:05 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35844 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgC0E0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 00:26:04 -0400
Received: by mail-pf1-f194.google.com with SMTP id i13so3905624pfe.3;
        Thu, 26 Mar 2020 21:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LSgXoIxEoELwnVK+5i6wNsla7+o6/mVWf4PV/UuHzAU=;
        b=a/UyRHFer+QiXJHNeg2MukhqPmw+r/musvtul2/re4qw8u7VZbhUYi8KWbOgn5PoPy
         Txgz7nVhNGih+EEOt5+WYcjTy0jE33nspPTCE//iUdQqHU4Lj2lGGfHdnBidFqFoPp1W
         yrYrejNFlHod1AgwagSgXVhyAKuQue078ouVECT6pZF4gVoudDhM8ZjxvyuxNZtffOkx
         3QPEkJ9w2MYwIHIHl6GJDVfUN80D6/ch6L/e5jT0K1DUETTSHswM3MXCb/XMsf7KXWkj
         9Va7P/Iz1dFFmGL2KYUJ2TPLgYREgeGxZVWsw40R9wCUOii22fWzYhJQXKx47nMPqoeP
         XrqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=LSgXoIxEoELwnVK+5i6wNsla7+o6/mVWf4PV/UuHzAU=;
        b=nIuzWpLYx4rwHITw8pC4wKzopC2uXvwHmytRoZ1NlD8KBnSHcFevRkNP3VINJ2gt7b
         C4T1e2HgFrJumxHU1sf/LruiaoZwh3J8EvJVLPgaqn4cc3FG6w8FtxGB8fyuaXXja/mz
         hhm/msBHg24z1iqOhfQ/sli+sK8hve0UnFt1Y0oOJbdwNAiCc8272jjDqIgt3kN7xJ4o
         dUMFPDdSOduglZVw1rktbC61FXy3wzVOKl67ReaEFSZ8VIrNK5hS2QC5T8BnLoFLv1j8
         uH4xGI+g/g1pRXRIerKnKsKgIZ2EfU4JGSAHjZSc7fjXJblqMoceTWlhvYhVrkAwuOw/
         XINg==
X-Gm-Message-State: ANhLgQ3/DLz//2on8MoThiDPVb7Cp0hf7E/2tQzuBpX5tEj5CchF7iwu
        JXSxm3ShJDPCwqP7edMNCmjhKgWI
X-Google-Smtp-Source: ADFU+vuRiRXr2tj7Dmd4IsXWfIVZ4csYqmObfzyzlnx/3vxSwaMf2YSLKvLO7hnjQDqRXFaYmh8/RQ==
X-Received: by 2002:a63:3e02:: with SMTP id l2mr5597212pga.284.1585283163096;
        Thu, 26 Mar 2020 21:26:03 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id y17sm3004647pfl.104.2020.03.26.21.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 21:26:02 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com, kafai@fb.com
Subject: [PATCHv3 bpf-next 3/5] bpf: Don't refcount LISTEN sockets in sk_assign()
Date:   Thu, 26 Mar 2020 21:25:54 -0700
Message-Id: <20200327042556.11560-4-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200327042556.11560-1-joe@wand.net.nz>
References: <20200327042556.11560-1-joe@wand.net.nz>
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
---
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
index 2bcc29c1a595..fb73e6452c91 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5343,8 +5343,7 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
 
 BPF_CALL_1(bpf_sk_release, struct sock *, sk)
 {
-	/* Only full sockets have sk->sk_flags. */
-	if (!sk_fullsock(sk) || !sock_flag(sk, SOCK_RCU_FREE))
+	if (sk_is_refcounted(sk))
 		sock_gen_put(sk);
 	return 0;
 }
@@ -5870,7 +5869,8 @@ BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
 		return -ENETUNREACH;
 	if (unlikely(sk->sk_reuseport))
 		return -ESOCKTNOSUPPORT;
-	if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
+	if (sk_is_refcounted(sk) &&
+	    unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
 		return -ENOENT;
 
 	skb_orphan(skb);
diff --git a/net/core/sock.c b/net/core/sock.c
index cfaf60267360..a2ab79446f59 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2076,7 +2076,8 @@ EXPORT_SYMBOL(sock_efree);
  */
 void sock_pfree(struct sk_buff *skb)
 {
-	sock_edemux(skb);
+	if (sk_is_refcounted(skb->sk))
+		sock_edemux(skb);
 }
 EXPORT_SYMBOL(sock_pfree);
 
-- 
2.20.1

