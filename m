Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03EFD2B7E6D
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 14:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgKRNjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 08:39:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35034 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgKRNjA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 08:39:00 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfNfk-007jTk-EF; Wed, 18 Nov 2020 14:38:56 +0100
Date:   Wed, 18 Nov 2020 14:38:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net] enetc: Workaround for MDIO register access issue
Message-ID: <20201118133856.GC1804098@lunn.ch>
References: <20201112182608.26177-1-claudiu.manoil@nxp.com>
 <20201117024450.GH1752213@lunn.ch>
 <AM0PR04MB6754D77454B6DA79FB59917896E20@AM0PR04MB6754.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB6754D77454B6DA79FB59917896E20@AM0PR04MB6754.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 10:22:20AM +0000, Claudiu Manoil wrote:
> >-----Original Message-----
> >From: Andrew Lunn <andrew@lunn.ch>
> >Sent: Tuesday, November 17, 2020 4:45 AM
> >To: Claudiu Manoil <claudiu.manoil@nxp.com>
> >Cc: netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>; David S .
> >Miller <davem@davemloft.net>; Alexandru Marginean
> ><alexandru.marginean@nxp.com>; Vladimir Oltean
> ><vladimir.oltean@nxp.com>
> >Subject: Re: [PATCH net] enetc: Workaround for MDIO register access issue
> >
> >> +static inline void enetc_lock_mdio(void)
> >> +{
> >> +	read_lock(&enetc_mdio_lock);
> >> +}
> >> +
> >
> >> +static inline u32 _enetc_rd_mdio_reg_wa(void __iomem *reg)
> >> +{
> >> +	unsigned long flags;
> >> +	u32 val;
> >> +
> >> +	write_lock_irqsave(&enetc_mdio_lock, flags);
> >> +	val = ioread32(reg);
> >> +	write_unlock_irqrestore(&enetc_mdio_lock, flags);
> >> +
> >> +	return val;
> >> +}
> >
> >Can you mix read_lock() with write_lock_irqsave()?  Normal locks you
> >should not mix, so i assume read/writes also cannot be mixed?
> >
> 
> Not sure I understand your concerns, but this is the readers-writers locking
> scheme. The readers (read_lock) are "lightweight", they get the most calls,
> can be taken from any context including interrupt context, and compete only
> with the writers (write_lock). The writers can take the lock only when there are
> no readers holding it, and the writer must insure that it doesn't get preempted
> (by interrupts etc.) when holding the lock (irqsave). The good part is that mdio
> operations are not frequent. Also, we had this code out of the tree for quite some
> time, it's well exercised.

Hi CLaidiu

Thanks for the explanation. I don't think i've every reviewed a driver
using read/write locks like this. But thinking it through, it does
seem O.K.

     Andrew
