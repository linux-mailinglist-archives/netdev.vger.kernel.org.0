Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4D9E5291F
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 12:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbfFYKLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 06:11:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60872 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728255AbfFYKLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 06:11:35 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2772F81F25;
        Tue, 25 Jun 2019 10:11:35 +0000 (UTC)
Received: from hog.localdomain, (ovpn-204-41.brq.redhat.com [10.40.204.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1166560BE5;
        Tue, 25 Jun 2019 10:11:33 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH RFC ipsec-next 2/7] skbuff: Avoid sleeping in skb_send_sock_locked
Date:   Tue, 25 Jun 2019 12:11:35 +0200
Message-Id: <23a871790d07db86a869e98118cedd703c42b6c2.1561457281.git.sd@queasysnail.net>
In-Reply-To: <cover.1561457281.git.sd@queasysnail.net>
References: <cover.1561457281.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 25 Jun 2019 10:11:35 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

For a function that needs to be called with the socket spinlock
held, sleeping would seem to be a bad idea.  This function does
in fact avoid sleeping when calling kernel_sendpage_locked on the
page part of the skb.  However, it doesn't do that when sending
the linear part.  Resulting in sleeping when the socket send buffer
is full.

This patch fixes it by setting the MSG_DONTWAIT flag when calling
kernel_sendmsg_locked.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/core/skbuff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b50a5e3ac4e4..f863c7ef417c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2367,6 +2367,7 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
 		kv.iov_base = skb->data + offset;
 		kv.iov_len = slen;
 		memset(&msg, 0, sizeof(msg));
+		msg.msg_flags = MSG_DONTWAIT;
 
 		ret = kernel_sendmsg_locked(sk, &msg, &kv, 1, slen);
 		if (ret <= 0)
-- 
2.22.0

