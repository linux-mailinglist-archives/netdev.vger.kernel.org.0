Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7B745F00D
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 15:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351127AbhKZOoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 09:44:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53558 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239136AbhKZOmE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 09:42:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=XlFnGXJRxbZVEZqCmUzRQIQzW8wnQfRuzqfUvNPIFuY=; b=0r
        k4f5DKGSK7K0pld8PqF44Jmuv4DpfKS1V1ikeBCCbxuXHR5bUwteJQV/nIJOVCLYdI+GdWhb0y0E1
        fNRBtImuo7f12MCAFa6G0GtJZNPeS/fLEYz2h43EQUIfoHBpSSOh98Cm/OgeIjAkQfBrZI30ujCM2
        yTWrhuQZTfeWF1k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mqcN9-00Eha7-S0; Fri, 26 Nov 2021 15:38:43 +0100
Date:   Fri, 26 Nov 2021 15:38:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu =?utf-8?B?5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
Cc:     Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        Vincent Shih =?utf-8?B?5pa96YyV6bS7?= 
        <vincent.shih@sunplus.com>
Subject: Re: [PATCH v2 2/2] net: ethernet: Add driver for Sunplus SP7021
Message-ID: <YaDxc2+HKUYxsmX4@lunn.ch>
References: <cover.1636620754.git.wells.lu@sunplus.com>
 <519b61af544f4c6920012d44afd35a0f8761b24f.1636620754.git.wells.lu@sunplus.com>
 <YY7/v1msiaqJF3Uy@lunn.ch>
 <7cccf9f79363416ca8115a7ed9b1b7fd@sphcmbx02.sunplus.com.tw>
 <YZ+pzFRCB0faDikb@lunn.ch>
 <6c1ce569d2dd46eba8d4b0be84d6159b@sphcmbx02.sunplus.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6c1ce569d2dd46eba8d4b0be84d6159b@sphcmbx02.sunplus.com.tw>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 03:56:28AM +0000, Wells Lu 呂芳騰 wrote:
> Hi Andrew,
> 
> I set phy-id registers to 30 and 31 and found the read-back
> values of mdio read commands from CPU are all 0x0000.
> 
> I consulted with an ASIC engineer. She confirmed that if
> phy-id of a mdio command from CPU does not match any 
> phy-id registers, the mdio command will not be sent out.
> 
> She explained if phy-id of a mdio command does not match 
> any phy-id registers (represent addresses of external PHYs),
> why MAC needs to send a command to non-existing PHY?

Reads or writes on a real PHY which Linux is driving can have side
effects. There is a link statue register which latches. Read it once,
you get the last status, read it again, you get the current status. If
the MAC hardware is reading this register as well a Linux, bad things
will happen. A read on the interrupt status register often clears the
interrupts. So Linux will not see the interrupts.

So you need to make sure you hardware is not touching a PHY which
Linux uses. Which is why i suggested using MDIO bus address 31, which
generally does not have a PHY at that address.

	  Andrew
