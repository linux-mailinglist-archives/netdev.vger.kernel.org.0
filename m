Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11A92D37D2
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 05:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfJKDS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 23:18:27 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:32878 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbfJKDS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 23:18:26 -0400
Received: by mail-pl1-f201.google.com with SMTP id d2so5177726pll.0
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 20:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3eV3YWRRjRq6E1Ps6X/vhhPJX+AuA+BAZelhywhpWmU=;
        b=hsophCyJDpMFvC4xVDbrVOl51SMSNL/FxQcBx2x2J+p7MDMpHC6eYdsBVMm0mZb4AH
         zeoEC0M0VMvAIeVMncP1P48lbQ9poa7h8EEpVK01FtN+HU1fdPIlS4az4/F+W9Alw785
         wK8xEiktqwhy2Ovbz3JM7CzDQbvve/yyjpt0hoRZmU7X7xWFRB4Uel4YF3qy5ewGjh5S
         doAchZmQMhM8xiDPEla4iAn14/m6zrrNWDuwei3ILxwY6zT51kwRKTWvb9cLGI7Ek64q
         5OrYhqnfaDOBqcY9JqVgpoybPUKEjWRISWJ/8YaOx0HPPVfrsP/Zcmxa1WVG6KDFVoKI
         h6zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3eV3YWRRjRq6E1Ps6X/vhhPJX+AuA+BAZelhywhpWmU=;
        b=godCCa6ybMr+jXfzsCz5DuGKYLiGzHdK6Z6mAxhHnAqwkYkQoaPstoYvApFelFpxjz
         iXZH1BA4rui300dUAUmRQteER0C1zoM5S4WdrCQumfbRD4VxvmTMMPOFTkIcWYANt1VZ
         aBqEpxFGLljRBJxq/sq/0B47/EnV7nDUplHTf1kVviT1s6c7u/q1tr6EhnxpuGtF/gN6
         rCHA4eL3isr++VvYItt9BiaZbKUwczpq/EgPH75zqKKpwl/ppYRRgJp8JxjhP2SYOZaS
         qTLh/tebY5MdfKzzJx6KyMWTDPVK8UBrzTdlxQTeYG3fXckEZm3Wb1yMLw2qwUNngEdW
         xCxw==
X-Gm-Message-State: APjAAAW//Gi5XatPRZkQ3hODuM/p3eDNqGGmZluopuVpN88vdirKpG9z
        PsP9D3QtoeoG7XZDkTcND9q5BvATdXyvQA==
X-Google-Smtp-Source: APXvYqyBJgaSTTgvZGJInJGwi7FWGx3c7Ny9d6/tIjz70rAyzoRkmbDKXvIHFV5DoFiLVcV5Ft3bImCcFxJjWg==
X-Received: by 2002:a63:4f06:: with SMTP id d6mr14359976pgb.157.1570763905853;
 Thu, 10 Oct 2019 20:18:25 -0700 (PDT)
Date:   Thu, 10 Oct 2019 20:17:45 -0700
In-Reply-To: <20191011031746.16220-1-edumazet@google.com>
Message-Id: <20191011031746.16220-9-edumazet@google.com>
Mime-Version: 1.0
References: <20191011031746.16220-1-edumazet@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH net 8/9] tcp: annotate sk->sk_sndbuf lockless reads
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the sake of tcp_poll(), there are few places where we fetch
sk->sk_sndbuf while this field can change from IRQ or other cpu.

We need to add READ_ONCE() annotations, and also make sure write
sides use corresponding WRITE_ONCE() to avoid store-tearing.

Note that other transports probably need similar fixes.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h   | 18 +++++++++++-------
 net/core/filter.c    |  3 ++-
 net/core/sock.c      | 15 +++++++++------
 net/ipv4/tcp.c       |  2 +-
 net/ipv4/tcp_input.c |  3 ++-
 5 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 79f54e1f88277dc7cc64ca0f35fd5ba869a2f96d..3d1e7502333e7ea0ff866f8982048800193caf33 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -883,7 +883,7 @@ static inline int sk_stream_min_wspace(const struct sock *sk)
 
 static inline int sk_stream_wspace(const struct sock *sk)
 {
-	return sk->sk_sndbuf - sk->sk_wmem_queued;
+	return READ_ONCE(sk->sk_sndbuf) - sk->sk_wmem_queued;
 }
 
 void sk_stream_write_space(struct sock *sk);
@@ -1207,7 +1207,7 @@ static inline void sk_refcnt_debug_release(const struct sock *sk)
 
 static inline bool __sk_stream_memory_free(const struct sock *sk, int wake)
 {
-	if (sk->sk_wmem_queued >= sk->sk_sndbuf)
+	if (sk->sk_wmem_queued >= READ_ONCE(sk->sk_sndbuf))
 		return false;
 
 	return sk->sk_prot->stream_memory_free ?
@@ -2220,10 +2220,14 @@ static inline void sk_wake_async(const struct sock *sk, int how, int band)
 
 static inline void sk_stream_moderate_sndbuf(struct sock *sk)
 {
-	if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK)) {
-		sk->sk_sndbuf = min(sk->sk_sndbuf, sk->sk_wmem_queued >> 1);
-		sk->sk_sndbuf = max_t(u32, sk->sk_sndbuf, SOCK_MIN_SNDBUF);
-	}
+	u32 val;
+
+	if (sk->sk_userlocks & SOCK_SNDBUF_LOCK)
+		return;
+
+	val = min(sk->sk_sndbuf, sk->sk_wmem_queued >> 1);
+
+	WRITE_ONCE(sk->sk_sndbuf, max_t(u32, val, SOCK_MIN_SNDBUF));
 }
 
 struct sk_buff *sk_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
@@ -2251,7 +2255,7 @@ bool sk_page_frag_refill(struct sock *sk, struct page_frag *pfrag);
  */
 static inline bool sock_writeable(const struct sock *sk)
 {
-	return refcount_read(&sk->sk_wmem_alloc) < (sk->sk_sndbuf >> 1);
+	return refcount_read(&sk->sk_wmem_alloc) < (READ_ONCE(sk->sk_sndbuf) >> 1);
 }
 
 static inline gfp_t gfp_any(void)
diff --git a/net/core/filter.c b/net/core/filter.c
index 7deceaeeed7bace2bb805d110190b98819cfc7b1..3fed5755494bd39cf55ca1806ead67609ae8b587 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4258,7 +4258,8 @@ BPF_CALL_5(bpf_setsockopt, struct bpf_sock_ops_kern *, bpf_sock,
 		case SO_SNDBUF:
 			val = min_t(u32, val, sysctl_wmem_max);
 			sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
-			sk->sk_sndbuf = max_t(int, val * 2, SOCK_MIN_SNDBUF);
+			WRITE_ONCE(sk->sk_sndbuf,
+				   max_t(int, val * 2, SOCK_MIN_SNDBUF));
 			break;
 		case SO_MAX_PACING_RATE: /* 32bit version */
 			if (val != ~0U)
diff --git a/net/core/sock.c b/net/core/sock.c
index 8c8f61e70141583afe52420b58fea4bcce3a74f0..cd075bc86407a5816bd448521955525ebe941694 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -785,7 +785,8 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		 */
 		val = min_t(int, val, INT_MAX / 2);
 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
-		sk->sk_sndbuf = max_t(int, val * 2, SOCK_MIN_SNDBUF);
+		WRITE_ONCE(sk->sk_sndbuf,
+			   max_t(int, val * 2, SOCK_MIN_SNDBUF));
 		/* Wake up sending tasks if we upped the value. */
 		sk->sk_write_space(sk);
 		break;
@@ -2089,8 +2090,10 @@ EXPORT_SYMBOL(sock_i_ino);
 struct sk_buff *sock_wmalloc(struct sock *sk, unsigned long size, int force,
 			     gfp_t priority)
 {
-	if (force || refcount_read(&sk->sk_wmem_alloc) < sk->sk_sndbuf) {
+	if (force ||
+	    refcount_read(&sk->sk_wmem_alloc) < READ_ONCE(sk->sk_sndbuf)) {
 		struct sk_buff *skb = alloc_skb(size, priority);
+
 		if (skb) {
 			skb_set_owner_w(skb, sk);
 			return skb;
@@ -2191,7 +2194,7 @@ static long sock_wait_for_wmem(struct sock *sk, long timeo)
 			break;
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
-		if (refcount_read(&sk->sk_wmem_alloc) < sk->sk_sndbuf)
+		if (refcount_read(&sk->sk_wmem_alloc) < READ_ONCE(sk->sk_sndbuf))
 			break;
 		if (sk->sk_shutdown & SEND_SHUTDOWN)
 			break;
@@ -2226,7 +2229,7 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 		if (sk->sk_shutdown & SEND_SHUTDOWN)
 			goto failure;
 
-		if (sk_wmem_alloc_get(sk) < sk->sk_sndbuf)
+		if (sk_wmem_alloc_get(sk) < READ_ONCE(sk->sk_sndbuf))
 			break;
 
 		sk_set_bit(SOCKWQ_ASYNC_NOSPACE, sk);
@@ -2807,7 +2810,7 @@ static void sock_def_write_space(struct sock *sk)
 	/* Do not wake up a writer until he can make "significant"
 	 * progress.  --DaveM
 	 */
-	if ((refcount_read(&sk->sk_wmem_alloc) << 1) <= sk->sk_sndbuf) {
+	if ((refcount_read(&sk->sk_wmem_alloc) << 1) <= READ_ONCE(sk->sk_sndbuf)) {
 		wq = rcu_dereference(sk->sk_wq);
 		if (skwq_has_sleeper(wq))
 			wake_up_interruptible_sync_poll(&wq->wait, EPOLLOUT |
@@ -3207,7 +3210,7 @@ void sk_get_meminfo(const struct sock *sk, u32 *mem)
 	mem[SK_MEMINFO_RMEM_ALLOC] = sk_rmem_alloc_get(sk);
 	mem[SK_MEMINFO_RCVBUF] = READ_ONCE(sk->sk_rcvbuf);
 	mem[SK_MEMINFO_WMEM_ALLOC] = sk_wmem_alloc_get(sk);
-	mem[SK_MEMINFO_SNDBUF] = sk->sk_sndbuf;
+	mem[SK_MEMINFO_SNDBUF] = READ_ONCE(sk->sk_sndbuf);
 	mem[SK_MEMINFO_FWD_ALLOC] = sk->sk_forward_alloc;
 	mem[SK_MEMINFO_WMEM_QUEUED] = sk->sk_wmem_queued;
 	mem[SK_MEMINFO_OPTMEM] = atomic_read(&sk->sk_omem_alloc);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bc0481aa6633c0c871c57a89d38ef57734b51f12..11185326297211bee3746edd725d106643b78720 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -450,7 +450,7 @@ void tcp_init_sock(struct sock *sk)
 
 	icsk->icsk_sync_mss = tcp_sync_mss;
 
-	sk->sk_sndbuf = sock_net(sk)->ipv4.sysctl_tcp_wmem[1];
+	WRITE_ONCE(sk->sk_sndbuf, sock_net(sk)->ipv4.sysctl_tcp_wmem[1]);
 	WRITE_ONCE(sk->sk_rcvbuf, sock_net(sk)->ipv4.sysctl_tcp_rmem[1]);
 
 	sk_sockets_allocated_inc(sk);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 6995df20710a7bf48d9aca88c14e5980f4fc9615..a2e52ad7cdab3e66a469a8ca850848988b3888d7 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -359,7 +359,8 @@ static void tcp_sndbuf_expand(struct sock *sk)
 	sndmem *= nr_segs * per_mss;
 
 	if (sk->sk_sndbuf < sndmem)
-		sk->sk_sndbuf = min(sndmem, sock_net(sk)->ipv4.sysctl_tcp_wmem[2]);
+		WRITE_ONCE(sk->sk_sndbuf,
+			   min(sndmem, sock_net(sk)->ipv4.sysctl_tcp_wmem[2]));
 }
 
 /* 2. Tuning advertised window (window_clamp, rcv_ssthresh)
-- 
2.23.0.700.g56cf767bdb-goog

