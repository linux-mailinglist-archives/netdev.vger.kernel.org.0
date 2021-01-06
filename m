Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2039F2EC199
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 17:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbhAFQ6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 11:58:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31339 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727534AbhAFQ6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 11:58:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609952233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9VLLWEiPKgR359BbzU+UUPOHxLugO8L8LfVhmpzJuXo=;
        b=T86d46wmpwBM1AoFuLpGkwxSpZh4IBsyZGY1PBpQAfaNRHYQzhSC/1LPbLuNmBzUhRwDrV
        KMoWp76JtzEzainWG5aT2a6v3hsN8WWuuZe5pnhn5MnUO+JZl9+5wHhLC593r/7FWp3DHj
        cUo8lxQwdMM1BNIgGSs5MYnwW408DSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-WNuxAZqtPZSOLxYrmOAT0Q-1; Wed, 06 Jan 2021 11:57:09 -0500
X-MC-Unique: WNuxAZqtPZSOLxYrmOAT0Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6BD6107ACF6;
        Wed,  6 Jan 2021 16:57:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-8.rdu2.redhat.com [10.10.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBC265C1C4;
        Wed,  6 Jan 2021 16:57:05 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <c2cc898d-171a-25da-c565-48f57d407777@redhat.com>
References: <c2cc898d-171a-25da-c565-48f57d407777@redhat.com> <20201229173916.1459499-1-trix@redhat.com> <259549.1609764646@warthog.procyon.org.uk>
To:     Tom Rix <trix@redhat.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, kuba@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] rxrpc: fix handling of an unsupported token type in rxrpc_read()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <548096.1609952225.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 06 Jan 2021 16:57:05 +0000
Message-ID: <548097.1609952225@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

How about this?

David
---
commit 5d370a9db65a6fae82f09a009430ae40c564b0ef
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

    Fix the second loop so that it doesn't encode the size and type of an
    unsupported token, but rather just ignore it as does the first loop.
    =

    Fixes: 9a059cd5ca7d ("rxrpc: Downgrade the BUG() for unsupported token=
 type in rxrpc_read()")
    Reported-by: Tom Rix <trix@redhat.com>
    Signed-off-by: David Howells <dhowells@redhat.com>

diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 9631aa8543b5..c8e298c8d314 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -655,12 +655,12 @@ static long rxrpc_read(const struct key *key,
 	tok =3D 0;
 	for (token =3D key->payload.data[0]; token; token =3D token->next) {
 		toksize =3D toksizes[tok++];
-		ENCODE(toksize);
 		oldxdr =3D xdr;
-		ENCODE(token->security_index);
 =

 		switch (token->security_index) {
 		case RXRPC_SECURITY_RXKAD:
+			ENCODE(toksize);
+			ENCODE(token->security_index);
 			ENCODE(token->kad->vice_id);
 			ENCODE(token->kad->kvno);
 			ENCODE_BYTES(8, token->kad->session_key);

