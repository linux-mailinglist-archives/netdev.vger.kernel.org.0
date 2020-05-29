Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F211E7B50
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 13:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgE2LKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 07:10:51 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:39922 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbgE2LKp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 07:10:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 31351205AE;
        Fri, 29 May 2020 13:10:43 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id s8psx1zw2dSf; Fri, 29 May 2020 13:10:42 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4211F205DB;
        Fri, 29 May 2020 13:10:42 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 13:10:42 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 13:10:41 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 26D30318032D;
 Fri, 29 May 2020 13:04:12 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 06/15] xfrm: espintcp: save and call old ->sk_destruct
Date:   Fri, 29 May 2020 13:03:59 +0200
Message-ID: <20200529110408.6349-7-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529110408.6349-1-steffen.klassert@secunet.com>
References: <20200529110408.6349-1-steffen.klassert@secunet.com>
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

When ESP encapsulation is enabled on a TCP socket, I'm replacing the
existing ->sk_destruct callback with espintcp_destruct. We still need to
call the old callback to perform the other cleanups when the socket is
destroyed. Save the old callback, and call it from espintcp_destruct.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/espintcp.h | 1 +
 net/xfrm/espintcp.c    | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/net/espintcp.h b/include/net/espintcp.h
index dd7026a00066..0335bbd76552 100644
--- a/include/net/espintcp.h
+++ b/include/net/espintcp.h
@@ -25,6 +25,7 @@ struct espintcp_ctx {
 	struct espintcp_msg partial;
 	void (*saved_data_ready)(struct sock *sk);
 	void (*saved_write_space)(struct sock *sk);
+	void (*saved_destruct)(struct sock *sk);
 	struct work_struct work;
 	bool tx_running;
 };
diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index 037ea156d2f9..5a0ff665b71a 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -379,6 +379,7 @@ static void espintcp_destruct(struct sock *sk)
 {
 	struct espintcp_ctx *ctx = espintcp_getctx(sk);
 
+	ctx->saved_destruct(sk);
 	kfree(ctx);
 }
 
@@ -419,6 +420,7 @@ static int espintcp_init_sk(struct sock *sk)
 	sk->sk_socket->ops = &espintcp_ops;
 	ctx->saved_data_ready = sk->sk_data_ready;
 	ctx->saved_write_space = sk->sk_write_space;
+	ctx->saved_destruct = sk->sk_destruct;
 	sk->sk_data_ready = espintcp_data_ready;
 	sk->sk_write_space = espintcp_write_space;
 	sk->sk_destruct = espintcp_destruct;
-- 
2.17.1

