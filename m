Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34C4467FF0
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 23:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383421AbhLCWjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 17:39:12 -0500
Received: from mga18.intel.com ([134.134.136.126]:46470 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238444AbhLCWjL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 17:39:11 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10187"; a="223940929"
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="223940929"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 14:35:47 -0800
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="460185302"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.18.88])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 14:35:46 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 00/10] mptcp: New features for MPTCP sockets and netlink PM
Date:   Fri,  3 Dec 2021 14:35:31 -0800
Message-Id: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This collection of patches adds MPTCP socket support for a few socket
options, ioctls, and one ancillary data type (specifics for each are
listed below). There's also a patch modifying the netlink MPTCP path
manager API to allow setting the backup flag on a configured interface
using the endpoint ID instead of the full IP address.

Patches 1 & 2: TCP_INQ cmsg and selftests.

Patches 2 & 3: SIOCINQ, OUTQ, and OUTQNSD ioctls and selftests.

Patch 5: Change backup flag using endpoint ID.

Patches 6 & 7: IP_TOS socket option and selftests.

Patches 8-10: TCP_CORK and TCP_NODELAY socket options. Includes a tcp
change to expose __tcp_sock_set_cork() and __tcp_sock_set_nodelay() for
use by MPTCP.


Davide Caratti (1):
  mptcp: allow changing the "backup" bit by endpoint id

Florian Westphal (6):
  mptcp: add TCP_INQ cmsg support
  selftests: mptcp: add TCP_INQ support
  mptcp: add SIOCINQ, OUTQ and OUTQNSD ioctls
  selftests: mptcp: add inq test case
  mptcp: getsockopt: add support for IP_TOS
  selftests: mptcp: check IP_TOS in/out are the same

Maxim Galaganov (3):
  tcp: expose __tcp_sock_set_cork and __tcp_sock_set_nodelay
  mptcp: expose mptcp_check_and_set_pending
  mptcp: support TCP_CORK and TCP_NODELAY

 include/linux/tcp.h                           |   2 +
 net/ipv4/tcp.c                                |   4 +-
 net/mptcp/pm_netlink.c                        |  14 +-
 net/mptcp/protocol.c                          |  91 ++-
 net/mptcp/protocol.h                          |   4 +
 net/mptcp/sockopt.c                           | 132 +++-
 tools/testing/selftests/net/mptcp/.gitignore  |   1 +
 tools/testing/selftests/net/mptcp/Makefile    |   2 +-
 .../selftests/net/mptcp/mptcp_connect.c       |  60 +-
 tools/testing/selftests/net/mptcp/mptcp_inq.c | 603 ++++++++++++++++++
 .../selftests/net/mptcp/mptcp_sockopt.c       |  63 ++
 .../selftests/net/mptcp/mptcp_sockopt.sh      |  44 +-
 12 files changed, 1007 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/net/mptcp/mptcp_inq.c


base-commit: bb14bfc7eb927b47717d82ba7ecc8345d9099cf4
-- 
2.34.1

