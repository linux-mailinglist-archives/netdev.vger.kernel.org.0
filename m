Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60273283C4F
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 18:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgJEQTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 12:19:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27928 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727129AbgJEQTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 12:19:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601914774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=io5YUcWL7Pp/Mqno+O0YCVHUfi/wn5QScVgsf4nCP4o=;
        b=OSbhvWCKGvYW3C6WoTBtkervVMzijCGcXFk2dJYEnYZkdjTino6w0PNwj51Lq1Dk0mZKNV
        j4AdUEvA5GdnIGZVzYiGeuvz8AXFtkQaIneO3bIIiISTkGBYC2U2sgZ9gqSTWxnme4BL6h
        Bu6I+pc28mNYbTjdFkYQh7RQvUk7xT8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-hAxIkccgMBaPXHMUfNm7HQ-1; Mon, 05 Oct 2020 12:19:32 -0400
X-MC-Unique: hAxIkccgMBaPXHMUfNm7HQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FD00802B77;
        Mon,  5 Oct 2020 16:19:31 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E88A7BE5B;
        Mon,  5 Oct 2020 16:19:30 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 6/6] rxrpc: Fix server keyring leak
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 05 Oct 2020 17:19:29 +0100
Message-ID: <160191476986.3050642.7580243203219246840.stgit@warthog.procyon.org.uk>
In-Reply-To: <160191472433.3050642.12600839710302704718.stgit@warthog.procyon.org.uk>
References: <160191472433.3050642.12600839710302704718.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If someone calls setsockopt() twice to set a server key keyring, the first
keyring is leaked.

Fix it to return an error instead if the server key keyring is already set.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/key.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 75e84ed4fa63..2e8bd3b97301 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -903,7 +903,7 @@ int rxrpc_request_key(struct rxrpc_sock *rx, sockptr_t optval, int optlen)
 
 	_enter("");
 
-	if (optlen <= 0 || optlen > PAGE_SIZE - 1)
+	if (optlen <= 0 || optlen > PAGE_SIZE - 1 || rx->securities)
 		return -EINVAL;
 
 	description = memdup_sockptr_nul(optval, optlen);


