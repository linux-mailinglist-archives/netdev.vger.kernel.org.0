Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7D740FCBA
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243420AbhIQPkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:40:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47711 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243330AbhIQPke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 11:40:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631893152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U0a5YPbzRj7T4EnLfI6lSnZlEAhSaB116OUK3rRIgso=;
        b=cJVhN1nwjMpGtC0dtzE2XmUnNbFLh9529EcdLBx+OxXPGQ2o81hDYH0OYBxVBBl38hGNrn
        3QiTA+ki7FmMDFxxRb+C0LieVgVBPZdGprrnPH2q0ABLKlrv/VvP/qdG2u9JIcJqNMcy9l
        M7Pv9kZuDgJ5gNMkx8RwtSFPYgpCUvI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-Du287dFVPguyIu4BSOdiEg-1; Fri, 17 Sep 2021 11:39:08 -0400
X-MC-Unique: Du287dFVPguyIu4BSOdiEg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C5D350751;
        Fri, 17 Sep 2021 15:39:07 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E706A69CAD;
        Fri, 17 Sep 2021 15:39:05 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.linux.dev
Subject: [RFC PATCH 2/5] tcp: expose the tcp_mark_push() and skb_entail() helpers
Date:   Fri, 17 Sep 2021 17:38:37 +0200
Message-Id: <07fd053d2c2239e70b20b105ff6f33d299dabea7.1631888517.git.pabeni@redhat.com>
In-Reply-To: <cover.1631888517.git.pabeni@redhat.com>
References: <cover.1631888517.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

They will be used by the next patch.

Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/tcp.h | 2 ++
 net/ipv4/tcp.c    | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 3166dc15d7d6..dc52ea8adfc7 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -581,6 +581,8 @@ __u32 cookie_v6_init_sequence(const struct sk_buff *skb, __u16 *mss);
 #endif
 /* tcp_output.c */
 
+void skb_entail(struct sock *sk, struct sk_buff *skb);
+void tcp_mark_push(struct tcp_sock *tp, struct sk_buff *skb);
 void __tcp_push_pending_frames(struct sock *sk, unsigned int cur_mss,
 			       int nonagle);
 int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e8b48df73c85..7a3e632b0048 100644
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
+void skb_entail(struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
-- 
2.26.3

