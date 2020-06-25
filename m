Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62E5209AD5
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 09:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390470AbgFYHye convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jun 2020 03:54:34 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:35577 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390360AbgFYHyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 03:54:33 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 2787C1BF209;
        Thu, 25 Jun 2020 07:54:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200625071816.1739528-1-ardb@kernel.org>
References: <20200625071816.1739528-1-ardb@kernel.org>
Subject: Re: [PATCH v2] net: phy: mscc: avoid skcipher API for single block AES encryption
Cc:     linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stable@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Ard Biesheuvel <ardb@kernel.org>, netdev@vger.kernel.org
Message-ID: <159307166803.397581.14181147952249059680@kwain>
Date:   Thu, 25 Jun 2020 09:54:28 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ard,

Quoting Ard Biesheuvel (2020-06-25 09:18:16)
> The skcipher API dynamically instantiates the transformation object
> on request that implements the requested algorithm optimally on the
> given platform. This notion of optimality only matters for cases like
> bulk network or disk encryption, where performance can be a bottleneck,
> or in cases where the algorithm itself is not known at compile time.
> 
> In the mscc case, we are dealing with AES encryption of a single
> block, and so neither concern applies, and we are better off using
> the AES library interface, which is lightweight and safe for this
> kind of use.
> 
> Note that the scatterlist API does not permit references to buffers
> that are located on the stack, so the existing code is incorrect in
> any case, but avoiding the skcipher and scatterlist APIs entirely is
> the most straight-forward approach to fixing this.
> 
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: <stable@vger.kernel.org>
> Fixes: 28c5107aa904e ("net: phy: mscc: macsec support")
> Reviewed-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Tested-by: Antoine Tenart <antoine.tenart@bootlin.com>

That improves and simplifies a lot the code, thank you!
Antoine

> ---
> v2:
> - select CRYPTO_LIB_AES only if MACSEC is enabled
> - add Eric's R-b
> 
>  drivers/net/phy/Kconfig            |  3 +-
>  drivers/net/phy/mscc/mscc_macsec.c | 40 +++++---------------
>  2 files changed, 10 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index f25702386d83..e351d65533aa 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -480,8 +480,7 @@ config MICROCHIP_T1_PHY
>  config MICROSEMI_PHY
>         tristate "Microsemi PHYs"
>         depends on MACSEC || MACSEC=n
> -       select CRYPTO_AES
> -       select CRYPTO_ECB
> +       select CRYPTO_LIB_AES if MACSEC
>         help
>           Currently supports VSC8514, VSC8530, VSC8531, VSC8540 and VSC8541 PHYs
>  
> diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
> index b4d3dc4068e2..d53ca884b5c9 100644
> --- a/drivers/net/phy/mscc/mscc_macsec.c
> +++ b/drivers/net/phy/mscc/mscc_macsec.c
> @@ -10,7 +10,7 @@
>  #include <linux/phy.h>
>  #include <dt-bindings/net/mscc-phy-vsc8531.h>
>  
> -#include <crypto/skcipher.h>
> +#include <crypto/aes.h>
>  
>  #include <net/macsec.h>
>  
> @@ -500,39 +500,17 @@ static u32 vsc8584_macsec_flow_context_id(struct macsec_flow *flow)
>  static int vsc8584_macsec_derive_key(const u8 key[MACSEC_KEYID_LEN],
>                                      u16 key_len, u8 hkey[16])
>  {
> -       struct crypto_skcipher *tfm = crypto_alloc_skcipher("ecb(aes)", 0, 0);
> -       struct skcipher_request *req = NULL;
> -       struct scatterlist src, dst;
> -       DECLARE_CRYPTO_WAIT(wait);
> -       u32 input[4] = {0};
> +       const u8 input[AES_BLOCK_SIZE] = {0};
> +       struct crypto_aes_ctx ctx;
>         int ret;
>  
> -       if (IS_ERR(tfm))
> -               return PTR_ERR(tfm);
> -
> -       req = skcipher_request_alloc(tfm, GFP_KERNEL);
> -       if (!req) {
> -               ret = -ENOMEM;
> -               goto out;
> -       }
> -
> -       skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
> -                                     CRYPTO_TFM_REQ_MAY_SLEEP, crypto_req_done,
> -                                     &wait);
> -       ret = crypto_skcipher_setkey(tfm, key, key_len);
> -       if (ret < 0)
> -               goto out;
> -
> -       sg_init_one(&src, input, 16);
> -       sg_init_one(&dst, hkey, 16);
> -       skcipher_request_set_crypt(req, &src, &dst, 16, NULL);
> -
> -       ret = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
> +       ret = aes_expandkey(&ctx, key, key_len);
> +       if (ret)
> +               return ret;
>  
> -out:
> -       skcipher_request_free(req);
> -       crypto_free_skcipher(tfm);
> -       return ret;
> +       aes_encrypt(&ctx, hkey, input);
> +       memzero_explicit(&ctx, sizeof(ctx));
> +       return 0;
>  }
>  
>  static int vsc8584_macsec_transformation(struct phy_device *phydev,
> -- 
> 2.27.0
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
