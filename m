Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73192129A7
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgGBQfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgGBQfs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 12:35:48 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 720FB20720;
        Thu,  2 Jul 2020 16:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593707747;
        bh=rGNKmO07ReYGewo3jFdWR8QXf223+xTSsCx/NpM/Ewk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZJ0pdQbxr+sSQechj3qDo+8J71drf+D7PoVp9r0DTP2FbPziWtZntsXMbqz1xO9Ro
         MPLtbNwPF9bAIO7TiUBqLUDU1qN/9K7xacminlnEiFdbaZ+f8vPY22N38Ja7lybRL8
         zCajvfnCOvSKBzpQfI2iyuEPNKiBlqGq6+kkzrBo=
Date:   Thu, 2 Jul 2020 09:35:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] net: ethtool: Untangle PHYLIB dependency
Message-ID: <20200702093545.5ee3371a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200702163424.GG752507@lunn.ch>
References: <20200702042942.76674-1-f.fainelli@gmail.com>
        <20200702155652.ivokudjptoect6ch@lion.mk-sys.cz>
        <20200702163424.GG752507@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Jul 2020 18:34:24 +0200 Andrew Lunn wrote:
> On Thu, Jul 02, 2020 at 05:56:52PM +0200, Michal Kubecek wrote:
> > On Wed, Jul 01, 2020 at 09:29:38PM -0700, Florian Fainelli wrote:  
> > > Hi all,
> > > 
> > > This patch series untangles the ethtool netlink dependency with PHYLIB
> > > which exists because the cable test feature calls directly into PHY
> > > library functions. The approach taken here is to utilize a new set of
> > > net_device_ops function pointers which are automatically set to the PHY
> > > library variants when a network device driver attaches to a PHY device.  
> > 
> > I'm not sure about the idea of creating a copy of netdev_ops for each
> > device using phylib. First, there would be some overhead (just checked
> > my 5.8-rc3 kernel, struct netdev_ops is 632 bytes). Second, there is
> > quite frequent pattern of comparing dev->netdev_ops against known
> > constants to check if a network device is of certain type; I can't say
> > for sure if it is also used with devices using phylib in existing code
> > but it feels risky.  
> 
> I agree with Michal here. I don't like this.
> 
> I think we need phylib to register a set of ops with ethtool when it
> loads. It would also allow us to clean up phy_ethtool_get_strings(),
> phy_ethtool_get_sset_count(), phy_ethtool_get_stats().

+1
