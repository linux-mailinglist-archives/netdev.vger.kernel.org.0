Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D282B0547
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 13:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgKLM5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 07:57:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29296 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727789AbgKLM5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 07:57:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605185872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=KApSY4n0QrJwiU60IUmc5BIOxVfBJ4BfZCyb2aGAlK4=;
        b=c0pLs/LbzvaoZPYbrRv6XFD8tDboXjhxMmogFgCC2xKKZzwwFi15VDJ/zAyV5i4DHY/j9H
        e5MkOcvOJ/lwpqsvbUOqp2n+SD9Gk9OMjrTVjupLXKnnSW770ljvxGHCgVZvalLD3gD6TF
        tDmn7t8kBXXwlihLT7v5KbDABmELrK4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-LTVl2aaZOp-mAJ7msfQEwQ-1; Thu, 12 Nov 2020 07:57:50 -0500
X-MC-Unique: LTVl2aaZOp-mAJ7msfQEwQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BAE51882FAB;
        Thu, 12 Nov 2020 12:57:48 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4335A5D9E4;
        Thu, 12 Nov 2020 12:57:46 +0000 (UTC)
Subject: [RFC][PATCH 00/18] crypto: Add generic Kerberos library
From:   David Howells <dhowells@redhat.com>
To:     herbert@gondor.apana.org.au, bfields@fieldses.org
Cc:     dhowells@redhat.com, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Nov 2020 12:57:45 +0000
Message-ID: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Herbert, Bruce,

Here's my first cut at a generic Kerberos crypto library in the kernel so
that I can share code between rxrpc and sunrpc (and cifs?).

I derived some of the parts from the sunrpc gss library and added more
advanced AES and Camellia crypto.  I haven't ported across the DES-based
crypto yet - I figure that can wait a bit till the interface is sorted.

Whilst I have put it into a directory under crypto/, I haven't made an
interface that goes and loads it (analogous to crypto_alloc_skcipher,
say).  Instead, you call:

        const struct krb5_enctype *crypto_krb5_find_enctype(u32 enctype);

to go and get a handler table and then use a bunch of accessor functions to
jump through the hoops.  This is basically the way the sunrpc gsslib does
things.  It might be worth making it so you do something like:

	struct crypto_mech *ctx = crypto_mech_alloc("krb5(18)");

to get enctype 18, but I'm not sure if it's worth the effort.  Also, I'm
not sure if there are any alternatives to kerberos we will need to support.

There are three main interfaces to it:

 (*) I/O crypto: encrypt, decrypt, get_mic and verify_mic.

     These all do in-place crypto, using an sglist to define the buffer
     with the data in it.  Is it necessary to make it able to take separate
     input and output buffers?

 (*) PRF+ calculation for key derivation.
 (*) Kc, Ke, Ki derivation.

     These use krb5_buffer structs to pass objects around.  This is akin to
     the xdr_netobj, but has a void* instead of a u8* data pointer.

In terms of rxrpc's rxgk, there's another step in key derivation that isn't
part of the kerberos standard, but uses the PRF+ function to generate a key
that is then used to generate Kc, Ke and Ki.  Is it worth putting this into
the directory or maybe having a callout to insert an intermediate step in
key derivation?

Note that, for purposes of illustration, I've included some rxrpc patches
that use this interface to implement the rxgk Rx security class.  The
branch also is based on some rxrpc patches that are a prerequisite for
this, but the crypto patches don't need it.

---
The patches can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=crypto-krb5

David
---
David Howells (18):
      crypto/krb5: Implement Kerberos crypto core
      crypto/krb5: Add some constants out of sunrpc headers
      crypto/krb5: Provide infrastructure and key derivation
      crypto/krb5: Implement the Kerberos5 rfc3961 key derivation
      crypto/krb5: Implement the Kerberos5 rfc3961 encrypt and decrypt functions
      crypto/krb5: Implement the Kerberos5 rfc3961 get_mic and verify_mic
      crypto/krb5: Implement the AES enctypes from rfc3962
      crypto/krb5: Implement crypto self-testing
      crypto/krb5: Implement the AES enctypes from rfc8009
      crypto/krb5: Implement the AES encrypt/decrypt from rfc8009
      crypto/krb5: Add the AES self-testing data from rfc8009
      crypto/krb5: Implement the Camellia enctypes from rfc6803
      rxrpc: Add the security index for yfs-rxgk
      rxrpc: Add YFS RxGK (GSSAPI) security class
      rxrpc: rxgk: Provide infrastructure and key derivation
      rxrpc: rxgk: Implement the yfs-rxgk security class (GSSAPI)
      rxrpc: rxgk: Implement connection rekeying
      rxgk: Support OpenAFS's rxgk implementation


 crypto/krb5/Kconfig              |    9 +
 crypto/krb5/Makefile             |   11 +-
 crypto/krb5/internal.h           |  101 +++
 crypto/krb5/kdf.c                |  223 ++++++
 crypto/krb5/main.c               |  190 +++++
 crypto/krb5/rfc3961_simplified.c |  732 ++++++++++++++++++
 crypto/krb5/rfc3962_aes.c        |  140 ++++
 crypto/krb5/rfc6803_camellia.c   |  249 ++++++
 crypto/krb5/rfc8009_aes2.c       |  440 +++++++++++
 crypto/krb5/selftest.c           |  543 +++++++++++++
 crypto/krb5/selftest_data.c      |  289 +++++++
 fs/afs/misc.c                    |   13 +
 include/crypto/krb5.h            |  100 +++
 include/keys/rxrpc-type.h        |   17 +
 include/trace/events/rxrpc.h     |    4 +
 include/uapi/linux/rxrpc.h       |   17 +
 net/rxrpc/Kconfig                |   10 +
 net/rxrpc/Makefile               |    5 +
 net/rxrpc/ar-internal.h          |   20 +
 net/rxrpc/conn_object.c          |    2 +
 net/rxrpc/key.c                  |  319 ++++++++
 net/rxrpc/rxgk.c                 | 1232 ++++++++++++++++++++++++++++++
 net/rxrpc/rxgk_app.c             |  424 ++++++++++
 net/rxrpc/rxgk_common.h          |  164 ++++
 net/rxrpc/rxgk_kdf.c             |  271 +++++++
 net/rxrpc/security.c             |    6 +
 26 files changed, 5530 insertions(+), 1 deletion(-)
 create mode 100644 crypto/krb5/kdf.c
 create mode 100644 crypto/krb5/rfc3961_simplified.c
 create mode 100644 crypto/krb5/rfc3962_aes.c
 create mode 100644 crypto/krb5/rfc6803_camellia.c
 create mode 100644 crypto/krb5/rfc8009_aes2.c
 create mode 100644 crypto/krb5/selftest.c
 create mode 100644 crypto/krb5/selftest_data.c
 create mode 100644 net/rxrpc/rxgk.c
 create mode 100644 net/rxrpc/rxgk_app.c
 create mode 100644 net/rxrpc/rxgk_common.h
 create mode 100644 net/rxrpc/rxgk_kdf.c


