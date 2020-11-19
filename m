Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1339F2B9BA9
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbgKSTqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:46:09 -0500
Received: from mga04.intel.com ([192.55.52.120]:13142 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbgKSTqJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 14:46:09 -0500
IronPort-SDR: /q+pBGYwhh0PhGBljz0I+Pq1udw4DH4AQWOGz1naO+bCIFCpAk8O9otwyFlzfsbCDGc7XW0ypi
 xvkHjPHm8nCA==
X-IronPort-AV: E=McAfee;i="6000,8403,9810"; a="168780888"
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="168780888"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 11:46:08 -0800
IronPort-SDR: bf3HeBvhLjr/tx90PuCmKvACFRKXabV1h8mGY2HjFIujy32S+1Fh8yMOO0KhHSzleq9hJ4+Reu
 TSTy6LmaLzCQ==
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="476940473"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.255.229.232])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 11:46:08 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        kuba@kernel.org, mptcp@lists.01.org
Subject: [PATCH net-next 00/10] mptcp: More miscellaneous MPTCP fixes
Date:   Thu, 19 Nov 2020 11:45:53 -0800
Message-Id: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here's another batch of fixup and enhancement patches that we have
collected in the MPTCP tree.

Patch 1 removes an unnecessary flag and related code.

Patch 2 fixes a bug encountered when closing fallback sockets.

Patches 3 and 4 choose a better transmit subflow, with a self test.

Patch 5 adjusts tracking of unaccepted subflows

Patches 6-8 improve handling of long ADD_ADDR options, with a test.

Patch 9 more reliably tracks the MPTCP-level window shared with peers.

Patch 10 sends MPTCP-level acknowledgements more aggressively, so the
peer can send more data without extra delay.


Florian Westphal (3):
  mptcp: skip to next candidate if subflow has unacked data
  selftests: mptcp: add link failure test case
  mptcp: track window announced to peer

Geliang Tang (3):
  mptcp: change add_addr_signal type
  mptcp: send out dedicated ADD_ADDR packet
  selftests: mptcp: add ADD_ADDR IPv6 test cases

Paolo Abeni (4):
  mptcp: drop WORKER_RUNNING status bit
  mptcp: fix state tracking for fallback socket
  mptcp: keep unaccepted MPC subflow into join list
  mptcp: refine MPTCP-level ack scheduling

 include/net/mptcp.h                           |   3 +-
 net/ipv4/tcp_output.c                         |  11 +-
 net/mptcp/options.c                           |  48 ++++-
 net/mptcp/pm.c                                |  31 ++-
 net/mptcp/pm_netlink.c                        |  29 +++
 net/mptcp/protocol.c                          | 178 +++++++++---------
 net/mptcp/protocol.h                          |  44 ++++-
 net/mptcp/subflow.c                           |  14 +-
 .../testing/selftests/net/mptcp/mptcp_join.sh | 174 ++++++++++++++---
 9 files changed, 391 insertions(+), 141 deletions(-)


base-commit: 657bc1d10bfc23ac06d5d687ce45826c760744f9
-- 
2.29.2

