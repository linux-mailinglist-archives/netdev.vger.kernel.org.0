Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A809E68D138
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 09:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbjBGIEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 03:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjBGIEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 03:04:33 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079BD13508;
        Tue,  7 Feb 2023 00:04:29 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pPIxE-008OMQ-SI; Tue, 07 Feb 2023 16:03:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 07 Feb 2023 16:03:52 +0800
Date:   Tue, 7 Feb 2023 16:03:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Tyler Hicks <code@tyhicks.com>, ecryptfs@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org
Subject: Re: [PATCH 0/17] crypto: api - Change completion callback argument
 to void star
Message-ID: <Y+IF6L4cb2Ijy0fN@gondor.apana.org.au>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
 <20230206231008.64c822c1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206231008.64c822c1@kernel.org>
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_RDNS_DYNAMIC_FP,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 11:10:08PM -0800, Jakub Kicinski wrote:
> On Mon, 6 Feb 2023 18:21:06 +0800 Herbert Xu wrote:
> > The crypto completion function currently takes a pointer to a
> > struct crypto_async_request object.  However, in reality the API
> > does not allow the use of any part of the object apart from the
> > data field.  For example, ahash/shash will create a fake object
> > on the stack to pass along a different data field.
> 
> "different data field" == copy the value to a different structure?
> A bit hard to parse TBH.

The word data here refers to the data field in struct crypto_async_request.
 
> Buggy means bug could be hit in real light or buggy == did not use 
> the API right?

Yes this bug is real.  If you hit a driver/algorithm that returns
a different request object (of which there are many in the API) then
you will be dereferencing random pointers.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
