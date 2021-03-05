Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B9932DF54
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 02:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhCEB5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 20:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhCEB5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 20:57:10 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04711C061574;
        Thu,  4 Mar 2021 17:57:10 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id w3so309179oti.8;
        Thu, 04 Mar 2021 17:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bC4BMv/s3sCOyOd1K17vW7opInCuUyyPq+85GVpXtSo=;
        b=c2i3SK7BiJgwZBR7Trn9VCs7xqpL8NTeSj2UAlawXVMf+Mg29mrxXFfsc09hPrLDzU
         n6I5P7LDzpm0xuNOWu/dw1Ew5so0psEpQV0lfCNSDs5UFOitkVPvVyiWWPgkkhhVVMSY
         SOvI5hYa2OiefPhbqptaiqvN5a6SySVs4bESY7PSuVIOIIfG+dIn9IlIQJaRDqpyJg3/
         YybnvA5PGyHYolqSxljtTWAhIbuLCWzO3/UUZ6gX/r359FZk5sTC/D/edoJJlL+RaBOU
         E1wjz4VMfCLTkuB7UEfVsuANgPO2t3lrp9m7Co8BWSFwjvesWvPNXH826m0kh02gc6IZ
         Qn4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bC4BMv/s3sCOyOd1K17vW7opInCuUyyPq+85GVpXtSo=;
        b=kw/rK0/Qr1mBXpSSRJQRKhB/4nqCezuAT5Z+3f6fICQqKSjTSp8bXUky8GYk30nEOM
         CiBhFrGmSef5/HieLTmfQc9k5aAqoQaE9U11GatGOmpdgsCUXN6+TyS0n7Q9VuFFdu3s
         ypUTNR552mXcjv/atEoy43ZMEzQ8Cad4F+3gzOtwLBXgVuJaSbwUx2kkhsFb2E5FRVXE
         iUh141oGDYI/roRz7KBZOCHcVjcgi7qxPZB2PwldyD3/gM0NkMesoh0CFBxa49uIfn+Z
         rTR6jpxVH3yhT4luiGL/QQTV/V+AO8zz4avDDI0we3XjZD7zIkSuOif6QE2bKXxnvIQc
         XDWA==
X-Gm-Message-State: AOAM533k8ml42wXIODfpYG26InS+6yoXNzCSIP7Yz5aCbuz5FS/zumYL
        QdshI0tjIgW7lFLJJ54Sz3e8zWQKtydaHg==
X-Google-Smtp-Source: ABdhPJxrBnW9RgYbvdN5QnaFDu3sBHy75xlA7Z+uD/035xIZ5m/1vfA25JDvD1eDmN9OL3Fy5QhoLw==
X-Received: by 2002:a05:6830:558:: with SMTP id l24mr5964912otb.209.1614909429233;
        Thu, 04 Mar 2021 17:57:09 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:95de:1d5:1b36:946a])
        by smtp.gmail.com with ESMTPSA id r3sm224126oif.5.2021.03.04.17.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 17:57:08 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v3 3/9] udp: implement ->sendmsg_locked()
Date:   Thu,  4 Mar 2021 17:56:49 -0800
Message-Id: <20210305015655.14249-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210305015655.14249-1-xiyou.wangcong@gmail.com>
References: <20210305015655.14249-1-xiyou.wangcong@gmail.com>
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
index 38952aaee3a1..424231e910a9 100644
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

