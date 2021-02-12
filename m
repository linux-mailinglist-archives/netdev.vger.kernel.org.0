Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C5331A883
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhBMAB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:01:58 -0500
Received: from mga06.intel.com ([134.134.136.31]:22718 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhBMAB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 19:01:58 -0500
IronPort-SDR: n7Ls1MHJ/aQpFbjGUe3BjkiJMaUHVz/nOfPoqCNJytbiYpd0QZkKgRdkiTTvMhTnUGDNdtqVMG
 bogrq1L8m6nA==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="243981686"
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="243981686"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 16:00:11 -0800
IronPort-SDR: pPj34du3RxWHys1xQfIQhLAIPaDMk40nClf7nLIGK9zeOqMFDOoRlo4kvK+C7AOEbSXEoMUG2c
 6NPOyntuHXcw==
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="423381106"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.85.171])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 16:00:10 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.01.org,
        matthieu.baerts@tessares.net
Subject: [PATCH net-next 0/8] mptcp: Add genl events for connection info
Date:   Fri, 12 Feb 2021 15:59:53 -0800
Message-Id: <20210213000001.379332-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series from the MPTCP tree adds genl multicast events that are
important for implementing a userspace path manager. In MPTCP, a path
manager is responsible for adding or removing additional subflows on
each MPTCP connection. The in-kernel path manager (already part of the
kernel) is a better fit for many server use cases, but the additional
flexibility of userspace path managers is often useful for client
devices.

Patches 1, 2, 4, 5, and 6 do some refactoring to streamline the netlink
event implementation in the final patch.

Patch 3 improves the timeliness of subflow destruction to ensure the
'subflow closed' event will be sent soon enough.

Patch 7 allows use of the GENL_UNS_ADMIN_PERM flag on genl mcast groups
to mandate CAP_NET_ADMIN, which is important to protect token information
in the MPTCP events. This is a genetlink change.

Patch 8 adds the MPTCP netlink events.


Florian Westphal (8):
  mptcp: move pm netlink work into pm_netlink
  mptcp: split __mptcp_close_ssk helper
  mptcp: schedule worker when subflow is closed
  mptcp: move subflow close loop after sk close check
  mptcp: pass subflow socket to a few helpers
  mptcp: avoid lock_fast usage in accept path
  genetlink: add CAP_NET_ADMIN test for multicast bind
  mptcp: add netlink event support

 include/net/genetlink.h    |   1 +
 include/uapi/linux/mptcp.h |  74 +++++++++
 net/mptcp/options.c        |   2 +-
 net/mptcp/pm.c             |  24 ++-
 net/mptcp/pm_netlink.c     | 310 ++++++++++++++++++++++++++++++++++++-
 net/mptcp/protocol.c       |  72 ++++-----
 net/mptcp/protocol.h       |  20 +--
 net/mptcp/subflow.c        |  27 +++-
 net/netlink/genetlink.c    |  32 ++++
 9 files changed, 491 insertions(+), 71 deletions(-)


base-commit: c3ff3b02e99c691197a05556ef45f5c3dd2ed3d6
-- 
2.30.1

