Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411E7268928
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 12:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgINKUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 06:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgINKUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 06:20:31 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15437C061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 03:20:31 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id y17so822391qkf.15
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 03:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=JNmWJ3U0GiV/euGfjsbvKGnSDrLjLyZ3K2WEjXqUgOE=;
        b=VNAjA4RVbI4WzIuMuoMlGjextafRwwB3gZ9FeAcyk9edzoZ6LzfsuyLKJpIFLHgAo9
         DiXQP/DStvyDgR+spRpdskq61g9Z31+WnR9GX1HDxHs440x+es6YtGvEHQPiWuLe/HKa
         9Bi/NdPI6a9HRA9/GvTy8UkH5EUQNhycdXqSIry/rmtIjnM1QOa7198Wlo6ZIKZScqqB
         +wnfy782RA5NVxRBuUJNcxL/RhrlJczyzwL9yfaRYJGxTZHZw7mqNHYvVptFjJDmhVfG
         CDRi4PuvK/VnarwFKFNwZ7GqbIcdlX51M48spXQmk0UpxPADlFiypX1l4li/b6muPXK8
         imHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=JNmWJ3U0GiV/euGfjsbvKGnSDrLjLyZ3K2WEjXqUgOE=;
        b=c7aAFd54d3IINMJbAxseXyHwoTH75mpVnHuUcORjWApFsV+Sb+sMXbPtWvAtzblf6t
         GxeznthynwbRMbZFIGcr2tVVXZEEh787olFLMdqIKJer/wfCM6q4AP5xjBhay8FT6JAr
         PgikuijMOJC/IeQg4rz8hmPqf9eyb5i8kRr5lAHFCnMd92jbY41BkrHjg3tOHVomep9W
         xj3O9zh+XK5AVevKggntuvuw6RcPohVUrmGW/Y6ox6Tu5uLZzG+5TiyI5+eXho5+QHmK
         9UCd1JnuwCr0pkv0imK+tjRNlk5rjmi6eVR8MODa5KZocPXO9Hvcv9onvvjywV9+lDrV
         TTiw==
X-Gm-Message-State: AOAM532Cz+M3V/srNQBRCx2YDp/7jHJmKhCi+tiWYyeU/Aq5l4Zg3WLd
        GPisC0ejCFNk8hoOybJOs2tPIjggn6vxag==
X-Google-Smtp-Source: ABdhPJzxw6rIrfIw3VD85ARI7XnocSs2An/hzX35cOMmPS+UpKeu5wZ7OjJ4Vq21ZnFS+ET5uDra7hW9Ziw/LQ==
X-Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
 (user=edumazet job=sendgmr) by 2002:a0c:d443:: with SMTP id
 r3mr12606889qvh.17.1600078830150; Mon, 14 Sep 2020 03:20:30 -0700 (PDT)
Date:   Mon, 14 Sep 2020 03:20:27 -0700
Message-Id: <20200914102027.3746717-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH net-next] tcp: remove SOCK_QUEUE_SHRUNK
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SOCK_QUEUE_SHRUNK is currently used by TCP as a temporary state
that remembers if some room has been made in the rtx queue
by an incoming ACK packet.

This is later used from tcp_check_space() before
considering to send EPOLLOUT.

Problem is: If we receive SACK packets, and no packet
is removed from RTX queue, we can send fresh packets, thus
moving them from write queue to rtx queue and eventually
empty the write queue.

This stall can happen if TCP_NOTSENT_LOWAT is used.

With this fix, we no longer risk stalling sends while holes
are repaired, and we can fully use socket sndbuf.

This also removes a cache line dirtying for typical RPC
workloads.

Fixes: c9bee3b7fdec ("tcp: TCP_NOTSENT_LOWAT socket option")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
---
 include/net/sock.h    |  2 --
 net/ipv4/tcp_input.c  | 23 +++++++----------------
 net/ipv4/tcp_output.c |  1 -
 3 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 7dd3051551fbad3f432c969e16c04ff7f63bbe26..eaa5cac5e8368bf1c18e221fffa321d692579bad 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -845,7 +845,6 @@ enum sock_flags {
 	SOCK_RCVTSTAMP, /* %SO_TIMESTAMP setting */
 	SOCK_RCVTSTAMPNS, /* %SO_TIMESTAMPNS setting */
 	SOCK_LOCALROUTE, /* route locally only, %SO_DONTROUTE setting */
-	SOCK_QUEUE_SHRUNK, /* write queue has been shrunk recently */
 	SOCK_MEMALLOC, /* VM depends on this socket for swapping */
 	SOCK_TIMESTAMPING_RX_SOFTWARE,  /* %SOF_TIMESTAMPING_RX_SOFTWARE */
 	SOCK_FASYNC, /* fasync() active */
@@ -1526,7 +1525,6 @@ static inline void sk_mem_uncharge(struct sock *sk, int size)
 DECLARE_STATIC_KEY_FALSE(tcp_tx_skb_cache_key);
 static inline void sk_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
 {
-	sock_set_flag(sk, SOCK_QUEUE_SHRUNK);
 	sk_wmem_queued_add(sk, -skb->truesize);
 	sk_mem_uncharge(sk, skb->truesize);
 	if (static_branch_unlikely(&tcp_tx_skb_cache_key) &&
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3658ad84f0c6252658dd5174eae31dcde4b34942..50834e7f958eec178ea144e8d438c98f2cff9014 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5332,12 +5332,6 @@ static bool tcp_should_expand_sndbuf(const struct sock *sk)
 	return true;
 }
 
-/* When incoming ACK allowed to free some skb from write_queue,
- * we remember this event in flag SOCK_QUEUE_SHRUNK and wake up socket
- * on the exit from tcp input handler.
- *
- * PROBLEM: sndbuf expansion does not work well with largesend.
- */
 static void tcp_new_space(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -5352,16 +5346,13 @@ static void tcp_new_space(struct sock *sk)
 
 static void tcp_check_space(struct sock *sk)
 {
-	if (sock_flag(sk, SOCK_QUEUE_SHRUNK)) {
-		sock_reset_flag(sk, SOCK_QUEUE_SHRUNK);
-		/* pairs with tcp_poll() */
-		smp_mb();
-		if (sk->sk_socket &&
-		    test_bit(SOCK_NOSPACE, &sk->sk_socket->flags)) {
-			tcp_new_space(sk);
-			if (!test_bit(SOCK_NOSPACE, &sk->sk_socket->flags))
-				tcp_chrono_stop(sk, TCP_CHRONO_SNDBUF_LIMITED);
-		}
+	/* pairs with tcp_poll() */
+	smp_mb();
+	if (sk->sk_socket &&
+	    test_bit(SOCK_NOSPACE, &sk->sk_socket->flags)) {
+		tcp_new_space(sk);
+		if (!test_bit(SOCK_NOSPACE, &sk->sk_socket->flags))
+			tcp_chrono_stop(sk, TCP_CHRONO_SNDBUF_LIMITED);
 	}
 }
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index ab79d36ed07fc6918035ab3f9ebdb3ce6b7767c8..386978dcd318d84af486d0d1a5bb1786f4a493cf 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1682,7 +1682,6 @@ int tcp_trim_head(struct sock *sk, struct sk_buff *skb, u32 len)
 		skb->truesize	   -= delta_truesize;
 		sk_wmem_queued_add(sk, -delta_truesize);
 		sk_mem_uncharge(sk, delta_truesize);
-		sock_set_flag(sk, SOCK_QUEUE_SHRUNK);
 	}
 
 	/* Any change of skb->len requires recalculation of tso factor. */
-- 
2.28.0.618.gf4bc123cb7-goog

