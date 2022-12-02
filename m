Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA2FE63FCA8
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbiLBAQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 19:16:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiLBAQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:16:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FC1CEFA2
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669940117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4qYC6XKsXbcd0hRR1gotSuy2C9d5zoYzYBq3xZH4glY=;
        b=DP0T7xIR6DmCiUY43jxGiNgzs9c36XszZdDFZFoPS5rwSOALzUOMKqlQfB/ceoMG9eoeBk
        AKr555EDRZUR/3PvZTpkC8J1Gt17oyLJjbTErqrJ5UM0bUIpb8UD79uNao2+h+n4MfSQHH
        YhvSWf7vP/7JzJWJJBwINua/CCDxNVs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-ofMatim6PJi2TSgbaqyS7A-1; Thu, 01 Dec 2022 19:15:16 -0500
X-MC-Unique: ofMatim6PJi2TSgbaqyS7A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 406C7101A528;
        Fri,  2 Dec 2022 00:15:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98CBA111E3F8;
        Fri,  2 Dec 2022 00:15:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 01/36] rxrpc: Fix checker warning
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 02 Dec 2022 00:15:12 +0000
Message-ID: <166994011276.1732290.15928632785736482421.stgit@warthog.procyon.org.uk>
In-Reply-To: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
References: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following checker warning:

../net/rxrpc/key.c:692:9: error: subtraction of different types can't work (different address spaces)

Checker is wrong in this case, but cast the pointers to unsigned long to
avoid the warning.

Whilst we're at it, reduce the assertions to WARN_ON() and return an error.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/key.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 8d2073e0e3da..830eeffe2d5b 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -602,7 +602,8 @@ static long rxrpc_read(const struct key *key,
 		}
 
 		_debug("token[%u]: toksize=%u", ntoks, toksize);
-		ASSERTCMP(toksize, <=, AFSTOKEN_LENGTH_MAX);
+		if (WARN_ON(toksize > AFSTOKEN_LENGTH_MAX))
+			return -EIO;
 
 		toksizes[ntoks++] = toksize;
 		size += toksize + 4; /* each token has a length word */
@@ -679,8 +680,9 @@ static long rxrpc_read(const struct key *key,
 			return -ENOPKG;
 		}
 
-		ASSERTCMP((unsigned long)xdr - (unsigned long)oldxdr, ==,
-			  toksize);
+		if (WARN_ON((unsigned long)xdr - (unsigned long)oldxdr ==
+			    toksize))
+			return -EIO;
 	}
 
 #undef ENCODE_STR
@@ -688,8 +690,10 @@ static long rxrpc_read(const struct key *key,
 #undef ENCODE64
 #undef ENCODE
 
-	ASSERTCMP(tok, ==, ntoks);
-	ASSERTCMP((char __user *) xdr - buffer, ==, size);
+	if (WARN_ON(tok != ntoks))
+		return -EIO;
+	if (WARN_ON((unsigned long)xdr - (unsigned long)buffer != size))
+		return -EIO;
 	_leave(" = %zu", size);
 	return size;
 }


