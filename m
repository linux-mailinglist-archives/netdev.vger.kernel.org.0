Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71603EA4B3
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 21:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfJ3U1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 16:27:41 -0400
Received: from plaes.org ([188.166.43.21]:60120 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbfJ3U1k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 16:27:40 -0400
Received: from plaes.org (localhost [127.0.0.1])
        by plaes.org (Postfix) with ESMTPSA id 2AD8D40190;
        Wed, 30 Oct 2019 20:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1572466878; bh=kXPINGcgLrjVjnsgDRwZu5/Oh1nSzsnDe6iSE0gDq5Q=;
        h=Date:From:To:Cc:Subject:From;
        b=JHuO79foOHdtbew0PYC/7+0T/7BzSNupYvfEkRKA2lCkDkOKl2pfo4NCYRNxA5oNC
         cXqJdotJoRoIV5YuWHX3m22wKP15zKNCswGsmPevTr7qyrXIpdZFOYw5qPabcGR8KC
         U/7gKOxBuoytVKjZOZg6wKikSxGiXqaEIEpZzOpl30S63b4ypVxqZaRW9h3CAy16gO
         vmY2NUApe070AQuP5rDYZR2oomNb2ydaMqpcqXRPJ5Fw+Ds5bZDrDkCJqCu7UJaQR+
         LsD03rziohQkRCzmw1GmfjqpRtnuAZ0bMic5Q5+xYLjg7JeaB6088gIA0p1R09j2ld
         2InpXDuv48wPA==
Date:   Wed, 30 Oct 2019 20:21:17 +0000
From:   Priit Laes <plaes@plaes.org>
To:     linux-sunxi@googlegroups.com, wens@csie.org,
        netdev@vger.kernel.org, plaes@plaes.org
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com
Subject: sun7i-dwmac: link detection failure with 1000Mbit parters
Message-ID: <20191030202117.GA29022@plaes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heya!

I have noticed that with sun7i-dwmac driver (OLinuxino Lime2 eMMC), link
detection fails consistently with certain 1000Mbit partners (for example Huawei
B525s-23a 4g modem ethernet outputs and RTL8153-based USB3.0 ethernet dongle),
but the same hardware works properly with certain other link partners (100Mbit GL AR150
for example).

(Just need to test with another 1000Mbit switch at the office).

I first thought it could be a regression, but I went from current master to as far back
as 5.2.0-rc6 where it was still broken.

Failure is basically following:

[   10.971485] sun7i-dwmac 1c50000.ethernet eth0: PHY [stmmac-0:01] driver [Generic PHY]
[   10.980841] sun7i-dwmac 1c50000.ethernet eth0: No Safety Features support found
[   10.988291] sun7i-dwmac 1c50000.ethernet eth0: RX IPC Checksum Offload disabled
[   10.995694] sun7i-dwmac 1c50000.ethernet eth0: No MAC Management Counters available
[   11.003381] sun7i-dwmac 1c50000.ethernet eth0: PTP not supported by HW
[   11.009927] sun7i-dwmac 1c50000.ethernet eth0: configuring for phy/rgmii link mode
... link and activity leds go blank ...
... remove and replug and link is detected again ...
[   19.371894] sun7i-dwmac 1c50000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx

Ethtool output in case link is down:
[snip]
	Supported ports: [ TP MII ]
	Supported link modes:   10baseT/Half 10baseT/Full 
	                        100baseT/Half 100baseT/Full 
	                        1000baseT/Half 1000baseT/Full 
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  10baseT/Half 10baseT/Full 
	                        100baseT/Half 100baseT/Full 
	                        1000baseT/Half 1000baseT/Full 
	Advertised pause frame use: Symmetric Receive-only
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Speed: Unknown!
	Duplex: Unknown! (255)
	Port: MII
	PHYAD: 1
	Transceiver: internal
	Auto-negotiation: on
	Supports Wake-on: d
	Wake-on: d
	Current message level: 0x0000003f (63)
			       drv probe link timer ifdown ifup
	Link detected: no
[/snip]

And ethtool output in case cable is removed and replugged:
[snip]
ethtool eth0
Settings for eth0:
	...cut...
	Advertised pause frame use: Symmetric Receive-only
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  10baseT/Half 10baseT/Full 
	                                     100baseT/Half 100baseT/Full 
	                                     1000baseT/Full 
	Link partner advertised pause frame use: Symmetric
	Link partner advertised auto-negotiation: Yes
	Link partner advertised FEC modes: Not reported
	Speed: 1000Mb/s
	Duplex: Full
	Port: MII
	PHYAD: 1
	Transceiver: internal
	Auto-negotiation: on
	Supports Wake-on: d
	Wake-on: d
	Current message level: 0x0000003f (63)
			       drv probe link timer ifdown ifup
	Link detected: yes
[/snip]


With 100Mbit link partner (GL Inet AR150), the link is pulled up almost
immediately:
[   15.531754] sun7i-dwmac 1c50000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx

[snip]
Settings for eth0:
	... cut ...
	Link partner advertised link modes:  10baseT/Half 10baseT/Full 
	                                     100baseT/Half 100baseT/Full 
	Link partner advertised pause frame use: Symmetric Receive-only
	Link partner advertised auto-negotiation: Yes
	Link partner advertised FEC modes: Not reported
	Speed: 100Mb/s
	Duplex: Full
	Port: MII
	PHYAD: 1
	Transceiver: internal
	Auto-negotiation: on
	Supports Wake-on: d
	Wake-on: d
	Current message level: 0x0000003f (63)
			       drv probe link timer ifdown ifup
	Link detected: yes
[/snip]

