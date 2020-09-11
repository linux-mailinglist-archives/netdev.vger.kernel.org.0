Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34BF266472
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgIKQij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:38:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46296 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726364AbgIKPMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:12:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599837122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bgw7GjGyCIzt0zpVv4jK5j2Dm7NXsSA2o9iy1jtIdpo=;
        b=JG/oa5zx0T508AGnqKKKflFgk59PXx0KXeVwnPORZtkxBbxJ5ep9Q4fOepUYQIb0NeqSNM
        6Vcm54bD2V3x77nqjVdE6OMOvQ3OFR5bbD586H+EPc1zc/h7S7m/OQV1wy6VnOs4uhkGYz
        k9leqbSt7Xi8szIk0qJfbXG4GMEO/dk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-nk2RKPtSNQaAoQODcfnszA-1; Fri, 11 Sep 2020 09:52:36 -0400
X-MC-Unique: nk2RKPtSNQaAoQODcfnszA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9B8F18C5210;
        Fri, 11 Sep 2020 13:52:34 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-214.ams2.redhat.com [10.36.114.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDB255C69A;
        Fri, 11 Sep 2020 13:52:33 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next 05/13] mptcp: introduce and use mptcp_try_coalesce()
Date:   Fri, 11 Sep 2020 15:52:00 +0200
Message-Id: <24130f7d45c2a2e595b45b3d27b0290e9c0a1318.1599832097.git.pabeni@redhat.com>
In-Reply-To: <cover.1599832097.git.pabeni@redhat.com>
References: <cover.1599832097.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor-out existing code, will be re-used by the
next patch.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 4f12a8ce0ddd..5a2ff333e426 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -110,6 +110,22 @@ static int __mptcp_socket_create(struct mptcp_sock *msk)
 	return 0;
 }
 
+static bool mptcp_try_coalesce(struct sock *sk, struct sk_buff *to,
+			       struct sk_buff *from)
+{
+	bool fragstolen;
+	int delta;
+
+	if (MPTCP_SKB_CB(from)->offset ||
+	    !skb_try_coalesce(to, from, &fragstolen, &delta))
+		return false;
+
+	kfree_skb_partial(from, fragstolen);
+	atomic_add(delta, &sk->sk_rmem_alloc);
+	sk_mem_charge(sk, delta);
+	return true;
+}
+
 static void __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
 			     struct sk_buff *skb,
 			     unsigned int offset, size_t copy_len)
@@ -121,24 +137,15 @@ static void __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
 
 	skb_ext_reset(skb);
 	skb_orphan(skb);
+	MPTCP_SKB_CB(skb)->offset = offset;
 	msk->ack_seq += copy_len;
 
 	tail = skb_peek_tail(&sk->sk_receive_queue);
-	if (offset == 0 && tail) {
-		bool fragstolen;
-		int delta;
-
-		if (skb_try_coalesce(tail, skb, &fragstolen, &delta)) {
-			kfree_skb_partial(skb, fragstolen);
-			atomic_add(delta, &sk->sk_rmem_alloc);
-			sk_mem_charge(sk, delta);
-			return;
-		}
-	}
+	if (tail && mptcp_try_coalesce(sk, tail, skb))
+		return;
 
 	skb_set_owner_r(skb, sk);
 	__skb_queue_tail(&sk->sk_receive_queue, skb);
-	MPTCP_SKB_CB(skb)->offset = offset;
 }
 
 static void mptcp_stop_timer(struct sock *sk)
-- 
2.26.2

