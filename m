Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD53C2E89E2
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 02:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbhACBho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jan 2021 20:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbhACBho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jan 2021 20:37:44 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2627C0613C1;
        Sat,  2 Jan 2021 17:37:03 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4D7hF06lyCzQlX9;
        Sun,  3 Jan 2021 02:36:36 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1609637795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cDfPmiF35EBFlkS0scxyijDia7m1mxvskmVdso9eEdA=;
        b=Fc5QS6w6NQv6BM3AxdGEeqwxqOg/43yDN7gyJBCGufZnbGo81xcXl1XZm8WwuOJtgIwxKq
        JpMxwZ/kyMwQ6JR6ScXKcScHkqvChBj3T4o/mX+Q7mjxLHIp230mGJcX4qmg6wKj5QzGBN
        lMgdsBxTNhtKr2QVdrwJxPBToOP/HMAbvO2AViYdOCr3yAWnHGsOeL5J5e76R5bu4wUy2R
        Nisksy4grOPmd3SzV/3Z3318j8VxAY++Ki3TA+A7yu8oci54pzN5dO6GbqwZklJ48Afb4A
        whJ4UbfAH9ZOk7VwZ3WFswvul38hoJsiHMR3BR+RGUAxQcq5naw847EbBskljg==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id ITpM2tYc2Ko0; Sun,  3 Jan 2021 02:36:33 +0100 (CET)
Subject: Re: [PATCH 2/2] net: dsa: lantiq_gswip: Fix GSWIP_MII_CFG(p) register
 access
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210103012544.3259029-1-martin.blumenstingl@googlemail.com>
 <20210103012544.3259029-3-martin.blumenstingl@googlemail.com>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <a671e783-da5c-378b-56f3-97e1c782570d@hauke-m.de>
Date:   Sun, 3 Jan 2021 02:36:30 +0100
MIME-Version: 1.0
In-Reply-To: <20210103012544.3259029-3-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -5.50 / 15.00 / 15.00
X-Rspamd-Queue-Id: CF6031724
X-Rspamd-UID: eb4f15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/3/21 2:25 AM, Martin Blumenstingl wrote:
> There is one GSWIP_MII_CFG register for each switch-port except the CPU
> port. The register offset for the first port is 0x0, 0x02 for the
> second, 0x04 for the third and so on.
> 
> Update the driver to not only restrict the GSWIP_MII_CFG registers to
> ports 0, 1 and 5. Handle ports 0..5 instead but skip the CPU port. This
> means we are not overwriting the configuration for the third port (port
> two since we start counting from zero) with the settings for the sixth
> port (with number five) anymore.
> 
> The GSWIP_MII_PCDU(p) registers are not updated because there's really
> only three (one for each of the following ports: 0, 1, 5).
> 
> Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
> Cc: stable@vger.kernel.org
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
>   drivers/net/dsa/lantiq_gswip.c | 23 ++++++-----------------
>   1 file changed, 6 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
> index 5d378c8026f0..4b36d89bec06 100644
> --- a/drivers/net/dsa/lantiq_gswip.c
> +++ b/drivers/net/dsa/lantiq_gswip.c
> @@ -92,9 +92,7 @@
>   					 GSWIP_MDIO_PHY_FDUP_MASK)
>   
>   /* GSWIP MII Registers */
> -#define GSWIP_MII_CFG0			0x00
> -#define GSWIP_MII_CFG1			0x02
> -#define GSWIP_MII_CFG5			0x04
> +#define GSWIP_MII_CFGp(p)		(0x2 * (p))
>   #define  GSWIP_MII_CFG_EN		BIT(14)
>   #define  GSWIP_MII_CFG_LDCLKDIS		BIT(12)
>   #define  GSWIP_MII_CFG_MODE_MIIP	0x0
> @@ -392,17 +390,9 @@ static void gswip_mii_mask(struct gswip_priv *priv, u32 clear, u32 set,
>   static void gswip_mii_mask_cfg(struct gswip_priv *priv, u32 clear, u32 set,
>   			       int port)
>   {
> -	switch (port) {
> -	case 0:
> -		gswip_mii_mask(priv, clear, set, GSWIP_MII_CFG0);
> -		break;
> -	case 1:
> -		gswip_mii_mask(priv, clear, set, GSWIP_MII_CFG1);
> -		break;
> -	case 5:
> -		gswip_mii_mask(priv, clear, set, GSWIP_MII_CFG5);
> -		break;
> -	}
> +	/* There's no MII_CFG register for the CPU port */
> +	if (!dsa_is_cpu_port(priv->ds, port))
> +		gswip_mii_mask(priv, clear, set, GSWIP_MII_CFGp(port));
>   }
>   
>   static void gswip_mii_mask_pcdu(struct gswip_priv *priv, u32 clear, u32 set,
> @@ -822,9 +812,8 @@ static int gswip_setup(struct dsa_switch *ds)
>   	gswip_mdio_mask(priv, 0xff, 0x09, GSWIP_MDIO_MDC_CFG1);
>   
>   	/* Disable the xMII link */
> -	gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, 0);
> -	gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, 1);
> -	gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, 5);
> +	for (i = 0; i < priv->hw_info->max_ports; i++)
> +		gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, i);
>   
>   	/* enable special tag insertion on cpu port */
>   	gswip_switch_mask(priv, 0, GSWIP_FDMA_PCTRL_STEN,
> 

