Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D136EB091
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 19:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbjDUR33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 13:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbjDUR31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 13:29:27 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A300B12C96;
        Fri, 21 Apr 2023 10:29:26 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1ppuZB-0002Ee-23;
        Fri, 21 Apr 2023 19:29:01 +0200
Date:   Fri, 21 Apr 2023 18:28:57 +0100
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
Subject: Re: [RFC PATCH net-next 08/22] net: dsa: mt7530: change
 p{5,6}_interface to p{5,6}_configured
Message-ID: <ZELH2RlYLPjJGx6Y@makrotopia.org>
References: <20230421143648.87889-1-arinc.unal@arinc9.com>
 <20230421143648.87889-9-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230421143648.87889-9-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 05:36:34PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> The idea of p5_interface and p6_interface pointers is to prevent
> mt753x_mac_config() from running twice for MT7531, as it's already run with
> mt753x_cpu_port_enable() from mt7531_setup_common(), if the port is used as
> a CPU port.
> 
> Change p5_interface and p6_interface to p5_configured and p6_configured.
> Make them boolean.
> 
> Do not set them for any other reason.
> 
> The priv->p5_intf_sel check is useless as in this code path, it will always
> be P5_INTF_SEL_GMAC5.
> 
> There was also no need to set priv->p5_interface and priv->p6_interface to
> PHY_INTERFACE_MODE_NA on mt7530_setup() and mt7531_setup() as they would
> already be set to that when "priv" is allocated. The pointers were of the
> phy_interface_t enumeration type, and the first element of the enum is
> PHY_INTERFACE_MODE_NA. There was nothing in between that would change this
> beforehand.
> 
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>

NACK. This assumes that a user port is configured exactly once.
However, interface mode may change because of mode-changing PHYs (e.g.
often using Cisco SGMII for 10M/100M/1000M but using 2500Base-X for
2500M, ie. depending on actual link speed).

Also when using SFP modules (which can be hotplugged) the interface
mode may change after initially setting up the driver, e.g. when SFP
driver is loaded or a module is plugged or replaced.

> ---
>  drivers/net/dsa/mt7530.c | 19 ++++---------------
>  drivers/net/dsa/mt7530.h | 10 ++++++----
>  2 files changed, 10 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index bac2388319a3..2f670e512415 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2237,8 +2237,6 @@ mt7530_setup(struct dsa_switch *ds)
>  	val |= MHWTRAP_MANUAL;
>  	mt7530_write(priv, MT7530_MHWTRAP, val);
>  
> -	priv->p6_interface = PHY_INTERFACE_MODE_NA;
> -
>  	/* Enable and reset MIB counters */
>  	mt7530_mib_reset(ds);
>  
> @@ -2460,10 +2458,6 @@ mt7531_setup(struct dsa_switch *ds)
>  	mt7530_rmw(priv, MT7531_GPIO_MODE0, MT7531_GPIO0_MASK,
>  		   MT7531_GPIO0_INTERRUPT);
>  
> -	/* Let phylink decide the interface later. */
> -	priv->p5_interface = PHY_INTERFACE_MODE_NA;
> -	priv->p6_interface = PHY_INTERFACE_MODE_NA;
> -
>  	/* Enable PHY core PLL, since phy_device has not yet been created
>  	 * provided for phy_[read,write]_mmd_indirect is called, we provide
>  	 * our own mt7531_ind_mmd_phy_[read,write] to complete this
> @@ -2733,25 +2727,20 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  			goto unsupported;
>  		break;
>  	case 5: /* Port 5, can be used as a CPU port. */
> -		if (priv->p5_interface == state->interface)
> +		if (priv->p5_configured)
>  			break;
>  
>  		if (mt753x_mac_config(ds, port, mode, state) < 0)
>  			goto unsupported;
> -
> -		if (priv->p5_intf_sel != P5_DISABLED)
> -			priv->p5_interface = state->interface;
>  		break;
>  	case 6: /* Port 6, can be used as a CPU port. */
> -		if (priv->p6_interface == state->interface)
> +		if (priv->p6_configured)
>  			break;
>  
>  		mt753x_pad_setup(ds, state);
>  
>  		if (mt753x_mac_config(ds, port, mode, state) < 0)
>  			goto unsupported;
> -
> -		priv->p6_interface = state->interface;
>  		break;
>  	default:
>  unsupported:
> @@ -2859,12 +2848,12 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
>  		else
>  			interface = PHY_INTERFACE_MODE_2500BASEX;
>  
> -		priv->p5_interface = interface;
> +		priv->p5_configured = true;
>  		break;
>  	case 6:
>  		interface = PHY_INTERFACE_MODE_2500BASEX;
>  
> -		priv->p6_interface = interface;
> +		priv->p6_configured = true;
>  		break;
>  	default:
>  		return -EINVAL;
> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> index f58828577520..c3a37a0f4843 100644
> --- a/drivers/net/dsa/mt7530.h
> +++ b/drivers/net/dsa/mt7530.h
> @@ -745,8 +745,10 @@ struct mt753x_info {
>   * @ports:		Holding the state among ports
>   * @reg_mutex:		The lock for protecting among process accessing
>   *			registers
> - * @p6_interface:	Holding the current port 6 interface
> - * @p5_interface:	Holding the current port 5 interface
> + * @p6_configured:	Flag for distinguishing if port 6 of the MT7531 switch
> + *			is already configured
> + * @p5_configured:	Flag for distinguishing if port 5 of the MT7531 switch
> + *			is already configured
>   * @p5_intf_sel:	Holding the current port 5 interface select
>   * @p5_sgmii:		Flag for distinguishing if port 5 of the MT7531 switch
>   *			has got SGMII
> @@ -767,8 +769,8 @@ struct mt7530_priv {
>  	const struct mt753x_info *info;
>  	unsigned int		id;
>  	bool			mcm;
> -	phy_interface_t		p6_interface;
> -	phy_interface_t		p5_interface;
> +	bool			p6_configured;
> +	bool			p5_configured;
>  	p5_interface_select	p5_intf_sel;
>  	bool			p5_sgmii;
>  	u8			mirror_rx;
> -- 
> 2.37.2
> 
