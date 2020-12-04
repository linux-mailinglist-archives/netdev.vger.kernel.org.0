Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F007F2CF03B
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 16:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388365AbgLDPBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 10:01:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730411AbgLDPBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 10:01:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607093985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OTBOnyE1n+B2er0y+QuZYiU0VZBSiLUvAG5osfhcmQc=;
        b=dEawRCBIpSZ/Sy8iKTg+IOGLATe9FvBrLCB8Iv8wFpMSV5A2WBqqGcCb2CEEAUd2UGmZiS
        aaQ9F5PijX80+3dCGw8ile//VM1sg5gthJ9FreyO/sdSEsoEA94ODopbMUT0NtJJKA2vMk
        BiQnOHD+/C91HtFPrRbIZ1ydJEGJsnA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-PzPPozy8PUqmAMwzJKEjCw-1; Fri, 04 Dec 2020 09:59:41 -0500
X-MC-Unique: PzPPozy8PUqmAMwzJKEjCw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FE30107ACE3;
        Fri,  4 Dec 2020 14:59:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-67.rdu2.redhat.com [10.10.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B307A18AD4;
        Fri,  4 Dec 2020 14:59:36 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com>
References: <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com> <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
To:     Chuck Lever <chuck.lever@oracle.com>,
        Bruce Fields <bfields@fieldses.org>
Cc:     dhowells@redhat.com, CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-afs@lists.infradead.org
Subject: Why the auxiliary cipher in gss_krb5_crypto.c?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <118875.1607093975.1@warthog.procyon.org.uk>
Date:   Fri, 04 Dec 2020 14:59:35 +0000
Message-ID: <118876.1607093975@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chuck, Bruce,

Why is gss_krb5_crypto.c using an auxiliary cipher?  For reference, the
gss_krb5_aes_encrypt() code looks like the attached.

From what I can tell, in AES mode, the difference between the main cipher and
the auxiliary cipher is that the latter is "cbc(aes)" whereas the former is
"cts(cbc(aes))" - but they have the same key.

Reading up on CTS, I'm guessing the reason it's like this is that CTS is the
same as the non-CTS, except for the last two blocks, but the non-CTS one is
more efficient.

David
---
	nbytes = buf->len - offset - GSS_KRB5_TOK_HDR_LEN;
	nblocks = (nbytes + blocksize - 1) / blocksize;
	cbcbytes = 0;
	if (nblocks > 2)
		cbcbytes = (nblocks - 2) * blocksize;

	memset(desc.iv, 0, sizeof(desc.iv));

	if (cbcbytes) {
		SYNC_SKCIPHER_REQUEST_ON_STACK(req, aux_cipher);

		desc.pos = offset + GSS_KRB5_TOK_HDR_LEN;
		desc.fragno = 0;
		desc.fraglen = 0;
		desc.pages = pages;
		desc.outbuf = buf;
		desc.req = req;

		skcipher_request_set_sync_tfm(req, aux_cipher);
		skcipher_request_set_callback(req, 0, NULL, NULL);

		sg_init_table(desc.infrags, 4);
		sg_init_table(desc.outfrags, 4);

		err = xdr_process_buf(buf, offset + GSS_KRB5_TOK_HDR_LEN,
				      cbcbytes, encryptor, &desc);
		skcipher_request_zero(req);
		if (err)
			goto out_err;
	}

	/* Make sure IV carries forward from any CBC results. */
	err = gss_krb5_cts_crypt(cipher, buf,
				 offset + GSS_KRB5_TOK_HDR_LEN + cbcbytes,
				 desc.iv, pages, 1);
	if (err) {
		err = GSS_S_FAILURE;
		goto out_err;
	}

