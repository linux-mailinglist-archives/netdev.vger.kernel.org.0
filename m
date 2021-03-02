Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A72532A2E5
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377877AbhCBIlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443988AbhCBCil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 21:38:41 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA85C061793;
        Mon,  1 Mar 2021 18:37:58 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id o3so20440864oic.8;
        Mon, 01 Mar 2021 18:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1+nWbH2X4eUskfN7h2bAJQ0jwGDRaEfpm7mVkpF/v2w=;
        b=ROtSuaqMLfI54kztrhx/vsjFPBVqHWxu/JRtbSOqxVPOL2vSfNQ1tF5wrclB3nYran
         qgtGrmHIeMIKuwctWgN3e4e5BZOsT6J79dLp75zY/3QZb7gWhhDPhV8Bs9WGMfJtZeoz
         HoBhRstYP5lkW8nOVRchom9uagH0cOE2CXbZpwPS6aFkCBeUqu3S9uxRtoWCGsa1MJiu
         jia5Or8GlJvhT+C1/FNgA08i0rdtawCfq//mtrA0Mz1C/Dpji2XIxmaZqFE1rib8K1q6
         UQFPupACZ+B2iFt8zXk0gXCfAPm7CpQj5lRQglC5f3j32/g7bV+yM8Zk0tzVSs2j5N0j
         4jOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1+nWbH2X4eUskfN7h2bAJQ0jwGDRaEfpm7mVkpF/v2w=;
        b=dXT7m3X1IlTEXabW/GbXLzQFLTXk4egL7bVXoeBD+AnmZ7tgvV4Ay7hLLTqP+gm8Z0
         bflFswIAVgKo2ShK9h+rmWmHSZD6pcg8aNRNIw6VqnPhiJ/r1wpCZqSAAF99PvNvtF6X
         iAwK37zrqbE9igTYTxlyhAWMcUoU+5jqBDx3d2szxik22sr5ChkDs+8MqLrevcwN13kV
         zp90Z0vhuwHJNgA0CeFGgy0ppyQyPoQjX3VUevYUGIfIqFa1TrdGfV8vlSemTKcX/CNV
         M+98DgQjySr8CwW6Te0pAkZT6QmryakXMJM0cacd2Ildn0+ychhJZsvQhOiyx3DKOhce
         se0A==
X-Gm-Message-State: AOAM530jyX1q1bDcNAwnWz/cz1ZiS7+fH21QCKG3qUO5qxoXxYG2ehX1
        YQO+B+KUbniJ/4AopPpfNFer8QMcxojqDQ==
X-Google-Smtp-Source: ABdhPJzn+qeD0x3rs4Bf3/YXKrzZA893z5z/hfPUZCLTaRdr3pYNehgeCVFLYzm+EoUGsQ6Vzqf5tA==
X-Received: by 2002:aca:d644:: with SMTP id n65mr1718463oig.118.1614652677938;
        Mon, 01 Mar 2021 18:37:57 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1bb:8d29:39ef:5fe5])
        by smtp.gmail.com with ESMTPSA id a30sm100058oiy.42.2021.03.01.18.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 18:37:57 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v2 3/9] udp: implement ->sendmsg_locked()
Date:   Mon,  1 Mar 2021 18:37:37 -0800
Message-Id: <20210302023743.24123-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

UDP already has udp_sendmsg() which takes lock_sock() inside.
We have to build ->sendmsg_locked() on top of it, by adding
a new parameter for whether the sock has been locked.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/net/udp.h  |  1 +
 net/ipv4/af_inet.c |  1 +
 net/ipv4/udp.c     | 30 +++++++++++++++++++++++-------
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index df7cc1edc200..5264ba1439f9 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -292,6 +292,7 @@ int udp_get_port(struct sock *sk, unsigned short snum,
 int udp_err(struct sk_buff *, u32);
 int udp_abort(struct sock *sk, int err);
 int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len);
+int udp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t len);
 int udp_push_pending_frames(struct sock *sk);
 void udp_flush_pending_frames(struct sock *sk);
 int udp_cmsg_send(struct sock *sk, struct msghdr *msg, u16 *gso_size);
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index a02ce89b56b5..d8c73a848c53 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1071,6 +1071,7 @@ const struct proto_ops inet_dgram_ops = {
 	.setsockopt	   = sock_common_setsockopt,
 	.getsockopt	   = sock_common_getsockopt,
 	.sendmsg	   = inet_sendmsg,
+	.sendmsg_locked    = udp_sendmsg_locked,
 	.recvmsg	   = inet_recvmsg,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = inet_sendpage,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index dbd25b59ce0e..93db853601d7 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1024,7 +1024,7 @@ int udp_cmsg_send(struct sock *sk, struct msghdr *msg, u16 *gso_size)
 }
 EXPORT_SYMBOL_GPL(udp_cmsg_send);
 
-int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+static int __udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len, bool locked)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	struct udp_sock *up = udp_sk(sk);
@@ -1063,15 +1063,18 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		 * There are pending frames.
 		 * The socket lock must be held while it's corked.
 		 */
-		lock_sock(sk);
+		if (!locked)
+			lock_sock(sk);
 		if (likely(up->pending)) {
 			if (unlikely(up->pending != AF_INET)) {
-				release_sock(sk);
+				if (!locked)
+					release_sock(sk);
 				return -EINVAL;
 			}
 			goto do_append_data;
 		}
-		release_sock(sk);
+		if (!locked)
+			release_sock(sk);
 	}
 	ulen += sizeof(struct udphdr);
 
@@ -1241,11 +1244,13 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
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
 
 		net_dbg_ratelimited("socket already corked\n");
 		err = -EINVAL;
@@ -1272,7 +1277,8 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		err = udp_push_pending_frames(sk);
 	else if (unlikely(skb_queue_empty(&sk->sk_write_queue)))
 		up->pending = 0;
-	release_sock(sk);
+	if (!locked)
+		release_sock(sk);
 
 out:
 	ip_rt_put(rt);
@@ -1302,8 +1308,18 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	err = 0;
 	goto out;
 }
+
+int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+{
+	return __udp_sendmsg(sk, msg, len, false);
+}
 EXPORT_SYMBOL(udp_sendmsg);
 
+int udp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t len)
+{
+	return __udp_sendmsg(sk, msg, len, true);
+}
+
 int udp_sendpage(struct sock *sk, struct page *page, int offset,
 		 size_t size, int flags)
 {
-- 
2.25.1

