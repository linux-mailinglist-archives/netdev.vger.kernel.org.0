Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2423B300A
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 15:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbhFXNgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 09:36:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53700 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229878AbhFXNgf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 09:36:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/QoD2olOKiTnq2WBqvcr2a3obQ9nSZsgcbVeh4n1M8o=; b=eZ+A88OWuWRVcJCGkjiY3qUVtT
        YZXBYa4kedsiNRipnvHUTk/z0/cuWTSN0vGoadd9CyKKQ1MhFYtOkIEnFJ9vCiz5yb3Og0NcDVqUs
        hK8JmGNRBmqZ3CdpijySE22MhseVFGWxYsI+PZCgw9Eekk01qQVH8vTVrgNBBtfXALsU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lwPUX-00AyWz-CJ; Thu, 24 Jun 2021 15:34:01 +0200
Date:   Thu, 24 Jun 2021 15:34:01 +0200
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
Message-ID: <YNSJyf5vN4YuTUGb@lunn.ch>
References: <20210622144111.19647-1-lukma@denx.de>
 <20210622144111.19647-3-lukma@denx.de>
 <YNH7vS9FgvEhz2fZ@lunn.ch>
 <20210623133704.334a84df@ktm>
 <YNOTKl7ZKk8vhcMR@lunn.ch>
 <20210624125304.36636a44@ktm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210624125304.36636a44@ktm>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I'm not sure if the imx28 switch is similar to one from TI (cpsw-3g)
> - it looks to me that the bypass mode for both seems to be very
> different. For example, on NXP when switch is disabled we need to
> handle two DMA[01]. When it is enabled, only one is used. The approach
> with two DMAs is best handled with FEC driver instantiation.

I don't know if it applies to the FEC, but switches often have
registers which control which egress port an ingress port can send
packets to. So by default, you allow CPU to port0, CPU to port1, but
block between port0 to port1. This would give you two independent
interface, the switch enabled, and using one DMA. When the bridge is
configured, you simply allow port0 and send/receive packets to/from
port1. No change to the DMA setup, etc.

> The code from [2] needs some vendor ioctl based tool (or hardcode) to
> configure the switch. 

This would not be allowed. You configure switches in Linux using the
existing user space tools. No vendor tools are used.

> > and how well future features can be added. Do you have
> > support for VLANS? Adding and removing entries to the lookup tables?
> > How will IGMP snooping work? How will STP work?
> 
> This can be easily added with serving netstack hooks (as it is already
> done with cpsw_new) in the new switchdev based version [3] (based on
> v5.12).

Here i'm less convinced. I expect a fully functioning switch driver is
going to need switch specific versions of some of the netdev ops
functions, maybe the ethtool ops as well. It is going to want to add
devlink ops. By hacking around with the FEC driver in the way you are,
you might get very basic switch operation working. But as we have seen
with cpsw, going from very basic to a fully functioning switchdev
driver required a new driver, cpsw_new. It was getting more and more
difficult to add features because its structure was just wrong. We
don't want to add code to the kernel which is probably a dead end.

      Andrew
