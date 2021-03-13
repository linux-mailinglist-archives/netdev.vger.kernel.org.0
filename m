Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB64339ACA
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 02:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbhCMBQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 20:16:36 -0500
Received: from mga17.intel.com ([192.55.52.151]:1166 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232229AbhCMBQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 20:16:28 -0500
IronPort-SDR: uQpKXxs3dPlefe4NSWN9DWfNheJvKOB4AkS8Uw4SOpTASH1PAtLg+Joxj+/vbtmicQZzd9+T0f
 zYiqwaoTaYug==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="168828242"
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="168828242"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:26 -0800
IronPort-SDR: /F5j0Dq7CAUDBVPrttBUFmVXEng2LbcCCAusCRDkg8Qffj52/6wkOPYS5gruLu+dwULpiMtvrb
 WOWQbzGjyAPA==
X-IronPort-AV: E=Sophos;i="5.81,245,1610438400"; 
   d="scan'208";a="411197364"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.255.228.204])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 17:16:26 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.01.org
Subject: [PATCH net-next 00/11] mptcp: Include multiple address ids in RM_ADDR
Date:   Fri, 12 Mar 2021 17:16:10 -0800
Message-Id: <20210313011621.211661-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here's a patch series from the MPTCP tree that extends the capabilities
of the MPTCP RM_ADDR header.

MPTCP peers can exchange information about their IP addresses that are
available for additional MPTCP subflows. IP addresses are advertised
with an ADD_ADDR header type, and those advertisements are revoked with
the RM_ADDR header type. RFC 8684 allows the RM_ADDR header to include
more than one address ID, so multiple advertisements can be revoked in a
single header. Previous kernel versions have only used RM_ADDR with a
single address ID, so multiple removals required multiple packets.

Patches 1-4 plumb address id list structures around the MPTCP code,
where before only a single address ID was passed.

Patches 5-8 make use of the address lists at the path manager layer that
tracks available addresses for both peers.

Patches 9-11 update the selftests to cover the new use of RM_ADDR with
multiple address IDs.


Geliang Tang (11):
  mptcp: add rm_list in mptcp_out_options
  mptcp: add rm_list_tx in mptcp_pm_data
  mptcp: add rm_list in mptcp_options_received
  mptcp: add rm_list_rx in mptcp_pm_data
  mptcp: remove multi addresses in PM
  mptcp: remove multi subflows in PM
  mptcp: remove multi addresses and subflows in PM
  mptcp: remove a list of addrs when flushing
  selftests: mptcp: add invert argument for chk_rm_nr
  selftests: mptcp: set addr id for removing testcases
  selftests: mptcp: add testcases for removing addrs

 include/net/mptcp.h                           |   9 +-
 net/mptcp/options.c                           |  47 ++++--
 net/mptcp/pm.c                                |  39 +++--
 net/mptcp/pm_netlink.c                        | 139 +++++++++++++-----
 net/mptcp/protocol.h                          |  27 +++-
 .../testing/selftests/net/mptcp/mptcp_join.sh |  82 ++++++++---
 6 files changed, 250 insertions(+), 93 deletions(-)


base-commit: 26d2e0426aacaf4c128dc57111f0d460ab20e8b5
-- 
2.30.2

