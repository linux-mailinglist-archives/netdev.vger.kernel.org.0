Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F172B0AC4
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgKLQyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 11:54:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728692AbgKLQyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 11:54:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605200056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HGrk85a0VZVfDIo9MNpIfHt62UYe1QlF3HTUKbfYRUc=;
        b=d5Oi5ngkHEgB1eyy0pN2AjI/QRfXs4ELKN6xXKoZpB4UhBhnrk0bP2kAYZ1hQZv0hW5mec
        eJ6mxIP0cDwgzZMaqL+Vk+82MK6pJhsFVcJlScG0KOglVjtJVfpRWN5t9hFgfT7Qxfkzhj
        QIpbP+aC7RL+551+jxyOMg3MbkW9PTQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-Qnmvm0OEMaqqpFKUqCkxbg-1; Thu, 12 Nov 2020 11:54:11 -0500
X-MC-Unique: Qnmvm0OEMaqqpFKUqCkxbg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77D7A6D254;
        Thu, 12 Nov 2020 16:54:09 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D55EB5D993;
        Thu, 12 Nov 2020 16:54:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <22138FE2-9E79-4E24-99FC-74A35651B0C1@oracle.com>
References: <22138FE2-9E79-4E24-99FC-74A35651B0C1@oracle.com> <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com> <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk> <2380561.1605195776@warthog.procyon.org.uk>
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     dhowells@redhat.com, CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Bruce Fields <bfields@fieldses.org>,
        linux-crypto@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-afs@lists.infradead.org
Subject: Re: [RFC][PATCH 00/18] crypto: Add generic Kerberos library
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2422486.1605200046.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 12 Nov 2020 16:54:06 +0000
Message-ID: <2422487.1605200046@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chuck Lever <chuck.lever@oracle.com> wrote:

> Really? My understanding of the Linux kernel SUNRPC implementation is
> that it uses asynchronous, even for small data items. Maybe I'm using
> the terminology incorrectly.

Seems to be synchronous, at least in its use of skcipher:

grep -e skcipher *
gss_krb5_crypto.c:#include <crypto/skcipher.h>
gss_krb5_crypto.c:	struct crypto_sync_skcipher *tfm,
gss_krb5_crypto.c:	if (length % crypto_sync_skcipher_blocksize(tfm) !=3D 0=
)
gss_krb5_crypto.c:	if (crypto_sync_skcipher_ivsize(tfm) > GSS_KRB5_MAX_BLO=
CKSIZE) {
gss_krb5_crypto.c:			crypto_sync_skcipher_ivsize(tfm));
gss_krb5_crypto.c:		memcpy(local_iv, iv, crypto_sync_skcipher_ivsize(tfm))=
;
gss_krb5_crypto.c:	skcipher_request_set_sync_tfm(req, tfm);
gss_krb5_crypto.c:	skcipher_request_set_callback(req, 0, NULL, NULL);
gss_krb5_crypto.c:	skcipher_request_set_crypt(req, sg, sg, length, local_i=
v);
gss_krb5_crypto.c:	ret =3D crypto_skcipher_encrypt(req);
gss_krb5_crypto.c:	skcipher_request_zero(req);
gss_krb5_crypto.c:     struct crypto_sync_skcipher *tfm,
gss_krb5_crypto.c:	if (length % crypto_sync_skcipher_blocksize(tfm) !=3D 0=
)
gss_krb5_crypto.c:	if (crypto_sync_skcipher_ivsize(tfm) > GSS_KRB5_MAX_BLO=
CKSIZE) {
gss_krb5_crypto.c:			crypto_sync_skcipher_ivsize(tfm));
gss_krb5_crypto.c:		memcpy(local_iv, iv, crypto_sync_skcipher_ivsize(tfm))=
;
gss_krb5_crypto.c:	skcipher_request_set_sync_tfm(req, tfm);
gss_krb5_crypto.c:	skcipher_request_set_callback(req, 0, NULL, NULL);
gss_krb5_crypto.c:	skcipher_request_set_crypt(req, sg, sg, length, local_i=
v);
gss_krb5_crypto.c:	ret =3D crypto_skcipher_decrypt(req);
gss_krb5_crypto.c:	skcipher_request_zero(req);
gss_krb5_crypto.c:	struct skcipher_request *req;
gss_krb5_crypto.c:	struct crypto_sync_skcipher *tfm =3D
gss_krb5_crypto.c:		crypto_sync_skcipher_reqtfm(desc->req);
gss_krb5_crypto.c:	fraglen =3D thislen & (crypto_sync_skcipher_blocksize(t=
fm) - 1);
gss_krb5_crypto.c:	skcipher_request_set_crypt(desc->req, desc->infrags, de=
sc->outfrags,
gss_krb5_crypto.c:	ret =3D crypto_skcipher_encrypt(desc->req);
gss_krb5_crypto.c:gss_encrypt_xdr_buf(struct crypto_sync_skcipher *tfm, st=
ruct xdr_buf *buf,
gss_krb5_crypto.c:	BUG_ON((buf->len - offset) % crypto_sync_skcipher_block=
size(tfm) !=3D 0);
gss_krb5_crypto.c:	skcipher_request_set_sync_tfm(req, tfm);
gss_krb5_crypto.c:	skcipher_request_set_callback(req, 0, NULL, NULL);
gss_krb5_crypto.c:	skcipher_request_zero(req);
gss_krb5_crypto.c:	struct skcipher_request *req;
gss_krb5_crypto.c:	struct crypto_sync_skcipher *tfm =3D
gss_krb5_crypto.c:		crypto_sync_skcipher_reqtfm(desc->req);
gss_krb5_crypto.c:	fraglen =3D thislen & (crypto_sync_skcipher_blocksize(t=
fm) - 1);
gss_krb5_crypto.c:	skcipher_request_set_crypt(desc->req, desc->frags, desc=
->frags,
gss_krb5_crypto.c:	ret =3D crypto_skcipher_decrypt(desc->req);
gss_krb5_crypto.c:gss_decrypt_xdr_buf(struct crypto_sync_skcipher *tfm, st=
ruct xdr_buf *buf,
gss_krb5_crypto.c:	BUG_ON((buf->len - offset) % crypto_sync_skcipher_block=
size(tfm) !=3D 0);
gss_krb5_crypto.c:	skcipher_request_set_sync_tfm(req, tfm);
gss_krb5_crypto.c:	skcipher_request_set_callback(req, 0, NULL, NULL);
gss_krb5_crypto.c:	skcipher_request_zero(req);
gss_krb5_crypto.c:gss_krb5_cts_crypt(struct crypto_sync_skcipher *cipher, =
struct xdr_buf *buf,
gss_krb5_crypto.c:	skcipher_request_set_sync_tfm(req, cipher);
gss_krb5_crypto.c:	skcipher_request_set_callback(req, 0, NULL, NULL);
gss_krb5_crypto.c:	skcipher_request_set_crypt(req, sg, sg, len, iv);
gss_krb5_crypto.c:		ret =3D crypto_skcipher_encrypt(req);
gss_krb5_crypto.c:		ret =3D crypto_skcipher_decrypt(req);
gss_krb5_crypto.c:	skcipher_request_zero(req);
gss_krb5_crypto.c:	struct crypto_sync_skcipher *cipher, *aux_cipher;
gss_krb5_crypto.c:	blocksize =3D crypto_sync_skcipher_blocksize(cipher);
gss_krb5_crypto.c:		skcipher_request_set_sync_tfm(req, aux_cipher);
gss_krb5_crypto.c:		skcipher_request_set_callback(req, 0, NULL, NULL);
gss_krb5_crypto.c:		skcipher_request_zero(req);
gss_krb5_crypto.c:	struct crypto_sync_skcipher *cipher, *aux_cipher;
gss_krb5_crypto.c:	blocksize =3D crypto_sync_skcipher_blocksize(cipher);
gss_krb5_crypto.c:		skcipher_request_set_sync_tfm(req, aux_cipher);
gss_krb5_crypto.c:		skcipher_request_set_callback(req, 0, NULL, NULL);
gss_krb5_crypto.c:		skcipher_request_zero(req);
gss_krb5_keys.c:#include <crypto/skcipher.h>
gss_krb5_keys.c:	struct crypto_sync_skcipher *cipher;
gss_krb5_keys.c:	cipher =3D crypto_alloc_sync_skcipher(gk5e->encrypt_name,=
 0, 0);
gss_krb5_keys.c:	if (crypto_sync_skcipher_setkey(cipher, inkey->data, inke=
y->len))
gss_krb5_keys.c:	crypto_free_sync_skcipher(cipher);
gss_krb5_mech.c:#include <crypto/skcipher.h>
gss_krb5_mech.c:	struct krb5_ctx *ctx, struct crypto_sync_skcipher **res)
gss_krb5_mech.c:	*res =3D crypto_alloc_sync_skcipher(ctx->gk5e->encrypt_na=
me, 0, 0);
gss_krb5_mech.c:	if (crypto_sync_skcipher_setkey(*res, key.data, key.len))=
 {
gss_krb5_mech.c:	crypto_free_sync_skcipher(*res);
gss_krb5_mech.c:	crypto_free_sync_skcipher(ctx->seq);
gss_krb5_mech.c:	crypto_free_sync_skcipher(ctx->enc);
gss_krb5_mech.c:static struct crypto_sync_skcipher *
gss_krb5_mech.c:	struct crypto_sync_skcipher *cp;
gss_krb5_mech.c:	cp =3D crypto_alloc_sync_skcipher(cname, 0, 0);
gss_krb5_mech.c:	if (crypto_sync_skcipher_setkey(cp, key, ctx->gk5e->keyle=
ngth)) {
gss_krb5_mech.c:		crypto_free_sync_skcipher(cp);
gss_krb5_mech.c:	crypto_free_sync_skcipher(ctx->enc);
gss_krb5_mech.c:	crypto_free_sync_skcipher(ctx->seq);
gss_krb5_mech.c:			crypto_free_sync_skcipher(ctx->initiator_enc_aux);
gss_krb5_mech.c:	crypto_free_sync_skcipher(ctx->acceptor_enc);
gss_krb5_mech.c:	crypto_free_sync_skcipher(ctx->initiator_enc);
gss_krb5_mech.c:	crypto_free_sync_skcipher(kctx->seq);
gss_krb5_mech.c:	crypto_free_sync_skcipher(kctx->enc);
gss_krb5_mech.c:	crypto_free_sync_skcipher(kctx->acceptor_enc);
gss_krb5_mech.c:	crypto_free_sync_skcipher(kctx->initiator_enc);
gss_krb5_mech.c:	crypto_free_sync_skcipher(kctx->acceptor_enc_aux);
gss_krb5_mech.c:	crypto_free_sync_skcipher(kctx->initiator_enc_aux);
gss_krb5_seqnum.c:#include <crypto/skcipher.h>
gss_krb5_seqnum.c:		struct crypto_sync_skcipher *key,
gss_krb5_seqnum.c:	struct crypto_sync_skcipher *key =3D kctx->seq;
gss_krb5_wrap.c:#include <crypto/skcipher.h>
gss_krb5_wrap.c:	blocksize =3D crypto_sync_skcipher_blocksize(kctx->enc);
gss_krb5_wrap.c:	blocksize =3D crypto_sync_skcipher_blocksize(kctx->enc);

David

