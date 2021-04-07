Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61D83561D6
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 05:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238994AbhDGDVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 23:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbhDGDVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 23:21:34 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3C6C06174A;
        Tue,  6 Apr 2021 20:21:23 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id c3so17372380qkc.5;
        Tue, 06 Apr 2021 20:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5P9yhB2ipajvGPZkRP/J5oDNtkEzGGHrQDNL3q9n6sQ=;
        b=rgzdrHFN+NjBsU+o+0mM2dHwX4NGkabQTyE4g9xBhSfG/aqEPgRlM9CYAHaFbsEdtZ
         7JWWTpOv/yahBlKrv/RBUpN7XNh4LnqaBCzcXoD+73HsaFrgMJ17DN8Ro6ZQh33iXnlL
         BiVvp/jUYX+3vqRgF8qiwjf2gJ+uxuyEtVlmPSqG1azcLTQMocZOuZzTT+jqIEwKGQCh
         cbU+mKBBqNswD0WREZVTlcPW2FP+hQAreoyV8VRADilBnJ+WCUcbkSQQk8RgvubJIFHz
         yLqBYcXFmgiNoEtSDW0pQyGEYXEn9eMom0H0dakk8T5RSKuW5COTQzIf1khhDqvI2vBg
         PXIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5P9yhB2ipajvGPZkRP/J5oDNtkEzGGHrQDNL3q9n6sQ=;
        b=P6Jo8HxFMQ/og+hCa6fEt3lyM0qCS/5U5wyjcDQ7F6+j9RqBm9UMzVXcctiLOlGlN2
         +fy9sU90xytguQkm8d2E1HTmZ4s4bABoHg9nPelDatjFDImcNPFYpivCLQpshapB6XkK
         Uh/SbIDhNNMOcehycdfd78twLyWtC0Raj4jZBF6PFyxmt/94VE13/ILxnCneLpCkgDE6
         k37gVxA8MxV+nPllE1L+NdXhmGd82yt0zWkL2125GtxDnYkGmIgW50ROhy+Niuwh/Qju
         783BfAGP8Lgp8r1hKLWEUUhJwFv4byY4jR9x47OWEvkz79JnkELfnE8NIkHRz/tKZ/QF
         26mA==
X-Gm-Message-State: AOAM531BOzV7i3Eot2WR4JOVJJe+YHgfTle/GFoDCvJwMr0l30XHu1tJ
        DdOV8B9Jrh6A6RPjCXlWUxsxuXSWB1QR655t
X-Google-Smtp-Source: ABdhPJxJ00tR3gql7/Ti0r5AW1lR1bCzH+teuPcFhRDOxepFmHCqIYGFzbz/XEhjoB3k8/DVVoRx3Q==
X-Received: by 2002:a37:6c01:: with SMTP id h1mr1213547qkc.182.1617765682553;
        Tue, 06 Apr 2021 20:21:22 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id y13sm16189989qto.39.2021.04.06.20.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 20:21:22 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        syzbot+320a3bc8d80f478c37e4@syzkaller.appspotmail.com,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next] skmsg: pass psock pointer to ->psock_update_sk_prot()
Date:   Tue,  6 Apr 2021 20:21:11 -0700
Message-Id: <20210407032111.33398-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Using sk_psock() to retrieve psock pointer from sock requires
RCU read lock, but we already get psock pointer before calling
->psock_update_sk_prot() in both cases, so we can just pass it
without bothering sk_psock().

Reported-and-tested-by: syzbot+320a3bc8d80f478c37e4@syzkaller.appspotmail.com
Fixes: 8a59f9d1e3d4 ("sock: Introduce sk->sk_prot->psock_update_sk_prot()")
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h | 5 +++--
 include/net/sock.h    | 5 ++++-
 include/net/tcp.h     | 2 +-
 include/net/udp.h     | 2 +-
 net/core/sock_map.c   | 2 +-
 net/ipv4/tcp_bpf.c    | 3 +--
 net/ipv4/udp_bpf.c    | 3 +--
 7 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index f78e90a04a69..e2fb0a5a101e 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -99,7 +99,8 @@ struct sk_psock {
 	void (*saved_close)(struct sock *sk, long timeout);
 	void (*saved_write_space)(struct sock *sk);
 	void (*saved_data_ready)(struct sock *sk);
-	int  (*psock_update_sk_prot)(struct sock *sk, bool restore);
+	int  (*psock_update_sk_prot)(struct sock *sk, struct sk_psock *psock,
+				     bool restore);
 	struct proto			*sk_proto;
 	struct mutex			work_mutex;
 	struct sk_psock_work_state	work_state;
@@ -405,7 +406,7 @@ static inline void sk_psock_restore_proto(struct sock *sk,
 {
 	sk->sk_prot->unhash = psock->saved_unhash;
 	if (psock->psock_update_sk_prot)
-		psock->psock_update_sk_prot(sk, true);
+		psock->psock_update_sk_prot(sk, psock, true);
 }
 
 static inline void sk_psock_set_state(struct sk_psock *psock,
diff --git a/include/net/sock.h b/include/net/sock.h
index 8b4155e756c2..c4bbdcd83f4d 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1114,6 +1114,7 @@ struct inet_hashinfo;
 struct raw_hashinfo;
 struct smc_hashinfo;
 struct module;
+struct sk_psock;
 
 /*
  * caches using SLAB_TYPESAFE_BY_RCU should let .next pointer from nulls nodes
@@ -1185,7 +1186,9 @@ struct proto {
 	void			(*rehash)(struct sock *sk);
 	int			(*get_port)(struct sock *sk, unsigned short snum);
 #ifdef CONFIG_BPF_SYSCALL
-	int			(*psock_update_sk_prot)(struct sock *sk, bool restore);
+	int			(*psock_update_sk_prot)(struct sock *sk,
+							struct sk_psock *psock,
+							bool restore);
 #endif
 
 	/* Keeping track of sockets in use */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index eaea43afcc97..d05193cb0d99 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2215,7 +2215,7 @@ struct sk_psock;
 
 #ifdef CONFIG_BPF_SYSCALL
 struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
-int tcp_bpf_update_proto(struct sock *sk, bool restore);
+int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
 void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
 #endif /* CONFIG_BPF_SYSCALL */
 
diff --git a/include/net/udp.h b/include/net/udp.h
index f55aaeef7e91..360df454356c 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -543,7 +543,7 @@ static inline void udp_post_segment_fix_csum(struct sk_buff *skb)
 #ifdef CONFIG_BPF_SYSCALL
 struct sk_psock;
 struct proto *udp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
-int udp_bpf_update_proto(struct sock *sk, bool restore);
+int udp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
 #endif
 
 #endif	/* _UDP_H */
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 3d190d22b0d8..f473c51cbc4b 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -188,7 +188,7 @@ static int sock_map_init_proto(struct sock *sk, struct sk_psock *psock)
 	if (!sk->sk_prot->psock_update_sk_prot)
 		return -EINVAL;
 	psock->psock_update_sk_prot = sk->sk_prot->psock_update_sk_prot;
-	return sk->sk_prot->psock_update_sk_prot(sk, false);
+	return sk->sk_prot->psock_update_sk_prot(sk, psock, false);
 }
 
 static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 3d622a0d0753..4930bc8ab47e 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -499,9 +499,8 @@ static int tcp_bpf_assert_proto_ops(struct proto *ops)
 	       ops->sendpage == tcp_sendpage ? 0 : -ENOTSUPP;
 }
 
-int tcp_bpf_update_proto(struct sock *sk, bool restore)
+int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 {
-	struct sk_psock *psock = sk_psock(sk);
 	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
 	int config = psock->progs.msg_parser   ? TCP_BPF_TX   : TCP_BPF_BASE;
 
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index 4a7e38c5d842..954c4591a6fd 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -103,10 +103,9 @@ static int __init udp_bpf_v4_build_proto(void)
 }
 core_initcall(udp_bpf_v4_build_proto);
 
-int udp_bpf_update_proto(struct sock *sk, bool restore)
+int udp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 {
 	int family = sk->sk_family == AF_INET ? UDP_BPF_IPV4 : UDP_BPF_IPV6;
-	struct sk_psock *psock = sk_psock(sk);
 
 	if (restore) {
 		sk->sk_write_space = psock->saved_write_space;
-- 
2.25.1

