Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2021EFFF1
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 20:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgFESiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 14:38:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37822 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgFESiz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 14:38:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zHH2e75b+EMDPfvqjK0MkYGBOFXfpbFKWqwBx4iGH84=; b=w/YPse8ZXjEkuOlr5mpkD/fZOD
        Gh8xA2owB89CzMInPHc8JdoPrh8RBkgc8KuuRAVOMegJVq0wwtgb6auqliJ97aUR7zfSefHzqe5iw
        qYfDzL9y+amgCLSYnPKeIcXSySCdN9Mc9BSUHGqlBwFpXua4XDhwqhmp58zMpNoFnIVA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jhHEp-004F0P-CI; Fri, 05 Jun 2020 20:38:43 +0200
Date:   Fri, 5 Jun 2020 20:38:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jonathan McDowell <noodles@earth.li>,
        Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: qca8k: introduce SGMII configuration
 options
Message-ID: <20200605183843.GB1006885@lunn.ch>
References: <cover.1591380105.git.noodles@earth.li>
 <8ddd76e484e1bedd12c87ea0810826b60e004a65.1591380105.git.noodles@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ddd76e484e1bedd12c87ea0810826b60e004a65.1591380105.git.noodles@earth.li>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 05, 2020 at 07:10:58PM +0100, Jonathan McDowell wrote:
> The QCA8337(N) has an SGMII port which can operate in MAC, PHY or BASE-X
> mode depending on what it's connected to (e.g. CPU vs external PHY or
> SFP). At present the driver does no configuration of this port even if
> it is selected.
> 
> Add support for making sure the SGMII is enabled if it's in use, and
> device tree support for configuring the connection details.

Hi Jonathan

It is good to include Russell King in Cc: for patches like this.

Also, netdev is closed at the moment, so please post patches as RFC.

It sounds like the hardware has a PCS which can support SGMII or
1000BaseX. phylink will tell you what mode to configure it to. e.g. A
fibre SFP module will want 1000BaseX. A copper SFP module will want
SGMII. A switch is likely to want 1000BaseX. A PHY is likely to want
SGMII. So remove the "sgmii-mode" property and configure it as phylink
is requesting.

What exactly does sgmii-delay do?

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

I guess these are not really bits. You cannot combine
QCA8K_SGMII_MODE_CTRL_MAC and QCA8K_SGMII_MODE_CTRL_PHY. So it makes
more sense to have:

#define   QCA8K_SGMII_MODE_CTRL_BASEX			(0x0 << 22)
#define   QCA8K_SGMII_MODE_CTRL_PHY			(0x1 << 22)
#define   QCA8K_SGMII_MODE_CTRL_MAC			(0x2 << 22)

   Andrew
