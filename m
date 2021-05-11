Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036AB37A70F
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 14:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbhEKMvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 08:51:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35070 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230494AbhEKMvF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 08:51:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Nk2QATE/YAGmpaluCxZLB2CwY3T6g4W15h0LkcfarMQ=; b=rKrr/2Vg6EBMa0RhcSkP28/Wwv
        VI7/lbvFjIxMvbqbCwz+kiiBFJy0AmyrMsywKjBOA2CKKhFeknZZFYkIVTRF92W/LVVCwDOuKfy3s
        Egzw8mdCJNOuZIssw5sdFozzSBBdvnYw9q5Xt3RwMW0o+ISyRzOMpRc6Bgua1aMACXVg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgRpk-003kBS-5O; Tue, 11 May 2021 14:49:56 +0200
Date:   Tue, 11 May 2021 14:49:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH v3 1/7] ARM i.MX6q: remove PHY fixup for KSZ9031
Message-ID: <YJp9dCpPWq9wxhhB@lunn.ch>
References: <20210511043735.30557-1-o.rempel@pengutronix.de>
 <20210511043735.30557-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511043735.30557-2-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 06:37:29AM +0200, Oleksij Rempel wrote:
> Starting with:
> 
>     bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for the KSZ9031 PHY")
> 
> the micrel phy driver started respecting phy-mode for the KSZ9031 PHY.
> At least with kernel v5.8 configuration provided by this fixup was
> overwritten by the micrel driver.
> 
> This fixup was providing following configuration:
> 
> RX path: 2.58ns delay
>     rx -0.42 (left shift) + rx_clk  +0.96ns (right shift) =
>         1,38 + 1,2 internal RX delay = 2.58ns
> TX path: 0.96ns delay
>     tx (no delay) + tx_clk 0.96ns (right shift) = 0.96ns
> 
> This configuration is outside of the recommended RGMII clock skew delays
> and about in the middle of: rgmii-idrx and rgmii-id
> 
> Since most embedded systems do not have enough place to introduce
> significant clock skew, rgmii-id is the way to go.
> 
> In case this patch breaks network functionality on your system, build
> kernel with enabled MICREL_PHY. If it is still not working then try
> following device tree options:
> 1. Set (or change) phy-mode in DT to:
>    phy-mode = "rgmii-id";
>    This actives internal delay for both RX and TX.
> 1. Set (or change) phy-mode in DT to:
>    phy-mode = "rgmii-idrx";
>    This actives internal delay for RX only.
> 3. Use following DT properties:
>    phy-mode = "rgmii";
>    txen-skew-psec = <0>;
>    rxdv-skew-psec = <0>;
>    rxd0-skew-psec = <0>;
>    rxd1-skew-psec = <0>;
>    rxd2-skew-psec = <0>;
>    rxd3-skew-psec = <0>;
>    rxc-skew-psec = <1860>;
>    txc-skew-psec = <1860>;
>    This activates the internal delays for RX and TX, with the value as
>    the fixup that is removed in this patch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
