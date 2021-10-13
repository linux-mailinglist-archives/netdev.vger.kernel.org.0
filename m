Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A1A42BA5B
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 10:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238940AbhJMIbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 04:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238950AbhJMIbW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 04:31:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FD21610CE;
        Wed, 13 Oct 2021 08:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634113759;
        bh=9AanjzVrkE5YAEfmmzu9A5gx/ULDw6Y85cUNeD2BSwU=;
        h=In-Reply-To:References:From:Subject:Cc:To:Date:From;
        b=AUms3Z4z+tmy1W/K0NHphRpgmBGoLBjtunA4C1CQHLxyt7FlHcSrGpnNbGAaXs6ja
         IELP9p9ZoVJmNWb/XKmFmhLnQVPo39fsobpvKQu9oSUtrmBd0ocGDmeROJGRJ3wEiz
         lBgagmHbBjbwPNdJkwcMmTYx3HfZXKula00PA5Ui2hpPU/y3jPIRPId8FnInUz6l+V
         Eywf6aIbVQ8gD5yJ9gGFfmMUJzu36alI3+bvQwabDO9Id2P8e/mMqkZTQto0vPLE6v
         sxxT6hN4BI78P/97acSrrAtv2juy/hvyQBy8CwC+z+mMDw2yYAoV+4WVCm0aYPz3pd
         Z1IEo/M7Fst3Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211012194644.3182475-2-sean.anderson@seco.com>
References: <20211012194644.3182475-1-sean.anderson@seco.com> <20211012194644.3182475-2-sean.anderson@seco.com>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH v3 2/2] net: macb: Clean up macb_validate
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>, netdev@vger.kernel.org
Message-ID: <163411375475.451779.17785363770684815611@kwain>
Date:   Wed, 13 Oct 2021 10:29:14 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Sean Anderson (2021-10-12 21:46:44)
> +       /* There are three major types of interfaces we support:
> +        * - (R)MII supporting 10/100 Mbit/s
> +        * - GMII, RGMII, and SGMII supporting 10/100/1000 Mbit/s
> +        * - 10GBASER supporting 10 Gbit/s only
> +        * Because GMII and MII both support 10/100, GMII falls through t=
o MII.
> +        *
> +        * If we can't support an interface mode, we just clear the suppo=
rted
> +        * mask and return. The major complication is that if we get
> +        * PHY_INTERFACE_MODE_NA, we must return all modes we support.  B=
ecause
> +        * of this, NA starts at the top of the switch and falls all the =
way to
> +        * the bottom, and doesn't return early if we don't support a
> +        * particular mode.
> +        */
> +       switch (state->interface) {
> +       case PHY_INTERFACE_MODE_NA:
> +       case PHY_INTERFACE_MODE_10GBASER:
> +               if (bp->caps & MACB_CAPS_HIGH_SPEED &&
> +                   bp->caps & MACB_CAPS_PCS &&
> +                   bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
> +                       phylink_set_10g_modes(mask);
> +                       phylink_set(mask, 10000baseKR_Full);
> +               } else if (one) {
> +                       bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_N=
BITS);
> +                       return;
> +               }
> +               if (one)
> +                       break;

This can go in the first if block.

> +               fallthrough;
> +       case PHY_INTERFACE_MODE_GMII:
> +       case PHY_INTERFACE_MODE_RGMII:
> +       case PHY_INTERFACE_MODE_RGMII_ID:
> +       case PHY_INTERFACE_MODE_RGMII_RXID:
> +       case PHY_INTERFACE_MODE_RGMII_TXID:
> +       case PHY_INTERFACE_MODE_SGMII:
> +               if (macb_is_gem(bp)) {
> +                       if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {

Is not having MACB_CAPS_GIGABIT_MODE_AVAILABLE acceptable here, or
should the two above checks be merged?

> +                               phylink_set(mask, 1000baseT_Full);
> +                               phylink_set(mask, 1000baseX_Full);
> +                               if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HAL=
F))
> +                                       phylink_set(mask, 1000baseT_Half);
> +                       }
> +               } else if (one) {
> +                       bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_N=
BITS);
> +                       return;
> +               }
> +               fallthrough;
> +       case PHY_INTERFACE_MODE_MII:
> +       case PHY_INTERFACE_MODE_RMII:
> +               phylink_set(mask, 10baseT_Half);
> +               phylink_set(mask, 10baseT_Full);
> +               phylink_set(mask, 100baseT_Half);
> +               phylink_set(mask, 100baseT_Full);
> +               break;
> +       default:
>                 bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
>                 return;
>         }

(For readability, it's not for me to decide in the end).

Thanks,
Antoine
