Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2981A1A47A2
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 16:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgDJOuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 10:50:44 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34182 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgDJOuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 10:50:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JKDRnjw6nHLIlh7GKrKhCQg2UxHo0B72/9vi0yz6KBU=; b=j33fAWYSW0Q7nM5nsNhnrNs73
        BwRb/ToAR6WNaED/Z+Ozb9eP9XN8niKqrX/NaIY4vw9GKgdkSAZDJrxBrOs9eoqapd+VgcTzuNgap
        xSrG7UUJpRdY6bwftGU9cd4WC+Am8PJdjXKz/+K+vVghfLf/OpIxiqlBLE7i62sB763V/p574bRqx
        XK73ArK9gL0cecxb0iZLApx8LDmwHvewZkb+8vMVCUJ16ItWw4cl1RcWD+YrEtbMJcKk+3j3Tpskr
        +4C2rBAuJGrHZisySCkFcEw45q+AOWZyQxxRRDAqdpNfXWYmpf3OycahGAqQm/z/amBtRAz2jZd2j
        d/2UimKeg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:36560)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jMuzM-00025N-2z; Fri, 10 Apr 2020 15:50:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jMuzK-0003rd-P6; Fri, 10 Apr 2020 15:50:34 +0100
Date:   Fri, 10 Apr 2020 15:50:34 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH net-next v2 3/3] net: phy: marvell10g: place in powersave
 mode at probe
Message-ID: <20200410145034.GA25745@shell.armlinux.org.uk>
References: <20200303155347.GS25745@shell.armlinux.org.uk>
 <E1j99sC-00011f-22@rmk-PC.armlinux.org.uk>
 <CAGnkfhx+JkD6a_8ojU6tEL_vk6vtwQpxbwU9+beDepL4dxgLyQ@mail.gmail.com>
 <20200410141914.GY25745@shell.armlinux.org.uk>
 <20200410143658.GM5827@shell.armlinux.org.uk>
 <CAGnkfhxPm6UWj8Dyt9S08vHdh9nwkTums+WfY14D52dsBsBPgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnkfhxPm6UWj8Dyt9S08vHdh9nwkTums+WfY14D52dsBsBPgQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 04:39:48PM +0200, Matteo Croce wrote:
> On Fri, Apr 10, 2020 at 4:37 PM Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Fri, Apr 10, 2020 at 03:19:14PM +0100, Russell King - ARM Linux admin wrote:
> > > On Fri, Apr 10, 2020 at 03:48:34PM +0200, Matteo Croce wrote:
> > > > On Fri, Apr 10, 2020 at 3:24 PM Russell King <rmk+kernel@armlinux.org.uk> wrote:
> > > > >
> > > > > Place the 88x3310 into powersaving mode when probing, which saves 600mW
> > > > > per PHY. For both PHYs on the Macchiatobin double-shot, this saves
> > > > > about 10% of the board idle power.
> > > > >
> > > > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > >
> > > > Hi,
> > > >
> > > > I have a Macchiatobin double shot, and my 10G ports stop working after
> > > > this change.
> > > > I reverted this commit on top of latest net-next and now the ports work again.
> > >
> > > Please describe the problem in more detail.
> > >
> > > Do you have the interface up?  Does the PHY link with the partner?
> > > Is the problem just that traffic isn't passed?
> >
> > I've just retested on my Macchiatobin double shot, and it works fine.
> > What revision PHYs do you have?  Unfortunately, you can't read the
> > PHY ID except using mii-diag:
> >
> > # mii-diag eth0 -p 32769
> >
> > or
> >
> > # mii-diag eth1 -p 33025
> >
> > Looking at word 3 and 4, it will be either:
> >
> > 002b 09aa
> > 002b 09ab
> >
> > Thanks.
> >
> > --
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
> >
> 
> 
> Hi Russel,
> 
> I have the interface up connected via a DAC Cable to an i40e card.
> When I set the link up I detect the carrier:
> 
> mvpp2 f2000000.ethernet eth0: PHY [f212a600.mdio-mii:00] driver
> [mv88x3310] (irq=POLL)
> mvpp2 f2000000.ethernet eth0: configuring for phy/10gbase-r link mode
> mvpp2 f2000000.ethernet eth0: Link is Up - 10Gbps/Full - flow control off
> 
> No traffic is received or can be sent.

I've just tried with a DAC cable ("Molex Inc. 74752-9542")... works for
me:

root@mcbin-ds:~# ip li set dev eth0 down
mvpp2 f2000000.ethernet eth0: Link is Down
root@mcbin-ds:~# ip li set dev eth0 up
mvpp2 f2000000.ethernet eth0: PHY [f212a600.mdio-mii:00] driver [mv88x3310] (irq=POLL)
mvpp2 f2000000.ethernet eth0: configuring for phy/10gbase-r link mode
root@mcbin-ds:~# mvpp2 f2000000.ethernet eth0: Link is Up - 10Gbps/Full - flow control off
IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

root@mcbin-ds:~# ping6 -I eth0 fe80::202:c9ff:fe54:d70a
ping6: Warning: source address might be selected on device other than eth0.
PING fe80::202:c9ff:fe54:d70a(fe80::202:c9ff:fe54:d70a) from :: eth0: 56 data bytes
64 bytes from fe80::202:c9ff:fe54:d70a%eth0: icmp_seq=1 ttl=64 time=0.344 ms
64 bytes from fe80::202:c9ff:fe54:d70a%eth0: icmp_seq=2 ttl=64 time=0.129 ms
64 bytes from fe80::202:c9ff:fe54:d70a%eth0: icmp_seq=3 ttl=64 time=0.118 ms
^C
--- fe80::202:c9ff:fe54:d70a ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 54ms
rtt min/avg/max/mdev = 0.118/0.197/0.344/0.104 ms

where fe80::202:c9ff:fe54:d70a is the IPv6 link local address on a
Mellanox card in a different machine at the other end of the DAC
cable.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
