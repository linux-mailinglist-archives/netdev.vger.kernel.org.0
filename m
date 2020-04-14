Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87791A7202
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 05:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404938AbgDNDt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 23:49:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35426 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404915AbgDNDtZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 23:49:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PRv5zwlgZDStOuCBTzTr0abei5OX8fL8VwQbStTj/9g=; b=TqaLbLqTZpT3yZNyllQUkcIIKv
        ciYtCg/c4BAw+n87zZD6k/Uzc4GdzSzIHgg7whMXL3eRgIU35MegnBXmswnTIggitnwLOShN4A22h
        +RZRGWUg1euompD6Mq4oAyHvYAkg3e5Kb7gqcRV6LgxY59w03hDTYuJ4HkZTf9vTQIrQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jOCZc-002ZYT-9r; Tue, 14 Apr 2020 05:49:20 +0200
Date:   Tue, 14 Apr 2020 05:49:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>,
        Chris Heally <cphealy@gmail.com>
Subject: Re: [EXT] [PATCH] net: ethernet: fec: Replace interrupt driven MDIO
 with polled IO
Message-ID: <20200414034920.GA611399@lunn.ch>
References: <20200414004551.607503-1-andrew@lunn.ch>
 <VI1PR0402MB3600B82EE105E43BD20E2190FFDA0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3600B82EE105E43BD20E2190FFDA0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 03:07:09AM +0000, Andy Duan wrote:
> From: Andrew Lunn <andrew@lunn.ch> Sent: Tuesday, April 14, 2020 8:46 AM
> > Measurements of the MDIO bus have shown that driving the MDIO bus using
> > interrupts is slow. Back to back MDIO transactions take about 90uS, with
> > 25uS spent performing the transaction, and the remainder of the time the bus
> > is idle.
> > 
> > Replacing the completion interrupt with polled IO results in back to back
> > transactions of 40uS. The polling loop waiting for the hardware to complete
> > the transaction takes around 27uS. Which suggests interrupt handling has an
> > overhead of 50uS, and polled IO nearly halves this overhead, and doubles the
> > MDIO performance.
> > 
> 
> Although the mdio performance is better, but polling IO by reading register
> cause system/bus loading more heavy.

Hi Andy

I actually think is reduces the system bus load. With interrupts we
have 27uS waiting for the interrupt when the bus is idle, followed by
63uS the CPU is busy handling the interrupt and setting up the next
transfer, which will case the bus to be loaded. So the system bus is
busy for 63uS per transaction. With polled IO, yes the system bus is
busy for 27uS polling while the transaction happens, and then another
13uS setting up the next transaction. But in total, that is only 40uS.

So with interrupts we have 63uS of load per transaction, vs 40uS of
load per transaction for polled IO. Polled IO is better for the bus.

I also have follow up patches which allows the bus to be run at higher
speeds. The Ethernet switch i have on the bus is happy to run a 5MHz
rather than the default 2.5MHz. That reduces the transaction time by a
1/2. The switch will also work without the MDIO preamble, again
reducing the size of the MDIO transaction by 1/2. Combining all these,
interrupt handling becomes very expensive. You do not want to be doing
interrupts every 7uS.

     Andrew
