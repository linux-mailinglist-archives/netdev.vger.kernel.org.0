Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF4B89252
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 17:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfHKPb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 11:31:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51202 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbfHKPb4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 11:31:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DKNtVELMimKV4pXqA8CXI/kdt8yx+cpbxEWWMwST9sg=; b=ef7wZAnfPUuHtBxnLxhrBwswf2
        XbDmYAAeZSqrvR9rRW0VpyJQkgfBPWrtSDO3DA7xmeG/ow0nwnE1VNUcH0zzanNxoOYWJ6/wceNcJ
        5avYnkYZ9OtazMBaSsmAoJlDTI6dvfAV9CJw9+p20TOb+Htzk2dgVMtKQ/jfD7PTh3Q8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hwpp3-0003t6-Vs; Sun, 11 Aug 2019 17:31:53 +0200
Date:   Sun, 11 Aug 2019 17:31:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: fix RGMII-ID port setup
Message-ID: <20190811153153.GB14290@lunn.ch>
References: <20190811150812.6780-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190811150812.6780-1-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 11, 2019 at 05:08:11PM +0200, Marek Behún wrote:
> The mv88e6xxx_port_setup_mac looks if one of the {link, speed, duplex}
> parameters is being changed from the current setting, and if not, does
> not do anything. This test is wrong in some situations: this method also
> has the mode argument, which can also be changed.
> 
> For example on Turris Omnia, the mode is PHY_INTERFACE_MODE_RGMII_ID,
> which has to be set byt the ->port_set_rgmii_delay method. The test does
> not look if mode is being changed (in fact there is currently no method
> to determine port mode as phy_interface_t type).
> 
> The simplest solution seems to be to drop this test altogether and
> simply do the setup when requested.

Hi Marek

Unfortunately, that code is there for a reason. phylink can call the
->mac_config() method once per second. It is documented that
mac_config() should only reconfigure what, if anything, has changed.
And mv88e6xxx_port_setup_mac() needs to disable the port in order to
change anything. So the change you propose here, under some
conditions, will cause the port to be disabled/enables once per
second.

We need to fix this by expanding the test, not removing it.  My
current _guess_ would be, we need to add a ops->port_get_rgmii_delay()
so we can see if that is what needs configuring.

   Andrew
