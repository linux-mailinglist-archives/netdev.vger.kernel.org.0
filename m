Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CBD2686C1
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 10:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgINIDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 04:03:43 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51007 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgINIBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 04:01:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600070510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bgw7GjGyCIzt0zpVv4jK5j2Dm7NXsSA2o9iy1jtIdpo=;
        b=eiZ9zmkweMXbA1dJGdYgb8dK1/iILmsv74QfiYiVmG5SvcXNEmualycccJLWzttxFDQMRu
        vT9htxX4E2RLXkYe34q0tyBLvzzGS+oKNlBJ0vLMghk5NVcaQfsFPKnFCnDrieUDmfJ/5I
        JM7O0m9DPa5i5bXJ28CZLgSbeAe2AsE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-TJmbGrvMOvOcZUZoCb48xA-1; Mon, 14 Sep 2020 04:01:46 -0400
X-MC-Unique: TJmbGrvMOvOcZUZoCb48xA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1718C10BBECF;
        Mon, 14 Sep 2020 08:01:45 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-112-96.ams2.redhat.com [10.36.112.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA33C19C66;
        Mon, 14 Sep 2020 08:01:43 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next v2 05/13] mptcp: introduce and use mptcp_try_coalesce()
Date:   Mon, 14 Sep 2020 10:01:11 +0200
Message-Id: <39b392036de70a64726b19e7bb851a53ec90f134.1599854632.git.pabeni@redhat.com>
In-Reply-To: <cover.1599854632.git.pabeni@redhat.com>
References: <cover.1599854632.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

