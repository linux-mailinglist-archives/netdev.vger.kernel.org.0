Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8F830B328
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 00:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhBAXLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 18:11:15 -0500
Received: from mga12.intel.com ([192.55.52.136]:51851 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230090AbhBAXLN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 18:11:13 -0500
IronPort-SDR: yXp8ir/z9a8BEY30wJrDgt7Q8gXooyWv401Ivklf30hE8fNbUfkXJ0HllV8a6Dgl6bNBErIwfY
 oSo/MUlD2Ufg==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="159934334"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="159934334"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 15:09:26 -0800
IronPort-SDR: HKmWDzAoBwK5d4awRXF1ya2+1NbSCjbW+nUmASf1/jlRxMIVFsVL434fRte4mO4uYjxU7uW9PM
 IPFHDO8B0rGA==
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="391188460"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.7.131])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 15:09:26 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.01.org
Subject: [PATCH net-next v2 00/15] mptcp: ADD_ADDR enhancements
Date:   Mon,  1 Feb 2021 15:09:05 -0800
Message-Id: <20210201230920.66027-1-mathew.j.martineau@linux.intel.com>
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


v2: Address review comments for patch 1 (drop unnecessary READ_ONCE()
under lock). Drop patch 16, which will be submitted later.


Geliang Tang (15):
  mptcp: use WRITE_ONCE for the pernet *_max
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

 net/mptcp/mib.c                               |   6 +
 net/mptcp/mib.h                               |   6 +
 net/mptcp/mptcp_diag.c                        |   6 +-
 net/mptcp/options.c                           |   4 +
 net/mptcp/pm.c                                |  12 +-
 net/mptcp/pm_netlink.c                        | 291 +++++++++++++++---
 net/mptcp/protocol.c                          |   2 +-
 net/mptcp/protocol.h                          |  12 +-
 net/mptcp/subflow.c                           |  79 ++++-
 .../testing/selftests/net/mptcp/mptcp_join.sh | 261 +++++++++++++++-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c |  24 +-
 11 files changed, 609 insertions(+), 94 deletions(-)


base-commit: 14e8e0f6008865d823a8184a276702a6c3cbef3d
-- 
2.30.0

