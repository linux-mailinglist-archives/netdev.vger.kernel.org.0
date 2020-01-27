Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9FA14A736
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 16:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbgA0PbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 10:31:20 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38439 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729146AbgA0PbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 10:31:20 -0500
Received: by mail-ed1-f67.google.com with SMTP id p23so2411567edr.5
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 07:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NkdzLFNgJvteRYCsnmdL81NA/Tn3A5A6N+qd51vUP1I=;
        b=ekYpzpqv6LaP8dXa9yBbQNg6xCrSHAAHRNla5lDSReKV1/NCBzTRaFno9XX9Rk8R/m
         hPCXUYpty4oE5Y6oKGTGFINBJfxfMlkRPTSpZMO05cu4aD8z/sOlryY+lBU8DQBEmF3h
         ImTBHfam0lxYZlfB/5PUCYU8wsfIjY3XgxtcebOKR6VpCvdWcXuwHLKTU54SxA/64Hn9
         BUVYQgoQCP/45GD1vP5PtVE+hp3U40kijkTdCgyIXm4wOP+42MZSLh4bTVo+0GZoB3gT
         2e09xaieyx9TWAN886BAv/bh3KH6z+GjA4uxlrXG/6Z3tE0saAwcF4PjRSBmtJ7POzQq
         FNoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NkdzLFNgJvteRYCsnmdL81NA/Tn3A5A6N+qd51vUP1I=;
        b=g21WYP5wvmz9grsW6EHXfDdkk4mWy+ipskBbYVr1k7v+fB9BSjeEm6HBZ4wk5u7sL8
         vdrUDzUzQzEcpmOPLCvL8VhIVlhqjVNm+Al6y5id/CnWn5sXOfejw7dQXhMny9Kd84mV
         k404kfksd2uNOYkHOchRmgkdE4t/wzZzSTlUvnCJ2Z1VhH+YHNIv/gsp30qJPMjrMtsG
         dCA3KbRUkxybjERxr5FOotWWsPi22gPWX0vi/3xIh2/ewVoBRp9OccmJJ7a/ZcDSxpE+
         u+/drCBNlf0/MA0l/geJFKdnhBVMOW6dBpot9ny5xDvns6UUuUJnBW00KOO2PWslsDRR
         AgFg==
X-Gm-Message-State: APjAAAVnTPdX00SwdqcQDK2V7zOFJGbRQJA4QjSe8/7t+oK+ryu1lUPr
        +SPAte1I0rLSKeRO322EJ9mSOJZz655lWbz+42Q=
X-Google-Smtp-Source: APXvYqxwBAs/FV4+x4RM+c/a7iumTynIusJ0Z2N/aV6nBAgowmPvkisg7twyeSOIgibiUE0GmhAfLIZHZYvrxZwZ7Xo=
X-Received: by 2002:a17:906:af99:: with SMTP id mj25mr3711291ejb.293.1580139078511;
 Mon, 27 Jan 2020 07:31:18 -0800 (PST)
MIME-Version: 1.0
References: <1580137671-22081-1-git-send-email-madalin.bucur@oss.nxp.com> <1580137671-22081-3-git-send-email-madalin.bucur@oss.nxp.com>
In-Reply-To: <1580137671-22081-3-git-send-email-madalin.bucur@oss.nxp.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 27 Jan 2020 17:31:07 +0200
Message-ID: <CA+h21hqzR72v9=dWGk1zBptNHNst+kajh6SHHSUMp02fAq5m5g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] dpaa_eth: support all modes with rate adapting PHYs
To:     madalin.bucur@oss.nxp.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, ykaukab@suse.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Madalin,

On Mon, 27 Jan 2020 at 17:08, Madalin Bucur <madalin.bucur@oss.nxp.com> wrote:
>
> Stop removing modes that are not supported on the system interface
> when the connected PHY is capable of rate adaptation. This addresses
> an issue with the LS1046ARDB board 10G interface no longer working
> with an 1G link partner after autonegotiation support was added
> for the Aquantia PHY on board in
>
> commit 09c4c57f7bc4 ("net: phy: aquantia: add support for auto-negotiation configuration")
>
> Before this commit the values advertised by the PHY were not
> influenced by the dpaa_eth driver removal of system-side unsupported
> modes as the aqr_config_aneg() was basically a no-op. After this
> commit, the modes removed by the dpaa_eth driver were no longer
> advertised thus autonegotiation with 1G link partners failed.
>
> Reported-by: Mian Yousaf Kaukab <ykaukab@suse.de>
> Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index a301f0095223..d3eb235450e5 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -2471,9 +2471,13 @@ static int dpaa_phy_init(struct net_device *net_dev)
>                 return -ENODEV;
>         }
>
> -       /* Remove any features not supported by the controller */
> -       ethtool_convert_legacy_u32_to_link_mode(mask, mac_dev->if_support);
> -       linkmode_and(phy_dev->supported, phy_dev->supported, mask);
> +       if (mac_dev->phy_if != PHY_INTERFACE_MODE_XGMII ||
> +           !phy_dev->rate_adaptation) {
> +               /* Remove any features not supported by the controller */
> +               ethtool_convert_legacy_u32_to_link_mode(mask,
> +                                                       mac_dev->if_support);
> +               linkmode_and(phy_dev->supported, phy_dev->supported, mask);
> +       }

Is this sufficient?
I suppose this works because you have flow control enabled by default?
What would happen if the user would disable flow control with ethtool?

>
>         phy_support_asym_pause(phy_dev);
>
> --
> 2.1.0
>

Regards,
-Vladimir
