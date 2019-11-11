Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD5FAF739C
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 13:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfKKMKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 07:10:53 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:20129 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfKKMKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 07:10:53 -0500
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 8Kk2oexrn6M7SFEbyH3MPh1OGNiCqA83rD2nNqIbV/Sfmy0jePU+Jpsr0st1SSEZ6M+3aYcrD2
 XtZlEg37AR20Kv3D2IxMq4UfoYc/iM3ZyuycLK6vTHp0sT/15Q65pWkOhhG9PDYgYEzJgHGg2p
 6HclYJlUb6/nx/r9Xmj56DRWr5P6FDjOGiRhPy6X0ic7SEqH8rxxCWsoYkO9l6ctAV3/8hKnzC
 sSQ0wRZUJ/fptSDR0gdsYP3P7RMfjDXVu0IdukhO4cbDCAOR7GxlzplgxtMfA28NxC9qn2ixij
 94w=
X-IronPort-AV: E=Sophos;i="5.68,292,1569308400"; 
   d="scan'208";a="57823997"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Nov 2019 05:10:52 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 11 Nov 2019 05:10:50 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 11 Nov 2019 05:10:51 -0700
Date:   Mon, 11 Nov 2019 13:10:50 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <jakub.kicinski@netronome.com>, <davem@davemloft.net>,
        <alexandre.belloni@bootlin.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <joergen.andreasen@microchip.com>, <allan.nielsen@microchip.com>,
        <claudiu.manoil@nxp.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 00/15] Accomodate DSA front-end into Ocelot
Message-ID: <20191111121049.3hrammgeez5x6cm3@soft-dev3.microsemi.net>
References: <20191109130301.13716-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20191109130301.13716-1-olteanv@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/09/2019 15:02, Vladimir Oltean wrote:
> External E-Mail
> 
> 
> After the nice "change-my-mind" discussion about Ocelot, Felix and
> LS1028A (which can be read here: https://lkml.org/lkml/2019/6/21/630),
> we have decided to take the route of reworking the Ocelot implementation
> in a way that is DSA-compatible.
> 
> This is a large series, but hopefully is easy enough to digest, since it
> contains mostly code refactoring. What needs to be changed:
> - The struct net_device, phy_device needs to be isolated from Ocelot
>   private structures (struct ocelot, struct ocelot_port). These will
>   live as 1-to-1 equivalents to struct dsa_switch and struct dsa_port.
> - The function prototypes need to be compatible with DSA (of course,
>   struct dsa_switch will become struct ocelot).
> - The CPU port needs to be assigned via a higher-level API, not
>   hardcoded in the driver.
> 
> What is going to be interesting is that the new DSA front-end of Ocelot
> will need to have features in lockstep with the DSA core itself. At the
> moment, some more advanced tc offloading features of Ocelot (tc-flower,
> etc) are not available in the DSA front-end due to lack of API in the
> DSA core. It also means that Ocelot practically re-implements large
> parts of DSA (although it is not a DSA switch per se) - see the FDB API
> for example.
> 
> The code has been only compile-tested on Ocelot, since I don't have
> access to any VSC7514 hardware. It was proven to work on NXP LS1028A,
> which instantiates a DSA derivative of Ocelot. So I would like to ask
> Alex Belloni if you could confirm this series causes no regression on
> the Ocelot MIPS SoC.
> 
> The goal is to get this rework upstream as quickly as possible,
> precisely because it is a large volume of code that risks gaining merge
> conflicts if we keep it for too long.
> 
> This is but the first chunk of the LS1028A Felix DSA driver upstreaming.
> For those who are interested, the concept can be seen on my private
> Github repo, the user of this reworked Ocelot driver living under
> drivers/net/dsa/vitesse/:
> https://github.com/vladimiroltean/ls1028ardb-linux

I have done some tests on Ocelot hardware and it seems to work fine.

Acked-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Claudiu Manoil (1):
>   net: mscc: ocelot: initialize list of multicast addresses in common
>     code
> 
> Vladimir Oltean (14):
>   net: mscc: ocelot: break apart ocelot_vlan_port_apply
>   net: mscc: ocelot: break apart vlan operations into
>     ocelot_vlan_{add,del}
>   net: mscc: ocelot: break out fdb operations into abstract
>     implementations
>   net: mscc: ocelot: change prototypes of hwtstamping ioctls
>   net: mscc: ocelot: change prototypes of switchdev port attribute
>     handlers
>   net: mscc: ocelot: refactor struct ocelot_port out of function
>     prototypes
>   net: mscc: ocelot: separate net_device related items out of
>     ocelot_port
>   net: mscc: ocelot: refactor ethtool callbacks
>   net: mscc: ocelot: limit vlan ingress filtering to actual number of
>     ports
>   net: mscc: ocelot: move port initialization into separate function
>   net: mscc: ocelot: separate the common implementation of ndo_open and
>     ndo_stop
>   net: mscc: ocelot: refactor adjust_link into a netdev-independent
>     function
>   net: mscc: ocelot: split assignment of the cpu port into a separate
>     function
>   net: mscc: ocelot: don't hardcode the number of the CPU port
> 
>  drivers/net/ethernet/mscc/ocelot.c        | 948 +++++++++++++---------
>  drivers/net/ethernet/mscc/ocelot.h        |  33 +-
>  drivers/net/ethernet/mscc/ocelot_ace.h    |   4 +-
>  drivers/net/ethernet/mscc/ocelot_board.c  |  24 +-
>  drivers/net/ethernet/mscc/ocelot_flower.c |  32 +-
>  drivers/net/ethernet/mscc/ocelot_police.c |  36 +-
>  drivers/net/ethernet/mscc/ocelot_police.h |   4 +-
>  drivers/net/ethernet/mscc/ocelot_tc.c     |  56 +-
>  8 files changed, 680 insertions(+), 457 deletions(-)
> 
> -- 
> 2.17.1
> 
> 

-- 
/Horatiu
