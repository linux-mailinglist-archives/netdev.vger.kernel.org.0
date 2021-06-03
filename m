Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B8539AE95
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 01:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhFCX02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 19:26:28 -0400
Received: from mga05.intel.com ([192.55.52.43]:8110 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229723AbhFCX01 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 19:26:27 -0400
IronPort-SDR: IYlEWAfbA0G98JBfIMcAEuBVndjwj9SnIDWp0vQDtgMDpyFBNjbt2oXVt7Cvk4FFGiKI52NtZb
 //c8NZ1KAToA==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="289807783"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="289807783"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 16:24:41 -0700
IronPort-SDR: BdeWeVIBJ+DcmF3X1OnWDR6TN4A8lYEaW4qTxKtLN2zNzq1XQF7bpgvu+6aemBK3oPmRjotC3V
 evdDYQZME3QQ==
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="483669037"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.3.143])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 16:24:41 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        fw@strlen.de, mptcp@lists.linux.dev
Subject: [PATCH net-next 0/7] mptcp: Add timestamp support
Date:   Thu,  3 Jun 2021 16:24:26 -0700
Message-Id: <20210603232433.260703-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the SO_TIMESTAMP and SO_TIMESTAMPING socket options for MPTCP
sockets and add receive path cmsg support for timestamps.

Patches 1, 2, and 5 expose existing sock and tcp helpers for timestamps
(no new EXPORT_SYMBOLS()s).

Patch 3 propagates timestamp options to subflows.

Patch 4 cleans up MPTCP handling of SOL_SOCKET options.

Patch 6 adds timestamp csmg data when receiving on sockets that have
been configured for timestamps.

Patch 7 adds self test coverage for timestamps.


Florian Westphal (7):
  sock: expose so_timestamp options for mptcp
  sock: expose so_timestamping options for mptcp
  mptcp: sockopt: propagate timestamp request to subflows
  mptcp: setsockopt: handle SOL_SOCKET in one place only
  tcp: export timestamp helpers for mptcp
  mptcp: receive path cmsg support
  selftests: mptcp_connect: add SO_TIMESTAMPNS cmsg support

 include/net/sock.h                            |   3 +
 include/net/tcp.h                             |   4 +
 net/core/sock.c                               |  97 +++++++-----
 net/ipv4/tcp.c                                |  10 +-
 net/mptcp/protocol.c                          |  28 +++-
 net/mptcp/sockopt.c                           | 149 ++++++++++--------
 .../selftests/net/mptcp/mptcp_connect.c       | 125 ++++++++++++++-
 .../selftests/net/mptcp/mptcp_sockopt.sh      |   4 +-
 8 files changed, 296 insertions(+), 124 deletions(-)


base-commit: 6a8dd8b2fa5b7cec4b13f5f5b2589d9abbac0fab
-- 
2.31.1

