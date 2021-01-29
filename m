Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4AC2308316
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbhA2BOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:14:51 -0500
Received: from mga07.intel.com ([134.134.136.100]:6703 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231734AbhA2BOf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:14:35 -0500
IronPort-SDR: /cce9MoMmbqG7ahNUXfyJF14fA7MBwqY6gKESB9ZUpHO7o8JnD8t0vJYZjcEWQXKVclxTRJ9cu
 w6uIn/2bU/lQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="244430165"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="244430165"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:22 -0800
IronPort-SDR: fU+dvKvKVjoj799sENhaOSlpACQQNRK+cVc7wDmhufI77nWdNc7Odfvnuxm0BgtdZN27wLTs9G
 7pVUJXHPpKHg==
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="505538323"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.96.46])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:22 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.01.org
Subject: [PATCH net-next 00/16] mptcp: ADD_ADDR enhancements
Date:   Thu, 28 Jan 2021 17:10:59 -0800
Message-Id: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series from the MPTCP tree contains enhancements and
associated tests for the ADD_ADDR ("add address") MPTCP option. This
option allows already-connected MPTCP peers to share additional IP
addresses with each other, which can then be used to create additional
subflows within those MPTCP connections.

Patches 1 & 2 remove duplicated data in the per-connection path manager
structure.

Patches 3-6 initiate additional subflows when an address is added using
the netlink path manager interface and improve ADD_ADDR signaling
reliability, subject to configured limits. Self tests are also updated.

Patches 7-15 add new support for optional port numbers in ADD_ADDR. This
includes creating an additional in-kernel TCP listening socket for the
requested port number, validating the port number when processing
incoming subflow connections, including the port number in netlink
interfaces, and adding some new MIBs. New self test cases are added for
subflows connecting with alternate port numbers.

Patch 16 refactors the self test script containing the ADD_ADDR test
cases, allowing developers to quickly run a subset of the tests.

Geliang Tang (16):
  mptcp: use WRITE_ONCE/READ_ONCE for the pernet *_max
  mptcp: drop *_max fields in mptcp_pm_data
  mptcp: create subflow or signal addr for newly added address
  mptcp: send ack for every add_addr
  selftests: mptcp: use minus values for removing address numbers
  selftests: mptcp: add testcases for newly added addresses
  mptcp: create the listening socket for new port
  mptcp: drop unused skb in subflow_token_join_request
  mptcp: add a new helper subflow_req_create_thmac
  mptcp: add port number check for MP_JOIN
  mptcp: enable use_port when invoke addresses_equal
  mptcp: deal with MPTCP_PM_ADDR_ATTR_PORT in PM netlink
  selftests: mptcp: add port argument for pm_nl_ctl
  mptcp: add the mibs for ADD_ADDR with port
  selftests: mptcp: add testcases for ADD_ADDR with port
  selftests: mptcp: add command line arguments for mptcp_join.sh

 net/mptcp/mib.c                               |    6 +
 net/mptcp/mib.h                               |    6 +
 net/mptcp/mptcp_diag.c                        |    6 +-
 net/mptcp/options.c                           |    4 +
 net/mptcp/pm.c                                |   12 +-
 net/mptcp/pm_netlink.c                        |  295 ++++-
 net/mptcp/protocol.c                          |    2 +-
 net/mptcp/protocol.h                          |   12 +-
 net/mptcp/subflow.c                           |   79 +-
 .../testing/selftests/net/mptcp/mptcp_join.sh | 1095 +++++++++++------
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c |   24 +-
 11 files changed, 1084 insertions(+), 457 deletions(-)


base-commit: 32e31b78272ba0905c751a0f6ff6ab4c275a780e
-- 
2.30.0

