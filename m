Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CBD1D14C2
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 15:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387735AbgEMN0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 09:26:20 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:40714 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727792AbgEMN0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 09:26:19 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04DDQG0i118996;
        Wed, 13 May 2020 08:26:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589376376;
        bh=+e0mbSlpXXz27VKNTKjsJZwfHqlIfU65rOvu1CND0/8=;
        h=From:To:Subject:Date;
        b=o809UpepJP1zcTHnd3Xlt3a0t8lmasZ4Fgd8AZFEVkx7vPqRnmggOB/77HXhT3c6Q
         AwTfZL4pw16iYI57t5sF5AFFS8rr322ToKdujLnguZcLbLwISaLebanmOO/Ea+GI8X
         si8tK6XB3X+FADz8HMfBNkesDNoxAnFkNJvsahqk=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04DDQGGC096817;
        Wed, 13 May 2020 08:26:16 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 13
 May 2020 08:26:15 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 13 May 2020 08:26:16 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04DDQF4H074601;
        Wed, 13 May 2020 08:26:15 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <grygorii.strashko@ti.com>,
        <ilias.apalodimas@linaro.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <nsekhar@ti.com>
Subject: [PATCH net-next 0/2] am65-cpsw: add taprio/EST offload support
Date:   Wed, 13 May 2020 09:26:13 -0400
Message-ID: <20200513132615.16299-1-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AM65 CPSW h/w supports Enhanced Scheduled Traffic (EST – defined
in P802.1Qbv/D2.2 that later got included in IEEE 802.1Q-2018)
configuration. EST allows express queue traffic to be scheduled
(placed) on the wire at specific repeatable time intervals. In
Linux kernel, EST configuration is done through tc command and
the taprio scheduler in the net core implements a software only
scheduler (SCH_TAPRIO). If the NIC is capable of EST configuration,
user indicate "flag 2" in the command which is then parsed by
taprio scheduler in net core and indicate that the command is to
be offloaded to h/w. taprio then offloads the command to the
driver by calling ndo_setup_tc() ndo ops. This patch implements
ndo_setup_tc() as well as other changes required to offload EST
configuration to CPSW h/w

For more details please refer patch 2/2.

This series is based on original work done by Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> to add taprio offload support to
AM65 CPSW 2G. 

1. Example configuration 3 Gates

ifconfig eth0 down
ethtool -L eth0 tx 3

#disable rrobin
ethtool --set-priv-flags eth0 p0-rx-ptype-rrobin off

ifconfig eth0 192.168.2.20

tc qdisc replace dev eth0 parent root handle 100 taprio \
    num_tc 3 \
    map 0 0 1 2 0 0 0 0 0 0 0 0 0 0 0 0 \
    queues 1@0 1@1 1@2 \
    base-time 0000 \
    sched-entry S 4 125000 \
    sched-entry S 2 125000 \
    sched-entry S 1 250000 \
    flags 2

2. Example configuration 8 Gates 

ifconfig eth0 down
ethtool -L eth0 tx 8

#disable rrobin
ethtool --set-priv-flags eth0 p0-rx-ptype-rrobin off

ifconfig eth0 192.168.2.20

tc qdisc replace dev eth0 parent root handle 100 taprio \
    num_tc 8 \
    map 0 1 2 3 4 5 6 7 0 0 0 0 0 0 0 0 \
    queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
    base-time 0000 \
    sched-entry S 80 125000 \
    sched-entry S 40 125000 \
    sched-entry S 20 125000 \
    sched-entry S 10 125000 \
    sched-entry S 08 125000 \
    sched-entry S 04 125000 \
    sched-entry S 02 125000 \
    sched-entry S 01 125000 \
    flags 2


Classify frames to particular priority using skbedit so that they land at
a specific queue in cpsw h/w which is Gated by the EST gate which opens based
on the sched-entry. 

tc qdisc add dev eth0 clsact

In the below for example an iperf3 session with destination port 5007
will go through Q7.

# Assume case 1: 8 TCs as per the second tc command listed above
# Assign packet prio 7 for port 5007 -> hw_prio 7
tc filter add dev eth0 egress protocol ip prio 1 u32 match ip dport 5007 0xffff action skbedit priority 7

# Similarly, assign packet prio 6 for port 5006 -> hw_prio 6 and so forth
tc filter add dev eth0 egress protocol ip prio 1 u32 match ip dport 5006 0xffff action skbedit priority 6
tc filter add dev eth0 egress protocol ip prio 1 u32 match ip dport 5005 0xffff action skbedit priority 5
tc filter add dev eth0 egress protocol ip prio 1 u32 match ip dport 5004 0xffff action skbedit priority 4
tc filter add dev eth0 egress protocol ip prio 1 u32 match ip dport 5003 0xffff action skbedit priority 3
tc filter add dev eth0 egress protocol ip prio 1 u32 match ip dport 5002 0xffff action skbedit priority 2
tc filter add dev eth0 egress protocol ip prio 1 u32 match ip dport 5001 0xffff action skbedit priority 1

#send iperf3 udp traffic for port 5007 with iperf3 server running at
#a PC connected to the eth0 port

iperf3 -c 192.168.2.10 -u -l1470 -b32M -t1 -p 5007

Testing was done by capturing frames at the PC using wireshark and checking for
the bust interval or cycle time of UDP frames with a specific port number. 
Verified that the distance between first frame of a burst (cycle-time) is 1
milli second and burst duration is within 125 usec based on the received packet
timestamp shown in wireshark packet display. 

Ivan Khoronzhuk (2):
  ethernet: ti: am65-cpts: add routines to support taprio offload
  ethernet: ti: am65-cpsw-qos: add TAPRIO offload support

 drivers/net/ethernet/ti/Kconfig             |   9 +
 drivers/net/ethernet/ti/Makefile            |   2 +-
 drivers/net/ethernet/ti/am65-cpsw-ethtool.c |  12 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c    |   9 +
 drivers/net/ethernet/ti/am65-cpsw-nuss.h    |   5 +
 drivers/net/ethernet/ti/am65-cpsw-qos.c     | 626 ++++++++++++++++++++
 drivers/net/ethernet/ti/am65-cpsw-qos.h     |  29 +
 drivers/net/ethernet/ti/am65-cpts.c         |  48 ++
 drivers/net/ethernet/ti/am65-cpts.h         |  24 +
 9 files changed, 761 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/ti/am65-cpsw-qos.c
 create mode 100644 drivers/net/ethernet/ti/am65-cpsw-qos.h

-- 
2.17.1

