Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59AC268E6ED
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 05:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjBHECx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 23:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjBHECv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 23:02:51 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3713A3867D;
        Tue,  7 Feb 2023 20:02:49 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pPbev-008jle-Fn; Wed, 08 Feb 2023 12:02:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 08 Feb 2023 12:02:13 +0800
Date:   Wed, 8 Feb 2023 12:02:13 +0800
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
Message-ID: <Y+MexdOj12Y5Ikj1@gondor.apana.org.au>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
 <20230206231008.64c822c1@kernel.org>
 <Y+IF6L4cb2Ijy0fN@gondor.apana.org.au>
 <20230207105146.267fc5e8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207105146.267fc5e8@kernel.org>
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_RDNS_DYNAMIC_FP,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 10:51:46AM -0800, Jakub Kicinski wrote:
.
> Any aes-gcm or chacha-poly implementations which would do that come 
> to mind? I'm asking 'cause we probably want to do stable if we know
> of a combination which would be broken, or the chances of one existing
> are high.

Good point.  I had a quick look at tls_sw.c and it *appears* to be
safe with the default software code.  As tls_sw only uses the generic
AEAD algorithms (rather than the IPsec-specific variants which aren't
safe), the software-only paths *should* be OK.

However, drivers that support these algorithms may require fallbacks
for esoteric reasons.  For example, drivers/crypto/amcc appears to
require a fallback for certain input parameters which may or may not
be possible with TLS.

To be on the safe side I would do a backport once this has been
in mainline for a little bit.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
