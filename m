Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A581BBFA4
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 15:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgD1Nev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 09:34:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56984 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbgD1Neu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 09:34:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PAd6TNSkrAbP3kJmPuAA9PC+MMybdzDOwMSeL3Gd5jg=; b=EUOrich7SCQ+mTCc8uW0O/5xgG
        0cpnSs5OQHgf811nyv9w7SU0AnGkw+FGWEDCxzcsDtZBSxPLmolq49jNr5qZXxl4n1fMcIQ0SN8dF
        ANes/IhpPXRTpBleYBM7GQ2pfM2huNiinv8+CUv5Kfnh8D06imKb3la9Pfi85sbw7ng8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTQNp-0005i5-Qq; Tue, 28 Apr 2020 15:34:45 +0200
Date:   Tue, 28 Apr 2020 15:34:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     Leonard Crestez <leonard.crestez@nxp.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>,
        dl-linux-imx <linux-imx@nxp.com>, Chris Healy <cphealy@gmail.com>
Subject: Re: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Message-ID: <20200428133445.GA21352@lunn.ch>
References: <20200414004551.607503-1-andrew@lunn.ch>
 <VI1PR04MB6941D611F6EF67BB42826D4EEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
 <20200427164620.GD1250287@lunn.ch>
 <VI1PR04MB6941C603529307039AF7F4ABEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
 <20200427201339.GJ1250287@lunn.ch>
 <HE1PR0402MB2745B6388B6BF7306629A305FFAC0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HE1PR0402MB2745B6388B6BF7306629A305FFAC0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Andrew, after investigate the issue, there have one MII event coming later then
> clearing MII pending event when writing MSCR register (MII_SPEED).
> 
> Check the rtl design by co-working with our IC designer, the MII event generation
> condition:
> - writing MSCR:
> 	- mmfr[31:0]_not_zero & mscr[7:0]_is_zero & mscr_reg_data_in[7:0] != 0
> - writing MMFR:
> 	- mscr[7:0]_not_zero
> 	
> mmfr[31:0]: current MMFR register value
> mscr[7:0]: current MSCR register value
> mscr_reg_data_in[7:0]: the value wrote to MSCR
> 
> 
> Below patch can fix the block issue:
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -2142,6 +2142,15 @@ static int fec_enet_mii_init(struct platform_device *pdev)
>         if (suppress_preamble)
>                 fep->phy_speed |= BIT(7);
> 
> +       /*
> +        * Clear MMFR to avoid to generate MII event by writing MSCR.
> +        * MII event generation condition:
> +        * - writing MSCR:
> +        *      - mmfr[31:0]_not_zero & mscr[7:0]_is_zero & mscr_reg_data_in[7:0] != 0
> +        * - writing MMFR:
> +        *      - mscr[7:0]_not_zero
> +        */
> +       writel(0, fep->hwp + FEC_MII_DATA);
>         writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);

Hi Andy

Thanks for digging into the internal of the FEC. Just to make sure i
understand this correctly:

In fec_enet_mii_init() we have:

        holdtime = DIV_ROUND_UP(clk_get_rate(fep->clk_ipg), 100000000) - 1;

        fep->phy_speed = mii_speed << 1 | holdtime << 8;

        writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);

        /* Clear any pending transaction complete indication */
        writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);

You are saying this write to the FEC_MII_SPEED register can on some
SoCs trigger an FEC_ENET_MII event. And because it does not happen
immediately, it happens after the clear which is performed here?
Sometime later we then go into fec_enet_mdio_wait(), the event is
still pending, so we read the FEC_MII_DATA register too early?

But this does not fully explain the problem. This should only affect
the first MDIO transaction, because as we exit fec_enet_mdio_wait()
the event is cleared. But Leonard reported that all reads return 0,
not just the first.

    Andrew

