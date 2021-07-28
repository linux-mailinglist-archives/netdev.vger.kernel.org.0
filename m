Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909CC3D9602
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 21:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhG1TYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 15:24:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50576 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhG1TYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 15:24:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aFv9sT0cxR5NccK1AcZhjra4GfhXLnSG8WtLz1k6r8Y=; b=FG5CsXWVwG3OcJTtQGk+/6Q7Bq
        XQ0vLKoIDw33mNyK/W1ie+huQXXc3JLn5GqRR/SeWsisoCGwPLtJQaN4yEAQbUVDN44vX02OxJ33y
        wRPYr3onZBm8gSCpAwVUJ+7btmYy98LV1zrFl5AhORZ8JciShTyjxyW9j1bpcGoQYJrE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m8pA2-00FDy7-Om; Wed, 28 Jul 2021 21:24:10 +0200
Date:   Wed, 28 Jul 2021 21:24:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dario Alcocer <dalcocer@helixd.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
Message-ID: <YQGu2r02XdMR5Ajp@lunn.ch>
References: <YPsJnLCKVzEUV5cb@lunn.ch>
 <b5d1facd-470b-c45f-8ce7-c7df49267989@helixd.com>
 <82974be6-4ccc-3ae1-a7ad-40fd2e134805@helixd.com>
 <YPxPF2TFSDX8QNEv@lunn.ch>
 <f8ee6413-9cf5-ce07-42f3-6cc670c12824@helixd.com>
 <bcd589bd-eeb4-478c-127b-13f613fdfebc@helixd.com>
 <527bcc43-d99c-f86e-29b0-2b4773226e38@helixd.com>
 <fb7ced72-384c-9908-0a35-5f425ec52748@helixd.com>
 <YQGgvj2e7dqrHDCc@lunn.ch>
 <59790fef-bf4a-17e5-4927-5f8d8a1645f7@helixd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59790fef-bf4a-17e5-4927-5f8d8a1645f7@helixd.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 11:33:35AM -0700, Dario Alcocer wrote:
> On 7/28/21 11:23 AM, Andrew Lunn wrote:
> > On Wed, Jul 28, 2021 at 11:07:37AM -0700, Dario Alcocer wrote:
> > > It appears the port link-state issue is caused by the mv88e6xxx switch
> > > driver. The function mv88e6xxx_mac_config identifies the PHY as internal and
> > > skips the call to mv88e6xxx_port_setup_mac.
> > > 
> > > It does not make sense to me why internal PHY configuration should be
> > > skipped.
> > 
> > The switch should do the configuration itself for internal PHYs. At
> > least that works for other switches. What value does CMODE have for
> > the port? 0xf?
> > 
> >      Andrew
> > 
> 
> Is CMODE available via the DSA debugfs? Here are the registers for port0,
> which should be lan1:
> 
> root@dali:~# ls /sys/kernel/debug/dsa/switch0/
> port0/        port1/        port2/        port3/        port4/ port5/
> port6/        tag_protocol  tree
> root@dali:~# ls /sys/kernel/debug/dsa/switch0/port0/
> fdb    mdb    regs   stats  vlan
> root@dali:~# cat /sys/kernel/debug/dsa/switch0/port0/regs
>  0: 100f

It is the lower nibble of this register. So 0xf.

Take a look at:

https://github.com/lunn/mv88e6xxx_dump/blob/master/mv88e6xxx_dump.c

The 1 in 100f means it has found the PHY. But there is no link,
10/Half duplex, etc.

>  1: 0003

This at least looks sensible. Nothing is forced, normal speed
detection should be performed. So what should happen is the link
speed, duplex etc from the internal PHY should directly appear in
register 0. There is no need for software to ask the PHY and then
configure the MAC.

	  Andrew
