Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE9322FAE2
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 23:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgG0VBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 17:01:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58136 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgG0VBt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 17:01:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k0AFh-0079mh-SH; Mon, 27 Jul 2020 23:01:41 +0200
Date:   Mon, 27 Jul 2020 23:01:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Jamie Gloudon <jamie.gloudon@gmx.fr>,
        Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Subject: Re: Broken link partner advertised reporting in ethtool
Message-ID: <20200727210141.GA1705504@lunn.ch>
References: <20200727154715.GA1901@gmx.fr>
 <871802ee-3b9a-87fb-4a16-db570828ef2d@intel.com>
 <20200727200912.GA1884@gmx.fr>
 <20200727204227.s2gv3hqszmpk7l7r@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727204227.s2gv3hqszmpk7l7r@lion.mk-sys.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>   - the exact command you ran (including arguments)
>   - expected output (or at least the relevant part)
>   - actual output (or at least the relevant part)
>   - output with dump of netlink messages, you can get it by enabling
>     debugging flags, e.g. "ethtool --debug 0x12 eth0"
 
Hi Michal

See if this helps.

This is a Marvel Ethernet switch port using an Marvell PHY.

$ dpkg -l ethtool
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name           Version      Architecture Description
+++-==============-============-============-==========================================
ii  ethtool        1:5.4-1      amd64        display or change Ethernet device settings

root@rap:~# ethtool green
Settings for green:
	Supported ports: [ TP MII ]
	Supported link modes:   10baseT/Half 10baseT/Full 
	                        100baseT/Half 100baseT/Full 
	                        1000baseT/Full 
	Supported pause frame use: Symmetric
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  10baseT/Half 10baseT/Full 
	                        100baseT/Half 100baseT/Full 
	                        1000baseT/Full 
	Advertised pause frame use: Symmetric
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  10baseT/Half 10baseT/Full 
	                                     100baseT/Half 100baseT/Full 
	                                     1000baseT/Full 
	Link partner advertised pause frame use: No
	Link partner advertised auto-negotiation: Yes
	Link partner advertised FEC modes: Not reported
	Speed: 1000Mb/s
	Duplex: Full
	Port: MII
	PHYAD: 4
	Transceiver: internal
	Auto-negotiation: on
	Supports Wake-on: d
	Wake-on: d
	Link detected: yes

And now ethtool from git 4e02c55227c9958184d5941de73d9cf1cd49bf2e.

root@rap:/home/andrew/ethtool# /home/andrew/ethtool/ethtool green
Settings for green:
	Supported ports: [ TP	 MII ]
	Supported link modes:   10baseT/Half 10baseT/Full
	                        100baseT/Half 100baseT/Full
	                        1000baseT/Full
	Supported pause frame use: Symmetric
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  10baseT/Half 10baseT/Full
	                        100baseT/Half 100baseT/Full
	                        1000baseT/Full
	Advertised pause frame use: Symmetric
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  Not reported
	Link partner advertised pause frame use: No
	Link partner advertised auto-negotiation: No
	Link partner advertised FEC modes: No
	Speed: 1000Mb/s
	Duplex: Full
	Auto-negotiation: on
	Port: MII
	PHYAD: 4
	Transceiver: external
	Supports Wake-on: d
	Wake-on: d
	Link detected: yes

So they are definitely missing.

Here are the netlink messages.

sending genetlink packet (32 bytes):
    msg length 32 genl-ctrl
    CTRL_CMD_GETFAMILY
        CTRL_ATTR_FAMILY_NAME = "ethtool"
...
...
sending genetlink packet (36 bytes):
    msg length 36 ethool ETHTOOL_MSG_LINKMODES_GET
    ETHTOOL_MSG_LINKMODES_GET
        ETHTOOL_A_LINKMODES_HEADER
            ETHTOOL_A_HEADER_DEV_NAME = "green"
received genetlink packet (572 bytes):
    msg length 572 ethool ETHTOOL_MSG_LINKMODES_GET_REPLY
    ETHTOOL_MSG_LINKMODES_GET_REPLY
        ETHTOOL_A_LINKMODES_HEADER
            ETHTOOL_A_HEADER_DEV_INDEX = 8
            ETHTOOL_A_HEADER_DEV_NAME = "green"
        ETHTOOL_A_LINKMODES_AUTONEG = on
        ETHTOOL_A_LINKMODES_OURS
            ETHTOOL_A_BITSET_SIZE = 90
            ETHTOOL_A_BITSET_BITS
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_INDEX = 0
                    ETHTOOL_A_BITSET_BIT_NAME = "10baseT/Half"
                    ETHTOOL_A_BITSET_BIT_VALUE = true
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_INDEX = 1
                    ETHTOOL_A_BITSET_BIT_NAME = "10baseT/Full"
                    ETHTOOL_A_BITSET_BIT_VALUE = true
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_INDEX = 2
                    ETHTOOL_A_BITSET_BIT_NAME = "100baseT/Half"
                    ETHTOOL_A_BITSET_BIT_VALUE = true
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_INDEX = 3
                    ETHTOOL_A_BITSET_BIT_NAME = "100baseT/Full"
                    ETHTOOL_A_BITSET_BIT_VALUE = true
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_INDEX = 5
                    ETHTOOL_A_BITSET_BIT_NAME = "1000baseT/Full"
                    ETHTOOL_A_BITSET_BIT_VALUE = true
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_INDEX = 6
                    ETHTOOL_A_BITSET_BIT_NAME = "Autoneg"
                    ETHTOOL_A_BITSET_BIT_VALUE = true
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_INDEX = 7
                    ETHTOOL_A_BITSET_BIT_NAME = "TP"
                    ETHTOOL_A_BITSET_BIT_VALUE = true
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_INDEX = 9
                    ETHTOOL_A_BITSET_BIT_NAME = "MII"
                    ETHTOOL_A_BITSET_BIT_VALUE = true
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_INDEX = 13
                    ETHTOOL_A_BITSET_BIT_NAME = "Pause"
                    ETHTOOL_A_BITSET_BIT_VALUE = true
        ETHTOOL_A_LINKMODES_PEER
            ETHTOOL_A_BITSET_NOMASK = true
            ETHTOOL_A_BITSET_SIZE = 90
            ETHTOOL_A_BITSET_BITS
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_INDEX = 0
                    ETHTOOL_A_BITSET_BIT_NAME = "10baseT/Half"
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_INDEX = 1
                    ETHTOOL_A_BITSET_BIT_NAME = "10baseT/Full"
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_INDEX = 2
                    ETHTOOL_A_BITSET_BIT_NAME = "100baseT/Half"
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_INDEX = 3
                    ETHTOOL_A_BITSET_BIT_NAME = "100baseT/Full"
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_INDEX = 5
                    ETHTOOL_A_BITSET_BIT_NAME = "1000baseT/Full"
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_INDEX = 6
                    ETHTOOL_A_BITSET_BIT_NAME = "Autoneg"
        ETHTOOL_A_LINKMODES_SPEED = 1000
        ETHTOOL_A_LINKMODES_DUPLEX = 1
Settings for green:
	Supported ports: [ TP	 MII ]
	Supported link modes:   10baseT/Half 10baseT/Full
	                        100baseT/Half 100baseT/Full
	                        1000baseT/Full
	Supported pause frame use: Symmetric
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  10baseT/Half 10baseT/Full
	                        100baseT/Half 100baseT/Full
	                        1000baseT/Full
	Advertised pause frame use: Symmetric
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  Not reported
	Link partner advertised pause frame use: No
	Link partner advertised auto-negotiation: No
	Link partner advertised FEC modes: No
	Speed: 1000Mb/s
	Duplex: Full
	Auto-negotiation: on
received genetlink packet (36 bytes):
    msg length 36 error errno=0
sending genetlink packet (36 bytes):
    msg length 36 ethool ETHTOOL_MSG_LINKINFO_GET
    ETHTOOL_MSG_LINKINFO_GET
        ETHTOOL_A_LINKINFO_HEADER
            ETHTOOL_A_HEADER_DEV_NAME = "green"
received genetlink packet (84 bytes):
    msg length 84 ethool ETHTOOL_MSG_LINKINFO_GET_REPLY
    ETHTOOL_MSG_LINKINFO_GET_REPLY
        ETHTOOL_A_LINKINFO_HEADER
            ETHTOOL_A_HEADER_DEV_INDEX = 8
            ETHTOOL_A_HEADER_DEV_NAME = "green"
        ETHTOOL_A_LINKINFO_PORT = 2
        ETHTOOL_A_LINKINFO_PHYADDR = 4
        ETHTOOL_A_LINKINFO_TP_MDIX = 0
        ETHTOOL_A_LINKINFO_TP_MDIX_CTRL = 0
        ETHTOOL_A_LINKINFO_TRANSCEIVER = 1
	Port: MII
	PHYAD: 4
	Transceiver: external
received genetlink packet (36 bytes):
    msg length 36 error errno=0
sending genetlink packet (36 bytes):
    msg length 36 ethool ETHTOOL_MSG_WOL_GET
    ETHTOOL_MSG_WOL_GET
        ETHTOOL_A_WOL_HEADER
            ETHTOOL_A_HEADER_DEV_NAME = "green"
received genetlink packet (60 bytes):
    msg length 60 ethool ETHTOOL_MSG_WOL_GET_REPLY
    ETHTOOL_MSG_WOL_GET_REPLY
        ETHTOOL_A_WOL_HEADER
            ETHTOOL_A_HEADER_DEV_INDEX = 8
            ETHTOOL_A_HEADER_DEV_NAME = "green"
        ETHTOOL_A_WOL_MODES
            ETHTOOL_A_BITSET_SIZE = 8
            ETHTOOL_A_BITSET_BITS
	Supports Wake-on: d
	Wake-on: d
received genetlink packet (36 bytes):
    msg length 36 error errno=0
sending genetlink packet (36 bytes):
    msg length 36 ethool ETHTOOL_MSG_DEBUG_GET
    ETHTOOL_MSG_DEBUG_GET
        ETHTOOL_A_DEBUG_HEADER
            ETHTOOL_A_HEADER_DEV_NAME = "green"
received genetlink packet (56 bytes):
    msg length 56 error errno=-95
offending message:
    ETHTOOL_MSG_DEBUG_GET
        ETHTOOL_A_DEBUG_HEADER
            ETHTOOL_A_HEADER_DEV_NAME = "green"
sending genetlink packet (36 bytes):
    msg length 36 ethool ETHTOOL_MSG_LINKSTATE_GET
    ETHTOOL_MSG_LINKSTATE_GET
        ETHTOOL_A_LINKSTATE_HEADER
            ETHTOOL_A_HEADER_DEV_NAME = "green"
received genetlink packet (52 bytes):
    msg length 52 ethool ETHTOOL_MSG_LINKSTATE_GET_REPLY
    ETHTOOL_MSG_LINKSTATE_GET_REPLY
        ETHTOOL_A_LINKSTATE_HEADER
            ETHTOOL_A_HEADER_DEV_INDEX = 8
            ETHTOOL_A_HEADER_DEV_NAME = "green"
        ETHTOOL_A_LINKSTATE_LINK = on
	Link detected: yes
received genetlink packet (36 bytes):
    msg length 36 error errno=0


I also get similar results from a USB-Ethernet Dongle:

# ethtool enx0050b61b0207
Settings for enx0050b61b0207:
	Supported ports: [ TP MII ]
	Supported link modes:   10baseT/Half 10baseT/Full 
	                        100baseT/Half 100baseT/Full 
	Supported pause frame use: No
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  10baseT/Half 10baseT/Full 
	                        100baseT/Half 100baseT/Full 
	Advertised pause frame use: Symmetric
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  10baseT/Half 10baseT/Full 
	                                     100baseT/Half 100baseT/Full 
	Link partner advertised pause frame use: Symmetric
	Link partner advertised auto-negotiation: Yes
	Link partner advertised FEC modes: Not reported
	Speed: 100Mb/s
	Duplex: Full
	Port: MII
	PHYAD: 16
	Transceiver: internal
	Auto-negotiation: on
	Supports Wake-on: pg
	Wake-on: p
	Current message level: 0x00000007 (7)
			       drv probe link
	Link detected: yes


# /home/andrew/ethtool/ethtool enx0050b61b0207
Settings for enx0050b61b0207:
	Supported ports: [ TP	 MII ]
	Supported link modes:   10baseT/Half 10baseT/Full
	                        100baseT/Half 100baseT/Full
	Supported pause frame use: No
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  10baseT/Half 10baseT/Full
	                        100baseT/Half 100baseT/Full
	Advertised pause frame use: No
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  Not reported
	Link partner advertised pause frame use: No
	Link partner advertised auto-negotiation: No
	Link partner advertised FEC modes: No
	Speed: 100Mb/s
	Duplex: Full
	Auto-negotiation: on
	Port: MII
	PHYAD: 16
	Transceiver: internal
	Supports Wake-on: pg
	Wake-on: p
        Current message level: 0x00000007 (7)
                               drv probe link
	Link detected: yes
