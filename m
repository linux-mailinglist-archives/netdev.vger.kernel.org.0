Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645A05202E
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 03:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbfFYBAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 21:00:40 -0400
Received: from pb-smtp1.pobox.com ([64.147.108.70]:53555 "EHLO
        pb-smtp1.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729336AbfFYBAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 21:00:40 -0400
Received: from pb-smtp1.pobox.com (unknown [127.0.0.1])
        by pb-smtp1.pobox.com (Postfix) with ESMTP id E370B166E86;
        Mon, 24 Jun 2019 21:00:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=subject:to:cc
        :references:from:message-id:date:mime-version:in-reply-to
        :content-type:content-transfer-encoding; s=sasl; bh=Nf98VEpzf7Ot
        iCL+6e9xy3Hq6AA=; b=b8bzrrPZd4hxAZIVhklHshtzsOaZkb+uJbfXwXM8UGRL
        EBQbuYfMmWrJLYlnLF78218t1OhM6T0RFeqih+GsXV2UDnVWrxcDTd7LWdeeF5vH
        rv/BdK4t2pJFvWiog+Nkw3SmHqphgL/sunsrVHuuXlz9hWOVIDPAPrjCbzagYG0=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:to:cc
        :references:from:message-id:date:mime-version:in-reply-to
        :content-type:content-transfer-encoding; q=dns; s=sasl; b=CNX69V
        3a4HcFXzpGmJDgSjZVmj1pjtwb368c7do0jqRCgBdsUsPKNWS0ATRT3deninkTvr
        8eWOJv+A/7tR8lXHi8iUaqRHAc19TdC1U5f6MVHL78pGic/H+bEUAYEmBWNgjRcn
        YZQOOHDKQeRvbQXGdS91yk2FNCU29OXX3Aghg=
Received: from pb-smtp1.nyi.icgroup.com (unknown [127.0.0.1])
        by pb-smtp1.pobox.com (Postfix) with ESMTP id D7BD3166E85;
        Mon, 24 Jun 2019 21:00:30 -0400 (EDT)
Received: from [192.168.1.134] (unknown [70.142.57.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pb-smtp1.pobox.com (Postfix) with ESMTPSA id EAEE5166E83;
        Mon, 24 Jun 2019 21:00:27 -0400 (EDT)
Subject: Re: [PATCH RFC net-next 1/5] net: dsa: mt7530: Convert to PHYLINK API
To:     =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        sean.wang@mediatek.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, matthias.bgg@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com
Cc:     frank-w@public-files.de, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
References: <20190624145251.4849-1-opensource@vdorst.com>
 <20190624145251.4849-2-opensource@vdorst.com>
From:   Daniel Santos <daniel.santos@pobox.com>
Message-ID: <13c67cb7-b33e-f2b1-9d1e-d2882e0ff076@pobox.com>
Date:   Mon, 24 Jun 2019 19:58:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190624145251.4849-2-opensource@vdorst.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Pobox-Relay-ID: 9F971F98-96E4-11E9-81CE-46F8B7964D18-06139138!pb-smtp1.pobox.com
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/19 9:52 AM, Ren=C3=A9 van Dorst wrote:
> Convert mt7530 to PHYLINK API
>
> Signed-off-by: Ren=C3=A9 van Dorst <opensource@vdorst.com>
> ---
>  drivers/net/dsa/mt7530.c | 237 +++++++++++++++++++++++++++++----------
>  drivers/net/dsa/mt7530.h |   9 ++
>  2 files changed, 187 insertions(+), 59 deletions(-)
>
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 3181e95586d6..9c5e4dd00826 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -13,7 +13,7 @@
>  #include <linux/of_mdio.h>
>  #include <linux/of_net.h>
>  #include <linux/of_platform.h>
> -#include <linux/phy.h>
> +#include <linux/phylink.h>
>  #include <linux/regmap.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/reset.h>
> @@ -633,63 +633,6 @@ mt7530_get_sset_count(struct dsa_switch *ds, int p=
ort, int sset)
>  	return ARRAY_SIZE(mt7530_mib);
>  }
> =20
> -static void mt7530_adjust_link(struct dsa_switch *ds, int port,
> -			       struct phy_device *phydev)
> -{
> -	struct mt7530_priv *priv =3D ds->priv;
> -
> -	if (phy_is_pseudo_fixed_link(phydev)) {
> -		dev_dbg(priv->dev, "phy-mode for master device =3D %x\n",
> -			phydev->interface);
> -
> -		/* Setup TX circuit incluing relevant PAD and driving */
> -		mt7530_pad_clk_setup(ds, phydev->interface);
> -
> -		if (priv->id =3D=3D ID_MT7530) {
> -			/* Setup RX circuit, relevant PAD and driving on the
> -			 * host which must be placed after the setup on the
> -			 * device side is all finished.
> -			 */
> -			mt7623_pad_clk_setup(ds);
> -		}
> -	} else {
> -		u16 lcl_adv =3D 0, rmt_adv =3D 0;
> -		u8 flowctrl;
> -		u32 mcr =3D PMCR_USERP_LINK | PMCR_FORCE_MODE;
> -
> -		switch (phydev->speed) {
> -		case SPEED_1000:
> -			mcr |=3D PMCR_FORCE_SPEED_1000;
> -			break;
> -		case SPEED_100:
> -			mcr |=3D PMCR_FORCE_SPEED_100;
> -			break;
> -		}
> -
> -		if (phydev->link)
> -			mcr |=3D PMCR_FORCE_LNK;
> -
> -		if (phydev->duplex) {
> -			mcr |=3D PMCR_FORCE_FDX;
> -
> -			if (phydev->pause)
> -				rmt_adv =3D LPA_PAUSE_CAP;
> -			if (phydev->asym_pause)
> -				rmt_adv |=3D LPA_PAUSE_ASYM;
> -
> -			lcl_adv =3D linkmode_adv_to_lcl_adv_t(
> -				phydev->advertising);
> -			flowctrl =3D mii_resolve_flowctrl_fdx(lcl_adv, rmt_adv);
> -
> -			if (flowctrl & FLOW_CTRL_TX)
> -				mcr |=3D PMCR_TX_FC_EN;
> -			if (flowctrl & FLOW_CTRL_RX)
> -				mcr |=3D PMCR_RX_FC_EN;
> -		}
> -		mt7530_write(priv, MT7530_PMCR_P(port), mcr);
> -	}
> -}
> -
>  static int
>  mt7530_cpu_port_enable(struct mt7530_priv *priv,
>  		       int port)
> @@ -1323,6 +1266,178 @@ mt7530_setup(struct dsa_switch *ds)
>  	return 0;
>  }
> =20
> +static void mt7530_phylink_mac_config(struct dsa_switch *ds, int port,
> +				      unsigned int mode,
> +				      const struct phylink_link_state *state)
> +{
> +	struct mt7530_priv *priv =3D ds->priv;
> +	u32 mcr =3D PMCR_IFG_XMIT(1) | PMCR_MAC_MODE | PMCR_BACKOFF_EN |
> +		  PMCR_BACKPR_EN | PMCR_TX_EN | PMCR_RX_EN;
> +
> +	switch (port) {
> +	case 0: /* Internal phy */
> +	case 1:
> +	case 2:
> +	case 3:
> +	case 4:
> +		if (state->interface !=3D PHY_INTERFACE_MODE_GMII)
> +			goto unsupported;
> +		break;
> +	/* case 5: Port 5 is not supported! */
> +	case 6: /* 1st cpu port */
> +		if (state->interface !=3D PHY_INTERFACE_MODE_RGMII &&
> +		    state->interface !=3D PHY_INTERFACE_MODE_TRGMII)
> +			goto unsupported;
> +
> +		/* Setup TX circuit incluing relevant PAD and driving */
> +		mt7530_pad_clk_setup(ds, state->interface);
> +
> +		if (priv->id =3D=3D ID_MT7530) {
> +			/* Setup RX circuit, relevant PAD and driving on the
> +			 * host which must be placed after the setup on the
> +			 * device side is all finished.
> +			 */
> +			mt7623_pad_clk_setup(ds);
> +		}
> +		break;
> +	default:
> +		dev_err(ds->dev, "%s: unsupported port: %i\n", __func__, port);
> +		return;
> +	}
> +
> +	if (!state->an_enabled || mode =3D=3D MLO_AN_FIXED) {
> +		mcr |=3D PMCR_FORCE_MODE;
> +
> +		if (state->speed =3D=3D SPEED_1000)
> +			mcr |=3D PMCR_FORCE_SPEED_1000;
> +		if (state->speed =3D=3D SPEED_100)
> +			mcr |=3D PMCR_FORCE_SPEED_100;

I would suggest using the defines

#define PMCR_FORCE_SPEED	0x0000000c /* or PMCR_FORCE_SPEED_MASK */
#define PMCR_FORCE_SPEED_10	0x00000000
#define PMCR_FORCE_SPEED_100	0x00000004
#define PMCR_FORCE_SPEED_1000	0x00000008

and a switch statement such as

	switch (state->speed) {
	case SPEED_10:
		mcr |=3D PMCR_FORCE_SPEED_10;
		break;
	case SPEED_100:
		mcr |=3D PMCR_FORCE_SPEED_100;
		break;
	case SPEED_1000:
		mcr |=3D PMCR_FORCE_SPEED_1000;
		break;
	}

This will compile the same (i.e, the mcr |=3D 0 will optimize away, etc.)=
,
while alleviating the need to intimately know the hardware in order to
easily understand what the code is doing at a glance.=C2=A0 It's also bet=
ter
form as we're treating the two bits as a composite value, rather than
two separate bits.


> +		if (state->duplex =3D=3D DUPLEX_FULL)
> +			mcr |=3D PMCR_FORCE_FDX;
> +		if (state->link || mode =3D=3D MLO_AN_FIXED)
> +			mcr |=3D PMCR_FORCE_LNK;
> +		if (state->pause || phylink_test(state->advertising, Pause))
> +			mcr |=3D PMCR_TX_FC_EN | PMCR_RX_FC_EN;
> +		if (state->pause & MLO_PAUSE_TX)
> +			mcr |=3D PMCR_TX_FC_EN;
> +		if (state->pause & MLO_PAUSE_RX)
> +			mcr |=3D PMCR_RX_FC_EN;
> +	}
> +
> +	mt7530_write(priv, MT7530_PMCR_P(port), mcr);
> +
> +	return;
> +
> +unsupported:
> +	dev_err(ds->dev, "%s: P%d: Unsupported phy_interface mode: %d (%s)\n"=
,
> +		__func__, port, state->interface, phy_modes(state->interface));
> +}
> +
> +static void mt7530_phylink_mac_link_down(struct dsa_switch *ds, int po=
rt,
> +					 unsigned int mode,
> +					 phy_interface_t interface)
> +{
> +	/* Do nothing */
> +}
> +
> +static void mt7530_phylink_mac_link_up(struct dsa_switch *ds, int port=
,
> +				       unsigned int mode,
> +				       phy_interface_t interface,
> +				       struct phy_device *phydev)
> +{
> +	/* Do nothing */
> +}
> +
> +static void mt7530_phylink_validate(struct dsa_switch *ds, int port,
> +				    unsigned long *supported,
> +				    struct phylink_link_state *state)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
> +
> +	switch (port) {
> +	case 0: /* Internal phy */
> +	case 1:
> +	case 2:
> +	case 3:
> +	case 4:
> +		if (state->interface !=3D PHY_INTERFACE_MODE_NA &&
> +		    state->interface !=3D PHY_INTERFACE_MODE_GMII)
> +			goto unsupported;
> +		break;
> +	/* case 5: Port 5 not supported! */
> +	case 6: /* 1st cpu port */
> +		if (state->interface !=3D PHY_INTERFACE_MODE_RGMII &&
> +		    state->interface !=3D PHY_INTERFACE_MODE_TRGMII)
> +			goto unsupported;
> +		break;
> +	default:
> +		linkmode_zero(supported);
> +		dev_err(ds->dev, "%s: unsupported port: %i\n", __func__, port);
> +		return;
> +	}
> +
> +	phylink_set(mask, Autoneg);
> +	phylink_set(mask, Pause);
> +	phylink_set(mask, Asym_Pause);
> +	phylink_set(mask, MII);
> +
> +	phylink_set(mask, 10baseT_Half);
> +	phylink_set(mask, 10baseT_Full);
> +	phylink_set(mask, 100baseT_Half);
> +	phylink_set(mask, 100baseT_Full);
> +	phylink_set(mask, 1000baseT_Full);
> +	phylink_set(mask, 1000baseT_Half);
> +
> +	linkmode_and(supported, supported, mask);
> +	linkmode_and(state->advertising, state->advertising, mask);
> +	return;
> +
> +unsupported:
> +	linkmode_zero(supported);
> +	dev_err(ds->dev, "%s: unsupported interface mode: [0x%x] %s\n",
> +		__func__, state->interface, phy_modes(state->interface));
> +}
> +
> +static int
> +mt7530_phylink_mac_link_state(struct dsa_switch *ds, int port,
> +			      struct phylink_link_state *state)
> +{
> +	struct mt7530_priv *priv =3D ds->priv;
> +	u32 pmsr;
> +
> +	if (port < 0 || port >=3D MT7530_NUM_PORTS)
> +		return -EINVAL;
> +
> +	pmsr =3D mt7530_read(priv, MT7530_PMSR_P(port));
> +
> +	state->link =3D (pmsr & PMSR_LINK);
> +	state->an_complete =3D state->link;
> +	state->duplex =3D (pmsr & PMSR_DPX) >> 1;
> +
> +	switch (pmsr & (PMSR_SPEED_1000 | PMSR_SPEED_100)) {
> +	case 0:
> +		state->speed =3D SPEED_10;
> +		break;
> +	case PMSR_SPEED_100:
> +		state->speed =3D SPEED_100;
> +		break;
> +	case PMSR_SPEED_1000:
> +		state->speed =3D SPEED_1000;
> +		break;
> +	default:
> +		state->speed =3D SPEED_UNKNOWN;
> +		break;
> +	}
> +

Same as above: add PMSR_SPEED_10, and and with PMSR_SPEED (or
PMSR_SPEED_MASK if you prefer).

> +	state->pause =3D 0;
> +	if (pmsr & PMSR_RX_FC)
> +		state->pause |=3D MLO_PAUSE_RX;
> +	if (pmsr & PMSR_TX_FC)
> +		state->pause |=3D MLO_PAUSE_TX;
> +
> +	return 1;
> +}
> +
>  static const struct dsa_switch_ops mt7530_switch_ops =3D {
>  	.get_tag_protocol	=3D mtk_get_tag_protocol,
>  	.setup			=3D mt7530_setup,
> @@ -1331,7 +1446,6 @@ static const struct dsa_switch_ops mt7530_switch_=
ops =3D {
>  	.phy_write		=3D mt7530_phy_write,
>  	.get_ethtool_stats	=3D mt7530_get_ethtool_stats,
>  	.get_sset_count		=3D mt7530_get_sset_count,
> -	.adjust_link		=3D mt7530_adjust_link,
>  	.port_enable		=3D mt7530_port_enable,
>  	.port_disable		=3D mt7530_port_disable,
>  	.port_stp_state_set	=3D mt7530_stp_state_set,
> @@ -1344,6 +1458,11 @@ static const struct dsa_switch_ops mt7530_switch=
_ops =3D {
>  	.port_vlan_prepare	=3D mt7530_port_vlan_prepare,
>  	.port_vlan_add		=3D mt7530_port_vlan_add,
>  	.port_vlan_del		=3D mt7530_port_vlan_del,
> +	.phylink_validate	=3D mt7530_phylink_validate,
> +	.phylink_mac_link_state =3D mt7530_phylink_mac_link_state,
> +	.phylink_mac_config	=3D mt7530_phylink_mac_config,
> +	.phylink_mac_link_down	=3D mt7530_phylink_mac_link_down,
> +	.phylink_mac_link_up	=3D mt7530_phylink_mac_link_up,
>  };
> =20
>  static const struct of_device_id mt7530_of_match[] =3D {
> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> index bfac90f48102..41d9a132ac70 100644
> --- a/drivers/net/dsa/mt7530.h
> +++ b/drivers/net/dsa/mt7530.h
> @@ -198,6 +198,7 @@ enum mt7530_vlan_port_attr {
>  #define  PMCR_FORCE_SPEED_100		BIT(2)
>  #define  PMCR_FORCE_FDX			BIT(1)
>  #define  PMCR_FORCE_LNK			BIT(0)
> +#define  PMCR_FORCE_LNK_DOWN		PMCR_FORCE_MODE
>  #define  PMCR_COMMON_LINK		(PMCR_IFG_XMIT(1) | PMCR_MAC_MODE | \
>  					 PMCR_BACKOFF_EN | PMCR_BACKPR_EN | \
>  					 PMCR_TX_EN | PMCR_RX_EN | \
> @@ -218,6 +219,14 @@ enum mt7530_vlan_port_attr {
>  					 PMCR_TX_FC_EN | PMCR_RX_FC_EN)
> =20
>  #define MT7530_PMSR_P(x)		(0x3008 + (x) * 0x100)
> +#define  PMSR_EEE1G			BIT(7)
> +#define  PMSR_EEE100M			BIT(6)
> +#define  PMSR_RX_FC			BIT(5)
> +#define  PMSR_TX_FC			BIT(4)
> +#define  PMSR_SPEED_1000		BIT(3)
> +#define  PMSR_SPEED_100			BIT(2)
> +#define  PMSR_DPX			BIT(1)
> +#define  PMSR_LINK			BIT(0)
> =20
>  /* Register for MIB */
>  #define MT7530_PORT_MIB_COUNTER(x)	(0x4000 + (x) * 0x100)

Cheers,
Daniel
