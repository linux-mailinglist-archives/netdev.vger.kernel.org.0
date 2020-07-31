Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A8B233FD9
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgGaHSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:18:11 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:49892 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731597AbgGaHSK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 03:18:10 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 87B98205E5;
        Fri, 31 Jul 2020 09:18:09 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id qJib8_ZTXL6i; Fri, 31 Jul 2020 09:18:09 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1758E20519;
        Fri, 31 Jul 2020 09:18:09 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 31 Jul 2020 09:18:08 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 31 Jul
 2020 09:18:08 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 5F492318464F;
 Fri, 31 Jul 2020 09:18:08 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 04/10] espintcp: recv() should return 0 when the peer socket is closed
Date:   Fri, 31 Jul 2020 09:17:58 +0200
Message-ID: <20200731071804.29557-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200731071804.29557-1-steffen.klassert@secunet.com>
References: <20200731071804.29557-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

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
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
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
2.17.1

