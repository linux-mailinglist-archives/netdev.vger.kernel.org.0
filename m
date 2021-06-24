Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA0B3B339D
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhFXQOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:14:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54050 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhFXQOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 12:14:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2zpxTskXtsSrCKrJdGxNHyEuYUkfYqVGKXrVSQNH2cg=; b=pCQpVOtxgMgXa5fmttOeaZCDS2
        eGEAjIw+HJKlpBXv/y99EkzIEDk4LGG/2LWIobnETdlypWtlDiUJUMK2saxMzDiKGUZreG1Xyl3tP
        Uyl81+u4qfj7XRxtu4TROreTRUb9p300x+w1Bd8UAXvj6C+7FgtTu7hlWUgMB71VSNas=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lwRx6-00Azym-DF; Thu, 24 Jun 2021 18:11:40 +0200
Date:   Thu, 24 Jun 2021 18:11:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] net: Provide switchdev driver for NXP's More Than IP
 L2 switch
Message-ID: <YNSuvJsD0HSSshOJ@lunn.ch>
References: <20210622144111.19647-1-lukma@denx.de>
 <20210622144111.19647-3-lukma@denx.de>
 <YNH7vS9FgvEhz2fZ@lunn.ch>
 <20210623133704.334a84df@ktm>
 <YNOTKl7ZKk8vhcMR@lunn.ch>
 <20210624125304.36636a44@ktm>
 <YNSJyf5vN4YuTUGb@lunn.ch>
 <20210624163542.5b6d87ee@ktm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210624163542.5b6d87ee@ktm>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 04:35:42PM +0200, Lukasz Majewski wrote:
> Hi Andrew,
> 
> > > I'm not sure if the imx28 switch is similar to one from TI (cpsw-3g)
> > > - it looks to me that the bypass mode for both seems to be very
> > > different. For example, on NXP when switch is disabled we need to
> > > handle two DMA[01]. When it is enabled, only one is used. The
> > > approach with two DMAs is best handled with FEC driver
> > > instantiation.  
> > 
> > I don't know if it applies to the FEC, but switches often have
> > registers which control which egress port an ingress port can send
> > packets to. So by default, you allow CPU to port0, CPU to port1, but
> > block between port0 to port1. This would give you two independent
> > interface, the switch enabled, and using one DMA. When the bridge is
> > configured, you simply allow port0 and send/receive packets to/from
> > port1. No change to the DMA setup, etc.
> 
> Please correct me if I misunderstood this concept - but it seems like
> you refer to the use case where the switch is enabled, and by changing
> it's "allowed internal port's" mapping it decides if frames are passed
> between engress ports (port1 and port2).

Correct.


> 	----------
> DMA0 ->	|P0    P1| -> ENET-MAC (PHY control) -> eth0 (lan1)
> 	|L2 SW	 |
> 	|      P2| -> ENET-MAC (PHY control) -> eth1 (lan2)
> 	----------
> 
> DMA1 (not used)
> 
> We can use this approach when we keep always enabled L2 switch.
> 
> However now in FEC we use the "bypass" mode, where:
> DMA0 -> ENET-MAC (FEC instance driver 1) -> eth0
> DMA1 -> ENET-MAC (FEC instance driver 2) -> eth1
> 
> And the "bypass" mode is the default one.

Which is not a problem, when you refactor the FEC into a library and a
driver, plus add a new switch driver. When the FEC loads, it uses
bypass mode, the switch disabled. When the new switch driver loads, it
always enables the switch, but disables communication between the two
ports until they both join the same bridge.

But i doubt we are actually getting anywhere. You say you don't have
time to write a new driver. I'm not convinced you can hack the FEC
like you are suggesting and not end up in the mess the cpsw had,
before they wrote a new driver.

       Andrew
