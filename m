Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB619414F05
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 19:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbhIVR2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 13:28:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57424 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236744AbhIVR2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 13:28:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632331622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ocBV2wXfiOTn1O2w09aLkS14Tww2/enRy19+rxA+SrQ=;
        b=DqPSD1usAhK2wGQaS5+PxB6ptvZuNdTr8e/0OVDNFx1v6+qxERZ4jLUEeLp8gbXtRZtkOj
        fKYkNKHoc1Z8Ffk3hs9HZ4Widj60Y/cK1YTP/6zdqaWkqLOYY3qINrnvi08GtVG+8WLuAa
        CHrEOcGnOZL8iMs0x3qvZ77xkKYwfnM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-yBKxnveKPI-3xBWZUA5Fsg-1; Wed, 22 Sep 2021 13:27:00 -0400
X-MC-Unique: yBKxnveKPI-3xBWZUA5Fsg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8AD6210151E1;
        Wed, 22 Sep 2021 17:26:59 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CED019724;
        Wed, 22 Sep 2021 17:26:57 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.linux.dev
Subject: [PATCH net-next 1/4] tcp: expose the tcp_mark_push() and tcp_skb_entail() helpers
Date:   Wed, 22 Sep 2021 19:26:40 +0200
Message-Id: <c7a97cc05d33a43991f5789469f254f78aa78ebf.1632318035.git.pabeni@redhat.com>
In-Reply-To: <cover.1632318035.git.pabeni@redhat.com>
References: <cover.1632318035.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the tcp_skb_entail() helper is actually skb_entail(), renamed
to provide proper scope.

    The two helper will be used by the next patch.

RFC -> v1:
 - rename skb_entail to tcp_skb_entail (Eric)

Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/tcp.h | 2 ++
 net/ipv4/tcp.c    | 8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 3166dc15d7d6..4a96f6e0f6f8 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -581,6 +581,8 @@ __u32 cookie_v6_init_sequence(const struct sk_buff *skb, __u16 *mss);
 #endif
 /* tcp_output.c */
 
+void tcp_skb_entail(struct sock *sk, struct sk_buff *skb);
+void tcp_mark_push(struct tcp_sock *tp, struct sk_buff *skb);
 void __tcp_push_pending_frames(struct sock *sk, unsigned int cur_mss,
 			       int nonagle);
 int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e8b48df73c85..c592454625e1 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -647,7 +647,7 @@ int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 }
 EXPORT_SYMBOL(tcp_ioctl);
 
-static inline void tcp_mark_push(struct tcp_sock *tp, struct sk_buff *skb)
+void tcp_mark_push(struct tcp_sock *tp, struct sk_buff *skb)
 {
 	TCP_SKB_CB(skb)->tcp_flags |= TCPHDR_PSH;
 	tp->pushed_seq = tp->write_seq;
@@ -658,7 +658,7 @@ static inline bool forced_push(const struct tcp_sock *tp)
 	return after(tp->write_seq, tp->pushed_seq + (tp->max_window >> 1));
 }
 
-static void skb_entail(struct sock *sk, struct sk_buff *skb)
+void tcp_skb_entail(struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
@@ -985,7 +985,7 @@ struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 #ifdef CONFIG_TLS_DEVICE
 		skb->decrypted = !!(flags & MSG_SENDPAGE_DECRYPTED);
 #endif
-		skb_entail(sk, skb);
+		tcp_skb_entail(sk, skb);
 		copy = size_goal;
 	}
 
@@ -1314,7 +1314,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			process_backlog++;
 			skb->ip_summed = CHECKSUM_PARTIAL;
 
-			skb_entail(sk, skb);
+			tcp_skb_entail(sk, skb);
 			copy = size_goal;
 
 			/* All packets are restored as if they have
-- 
2.26.3

