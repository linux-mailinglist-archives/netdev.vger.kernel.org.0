Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2D8292D51
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 20:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730310AbgJSSHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 14:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727293AbgJSSHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 14:07:15 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88715C0613CE;
        Mon, 19 Oct 2020 11:07:15 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id 8F970AAD; Mon, 19 Oct 2020 14:07:14 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 8F970AAD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1603130834;
        bh=dco/WybpU/EqfvSvsH+XSa82NSYyQWrMNtM8NHtAqo8=;
        h=Date:To:Cc:Subject:References:In-Reply-To:From:From;
        b=GwREMXbUFIGpSf1Gsl88oP+3JCO5ZoWbw+JFj+3z86HxybGd/ID9RSNytKwfe4S3N
         F7CHbMAgHPKgbcKjzJ8K1aYF9zD3lRddWW+NDiuuWfS9k8tFHbc2dUMZAii+dIZBSC
         uDXzZ/mhfEqceOj0kg247FrZYqStB7yW+3H/a68M=
Date:   Mon, 19 Oct 2020 14:07:14 -0400
To:     David Howells <dhowells@redhat.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        trond.myklebust@hammerspace.com, linux-crypto@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-afs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: gssapi, crypto and afs/rxrpc
Message-ID: <20201019180714.GA6692@fieldses.org>
References: <1444464.1602865106@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1444464.1602865106@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
From:   bfields@fieldses.org (J. Bruce Fields)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 05:18:26PM +0100, David Howells wrote:
> Hi Herbert, Dave, Trond,
> 
> I've written basic gssapi-derived security support for AF_RXRPC:
> 
> 	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-rxgk
> 
> I've borrowed some bits from net/sunrpc/auth_gss/ but there's a lot in there
> that is quite specific to the sunrpc module that makes it hard to use for
> rxrpc (dprintk, struct xdr_buf).
> 
> Further, I've implemented some more enctypes that aren't supported yet by
> gssapi (AES with sha256/sha384 and Camellia), and that requires some changes
> to the handling as AES with sha384 has a 24-byte checksum size and a 24-byte
> calculated key size for Kc and Ki but a 32-byte Ke.
> 
> Should I pull the core out and try to make it common?  If so, should I move it
> to crypto/ or lib/, or perhaps put it in net/gssapi/?
> 
> There are two components to it:
> 
>  (1) Key derivation steps.
> 
>      My thought is to use xdr_netobj or something similar for to communicate
>      between the steps (though I'd prefer to change .data to be a void* rather
>      than u8*).
> 
>  (2) Encryption/checksumming.
> 
>      My thought is to make this interface use scattergather lists[*] since
>      that's what the crypto encryption API requires (though not the hash API).
> 
> If I do this, should I create a "kerberos" crypto API for the data wrapping
> functions?  I'm not sure that it quite matches the existing APIs because the
> size of the input data will likely not match the size of the output data and
> it's "one shot" as it needs to deal with a checksum.
> 
> Or I can just keep my implementation separate inside net/rxrpc/.

I'd love to share whatever we can, though I'm not really sure what's
involved.  Certainly some careful testing at least.

It's been about 15 years since I really worked on that code.  I remember
struggling with struct xdr_buf.  The client and server support
zero-copy, so requests and replies are represented by a combination of a
couple of linear buffers plus an array of pages.  My memory is that the
(undocumented) meanings of the fields of the xdr_buf were different for
request and replies and for server and client, and getting them right
took some trial and error.

--b.
