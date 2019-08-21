Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09BC7986C6
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 23:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730956AbfHUVqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 17:46:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37116 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730950AbfHUVqC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 17:46:02 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 550CF8980FD;
        Wed, 21 Aug 2019 21:46:02 +0000 (UTC)
Received: from hog.localdomain, (ovpn-204-30.brq.redhat.com [10.40.204.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C7D9194B9;
        Wed, 21 Aug 2019 21:46:01 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 2/7] skbuff: Avoid sleeping in skb_send_sock_locked
Date:   Wed, 21 Aug 2019 23:46:20 +0200
Message-Id: <8a35b931932ed65b88cbb01e278973029b504cd7.1566395202.git.sd@queasysnail.net>
In-Reply-To: <cover.1566395202.git.sd@queasysnail.net>
References: <cover.1566395202.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Wed, 21 Aug 2019 21:46:02 +0000 (UTC)
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

