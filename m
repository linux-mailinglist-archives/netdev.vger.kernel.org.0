Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F9032DF57
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 02:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhCEB5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 20:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhCEB5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 20:57:12 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900F8C061574;
        Thu,  4 Mar 2021 17:57:12 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id d20so749560oiw.10;
        Thu, 04 Mar 2021 17:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uGsqveMCmyCU5pgZFzP569dVFv2d0yadbOz4Nvro+g0=;
        b=hEPEkzDvfVo4GbvNpaEVEpzhcODcVra0+pfmAuNySIBUwkMo2cYto83LOSq8OONMWe
         HLPhmhYO8h8zvLszeVt/+DBHQsrOTE114Wo/d8157ryhe7qit+H8Vf9UvVFmyZ0JHrt1
         2E7BLXvzBzzkl0AvZAUcPYuui/eX3+Yw6tO5K/cDHe+YHeap9ynnRZORVCkF9QBXZxSc
         iIRCLpcrGhz4ahAujd5Mjup9WlnoR1dIFdgbi2QN4ftGyQuwNGm0uWXwj6zR9iGy7jQh
         25gEizqOkhVkgZ3DAoHganqVrkRX3nA6E/5dJKfleinoFbBGPE4TKueS1yUh42TG9BW3
         SVdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uGsqveMCmyCU5pgZFzP569dVFv2d0yadbOz4Nvro+g0=;
        b=LUh/Vc9Q3aOTatcubhWwkD0nceM92MULYjwTgbW9tmiC98A11WZf2dKgrmtiRuaPlk
         GOrSASU73+6TpG0U9YAoLR6rai3syOg8wOdeXvu3V9DY1QrTehbTJn7ugK6O5rdS1N6A
         k96pMT5F6OtB2I+jjrTEE0Y556U9ywUJwqe3aOtF6L7F8f2v2f6JVv+btkZHQSwRBltd
         /nimGmV8+pScS206J2lnAlaoztPbx0b2IIDnkqLA1bSNwjMGo4iNxipSfL/xmYAmiLvU
         YFSABA8HAq3iDM+A/hEDLPuvxz5jDPbg7gBPeMpmGsMKXqDiMLaNaICWljI9PBp4Ylbq
         D+7Q==
X-Gm-Message-State: AOAM5308d0nYr/kilvx7mWHHwe/66j1pILa8HvumtDClEXa1AOiBaVxW
        X7a/D+c8ykHbQjYegoTtAQkKaMGDmo78BQ==
X-Google-Smtp-Source: ABdhPJyMie4ja78W3y2goF6TCaZQ+Fl2FE+1kvIMWPjEVl4B51tuXrysr9MEzEUI+Sgp6yQjjQbhoA==
X-Received: by 2002:aca:bc89:: with SMTP id m131mr5066332oif.62.1614909431837;
        Thu, 04 Mar 2021 17:57:11 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:95de:1d5:1b36:946a])
        by smtp.gmail.com with ESMTPSA id r3sm224126oif.5.2021.03.04.17.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 17:57:11 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v3 5/9] udp: add ->read_sock() and ->sendmsg_locked() to ipv6
Date:   Thu,  4 Mar 2021 17:56:51 -0800
Message-Id: <20210305015655.14249-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210305015655.14249-1-xiyou.wangcong@gmail.com>
References: <20210305015655.14249-1-xiyou.wangcong@gmail.com>
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
index fd8f27ee5b4e..6658db231475 100644
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
index ef2c75bb4771..124a316da410 100644
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

