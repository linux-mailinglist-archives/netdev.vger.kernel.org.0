Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C959022AD2B
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgGWLDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:03:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38278 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728396AbgGWLDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:03:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595502189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n0tivQwLahFE9iRdcZ4VDUmNKMUeGivqv4GUniCtPYM=;
        b=Gy7FkS4j3JKycYGI67vBq+50eDTN8wuyuNLIvV2vw95UQHU+8E6TRBrhStd8BskutuGZFv
        41xMEzkHFMZq4iM372VT7zbZkn9VfQz7a2qXjKz7NY3gHNx1Ahv3R8lPP1KJOJ24oqpH3N
        Osl3KATkGErD5RuNsjrcncBryBaF67g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-Hmb2Nea-MUS4NVNpDSWYaA-1; Thu, 23 Jul 2020 07:03:07 -0400
X-MC-Unique: Hmb2Nea-MUS4NVNpDSWYaA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D26231B2C980;
        Thu, 23 Jul 2020 11:03:05 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-113-9.ams2.redhat.com [10.36.113.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1D228BED5;
        Thu, 23 Jul 2020 11:03:04 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, mptcp@lists.01.org
Subject: [PATCH net-next 5/8] mptcp: cleanup subflow_finish_connect()
Date:   Thu, 23 Jul 2020 13:02:33 +0200
Message-Id: <d42c2e757008d4b404d82c918d3b6ae56cfa2a0f.1595431326.git.pabeni@redhat.com>
In-Reply-To: <cover.1595431326.git.pabeni@redhat.com>
References: <cover.1595431326.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mentioned function has several unneeded branches,
handle each case - MP_CAPABLE, MP_JOIN, fallback -
under a single conditional and drop quite a bit of
duplicate code.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 56 ++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 31 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index ea81842fc3b2..7f3ef1840df5 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -206,44 +206,34 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 	pr_debug("subflow=%p synack seq=%x", subflow, subflow->ssn_offset);
 
 	mptcp_get_options(skb, &mp_opt);
-	if (subflow->request_mptcp && mp_opt.mp_capable) {
+	if (subflow->request_mptcp) {
+		if (!mp_opt.mp_capable) {
+			MPTCP_INC_STATS(sock_net(sk),
+					MPTCP_MIB_MPCAPABLEACTIVEFALLBACK);
+			mptcp_do_fallback(sk);
+			pr_fallback(mptcp_sk(subflow->conn));
+			goto fallback;
+		}
+
 		subflow->mp_capable = 1;
 		subflow->can_ack = 1;
 		subflow->remote_key = mp_opt.sndr_key;
 		pr_debug("subflow=%p, remote_key=%llu", subflow,
 			 subflow->remote_key);
-	} else if (subflow->request_join && mp_opt.mp_join) {
-		subflow->mp_join = 1;
+		mptcp_finish_connect(sk);
+	} else if (subflow->request_join) {
+		u8 hmac[SHA256_DIGEST_SIZE];
+
+		if (!mp_opt.mp_join)
+			goto do_reset;
+
 		subflow->thmac = mp_opt.thmac;
 		subflow->remote_nonce = mp_opt.nonce;
 		pr_debug("subflow=%p, thmac=%llu, remote_nonce=%u", subflow,
 			 subflow->thmac, subflow->remote_nonce);
-	} else {
-		if (subflow->request_mptcp)
-			MPTCP_INC_STATS(sock_net(sk),
-					MPTCP_MIB_MPCAPABLEACTIVEFALLBACK);
-		mptcp_do_fallback(sk);
-		pr_fallback(mptcp_sk(subflow->conn));
-	}
 
-	if (mptcp_check_fallback(sk)) {
-		mptcp_rcv_space_init(mptcp_sk(parent), sk);
-		return;
-	}
-
-	if (subflow->mp_capable) {
-		pr_debug("subflow=%p, remote_key=%llu", mptcp_subflow_ctx(sk),
-			 subflow->remote_key);
-		mptcp_finish_connect(sk);
-	} else if (subflow->mp_join) {
-		u8 hmac[SHA256_DIGEST_SIZE];
-
-		pr_debug("subflow=%p, thmac=%llu, remote_nonce=%u",
-			 subflow, subflow->thmac,
-			 subflow->remote_nonce);
 		if (!subflow_thmac_valid(subflow)) {
 			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_JOINACKMAC);
-			subflow->mp_join = 0;
 			goto do_reset;
 		}
 
@@ -251,18 +241,22 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 				      subflow->local_nonce,
 				      subflow->remote_nonce,
 				      hmac);
-
 		memcpy(subflow->hmac, hmac, MPTCPOPT_HMAC_LEN);
 
 		if (!mptcp_finish_join(sk))
 			goto do_reset;
 
+		subflow->mp_join = 1;
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_JOINSYNACKRX);
-	} else {
-do_reset:
-		tcp_send_active_reset(sk, GFP_ATOMIC);
-		tcp_done(sk);
+	} else if (mptcp_check_fallback(sk)) {
+fallback:
+		mptcp_rcv_space_init(mptcp_sk(parent), sk);
 	}
+	return;
+
+do_reset:
+	tcp_send_active_reset(sk, GFP_ATOMIC);
+	tcp_done(sk);
 }
 
 static struct request_sock_ops subflow_request_sock_ops;
-- 
2.26.2

