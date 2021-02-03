Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2983D30D27B
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhBCET1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbhBCESY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:18:24 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC29C06178B;
        Tue,  2 Feb 2021 20:17:04 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id y72so5711606ooa.5;
        Tue, 02 Feb 2021 20:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ojv8oP/7DrPVwj1wzfTdEvvaO8PPS/QTeufALEIgqOU=;
        b=mxRlFC+IELWEi7o+jKOI5sSiSZVJ9D3t9M2StQ7sQmK1Di201bBgmRziJaLFmZFl0b
         2Cg/63NL2J+zxknTpMVxIgdz1C3c7oWPtEjAnOMQGk5fqHFpCR3uFQcZy4l5H9hfkZl2
         1gbuIlA3lhb9VAiv37BMhAfzvwiPBZRu8GCrBUYmgrBuRSs1JCTGjgKb1egTulBjfo5G
         +nmPkNCl9SuWsQUijdqEUL5PY8Xilo5VseaIHOg+LsfCpDmZmu1N4SqmHK0wdeniIwqZ
         vPrfk2V0gnwigXTRxJ2nsqCwCPLTlKwTgyEbhfftil9BRi9DGr2amp4hmYtICmTu4w6E
         TsNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ojv8oP/7DrPVwj1wzfTdEvvaO8PPS/QTeufALEIgqOU=;
        b=bL9rlSdlVRP+fLSJIp1tLaewfF5UEQq6x5q9txPpmSQwJGPabmeX3KDNPtDnfH2O4F
         VOqqSx7Nit7+p1mKKzdRjYXlpVLocqs9cOAkgF3MpcdTPqTEXlfmjJoPOKqX1V4+Lc6f
         ji4i5o1MEYo62UMp3OlbTwPZI+s+2K26mUABIL/NChkIxyHMsmJtzw8Wr764YEwA1LZO
         rljBOqijuCCQdDBFyyLFmrzYb3+ytecCsbpdDX9M4HB28wxcq8b/2NYmcR68FU8cCKMm
         F4mDlgAHCndokVSnTUi+2mWL2YN4W6KOlPCBhBML6bgQKB0aE5RwVyCdoWGc6TZQVyLt
         unGg==
X-Gm-Message-State: AOAM530fckpHQm5lWPFxQlIrw+BcyoSvVJPdq6Xcl6laB1MdnQwNjzRQ
        UX0GL1M6vn2iLBs49+1bLqJZP6jp6S16vw==
X-Google-Smtp-Source: ABdhPJyIt8Yrfz85xYwgJUnkJegZTul1rNk1tPOZJ+FINcISP6e3JM96rni9/8pHA2+gBw4NvicY/g==
X-Received: by 2002:a4a:9c85:: with SMTP id z5mr787878ooj.93.1612325824044;
        Tue, 02 Feb 2021 20:17:04 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:90c4:ffea:6079:8a0c])
        by smtp.gmail.com with ESMTPSA id s10sm209978ool.35.2021.02.02.20.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 20:17:03 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next 07/19] udp: implement ->sendmsg_locked()
Date:   Tue,  2 Feb 2021 20:16:24 -0800
Message-Id: <20210203041636.38555-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
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
index e3e5dfc8e0f0..13f9354dbd3e 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -289,6 +289,7 @@ int udp_get_port(struct sock *sk, unsigned short snum,
 int udp_err(struct sk_buff *, u32);
 int udp_abort(struct sock *sk, int err);
 int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len);
+int udp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t len);
 int udp_push_pending_frames(struct sock *sk);
 void udp_flush_pending_frames(struct sock *sk);
 int udp_cmsg_send(struct sock *sk, struct msghdr *msg, u16 *gso_size);
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index aaa94bea19c3..d184d9379a92 100644
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
index 84ab4f2e874a..635e1e8b2968 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1018,7 +1018,7 @@ int udp_cmsg_send(struct sock *sk, struct msghdr *msg, u16 *gso_size)
 }
 EXPORT_SYMBOL_GPL(udp_cmsg_send);
 
-int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+static int __udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len, bool locked)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	struct udp_sock *up = udp_sk(sk);
@@ -1057,15 +1057,18 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
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
 
@@ -1235,11 +1238,13 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
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
@@ -1266,7 +1271,8 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		err = udp_push_pending_frames(sk);
 	else if (unlikely(skb_queue_empty(&sk->sk_write_queue)))
 		up->pending = 0;
-	release_sock(sk);
+	if (!locked)
+		release_sock(sk);
 
 out:
 	ip_rt_put(rt);
@@ -1296,8 +1302,18 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
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

