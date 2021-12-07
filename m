Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E4246C301
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 19:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240633AbhLGSpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 13:45:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43688 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240627AbhLGSo7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 13:44:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VAh0IEb1mDATF+5DEmm633lm7F5fbYCo8vWsPxSIIv8=; b=tBvrOdE1UlvHYq3Gmc04jj0VQx
        ifgibcTWkH1La3xcmrBH7GQWXRh0PdbP1QYyZC2UzFL4KYyugyWDAJjBKGS7R7cPM+qYxhMko0yKg
        IFXQPyZDEAiMhFFAQxISj4s41AWmVC8AvZhuKuaqcZjo/1g+AQZbg/Qeo9gvb+zDJdqo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mufP1-00Fnv0-RS; Tue, 07 Dec 2021 19:41:23 +0100
Date:   Tue, 7 Dec 2021 19:41:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <Ya+q02HlWsHMYyAe@lunn.ch>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207145942.7444-1-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I still have to find a solution to a slowdown problem and this is where
> I would love to get some hint.
> Currently I still didn't find a good way to understand when the tagger
> starts to accept packets and because of this the initial setup is slow
> as every completion timeouts. Am I missing something or is there a way
> to check for this?

I've not looked at this particular driver, i just know the general
architecture.

The MDIO bus driver probes first, maybe as part of the Ethernet
driver, maybe as a standalone MDIO driver. The switch is found in DT
and the driver code will at some point later probe the switch driver.

The switch driver has working MDIO at this point. It should use MDIO
to talk to the switch, make sure it is there, maybe do some initial
configuration. Once it is happy, it registers the switch with the DSA
core using dsa_register_switch().

If this is a single switch, the DSA core will then start setting
things up. As part of dsa_switch_setup() it will call the switch
drivers setup() method. It then figures out what tag driver to use, by
calling dsa_switch_setup_tag_protocol(). However, the tag driver
itself is not inserted into the chain yet. That happens later.  Once
the switch is setup, dsa_tree_setup_master() is called which does
dsa_master_setup() and in the middle there is:

	/* If we use a tagging format that doesn't have an ethertype
	 * field, make sure that all packets from this point on get
	 * sent to the tag format's receive function.
	 */
	wmb();

	dev->dsa_ptr = cpu_dp;

This is the magic to actually enable the tagger receiving frames.

I need to look at your patches, but why is the tagger involved?  At
least for the Marvell switch, you send a pretty normal looking
Ethernet frame to a specific MAC address, and the switch replies using
that MAC address. And it has an Ether Type specific to switch
control. Since this is all normal looking, there are hooks in the
network stack which can be used to get these frames.

	Andrew

