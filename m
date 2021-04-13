Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE1D35DC0F
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 12:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhDMKBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 06:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhDMKBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 06:01:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47AFC061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 03:00:50 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <l.stach@pengutronix.de>)
        id 1lWFqh-00049D-7p; Tue, 13 Apr 2021 12:00:47 +0200
Message-ID: <c03053f59a89ef6ea4a4f2ce15aee4b4f4892745.camel@pengutronix.de>
Subject: Re: [PATCH v2 0/7] remove different PHY fixups
From:   Lucas Stach <l.stach@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Philippe Schenker <philippe.schenker@toradex.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, linux-imx@nxp.com,
        kernel@pengutronix.de, David Jander <david@protonic.nl>,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Date:   Tue, 13 Apr 2021 12:00:45 +0200
In-Reply-To: <20210309112615.625-1-o.rempel@pengutronix.de>
References: <20210309112615.625-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Am Dienstag, dem 09.03.2021 um 12:26 +0100 schrieb Oleksij Rempel:
> changes v2:
> - rebase against latest kernel
> - fix networking on RIoTBoard
> 
> This patch series tries to remove most of the imx6 and imx7 board
> specific PHY configuration via fixup, as this breaks the PHYs when
> connected to switch chips or USB Ethernet MACs.
> 
> Each patch has the possibility to break boards, but contains a
> recommendation to fix the problem in a more portable and future-proof
> way.

I agree with the opinion that those PHY fixups introduce more harm than
good. Essentially they are pushing board specific configuration values
into the PHY, without any checks that the fixup is even running on the
specific board it was targeted at.

While there is a real chance to break some out of tree boards or
incomplete configs I think that's something we can accept here. If
someone makes a case why they can absolutely not fixup their DT or
kernel config we could even bring back some of those fixups with a
proper board compatible check to avoid mashing things up for other
boards with the same PHY. I guess the only realistic way to learn if
someone can make such a case is to apply this series and look for any
fallout.

So for what it is worth:
Acked-by: Lucas Stach <l.stach@pengutronix.de>

> regards,
> Oleksij
> 
> Oleksij Rempel (7):
>   ARM: imx6q: remove PHY fixup for KSZ9031
>   ARM: imx6q: remove TX clock delay of ar8031_phy_fixup()
>   ARM: imx6q: remove hand crafted PHY power up in ar8035_phy_fixup()
>   ARM: imx6q: remove clk-out fixup for the Atheros AR8031 and AR8035
>     PHYs
>   ARM: imx6q: remove Atheros AR8035 SmartEEE fixup
>   ARM: imx6sx: remove Atheros AR8031 PHY fixup
>   ARM: imx7d: remove Atheros AR8031 PHY fixup
> 
>  arch/arm/boot/dts/imx6dl-riotboard.dts  |  2 +
>  arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts |  2 +-
>  arch/arm/mach-imx/mach-imx6q.c          | 85 -------------------------
>  arch/arm/mach-imx/mach-imx6sx.c         | 26 --------
>  arch/arm/mach-imx/mach-imx7d.c          | 22 -------
>  5 files changed, 3 insertions(+), 134 deletions(-)
> 


