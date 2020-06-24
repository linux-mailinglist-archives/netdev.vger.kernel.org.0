Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05CD207BEA
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 21:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404520AbgFXTBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 15:01:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404055AbgFXTBf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 15:01:35 -0400
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E04682084D;
        Wed, 24 Jun 2020 19:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593025295;
        bh=VazlkY1OYWfgAyK3hGCaPhS2KlqVl7X9iMka55vdxYk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bdU3yQ56Te081zokRTBJaWnNfBDxA2HRQ7cDOy1X/uqhswWAV33x36D0b+XGMv3gk
         zHeGBuMh5ZJpPrK3njJOpSB6x8c2nsRnjKqGgi9/3mO9IQ2LA5V+5oEPkBilab3zRV
         J2po4NbZyQuPdoUI8A6k5aMXhrhs9uAD5LG4L1x8=
Received: by mail-ot1-f42.google.com with SMTP id d4so2967180otk.2;
        Wed, 24 Jun 2020 12:01:34 -0700 (PDT)
X-Gm-Message-State: AOAM532LyRKxN1yY0/Azv8DnsIlX3m/CUgMF1PrEmYAMzz/cjE7OmgHA
        5GHLd84gVkL3Kholh1xpOhONOQ7u9bXvDSDJIkU=
X-Google-Smtp-Source: ABdhPJytPjDcWa0KOHnXhKGMIfh9Cll5z7/IKKeN16fko2CmG/qSZpVNTBykudQIxS6TjtLs//PGjtJzaXa3atetpfs=
X-Received: by 2002:a9d:4a8f:: with SMTP id i15mr1112953otf.77.1593025294222;
 Wed, 24 Jun 2020 12:01:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200624133427.1630650-1-ardb@kernel.org> <20200624163229.GC200774@gmail.com>
In-Reply-To: <20200624163229.GC200774@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 24 Jun 2020 21:01:23 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFtDyRRufiCCdKH_NAs4g=jAenO9Zxq0jBhy=Dp0QCuSw@mail.gmail.com>
Message-ID: <CAMj1kXFtDyRRufiCCdKH_NAs4g=jAenO9Zxq0jBhy=Dp0QCuSw@mail.gmail.com>
Subject: Re: [PATCH] net: phy: mscc: avoid skcipher API for single block AES encryption
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     netdev@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Jun 2020 at 18:32, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Jun 24, 2020 at 03:34:27PM +0200, Ard Biesheuvel wrote:
> > The skcipher API dynamically instantiates the transformation object on
> > request that implements the requested algorithm optimally on the given
> > platform. This notion of optimality only matters for cases like bulk
> > network or disk encryption, where performance can be a bottleneck, or
> > in cases where the algorithm itself is not known at compile time.
> >
> > In the mscc macsec case, we are dealing with AES encryption of a single
> > block, and so neither concern applies, and we are better off using the
> > AES library interface, which is lightweight and safe for this kind of
> > use.
> >
> > Note that the scatterlist API does not permit references to buffers that
> > are located on the stack, so the existing code is incorrect in any case,
> > but avoiding the skcipher and scatterlist APIs altogether is the most
> > straight-forward approach to fixing this.
> >
> > Cc: Antoine Tenart <antoine.tenart@bootlin.com>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Florian Fainelli <f.fainelli@gmail.com>
> > Cc: Heiner Kallweit <hkallweit1@gmail.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: <stable@vger.kernel.org>
> > Fixes: 28c5107aa904e ("net: phy: mscc: macsec support")
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  drivers/net/phy/Kconfig            |  3 +-
> >  drivers/net/phy/mscc/mscc_macsec.c | 40 +++++---------------
> >  2 files changed, 10 insertions(+), 33 deletions(-)
> >
> > diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> > index f25702386d83..e9c05848ec52 100644
> > --- a/drivers/net/phy/Kconfig
> > +++ b/drivers/net/phy/Kconfig
> > @@ -480,8 +480,7 @@ config MICROCHIP_T1_PHY
> >  config MICROSEMI_PHY
> >       tristate "Microsemi PHYs"
> >       depends on MACSEC || MACSEC=n
> > -     select CRYPTO_AES
> > -     select CRYPTO_ECB
> > +     select CRYPTO_LIB_AES
> >       help
> >         Currently supports VSC8514, VSC8530, VSC8531, VSC8540 and VSC8541 PHYs
>
> Shouldn't it be 'select CRYPTO_LIB_AES if MACSEC', since
> mscc_macsec.c is only compiled if MACSEC?
>

Good point, I'll change that.

> >
> > diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
> > index b4d3dc4068e2..d53ca884b5c9 100644
> > --- a/drivers/net/phy/mscc/mscc_macsec.c
> > +++ b/drivers/net/phy/mscc/mscc_macsec.c
> > @@ -10,7 +10,7 @@
> >  #include <linux/phy.h>
> >  #include <dt-bindings/net/mscc-phy-vsc8531.h>
> >
> > -#include <crypto/skcipher.h>
> > +#include <crypto/aes.h>
> >
> >  #include <net/macsec.h>
> >
> > @@ -500,39 +500,17 @@ static u32 vsc8584_macsec_flow_context_id(struct macsec_flow *flow)
> >  static int vsc8584_macsec_derive_key(const u8 key[MACSEC_KEYID_LEN],
> >                                    u16 key_len, u8 hkey[16])
> >  {
> > -     struct crypto_skcipher *tfm = crypto_alloc_skcipher("ecb(aes)", 0, 0);
> > -     struct skcipher_request *req = NULL;
> > -     struct scatterlist src, dst;
> > -     DECLARE_CRYPTO_WAIT(wait);
> > -     u32 input[4] = {0};
> > +     const u8 input[AES_BLOCK_SIZE] = {0};
> > +     struct crypto_aes_ctx ctx;
> >       int ret;
> >
> > -     if (IS_ERR(tfm))
> > -             return PTR_ERR(tfm);
> > -
> > -     req = skcipher_request_alloc(tfm, GFP_KERNEL);
> > -     if (!req) {
> > -             ret = -ENOMEM;
> > -             goto out;
> > -     }
> > -
> > -     skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
> > -                                   CRYPTO_TFM_REQ_MAY_SLEEP, crypto_req_done,
> > -                                   &wait);
> > -     ret = crypto_skcipher_setkey(tfm, key, key_len);
> > -     if (ret < 0)
> > -             goto out;
> > -
> > -     sg_init_one(&src, input, 16);
> > -     sg_init_one(&dst, hkey, 16);
> > -     skcipher_request_set_crypt(req, &src, &dst, 16, NULL);
> > -
> > -     ret = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
> > +     ret = aes_expandkey(&ctx, key, key_len);
> > +     if (ret)
> > +             return ret;
> >
> > -out:
> > -     skcipher_request_free(req);
> > -     crypto_free_skcipher(tfm);
> > -     return ret;
> > +     aes_encrypt(&ctx, hkey, input);
> > +     memzero_explicit(&ctx, sizeof(ctx));
> > +     return 0;
> >  }
> >
>
> Otherwise this looks good.  You can add:
>
>         Reviewed-by: Eric Biggers <ebiggers@google.com>
>

Thanks
