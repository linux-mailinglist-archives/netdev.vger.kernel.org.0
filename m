Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8073B2B5704
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgKQCox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:44:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59238 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbgKQCow (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 21:44:52 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1keqzC-007SPb-PQ; Tue, 17 Nov 2020 03:44:50 +0100
Date:   Tue, 17 Nov 2020 03:44:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net] enetc: Workaround for MDIO register access issue
Message-ID: <20201117024450.GH1752213@lunn.ch>
References: <20201112182608.26177-1-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112182608.26177-1-claudiu.manoil@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static inline void enetc_lock_mdio(void)
> +{
> +	read_lock(&enetc_mdio_lock);
> +}
> +

> +static inline u32 _enetc_rd_mdio_reg_wa(void __iomem *reg)
> +{
> +	unsigned long flags;
> +	u32 val;
> +
> +	write_lock_irqsave(&enetc_mdio_lock, flags);
> +	val = ioread32(reg);
> +	write_unlock_irqrestore(&enetc_mdio_lock, flags);
> +
> +	return val;
> +}

Can you mix read_lock() with write_lock_irqsave()?  Normal locks you
should not mix, so i assume read/writes also cannot be mixed?

       Andrew
