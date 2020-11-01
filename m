Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A77B2A2208
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 23:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgKAWPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 17:15:44 -0500
Received: from mailout04.rmx.de ([94.199.90.94]:52770 "EHLO mailout04.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727009AbgKAWPo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 17:15:44 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout04.rmx.de (Postfix) with ESMTPS id 4CPVjl1pBmz3qjlg;
        Sun,  1 Nov 2020 23:15:39 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CPVjV3ym7z2TRlZ;
        Sun,  1 Nov 2020 23:15:26 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.12) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Sun, 1 Nov
 2020 23:14:25 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add hardware time stamping support
Date:   Sun, 1 Nov 2020 23:14:24 +0100
Message-ID: <3355013.oZEI4y40TO@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201101111008.vl4lj4iqmqjdpbyg@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de> <4928494.XgmExmOR0V@n95hx1g2> <20201101111008.vl4lj4iqmqjdpbyg@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.12]
X-RMX-ID: 20201101-231526-4CPVjV3ym7z2TRlZ-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sunday, 1 November 2020, 12:10:08 CET, Vladimir Oltean wrote:
> On Sun, Nov 01, 2020 at 10:35:01AM +0100, Christian Eggers wrote:
> > Hi Vladimir,
> > 
> > On Friday, 30 October 2020, 19:24:47 CET, Vladimir Oltean wrote:
> > > On Thu, Oct 22, 2020 at 12:17:48PM +0200, Christian Eggers wrote:
> > > > I tried to study the effect of setting the ocmode bit on the KSZ
> > > > either to
> > > > master or to slave. The main visible change is, that some PTP message
> > > > types
> > > > are be filtered out on RX:
> > > > - in "master" mode, "Sync" messages from other nodes will not be
> > > > received
> > > > (but everything else like "Announce" seem to work)
> > > > - in "slave" mode, "Delay_Req" messages from other nodes will not be
> > > > received
> > > 
> > > Could you dump the contents of your REG_PTP_MSG_CONF2 register?
> > 
> > runtime register value is 0x1004 (matches default value from the data
> > sheet). The Linux driver doesn't touch this register. Below is a dump of
> > all PTP related (global) registers.
> 
> So the bit 5 ("Enable Dropping of Sync/Follow_Up and Delay_Req PTP
> Messages") is not set. When the PTP messages are dropped, do you know
> which error counter in ethtool -S is increasing?
I am not sure whether I understand the question. My assumption is that the
KSZ9563 simply doesn't forward specific PTP packages from the slave ports to 
the CPU port. In my imagination this happens in hardware and is not visible in
software.

I have run "ethtool -S" two times on the PTP master clock (E2E mode):
- When "ocmode" is set to master (DelayReq messages can be received)
- When "ocmode" is set to slave (DelayReq messages cannot be received)

Here is the diff output:
--- /home/root/ethtool1
+++ /home/root/ethtool2
@@ -1,8 +1,8 @@
 NIC statistics:
-     tx_packets: 1421
-     tx_bytes: 133641
-     rx_packets: 488
-     rx_bytes: 35904
+     tx_packets: 1455
+     tx_bytes: 136783
+     rx_packets: 496
+     rx_bytes: 36459
      rx_hi: 0
      rx_undersize: 0
      rx_fragments: 0
@@ -14,10 +14,10 @@
      rx_mac_ctrl: 0
      rx_pause: 0
      rx_bcast: 4
-     rx_mcast: 667
+     rx_mcast: 683
      rx_ucast: 0
      rx_64_or_less: 0
-     rx_65_127: 659
+     rx_65_127: 675
      rx_128_255: 11
      rx_256_511: 1
      rx_512_1023: 0
@@ -27,15 +27,15 @@
      tx_hi: 0
      tx_late_col: 0
      tx_pause: 0
-     tx_bcast: 713
-     tx_mcast: 1852
-     tx_ucast: 324
+     tx_bcast: 733
+     tx_mcast: 1897
+     tx_ucast: 333
      tx_deferred: 0
      tx_total_col: 0
      tx_exc_col: 0
      tx_single_col: 0
      tx_mult_col: 0
-     rx_total: 61158
-     tx_total: 307225
+     rx_total: 62577
+     tx_total: 313773
      rx_discards: 20
      tx_discards: 0

regards
Christian



