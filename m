Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7057D1EFFE1
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 20:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgFES2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 14:28:07 -0400
Received: from lists.nic.cz ([217.31.204.67]:56854 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbgFES2H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 14:28:07 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 875FE140767;
        Fri,  5 Jun 2020 20:28:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1591381685; bh=dlzAjrHSLTJlrBksWH6lA6rKTtqWqJwSo5Eax8JDLXM=;
        h=Date:From:To;
        b=PpUpZRWC6T+8lG72B+k3PRqRCioHq4vOsnTRii+nnw3jDnFsc3IbD737nBNyibUoK
         S2xRotPhlwmMObrt8zzhPde91wmAAfhQ7fYHdXevrWL6GGDkSqSKBD8MQktC6Wko5l
         6ku9krnYLDSbhLbZPvw8yOUTT90Ds/E9u0i1k4Yk=
Date:   Fri, 5 Jun 2020 20:28:04 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: qca8k: introduce SGMII configuration
 options
Message-ID: <20200605202804.1dd78ee8@nic.cz>
In-Reply-To: <8ddd76e484e1bedd12c87ea0810826b60e004a65.1591380105.git.noodles@earth.li>
References: <cover.1591380105.git.noodles@earth.li>
        <8ddd76e484e1bedd12c87ea0810826b60e004a65.1591380105.git.noodles@earth.li>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,URIBL_BLOCKED,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Jun 2020 19:10:58 +0100
Jonathan McDowell <noodles@earth.li> wrote:

> The QCA8337(N) has an SGMII port which can operate in MAC, PHY or BASE-X
> mode depending on what it's connected to (e.g. CPU vs external PHY or
> SFP). At present the driver does no configuration of this port even if
> it is selected.
> 
> Add support for making sure the SGMII is enabled if it's in use, and
> device tree support for configuring the connection details.
> 
> Signed-off-by: Jonathan McDowell <noodles@earth.li>
> ---
>  drivers/net/dsa/qca8k.c | 44 ++++++++++++++++++++++++++++++++++++++++-
>  drivers/net/dsa/qca8k.h | 12 +++++++++++
>  2 files changed, 55 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 9f4205b4439b..5b7979aca9b9 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -418,6 +418,40 @@ qca8k_mib_init(struct qca8k_priv *priv)
>  	mutex_unlock(&priv->reg_mutex);
>  }
>  
> +static int
> +qca8k_setup_sgmii(struct qca8k_priv *priv)
> +{
> +	const char *mode;
> +	u32 val;
> +
> +	val = qca8k_read(priv, QCA8K_REG_SGMII_CTRL);
> +
> +	val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
> +		QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;
> +
> +	if (of_property_read_bool(priv->dev->of_node, "sgmii-delay"))
> +		val |= QCA8K_SGMII_CLK125M_DELAY;
> +
> +	if (of_property_read_string(priv->dev->of_node, "sgmii-mode", &mode)) {
> +		val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
> +
> +		if (!strcasecmp(mode, "basex")) {
> +			val |= QCA8K_SGMII_MODE_CTRL_BASEX;
> +		} else if (!strcasecmp(mode, "mac")) {
> +			val |= QCA8K_SGMII_MODE_CTRL_MAC;
> +		} else if (!strcasecmp(mode, "phy")) {
> +			val |= QCA8K_SGMII_MODE_CTRL_PHY;
> +		} else {
> +			pr_err("Unrecognised SGMII mode %s\n", mode);
> +			return -EINVAL;
> +		}
> +	}

There is no sgmii-mode device tree property documented. You should
infere this settings from the existing device tree bindings, ie look at
phy-mode. You can use of_get_phy_mode function, or something from
of_mdio.c, or better yet change the api in this driver to use the new
phylink API.

Marek


> +
> +	qca8k_write(priv, QCA8K_REG_SGMII_CTRL, val);
> +
> +	return 0;
> +}
> +
>  static int
>  qca8k_set_pad_ctrl(struct qca8k_priv *priv, int port, int mode)
>  {
> @@ -458,7 +492,8 @@ qca8k_set_pad_ctrl(struct qca8k_priv *priv, int port, int mode)
>  		break;
>  	case PHY_INTERFACE_MODE_SGMII:
>  		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
> -		break;
> +
> +		return qca8k_setup_sgmii(priv);
>  	default:
>  		pr_err("xMII mode %d not supported\n", mode);
>  		return -EINVAL;
> @@ -661,6 +696,13 @@ qca8k_setup(struct dsa_switch *ds)
>  	if (ret)
>  		return ret;
>  
> +	if (of_property_read_bool(priv->dev->of_node,
> +				  "disable-serdes-autoneg")) {
> +		mask = qca8k_read(priv, QCA8K_REG_PWS) |
> +		       QCA8K_PWS_SERDES_AEN_DIS;
> +		qca8k_write(priv, QCA8K_REG_PWS, mask);
> +	}
> +
>  	/* Initialize CPU port pad mode (xMII type, delays...) */
>  	ret = of_get_phy_mode(dsa_to_port(ds, QCA8K_CPU_PORT)->dn, &phy_mode);
>  	if (ret) {
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index 42d6ea24eb14..cd97c212f3f8 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -36,6 +36,8 @@
>  #define   QCA8K_MAX_DELAY				3
>  #define   QCA8K_PORT_PAD_RGMII_RX_DELAY_EN		BIT(24)
>  #define   QCA8K_PORT_PAD_SGMII_EN			BIT(7)
> +#define QCA8K_REG_PWS					0x010
> +#define   QCA8K_PWS_SERDES_AEN_DIS			BIT(7)
>  #define QCA8K_REG_MODULE_EN				0x030
>  #define   QCA8K_MODULE_EN_MIB				BIT(0)
>  #define QCA8K_REG_MIB					0x034
> @@ -77,6 +79,16 @@
>  #define   QCA8K_PORT_HDR_CTRL_ALL			2
>  #define   QCA8K_PORT_HDR_CTRL_MGMT			1
>  #define   QCA8K_PORT_HDR_CTRL_NONE			0
> +#define QCA8K_REG_SGMII_CTRL				0x0e0
> +#define   QCA8K_SGMII_EN_PLL				BIT(1)
> +#define   QCA8K_SGMII_EN_RX				BIT(2)
> +#define   QCA8K_SGMII_EN_TX				BIT(3)
> +#define   QCA8K_SGMII_EN_SD				BIT(4)
> +#define   QCA8K_SGMII_CLK125M_DELAY			BIT(7)
> +#define   QCA8K_SGMII_MODE_CTRL_MASK			(BIT(22) | BIT(23))
> +#define   QCA8K_SGMII_MODE_CTRL_BASEX			0
> +#define   QCA8K_SGMII_MODE_CTRL_PHY			BIT(22)
> +#define   QCA8K_SGMII_MODE_CTRL_MAC			BIT(23)
>  
>  /* EEE control registers */
>  #define QCA8K_REG_EEE_CTRL				0x100

