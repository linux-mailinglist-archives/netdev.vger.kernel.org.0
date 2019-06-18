Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4604A4A8E7
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbfFRR5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:57:25 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:48483 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729285AbfFRR5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 13:57:25 -0400
Received: from [5.158.153.53] (helo=nereus.lab.linutronix.de.)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <b.spranger@linutronix.de>)
        id 1hdIME-0006l3-TI; Tue, 18 Jun 2019 19:57:23 +0200
From:   Benedikt Spranger <b.spranger@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     Benedikt Spranger <b.spranger@linutronix.de>
Subject: [RFC PATCH 0/2] enable broadcom tagging for bcm531x5 switches
Date:   Tue, 18 Jun 2019 19:57:10 +0200
Message-Id: <20190618175712.71148-1-b.spranger@linutronix.de>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

while puting a Banana Pi R1 board into operation I faced network hickups
and get into serious trouble from my coworkers:

Banana Pi network setup:
PC (eth1) <--> BPi R1 (wan) / BPi R1 (lan4) <--> DUT (eth0)
10.0.32.1      10.0.32.2      172.16.0.1         172.16.0.2
---8<---
#! /bin/bash

# create VLANs
ip link add link eth0 name eth0.1 type vlan id 1
ip link add link eth0 name eth0.100 type vlan id 100

# create bridges
ip link add br0 type bridge
ip link set dev br0 type bridge vlan_filtering 1

ip link add br1 type bridge
ip link set dev br1 type bridge vlan_filtering 1

# add interfaces to bridges
ip link set lan1 master br0
ip link set lan2 master br0
ip link set lan3 master br0
ip link set lan4 master br0
ip link set eth0.100 master br0

ip link set wan master br1

# adjust tagging
bridge vlan add dev lan1 vid 100 pvid untagged
bridge vlan add dev lan2 vid 100 pvid untagged
bridge vlan add dev lan3 vid 100 pvid untagged
bridge vlan add dev lan4 vid 100 pvid untagged

bridge vlan del dev lan1 vid 1
bridge vlan del dev lan2 vid 1
bridge vlan del dev lan3 vid 1
bridge vlan del dev lan4 vid 1

# set IPs
ip addr add 10.0.32.2/24 dev eth0.1
ip addr add 172.16.0.1/24 dev br0

# up and run
ip link set eth0 up
ip link set eth0.1 up
ip link set eth0.100 up

ip link set br0 up
ip link set br1 up

ip link set wan up

ip link set lan1 up
ip link set lan2 up
ip link set lan3 up
ip link set lan4 up
---8<---

While trying to ping a non existing host 10.0.32.111 result in
doublication of ARP broadcasts:

On the BPi R1:
# tshark -i br0
    1 8.157471671 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111?
 Tell 10.0.32.1
    2 9.167563213 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111?
 Tell 10.0.32.1
    3 10.191703047 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111
? Tell 10.0.32.1
    4 11.215905797 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111
? Tell 10.0.32.1
    5 12.243932964 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111
? Tell 10.0.32.1
    6 13.264033298 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111
? Tell 10.0.32.1

# tshark -i wan0
    1 8.157421295 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111?
 Tell 10.0.32.1
    2 9.167510087 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111?
 Tell 10.0.32.1
    3 10.191649213 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111
? Tell 10.0.32.1
    4 11.215856838 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111
? Tell 10.0.32.1
    5 12.243881922 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111
? Tell 10.0.32.1
    6 13.263981506 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111
? Tell 10.0.32.1

On the PC:
# tshark -i eth1
  116 272.660717059 DavicomS_43:18:fc → Broadcast    ARP 42 Who has 10.0.32.111? Tell 10.0.32.1
  117 272.661062292 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111? Tell 10.0.32.1
  118 273.670690338 DavicomS_43:18:fc → Broadcast    ARP 42 Who has 10.0.32.111? Tell 10.0.32.1
  119 273.671058605 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111? Tell 10.0.32.1
  120 274.694720511 DavicomS_43:18:fc → Broadcast    ARP 42 Who has 10.0.32.111? Tell 10.0.32.1
  121 274.695250723 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111? Tell 10.0.32.1
  122 275.718813538 DavicomS_43:18:fc → Broadcast    ARP 42 Who has 10.0.32.111? Tell 10.0.32.1
  123 275.719285852 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111? Tell 10.0.32.1
  124 276.746729795 DavicomS_43:18:fc → Broadcast    ARP 42 Who has 10.0.32.111? Tell 10.0.32.1
  125 276.747236341 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111? Tell 10.0.32.1
  126 277.766722429 DavicomS_43:18:fc → Broadcast    ARP 42 Who has 10.0.32.111? Tell 10.0.32.1
  127 277.767233098 DavicomS_43:18:fc → Broadcast    ARP 60 Who has 10.0.32.111? Tell 10.0.32.1

Choosing between network disturbance by mirrored broadcast packages (and angry
coworkers) or lack of multicast, I choose the later. 

Regards
    Bene Spranger

Florian Fainelli (1):
  net: dsa: b53: Turn on managed mode and set IMP port

Sebastian Andrzej Siewior (1):
  net: dsa: b53: enbale broadcom tags on bcm531x5

 drivers/net/dsa/b53/b53_common.c | 21 ++++++++++++++++-----
 drivers/net/dsa/bcm_sf2.c        |  3 ---
 2 files changed, 16 insertions(+), 8 deletions(-)

-- 
2.19.0

