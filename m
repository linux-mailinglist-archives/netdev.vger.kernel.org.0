Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690B82EFC73
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbhAIAvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:51:02 -0500
Received: from mga03.intel.com ([134.134.136.65]:32272 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbhAIAvC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 19:51:02 -0500
IronPort-SDR: tdyugtTm/PdzUGReUEbqS3hapw7OKVgbV+QZnkjhdl2P8Ftm2r8Jk4vzceYi41P8lp1c0SxtpF
 aWkgCR5h6k1g==
X-IronPort-AV: E=McAfee;i="6000,8403,9858"; a="177771953"
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="177771953"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 16:48:09 -0800
IronPort-SDR: y+HCkJz99I1hhPipxieXLQ2DybTbETpTUJWM/ir0jkBDA4f1vYMxWUR+f8VgU5ughwnCn3N8IN
 llviz+iXXMfA==
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="423124497"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.251.4.171])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 16:48:09 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.01.org
Subject: [PATCH net-next 0/8] MPTCP: Add MP_PRIO support and rework local address IDs
Date:   Fri,  8 Jan 2021 16:47:54 -0800
Message-Id: <20210109004802.341602-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are some patches we've merged in the MPTCP tree that are ready for
net-next.

Patches 1 and 2 rework the assignment of local address IDs to allow them
to be assigned by a userspace path manager, and add corresponding self
tests.

Patches 2-8 add the ability to change subflow priority after a subflow
has been established. Each subflow in a MPTCP connection has a priority
level: "regular" or "backup". Data should only be sent on backup
subflows if no regular subflows are available. The priority level can be
set when the subflow connection is established (as was already
implemented), or during the life of the connection by sending MP_PRIO in
the TCP options (as added here). Self tests are included.


Geliang Tang (8):
  mptcp: add the address ID assignment bitmap
  selftests: mptcp: add testcases for setting the address ID
  mptcp: add the outgoing MP_PRIO support
  mptcp: add the incoming MP_PRIO support
  mptcp: add set_flags command in PM netlink
  selftests: mptcp: add set_flags command in pm_nl_ctl
  mptcp: add the mibs for MP_PRIO
  selftests: mptcp: add the MP_PRIO testcases

 include/uapi/linux/mptcp.h                    |   1 +
 net/mptcp/mib.c                               |   2 +
 net/mptcp/mib.h                               |   2 +
 net/mptcp/options.c                           |  56 ++++++
 net/mptcp/pm.c                                |   8 +
 net/mptcp/pm_netlink.c                        | 172 ++++++++++++++++--
 net/mptcp/protocol.h                          |  11 ++
 .../testing/selftests/net/mptcp/mptcp_join.sh |  72 +++++++-
 .../testing/selftests/net/mptcp/pm_netlink.sh |  41 ++++-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c |  87 ++++++++-
 10 files changed, 430 insertions(+), 22 deletions(-)


base-commit: 833d22f2f922bbee6430e558417af060db6bbe9c
-- 
2.30.0

