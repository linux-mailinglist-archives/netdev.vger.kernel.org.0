Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9460E283C4B
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 18:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728937AbgJEQTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 12:19:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25305 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728572AbgJEQTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 12:19:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601914769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pukhGR17Hped60U2lIl0rtmKGJrHBUnmeaavTCrKCdY=;
        b=ed1KX5TsCn1yWYXJf2W/qjnVkyzyc4ysF4lbTKQWpSet/PmsGzNrPlfAfKjG/CtOGbdB7T
        NNJU6VEum95z5PGlK3WPRFNcnd6oFQmLbad+3BODvLGNkfS8fVCQkd4L3ML038ITysp8oW
        BlHFK9tHt5pLD55oUQNe5CFfrs72LJQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445--BXL_3B8NF6pIDz--7TE1w-1; Mon, 05 Oct 2020 12:19:25 -0400
X-MC-Unique: -BXL_3B8NF6pIDz--7TE1w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D542805EE2;
        Mon,  5 Oct 2020 16:19:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D15F81002D42;
        Mon,  5 Oct 2020 16:19:23 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 5/6] rxrpc: The server keyring isn't network-namespaced
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 05 Oct 2020 17:19:23 +0100
Message-ID: <160191476306.3050642.10336748733343433067.stgit@warthog.procyon.org.uk>
In-Reply-To: <160191472433.3050642.12600839710302704718.stgit@warthog.procyon.org.uk>
References: <160191472433.3050642.12600839710302704718.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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


