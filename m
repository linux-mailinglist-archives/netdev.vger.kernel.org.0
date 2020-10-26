Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40BDA29969D
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 20:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1792710AbgJZTOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 15:14:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45450 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1792694AbgJZTOK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 15:14:10 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kX7wO-003exb-HC; Mon, 26 Oct 2020 20:14:00 +0100
Date:   Mon, 26 Oct 2020 20:14:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xu Yilun <yilun.xu@intel.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, mdf@kernel.org,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        linux-fpga@vger.kernel.org, netdev@vger.kernel.org,
        trix@redhat.com, lgoncalv@redhat.com, hao.wu@intel.com
Subject: Re: [RFC PATCH 1/6] docs: networking: add the document for DFL Ether
 Group driver
Message-ID: <20201026191400.GO752111@lunn.ch>
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
 <1603442745-13085-2-git-send-email-yilun.xu@intel.com>
 <20201023153731.GC718124@lunn.ch>
 <20201026085246.GC25281@yilunxu-OptiPlex-7050>
 <20201026130001.GC836546@lunn.ch>
 <20201026173803.GA10743@yilunxu-OptiPlex-7050>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026173803.GA10743@yilunxu-OptiPlex-7050>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > Do you really mean PHY? I actually expect it is PCS? 
> > > 
> > > For this implementation, yes.
> > 
> > Yes, you have a PHY? Or Yes, it is PCS?
> 
> Sorry, I mean I have a PHY.
> 
> > 
> > To me, the phylib maintainer, having a PHY means you have a base-T
> > interface, 25Gbase-T, 40Gbase-T?  That would be an odd and expensive
> > architecture when you should be able to just connect SERDES interfaces
> > together.

You really have 25Gbase-T, 40Gbase-T? Between the FPGA & XL710?
What copper PHYs are using? 

> I see your concerns about the SERDES interface between FPGA & XL710.

I have no concerns about direct SERDES connections. That is the normal
way of doing this. It keeps it a lot simpler, since you don't have to
worry about driving the PHYs.

> I did some investigation about the DSA, and actually I wrote a
> experimental DSA driver. It works and almost meets my need, I can make
> configuration, run pktgen on slave inf.

Cool. As i said, I don't know if this actually needs to be a DSA
driver. It might just need to borrow some ideas from DSA.

> Mm.. seems the hardware should be changed, either let host directly
> access the QSFP, or re-design the BMC to provide more info for QSFP.

At a minimum, you need to support ethtool -m. It could be a firmware
call to the BMC, our you expose the i2c bus somehow. There are plenty
of MAC drivers which implement eththool -m without using phylink.

But i think you need to take a step back first, and look at the bigger
picture. What is Intel's goal? Are they just going to sell complete
cards? Or do they also want to sell the FPGA as a components anybody
get put onto their own board?

If there are only ever going to be compete cards, then you can go the
firmware direction, push a lot of functionality into the BMC, and have
the card driver make firmware calls to control the SFP, retimer,
etc. You can then throw away your mdio and phy driver hacks.

If however, the FPGA is going to be available as a component, can you
also assume there is a BMC? Running Intel firmware? Can the customer
also modify this firmware for their own needs? I think that is going
to be difficult. So you need to push as much as possible towards
linux, and let Linux drive all the hardware, the SFP, retimer, FPGA,
etc.

	Andrew


