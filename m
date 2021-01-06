Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C7E2EC290
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbhAFRlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:41:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31635 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727372AbhAFRlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 12:41:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609954820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q1MVJV23rzhHmpdk2zEeUSOCj3KMipI7dPGLT5s4mXo=;
        b=CzE6hsZ4wop+2pfPjl6hzm8dWoe4TpiqGN1mUHWwm6yBJvjsrQPv6E8I5w6dATJYYY4Ao7
        8xFoM6WzgGzCYw0fjMFYf0Wz5hCyFPkrWBSla8zISHpSBO42eOroLSGA82HY9f2QXlDAJ7
        b691ykCJhrlOUhBEDghJT8e3IoZ48WA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-b_I-VHIKMvyWMuReIdF9gg-1; Wed, 06 Jan 2021 12:40:17 -0500
X-MC-Unique: b_I-VHIKMvyWMuReIdF9gg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E2BD18C8C00;
        Wed,  6 Jan 2021 17:40:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-8.rdu2.redhat.com [10.10.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FE5A5B6A2;
        Wed,  6 Jan 2021 17:40:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <548097.1609952225@warthog.procyon.org.uk>
References: <548097.1609952225@warthog.procyon.org.uk> <c2cc898d-171a-25da-c565-48f57d407777@redhat.com> <20201229173916.1459499-1-trix@redhat.com> <259549.1609764646@warthog.procyon.org.uk>
To:     Tom Rix <trix@redhat.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, kuba@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] rxrpc: fix handling of an unsupported token type in rxrpc_read()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <675149.1609954812.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 06 Jan 2021 17:40:12 +0000
Message-ID: <675150.1609954812@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> How about this?
> ...
>     Fix the second loop so that it doesn't encode the size and type of a=
n
>     unsupported token, but rather just ignore it as does the first loop.

Actually, a better way is probably just to error out in this case.  This
should only happen if a new token type is incompletely implemented.

David
---
commit e68ef16f59aa57564761b21e5ecb2ebbd72d1c57
Author: David Howells <dhowells@redhat.com>
Date:   Wed Jan 6 16:21:40 2021 +0000

    rxrpc: Fix handling of an unsupported token type in rxrpc_read()
    =

    Clang static analysis reports the following:
    =

    net/rxrpc/key.c:657:11: warning: Assigned value is garbage or undefine=
d
                    toksize =3D toksizes[tok++];
                            ^ ~~~~~~~~~~~~~~~
    =

    rxrpc_read() contains two consecutive loops.  The first loop calculate=
s the
    token sizes and stores the results in toksizes[] and the second one us=
es
    the array.  When there is an error in identifying the token in the fir=
st
    loop, the token is skipped, no change is made to the toksizes[] array.
    When the same error happens in the second loop, the token is not skipp=
ed.
    This will cause the toksizes[] array to be out of step and will overru=
n
    past the calculated sizes.
    =

    Fix this by making both loops log a message and return an error in thi=
s
    case.  This should only happen if a new token type is incompletely
    implemented, so it should normally be impossible to trigger this.
    =

    Fixes: 9a059cd5ca7d ("rxrpc: Downgrade the BUG() for unsupported token=
 type in rxrpc_read()")
    Reported-by: Tom Rix <trix@redhat.com>
    Signed-off-by: David Howells <dhowells@redhat.com>

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
 =

 		_debug("token[%u]: toksize=3D%u", ntoks, toksize);
@@ -674,7 +674,9 @@ static long rxrpc_read(const struct key *key,
 			break;
 =

 		default:
-			break;
+			pr_err("Unsupported key token type (%u)\n",
+			       token->security_index);
+			return -ENOPKG;
 		}
 =

 		ASSERTCMP((unsigned long)xdr - (unsigned long)oldxdr, =3D=3D,

