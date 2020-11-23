Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C73C2C1624
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 21:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732778AbgKWULa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 15:11:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34723 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732747AbgKWUL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 15:11:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606162288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ayTU8pfXD3zuC5xCy5xhogMoo0+7btygjIX1vriz5kg=;
        b=VbC32Uidw5nfbW42+nqXNIExc1cM8lY9JtVmkdNZznUwyZ0UTmbmhelaghz3aSMWkKkNrQ
        KgQ6RhFZXM1QPpNHcBKoX1n2w7ZxtxwSgeegR0E3u3PkFUUMIWUbtibqDOadOv1UFGvoCJ
        zqj3L0mw7OVoSxOeSMKKOen9FldaF/Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-H0cCCR_wO0uv3l84LYNj1g-1; Mon, 23 Nov 2020 15:11:24 -0500
X-MC-Unique: H0cCCR_wO0uv3l84LYNj1g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB17E8030D3;
        Mon, 23 Nov 2020 20:11:22 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-111.rdu2.redhat.com [10.10.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE1805C1BB;
        Mon, 23 Nov 2020 20:11:21 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 11/17] rxrpc: Ignore unknown tokens in key payload
 unless no known tokens
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 23 Nov 2020 20:11:21 +0000
Message-ID: <160616228111.830164.18024627408904902488.stgit@warthog.procyon.org.uk>
In-Reply-To: <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk>
References: <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When parsing a payload for an rxrpc-type key, ignore any tokens that are
not of a known type and don't give an error for them - unless there are no
tokens of a known type.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/key.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index a9d8f5b466be..7e6d19263ce3 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -139,7 +139,7 @@ static int rxrpc_preparse_xdr(struct key_preparsed_payload *prep)
 	const char *cp;
 	unsigned int len, paddedlen, loop, ntoken, toklen, sec_ix;
 	size_t datalen = prep->datalen;
-	int ret;
+	int ret, ret2;
 
 	_enter(",{%x,%x,%x,%x},%zu",
 	       ntohl(xdr[0]), ntohl(xdr[1]), ntohl(xdr[2]), ntohl(xdr[3]),
@@ -213,6 +213,7 @@ static int rxrpc_preparse_xdr(struct key_preparsed_payload *prep)
 	/* okay: we're going to assume it's valid XDR format
 	 * - we ignore the cellname, relying on the key to be correctly named
 	 */
+	ret = -EPROTONOSUPPORT;
 	do {
 		toklen = ntohl(*xdr++);
 		token = xdr;
@@ -225,27 +226,37 @@ static int rxrpc_preparse_xdr(struct key_preparsed_payload *prep)
 
 		switch (sec_ix) {
 		case RXRPC_SECURITY_RXKAD:
-			ret = rxrpc_preparse_xdr_rxkad(prep, datalen, token, toklen);
-			if (ret != 0)
-				goto error;
+			ret2 = rxrpc_preparse_xdr_rxkad(prep, datalen, token, toklen);
+			break;
+		default:
+			ret2 = -EPROTONOSUPPORT;
 			break;
+		}
 
+		switch (ret2) {
+		case 0:
+			ret = 0;
+			break;
+		case -EPROTONOSUPPORT:
+			break;
+		case -ENOPKG:
+			if (ret != 0)
+				ret = -ENOPKG;
+			break;
 		default:
-			ret = -EPROTONOSUPPORT;
+			ret = ret2;
 			goto error;
 		}
 
 	} while (--ntoken > 0);
 
-	_leave(" = 0");
-	return 0;
+error:
+	_leave(" = %d", ret);
+	return ret;
 
 not_xdr:
 	_leave(" = -EPROTO");
 	return -EPROTO;
-error:
-	_leave(" = %d", ret);
-	return ret;
 }
 
 /*


