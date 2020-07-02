Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279FC21299F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgGBQec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:34:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44222 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726715AbgGBQec (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 12:34:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jr2AK-003Le7-P9; Thu, 02 Jul 2020 18:34:24 +0200
Date:   Thu, 2 Jul 2020 18:34:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] net: ethtool: Untangle PHYLIB dependency
Message-ID: <20200702163424.GG752507@lunn.ch>
References: <20200702042942.76674-1-f.fainelli@gmail.com>
 <20200702155652.ivokudjptoect6ch@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702155652.ivokudjptoect6ch@lion.mk-sys.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 05:56:52PM +0200, Michal Kubecek wrote:
> On Wed, Jul 01, 2020 at 09:29:38PM -0700, Florian Fainelli wrote:
> > Hi all,
> > 
> > This patch series untangles the ethtool netlink dependency with PHYLIB
> > which exists because the cable test feature calls directly into PHY
> > library functions. The approach taken here is to utilize a new set of
> > net_device_ops function pointers which are automatically set to the PHY
> > library variants when a network device driver attaches to a PHY device.
> 
> I'm not sure about the idea of creating a copy of netdev_ops for each
> device using phylib. First, there would be some overhead (just checked
> my 5.8-rc3 kernel, struct netdev_ops is 632 bytes). Second, there is
> quite frequent pattern of comparing dev->netdev_ops against known
> constants to check if a network device is of certain type; I can't say
> for sure if it is also used with devices using phylib in existing code
> but it feels risky.

I agree with Michal here. I don't like this.

I think we need phylib to register a set of ops with ethtool when it
loads. It would also allow us to clean up phy_ethtool_get_strings(),
phy_ethtool_get_sset_count(), phy_ethtool_get_stats().

      Andrew
