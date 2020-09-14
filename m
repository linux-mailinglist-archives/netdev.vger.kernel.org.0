Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AE326985A
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgINVwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbgINVwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 17:52:24 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80192C061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 14:52:21 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id q63so2058054qkf.3
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 14:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eU/pCyz+Cn9FpUal4w4YvaEMrwTqR/VYjecDHxBJ9qA=;
        b=jsD7MSs64XLh2H1S+JMIH9tjwESGkvDSZP58ZZY0MaiRl34Psh695IktlX4hBDQTVp
         CvlPXLTX/M66olfqCxMoN1FeoVpObcMit64XN20s3enrPFA1JBjI/KFzs++CRzk+Akot
         EHUptmOcNhHuoO9QpX6r/qOTd/U42EqdsvsDftkUv1kxxu/AgXc159jEoXKVoEvC8onh
         95cx5a4EkojFKjYguqiaBT/Tc8DULTG0uHagd8CG3GHNZrAuKeA1ib2J4QzGwpOQokQa
         iW2wQHaUPa2xddCdbcadIO3qQZij7NQixhwEF1XbL+ePSe0Fke4N9+ijcVCmkKMnVJI7
         18iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eU/pCyz+Cn9FpUal4w4YvaEMrwTqR/VYjecDHxBJ9qA=;
        b=WQnOJKXHqtvzpIx1+5ekwbMixhkV5VDd7XFWsddrA1EhOp3Q0S0J88AsEV5Q+DNyUl
         HBNA3cOxeBFTrLQrOiy3fLzArqZ7WGF4WUZEcvmwyEOqP5e3aqE2iheyBpy9Aue2+wBW
         huFIR47VlcDSpEUMs/ImHX77PcBlDoiR92jOZWBDEB9ekosxSc/t2mhLzxMw3xt9tkxa
         wFHvJAZI4P27SzFy8vjEM7rY1zls7ovHWdlWGRZ0Lzy5qYzD3FrBREOaqiithsjuZvke
         fu8sjYk5dZQar9Fl4/txw7c00cY2XhtIxqYF2Oil2nzZONgurYmAZpVKkCVPklWdZ9zX
         7g6Q==
X-Gm-Message-State: AOAM530Rvv0rEDZ3ngEqHsIHc/TEIP7O03HfMt7/dRlodNqb4eCdadD1
        FDmjeT15jJ0V3lh0MHqb68A=
X-Google-Smtp-Source: ABdhPJxSoMT7qM0Jot/aiV3eHjP/h96bz7C/riEpTo17SY98MTlALTjDmNhexI68X36PSdUvruzZUA==
X-Received: by 2002:a05:620a:1297:: with SMTP id w23mr13792500qki.345.1600120340802;
        Mon, 14 Sep 2020 14:52:20 -0700 (PDT)
Received: from soheil4.nyc.corp.google.com ([2620:0:1003:312:a6ae:11ff:fe18:6946])
        by smtp.gmail.com with ESMTPSA id r195sm14755232qke.74.2020.09.14.14.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 14:52:20 -0700 (PDT)
From:   Soheil Hassas Yeganeh <soheil.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     edumazet@google.com, Soheil Hassas Yeganeh <soheil@google.com>
Subject: [PATCH net-next 2/2] tcp: schedule EPOLLOUT after a partial sendmsg
Date:   Mon, 14 Sep 2020 17:52:10 -0400
Message-Id: <20200914215210.2288109-2-soheil.kdev@gmail.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200914215210.2288109-1-soheil.kdev@gmail.com>
References: <20200914215210.2288109-1-soheil.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Soheil Hassas Yeganeh <soheil@google.com>

For EPOLLET, applications must call sendmsg until they get EAGAIN.
Otherwise, there is no guarantee that EPOLLOUT is sent if there was
a failure upon memory allocation.

As a result on high-speed NICs, userspace observes multiple small
sendmsgs after a partial sendmsg until EAGAIN, since TCP can send
1-2 TSOs in between two sendmsg syscalls:

// One large partial send due to memory allocation failure.
sendmsg(20MB)   = 2MB
// Many small sends until EAGAIN.
sendmsg(18MB)   = 64KB
sendmsg(17.9MB) = 128KB
sendmsg(17.8MB) = 64KB
...
sendmsg(...)    = EAGAIN
// At this point, userspace can assume an EPOLLOUT.

To fix this, set the SOCK_NOSPACE on all partial sendmsg scenarios
to guarantee that we send EPOLLOUT after partial sendmsg.

After this commit userspace can assume that it will receive an EPOLLOUT
after the first partial sendmsg. This EPOLLOUT will benefit from
sk_stream_write_space() logic delaying the EPOLLOUT until significant
space is available in write queue.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 net/ipv4/tcp.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 48c351804efc..65057744fac8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1004,12 +1004,12 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 		    !tcp_skb_can_collapse_to(skb)) {
 new_segment:
 			if (!sk_stream_memory_free(sk))
-				goto wait_for_sndbuf;
+				goto wait_for_space;
 
 			skb = sk_stream_alloc_skb(sk, 0, sk->sk_allocation,
 					tcp_rtx_and_write_queues_empty(sk));
 			if (!skb)
-				goto wait_for_memory;
+				goto wait_for_space;
 
 #ifdef CONFIG_TLS_DEVICE
 			skb->decrypted = !!(flags & MSG_SENDPAGE_DECRYPTED);
@@ -1028,7 +1028,7 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 			goto new_segment;
 		}
 		if (!sk_wmem_schedule(sk, copy))
-			goto wait_for_memory;
+			goto wait_for_space;
 
 		if (can_coalesce) {
 			skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
@@ -1069,9 +1069,8 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 			tcp_push_one(sk, mss_now);
 		continue;
 
-wait_for_sndbuf:
+wait_for_space:
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
-wait_for_memory:
 		tcp_push(sk, flags & ~MSG_MORE, mss_now,
 			 TCP_NAGLE_PUSH, size_goal);
 
@@ -1282,7 +1281,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 new_segment:
 			if (!sk_stream_memory_free(sk))
-				goto wait_for_sndbuf;
+				goto wait_for_space;
 
 			if (unlikely(process_backlog >= 16)) {
 				process_backlog = 0;
@@ -1293,7 +1292,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			skb = sk_stream_alloc_skb(sk, 0, sk->sk_allocation,
 						  first_skb);
 			if (!skb)
-				goto wait_for_memory;
+				goto wait_for_space;
 
 			process_backlog++;
 			skb->ip_summed = CHECKSUM_PARTIAL;
@@ -1326,7 +1325,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			struct page_frag *pfrag = sk_page_frag(sk);
 
 			if (!sk_page_frag_refill(sk, pfrag))
-				goto wait_for_memory;
+				goto wait_for_space;
 
 			if (!skb_can_coalesce(skb, i, pfrag->page,
 					      pfrag->offset)) {
@@ -1340,7 +1339,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			copy = min_t(int, copy, pfrag->size - pfrag->offset);
 
 			if (!sk_wmem_schedule(sk, copy))
-				goto wait_for_memory;
+				goto wait_for_space;
 
 			err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
 						       pfrag->page,
@@ -1393,9 +1392,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			tcp_push_one(sk, mss_now);
 		continue;
 
-wait_for_sndbuf:
+wait_for_space:
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
-wait_for_memory:
 		if (copied)
 			tcp_push(sk, flags & ~MSG_MORE, mss_now,
 				 TCP_NAGLE_PUSH, size_goal);
-- 
2.28.0.618.gf4bc123cb7-goog

