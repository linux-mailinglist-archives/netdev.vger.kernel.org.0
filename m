Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221C21D0493
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 03:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgEMB7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 21:59:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56972 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgEMB7u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 21:59:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=b7RrNiCav3BfKDCsCqG8wApdlCITQbgBHil/CGwVYAg=; b=MpB0XIHMrWz/zvuNFYXzCW7MDy
        sMF4pPrI/ZsxszE0NkWmGn3WpEf6JOQK3Lfri383ika76/qcGqdaNbc4frx1gQiGI4Puqm5AeZ3IR
        0Rwxxxo5fnzWphG95HH9K6RoYCLUVXOh8B8I8oNFT0VuU++gK6SHyATGqagAzFtPFcuM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jYggS-0027Tw-91; Wed, 13 May 2020 03:59:44 +0200
Date:   Wed, 13 May 2020 03:59:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yonglong Liu <liuyonglong@huawei.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxarm@huawei.com, Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [question] net: phy: rtl8211f: link speed shows 1000Mb/s but
 actual link speed in phy is 100Mb/s
Message-ID: <20200513015944.GA501603@lunn.ch>
References: <478f871a-583d-01f1-9cc5-2eea56d8c2a7@huawei.com>
 <20200512140017.GK409897@lunn.ch>
 <ef25a0a2-e13f-def1-5e91-ceae1bfaf333@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef25a0a2-e13f-def1-5e91-ceae1bfaf333@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 09:34:13AM +0800, Yonglong Liu wrote:
> Hi, Andrew:
> 	Thanks for your reply!
> 
> On 2020/5/12 22:00, Andrew Lunn wrote:
> > On Tue, May 12, 2020 at 08:48:21PM +0800, Yonglong Liu wrote:
> >> I use two devices, both support 1000M speed, they are directly connected
> >> with a network cable. Two devices enable autoneg, and then do the following
> >> test repeatedly:
> >> 	ifconfig eth5 down
> >> 	ifconfig eth5 up
> >> 	sleep $((RANDOM%6))
> >> 	ifconfig eth5 down
> >> 	ifconfig eth5 up
> >> 	sleep 10
> >>
> >> With low probability, one device A link up with 100Mb/s, the other B link up with
> >> 1000Mb/s(the actual link speed read from phy is 100Mb/s), and the network can
> >> not work.
> >>
> >> device A:
> >> Settings for eth5:
> >>         Supported ports: [ TP ]
> >>         Supported link modes:   10baseT/Half 10baseT/Full
> >>                                 100baseT/Half 100baseT/Full
> >>                                 1000baseT/Full
> >>         Supported pause frame use: Symmetric Receive-only
> >>         Supports auto-negotiation: Yes
> >>         Supported FEC modes: Not reported
> >>         Advertised link modes:  10baseT/Half 10baseT/Full
> >>                                 100baseT/Half 100baseT/Full
> >>                                 1000baseT/Full
> >>         Advertised pause frame use: Symmetric
> >>         Advertised auto-negotiation: Yes
> >>         Advertised FEC modes: Not reported
> >>         Link partner advertised link modes:  10baseT/Half 10baseT/Full
> >>                                              100baseT/Half 100baseT/Full
> >>         Link partner advertised pause frame use: Symmetric
> >>         Link partner advertised auto-negotiation: Yes
> >>         Link partner advertised FEC modes: Not reported
> >>         Speed: 100Mb/s
> >>         Duplex: Full
> >>         Port: MII
> >>         PHYAD: 3
> >>         Transceiver: internal
> >>         Auto-negotiation: on
> >>         Current message level: 0x00000036 (54)
> >>                                probe link ifdown ifup
> >>         Link detected: yes
> >>
> >> The regs value read from mdio are:
> >> reg 9 = 0x200
> >> reg a = 0
> >>
> >> device B:
> >> Settings for eth5:
> >>         Supported ports: [ TP ]
> >>         Supported link modes:   10baseT/Half 10baseT/Full
> >>                                 100baseT/Half 100baseT/Full
> >>                                 1000baseT/Full
> >>         Supported pause frame use: Symmetric Receive-only
> >>         Supports auto-negotiation: Yes
> >>         Supported FEC modes: Not reported
> >>         Advertised link modes:  10baseT/Half 10baseT/Full
> >>                                 100baseT/Half 100baseT/Full
> >>                                 1000baseT/Full
> >>         Advertised pause frame use: Symmetric
> >>         Advertised auto-negotiation: Yes
> >>         Advertised FEC modes: Not reported
> >>         Link partner advertised link modes:  10baseT/Half 10baseT/Full
> >>                                              100baseT/Half 100baseT/Full
> >>                                              1000baseT/Full
> >>         Link partner advertised pause frame use: Symmetric
> >>         Link partner advertised auto-negotiation: Yes
> >>         Link partner advertised FEC modes: Not reported
> >>         Speed: 1000Mb/s
> >>         Duplex: Full
> >>         Port: MII
> >>         PHYAD: 3
> >>         Transceiver: internal
> >>         Auto-negotiation: on
> >>         Current message level: 0x00000036 (54)
> >>                                probe link ifdown ifup
> >>         Link detected: yes
> >>
> >> The regs value read from mdio are:
> >> reg 9 = 0
> >> reg a = 0x800
> >>
> >> I had talk to the FAE of rtl8211f, they said if negotiation failed with 1000Mb/s,
> >> rtl8211f will change reg 9 to 0, than try to negotiation with 100Mb/s.
> >>
> >> The problem happened as:
> >> ifconfig eth5 up -> phy_start -> phy_start_aneg -> phy_modify_changed(MII_CTRL1000)
> >> (this time both A and B, reg 9 = 0x200) -> wait for link up -> (B: reg 9 changed to 0)
> >> -> link up.
> > 
> > This sounds like downshift, but not correctly working. 1Gbps requires
> > that 4 pairs in the cable work. If a 1Gbps link is negotiated, but
> > then does not establish because one of the pairs is broken, some PHYs
> > will try to 'downshift'. They drop down to 100Mbps, which only
> > requires two pairs of the cable to work. To do this, the PHY should
> > change what it is advertising, to no longer advertise 1G, just 100M
> > and 10M. The link partner should then try to use 100Mbps and
> > hopefully, a link is established.
> > 
> > Looking at the ethtool, you can see device A is reporting device B is
> > only advertising upto 100Mbps. Yet it is locally using 1G. That is
> > broken. So i would say device A has the problem. Are both PHYs
> > rtl8211f?
> 
> Both PHY is rtl8211f. I think Device B is broken. Device B advertising
> it supported 1G, but actually, in phy, downshift to 100M, so Device B
> link up with 1G in driver side, but actually 100M in phy.

You have to be careful with the output of ethtool. Downshift is not
part of 802.3. There i no standard register to indicate it has
happened. Sometimes there is a vendor register. You should check the
datasheet, and look at what other PHY drivers do for this, and
phy_check_downshift().

> > Are you 100% sure your cable and board layout is good? Is it
> > trying downshift because something is broken? Fix the
> > cable/connector and the

> Will check the layout with hardware engineer. This happened with a low
> probability. When this happened, another down/up operation or restart
> autoneg will solved.
 
> > reason to downshift goes away. But it does not solve the problem if a
> > customer has a broken cable. So you might want to deliberately cut a
> > pair in the cable so it becomes 100% reproducable and try to debug it
> > further. See if you can find out why auto-neg is not working
> > correctly.
> 
> So, your opinion is, maybe we should checkout whether the hardware layout
> or cable have problem?

Well, there are a couple of issues here.

It could be a hardware problem. Best case, it is the cable. But if you
can reproduce it with other boards, it is a board design issue, which
you might want to get fixed. If it happens for you in the lab, it will
probably happen out in the field.

You should also consider what you want to happen with a cable that
really is broken. It would be nice if downshift worked. Slower
networking is better than no networking. Unless you have a requirement
that 100Mbps is too slow for your use case. So you might want to debug
what is going wrong when downshift happens.

> By the way, do we have some mechanism to solve this downshift in software
> side? If the PHY advertising downshift to 100M, but software still have
> advertising with 1G(just like Device B), it will always have a broken network.

You might get some ideas from phy_check_downshift(). A lot will
depended on what information you can get from the PHY.

	 Andrew
