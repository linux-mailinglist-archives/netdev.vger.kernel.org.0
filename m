Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C74332A30C
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377960AbhCBIpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444090AbhCBCj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 21:39:27 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB22C061797;
        Mon,  1 Mar 2021 18:38:01 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id e45so18583741ote.9;
        Mon, 01 Mar 2021 18:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DKj01eWVlyMr7t8j3UxFWe5D/QCYMBC3DYw8jt3wc38=;
        b=FAgVdAJRK+htc197BZv5jzLqwNSdsPRuI5cQIlmQb8koGHt/4ATutydJCIL6a0sJq+
         CZjipKEx7a9+aw7vCGKj4lJdqfBts52qGFT1u7J/rGFNIxpLK723SvRs81r7VQJF7chw
         5uY2hCSapZpC63Uv4yLPraabrSWf1jK1yc3YTsCy7Onq1PLFrYMRvmZzg8AOcHI2C/Hi
         MkAtkQdYySKx3bOpkM8GdsmydWk5QaF8bxEqJpgm6owYJjkXAwcY5ii9KCCdVAOWqNXX
         r/KZ9GzZmzCnmTG907bv/M7z9A72bMzW4sgyJyjEEDc+Wg3RDZ6UpXnkqCkmDAMXj+B9
         cQEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DKj01eWVlyMr7t8j3UxFWe5D/QCYMBC3DYw8jt3wc38=;
        b=pDNPWhbMMIMoNafjozq1IWCUWh7zBdMea/0LGVQkEQa/Q6e17G/AizQ2yOmB9pID/m
         3K6HqdZ+6to/qiOJG4O66pOcmYSFqggvP37TVNMuK3IwIpHO4r6L75NhFIh3SqSPyZct
         SUQD3au6sGlnZ7Xf7AHh2kz6QRetXsY8nF0+AMtPa4kkrKMsQfypT5n6r6q1hJeJ+ZhS
         V+svHmjtauRcfinIVIms3vc70zE6EgEG9kyqhqdkIUXA5CezJgAomN38hHScZSgQ8wRK
         7e4HBnDpS4XFCTSmA3wpZZv4rIaDpkmoR1fbOkOL66+gUAWXHc9j4zjn33hf214Ly0nH
         ie/g==
X-Gm-Message-State: AOAM533IkEfSmDu3aQB6T5bnJFvgOn44dDvPhhw5BtRZc8lZv+N3PUUH
        dQlWMxW45p4nfDKWd3KfcBAmm7neiGD9CQ==
X-Google-Smtp-Source: ABdhPJxl364A77qIEiNxquKriNtmsuqro4z1JbWTetSSemI97XdnatzgkUuasG3TrYcOMYE5NpzskQ==
X-Received: by 2002:a9d:7519:: with SMTP id r25mr16133568otk.172.1614652680517;
        Mon, 01 Mar 2021 18:38:00 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1bb:8d29:39ef:5fe5])
        by smtp.gmail.com with ESMTPSA id a30sm100058oiy.42.2021.03.01.18.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 18:38:00 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v2 5/9] udp: add ->read_sock() and ->sendmsg_locked() to ipv6
Date:   Mon,  1 Mar 2021 18:37:39 -0800
Message-Id: <20210302023743.24123-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Similarly, udpv6_sendmsg() takes lock_sock() inside too,
we have to build ->sendmsg_locked() on top of it.

For ->read_sock(), we can just use udp_read_sock().

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/net/ipv6.h  |  1 +
 net/ipv4/udp.c      |  1 +
 net/ipv6/af_inet6.c |  2 ++
 net/ipv6/udp.c      | 27 +++++++++++++++++++++------
 4 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index bd1f396cc9c7..48b6850dae85 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1119,6 +1119,7 @@ int inet6_hash_connect(struct inet_timewait_death_row *death_row,
 int inet6_sendmsg(struct socket *sock, struct msghdr *msg, size_t size);
 int inet6_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		  int flags);
+int udpv6_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t len);
 
 /*
  * reassembly.c
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 54f24b1d4f65..717c543aaec3 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1831,6 +1831,7 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
 
 	return copied;
 }
+EXPORT_SYMBOL(udp_read_sock);
 
 /*
  * 	This should be easy, if there is something there we
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 1fb75f01756c..634ab3a825d7 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -714,7 +714,9 @@ const struct proto_ops inet6_dgram_ops = {
 	.setsockopt	   = sock_common_setsockopt,	/* ok		*/
 	.getsockopt	   = sock_common_getsockopt,	/* ok		*/
 	.sendmsg	   = inet6_sendmsg,		/* retpoline's sake */
+	.sendmsg_locked	   = udpv6_sendmsg_locked,
 	.recvmsg	   = inet6_recvmsg,		/* retpoline's sake */
+	.read_sock	   = udp_read_sock,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = sock_no_sendpage,
 	.set_peek_off	   = sk_set_peek_off,
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 105ba0cf739d..4372597bc271 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1272,7 +1272,7 @@ static int udp_v6_push_pending_frames(struct sock *sk)
 	return err;
 }
 
-int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+static int __udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len, bool locked)
 {
 	struct ipv6_txoptions opt_space;
 	struct udp_sock *up = udp_sk(sk);
@@ -1361,7 +1361,8 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		 * There are pending frames.
 		 * The socket lock must be held while it's corked.
 		 */
-		lock_sock(sk);
+		if (!locked)
+			lock_sock(sk);
 		if (likely(up->pending)) {
 			if (unlikely(up->pending != AF_INET6)) {
 				release_sock(sk);
@@ -1370,7 +1371,8 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			dst = NULL;
 			goto do_append_data;
 		}
-		release_sock(sk);
+		if (!locked)
+			release_sock(sk);
 	}
 	ulen += sizeof(struct udphdr);
 
@@ -1533,11 +1535,13 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		goto out;
 	}
 
-	lock_sock(sk);
+	if (!locked)
+		lock_sock(sk);
 	if (unlikely(up->pending)) {
 		/* The socket is already corked while preparing it. */
 		/* ... which is an evident application bug. --ANK */
-		release_sock(sk);
+		if (!locked)
+			release_sock(sk);
 
 		net_dbg_ratelimited("udp cork app bug 2\n");
 		err = -EINVAL;
@@ -1562,7 +1566,8 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	if (err > 0)
 		err = np->recverr ? net_xmit_errno(err) : 0;
-	release_sock(sk);
+	if (!locked)
+		release_sock(sk);
 
 out:
 	dst_release(dst);
@@ -1593,6 +1598,16 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	goto out;
 }
 
+int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+{
+	return __udpv6_sendmsg(sk, msg, len, false);
+}
+
+int udpv6_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t len)
+{
+	return __udpv6_sendmsg(sk, msg, len, true);
+}
+
 void udpv6_destroy_sock(struct sock *sk)
 {
 	struct udp_sock *up = udp_sk(sk);
-- 
2.25.1

