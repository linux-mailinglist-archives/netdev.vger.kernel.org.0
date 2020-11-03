Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12CA2A4FA4
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbgKCTFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:05:24 -0500
Received: from mga12.intel.com ([192.55.52.136]:49621 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727706AbgKCTFY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 14:05:24 -0500
IronPort-SDR: 54z5ULKM/GuSclpzPRo7aJYWUpvU3La68sjSzfumHfwII6lKQJGGDq6QvEfZNU5QxxFq8/aoO0
 Q1M/1Tb3UKLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="148386929"
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="148386929"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 11:05:14 -0800
IronPort-SDR: +sS8lu3X/CCCCIzELP5ueQdtz/sxm3vHMeV+UF/0dS/ln3t8g/V/1iC7JOFMvqSE8tRs42+0eX
 7HW0j/ez8J0Q==
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="352430145"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.251.18.188])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 11:05:14 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, kuba@kernel.org, davem@davemloft.net
Subject: [PATCH net-next v2 0/7] mptcp: Miscellaneous MPTCP fixes
Date:   Tue,  3 Nov 2020 11:05:02 -0800
Message-Id: <20201103190509.27416-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a collection of small fixup and minor enhancement patches that
have accumulated in the MPTCP tree while net-next was closed. These are
prerequisites for larger changes we have queued up.

Patch 1 refines receive buffer autotuning.

Patches 2 and 4 are some minor locking and refactoring changes.

Patch 3 improves GRO and RX coalescing with MPTCP skbs.

Patches 5-7 add a sysctl for tuning ADD_ADDR retransmission timeout,
corresponding test code, and documentation.


v2: Add sysctl documentation and fix signoff tags.


Florian Westphal (3):
  mptcp: adjust mptcp receive buffer limit if subflow has larger one
  mptcp: use _fast lock version in __mptcp_move_skbs
  mptcp: split mptcp_clean_una function

Geliang Tang (2):
  mptcp: add a new sysctl add_addr_timeout
  selftests: mptcp: add ADD_ADDR timeout test case

Mat Martineau (1):
  docs: networking: mptcp: Add MPTCP sysctl entries

Paolo Abeni (1):
  tcp: propagate MPTCP skb extensions on xmit splits

 Documentation/networking/index.rst            |  1 +
 Documentation/networking/mptcp-sysctl.rst     | 26 +++++
 MAINTAINERS                                   |  1 +
 include/net/mptcp.h                           | 21 ++++-
 net/ipv4/tcp_output.c                         |  3 +
 net/mptcp/ctrl.c                              | 14 +++
 net/mptcp/pm_netlink.c                        |  8 +-
 net/mptcp/protocol.c                          | 67 +++++++++----
 net/mptcp/protocol.h                          |  1 +
 tools/testing/selftests/net/mptcp/config      | 10 ++
 .../testing/selftests/net/mptcp/mptcp_join.sh | 94 ++++++++++++++-----
 11 files changed, 199 insertions(+), 47 deletions(-)
 create mode 100644 Documentation/networking/mptcp-sysctl.rst


base-commit: 6d89076e6ef09337a29a7b1ea4fdf2d892be9650
-- 
2.29.2

