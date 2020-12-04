Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37702CF1BA
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 17:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730768AbgLDQP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 11:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgLDQPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 11:15:24 -0500
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55443C061A51;
        Fri,  4 Dec 2020 08:14:44 -0800 (PST)
Received: by fieldses.org (Postfix, from userid 2815)
        id BE1AE6F72; Fri,  4 Dec 2020 11:14:43 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org BE1AE6F72
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1607098483;
        bh=J0xj9ewVrYZE9fzgXp3Qux8/NwVxEiikQkU7TSID3ZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pr74IznZ9NqMO6FgOWvlw4NZexyjnQNSe0DO8NZbAxGiKEWAa4WnQ2jA99uimZe2v
         vyegI7s6jysq7eOgv9o/3OnAi42+ccnduvuk4YP19X2Ot7/bF+VFQVIB9Ply9VAeOp
         36YgsbRyzUoVrxWsGiuYhIx7yRLpfsg5exJJnN/w=
Date:   Fri, 4 Dec 2020 11:14:43 -0500
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
Message-ID: <20201204161443.GB26933@fieldses.org>
References: <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com>
 <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
 <118876.1607093975@warthog.procyon.org.uk>
 <20201204154626.GA26255@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204154626.GA26255@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 10:46:26AM -0500, Bruce Fields wrote:
> On Fri, Dec 04, 2020 at 02:59:35PM +0000, David Howells wrote:
> > Hi Chuck, Bruce,
> > 
> > Why is gss_krb5_crypto.c using an auxiliary cipher?  For reference, the
> > gss_krb5_aes_encrypt() code looks like the attached.
> > 
> > >From what I can tell, in AES mode, the difference between the main cipher and
> > the auxiliary cipher is that the latter is "cbc(aes)" whereas the former is
> > "cts(cbc(aes))" - but they have the same key.
> > 
> > Reading up on CTS, I'm guessing the reason it's like this is that CTS is the
> > same as the non-CTS, except for the last two blocks, but the non-CTS one is
> > more efficient.
> 
> CTS is cipher-text stealing, isn't it?  I think it was Kevin Coffman
> that did that, and I don't remember the history.  I thought it was
> required by some spec or peer implementation (maybe Windows?) but I
> really don't remember.  It may predate git.  I'll dig around and see
> what I can find.

Like I say, I've got no insight here, I'm just grepping through
mailboxes and stuff, but maybe some of this history's useful;

Addition of CTS mode:

	https://lore.kernel.org/linux-crypto/20080220202543.3209.47410.stgit@jazz.citi.umich.edu/

This rpc/krb5 code went in with 934a95aa1c9c "gss_krb5: add remaining
pieces to enable AES encryption support"; may be worth looking at that
and the series leading up to it, I see the changelogs have some RFC
references that might explain why it's using the crypto it is.

--b.
