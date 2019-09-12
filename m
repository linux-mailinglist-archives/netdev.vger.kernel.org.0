Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63641B0D1D
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 12:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731030AbfILKng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 06:43:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42240 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730807AbfILKng (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 06:43:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1PvI8WCVXvkl9K9coqaBNo6diovEdo89od2wQvjv+7M=; b=Dh1kZr5AAJlvXSWO87EsY3HQ2m
        vNMTqlrWlg5LpSURv5m9DfvwCfu6GRLOlSPQEuyhNswshvp4M0leY75ssKunzf6bQTlIukls5L3tW
        CsXeAMK7SGg2+NP6xqMmULQPuOk8hqtUxPXLVHC/aMZ8n52DIpCzTFw04gyPEF5VVYyg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i8MZZ-0005Ax-Nm; Thu, 12 Sep 2019 12:43:33 +0200
Date:   Thu, 12 Sep 2019 12:43:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Beckett <bob.beckett@collabora.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, bob.beckett@gmail.com
Subject: Re: [PATCH 1/7] net/dsa: configure autoneg for CPU port
Message-ID: <20190912104333.GE17773@lunn.ch>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
 <20190910154238.9155-2-bob.beckett@collabora.com>
 <20190910182635.GA9761@lunn.ch>
 <aa0459e0-64ee-de84-fc38-3c9364301275@gmail.com>
 <ad302835a98ca5abc7ac88b3caad64867e33ee70.camel@collabora.com>
 <20190911225252.GA5710@lunn.ch>
 <8d63d4dbd9d075b5c238fd8933673b95b2fa96e9.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d63d4dbd9d075b5c238fd8933673b95b2fa96e9.camel@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > It actually has nothing to do with PHY to PHY connections. You can
> > use
> > pause frames with direct MAC to MAC connections. PHY auto-negotiation
> > is one way to indicate both ends support it, but there are also other
> > ways. e.g.
> > 
> > ethtool -A|--pause devname [autoneg on|off] [rx on|off] [tx on|off]
> > 
> > on the SoC you could do
> > 
> > ethtool --pause eth0 autoneg off rx on tx on
> > 
> > to force the SoC to send and process pause frames. Ideally i would
> > prefer a solution like this, since it is not a change of behaviour
> > for
> > everybody else.
> 
> Good point, well made.
> The reason for using autoneg in this series was due to having no netdev
> to run ethtool against for the CPU port.

Do you need one? It is the IMX which is the bottle neck. It is the one
which needs to send pause frames. You have a netdev for that. Have you
checked if the switch will react on pause frames without your
change. Play with the command i give above on the master interface. It
looks like the FEC driver fully supports synchronous pause
configuration.

> However, given that the phy on the marvell switch is capable of
> autoneg , is it not reasonable to setup the advertisement and let
> autoneg take care of it if using phy to phy connection?

Most designs don't use back to back PHYs for the CPU port. They save
the cost and connect MACs back to back using RGMII, or maybe SERDES.
If we are going for a method which can configure pause between the CPU
and the switch, it needs to be generic and work for both setups.

    Andrew
