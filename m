Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E0E203916
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 16:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgFVOZp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 22 Jun 2020 10:25:45 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:49675 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728070AbgFVOZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 10:25:45 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 036B21BF20D;
        Mon, 22 Jun 2020 14:25:41 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <964739eb70dcd58153d8548f7b57719b@0leil.net>
References: <20200619122300.2510533-1-antoine.tenart@bootlin.com> <20200619122300.2510533-5-antoine.tenart@bootlin.com> <964739eb70dcd58153d8548f7b57719b@0leil.net>
Subject: Re: [PATCH net-next v3 4/8] net: phy: mscc: take into account the 1588 block in MACsec init
To:     Quentin Schulz <foss@0leil.net>
From:   Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com
Message-ID: <159283594086.1456598.17039454007067615022@kwain>
Date:   Mon, 22 Jun 2020 16:25:41 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Quentin,

Quoting Quentin Schulz (2020-06-21 17:38:42)
> On 2020-06-19 14:22, Antoine Tenart wrote:
> > This patch takes in account the use of the 1588 block in the MACsec
> > initialization, as a conditional configuration has to be done (when the
> > 1588 block is used).
> > 
> > Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
> > ---
> >  drivers/net/phy/mscc/mscc_macsec.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/phy/mscc/mscc_macsec.c
> > b/drivers/net/phy/mscc/mscc_macsec.c
> > index c0eeb62cb940..713c62b1d1f0 100644
> > --- a/drivers/net/phy/mscc/mscc_macsec.c
> > +++ b/drivers/net/phy/mscc/mscc_macsec.c
> > @@ -285,7 +285,9 @@ static void vsc8584_macsec_mac_init(struct
> > phy_device *phydev,
> >                                MSCC_MAC_CFG_PKTINF_CFG_STRIP_PREAMBLE_ENA |
> >                                MSCC_MAC_CFG_PKTINF_CFG_INSERT_PREAMBLE_ENA |
> >                                (bank == HOST_MAC ?
> > -                               MSCC_MAC_CFG_PKTINF_CFG_ENABLE_TX_PADDING : 0));
> > +                               MSCC_MAC_CFG_PKTINF_CFG_ENABLE_TX_PADDING : 0) |
> > +                              (IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING) ?
> > +                               MSCC_MAC_CFG_PKTINF_CFG_MACSEC_BYPASS_NUM_PTP_STALL_CLKS(0x8) : 
> > 0));
> 
> Do we have more info on this 0x8? Where does it come from? What does it 
> mean?

I unfortunately do not have more information about this.

> Also this starts to get a little bit hard to read. Would it make sense 
> to have
> two temp variables? e.g.:
> 
>         padding = bank == HOST_MAC ? MSCC_MAC_CFG_PKTINF_CFG_ENABLE_TX_PADDING 
> : 0;
>         ptp_stall_clks = IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING) ?
>                 MSCC_MAC_CFG_PKTINF_CFG_MACSEC_BYPASS_NUM_PTP_STALL_CLKS(0x8) : 0;
> 
>         vsc8584_macsec_phy_write(phydev, bank, MSCC_MAC_CFG_PKTINF_CFG,
>                                  MSCC_MAC_CFG_PKTINF_CFG_STRIP_FCS_ENA |
>                                  MSCC_MAC_CFG_PKTINF_CFG_INSERT_FCS_ENA |
>                                  MSCC_MAC_CFG_PKTINF_CFG_LPI_RELAY_ENA |
>                                  MSCC_MAC_CFG_PKTINF_CFG_STRIP_PREAMBLE_ENA |
>                                  MSCC_MAC_CFG_PKTINF_CFG_INSERT_PREAMBLE_ENA |
>                                  padding |
>                                  ptp_stall_clks);

I'm not convinced this would be better. I guess that is a question of
personal preference; I don't really mind either solution.  I'll keep it
as-is for now, as it follows what was already done.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
