Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF2E423310
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 23:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236707AbhJEVy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 17:54:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50874 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229974AbhJEVyY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 17:54:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=W4yT+b65bPv7vYT9mcTeeaiNF0+rs+97F+OpDRA+k/A=; b=dXUXB6dzavKbocZFMhwV2yslLq
        NkSeyWUW3YN61BQRSA0hMc24LA2ulbDvqG4Oh8VmhUcePE8btegHq66oE0OjUiNAiBRd8MpGSe0Xh
        dRC61innIrLKAE0bnjdNs3oyGil6U6oKrqLaqsfIOybmBqt2sLPj2TK/CyYQh9mFUW4k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXsMP-009kfY-HF; Tue, 05 Oct 2021 23:52:29 +0200
Date:   Tue, 5 Oct 2021 23:52:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: lets settle the LED `function` property regarding the netdev
 trigger
Message-ID: <YVzJHZXjQ04T2hmk@lunn.ch>
References: <20211001143601.5f57eb1a@thinkpad>
 <YVn815h7JBtVSfwZ@lunn.ch>
 <20211003212654.30fa43f5@thinkpad>
 <YVsUodiPoiIESrEE@lunn.ch>
 <20211004170847.3f92ef48@thinkpad>
 <YVs5sxd/dEBwBShm@lunn.ch>
 <20211005223014.3891f041@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005223014.3891f041@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I really don't think we should be registering any LEDs in the PHY driver
> if the driver does not know whether there are LEDs connected to the PHY.
> 
> If this information is not available (via device-tree or some other
> method, for example USB vendor/device table), then we can't register a
> LED and let user control it.
> 
> What if the pin is used for something different on a board?

There is some danger here. Some hardware misuse LED outputs for WoL
interrupts. There is even m88e1318_set_wol() which sets up LED2 for
WoL. So i will need to review the PHY drivers to look out for this,
and maybe add some restrictions.

But i think we have little choice but to export all the LEDs a PHY
supports. USB vendor/product, PCI vendor/product does not give us
anything useful. How many OEMs take a lan78xx chip, created a USB
dongle and shipped it using USB enumeration data:
LAN78XX_USB_VENDOR_ID:LAN7800_USB_PRODUCT_ID. How many motherboards
have a r8169 PCIe device using realteks PCI enumeration data? There is
no useful source of information in devices like this. But what we do
know is that the PHY can control X LED output pins, and we know what
patterns it can blink those LED pins. So we export them, and let the
user figure it out. This is the general case.

If we have DT, or ACPI, or some other source, we can then refine this
representation. If we have LED information, but a specific LED is
missing from DT, don't export it. If the colour is available, use that
in the name. If the default mode information is available, configure
it that way, etc.

Now, it could be we don't start with this, we just export those that
do have DT. But i will want to ensure that the API/ABI we define is
generic enough to support this. We need to start somewhere, get some
basic support merged, and then do incremental improvements.

	  Andrew
