Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D751D30D6
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 15:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgENNPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 09:15:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60190 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbgENNPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 09:15:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=C4XSn2ABMWjBZ9aqxDsYGwYODrXuuIHG89AOkv3xl4Y=; b=KOdAMOc58/q+MbDJUgq/sZ4irw
        oEVJEgY+yla7stTfq+//jkrJnfz4iSQUJyKkhA0KCAq4710SdbaldV3IfAvRz1Fu7e3R8WiEQQyyv
        NXp/pDx6z1L9iTAjfr8I8+QqiQ+WnqSvDNdEoAUl5MgTO96J4ValFHkMUqLxZUKrCTvQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZDhv-002Hua-7i; Thu, 14 May 2020 15:15:27 +0200
Date:   Thu, 14 May 2020 15:15:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V5 18/19] net: ks8851: Implement Parallel bus operations
Message-ID: <20200514131527.GN527401@lunn.ch>
References: <20200514000747.159320-1-marex@denx.de>
 <20200514000747.159320-19-marex@denx.de>
 <20200514015753.GL527401@lunn.ch>
 <5dbab44d-de45-f8e2-b4e4-4be15408657e@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dbab44d-de45-f8e2-b4e4-4be15408657e@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 04:26:30AM +0200, Marek Vasut wrote:
> On 5/14/20 3:57 AM, Andrew Lunn wrote:
> >> diff --git a/drivers/net/ethernet/micrel/ks8851_par.c b/drivers/net/ethernet/micrel/ks8851_par.c
> >> new file mode 100644
> >> index 000000000000..90fffacb1695
> >> --- /dev/null
> >> +++ b/drivers/net/ethernet/micrel/ks8851_par.c
> >> @@ -0,0 +1,348 @@
> >> +// SPDX-License-Identifier: GPL-2.0-only
> >> +/* drivers/net/ethernet/micrel/ks8851.c
> >> + *
> >> + * Copyright 2009 Simtec Electronics
> >> + *	http://www.simtec.co.uk/
> >> + *	Ben Dooks <ben@simtec.co.uk>
> >> + */
> >> +
> >> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >> +
> >> +#define DEBUG
> > 
> > I don't think you wanted that left in.
> 
> This actually was in the original ks8851.c since forever, so I wonder.
> Maybe a separate patch would be better ?

Yes, please add another patch.

> >> +		ks8851_done_tx(ks, skb);
> >> +	} else {
> >> +		ret = NETDEV_TX_BUSY;
> >> +	}
> >> +
> >> +	ks8851_unlock_par(ks, &flags);
> >> +
> >> +	return ret;
> >> +}
> > 
> >> +module_param_named(message, msg_enable, int, 0);
> >> +MODULE_PARM_DESC(message, "Message verbosity level (0=none, 31=all)");
> > 
> > Module parameters are bad. A new driver should not have one, if
> > possible. Please implement the ethtool .get_msglevel and .set_msglevel
> > instead.
> 
> This was in the original ks8851.c , so I need to retain it , no ?

Ah. Err.

This patch looks like a new driver. It has probe, remove
module_platform_driver(), etc. So as a new driver, it should not have
module parameters.

But then your next patch removes the mll driver. Your intention is
that this driver replaces the mll driver. So for backwards
compatibility, yes you do need the module parameter.

	Andrew
