Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F5F34F555
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbhCaAJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:09:39 -0400
Received: from mga05.intel.com ([192.55.52.43]:14824 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232126AbhCaAJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 20:09:03 -0400
IronPort-SDR: rG+uykrdJWvTlSZM8AMLvcli4jjcKNLcQQz02RT0m3Vy7ciV6veTJhLfangJDJ0D/acVK4AlcH
 HfQgdMQTt6KQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="277058936"
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="277058936"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 17:09:02 -0700
IronPort-SDR: apdnE05499dGXG109FX7WOBxbbi50nRzgByR9gZNyzzFxz1nlt6Lu4nRdq27Z3JWb2MtQZRs3p
 s8qvrysos7Rg==
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="378682555"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.25.43])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 17:09:01 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/6] MPTCP: Allow initial subflow to be disconnected
Date:   Tue, 30 Mar 2021 17:08:50 -0700
Message-Id: <20210331000856.117636-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An MPTCP connection is aggregated from multiple TCP subflows, and can
involve multiple IP addresses on either peer. The addresses used in the
initial subflow connection are assigned address id 0 on each side of the
link. More addresses can be added and shared with the peer using address
IDs of 1 or larger. MPTCP in Linux shares non-zero address IDs across
all MPTCP connections in a net namespace, which allows userspace to
manage subflow connections across a number of sockets. However, this
makes the address with id 0 a special case, since the IP address
associated with id 0 is potentially different for each socket.

This patch set allows the initial subflow to be disconnected when
userspace specifies an address to remove using both id 0 and an IP
address, or when the peer sends an RM_ADDR for id 0.

Patches 1 and 3 implement the change for requests from the peer and
userspace, respectively.

Patch 2 consolidates some code for disconnecting subflows.

Patches 4-6 update the self tests to cover removal of subflows using
address id 0.


Geliang Tang (5):
  mptcp: remove all subflows involving id 0 address
  mptcp: unify RM_ADDR and RM_SUBFLOW receiving
  mptcp: remove id 0 address
  selftests: mptcp: add addr argument for del_addr
  selftests: mptcp: remove id 0 address testcases

Matthieu Baerts (1):
  selftests: mptcp: avoid calling pm_nl_ctl with bad IDs

 net/mptcp/pm_netlink.c                        | 129 +++++++++++-------
 .../testing/selftests/net/mptcp/mptcp_join.sh |  35 ++++-
 .../testing/selftests/net/mptcp/pm_netlink.sh |   6 +-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c |  34 ++++-
 4 files changed, 143 insertions(+), 61 deletions(-)


base-commit: cda1893e9f7c1d78e391dbb6ef1798cd32354113
-- 
2.31.1

