Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5324101C4
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 01:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236753AbhIQXex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 19:34:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:37385 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235653AbhIQXew (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 19:34:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10110"; a="210130342"
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="210130342"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 16:33:30 -0700
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="483228553"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.205.24])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 16:33:29 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, fw@strlen.de
Subject: [PATCH net-next 0/5] mptcp: Add SOL_MPTCP getsockopt support
Date:   Fri, 17 Sep 2021 16:33:17 -0700
Message-Id: <20210917233322.271789-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here's the first new MPTCP feature for the v5.16 cycle, and I'll defer
to Florian's helpful description of the series implementing some new
MPTCP socket options:

========

This adds the MPTCP_INFO, MPTCP_TCPINFO and MPTCP_SUBFLOW_ADDRS
mptcp getsockopt optnames.

MPTCP_INFO exposes the mptcp_info struct as an alternative to the
existing netlink diag interface.

MPTCP_TCPINFO exposes the tcp_info struct.
Unlike SOL_TCP/TCP_INFO, this returns one struct for each active
subflow.

MPTCP_SUBFLOW_ADDRS allows userspace to discover the ip addresses/ports
used by the local and remote endpoints, one for each active tcp subflow.

MPTCP_TCPINFO and MPTCP_SUBFLOW_ADDRS share the same meta-header that
needs to be pre-filled by userspace with the size of the data structures
it expects.  This is done to allow extension of the involved structs
later on, without breaking backwards compatibility.

The meta-structure can also be used to discover the required space
to obtain all information, as kernel will fill in the number of
active subflows even if there is not enough room for the requested info
itself.

More information is available in the individual patches.
Last patch adds test cases for the three optnames.

========


Florian Westphal (5):
  mptcp: add new mptcp_fill_diag helper
  mptcp: add MPTCP_INFO getsockopt
  mptcp: add MPTCP_TCPINFO getsockopt support
  mptcp: add MPTCP_SUBFLOW_ADDRS getsockopt support
  selftests: mptcp: add mptcp getsockopt test cases

 include/linux/socket.h                        |   1 +
 include/net/mptcp.h                           |   4 +
 include/uapi/linux/mptcp.h                    |  35 +
 net/mptcp/mptcp_diag.c                        |  26 +-
 net/mptcp/sockopt.c                           | 276 +++++++
 tools/testing/selftests/net/mptcp/.gitignore  |   1 +
 tools/testing/selftests/net/mptcp/Makefile    |   2 +-
 .../selftests/net/mptcp/mptcp_sockopt.c       | 683 ++++++++++++++++++
 .../selftests/net/mptcp/mptcp_sockopt.sh      |  31 +-
 9 files changed, 1031 insertions(+), 28 deletions(-)
 create mode 100644 tools/testing/selftests/net/mptcp/mptcp_sockopt.c


base-commit: af54faab84f754ebd42ecdda871f8d71940ae40b
-- 
2.33.0

