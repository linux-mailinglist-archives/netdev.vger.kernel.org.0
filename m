Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4EC6DC7E7
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 16:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjDJOes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 10:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDJOer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 10:34:47 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4704ED2;
        Mon, 10 Apr 2023 07:34:46 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1plsbF-0007aS-0m;
        Mon, 10 Apr 2023 16:34:29 +0200
Date:   Mon, 10 Apr 2023 15:34:26 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     arinc9.unal@gmail.com
Cc:     Sean Wang <sean.wang@mediatek.com>,
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
        Russell King <linux@armlinux.org.uk>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [RFC PATCH v2 net-next 08/14] net: dsa: mt7530: remove pad_setup
 function pointer
Message-ID: <ZDQecu1NkQDQk-cJ@makrotopia.org>
References: <20230407134626.47928-1-arinc.unal@arinc9.com>
 <20230407134626.47928-9-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230407134626.47928-9-arinc.unal@arinc9.com>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 04:46:20PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> The pad_setup function pointer was introduced with 88bdef8be9f6 ("net: dsa:
> mt7530: Extend device data ready for adding a new hardware"). It was being
> used to set up the core clock and port 6 of the MT7530 switch, and pll of
> the MT7531 switch.
> 
> All of these were moved to more appropriate locations, and it was never
> used for the switch on the MT7988 SoC. Therefore, this function pointer
> hasn't got a use anymore. Remove it.
> 
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Acked-by: Daniel Golle <daniel@makrotopia.org>

> ---
>  drivers/net/dsa/mt7530.c | 36 ++----------------------------------
>  drivers/net/dsa/mt7530.h |  3 ---
>  2 files changed, 2 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index c636a888d194..0a6d1c0872be 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -473,12 +473,6 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
>  	return 0;
>  }
>  
> -static int
> -mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
> -{
> -	return 0;
> -}
> -
>  static bool mt7531_dual_sgmii_supported(struct mt7530_priv *priv)
>  {
>  	u32 val;
> @@ -488,12 +482,6 @@ static bool mt7531_dual_sgmii_supported(struct mt7530_priv *priv)
>  	return (val & PAD_DUAL_SGMII_EN) != 0;
>  }
>  
> -static int
> -mt7531_pad_setup(struct dsa_switch *ds, phy_interface_t interface)
> -{
> -	return 0;
> -}
> -
>  static void
>  mt7531_pll_setup(struct mt7530_priv *priv)
>  {
> @@ -2576,14 +2564,6 @@ static void mt7988_mac_port_get_caps(struct dsa_switch *ds, int port,
>  	}
>  }
>  
> -static int
> -mt753x_pad_setup(struct dsa_switch *ds, const struct phylink_link_state *state)
> -{
> -	struct mt7530_priv *priv = ds->priv;
> -
> -	return priv->info->pad_setup(ds, state->interface);
> -}
> -
>  static int
>  mt7530_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  		  phy_interface_t interface)
> @@ -2754,8 +2734,6 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  		if (priv->p6_interface == state->interface)
>  			break;
>  
> -		mt753x_pad_setup(ds, state);
> -
>  		if (mt753x_mac_config(ds, port, mode, state) < 0)
>  			goto unsupported;
>  
> @@ -3053,11 +3031,6 @@ static int mt753x_set_mac_eee(struct dsa_switch *ds, int port,
>  	return 0;
>  }
>  
> -static int mt7988_pad_setup(struct dsa_switch *ds, phy_interface_t interface)
> -{
> -	return 0;
> -}
> -
>  static int mt7988_setup(struct dsa_switch *ds)
>  {
>  	struct mt7530_priv *priv = ds->priv;
> @@ -3119,7 +3092,6 @@ const struct mt753x_info mt753x_table[] = {
>  		.phy_write_c22 = mt7530_phy_write_c22,
>  		.phy_read_c45 = mt7530_phy_read_c45,
>  		.phy_write_c45 = mt7530_phy_write_c45,
> -		.pad_setup = mt7530_pad_clk_setup,
>  		.mac_port_get_caps = mt7530_mac_port_get_caps,
>  		.mac_port_config = mt7530_mac_config,
>  	},
> @@ -3131,7 +3103,6 @@ const struct mt753x_info mt753x_table[] = {
>  		.phy_write_c22 = mt7530_phy_write_c22,
>  		.phy_read_c45 = mt7530_phy_read_c45,
>  		.phy_write_c45 = mt7530_phy_write_c45,
> -		.pad_setup = mt7530_pad_clk_setup,
>  		.mac_port_get_caps = mt7530_mac_port_get_caps,
>  		.mac_port_config = mt7530_mac_config,
>  	},
> @@ -3143,7 +3114,6 @@ const struct mt753x_info mt753x_table[] = {
>  		.phy_write_c22 = mt7531_ind_c22_phy_write,
>  		.phy_read_c45 = mt7531_ind_c45_phy_read,
>  		.phy_write_c45 = mt7531_ind_c45_phy_write,
> -		.pad_setup = mt7531_pad_setup,
>  		.cpu_port_config = mt7531_cpu_port_config,
>  		.mac_port_get_caps = mt7531_mac_port_get_caps,
>  		.mac_port_config = mt7531_mac_config,
> @@ -3156,7 +3126,6 @@ const struct mt753x_info mt753x_table[] = {
>  		.phy_write_c22 = mt7531_ind_c22_phy_write,
>  		.phy_read_c45 = mt7531_ind_c45_phy_read,
>  		.phy_write_c45 = mt7531_ind_c45_phy_write,
> -		.pad_setup = mt7988_pad_setup,
>  		.cpu_port_config = mt7988_cpu_port_config,
>  		.mac_port_get_caps = mt7988_mac_port_get_caps,
>  		.mac_port_config = mt7988_mac_config,
> @@ -3186,9 +3155,8 @@ mt7530_probe_common(struct mt7530_priv *priv)
>  	/* Sanity check if these required device operations are filled
>  	 * properly.
>  	 */
> -	if (!priv->info->sw_setup || !priv->info->pad_setup ||
> -	    !priv->info->phy_read_c22 || !priv->info->phy_write_c22 ||
> -	    !priv->info->mac_port_get_caps ||
> +	if (!priv->info->sw_setup || !priv->info->phy_read_c22 ||
> +	    !priv->info->phy_write_c22 || !priv->info->mac_port_get_caps ||
>  	    !priv->info->mac_port_config)
>  		return -EINVAL;
>  
> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> index 01db5c9724fa..9e5b99b853ba 100644
> --- a/drivers/net/dsa/mt7530.h
> +++ b/drivers/net/dsa/mt7530.h
> @@ -697,8 +697,6 @@ struct mt753x_pcs {
>   * @phy_write_c22:	Holding the way writing PHY port using C22
>   * @phy_read_c45:	Holding the way reading PHY port using C45
>   * @phy_write_c45:	Holding the way writing PHY port using C45
> - * @pad_setup:		Holding the way setting up the bus pad for a certain
> - *			MAC port
>   * @phy_mode_supported:	Check if the PHY type is being supported on a certain
>   *			port
>   * @mac_port_validate:	Holding the way to set addition validate type for a
> @@ -719,7 +717,6 @@ struct mt753x_info {
>  			    int regnum);
>  	int (*phy_write_c45)(struct mt7530_priv *priv, int port, int devad,
>  			     int regnum, u16 val);
> -	int (*pad_setup)(struct dsa_switch *ds, phy_interface_t interface);
>  	int (*cpu_port_config)(struct dsa_switch *ds, int port);
>  	void (*mac_port_get_caps)(struct dsa_switch *ds, int port,
>  				  struct phylink_config *config);
> -- 
> 2.37.2
> 
