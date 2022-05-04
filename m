Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A81519584
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 04:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245392AbiEDCmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 22:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbiEDCml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 22:42:41 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DDD1902A
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 19:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651631947; x=1683167947;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vsnw+ionwlQ/bLcjkhtG/wrtlCAeyvXE0/2zswBqgx0=;
  b=FCtVF2f5Q8gjoj2g6+qMa38qqfe/8JtjQ5ZhTLy7UEEMw2VEcQt7QtT5
   HyqmgGh7y3dlJ6yIV1GSB8SI+XRi1enom4E88KOb4sDm2ikV583/SL4+W
   3Wix9TByvjVjzI6G+wKygEO0rpCVdWnU0a8WS+xxUNLYLHe/lgWKH3vJN
   Rqrqxqi+DhdLv+IoALNdyRUm+7oLw878+9AttCM+JSLRzstSVLC9aQ6p9
   29h5iFM99P0UkaTD6hmcyNfoz5xsiMncKsMg8x431pxG7aTMBoQYbU0ES
   fWvllrV5lsBVXiFvIS1qtqUvPb0D2cwQnAj1EnGS1aOUtS8d2R26gQavW
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="267799829"
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="267799829"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 19:39:07 -0700
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="584493362"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.20.240])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 19:39:07 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 00/13] mptcp: Userspace path manager API
Date:   Tue,  3 May 2022 19:38:48 -0700
Message-Id: <20220504023901.277012-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Userspace path managers (PMs) make use of generic netlink MPTCP events
and commands to control addition and removal of MPTCP subflows on an
existing MPTCP connection. The path manager events have already been
upstream for a while, and this patch series adds four netlink commands
for userspace:

* MPTCP_PM_CMD_ANNOUNCE: advertise an address that's available for 
additional subflow connections.

* MPTCP_PM_CMD_REMOVE: revoke an advertisement

* MPTCP_PM_CMD_SUBFLOW_CREATE: initiate a new subflow on an existing MPTCP 
connection

* MPTCP_PM_CMD_SUBFLOW_DESTROY: close a subflow on an existing MPTCP 
connection

Userspace path managers, such as mptcpd, can be more easily customized
for different devices. The in-kernel path manager remains available to
handle server use cases.


Patches 1-3 update common path manager code (used by both in-kernel and
userspace PMs)

Patches 4, 6, and 8 implement the new generic netlink commands.

Patches 5, 7, and 9-13 add self test support and test cases for the new
path manager commands.


Florian Westphal (2):
  mptcp: netlink: split mptcp_pm_parse_addr into two functions
  mptcp: netlink: allow userspace-driven subflow establishment

Kishen Maloor (11):
  mptcp: handle local addrs announced by userspace PMs
  mptcp: read attributes of addr entries managed by userspace PMs
  mptcp: netlink: Add MPTCP_PM_CMD_ANNOUNCE
  selftests: mptcp: support MPTCP_PM_CMD_ANNOUNCE
  mptcp: netlink: Add MPTCP_PM_CMD_REMOVE
  selftests: mptcp: support MPTCP_PM_CMD_REMOVE
  selftests: mptcp: support MPTCP_PM_CMD_SUBFLOW_CREATE
  selftests: mptcp: support MPTCP_PM_CMD_SUBFLOW_DESTROY
  selftests: mptcp: capture netlink events
  selftests: mptcp: create listeners to receive MPJs
  selftests: mptcp: functional tests for the userspace PM type

 include/uapi/linux/mptcp.h                    |   7 +
 net/mptcp/Makefile                            |   2 +-
 net/mptcp/pm.c                                |   1 +
 net/mptcp/pm_netlink.c                        | 157 ++--
 net/mptcp/pm_userspace.c                      | 429 ++++++++++
 net/mptcp/protocol.c                          |   1 +
 net/mptcp/protocol.h                          |  37 +-
 net/mptcp/subflow.c                           |   2 +-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c | 645 ++++++++++++++-
 .../selftests/net/mptcp/userspace_pm.sh       | 779 ++++++++++++++++++
 10 files changed, 1999 insertions(+), 61 deletions(-)
 create mode 100644 net/mptcp/pm_userspace.c
 create mode 100755 tools/testing/selftests/net/mptcp/userspace_pm.sh


base-commit: f43f0cd2d9b07caf38d744701b0b54d4244da8cc
-- 
2.36.0

