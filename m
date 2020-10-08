Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0C0286E25
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 07:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbgJHFfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 01:35:43 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:41182 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbgJHFfm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 01:35:42 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kQOaU-0006Jv-GJ; Thu, 08 Oct 2020 16:35:35 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2020 16:35:34 +1100
Date:   Thu, 8 Oct 2020 16:35:34 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     poojatrivedi@gmail.com, linux-crypto@vger.kernel.org,
        mallesh537@gmail.com, josh.tway@stackpath.com,
        netdev@vger.kernel.org
Subject: Re: [RFC 1/1] net/tls(TLS_SW): Handle -ENOSPC error return from
 device/AES-NI
Message-ID: <20201008053534.GA4685@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007134746.069d7f2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.netdev
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
>
> Why would the driver return EBUSY from an async API? What's the caller
> supposed to do with that?

The Crypto API offers two modes for callers to deal with congestion.
If the request can be safely dropped (e.g., IPsec) then ENOSPC will
be returned and should be dealt with accordingly.

If the request cannot be dropped then EBUSY is returned to indicate
congestion, and the caller must refrain from issuing any more
requests until the Crypto API signals that there is space for them.

The request flag CRYPTO_TFM_REQ_MAY_BACKLOG is used to indicate
which mode you wish to use.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
