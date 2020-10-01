Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0B82801D1
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732667AbgJAO5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:57:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49546 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732651AbgJAO5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:57:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pukhGR17Hped60U2lIl0rtmKGJrHBUnmeaavTCrKCdY=;
        b=eEsFKWlxfUD37pr5ZbVZ1FCb7fFEfYKH3RNfa7U6M2lr5M39vQlpHRFVdQvArgacronBkr
        YU8Lv3ooSPaa5MQ8mqkPK8TGmAyZuFPO1Z5Ncb0Xi1O5oNd5lxlrSuDo6sPu88ld6rpebN
        iR9fZheTbXAkU/Gl+2Imv6t8t6tK1rE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-MYMoYuqpOzqALlp2JweQXw-1; Thu, 01 Oct 2020 10:57:41 -0400
X-MC-Unique: MYMoYuqpOzqALlp2JweQXw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28C321054F8E;
        Thu,  1 Oct 2020 14:57:40 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 689B75D9E4;
        Thu,  1 Oct 2020 14:57:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 08/23] rxrpc: The server keyring isn't
 network-namespaced
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:57:38 +0100
Message-ID: <160156425867.1728886.2646626920686586037.stgit@warthog.procyon.org.uk>
In-Reply-To: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
References: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The keyring containing the server's tokens isn't network-namespaced, so it
shouldn't be looked up with a network namespace.  It is expected to be
owned specifically by the server, so namespacing is unnecessary.

Fixes: a58946c158a0 ("keys: Pass the network namespace into request_key mechanism")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/key.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index c668e4b7dbff..75e84ed4fa63 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -940,7 +940,7 @@ int rxrpc_server_keyring(struct rxrpc_sock *rx, sockptr_t optval, int optlen)
 	if (IS_ERR(description))
 		return PTR_ERR(description);
 
-	key = request_key_net(&key_type_keyring, description, sock_net(&rx->sk), NULL);
+	key = request_key(&key_type_keyring, description, NULL);
 	if (IS_ERR(key)) {
 		kfree(description);
 		_leave(" = %ld", PTR_ERR(key));


