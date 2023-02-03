Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193E4689B41
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbjBCOMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbjBCOMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:12:30 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8681353F;
        Fri,  3 Feb 2023 06:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+5r0JwlkwF0W5R7Dh3RpHn9R6byVUmGVJI5gSn97Wh4=; b=w7/csSHS6VJfiCZilLoEjy2Y71
        nW0KNyVr5pHUV3umJE5GbaVZmV+ty/0ILVWJHnx18VBXeQ4PKiR0Qi2uXK4U9vP/h4QX1iZJ3YMbo
        K5Ei6T6XJoxH6iUENFN7f7K5TQRdZkKedmMhkgd5sLfWyP2rD9DAW6iZSvT0XxrQshsI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNwi7-0040Ot-M5; Fri, 03 Feb 2023 15:06:39 +0100
Date:   Fri, 3 Feb 2023 15:06:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH 2/9] net: ethernet: mtk_eth_soc: set MDIO bus clock
 frequency
Message-ID: <Y90U7ydTIxox/Gey@lunn.ch>
References: <cover.1675407169.git.daniel@makrotopia.org>
 <a613b66b4872b5f3f09544138d03d5326a8f6f8b.1675407169.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a613b66b4872b5f3f09544138d03d5326a8f6f8b.1675407169.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static int mtk_mdio_init(struct mtk_eth *eth)
>  {
>  	struct device_node *mii_np;
> +	int clk = 25000000, max_clk = 2500000, divider = 1;
>  	int ret;
> +	u32 val;

Reverse Christmas tree please.

> +
> +	if (!of_property_read_u32(mii_np, "clock-frequency", &val))
> +		max_clk = val;
> +
> +	while (clk / divider > max_clk) {
> +		if (divider >= 63)
> +			break;
> +
> +		divider++;
> +	};

Please add some range checks here. Return -EINVAL if val > max_clock.
Also, if divider = 63 indicating the requested clock is too slow.

> +
> +	val = mtk_r32(eth, MTK_PPSC);
> +	val |= PPSC_MDC_TURBO;
> +	mtk_w32(eth, val, MTK_PPSC);
> +
> +	/* Configure MDC Divider */
> +	val = mtk_r32(eth, MTK_PPSC);
> +	val &= ~PPSC_MDC_CFG;
> +	val |= FIELD_PREP(PPSC_MDC_CFG, divider);
> +	mtk_w32(eth, val, MTK_PPSC);

Can these two writes to MTK_PPSC be combined into one? 

val |= FIELD_PREP(PPSC_MDC_CFG, divider) | PPSC_MDC_TURBO;

    Andrew
