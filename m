Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68A11F84F1
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 21:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgFMTbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 15:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgFMTbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 15:31:08 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C630CC03E96F;
        Sat, 13 Jun 2020 12:31:07 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id p18so8736755eds.7;
        Sat, 13 Jun 2020 12:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/kNY3rdYu5FbXtz4ELo7zyxNW/R3tj/BP+SYvB4y5JY=;
        b=s3noLO16iA+qt99O/Dil/n46YaRRTW/uURa7d/R0DUgJHylcPM9WyCiY99qiSuWQWi
         rvzvd16yhAJBB4y5XdOxSFh+LU/bFwsf3QJsfwawqvMXgr20FvF9UaYFsaUezT4hXDzT
         ymffBsWvk//tYaobawg09tvZ1/1ldmuQ1WsR17T+VnTpH1rOBn78bWPEchMvlcBRn+tx
         nBW1UjC48tGhtFPpVSQv1wuTh55RSMFJdRqnSRULjuJTPTAUulhYkCnWER97/uAV/M1G
         EDl88ulr/iHJ8iQumd+/BjY4fW+WuwbNFQamnA+HymXuKhFQB2S4MqlCFX0gfZocmflh
         vjag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/kNY3rdYu5FbXtz4ELo7zyxNW/R3tj/BP+SYvB4y5JY=;
        b=sfW4SFNEQI3ZrJifE1nKZHjMEErsBkQQ0vW5EQMUTIM3f3jOOYmjiNKjwIQItJp+6Q
         AswCBM8D/DVKT8LqdDQkfM2ACK4FESRmy3bFZ4cgus/D/jFkg3MzFY6HHZRolp3kgkGl
         /Px0a0rmUhUhtnq8oIdbpvegU26XTxBaq+Ltja4OXRlQtWvLQu+3VZkzsjxFpz+eg+G/
         CtnkJZw6bFeMkvzLkQbQBcfATb0wRQTlqiTw1hAs/gkRoBqMTMQG9XTdNpcv42LGVawf
         bYN9HWwagCYEW8fslKRVGpRn9p/dBS+VjYALiu9j2lGwH/2Ayi2Yg8QkTdYgX+KTLS+c
         5nng==
X-Gm-Message-State: AOAM532k7mdJI+pF7A3Il+UeZOs2MY0HZpi1GwNctx48rdpKhzc3t8nS
        rnwkawwWWDJ4JRnulz04pyjQwLkplFO+R+ec87M=
X-Google-Smtp-Source: ABdhPJworKApnuXmlLNNzsoJjNmNz+1kag1x1jotMMD/CLGp+aMCgj5q07deuA4jA4GiURySIoxB4f/Q/ECE3bcmQaQ=
X-Received: by 2002:a50:fb0b:: with SMTP id d11mr17667991edq.118.1592076666245;
 Sat, 13 Jun 2020 12:31:06 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1592047530.git.noodles@earth.li> <f0f9232fa46d04ba0037305098d8ef17b2ffcacc.1592047530.git.noodles@earth.li>
In-Reply-To: <f0f9232fa46d04ba0037305098d8ef17b2ffcacc.1592047530.git.noodles@earth.li>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 13 Jun 2020 22:30:55 +0300
Message-ID: <CA+h21hqgpSi3LP4F+0b_VVOwwL2dDYzy7Jxat1kr2cdMOLTVuA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 1/2] net: dsa: qca8k: Switch to PHYLINK instead of PHYLIB
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 13 Jun 2020 at 14:31, Jonathan McDowell <noodles@earth.li> wrote:
>
> Update the driver to use the new PHYLINK callbacks, removing the
> legacy adjust_link callback.
>
> Signed-off-by: Jonathan McDowell <noodles@earth.li>
> ---
>  drivers/net/dsa/qca8k.c | 308 +++++++++++++++++++++++++++-------------
>  1 file changed, 211 insertions(+), 97 deletions(-)
>
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index d2b5ab403e06..dadf9ab2c14a 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -14,6 +14,7 @@
>  #include <linux/of_platform.h>
>  #include <linux/if_bridge.h>
>  #include <linux/mdio.h>
> +#include <linux/phylink.h>
>  #include <linux/gpio/consumer.h>
>  #include <linux/etherdevice.h>
>
> @@ -418,55 +419,6 @@ qca8k_mib_init(struct qca8k_priv *priv)
>         mutex_unlock(&priv->reg_mutex);
>  }
>
> -static int
> -qca8k_set_pad_ctrl(struct qca8k_priv *priv, int port, int mode)
> -{
> -       u32 reg, val;
> -
> -       switch (port) {
> -       case 0:
> -               reg = QCA8K_REG_PORT0_PAD_CTRL;
> -               break;
> -       case 6:
> -               reg = QCA8K_REG_PORT6_PAD_CTRL;
> -               break;
> -       default:
> -               pr_err("Can't set PAD_CTRL on port %d\n", port);
> -               return -EINVAL;
> -       }
> -
> -       /* Configure a port to be directly connected to an external
> -        * PHY or MAC.
> -        */
> -       switch (mode) {
> -       case PHY_INTERFACE_MODE_RGMII:
> -               /* RGMII mode means no delay so don't enable the delay */
> -               val = QCA8K_PORT_PAD_RGMII_EN;
> -               qca8k_write(priv, reg, val);
> -               break;
> -       case PHY_INTERFACE_MODE_RGMII_ID:
> -               /* RGMII_ID needs internal delay. This is enabled through
> -                * PORT5_PAD_CTRL for all ports, rather than individual port
> -                * registers
> -                */
> -               qca8k_write(priv, reg,
> -                           QCA8K_PORT_PAD_RGMII_EN |
> -                           QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
> -                           QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
> -               qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
> -                           QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
> -               break;
> -       case PHY_INTERFACE_MODE_SGMII:
> -               qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
> -               break;
> -       default:
> -               pr_err("xMII mode %d not supported\n", mode);
> -               return -EINVAL;
> -       }
> -
> -       return 0;
> -}
> -
>  static void
>  qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable)
>  {
> @@ -639,9 +591,7 @@ static int
>  qca8k_setup(struct dsa_switch *ds)
>  {
>         struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
> -       phy_interface_t phy_mode = PHY_INTERFACE_MODE_NA;
>         int ret, i;
> -       u32 mask;
>
>         /* Make sure that port 0 is the cpu port */
>         if (!dsa_is_cpu_port(ds, 0)) {
> @@ -661,24 +611,9 @@ qca8k_setup(struct dsa_switch *ds)
>         if (ret)
>                 return ret;
>
> -       /* Initialize CPU port pad mode (xMII type, delays...) */
> -       ret = of_get_phy_mode(dsa_to_port(ds, QCA8K_CPU_PORT)->dn, &phy_mode);
> -       if (ret) {
> -               pr_err("Can't find phy-mode for master device\n");
> -               return ret;
> -       }
> -       ret = qca8k_set_pad_ctrl(priv, QCA8K_CPU_PORT, phy_mode);
> -       if (ret < 0)
> -               return ret;
> -
> -       /* Enable CPU Port, force it to maximum bandwidth and full-duplex */
> -       mask = QCA8K_PORT_STATUS_SPEED_1000 | QCA8K_PORT_STATUS_TXFLOW |
> -              QCA8K_PORT_STATUS_RXFLOW | QCA8K_PORT_STATUS_DUPLEX;
> -       qca8k_write(priv, QCA8K_REG_PORT_STATUS(QCA8K_CPU_PORT), mask);
> +       /* Enable CPU Port */
>         qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
>                       QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
> -       qca8k_port_set_status(priv, QCA8K_CPU_PORT, 1);
> -       priv->port_sts[QCA8K_CPU_PORT].enabled = 1;
>
>         /* Enable MIB counters */
>         qca8k_mib_init(priv);
> @@ -693,10 +628,9 @@ qca8k_setup(struct dsa_switch *ds)
>                 qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
>                           QCA8K_PORT_LOOKUP_MEMBER, 0);
>
> -       /* Disable MAC by default on all user ports */
> +       /* Disable MAC by default on all ports */
>         for (i = 1; i < QCA8K_NUM_PORTS; i++)
> -               if (dsa_is_user_port(ds, i))
> -                       qca8k_port_set_status(priv, i, 0);
> +               qca8k_port_set_status(priv, i, 0);
>
>         /* Forward all unknown frames to CPU port for Linux processing */
>         qca8k_write(priv, QCA8K_REG_GLOBAL_FW_CTRL1,
> @@ -713,7 +647,7 @@ qca8k_setup(struct dsa_switch *ds)
>                                   QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
>                 }
>
> -               /* Invividual user ports get connected to CPU port only */
> +               /* Individual user ports get connected to CPU port only */

I would split typo fixes into separate patches.

>                 if (dsa_is_user_port(ds, i)) {
>                         int shift = 16 * (i % 2);
>
> @@ -743,44 +677,222 @@ qca8k_setup(struct dsa_switch *ds)
>  }
>
>  static void
> -qca8k_adjust_link(struct dsa_switch *ds, int port, struct phy_device *phy)
> +qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> +                        const struct phylink_link_state *state)
>  {
>         struct qca8k_priv *priv = ds->priv;
>         u32 reg;
>
> -       /* Force fixed-link setting for CPU port, skip others. */
> -       if (!phy_is_pseudo_fixed_link(phy))
> +       switch (port) {
> +       case 0: /* 1st CPU port */
> +               if (state->interface != PHY_INTERFACE_MODE_RGMII &&
> +                   state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
> +                   state->interface != PHY_INTERFACE_MODE_SGMII)
> +                       return;
> +
> +               reg = QCA8K_REG_PORT0_PAD_CTRL;
> +               break;
> +       case 1:
> +       case 2:
> +       case 3:
> +       case 4:
> +       case 5:
> +               /* Internal PHY, nothing to do */
> +               return;
> +       case 6: /* 2nd CPU port / external PHY */
> +               if (state->interface != PHY_INTERFACE_MODE_RGMII &&
> +                   state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
> +                   state->interface != PHY_INTERFACE_MODE_SGMII &&
> +                   state->interface != PHY_INTERFACE_MODE_1000BASEX)
> +                       return;
> +
> +               reg = QCA8K_REG_PORT6_PAD_CTRL;
> +               break;
> +       default:
> +               dev_err(ds->dev, "%s: unsupported port: %i\n", __func__, port);
> +               return;
> +       }
> +
> +       if (port != 6 && phylink_autoneg_inband(mode)) {
> +               dev_err(ds->dev, "%s: in-band negotiation unsupported\n",
> +                       __func__);
> +               return;
> +       }
> +
> +       switch (state->interface) {
> +       case PHY_INTERFACE_MODE_RGMII:
> +               /* RGMII mode means no delay so don't enable the delay */
> +               qca8k_write(priv, reg, QCA8K_PORT_PAD_RGMII_EN);
> +               break;
> +       case PHY_INTERFACE_MODE_RGMII_ID:
> +               /* RGMII_ID needs internal delay. This is enabled through
> +                * PORT5_PAD_CTRL for all ports, rather than individual port
> +                * registers
> +                */
> +               qca8k_write(priv, reg,
> +                           QCA8K_PORT_PAD_RGMII_EN |
> +                           QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
> +                           QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
> +               qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
> +                           QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
> +               break;
> +       case PHY_INTERFACE_MODE_SGMII:
> +       case PHY_INTERFACE_MODE_1000BASEX:
> +               /* Enable SGMII on the port */
> +               qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
> +               break;
> +       default:
> +               dev_err(ds->dev, "xMII mode %s not supported for port %d\n",
> +                       phy_modes(state->interface), port);
>                 return;
> +       }
> +}
>
> -       /* Set port speed */
> -       switch (phy->speed) {
> -       case 10:
> -               reg = QCA8K_PORT_STATUS_SPEED_10;
> +static void
> +qca8k_phylink_validate(struct dsa_switch *ds, int port,
> +                      unsigned long *supported,
> +                      struct phylink_link_state *state)
> +{
> +       __ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +
> +       switch (port) {
> +       case 0: /* 1st CPU port */
> +               if (state->interface != PHY_INTERFACE_MODE_NA &&
> +                   state->interface != PHY_INTERFACE_MODE_RGMII &&
> +                   state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
> +                   state->interface != PHY_INTERFACE_MODE_SGMII)
> +                       goto unsupported;
>                 break;
> -       case 100:
> -               reg = QCA8K_PORT_STATUS_SPEED_100;
> +       case 1:
> +       case 2:
> +       case 3:
> +       case 4:
> +       case 5:
> +               /* Internal PHY */
> +               if (state->interface != PHY_INTERFACE_MODE_NA &&
> +                   state->interface != PHY_INTERFACE_MODE_GMII)
> +                       goto unsupported;
>                 break;
> -       case 1000:
> -               reg = QCA8K_PORT_STATUS_SPEED_1000;
> +       case 6: /* 2nd CPU port / external PHY */
> +               if (state->interface != PHY_INTERFACE_MODE_NA &&
> +                   state->interface != PHY_INTERFACE_MODE_RGMII &&
> +                   state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
> +                   state->interface != PHY_INTERFACE_MODE_SGMII &&
> +                   state->interface != PHY_INTERFACE_MODE_1000BASEX)
> +                       goto unsupported;
>                 break;
>         default:
> -               dev_dbg(priv->dev, "port%d link speed %dMbps not supported.\n",
> -                       port, phy->speed);
> +unsupported:
> +               linkmode_zero(supported);
>                 return;
>         }
>
> -       /* Set duplex mode */
> -       if (phy->duplex == DUPLEX_FULL)
> -               reg |= QCA8K_PORT_STATUS_DUPLEX;
> +       phylink_set_port_modes(mask);
> +       phylink_set(mask, Autoneg);
> +
> +       phylink_set(mask, 1000baseT_Full);
> +       phylink_set(mask, 10baseT_Half);
> +       phylink_set(mask, 10baseT_Full);
> +       phylink_set(mask, 100baseT_Half);
> +       phylink_set(mask, 100baseT_Full);
> +
> +       if (state->interface == PHY_INTERFACE_MODE_1000BASEX)
> +               phylink_set(mask, 1000baseX_Full);
> +
> +       phylink_set(mask, Pause);
> +       phylink_set(mask, Asym_Pause);
> +
> +       linkmode_and(supported, supported, mask);
> +       linkmode_and(state->advertising, state->advertising, mask);
> +}
> +
> +static int
> +qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port,
> +                            struct phylink_link_state *state)
> +{
> +       struct qca8k_priv *priv = ds->priv;
> +       u32 reg;
>
> -       /* Force flow control */
> -       if (dsa_is_cpu_port(ds, port))
> -               reg |= QCA8K_PORT_STATUS_RXFLOW | QCA8K_PORT_STATUS_TXFLOW;
> +       reg = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port));
> +
> +       state->link = !!(reg & QCA8K_PORT_STATUS_LINK_UP);
> +       state->an_complete = state->link;
> +       state->an_enabled = !!(reg & QCA8K_PORT_STATUS_LINK_AUTO);
> +       state->duplex = (reg & QCA8K_PORT_STATUS_DUPLEX) ? DUPLEX_FULL :
> +                                                          DUPLEX_HALF;
> +
> +       switch (reg & QCA8K_PORT_STATUS_SPEED) {
> +       case QCA8K_PORT_STATUS_SPEED_10:
> +               state->speed = SPEED_10;
> +               break;
> +       case QCA8K_PORT_STATUS_SPEED_100:
> +               state->speed = SPEED_100;
> +               break;
> +       case QCA8K_PORT_STATUS_SPEED_1000:
> +               state->speed = SPEED_1000;
> +               break;
> +       default:
> +               state->speed = SPEED_UNKNOWN;
> +               break;
> +       }
> +
> +       state->pause = MLO_PAUSE_NONE;
> +       if (reg & QCA8K_PORT_STATUS_RXFLOW)
> +               state->pause |= MLO_PAUSE_RX;
> +       if (reg & QCA8K_PORT_STATUS_TXFLOW)
> +               state->pause |= MLO_PAUSE_TX;
> +
> +       return 1;
> +}
> +
> +static void
> +qca8k_phylink_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
> +                           phy_interface_t interface)
> +{
> +       struct qca8k_priv *priv = ds->priv;
>
> -       /* Force link down before changing MAC options */
>         qca8k_port_set_status(priv, port, 0);
> +}
> +
> +static void
> +qca8k_phylink_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
> +                         phy_interface_t interface, struct phy_device *phydev,
> +                         int speed, int duplex, bool tx_pause, bool rx_pause)
> +{
> +       struct qca8k_priv *priv = ds->priv;
> +       u32 reg;
> +
> +       if (phylink_autoneg_inband(mode)) {
> +               reg = QCA8K_PORT_STATUS_LINK_AUTO;
> +       } else {
> +               switch (speed) {
> +               case SPEED_10:
> +                       reg = QCA8K_PORT_STATUS_SPEED_10;
> +                       break;
> +               case SPEED_100:
> +                       reg = QCA8K_PORT_STATUS_SPEED_100;
> +                       break;
> +               case SPEED_1000:
> +                       reg = QCA8K_PORT_STATUS_SPEED_1000;
> +                       break;
> +               default:
> +                       reg = QCA8K_PORT_STATUS_LINK_AUTO;
> +                       break;
> +               }
> +
> +               if (duplex == DUPLEX_FULL)
> +                       reg |= QCA8K_PORT_STATUS_DUPLEX;
> +
> +               if (rx_pause || dsa_is_cpu_port(ds, port))
> +                       reg |= QCA8K_PORT_STATUS_RXFLOW;
> +
> +               if (tx_pause || dsa_is_cpu_port(ds, port))
> +                       reg |= QCA8K_PORT_STATUS_TXFLOW;
> +       }
> +
> +       reg |= QCA8K_PORT_STATUS_TXMAC | QCA8K_PORT_STATUS_RXMAC;
> +
>         qca8k_write(priv, QCA8K_REG_PORT_STATUS(port), reg);
> -       qca8k_port_set_status(priv, port, 1);
>  }
>
>  static void
> @@ -937,13 +1049,11 @@ qca8k_port_enable(struct dsa_switch *ds, int port,
>  {
>         struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
>
> -       if (!dsa_is_user_port(ds, port))
> -               return 0;
> -
>         qca8k_port_set_status(priv, port, 1);
>         priv->port_sts[port].enabled = 1;
>
> -       phy_support_asym_pause(phy);
> +       if (dsa_is_user_port(ds, port))
> +               phy_support_asym_pause(phy);
>
>         return 0;
>  }
> @@ -1026,7 +1136,6 @@ qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
>  static const struct dsa_switch_ops qca8k_switch_ops = {
>         .get_tag_protocol       = qca8k_get_tag_protocol,
>         .setup                  = qca8k_setup,
> -       .adjust_link            = qca8k_adjust_link,
>         .get_strings            = qca8k_get_strings,
>         .get_ethtool_stats      = qca8k_get_ethtool_stats,
>         .get_sset_count         = qca8k_get_sset_count,
> @@ -1040,6 +1149,11 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
>         .port_fdb_add           = qca8k_port_fdb_add,
>         .port_fdb_del           = qca8k_port_fdb_del,
>         .port_fdb_dump          = qca8k_port_fdb_dump,
> +       .phylink_validate       = qca8k_phylink_validate,
> +       .phylink_mac_link_state = qca8k_phylink_mac_link_state,
> +       .phylink_mac_config     = qca8k_phylink_mac_config,
> +       .phylink_mac_link_down  = qca8k_phylink_mac_link_down,
> +       .phylink_mac_link_up    = qca8k_phylink_mac_link_up,
>  };
>
>  static int
> --
> 2.20.1
>
