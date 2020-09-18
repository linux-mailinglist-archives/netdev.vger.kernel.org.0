Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1877226ECE0
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbgIRCPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:15:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728554AbgIRCPh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:15:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9366B2388B;
        Fri, 18 Sep 2020 02:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395336;
        bh=dmtQg8kSczZw3mlnO6PmU3nv0lewHWs6TbeH50Rv7sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cAvH6NWFALFwCqk3U6uOMFAtK62h84zuwblJ6QkrZyxWnaDQUhH5ioh88L7ktyxiV
         +ObJ7s6XUBIXHfEV1aU6WtZKzF/fFlmOkyXlrOKY+sprIeTPUL5CwpbcMzYcGQXtxj
         cdZLhlciZ7mERCXAJ8PkcpCap069kh0E0pTCO7QI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 33/90] skbuff: fix a data race in skb_queue_len()
Date:   Thu, 17 Sep 2020 22:13:58 -0400
Message-Id: <20200918021455.2067301-33-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021455.2067301-1-sashal@kernel.org>
References: <20200918021455.2067301-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 86b18aaa2b5b5bb48e609cd591b3d2d0fdbe0442 ]

sk_buff.qlen can be accessed concurrently as noticed by KCSAN,

 BUG: KCSAN: data-race in __skb_try_recv_from_queue / unix_dgram_sendmsg

 read to 0xffff8a1b1d8a81c0 of 4 bytes by task 5371 on cpu 96:
  unix_dgram_sendmsg+0x9a9/0xb70 include/linux/skbuff.h:1821
				 net/unix/af_unix.c:1761
  ____sys_sendmsg+0x33e/0x370
  ___sys_sendmsg+0xa6/0xf0
  __sys_sendmsg+0x69/0xf0
  __x64_sys_sendmsg+0x51/0x70
  do_syscall_64+0x91/0xb47
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

 write to 0xffff8a1b1d8a81c0 of 4 bytes by task 1 on cpu 99:
  __skb_try_recv_from_queue+0x327/0x410 include/linux/skbuff.h:2029
  __skb_try_recv_datagram+0xbe/0x220
  unix_dgram_recvmsg+0xee/0x850
  ____sys_recvmsg+0x1fb/0x210
  ___sys_recvmsg+0xa2/0xf0
  __sys_recvmsg+0x66/0xf0
  __x64_sys_recvmsg+0x51/0x70
  do_syscall_64+0x91/0xb47
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Since only the read is operating as lockless, it could introduce a logic
bug in unix_recvq_full() due to the load tearing. Fix it by adding
a lockless variant of skb_queue_len() and unix_recvq_full() where
READ_ONCE() is on the read while WRITE_ONCE() is on the write similar to
the commit d7d16a89350a ("net: add skb_queue_empty_lockless()").

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 14 +++++++++++++-
 net/unix/af_unix.c     | 11 +++++++++--
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e37112ac332f7..0380fd29824e0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1549,6 +1549,18 @@ static inline __u32 skb_queue_len(const struct sk_buff_head *list_)
 	return list_->qlen;
 }
 
+/**
+ *	skb_queue_len_lockless	- get queue length
+ *	@list_: list to measure
+ *
+ *	Return the length of an &sk_buff queue.
+ *	This variant can be used in lockless contexts.
+ */
+static inline __u32 skb_queue_len_lockless(const struct sk_buff_head *list_)
+{
+	return READ_ONCE(list_->qlen);
+}
+
 /**
  *	__skb_queue_head_init - initialize non-spinlock portions of sk_buff_head
  *	@list: queue to initialize
@@ -1752,7 +1764,7 @@ static inline void __skb_unlink(struct sk_buff *skb, struct sk_buff_head *list)
 {
 	struct sk_buff *next, *prev;
 
-	list->qlen--;
+	WRITE_ONCE(list->qlen, list->qlen - 1);
 	next	   = skb->next;
 	prev	   = skb->prev;
 	skb->next  = skb->prev = NULL;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 32ae82a5596d9..bcd6ed6e7e25c 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -191,11 +191,17 @@ static inline int unix_may_send(struct sock *sk, struct sock *osk)
 	return unix_peer(osk) == NULL || unix_our_peer(sk, osk);
 }
 
-static inline int unix_recvq_full(struct sock const *sk)
+static inline int unix_recvq_full(const struct sock *sk)
 {
 	return skb_queue_len(&sk->sk_receive_queue) > sk->sk_max_ack_backlog;
 }
 
+static inline int unix_recvq_full_lockless(const struct sock *sk)
+{
+	return skb_queue_len_lockless(&sk->sk_receive_queue) >
+		READ_ONCE(sk->sk_max_ack_backlog);
+}
+
 struct sock *unix_peer_get(struct sock *s)
 {
 	struct sock *peer;
@@ -1793,7 +1799,8 @@ restart_locked:
 	 * - unix_peer(sk) == sk by time of get but disconnected before lock
 	 */
 	if (other != sk &&
-	    unlikely(unix_peer(other) != sk && unix_recvq_full(other))) {
+	    unlikely(unix_peer(other) != sk &&
+	    unix_recvq_full_lockless(other))) {
 		if (timeo) {
 			timeo = unix_wait_for_peer(other, timeo);
 
-- 
2.25.1

