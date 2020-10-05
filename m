Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB2D283C46
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 18:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbgJEQTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 12:19:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29401 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728637AbgJEQTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 12:19:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601914742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zsThRT9Hjbi7+eqNnKQRHyqy67LUZqTmPmL/V+XYkb4=;
        b=d7HYeGBJvuXktALAhOVnnIRL6SUMWE51ZOapz7S7b8VU5/jIEf6WX9N4qu6AhS2E0H+Sfl
        MOLTQ4AmZfQDgIS6RXsjbm7KY5oNhFjHUVJ55AQzGRVAwgEGIjDm/oE9FsaPTXwL30cPXD
        dYvXqtnWW1K3Tv8V+KPo1KFkZWCJFRI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-rB1R95yxNVKcKqqiGia9gg-1; Mon, 05 Oct 2020 12:19:01 -0400
X-MC-Unique: rB1R95yxNVKcKqqiGia9gg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C1241054F8A;
        Mon,  5 Oct 2020 16:19:00 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4ECC85C26B;
        Mon,  5 Oct 2020 16:18:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 2/6] rxrpc: Downgrade the BUG() for unsupported token type
 in rxrpc_read()
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 05 Oct 2020 17:18:58 +0100
Message-ID: <160191473856.3050642.11077666467325613108.stgit@warthog.procyon.org.uk>
In-Reply-To: <160191472433.3050642.12600839710302704718.stgit@warthog.procyon.org.uk>
References: <160191472433.3050642.12600839710302704718.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
 


