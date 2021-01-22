Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F7C301048
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 23:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbhAVWr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 17:47:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:1524 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728163AbhAVWqH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 17:46:07 -0500
IronPort-SDR: lcYc7/eEBpbgqCPvnj4Mc/xBEGa1W5pne/5Bkdso4k+BXNGZQhb5PLAjpJFiCln/Dws1NLY2O+
 euFyU281r1DQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="166619674"
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="166619674"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 14:45:20 -0800
IronPort-SDR: xlC4TomIoJO/k4fLoXd9rLkko6uCMkFZ1sCqr48hzfvFtY/tShH05o1Q1p3fRu1nHTt1xRuxwT
 fwXWGIX96kog==
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="355390552"
Received: from apalur-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.155.78])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 14:45:19 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        vladimir.oltean@nxp.com, Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: [PATCH net-next v3 0/8] ethtool: Add support for frame preemption
Date:   Fri, 22 Jan 2021 14:44:45 -0800
Message-Id: <20210122224453.4161729-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Changes from v2:
 - Fixed some copy&paste mistakes, documentation formatting and
   slightly improved error reporting (Jakub Kicinski);

Changes from v1:
 - The minimum fragment size configuration was changed to be
   configured in bytes to be more future proof, in case the standard
   changes this (the previous definition was '(X + 1) * 64', X being
   [0..3]) (Michal Kubecek);
 - In taprio, frame preemption is now configured by traffic classes (was
   done by queues) (Jakub Kicinski, Vladimir Oltean);
 - Various netlink protocol validation improvements (Jakub Kicinski);
 - Dropped the IGC register dump for frame preemption registers, until a
   stardandized way of exposing that is agreed (Jakub Kicinski);

Changes from RFC v2:
 - Reorganised the offload enabling/disabling on the driver size;
 - Added a few igc fixes;

Changes from RFC v1:
 - The per-queue preemptible/express setting is moved to applicable
   qdiscs (Jakub Kicinski and others);
 - "min-frag-size" now follows the 802.3br specification more closely,
   it's expressed as X in '64(1 + X) + 4' (Joergen Andreasen);

Another point that should be noted is the addition of the
TC_SETUP_PREEMPT offload type, the idea behind this is to allow other
qdiscs (was thinking of mqprio) to also configure which traffic
classes should be marked as express/preemptible.

Original cover letter (lightly edited):

This is still an RFC because two main reasons, I want to confirm that
this approach (per-queue settings via qdiscs, device settings via
ethtool) looks good, even though there aren't much more options left ;-)
The other reason is that while testing this I found some weirdness
in the driver that I would need a bit more time to investigate.

(In case these patches are not enough to give an idea of how things
work, I can send the userspace patches, of course.)

The idea of this "hybrid" approach is that applications/users would do
the following steps to configure frame preemption:

$ tc qdisc replace dev $IFACE parent root handle 100 taprio \
      num_tc 3 \
      map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
      queues 1@0 1@1 2@2 \
      base-time $BASE_TIME \
      sched-entry S 0f 10000000 \
      preempt 1110 \
      flags 0x2 

The "preempt" parameter is the only difference, it configures which
traffic classes are marked as preemptible, in this example, traffic
class 0 is marked as "not preemptible", so it is express, the rest of
the four traffic classes are preemptible.

The next step, of this example, would be to enable frame preemption in
the device, via ethtool, and set the minimum fragment size to 192 bytes:

$ sudo ./ethtool --set-frame-preemption $IFACE fp on min-frag-size 192

Cheers,

Vinicius Costa Gomes (8):
  ethtool: Add support for configuring frame preemption
  taprio: Add support for frame preemption offload
  igc: Set the RX packet buffer size for TSN mode
  igc: Only dump registers if configured to dump HW information
  igc: Avoid TX Hangs because long cycles
  igc: Add support for tuning frame preemption via ethtool
  igc: Add support for Frame Preemption offload
  igc: Separate TSN configurations that can be updated

 Documentation/networking/ethtool-netlink.rst |  38 +++++
 drivers/net/ethernet/intel/igc/igc.h         |  12 ++
 drivers/net/ethernet/intel/igc/igc_defines.h |   6 +
 drivers/net/ethernet/intel/igc/igc_dump.c    |   3 +
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  53 ++++++
 drivers/net/ethernet/intel/igc/igc_main.c    |  31 +++-
 drivers/net/ethernet/intel/igc/igc_tsn.c     | 162 ++++++++++++++-----
 drivers/net/ethernet/intel/igc/igc_tsn.h     |   1 +
 include/linux/ethtool.h                      |  23 ++-
 include/linux/netdevice.h                    |   1 +
 include/net/pkt_sched.h                      |   4 +
 include/uapi/linux/ethtool_netlink.h         |  17 ++
 include/uapi/linux/pkt_sched.h               |   1 +
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/common.c                         |  25 +++
 net/ethtool/netlink.c                        |  19 +++
 net/ethtool/netlink.h                        |   4 +
 net/ethtool/preempt.c                        | 146 +++++++++++++++++
 net/sched/sch_taprio.c                       |  43 ++++-
 19 files changed, 539 insertions(+), 52 deletions(-)
 create mode 100644 net/ethtool/preempt.c

-- 
2.30.0

