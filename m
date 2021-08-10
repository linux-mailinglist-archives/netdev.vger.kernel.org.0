Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2513E5E0B
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 16:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240276AbhHJOdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 10:33:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42928 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240212AbhHJOdb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 10:33:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3FxL/4S4YmrQ+IWKQjnrpQVFunMNvpe9IajSsBJ9+jM=; b=xmpRAlZqaHdbLxX7ChgXsuhmse
        zrIYeTvO9v6JolQjUytMTEX+UmMI1Jedhxl2nz6zjt2z1DCEGQM1xkwSCJLQGieLeZVKpE5t418DV
        rVVBRsXnuhng9//M+3v6h7BEvl9Z6nrPeln1nAmwSV5ENgjSD7gv4a43zGbzLqTAyfVM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDSoM-00Gv7f-0A; Tue, 10 Aug 2021 16:32:58 +0200
Date:   Tue, 10 Aug 2021 16:32:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: fsl, fec: add "fsl,
 wakeup-irq" property
Message-ID: <YRKOGYwx1uVdsKoF@lunn.ch>
References: <20210805074615.29096-1-qiangqing.zhang@nxp.com>
 <20210805074615.29096-2-qiangqing.zhang@nxp.com>
 <2e1a14bf-2fa8-ed39-d133-807c4e14859c@gmail.com>
 <DB8PR04MB67950F6863A8FEE6745CBC68E6F69@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <498f3cee-8f37-2ab1-93c4-5472572ecc37@gmail.com>
 <DB8PR04MB6795DC35D0387637052E64A1E6F79@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6795DC35D0387637052E64A1E6F79@DB8PR04MB6795.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > 1) FEC controller has up to 4 interrupt lines and all of these are routed to GIC
> > interrupt controller.
> > > 2) FEC has a wakeup interrupt signal and always are mixed with other
> > interrupt signals, and then output to one interrupt line.
> > > 3) For legacy SoCs, wakeup interrupt are mixed to int0 line, but for i.MX8M
> > serials, are mixed to int2 line.

So you need to know which of the interrupts listed is the wake up
interrupt.

I can see a few ways to do this:

The FEC driver already has quirks. Add a quirk to fec_imx8mq_info and
fec_imx8qm_info to indicate these should use int2.

or

Documentation/devicetree/bindings/interrupt-controller/interrupts.txt 

  b) two cells
  ------------
  The #interrupt-cells property is set to 2 and the first cell defines the
  index of the interrupt within the controller, while the second cell is used
  to specify any of the following flags:
    - bits[3:0] trigger type and level flags
        1 = low-to-high edge triggered
        2 = high-to-low edge triggered
        4 = active high level-sensitive
        8 = active low level-sensitive

You could add

       18 = wakeup source

and extend to core to either do all the work for you, or tell you this
interrupt is flagged as being a wakeup source. This solution has the
advantage of it should be usable in other drivers.

	  Andrew
