Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1485FB0C62
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 12:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730971AbfILKOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 06:14:43 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41880 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730386AbfILKOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 06:14:43 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: bbeckett)
        with ESMTPSA id 9D23528A6D0
Message-ID: <8d63d4dbd9d075b5c238fd8933673b95b2fa96e9.camel@collabora.com>
Subject: Re: [PATCH 1/7] net/dsa: configure autoneg for CPU port
From:   Robert Beckett <bob.beckett@collabora.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, bob.beckett@gmail.com
Date:   Thu, 12 Sep 2019 11:14:39 +0100
In-Reply-To: <20190911225252.GA5710@lunn.ch>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
         <20190910154238.9155-2-bob.beckett@collabora.com>
         <20190910182635.GA9761@lunn.ch>
         <aa0459e0-64ee-de84-fc38-3c9364301275@gmail.com>
         <ad302835a98ca5abc7ac88b3caad64867e33ee70.camel@collabora.com>
         <20190911225252.GA5710@lunn.ch>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-09-12 at 00:52 +0200, Andrew Lunn wrote:
> > It is not just for broadcast storm protection. The original issue
> > that
> > made me look in to all of this turned out to be rx descritor ring
> > buffer exhaustion due to the CPU not being able to keep up with
> > packet
> > reception.
> 
> Pause frames does not really solve this problem. The switch will at
> some point fill its buffers, and start throwing packets away. Or it
> needs to send pause packets it its peers. And then your whole switch
> throughput goes down. Packets will always get thrown away, so you
> need
> QoS in your network to give the network hints about which frames is
> should throw away first.
> 

Indeed. This is the understanding I was working with.
This patch series enables pause frames, output queue prriority and
strict scheduling to egress the high priority queues first.
This means that when the switch starts dropping frames, it drops from
the lowest priority as the highest ones are delivered at line speed
without issue.

> ..
> 
> > Fundamentally, with a phy to phy CPU connection, the CPU MAC may
> > well
> > wish to enable pause frames for various reasons, so we should
> > strive to
> > handle that I think.
> 
> It actually has nothing to do with PHY to PHY connections. You can
> use
> pause frames with direct MAC to MAC connections. PHY auto-negotiation
> is one way to indicate both ends support it, but there are also other
> ways. e.g.
> 
> ethtool -A|--pause devname [autoneg on|off] [rx on|off] [tx on|off]
> 
> on the SoC you could do
> 
> ethtool --pause eth0 autoneg off rx on tx on
> 
> to force the SoC to send and process pause frames. Ideally i would
> prefer a solution like this, since it is not a change of behaviour
> for
> everybody else.

Good point, well made.
The reason for using autoneg in this series was due to having no netdev
to run ethtool against for the CPU port.
If we go down the route of creating a netdev for the CPU port, then we
could indeed force pause frames at both ends.

However, given that the phy on the marvell switch is capable of autoneg
, is it not reasonable to setup the advertisement and let autoneg take
care of it if using phy to phy connection?

> 
>    Andrew

