Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570B31ACB4F
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 17:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895232AbgDPPqB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 16 Apr 2020 11:46:01 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52751 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2895234AbgDPPp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 11:45:59 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-0CiRGiNSPk27eLmjOk-pBw-1; Thu, 16 Apr 2020 11:45:54 -0400
X-MC-Unique: 0CiRGiNSPk27eLmjOk-pBw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B3DF8017F3;
        Thu, 16 Apr 2020 15:45:53 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.195.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 91E2618A85;
        Thu, 16 Apr 2020 15:45:51 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec] xfrm: espintcp: save and call old ->sk_destruct
Date:   Thu, 16 Apr 2020 17:45:44 +0200
Message-Id: <bb90145107e53739544bd7f2190eac26fdd4cd3c.1587050109.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ESP encapsulation is enabled on a TCP socket, I'm replacing the
existing ->sk_destruct callback with espintcp_destruct. We still need to
call the old callback to perform the other cleanups when the socket is
destroyed. Save the old callback, and call it from espintcp_destruct.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
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
2.26.1

