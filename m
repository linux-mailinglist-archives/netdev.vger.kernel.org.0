Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F16B28C57A
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 01:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389308AbgJLX46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 19:56:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:19408 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728821AbgJLX46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 19:56:58 -0400
IronPort-SDR: wDVolbnI/UjZG9d1FzdB8MSVpwjFyDL5UL0c1IaxqsruwQmDxQPD1jGE9cXXJi2JJuHjUF58YX
 5QAT4xMwiFDA==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="152751180"
X-IronPort-AV: E=Sophos;i="5.77,368,1596524400"; 
   d="scan'208";a="152751180"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 16:56:57 -0700
IronPort-SDR: xPVQhOPceXpnJT8goQG4U2hbe5Y/+UsfrAeZquRHORMMtDnCNYnPG8fOA6yU2NkBgpyoQGHbyn
 hxU8ia543Zqw==
X-IronPort-AV: E=Sophos;i="5.77,368,1596524400"; 
   d="scan'208";a="520847727"
Received: from aravindh-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.209.37.143])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 16:56:56 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com
Subject: [RFC net-next v2 0/2] ethtool: Add support for frame preemption
Date:   Mon, 12 Oct 2020 16:56:40 -0700
Message-Id: <20201012235642.1384318-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Changes from v1:
 - The per-queue preemptible/express setting is moved to applicable
   qdiscs (Jakub Kicinski and others);
 - "min-frag-size" now follows the 802.3br specification more closely,
   it's expressed as X in '64(1 + X) + 4' (Joergen Andreasen)

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
queues are marked as preemptible, in this example, queue 0 is marked
as "not preemptible", so it is express, the rest of the four queues
are preemptible.

The next step, of this example, would be to enable frame preemption in
the device, via ethtool, and set the minimum fragment size to 2:

$ sudo ./ethtool --set-frame-preemption $IFACE fp on min-frag-size 2


Cheers,


Vinicius Costa Gomes (2):
  ethtool: Add support for configuring frame preemption
  taprio: Add support for frame preemption offload

 include/linux/ethtool.h              |  19 ++++
 include/linux/netdevice.h            |   1 +
 include/net/pkt_sched.h              |   4 +
 include/uapi/linux/ethtool_netlink.h |  17 +++
 include/uapi/linux/pkt_sched.h       |   1 +
 net/ethtool/Makefile                 |   2 +-
 net/ethtool/netlink.c                |  19 ++++
 net/ethtool/netlink.h                |   4 +
 net/ethtool/preempt.c                | 151 +++++++++++++++++++++++++++
 net/sched/sch_taprio.c               |  41 +++++++-
 10 files changed, 254 insertions(+), 5 deletions(-)
 create mode 100644 net/ethtool/preempt.c

-- 
2.28.0

