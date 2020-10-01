Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDBA2801C6
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732586AbgJAO5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:57:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50401 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732554AbgJAO5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:57:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zsThRT9Hjbi7+eqNnKQRHyqy67LUZqTmPmL/V+XYkb4=;
        b=UbMwecCsABRPFC68IVZJyTM5R6nxJhI1oebGAl/I8KAlIJ0z9RjSPrFuaKDcXA7LyGZ986
        0blTjJ/zCHlcPRj6VzGuT2Jc0hm+bWVPhWRcjmRBxxt9enFVUOKCEBu/TFhVftz9rNtbYr
        l+VdsS+uUkXKNTVRJ+KeALcQT6GjarM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-9j7L9co4OEaNwM_GpnQW2g-1; Thu, 01 Oct 2020 10:57:13 -0400
X-MC-Unique: 9j7L9co4OEaNwM_GpnQW2g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B65622FD09;
        Thu,  1 Oct 2020 14:57:12 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E95BE10013C1;
        Thu,  1 Oct 2020 14:57:11 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 04/23] rxrpc: Downgrade the BUG() for unsupported
 token type in rxrpc_read()
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:57:11 +0100
Message-ID: <160156423114.1728886.10210377856265949650.stgit@warthog.procyon.org.uk>
In-Reply-To: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
References: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If rxrpc_read() (which allows KEYCTL_READ to read a key), sees a token of a
type it doesn't recognise, it can BUG in a couple of places, which is
unnecessary as it can easily get back to userspace.

Fix this to print an error message instead.

Fixes: 99455153d067 ("RxRPC: Parse security index 5 keys (Kerberos 5)")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/key.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 8f7d7a6187db..c668e4b7dbff 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -1107,7 +1107,8 @@ static long rxrpc_read(const struct key *key,
 			break;
 
 		default: /* we have a ticket we can't encode */
-			BUG();
+			pr_err("Unsupported key token type (%u)\n",
+			       token->security_index);
 			continue;
 		}
 
@@ -1223,7 +1224,6 @@ static long rxrpc_read(const struct key *key,
 			break;
 
 		default:
-			BUG();
 			break;
 		}
 


