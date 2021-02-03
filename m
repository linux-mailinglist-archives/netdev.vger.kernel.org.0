Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B8C30D27C
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbhBCETi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:19:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbhBCESY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:18:24 -0500
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4028C061793;
        Tue,  2 Feb 2021 20:17:07 -0800 (PST)
Received: by mail-oo1-xc30.google.com with SMTP id y21so2387069oot.12;
        Tue, 02 Feb 2021 20:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hu2PSvf1ubuS5CTlM1297EMYv4VI1bTTMBsgsZV1bMQ=;
        b=Xopi7NxJGZjMD6E96E6Zwqp1FGbnAnTTS9fpOU3UDAKc2HXN/q98ycxqbFqFn41q7v
         gzbQJQKHI3E+lfnNWYHG8HhpaofH6PI29MpySujaIcGP0REiKB0Xi/dQgUD5WPJy5YA0
         mg4nVdrQlP7nkWt0IsXg0tVTKQkW0wCaKJFCzaQI9zzHDGEm6WVpAVgxjlApeyDUTown
         0bE0SNP3/GlLFfd/tXKz5PA4xZRLJwhBpRQpYqTtbv9IA0jjjRFxcu0541J6/qvqS8LX
         R8tquy6MKOVbFa+En0bk2xBqtCigC2yXb8oq1NT2cyooKQASt/3JFSTEiRT+IWvuK3TU
         HXQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hu2PSvf1ubuS5CTlM1297EMYv4VI1bTTMBsgsZV1bMQ=;
        b=ZK587+h5oaGcJeGc2VSUKe8rOzwOGFW4SeVS+/6exOZ3T1caMsUmC+fySNVEtLUlii
         sHpDGhgFf1G0pslglVSP9Y09wv6/0BtuEjVO3MvRJJIjhOqUIHgsKgBH3szdJGoX7DBS
         LqH8PGpeCQ63tRCnYAq8qrHT0cl6kvWknmgRgZeaPrQV0woxxhFOAnYjsgzGSBDhPYaf
         71T/UT0ikalPJcrmWjmev6tC5OgaGj6wZZgX4MLFUlvCbA0L1XRMP/xXy4WVFaSP4QAK
         thfxmI/0sw3QiqwYA+37HyRxJ9r0kEp51moy7s1BFs0xLZIYysdZ0yGG4T9r3mIqHlse
         dWVw==
X-Gm-Message-State: AOAM532rWY7fmF3z12PgTdVOZcyP5ufqpjqNnpMX/r8ZugvWMmNI7OXa
        sHnPxfnmM3MGt97vyozbRlFSaGNpkbv8nw==
X-Google-Smtp-Source: ABdhPJwYbPn6zl136gqq8TKcxOfa7RepL+MBrMNS/3yzIgNRTS22izXE3VQPaSHuLulohXaKev/aoA==
X-Received: by 2002:a4a:d1de:: with SMTP id a30mr810423oos.43.1612325827011;
        Tue, 02 Feb 2021 20:17:07 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:90c4:ffea:6079:8a0c])
        by smtp.gmail.com with ESMTPSA id s10sm209978ool.35.2021.02.02.20.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 20:17:06 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next 09/19] udp: add ->read_sock() and ->sendmsg_locked() to ipv6
Date:   Tue,  2 Feb 2021 20:16:26 -0800
Message-Id: <20210203041636.38555-10-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
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
index 6dffbcec0b51..3acb1be73131 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1825,6 +1825,7 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
 
 	return copied;
 }
+EXPORT_SYMBOL(udp_read_sock);
 
 /*
  * 	This should be easy, if there is something there we
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index f091fe9b4da5..63c2d024f572 100644
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
index 66ebdfc83c95..c52ea171060d 100644
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

