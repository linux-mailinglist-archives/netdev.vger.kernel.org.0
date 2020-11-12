Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B49A2B0CCB
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgKLShT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgKLShS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 13:37:18 -0500
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD0CC0613D1;
        Thu, 12 Nov 2020 10:37:18 -0800 (PST)
Received: by fieldses.org (Postfix, from userid 2815)
        id CB93C1E3B; Thu, 12 Nov 2020 13:37:17 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org CB93C1E3B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1605206237;
        bh=Ig7MoAhTLZXaNQ4E5S7TOqyF6MAcb4TbDz8tkp3ULV4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NSOjEa8OJOqemBTKNSUMH9tbkGbtDT33jE35eFxfkaA1/Mw7Zp4fMtsBEgZEbjYef
         te6bVwm4WSrBylhHkrZB84kR006+dyyCR722LipKqxYjqxeg113qWIhK8d0WDegYXa
         Ds9Ls2BVkx3HxWMmt1Mqd1EhSspO9o9DQ1Qa9ZmQ=
Date:   Thu, 12 Nov 2020 13:37:17 -0500
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     David Howells <dhowells@redhat.com>
Cc:     herbert@gondor.apana.org.au, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/18] crypto: Add generic Kerberos library
Message-ID: <20201112183717.GH9243@fieldses.org>
References: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 12:57:45PM +0000, David Howells wrote:
> 
> Hi Herbert, Bruce,
> 
> Here's my first cut at a generic Kerberos crypto library in the kernel so
> that I can share code between rxrpc and sunrpc (and cifs?).
> 
> I derived some of the parts from the sunrpc gss library and added more
> advanced AES and Camellia crypto.  I haven't ported across the DES-based
> crypto yet - I figure that can wait a bit till the interface is sorted.
> 
> Whilst I have put it into a directory under crypto/, I haven't made an
> interface that goes and loads it (analogous to crypto_alloc_skcipher,
> say).  Instead, you call:
> 
>         const struct krb5_enctype *crypto_krb5_find_enctype(u32 enctype);
> 
> to go and get a handler table and then use a bunch of accessor functions to
> jump through the hoops.  This is basically the way the sunrpc gsslib does
> things.  It might be worth making it so you do something like:
> 
> 	struct crypto_mech *ctx = crypto_mech_alloc("krb5(18)");
> 
> to get enctype 18, but I'm not sure if it's worth the effort.  Also, I'm
> not sure if there are any alternatives to kerberos we will need to support.

We did have code for a non-krb5 mechanism at some point, but it was torn
out.  So I don't think that's a priority.

(Chuck, will RPC-over-SSL need a new non-krb5 mechanism?)

> There are three main interfaces to it:
> 
>  (*) I/O crypto: encrypt, decrypt, get_mic and verify_mic.
> 
>      These all do in-place crypto, using an sglist to define the buffer
>      with the data in it.  Is it necessary to make it able to take separate
>      input and output buffers?

I don't know.  My memory is that the buffer management in the existing
rpcsec_gss code is complex and fragile.  See e.g. the long comment in
gss_krb5_remove_padding.

--b.

>  (*) PRF+ calculation for key derivation.
>  (*) Kc, Ke, Ki derivation.
> 
>      These use krb5_buffer structs to pass objects around.  This is akin to
>      the xdr_netobj, but has a void* instead of a u8* data pointer.
> 
> In terms of rxrpc's rxgk, there's another step in key derivation that isn't
> part of the kerberos standard, but uses the PRF+ function to generate a key
> that is then used to generate Kc, Ke and Ki.  Is it worth putting this into
> the directory or maybe having a callout to insert an intermediate step in
> key derivation?
> 
> Note that, for purposes of illustration, I've included some rxrpc patches
> that use this interface to implement the rxgk Rx security class.  The
> branch also is based on some rxrpc patches that are a prerequisite for
> this, but the crypto patches don't need it.
> 
> ---
> The patches can be found here also:
> 
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=crypto-krb5
> 
> David
> ---
> David Howells (18):
>       crypto/krb5: Implement Kerberos crypto core
>       crypto/krb5: Add some constants out of sunrpc headers
>       crypto/krb5: Provide infrastructure and key derivation
>       crypto/krb5: Implement the Kerberos5 rfc3961 key derivation
>       crypto/krb5: Implement the Kerberos5 rfc3961 encrypt and decrypt functions
>       crypto/krb5: Implement the Kerberos5 rfc3961 get_mic and verify_mic
>       crypto/krb5: Implement the AES enctypes from rfc3962
>       crypto/krb5: Implement crypto self-testing
>       crypto/krb5: Implement the AES enctypes from rfc8009
>       crypto/krb5: Implement the AES encrypt/decrypt from rfc8009
>       crypto/krb5: Add the AES self-testing data from rfc8009
>       crypto/krb5: Implement the Camellia enctypes from rfc6803
>       rxrpc: Add the security index for yfs-rxgk
>       rxrpc: Add YFS RxGK (GSSAPI) security class
>       rxrpc: rxgk: Provide infrastructure and key derivation
>       rxrpc: rxgk: Implement the yfs-rxgk security class (GSSAPI)
>       rxrpc: rxgk: Implement connection rekeying
>       rxgk: Support OpenAFS's rxgk implementation
> 
> 
>  crypto/krb5/Kconfig              |    9 +
>  crypto/krb5/Makefile             |   11 +-
>  crypto/krb5/internal.h           |  101 +++
>  crypto/krb5/kdf.c                |  223 ++++++
>  crypto/krb5/main.c               |  190 +++++
>  crypto/krb5/rfc3961_simplified.c |  732 ++++++++++++++++++
>  crypto/krb5/rfc3962_aes.c        |  140 ++++
>  crypto/krb5/rfc6803_camellia.c   |  249 ++++++
>  crypto/krb5/rfc8009_aes2.c       |  440 +++++++++++
>  crypto/krb5/selftest.c           |  543 +++++++++++++
>  crypto/krb5/selftest_data.c      |  289 +++++++
>  fs/afs/misc.c                    |   13 +
>  include/crypto/krb5.h            |  100 +++
>  include/keys/rxrpc-type.h        |   17 +
>  include/trace/events/rxrpc.h     |    4 +
>  include/uapi/linux/rxrpc.h       |   17 +
>  net/rxrpc/Kconfig                |   10 +
>  net/rxrpc/Makefile               |    5 +
>  net/rxrpc/ar-internal.h          |   20 +
>  net/rxrpc/conn_object.c          |    2 +
>  net/rxrpc/key.c                  |  319 ++++++++
>  net/rxrpc/rxgk.c                 | 1232 ++++++++++++++++++++++++++++++
>  net/rxrpc/rxgk_app.c             |  424 ++++++++++
>  net/rxrpc/rxgk_common.h          |  164 ++++
>  net/rxrpc/rxgk_kdf.c             |  271 +++++++
>  net/rxrpc/security.c             |    6 +
>  26 files changed, 5530 insertions(+), 1 deletion(-)
>  create mode 100644 crypto/krb5/kdf.c
>  create mode 100644 crypto/krb5/rfc3961_simplified.c
>  create mode 100644 crypto/krb5/rfc3962_aes.c
>  create mode 100644 crypto/krb5/rfc6803_camellia.c
>  create mode 100644 crypto/krb5/rfc8009_aes2.c
>  create mode 100644 crypto/krb5/selftest.c
>  create mode 100644 crypto/krb5/selftest_data.c
>  create mode 100644 net/rxrpc/rxgk.c
>  create mode 100644 net/rxrpc/rxgk_app.c
>  create mode 100644 net/rxrpc/rxgk_common.h
>  create mode 100644 net/rxrpc/rxgk_kdf.c
> 
