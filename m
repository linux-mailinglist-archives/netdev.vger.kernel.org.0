Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566ED1AF601
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 02:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgDSAfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 20:35:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47324 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbgDSAfI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 20:35:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zJk5ZNxWAF8NZypDghNXSxmU6TnWhH8GjElwssejEoc=; b=4ZgjXG6ZwVpfc7K+fZLNj/QobN
        JdczcXhbNeaPvj2mChFqeYrKf2ufH2V5PghWZiuxOw9mrgEJaXBzcEpdCr8qaKGLV4CO2XAG9oIuS
        IppBe37h23aw71NModehYqmPHAB4LSNrAy6Ym/Q3vfVhOk1oagCDKtPEktbQxpQPfNms=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPxvJ-003Xud-8N; Sun, 19 Apr 2020 02:35:01 +0200
Date:   Sun, 19 Apr 2020 02:35:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Healy <cphealy@gmail.com>
Cc:     Andy Duan <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [EXT] [PATCH net-next v2 1/3] net: ethernet: fec: Replace
 interrupt driven MDIO with polled IO
Message-ID: <20200419003501.GE836632@lunn.ch>
References: <20200418000355.804617-1-andrew@lunn.ch>
 <20200418000355.804617-2-andrew@lunn.ch>
 <HE1PR0402MB27450B207DFFB1B86DCF287DFFD60@HE1PR0402MB2745.eurprd04.prod.outlook.com>
 <CAFXsbZpVSiMYpUaOR=+UEGBgx5kSTzGcftbPe=PPkj_xWhy=bA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFXsbZpVSiMYpUaOR=+UEGBgx5kSTzGcftbPe=PPkj_xWhy=bA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 03:39:17PM -0700, Chris Healy wrote:
> I did some profiling using an oscilloscope with my NXP Vybrid based
> platform to see what different "sleep_us" values resulted in for start
> of MDIO to start of MDIO transaction times.  Here's what I found:
> 
> 0  - ~38us to ~40us
> 1  - ~48us to ~64us
> 2  - ~48us to ~64us
> 3  - ~48us to ~64us
> 4  - ~48us to ~64us
> 4  - ~48us to ~64us
> 5  - ~48us to ~64us
> 6  - ~48us to ~64us
> 7  - ~48us to ~64us
> 8  - ~48us to ~64us
> 9  - ~56us to ~88us
> 10 - ~56us to ~112us
> 
> Basically, with the "sleep_us" value set to 0, I would get the
> shortest inter transaction times with a very low variance.  Once I
> went to a non-zero value, the inter transaction time went up, as well
> as the variance, which I suppose makes sense....

Thanks for these numbers. They are suggesting that udelay() is quite
expensive, and is probably taking longer than we expect. I might
instrument the function to see what is happening.

	   Andrew
