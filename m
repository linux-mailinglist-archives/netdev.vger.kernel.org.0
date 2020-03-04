Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE739178E3E
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 11:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388007AbgCDKOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 05:14:34 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39161 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728946AbgCDKNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 05:13:41 -0500
Received: by mail-lf1-f66.google.com with SMTP id n30so1017848lfh.6
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 02:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WcIJ9lCZ97FXYirMRy6aCjRDlIzgj0wNvh43wB0M0DM=;
        b=q2ophHX5EW/6f77pOSGjfwqstKPYYFPktGOeNJbubRG0sfZQD+z5bDrME56aNqyBmH
         hcSuI3wctqMT4PzPXjaAOgeavEWUsTqSypIow6YYY8x3eKBLhGpGJU8nZFWCfsqv4nlg
         646DypBctCYqT5DueCkyVr3/6mc9Xmd6mL0Dw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WcIJ9lCZ97FXYirMRy6aCjRDlIzgj0wNvh43wB0M0DM=;
        b=rjareZdIkkqmvUA+kdU7qk4fN05OCH6Ho7S5UsArsISfF/TccnKMFFVsiut0dorQTr
         gqglFoCsqW1QyeCPo+ZxEKQljSa6AYyjUPE7x+kjHJ91cQyKEKXkb96hwGZekMfM0Ubu
         pn90Bj1bf51WsGi5TpstE6m3oejzMmBcWihgidJNbNAeCw5ThWvosi02o+bdcuLRTspW
         kgRcug+dUI0hhmNlZw2X+yQdUlHCI57D2pAdfJEh/U2qJZzsWguh515zcO7qhpk+1iRN
         xsrYek2tVsp/cW0L923oh/2uEKsn8j6s62lmqXpFTtr0F8YBkjK/ENG3b8hQHt8Rdy2A
         Yy1A==
X-Gm-Message-State: ANhLgQ0ALz1s4te6uDvt+6FaX76n4WfGolmwyHtEDxnw3OXaKSBRC/4c
        343xfdeqSOiMrRG5olavo5u7IQ==
X-Google-Smtp-Source: ADFU+vs/CTV/qo8RUQFXEsrJ/JkI3oT0QA0rJ1qLhtmshs+jh7HdlgfS2Yqr2gnhT3u+9ckrBuotJQ==
X-Received: by 2002:a19:c515:: with SMTP id w21mr1579786lfe.169.1583316819485;
        Wed, 04 Mar 2020 02:13:39 -0800 (PST)
Received: from localhost.localdomain ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id l7sm341777lfk.65.2020.03.04.02.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 02:13:38 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     john.fastabend@gmail.com, Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 02/12] skmsg: update saved hooks only once
Date:   Wed,  4 Mar 2020 11:13:07 +0100
Message-Id: <20200304101318.5225-3-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200304101318.5225-1-lmb@cloudflare.com>
References: <20200304101318.5225-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only update psock->saved_* if psock->sk_proto has not been initialized
yet. This allows us to get rid of tcp_bpf_reinit_sk_prot.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 include/linux/skmsg.h | 20 ++++++++++++++++----
 net/ipv4/tcp_bpf.c    | 16 +---------------
 2 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 4d3d75d63066..2be51b7a5800 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -347,11 +347,23 @@ static inline void sk_psock_update_proto(struct sock *sk,
 					 struct sk_psock *psock,
 					 struct proto *ops)
 {
-	psock->saved_unhash = sk->sk_prot->unhash;
-	psock->saved_close = sk->sk_prot->close;
-	psock->saved_write_space = sk->sk_write_space;
+	/* Initialize saved callbacks and original proto only once, since this
+	 * function may be called multiple times for a psock, e.g. when
+	 * psock->progs.msg_parser is updated.
+	 *
+	 * Since we've not installed the new proto, psock is not yet in use and
+	 * we can initialize it without synchronization.
+	 */
+	if (!psock->sk_proto) {
+		struct proto *orig = READ_ONCE(sk->sk_prot);
+
+		psock->saved_unhash = orig->unhash;
+		psock->saved_close = orig->close;
+		psock->saved_write_space = sk->sk_write_space;
+
+		psock->sk_proto = orig;
+	}
 
-	psock->sk_proto = sk->sk_prot;
 	/* Pairs with lockless read in sk_clone_lock() */
 	WRITE_ONCE(sk->sk_prot, ops);
 }
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 7d6e1b75d4d4..3327afa05c3d 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -637,20 +637,6 @@ static void tcp_bpf_update_sk_prot(struct sock *sk, struct sk_psock *psock)
 	sk_psock_update_proto(sk, psock, &tcp_bpf_prots[family][config]);
 }
 
-static void tcp_bpf_reinit_sk_prot(struct sock *sk, struct sk_psock *psock)
-{
-	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
-	int config = psock->progs.msg_parser   ? TCP_BPF_TX   : TCP_BPF_BASE;
-
-	/* Reinit occurs when program types change e.g. TCP_BPF_TX is removed
-	 * or added requiring sk_prot hook updates. We keep original saved
-	 * hooks in this case.
-	 *
-	 * Pairs with lockless read in sk_clone_lock().
-	 */
-	WRITE_ONCE(sk->sk_prot, &tcp_bpf_prots[family][config]);
-}
-
 static int tcp_bpf_assert_proto_ops(struct proto *ops)
 {
 	/* In order to avoid retpoline, we make assumptions when we call
@@ -670,7 +656,7 @@ void tcp_bpf_reinit(struct sock *sk)
 
 	rcu_read_lock();
 	psock = sk_psock(sk);
-	tcp_bpf_reinit_sk_prot(sk, psock);
+	tcp_bpf_update_sk_prot(sk, psock);
 	rcu_read_unlock();
 }
 
-- 
2.20.1

