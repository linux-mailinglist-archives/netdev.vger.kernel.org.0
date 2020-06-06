Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1D41F05AF
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 10:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbgFFIN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 04:13:28 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:46204 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgFFIN0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Jun 2020 04:13:26 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C63C920270;
        Sat,  6 Jun 2020 10:13:23 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id NJDh2La_7LBY; Sat,  6 Jun 2020 10:13:23 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5D0BE200AC;
        Sat,  6 Jun 2020 10:13:23 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Sat, 6 Jun 2020 10:13:23 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Sat, 6 Jun 2020
 10:13:22 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 56F9C31801D7;
 Sat,  6 Jun 2020 10:13:22 +0200 (CEST)
Date:   Sat, 6 Jun 2020 10:13:22 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH net v2] esp: select CRYPTO_SEQIV when useful
Message-ID: <20200606081322.GI13121@gauss3.secunet.de>
References: <20200605064748.GA595@gondor.apana.org.au>
 <20200605173931.241085-1-ebiggers@kernel.org>
 <20200605180023.GF1373@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200605180023.GF1373@sol.localdomain>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 05, 2020 at 11:00:23AM -0700, Eric Biggers wrote:
> On Fri, Jun 05, 2020 at 10:39:31AM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
> > index 23ba5045e3d3..6520b30883cf 100644
> > --- a/net/ipv4/Kconfig
> > +++ b/net/ipv4/Kconfig
> > @@ -361,6 +361,7 @@ config INET_ESP
> >  	select CRYPTO_SHA1
> >  	select CRYPTO_DES
> >  	select CRYPTO_ECHAINIV
> > +	select CRYPTO_SEQIV if CRYPTO_CTR || CRYPTO_CHACHA20POLY1305
> >  	---help---
> >  	  Support for IPsec ESP.
> >  
> 
> Oops, this doesn't actually work:
> 
> scripts/kconfig/conf  --olddefconfig Kconfig
> crypto/Kconfig:1799:error: recursive dependency detected!
> crypto/Kconfig:1799:	symbol CRYPTO_DRBG_MENU is selected by CRYPTO_RNG_DEFAULT
> crypto/Kconfig:83:	symbol CRYPTO_RNG_DEFAULT is selected by CRYPTO_SEQIV
> crypto/Kconfig:330:	symbol CRYPTO_SEQIV is selected by CRYPTO_CTR
> crypto/Kconfig:370:	symbol CRYPTO_CTR is selected by CRYPTO_DRBG_CTR
> crypto/Kconfig:1819:	symbol CRYPTO_DRBG_CTR depends on CRYPTO_DRBG_MENU
> For a resolution refer to Documentation/kbuild/kconfig-language.rst
> subsection "Kconfig recursive dependency limitations"
> 
> 
> I guess we need to go with v1 (which just had 'select CRYPTO_SEQIV'),
> or else make users explicitly select CRYPTO_SEQIV?

I think we should make INET_ESP to select everything that is
needed to instantiate the ciphers marked as 'MUST' in RFC 
8221 and let the users explicitly select everything else.
