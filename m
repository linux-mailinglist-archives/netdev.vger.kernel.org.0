Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DD52CF3BA
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729647AbgLDSO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:14:28 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:47966 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726775AbgLDSO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 13:14:27 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0B4IDIuo007813
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 4 Dec 2020 13:13:18 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id DA510420136; Fri,  4 Dec 2020 13:13:17 -0500 (EST)
Date:   Fri, 4 Dec 2020 13:13:17 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     David Howells <dhowells@redhat.com>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Bruce Fields <bfields@fieldses.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-afs@lists.infradead.org
Subject: Re: Why the auxiliary cipher in gss_krb5_crypto.c?
Message-ID: <20201204181317.GD577125@mit.edu>
References: <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com>
 <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
 <118876.1607093975@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <118876.1607093975@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 02:59:35PM +0000, David Howells wrote:
> Hi Chuck, Bruce,
> 
> Why is gss_krb5_crypto.c using an auxiliary cipher?  For reference, the
> gss_krb5_aes_encrypt() code looks like the attached.
> 
> From what I can tell, in AES mode, the difference between the main cipher and
> the auxiliary cipher is that the latter is "cbc(aes)" whereas the former is
> "cts(cbc(aes))" - but they have the same key.
> 
> Reading up on CTS, I'm guessing the reason it's like this is that CTS is the
> same as the non-CTS, except for the last two blocks, but the non-CTS one is
> more efficient.

The reason to use CTS is if you don't want to expand the size of the
cipher text to the cipher block size.  e.g., if you have a 53 byte
plaintext, and you can't afford to let the ciphertext be 56 bytes, the
cryptographic engineer will reach for CTS instead of CBC.

So that probably explains the explanation to use CTS (and it's
required by the spec in any case).  As far as why CBC is being used
instead of CTS, the only reason I can think of is the one you posted.
Perhaps there was some hardware or software configureation where
cbc(aes) was hardware accelerated, and cts(cbc(aes)) would not be?

In any case, using cbc(aes) for all but the last two blocks, and using
cts(cbc(aes)) for the last two blocks, is identical to using
cts(cbc(aes)) for the whole encryption.  So the only reason to do this
in the more complex way would be because for performance reasons.

       	    	    	      	 	 - Ted
