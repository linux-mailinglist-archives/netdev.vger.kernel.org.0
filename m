Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C2F3D1175
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 16:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239030AbhGUNzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 09:55:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38316 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232160AbhGUNzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 09:55:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ajdrKYl+mdvVy6NRBRpq4GHIFDRVTvgDHU6NF9M0u9k=; b=r/KZlOIRI2I9emSi07nWzaiHGb
        NmppCG/LWqWnUp3Ej5za69iuMnTNM2TREx+hcVhaAdYIQYHo86W8HDzo/oJuBxec4XbBrl4D+jo6n
        rCX9vrPAr8gyMRkgOJyMzs17OsGJdRazsZzJqijiPA6aFqZlXin0HDKlEK2rDoaMn3qk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m6DJn-00ECyH-GB; Wed, 21 Jul 2021 16:35:27 +0200
Date:   Wed, 21 Jul 2021 16:35:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Pavel Machek <pavel@ucw.cz>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <YPgwr2MB5gQVgDff@lunn.ch>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
 <f705bcd6-c55c-0b07-612f-38348d85bbee@gmail.com>
 <YPTKB0HGEtsydf9/@lunn.ch>
 <88d23db8-d2d2-5816-6ba1-3bd80738c398@gmail.com>
 <YPbu8xOFDRZWMTBe@lunn.ch>
 <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thanks for the hint, Andrew. If I make &netdev->dev the parent,
> then I get:
> 
> ll /sys/class/leds/
> total 0
> lrwxrwxrwx 1 root root 0 Jul 20 21:37 led0 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/led0
> lrwxrwxrwx 1 root root 0 Jul 20 21:37 led1 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/led1
> lrwxrwxrwx 1 root root 0 Jul 20 21:37 led2 -> ../../devices/pci0000:00/0000:00:1d.0/0000:03:00.0/net/enp3s0/led2
> 
> Now the (linked) LED devices are under /sys/class/net/<ifname>, but still
> the primary LED devices are under /sys/class/leds and their names have
> to be unique therefore. The LED subsystem takes care of unique names,
> but in case of a second network interface the LED device name suddenly
> would be led0_1 (IIRC). So the names wouldn't be predictable, and I think
> that's not what we want.

We need input from the LED maintainers, but do we actually need the
symbolic links in /sys/class/leds/? For this specific use case, not
generally. Allow an LED to opt out of the /sys/class/leds symlink.

If we could drop those, we can relax the naming requirements so that
the names is unique to a parent device, not globally unique.

    Andrew
