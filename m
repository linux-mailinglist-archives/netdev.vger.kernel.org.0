Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3234C221DE8
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 10:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgGPIJl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 16 Jul 2020 04:09:41 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40824 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726386AbgGPIJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 04:09:40 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-fj0a6Nz-OxWogBSeZASycw-1; Thu, 16 Jul 2020 04:09:35 -0400
X-MC-Unique: fj0a6Nz-OxWogBSeZASycw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 590AE1009613;
        Thu, 16 Jul 2020 08:09:34 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.194.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 086A8710A0;
        Thu, 16 Jul 2020 08:09:32 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Andrew Cagney <cagney@libreswan.org>
Subject: [PATCH ipsec 2/3] espintcp: recv() should return 0 when the peer socket is closed
Date:   Thu, 16 Jul 2020 10:09:02 +0200
Message-Id: <2eb7a9afd12bce54668813df849c6ba2319bc828.1594287359.git.sd@queasysnail.net>
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

man 2 recv says:

    RETURN VALUE

    When a stream socket peer has performed an orderly shutdown, the
    return value will be 0 (the traditional "end-of-file" return).

Currently, this works for blocking reads, but non-blocking reads will
return -EAGAIN. This patch overwrites that return value when the peer
won't send us any more data.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Reported-by: Andrew Cagney <cagney@libreswan.org>
Tested-by: Andrew Cagney <cagney@libreswan.org>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/xfrm/espintcp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index 5d3d2b98c62d..cb83e3664680 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -109,8 +109,11 @@ static int espintcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	flags |= nonblock ? MSG_DONTWAIT : 0;
 
 	skb = __skb_recv_datagram(sk, &ctx->ike_queue, flags, &off, &err);
-	if (!skb)
+	if (!skb) {
+		if (err == -EAGAIN && sk->sk_shutdown & RCV_SHUTDOWN)
+			return 0;
 		return err;
+	}
 
 	copied = len;
 	if (copied > skb->len)
-- 
2.27.0

