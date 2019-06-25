Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D90055A97
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfFYWHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:07:25 -0400
Received: from mga12.intel.com ([192.55.52.136]:34253 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbfFYWHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 18:07:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jun 2019 15:07:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,417,1557212400"; 
   d="scan'208";a="172511920"
Received: from vpatel-desk.jf.intel.com (HELO localhost.localdomain) ([10.7.159.52])
  by orsmga002.jf.intel.com with ESMTP; 25 Jun 2019 15:07:24 -0700
From:   Vedang Patel <vedang.patel@intel.com>
To:     netdev@vger.kernel.org
Cc:     jeffrey.t.kirsher@intel.com, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        intel-wired-lan@lists.osuosl.org, vinicius.gomes@intel.com,
        l@dorileo.org, jakub.kicinski@netronome.com, m-karicheri2@ti.com,
        sergei.shtylyov@cogentembedded.com, eric.dumazet@gmail.com,
        aaron.f.brown@intel.com, Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH net-next v6 0/8] net/sched: Add txtime-assist support for taprio.
Date:   Tue, 25 Jun 2019 15:07:11 -0700
Message-Id: <1561500439-30276-1-git-send-email-vedang.patel@intel.com>
X-Mailer: git-send-email 2.7.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v6:
- Use _BITUL() instead of BIT() in UAPI for etf. (patch #1)
- Fix a bug reported by kbuild test bot in length_to_duration(). (patch #6)
- Remove an unused function (get_cycle_start()). (Patch #6)

Changes in v5:
- Commit message improved for the igb patch (patch #1).
- Fixed typo in commit message for etf patch (patch #2).

Changes in v4:
- Remove inline directive from functions in foo.c.
- Fix spacing in pkt_sched.h (for etf patch).

Changes in v3:
- Simplify implementation for taprio flags. 
- txtime_delay can only be set if txtime-assist mode is enabled.
- txtime_delay and flags will only be visible in tc output if set by user.
- Minor changes in error reporting.

Changes in v2:
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

Vedang Patel (8):
  igb: clear out skb->tstamp after reading the txtime
  etf: Don't use BIT() in UAPI headers.
  etf: Add skip_sock_check
  taprio: calculate cycle_time when schedule is installed
  taprio: Remove inline directive
  taprio: Add support for txtime-assist mode
  taprio: make clock reference conversions easier
  taprio: Adjust timestamps for TCP packets

 drivers/net/ethernet/intel/igb/igb_main.c |   1 +
 include/uapi/linux/pkt_sched.h            |   9 +-
 net/sched/sch_etf.c                       |  10 +
 net/sched/sch_taprio.c                    | 421 +++++++++++++++++++++++++++---
 4 files changed, 405 insertions(+), 36 deletions(-)

-- 
2.7.3

