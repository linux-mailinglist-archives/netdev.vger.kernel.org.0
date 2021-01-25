Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C239304B51
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 22:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbhAZErj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:47:39 -0500
Received: from 95-165-96-9.static.spd-mgts.ru ([95.165.96.9]:57706 "EHLO
        blackbox.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbhAYJPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 04:15:23 -0500
Received: from metabook.localnet (metabook.metanet [192.168.2.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by blackbox.su (Postfix) with ESMTPSA id B00AB82100;
        Mon, 25 Jan 2021 11:58:41 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blackbox.su; s=mail;
        t=1611565121; bh=8SZ2rrDH5Iz6uZt2+yloOAHMdEXzY9V0yUVQOQ+k1GU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JpT/eO585YBzoG2pyoFdUxwkmhbihLudgZA8wWSUggDMnKy8TdKM3LkU7/iHxSXOX
         faRm/PdiHzNtvHzyQaJoStZ9uFdypKDZPr7pwEqscu1I2hYHfjFyRJE0OP4gLYANpQ
         X/GBa9zFGwUczVP4tzVUgA1Sh5AEfovQqgxj0mpO3lh91AdL+bpWnBuHNfA82oC2n/
         P9bKO8hAelVdzp/sPv79Hoz1wLZEIKAS3eIBcKVCqVGtTJ1FiVfKVHnn9iXuwMSwMH
         Z5xmj7A1HJ0d5u2r6bH+cuPKhQjbwHeuJ60eZTsTq67XSHqL4wsIWqMRnqEYupjtyU
         rUO2nwKhQrSSg==
From:   Sergej Bauer <sbauer@blackbox.su>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Simon Horman <simon.horman@netronome.com>,
        Mark Einon <mark.einon@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lan743x: add virtual PHY for PHY-less devices
Date:   Mon, 25 Jan 2021 11:57:47 +0300
Message-ID: <4533953.k7tWhSxINc@metabook>
In-Reply-To: <YAt8trmR1FjGnCeF@lunn.ch>
References: <20210122214247.6536-1-sbauer@blackbox.su> <4496952.bab7Homqhv@metabook> <YAt8trmR1FjGnCeF@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday, January 23, 2021 4:32:38 AM MSK Andrew Lunn wrote:
> > it migth be helpful for developers work on userspace networking tools with
> > PHY-less lan743x
> 
> (the interface even could not be brought up)
> 
> > of course, there nothing much to do without TP port but the difference is
> > representative.
> > 
> > sbauer@metamini ~$ sudo ethtool eth7
> > Settings for eth7:
> > Cannot get device settings: No such device
> > 
> >         Supports Wake-on: pumbag
> >         Wake-on: d
> >         Current message level: 0x00000137 (311)
> >         
> >                                drv probe link ifdown ifup tx_queued
> >         
> >         Link detected: no
> > 
> > sbauer@metamini ~$ sudo ifup eth7
> > sbauer@metamini ~$ sudo ethtool eth7
> > 
> > Settings for eth7:
> >         Supported ports: [ MII ]
> >         Supported link modes:   10baseT/Full
> >         
> >                                 100baseT/Full
> >                                 1000baseT/Full
> >         
> >         Supported pause frame use: Symmetric Receive-only
> >         Supports auto-negotiation: Yes
> >         Supported FEC modes: Not reported
> >         Advertised link modes:  10baseT/Full
> >         
> >                                 100baseT/Full
> >                                 1000baseT/Full
> >         
> >         Advertised pause frame use: Symmetric Receive-only
> >         Advertised auto-negotiation: Yes
> >         Advertised FEC modes: Not reported
> >         Speed: 1000Mb/s
> >         Duplex: Full
> >         Port: MII
> >         PHYAD: 0
> >         Transceiver: internal
> >         Auto-negotiation: on
> >         Supports Wake-on: pumbag
> >         Wake-on: d
> >         Current message level: 0x00000137 (311)
> >         
> >                                drv probe link ifdown ifup tx_queued
> >         
> >         Link detected: yes
> > 
> > sbauer@metamini ~$ sudo mii-tool -vv eth7
> > Using SIOCGMIIPHY=0x8947
> > eth7: negotiated 1000baseT-FD, link ok
> > 
> >   registers for MII PHY 0:
> >     5140 512d 7431 0011 4140 4140 000d 0000
> >     0000 0200 7800 0000 0000 0000 0000 2000
> >     0000 0000 0000 0000 0000 0000 0000 0000
> >     0000 0000 0000 0000 0000 0000 0000 0000
> >   
> >   product info: vendor 1d:0c:40, model 1 rev 1
> >   basic mode:   loopback, autonegotiation enabled
> >   basic status: autonegotiation complete, link ok
> >   capabilities: 1000baseT-FD 100baseTx-FD 10baseT-FD
> >   advertising:  1000baseT-FD 100baseTx-FD 10baseT-FD
> >   link partner: 1000baseT-FD 100baseTx-FD 10baseT-FD
> 
> You have not shown anything i cannot do with the ethernet interfaces i
> have in my laptop. And since ethtool is pretty standardized, what
> lan743x offers should be pretty much the same as any 1G Ethernet MAC
> using most 1G PHYs.
> 
>       Andrew

Andrew, for this moment with lan743x we can get only this:
sbauer@metamini ~/devel/kernel-works/net-next.git master$ sudo ethtool eth7
Settings for eth7:
Cannot get device settings: No such device
        Supports Wake-on: pumbag
        Wake-on: d
        Current message level: 0x00000137 (311)
                               drv probe link ifdown ifup tx_queued
        Link detected: no
sbauer@metamini ~/devel/kernel-works/net-next.git master$ sudo mii-tool -vv 
eth7
Using SIOCGMIIPHY=0x8947
SIOCGMIIPHY on 'eth7' failed: Invalid argument


-- 
                                Regards,
                                    Sergej.




