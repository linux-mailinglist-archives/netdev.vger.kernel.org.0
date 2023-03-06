Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC926AC0AB
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 14:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjCFNUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 08:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjCFNUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 08:20:21 -0500
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3236A298DB;
        Mon,  6 Mar 2023 05:20:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1678108766; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=MBt2bMI5bp/2zB0h18LEQySzgihKn/foLOBx2NR77IdiTmpfWrd0sRr8GchUGFOvDlnrW8/fCdnkJIfSunM13v4CNeWuznd6cnkvhrA1XzzgC2CDwhrXMw+sog8HVIsZ5H0neMdIhzkOvE4G6Y02VbsY+dMfAoR1sKUhMBq3EZo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1678108766; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=T2ixbp4HL4ggnEiRH4MwcUBhAScL6f5ENTnBz9aakSY=; 
        b=Rf+LkxsgmGXk10OGqcrdeQTYayhTVPI8T3yveHH1mDuvAZmj9TRzqI7xLNc9nu7gtnvN5hpxdFoMzsoa1GIwUeHA2mbDl0c+8kPNZL5k49lnCrTRgSLsVlse968YPMO+mW+e4mTQt2xarynaHe/epleXN+YiIcOzOZCc4OTC0ok=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1678108766;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=T2ixbp4HL4ggnEiRH4MwcUBhAScL6f5ENTnBz9aakSY=;
        b=cuzashvIqaekgwn5HerHcqybDot4DJA7rFstAZKiwPAUIfM8mZbktInSfFyrX8t8
        F5id+uDOl+qmc0awzudVzEYOl3VDxHXDbdswgWDBCowjBuQnHb0Yp0lTZi6CnROfkUx
        CUchHVz1uCHxvr8AuyDL/vshLHTtRpPro+drcZ14=
Received: from [10.10.10.3] (212.68.60.226 [212.68.60.226]) by mx.zohomail.com
        with SMTPS id 1678108765103288.5523800899738; Mon, 6 Mar 2023 05:19:25 -0800 (PST)
Message-ID: <f8669264-0c96-0337-2293-4d215e313b93@arinc9.com>
Date:   Mon, 6 Mar 2023 16:19:18 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH net] net: dsa: mt7530: move PLL setup out of port 6
 pad configuration
Content-Language: en-US
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Alexander Couzens <lynxis@fe80.eu>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230304125453.53476-1-arinc.unal@arinc9.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230304125453.53476-1-arinc.unal@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4.03.2023 15:54, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Move the PLL setup of the MT7530 switch out of the pad configuration of
> port 6 to mt7530_setup, after reset.
> 
> This fixes the improper initialisation of the switch when only port 5 is
> used as a CPU port.
> 
> Add supported phy modes of port 5 on the PLL setup.
> 
> Remove now incorrect comment regarding P5 as GMAC5.
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
> 
> I'm trying to mimic this change by Alexander [0] for the MT7530 switch.
> This is already the case for MT7530 and MT7531 on the MediaTek ethernet
> driver on U-Boot [1] [2].
> 
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=42bc4fafe359ed6b73602b7a2dba0dd99588f8ce
> [1] https://github.com/u-boot/u-boot/blob/a94ab561e2f49a80d8579930e840b810ab1a1330/drivers/net/mtk_eth.c#L729
> [2] https://github.com/u-boot/u-boot/blob/a94ab561e2f49a80d8579930e840b810ab1a1330/drivers/net/mtk_eth.c#L903
> 
> There are some parts I couldn't figure out myself with my limited C
> knowledge. I've pointed them out on the code. Vladimir, could you help?
> 
> There is a lot of code which is only needed for port 6 or trgmii on port 6,
> but runs whether port 6 or trgmii is used or not. For now, the best I can
> do is to fix port 5 so it works without port 6 being used.
> 
> The U-Boot driver seems to be much more organised so it could be taken as
> a reference to sort out this DSA driver further.
> 
> Also, now that the pad setup for mt7530 is also moved somewhere else, can
> we completely get rid of @pad_setup?
> 
> Arınç
> 
> ---
>   drivers/net/dsa/mt7530.c | 46 +++++++++++++++++++++++++++++-----------
>   1 file changed, 34 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 0e99de26d159..fb20ce4f443e 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -395,9 +395,8 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
>   
>   /* Setup TX circuit including relevant PAD and driving */
>   static int
> -mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
> +mt7530_pad_clk_setup(struct mt7530_priv *priv, phy_interface_t interface)
>   {
> -	struct mt7530_priv *priv = ds->priv;
>   	u32 ncpo1, ssc_delta, trgint, i, xtal;
>   
>   	xtal = mt7530_read(priv, MT7530_MHWTRAP) & HWTRAP_XTAL_MASK;
> @@ -409,9 +408,32 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
>   		return -EINVAL;
>   	}
>   
> +	/* Is setting trgint to 0 really needed for the !trgint check? */
> +	trgint = 0;
> +
> +	/* FIXME: run this switch if p5 is defined on the devicetree */
> +	/* and change interface to the phy-mode of port 5 */
> +	switch (interface) {
> +	case PHY_INTERFACE_MODE_GMII:
> +		/* PLL frequency: 125MHz */
> +		ncpo1 = 0x0c80;
> +		break;
> +	case PHY_INTERFACE_MODE_MII:
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII:
> +		/* PLL frequency: 125MHz */
> +		ncpo1 = 0x0c80;
> +		break;
> +	default:
> +		dev_err(priv->dev, "xMII interface %d not supported\n",
> +			interface);
> +		return -EINVAL;
> +	}
> +
> +	/* FIXME: run this switch if p6 is defined on the devicetree */
> +	/* and change interface to the phy-mode of port 6 */
>   	switch (interface) {
>   	case PHY_INTERFACE_MODE_RGMII:
> -		trgint = 0;
>   		/* PLL frequency: 125MHz */
>   		ncpo1 = 0x0c80;
>   		break;
> @@ -2172,7 +2194,11 @@ mt7530_setup(struct dsa_switch *ds)
>   		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
>   		     SYS_CTRL_REG_RST);
>   
> -	/* Enable Port 6 only; P5 as GMAC5 which currently is not supported */
> +	/* Setup switch core pll */
> +	/* FIXME: feed the phy-mode of port 5 and 6, if the ports are defined on the devicetree */
> +	mt7530_pad_clk_setup(priv, interface);

Unlike mt7531_pll_setup, there are return codes on mt7530_pad_clk_setup 
so we may need to check for the return code here.

Arınç
