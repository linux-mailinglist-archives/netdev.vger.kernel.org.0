Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A433D34AE7E
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhCZSXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 14:23:34 -0400
Received: from mga18.intel.com ([134.134.136.126]:38736 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230106AbhCZSX0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 14:23:26 -0400
IronPort-SDR: VIz0pgnJli9O2lMR2Ba/UmhW4D/QSJNEb/btktyQt7VKF9lL3cXPyCTkSzEVOHC5U/FSpBeisK
 d0WBqeJvG8jA==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="178744846"
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="178744846"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 11:23:25 -0700
IronPort-SDR: eAWEsXw6dwFPZ6kKBsBbDMX+IlknhR8uR4Yl+Gxi4Y1cVg8kDPkRImzbh8R2Fw0BoUr1BmSShB
 Trx30JxvBExw==
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="375569737"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.24.139])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 11:23:25 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 00/13] MPTCP: Cleanup and address advertisement fixes
Date:   Fri, 26 Mar 2021 11:23:07 -0700
Message-Id: <20210326182307.136256-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series contains cleanup and fixes we have been testing in the
MPTCP tree. MPTCP uses TCP option headers to advertise additional
address information after an initial connection is established. The main
fixes here deal with making those advertisements more reliable and
improving the way subflows are created after an advertisement is
received.


Patches 1, 2, 4, 10, and 12 are for various cleanup or refactoring.

Patch 3 skips an extra connection attempt if there's already a subflow
connection for the newly received advertisement.

Patches 5, 6, and 7 make sure that the next address is advertised when
there are multiple addresses to share, the advertisement has been
retried, and the peer has not echoed the advertisement. Self tests are
updated.

Patches 8 and 9 fix a problem similar to 5/6/7, but covers a case where
the failure was due to a subflow connection not completing.

Patches 11 and 13 send a bare ack to revoke an advertisement rather than
waiting for other activity to trigger a packet send. This mirrors the
way acks are sent for new advertisements. Self test is included.


Geliang Tang (12):
  mptcp: drop argument port from mptcp_pm_announce_addr
  mptcp: skip connecting the connected address
  mptcp: drop unused subflow in mptcp_pm_subflow_established
  mptcp: move to next addr when timeout
  selftests: mptcp: add cfg_do_w for cfg_remove
  selftests: mptcp: timeout testcases for multi addresses
  mptcp: export lookup_anno_list_by_saddr
  mptcp: move to next addr when subflow creation fail
  mptcp: drop useless addr_signal clear
  mptcp: send ack for rm_addr
  mptcp: rename mptcp_pm_nl_add_addr_send_ack
  selftests: mptcp: signal addresses testcases

Paolo Abeni (1):
  mptcp: clean-up the rtx path

 net/mptcp/options.c                           |  3 +-
 net/mptcp/pm.c                                | 25 ++++--
 net/mptcp/pm_netlink.c                        | 69 +++++++++------
 net/mptcp/protocol.c                          | 42 +++-------
 net/mptcp/protocol.h                          | 12 ++-
 .../selftests/net/mptcp/mptcp_connect.c       | 10 ++-
 .../testing/selftests/net/mptcp/mptcp_join.sh | 84 ++++++++++++++++++-
 7 files changed, 173 insertions(+), 72 deletions(-)


base-commit: 6c996e19949b34d7edebed4f6b0511145c036404
-- 
2.31.0

