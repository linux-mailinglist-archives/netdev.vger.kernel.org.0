Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25840151E0A
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 17:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbgBDQQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 11:16:30 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45471 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727290AbgBDQQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 11:16:29 -0500
Received: by mail-qt1-f193.google.com with SMTP id d9so14696689qte.12
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 08:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=pAy8jLtbMbimG8GilZh7LrbVrb27NyycDZqZCxpoHs8=;
        b=bOvS0LL/h3dhQAj52To9GrwAyqFdTm62vOnjl1p+9e7L19APZ5V84zcaLdt26gQ7n+
         Lv4DXKhGE9uhyrbgWCbUVizjcOiW8iyVo/TfxharjTyJru/Rk0avd9BcxFuJlRf1xaUR
         mPFYBG6cfn+QbaX3enxmlbTlL84TJxNNVBQWEgpaVg0HfgxlifYnTLLt+vaCVdNY/uC5
         PtiUWdr3Pb8aryX1lq3IeaBFwxsD7ls17Eih7+CaL+O8qAJJlTQd02nXY04wI3p+B7r1
         BTW2HVkEDH5t6Dr5xPhV8mizRrdQk/yKPadT4+Ooc89vLuRS4oIqfEbRXQpyrV5j0e2x
         eZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pAy8jLtbMbimG8GilZh7LrbVrb27NyycDZqZCxpoHs8=;
        b=YnrXJD4V9silKjDYbzjOQKt2IJ+WRewm6fy65U+mboSxN351wgczkE256/uRSMWh4K
         kSkgF5nckMQCg4um9Me7Jo2Zjwgtxv+ZZ56uErcMOm2Op1gBN1ucUxwxBxbCqlCfmLbE
         9fKjwStv811V1vGBfyjBVu+uFJzGY587AASUMez8p1SjKEgIs6dvmThVORWI4/h58f8k
         sZwsEGtxpRa+7g4Z3lfhgBDeSw5d+hHNNQ/4Z7S0OOjz6U9MVrPMrWJDxUL7sQ1oLI4l
         pO4PcoZ3UrW4f5JqtNFDHujm8yUf7Gr8rdDcrYlMorc9lV2bdyUJmnJnjOslHS2M+5PH
         J4qw==
X-Gm-Message-State: APjAAAVNY6xrolNYBVJuzqe01efzkI0qUdt16PImqeXjrcuK3FtZ6zOG
        Tqk0kZTRPMHirsvTv0mAl4aiyw==
X-Google-Smtp-Source: APXvYqz7uA5dN7UDMN36zGgMX2aZZ08vO0ZNAvSjII3gVrZwym/G8T5QvFz2fuPqIyNkyulRVDp+XA==
X-Received: by 2002:ac8:7281:: with SMTP id v1mr29023219qto.79.1580832988769;
        Tue, 04 Feb 2020 08:16:28 -0800 (PST)
Received: from qcai.nay.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id b24sm11753939qto.71.2020.02.04.08.16.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Feb 2020 08:16:28 -0800 (PST)
From:   Qian Cai <cai@lca.pw>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, elver@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: [PATCH v2] skbuff: fix a data race in skb_queue_len()
Date:   Tue,  4 Feb 2020 11:15:45 -0500
Message-Id: <1580832945-28331-1-git-send-email-cai@lca.pw>
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

v2: add lockless variant helpers and WRITE_ONCE().

 include/linux/skbuff.h | 14 +++++++++++++-
 net/unix/af_unix.c     |  9 ++++++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3d13a4b717e9..de5eade20e52 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1822,6 +1822,18 @@ static inline __u32 skb_queue_len(const struct sk_buff_head *list_)
 }
 
 /**
+ *	skb_queue_len	- get queue length
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
index 321af97c7bbe..349e7fbfbc67 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -194,6 +194,12 @@ static inline int unix_recvq_full(struct sock const *sk)
 	return skb_queue_len(&sk->sk_receive_queue) > sk->sk_max_ack_backlog;
 }
 
+static inline int unix_recvq_full_lockless(struct sock const *sk)
+{
+	return skb_queue_len_lockless(&sk->sk_receive_queue) >
+		sk->sk_max_ack_backlog;
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

