Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8293D15207C
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 19:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgBDSkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 13:40:47 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:44962 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727472AbgBDSko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 13:40:44 -0500
Received: by mail-qv1-f65.google.com with SMTP id n8so9015966qvg.11
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 10:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=DB0+6oqad2X9sug7/BYe3OrQc0C3Jh0vC4fwygtVpck=;
        b=Y0tX8RyRRKySRXdE1IIQ203wsgkLe0JjIB952ZIL1eXUf8Y2OwhTzPU33KVr9nY31W
         +FvemeuSARNLoLGgHZJrGxLLv/xmYI0Rxw4qICVZlu/0aGGnupRnJcGMwt2RBQ/0P5FK
         qh9Nq4BVutBRnHry/jLlB5YsQIAqhuHYPfBqyOJan3ECEhg7w4AQEqMg68bVbQ3COX/J
         buQVNDBB7jqdJDatu9qDteW4Vj6g4JTFnwc4RYBxYlqWjkeRxHiBxUfeELgyGmZ7CGxG
         JhC2z8QSXPHmmZ0rufntInnwDdR2+4ydbqUk/fXpg05Sd8it9kHqsa+RqDk/XDQaKifL
         30SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DB0+6oqad2X9sug7/BYe3OrQc0C3Jh0vC4fwygtVpck=;
        b=YdNatoQePa7QPM2kL+KJpMvYAM9cEGtG7dV90TcedN9Ghu4wT9vCUmLbePDS+U9Dnf
         qUHFkaGJAIrk0a+vuvhzvnvST5EXjWyDIYtwov+5NyVSAxm3tBhevljwoUtztEJtqhRT
         0Bax+vMT1Vk9YCT1suhem6U0HQd1w46EeWPD0/ReP/Q7ZkDPV+4jzikjr+vnkp6EQUZz
         lHpcha85q/slsqSFvO2anLAr+PLIJJQTeEK++6lvhS62HUnj9VuPHmQGWNN3xeH8ryBe
         EnxhRMg7APtBwhoqCsox+jGTlzH6EnZ9eEREsdtNEZ1jHm8+mbT3Uw0JguSRRDCmWKur
         dCjA==
X-Gm-Message-State: APjAAAVbN0jN4WyZkKrxEKz6vW8LeToKOmmvmBQocJUT1l4aXzHmIaCC
        gHgUUPbzex9sjCz/KXTKMWte8yFeYpHAvw==
X-Google-Smtp-Source: APXvYqxAVBSD7kuCElcQ9UYk3+Ei1ZcVmXAHn28Ocu4gusuB44mqNQ06KXU+zhoqeI6e3NQ+Om4BbA==
X-Received: by 2002:ad4:514e:: with SMTP id g14mr28949172qvq.196.1580841643722;
        Tue, 04 Feb 2020 10:40:43 -0800 (PST)
Received: from qcai.nay.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id o17sm12076071qtq.93.2020.02.04.10.40.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Feb 2020 10:40:43 -0800 (PST)
From:   Qian Cai <cai@lca.pw>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, elver@google.com, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>
Subject: [PATCH v3] skbuff: fix a data race in skb_queue_len()
Date:   Tue,  4 Feb 2020 13:40:29 -0500
Message-Id: <1580841629-7102-1-git-send-email-cai@lca.pw>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---

v3: fix minor issues thanks to Eric.
v2: add lockless variant helpers and WRITE_ONCE().

 include/linux/skbuff.h | 14 +++++++++++++-
 net/unix/af_unix.c     | 11 +++++++++--
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3d13a4b717e9..ca8806b69388 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1822,6 +1822,18 @@ static inline __u32 skb_queue_len(const struct sk_buff_head *list_)
 }
 
 /**
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
+/**
  *	__skb_queue_head_init - initialize non-spinlock portions of sk_buff_head
  *	@list: queue to initialize
  *
@@ -2026,7 +2038,7 @@ static inline void __skb_unlink(struct sk_buff *skb, struct sk_buff_head *list)
 {
 	struct sk_buff *next, *prev;
 
-	list->qlen--;
+	WRITE_ONCE(list->qlen, list->qlen - 1);
 	next	   = skb->next;
 	prev	   = skb->prev;
 	skb->next  = skb->prev = NULL;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 321af97c7bbe..62c12cb5763e 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -189,11 +189,17 @@ static inline int unix_may_send(struct sock *sk, struct sock *osk)
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
@@ -1758,7 +1764,8 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 	 * - unix_peer(sk) == sk by time of get but disconnected before lock
 	 */
 	if (other != sk &&
-	    unlikely(unix_peer(other) != sk && unix_recvq_full(other))) {
+	    unlikely(unix_peer(other) != sk &&
+	    unix_recvq_full_lockless(other))) {
 		if (timeo) {
 			timeo = unix_wait_for_peer(other, timeo);
 
-- 
1.8.3.1

