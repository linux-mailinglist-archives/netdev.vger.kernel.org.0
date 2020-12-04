Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77432CF0FA
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 16:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730621AbgLDPrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 10:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgLDPrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 10:47:07 -0500
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C104C061A52;
        Fri,  4 Dec 2020 07:46:27 -0800 (PST)
Received: by fieldses.org (Postfix, from userid 2815)
        id 084D96F73; Fri,  4 Dec 2020 10:46:26 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 084D96F73
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1607096786;
        bh=wHiljjMIkY8nl/ZnPYa+9FcyCXYDIXfFUmp0/iytMrM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jTPxHvE/rGumvGlYaM+xc80ODgvFi/CXOAPyE56Pd0+nQhVPHOXFK7EhdOBinOa3w
         LrUc+fa/1stZlpjT2QV+/OO2Ze/68TbyZoZBkhon+I4vAfX+PbuUS0sWT9pcimjm9x
         9vqFoS4izZ03kMWkuY7cWfCH4jd08F1FWv66Hfr4=
Date:   Fri, 4 Dec 2020 10:46:26 -0500
From:   Bruce Fields <bfields@fieldses.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-afs@lists.infradead.org
Subject: Re: Why the auxiliary cipher in gss_krb5_crypto.c?
Message-ID: <20201204154626.GA26255@fieldses.org>
References: <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com>
 <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
 <118876.1607093975@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <118876.1607093975@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 02:59:35PM +0000, David Howells wrote:
> Hi Chuck, Bruce,
> 
> Why is gss_krb5_crypto.c using an auxiliary cipher?  For reference, the
> gss_krb5_aes_encrypt() code looks like the attached.
> 
> >From what I can tell, in AES mode, the difference between the main cipher and
> the auxiliary cipher is that the latter is "cbc(aes)" whereas the former is
> "cts(cbc(aes))" - but they have the same key.
> 
> Reading up on CTS, I'm guessing the reason it's like this is that CTS is the
> same as the non-CTS, except for the last two blocks, but the non-CTS one is
> more efficient.

CTS is cipher-text stealing, isn't it?  I think it was Kevin Coffman
that did that, and I don't remember the history.  I thought it was
required by some spec or peer implementation (maybe Windows?) but I
really don't remember.  It may predate git.  I'll dig around and see
what I can find.

--b.

> 
> David
> ---
> 	nbytes = buf->len - offset - GSS_KRB5_TOK_HDR_LEN;
> 	nblocks = (nbytes + blocksize - 1) / blocksize;
> 	cbcbytes = 0;
> 	if (nblocks > 2)
> 		cbcbytes = (nblocks - 2) * blocksize;
> 
> 	memset(desc.iv, 0, sizeof(desc.iv));
> 
> 	if (cbcbytes) {
> 		SYNC_SKCIPHER_REQUEST_ON_STACK(req, aux_cipher);
> 
> 		desc.pos = offset + GSS_KRB5_TOK_HDR_LEN;
> 		desc.fragno = 0;
> 		desc.fraglen = 0;
> 		desc.pages = pages;
> 		desc.outbuf = buf;
> 		desc.req = req;
> 
> 		skcipher_request_set_sync_tfm(req, aux_cipher);
> 		skcipher_request_set_callback(req, 0, NULL, NULL);
> 
> 		sg_init_table(desc.infrags, 4);
> 		sg_init_table(desc.outfrags, 4);
> 
> 		err = xdr_process_buf(buf, offset + GSS_KRB5_TOK_HDR_LEN,
> 				      cbcbytes, encryptor, &desc);
> 		skcipher_request_zero(req);
> 		if (err)
> 			goto out_err;
> 	}
> 
> 	/* Make sure IV carries forward from any CBC results. */
> 	err = gss_krb5_cts_crypt(cipher, buf,
> 				 offset + GSS_KRB5_TOK_HDR_LEN + cbcbytes,
> 				 desc.iv, pages, 1);
> 	if (err) {
> 		err = GSS_S_FAILURE;
> 		goto out_err;
> 	}
