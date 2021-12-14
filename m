Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680B3474E78
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 00:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238183AbhLNXQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 18:16:24 -0500
Received: from mga18.intel.com ([134.134.136.126]:9338 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231684AbhLNXQW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 18:16:22 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="225961169"
X-IronPort-AV: E=Sophos;i="5.88,206,1635231600"; 
   d="scan'208";a="225961169"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 15:16:09 -0800
X-IronPort-AV: E=Sophos;i="5.88,206,1635231600"; 
   d="scan'208";a="518491434"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.180.223])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 15:16:09 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net 0/4] mptcp: Fixes for ULP, a deadlock, and netlink docs
Date:   Tue, 14 Dec 2021 15:16:00 -0800
Message-Id: <20211214231604.211016-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two of the MPTCP fixes in this set are related to the TCP_ULP socket
option with MPTCP sockets operating in "fallback" mode (the connection
has reverted to regular TCP). The other issues are an observed deadlock
and missing parameter documentation in the MPTCP netlink API.


Patch 1 marks TCP_ULP as unsupported earlier in MPTCP setsockopt code,
so the fallback code path in the MPTCP layer does not pass the TCP_ULP
option down to the subflow TCP socket.

Patch 2 makes sure a TCP fallback socket returned to userspace by
accept()ing on a MPTCP listening socket does not allow use of the
"mptcp" TCP_ULP type. That ULP is intended only for use by in-kernel
MPTCP subflows.

Patch 3 fixes the possible deadlock when sending data and there are
socket option changes to sync to the subflows.

Patch 4 makes sure all MPTCP netlink event parameters are documented
in the MPTCP uapi header.


Florian Westphal (2):
  mptcp: remove tcp ulp setsockopt support
  mptcp: clear 'kern' flag from fallback sockets

Matthieu Baerts (1):
  mptcp: add missing documented NL params

Maxim Galaganov (1):
  mptcp: fix deadlock in __mptcp_push_pending()

 include/uapi/linux/mptcp.h | 18 ++++++++++--------
 net/mptcp/protocol.c       |  6 ++++--
 net/mptcp/sockopt.c        |  1 -
 3 files changed, 14 insertions(+), 11 deletions(-)


base-commit: 3dd7d40b43663f58d11ee7a3d3798813b26a48f1
-- 
2.34.1

