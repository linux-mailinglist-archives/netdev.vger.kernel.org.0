Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAC4290988
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 18:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405614AbgJPQSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 12:18:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30607 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2410004AbgJPQSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 12:18:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602865114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=y+hjVI66PfcmwJlWfVwVOTQ6i8qhG0kIQEYwSMKlTRs=;
        b=FhJjkaAmVMEEZkf71mIjkyO+l0W/4D7YMf+IOLej1MHCryMHsIqVLgD5+fc98lsH1yTi0w
        ljFXoMaq8S0aDqI4ZzMQsjHaQEjwHyH8JK8KVII31U81IzmYcaW9UatL48yFFXu2VukqxR
        G+xuTGlQE0xxFhnvmPHIZOqRHmPU7g8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-hJhe2FRRP26PUE3ZREH50Q-1; Fri, 16 Oct 2020 12:18:31 -0400
X-MC-Unique: hJhe2FRRP26PUE3ZREH50Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7400A80365F;
        Fri, 16 Oct 2020 16:18:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-70.rdu2.redhat.com [10.10.120.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A5CB60C04;
        Fri, 16 Oct 2020 16:18:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        trond.myklebust@hammerspace.com
cc:     dhowells@redhat.com, linux-crypto@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-afs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: gssapi, crypto and afs/rxrpc
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1444463.1602865106.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 16 Oct 2020 17:18:26 +0100
Message-ID: <1444464.1602865106@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Herbert, Dave, Trond,

I've written basic gssapi-derived security support for AF_RXRPC:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log=
/?h=3Drxrpc-rxgk

I've borrowed some bits from net/sunrpc/auth_gss/ but there's a lot in the=
re
that is quite specific to the sunrpc module that makes it hard to use for
rxrpc (dprintk, struct xdr_buf).

Further, I've implemented some more enctypes that aren't supported yet by
gssapi (AES with sha256/sha384 and Camellia), and that requires some chang=
es
to the handling as AES with sha384 has a 24-byte checksum size and a 24-by=
te
calculated key size for Kc and Ki but a 32-byte Ke.

Should I pull the core out and try to make it common?  If so, should I mov=
e it
to crypto/ or lib/, or perhaps put it in net/gssapi/?

There are two components to it:

 (1) Key derivation steps.

     My thought is to use xdr_netobj or something similar for to communica=
te
     between the steps (though I'd prefer to change .data to be a void* ra=
ther
     than u8*).

 (2) Encryption/checksumming.

     My thought is to make this interface use scattergather lists[*] since
     that's what the crypto encryption API requires (though not the hash A=
PI).

If I do this, should I create a "kerberos" crypto API for the data wrappin=
g
functions?  I'm not sure that it quite matches the existing APIs because t=
he
size of the input data will likely not match the size of the output data a=
nd
it's "one shot" as it needs to deal with a checksum.

Or I can just keep my implementation separate inside net/rxrpc/.

David

[*] That said, I'm not exactly sure how the sunrpc stuff works, so this mi=
ght
not work for that.

