Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57F4233FDA
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731654AbgGaHSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:18:12 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:49910 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731567AbgGaHSL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 03:18:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 12338205EA;
        Fri, 31 Jul 2020 09:18:10 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id o9HinoBf-vDA; Fri, 31 Jul 2020 09:18:09 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 510EC205CB;
        Fri, 31 Jul 2020 09:18:09 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 31 Jul 2020 09:18:09 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 31 Jul
 2020 09:18:08 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 5A97A318464E;
 Fri, 31 Jul 2020 09:18:08 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 03/10] espintcp: support non-blocking sends
Date:   Fri, 31 Jul 2020 09:17:57 +0200
Message-ID: <20200731071804.29557-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200731071804.29557-1-steffen.klassert@secunet.com>
References: <20200731071804.29557-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

Currently, non-blocking sends from userspace result in EOPNOTSUPP.

To support this, we need to tell espintcp_sendskb_locked() and
espintcp_sendskmsg_locked() that non-blocking operation was requested
from espintcp_sendmsg().

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Reported-by: Andrew Cagney <cagney@libreswan.org>
Tested-by: Andrew Cagney <cagney@libreswan.org>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/espintcp.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index 100e29682b48..5d3d2b98c62d 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -213,7 +213,7 @@ static int espintcp_sendskmsg_locked(struct sock *sk,
 	return 0;
 }
 
-static int espintcp_push_msgs(struct sock *sk)
+static int espintcp_push_msgs(struct sock *sk, int flags)
 {
 	struct espintcp_ctx *ctx = espintcp_getctx(sk);
 	struct espintcp_msg *emsg = &ctx->partial;
@@ -227,12 +227,12 @@ static int espintcp_push_msgs(struct sock *sk)
 	ctx->tx_running = 1;
 
 	if (emsg->skb)
-		err = espintcp_sendskb_locked(sk, emsg, 0);
+		err = espintcp_sendskb_locked(sk, emsg, flags);
 	else
-		err = espintcp_sendskmsg_locked(sk, emsg, 0);
+		err = espintcp_sendskmsg_locked(sk, emsg, flags);
 	if (err == -EAGAIN) {
 		ctx->tx_running = 0;
-		return 0;
+		return flags & MSG_DONTWAIT ? -EAGAIN : 0;
 	}
 	if (!err)
 		memset(emsg, 0, sizeof(*emsg));
@@ -257,7 +257,7 @@ int espintcp_push_skb(struct sock *sk, struct sk_buff *skb)
 	offset = skb_transport_offset(skb);
 	len = skb->len - offset;
 
-	espintcp_push_msgs(sk);
+	espintcp_push_msgs(sk, 0);
 
 	if (emsg->len) {
 		kfree_skb(skb);
@@ -270,7 +270,7 @@ int espintcp_push_skb(struct sock *sk, struct sk_buff *skb)
 	emsg->len = len;
 	emsg->skb = skb;
 
-	espintcp_push_msgs(sk);
+	espintcp_push_msgs(sk, 0);
 
 	return 0;
 }
@@ -287,7 +287,7 @@ static int espintcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	char buf[2] = {0};
 	int err, end;
 
-	if (msg->msg_flags)
+	if (msg->msg_flags & ~MSG_DONTWAIT)
 		return -EOPNOTSUPP;
 
 	if (size > MAX_ESPINTCP_MSG)
@@ -298,9 +298,10 @@ static int espintcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 
 	lock_sock(sk);
 
-	err = espintcp_push_msgs(sk);
+	err = espintcp_push_msgs(sk, msg->msg_flags & MSG_DONTWAIT);
 	if (err < 0) {
-		err = -ENOBUFS;
+		if (err != -EAGAIN || !(msg->msg_flags & MSG_DONTWAIT))
+			err = -ENOBUFS;
 		goto unlock;
 	}
 
@@ -337,10 +338,9 @@ static int espintcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 
 	tcp_rate_check_app_limited(sk);
 
-	err = espintcp_push_msgs(sk);
+	err = espintcp_push_msgs(sk, msg->msg_flags & MSG_DONTWAIT);
 	/* this message could be partially sent, keep it */
-	if (err < 0)
-		goto unlock;
+
 	release_sock(sk);
 
 	return size;
@@ -374,7 +374,7 @@ static void espintcp_tx_work(struct work_struct *work)
 
 	lock_sock(sk);
 	if (!ctx->tx_running)
-		espintcp_push_msgs(sk);
+		espintcp_push_msgs(sk, 0);
 	release_sock(sk);
 }
 
-- 
2.17.1

