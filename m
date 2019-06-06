Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71FCB37B6B
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 19:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbfFFRvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 13:51:08 -0400
Received: from mga06.intel.com ([134.134.136.31]:29817 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728682AbfFFRvI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 13:51:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 10:51:07 -0700
X-ExtLoop1: 1
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga003.jf.intel.com with ESMTP; 06 Jun 2019 10:51:07 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jeffrey.t.kirsher@intel.com, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        intel-wired-lan@lists.osuosl.org, vinicius.gomes@intel.com,
        l@dorileo.org, jakub.kicinski@netronome.com, m-karicheri2@ti.com,
        Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH net-next v2 0/6] net/sched: Add txtime-assist support for taprio.
Date:   Thu,  6 Jun 2019 10:50:52 -0700
Message-Id: <1559843458-12517-1-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes from last version:
- Txtime-offload has now been renamed to txtime-assist mode.
- Renamed the offload parameter to flags.
- Removed the code which introduced the hardware offloading functionality.

Original Cover letter (with above changes included)
--------------------------------------------------

Currently, we are seeing packets being transmitted outside their
timeslices. We can confirm that the packets are being dequeued at the right
time. So, the delay is induced after the packet is dequeued, because
taprio, without any offloading, has no control of when a packet is actually
transmitted.

In order to solve this, we are making use of the txtime feature provided by
ETF qdisc. Hardware offloading needs to be supported by the ETF qdisc in
order to take advantage of this feature. The taprio qdisc will assign
txtime (in skb->tstamp) for all the packets which do not have the txtime
allocated via the SO_TXTIME socket option. For the packets which already
have SO_TXTIME set, taprio will validate whether the packet will be
transmitted in the correct interval.

In order to support this, the following parameters have been added:
- flags (taprio): This is added in order to support different offloading
  modes which will be added in the future.
- txtime-delay (taprio): This indicates the minimum time it will take for
  the packet to hit the wire after it reaches taprio_enqueue(). This is
  useful in determining whether we can transmit the packet in the remaining
  time if the gate corresponding to the packet is currently open.
- skip_skb_check (ETF): ETF currently drops any packet which does not have
  the SO_TXTIME socket option set. This check can be skipped by specifying
  this option.

Following is an example configuration:

tc qdisc replace dev $IFACE parent root handle 100 taprio \\
    num_tc 3 \\
    map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \\
    queues 1@0 1@0 1@0 \\
    base-time $BASE_TIME \\
    sched-entry S 01 300000 \\
    sched-entry S 02 300000 \\
    sched-entry S 04 400000 \\
    flags 0x1 \\
    txtime-delay 200000 \\
    clockid CLOCK_TAI

tc qdisc replace dev $IFACE parent 100:1 etf \\
    offload delta 200000 clockid CLOCK_TAI skip_skb_check

Here, the "flags" parameter is indicating that the txtime-assist mode is
enabled. Also, all the traffic classes have been assigned the same queue.
This is to prevent the traffic classes in the lower priority queues from
getting starved. Note that this configuration is specific to the i210
ethernet card. Other network cards where the hardware queues are given the
same priority, might be able to utilize more than one queue.

Following are some of the other highlights of the series:
- Fix a bug where hardware timestamping and SO_TXTIME options cannot be
  used together. (Patch 1)
- Introduces the skip_skb_check option.  (Patch 2)
- Make TxTime assist mode work with TCP packets (Patch 7).

The following changes are recommended to be done in order to get the best
performance from taprio in this mode:
# TSN in general does not allow Jumbo frames.
ip link set dev enp1s0 mtu 1514
# Disable segmentation offload. This is to prevent NIC from sending packets
# after the gate for a traffic class has closed.
ethtool -K eth0 gso off 
ethtool -K eth0 tso off
# Disable energy efficient ethernet to make sure there are no latency
# spikes when NIC is trying to wake up when the packet is supposed to be
# sent.
ethtool --set-eee eth0 eee off

Thanks,
Vedang Patel


Vedang Patel (6):
  igb: clear out tstamp after sending the packet.
  etf: Add skip_sock_check
  taprio: calculate cycle_time when schedule is installed
  taprio: Add support for txtime-assist mode.
  taprio: make clock reference conversions easier
  taprio: Adjust timestamps for TCP packets.

 drivers/net/ethernet/intel/igb/igb_main.c |   1 +
 include/uapi/linux/pkt_sched.h            |   5 +
 net/sched/sch_etf.c                       |  10 +
 net/sched/sch_taprio.c                    | 424 +++++++++++++++++++++++++++---
 4 files changed, 406 insertions(+), 34 deletions(-)

-- 
2.7.3

