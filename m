Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF27221DE7
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 10:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgGPIJj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 16 Jul 2020 04:09:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60401 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726386AbgGPIJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 04:09:38 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-Al_SaUPtMjyiMdVHCO7Iag-1; Thu, 16 Jul 2020 04:09:33 -0400
X-MC-Unique: Al_SaUPtMjyiMdVHCO7Iag-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7682C7466;
        Thu, 16 Jul 2020 08:09:32 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.194.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D431710A0;
        Thu, 16 Jul 2020 08:09:31 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Andrew Cagney <cagney@libreswan.org>
Subject: [PATCH ipsec 1/3] espintcp: support non-blocking sends
Date:   Thu, 16 Jul 2020 10:09:01 +0200
Message-Id: <ac2d70702ed637b8da4cd5cf4864995fb6853883.1594287359.git.sd@queasysnail.net>
In-Reply-To: <cover.1594287359.git.sd@queasysnail.net>
References: <cover.1594287359.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, non-blocking sends from userspace result in EOPNOTSUPP.

To support this, we need to tell espintcp_sendskb_locked() and
espintcp_sendskmsg_locked() that non-blocking operation was requested
from espintcp_sendmsg().

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Reported-by: Andrew Cagney <cagney@libreswan.org>
Tested-by: Andrew Cagney <cagney@libreswan.org>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
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
2.27.0

