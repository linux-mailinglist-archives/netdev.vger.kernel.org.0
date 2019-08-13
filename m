Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F21028BDBA
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 17:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbfHMPwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 11:52:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57280 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbfHMPwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 11:52:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nnJgvIpZCFabJ1YX+HDAaMn3yzPQYpab9k/QsJ2VfbI=; b=cOfjeuOnAdHCLXHeZ3eF5X8qzE
        2Z+ypsDwCy4A11Wvv59lZkyuPQ93CccgZTtRHGPiKqFrM25JFWMvTw+2usS+dYVKbdK4RmyDDHQB/
        EsRPG3CPJQalsXA+h5lVMXYPlg/CLtXCxPAsBhENvydvcXBOE2TbmSAmFz56CAK3nuYg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxZ67-0002ee-KU; Tue, 13 Aug 2019 17:52:31 +0200
Date:   Tue, 13 Aug 2019 17:52:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: fix RGMII-ID port setup
Message-ID: <20190813155231.GZ14290@lunn.ch>
References: <20190811150812.6780-1-marek.behun@nic.cz>
 <20190811153153.GB14290@lunn.ch>
 <20190811181445.71048d2c@nic.cz>
 <20190811165108.GG14290@lunn.ch>
 <20190813174416.5c57b08f@dellmb.labs.office.nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190813174416.5c57b08f@dellmb.labs.office.nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 05:44:16PM +0200, Marek Behún wrote:
> Hi Andrew,
> 
> > We should read the switch registers. I think you can set the defaults
> > using strapping pins. And in general, the driver always reads state
> > from the hardware rather than caching it.
> 
> hmm. The cmode is cached for each port, though. For example
> mv88e6390x_port_set_cmode compares the new requested value with the
> cached one and doesn't do anything if they are equal.
> 
> If mv88e6xxx_port_setup_mac can be called once per second by phylink as
> you say, do we really want to read the value via MDIO every time? We
> already have cmode cached (read from registers at mv88e6xxx_setup, and
> then changed when cmode change is requested). From cmode we can already
> differentiate mode in the terms of phy_interface_t, unless it is RGMII,
> in which case we would have to read RX/TX timing.

Hi Marek

cmode gets used a lot, and in interrupt thread context. So i think it
was worth caching it. RGMII Rx/Tx timing is not used much, so i don't
think it is worth caching it. But as you say, using cmode to determine
if the registers actually need to be read does make sense. Most ports
don't use RGMII, they have internal PHYs.

      Andrew
