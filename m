Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8AA6E19D9
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 03:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjDNBtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 21:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDNBtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 21:49:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9882A2D5F;
        Thu, 13 Apr 2023 18:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=E2G2QvD8LSN6zsKrK4x10klW74FtFwbyAIvDGNKBlgI=; b=mKoGtUTFW1RJGS3hAqeCxHJJ5A
        zG4T1dYaG40Nfu1CCGZib5u3IkjqmcT+jBShPe9xtQQfghWSW/OHaOAHOWJsQTOy9l4J9eBKHOsCw
        HPW9qZFTv1e7UxRIblVwHXOAAhULUz3eydk7O7toklv4Zq3xiEsVo6Oc0k9Gd8bUdDpo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pn8Ym-00AF4Q-5H; Fri, 14 Apr 2023 03:49:08 +0200
Date:   Fri, 14 Apr 2023 03:49:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Qingfang Deng <dqfext@gmail.com>,
        SkyLake Huang <SkyLake.Huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        John Crispin <john@phrozen.org>
Subject: Re: [PATCH net-next] net: phy: add driver for MediaTek SoC built-in
 GE PHYs
Message-ID: <1295d8aa-35e8-4396-b347-efc8d7557c79@lunn.ch>
References: <ZDihjfnzaZ1yh9cT@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDihjfnzaZ1yh9cT@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* Registers on MDIO_MMD_VEND1 */
> +#define MTK_PHY_MIDDLE_LEVEL_SHAPPER_0TO1	0
> +#define MTK_PHY_1st_OVERSHOOT_LEVEL_0TO1	1
> +#define MTK_PHY_2nd_OVERSHOOT_LEVEL_0TO1	2
> +#define MTK_PHY_1st_OVERSHOOT_LEVEL_1TO0	4
> +#define MTK_PHY_2nd_OVERSHOOT_LEVEL_1TO0	5 /* N means negative */
> +#define MTK_PHY_1st_OVERSHOOT_LEVEL_0TON1	7
> +#define MTK_PHY_2nd_OVERSHOOT_LEVEL_0TON1	8
> +#define MTK_PHY_1st_OVERSHOOT_LEVEL_N1TO0	10
> +#define MTK_PHY_2nd_OVERSHOOT_LEVEL_N1TO0	11

Mixed case like this is very unusual.

> +static int tx_amp_fill_result(struct phy_device *phydev, u16 *buf)
> +{
> +	int i;
> +	int bias[16] = {0};
> +	const int vals_9461[16] = { 7, 1, 4, 7,
> +				    7, 1, 4, 7,
> +				    7, 1, 4, 7,
> +				    7, 1, 4, 7 };
> +	const int vals_9481[16] = { 10, 6, 6, 10,
> +				    10, 6, 6, 10,
> +				    10, 6, 6, 10,
> +				    10, 6, 6, 10 };
> +
> +	switch (phydev->drv->phy_id) {
> +	case MTK_GPHY_ID_MT7981:
> +		/* We add some calibration to efuse values
> +		 * due to board level influence.
> +		 * GBE: +7, TBT: +1, HBT: +4, TST: +7
> +		 */
> +		memcpy(bias, (const void *)vals_9461, sizeof(bias));
> +		for (i = 0; i <= 12; i += 4) {
> +			if (likely(buf[i >> 2] + bias[i] >= 32)) {
> +				bias[i] -= 13;
> +			} else {
> +				phy_modify_mmd(phydev, MDIO_MMD_VEND1,
> +					       0x5c, 0x7 << i, bias[i] << i);
> +				bias[i + 1] += 13;
> +				bias[i + 2] += 13;
> +				bias[i + 3] += 13;

How does 13 map to GBE: +7, TBT: +1, HBT: +4, TST: +7 ?

> +static inline void mt798x_phy_common_finetune(struct phy_device *phydev)

No inline functions in .c files. Let the compiler decide. There
appears to be a number of these. And they are big function, too big to
make sense to inline.

>  static struct phy_driver mtk_gephy_driver[] = {
>  	{
> -		PHY_ID_MATCH_EXACT(0x03a29412),
> +		PHY_ID_MATCH_EXACT(MTK_GPHY_ID_MT7530),
>  		.name		= "MediaTek MT7530 PHY",
>  		.config_init	= mt7530_phy_config_init,
>  		/* Interrupts are handled by the switch, not the PHY
> @@ -84,7 +1205,7 @@ static struct phy_driver mtk_gephy_driver[] = {
>  		.write_page	= mtk_gephy_write_page,
>  	},
>  	{
> -		PHY_ID_MATCH_EXACT(0x03a29441),
> +		PHY_ID_MATCH_EXACT(MTK_GPHY_ID_MT7531),
>  		.name		= "MediaTek MT7531 PHY",
>  		.config_init	= mt7531_phy_config_init,
>  		/* Interrupts are handled by the switch, not the PHY

Useful changes, but please put them in a separate patch.

> @@ -97,16 +1218,42 @@ static struct phy_driver mtk_gephy_driver[] = {
>  		.read_page	= mtk_gephy_read_page,
>  		.write_page	= mtk_gephy_write_page,
>  	},
> +#if IS_ENABLED(CONFIG_MEDIATEK_GE_PHY_SOC)
> +	{
> +		PHY_ID_MATCH_EXACT(MTK_GPHY_ID_MT7981),
> +		.name		= "MediaTek MT7981 PHY",
> +		.probe		= mt7981_phy_probe,
> +		.config_intr	= genphy_no_config_intr,
> +		.handle_interrupt = genphy_handle_interrupt_no_ack,
> +		.suspend	= genphy_suspend,
> +		.resume		= genphy_resume,
> +		.read_page	= mtk_gephy_read_page,
> +		.write_page	= mtk_gephy_write_page,
> +	},
> +	{
> +		PHY_ID_MATCH_EXACT(MTK_GPHY_ID_MT7988),
> +		.name		= "MediaTek MT7988 PHY",
> +		.probe		= mt7988_phy_probe,
> +		.config_intr	= genphy_no_config_intr,
> +		.handle_interrupt = genphy_handle_interrupt_no_ack,
> +		.suspend	= genphy_suspend,
> +		.resume		= genphy_resume,
> +		.read_page	= mtk_gephy_read_page,
> +		.write_page	= mtk_gephy_write_page,

So the only thing these two new PHYs share with the other two PHYs is
mtk_gephy_read_page and mtk_gephy_write_page?

static int mtk_gephy_read_page(struct phy_device *phydev)
{
        return __phy_read(phydev, MTK_EXT_PAGE_ACCESS);
}

static int mtk_gephy_write_page(struct phy_device *phydev, int page)
{
        return __phy_write(phydev, MTK_EXT_PAGE_ACCESS, page);
}

Given the size of the new code, maybe consider adding
mediatek-ge-soc.c and make a copy these two functions?

	Andrew
