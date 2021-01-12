Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F234F2F341F
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 16:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391157AbhALPZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:25:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59671 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727292AbhALPZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 10:25:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610465035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wDH3uGhZpjYzlpdmZqM/oLSKif0MBL0h3J0QCBOw+Lg=;
        b=AHNjwBFEtakuW7eLFNRro3e2kNM/PBGtPqWJ241bdeVCM5AVW1zh2EOSsrbL5t69Kx9RAx
        6Tlf+LouJORs46KJYXoFOFY0VGwAdnH1Xnzxw3wwz4LwnB4Jta/r5HdP73gHSypHzRKnx8
        7l7ZwH1keKtCW+C/oWjTLZkaGo04CHE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-sCqrVvGyNj-10isFofht1w-1; Tue, 12 Jan 2021 10:23:53 -0500
X-MC-Unique: sCqrVvGyNj-10isFofht1w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D99F01835861;
        Tue, 12 Jan 2021 15:23:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-8.rdu2.redhat.com [10.10.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3BA760C5D;
        Tue, 12 Jan 2021 15:23:51 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: Fix handling of an unsupported token type in
 rxrpc_read()
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Tom Rix <trix@redhat.com>, Tom Rix <trix@redhat.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com
Date:   Tue, 12 Jan 2021 15:23:51 +0000
Message-ID: <161046503122.2445787.16714129930607546635.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang static analysis reports the following:

net/rxrpc/key.c:657:11: warning: Assigned value is garbage or undefined
                toksize = toksizes[tok++];
                        ^ ~~~~~~~~~~~~~~~

rxrpc_read() contains two consecutive loops.  The first loop calculates the
token sizes and stores the results in toksizes[] and the second one uses
the array.  When there is an error in identifying the token in the first
loop, the token is skipped, no change is made to the toksizes[] array.
When the same error happens in the second loop, the token is not skipped.
This will cause the toksizes[] array to be out of step and will overrun
past the calculated sizes.

Fix this by making both loops log a message and return an error in this
case.  This should only happen if a new token type is incompletely
implemented, so it should normally be impossible to trigger this.

Fixes: 9a059cd5ca7d ("rxrpc: Downgrade the BUG() for unsupported token type in rxrpc_read()")
Reported-by: Tom Rix <trix@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Tom Rix <trix@redhat.com>
---

 net/rxrpc/key.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 9631aa8543b5..8d2073e0e3da 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -598,7 +598,7 @@ static long rxrpc_read(const struct key *key,
 		default: /* we have a ticket we can't encode */
 			pr_err("Unsupported key token type (%u)\n",
 			       token->security_index);
-			continue;
+			return -ENOPKG;
 		}
 
 		_debug("token[%u]: toksize=%u", ntoks, toksize);
@@ -674,7 +674,9 @@ static long rxrpc_read(const struct key *key,
 			break;
 
 		default:
-			break;
+			pr_err("Unsupported key token type (%u)\n",
+			       token->security_index);
+			return -ENOPKG;
 		}
 
 		ASSERTCMP((unsigned long)xdr - (unsigned long)oldxdr, ==,


