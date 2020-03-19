Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CECBD18BC3B
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgCSQRV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Mar 2020 12:17:21 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:43675 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727700AbgCSQRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:17:20 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 0E4F81BF20C;
        Thu, 19 Mar 2020 16:17:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200319160505.GE27807@lunn.ch>
References: <20200319141958.383626-1-antoine.tenart@bootlin.com> <20200319141958.383626-3-antoine.tenart@bootlin.com> <20200319160505.GE27807@lunn.ch>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Antoine Tenart <antoine.tenart@bootlin.com>
Subject: Re: [PATCH net-next v3 2/2] net: phy: mscc: RGMII skew delay configuration
To:     Andrew Lunn <andrew@lunn.ch>
Message-ID: <158463463741.3149.13095217659080007040@kwain>
Date:   Thu, 19 Mar 2020 17:17:17 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Quoting Andrew Lunn (2020-03-19 17:05:05)
> On Thu, Mar 19, 2020 at 03:19:58PM +0100, Antoine Tenart wrote:
> > This patch adds support for configuring the RGMII skew delays in Rx and
> > Tx. The Rx and Tx skews are set based on the interface mode. By default
> > their configuration is set to the default value in hardware (0.2ns);
> > this means the driver do not rely anymore on the bootloader
> > configuration.
> > 
> > Then based on the interface mode being used, a 2ns delay is added:
> > - RGMII_ID adds it for both Rx and Tx.
> > - RGMII_RXID adds it for Rx.
> > - RGMII_TXID adds it for Tx.
> > 
> > Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
> > ---
> >  drivers/net/phy/mscc/mscc.h      | 14 ++++++++++++++
> >  drivers/net/phy/mscc/mscc_main.c | 29 +++++++++++++++++++++++++++++
> >  2 files changed, 43 insertions(+)
> > 
> > diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
> > index d1b8bbe8acca..25729302714c 100644
> > --- a/drivers/net/phy/mscc/mscc.h
> > +++ b/drivers/net/phy/mscc/mscc.h
> > @@ -161,6 +161,20 @@ enum rgmii_rx_clock_delay {
> >  /* Extended Page 2 Registers */
> >  #define MSCC_PHY_CU_PMD_TX_CNTL                16
> >  
> > +#define MSCC_PHY_RGMII_SETTINGS                18
> > +#define RGMII_SKEW_RX_POS              1
> > +#define RGMII_SKEW_TX_POS              4
> > +
> > +/* RGMII skew values, in ns */
> > +#define VSC8584_RGMII_SKEW_0_2                 0
> > +#define VSC8584_RGMII_SKEW_0_8                 1
> > +#define VSC8584_RGMII_SKEW_1_1                 2
> > +#define VSC8584_RGMII_SKEW_1_7                 3
> > +#define VSC8584_RGMII_SKEW_2_0                 4
> > +#define VSC8584_RGMII_SKEW_2_3                 5
> > +#define VSC8584_RGMII_SKEW_2_6                 6
> > +#define VSC8584_RGMII_SKEW_3_4                 7
> 
>   
> > +static void vsc8584_rgmii_set_skews(struct phy_device *phydev)
> > +{
> > +     u32 skew_rx, skew_tx;
> > +
> > +     /* We first set the Rx and Tx skews to their default value in h/w
> > +      * (0.2 ns).
> > +      */
> > +     skew_rx = VSC8584_RGMII_SKEW_0_2;
> > +     skew_tx = VSC8584_RGMII_SKEW_0_2;
> 
> Does this mean it is impossible to have a skew of 0ns?

It seems to be the case, the lowest value this register accepts is 0,
which means a 0.2ns delay, according to the datasheet. And I'm not
seeing any register disabling this when RGMII is used.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
