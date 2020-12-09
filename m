Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056942D4F18
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 00:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgLIXxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:53:23 -0500
Received: from mga06.intel.com ([134.134.136.31]:19330 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbgLIXxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 18:53:23 -0500
IronPort-SDR: iqYMOZyxpz3tEcxP4hN0xyUWGGExa6iV2Zbr5zvYRNsCxXRUYc+3eKrC4ZtWwh+/Kyj0Hk1K8G
 CbCau92bcuIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="235763087"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="235763087"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:37 -0800
IronPort-SDR: CkG4U1GDebA82f+LBnIZEUjvE2RpYUlhHs6zXl1qEb3sC0ky5wwwtLCD3gR7+DJi1wpC68ywsr
 JmhL9lpLldaA==
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="318582179"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.111.12])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 15:51:37 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, geliangtang@gmail.com,
        mptcp@lists.01.org
Subject: [PATCH net-next 00/11] mptcp: Add port parameter to ADD_ADDR option
Date:   Wed,  9 Dec 2020 15:51:17 -0800
Message-Id: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ADD_ADDR MPTCP option is used to announce available IP addresses
that a peer may connect to when adding more TCP subflows to an existing
MPTCP connection. There is an optional port number field in that
ADD_ADDR header, and this patch set adds capability for that port number
to be sent and received.

Patches 1, 2, and 4 refactor existing ADD_ADDR code to simplify implementation
of port number support.

Patches 3 and 5 are the main functional changes, for sending and
receiving the port number in the MPTCP ADD_ADDR option.

Patch 6 sends the ADD_ADDR option with port number on a bare TCP ACK,
since the extra length of the option may run in to cases where
sufficient TCP option space is not available on a data packet.

Patch 7 plumbs in port number support for the in-kernel MPTCP path
manager.

Patches 8-11 add some optional debug output and a little more cleanup
refactoring.


Geliang Tang (11):
  mptcp: unify ADD_ADDR and echo suboptions writing
  mptcp: unify ADD_ADDR and ADD_ADDR6 suboptions writing
  mptcp: add port support for ADD_ADDR suboption writing
  mptcp: use adding up size to get ADD_ADDR length
  mptcp: add the outgoing ADD_ADDR port support
  mptcp: send out dedicated packet for ADD_ADDR using port
  mptcp: add port parameter for mptcp_pm_announce_addr
  mptcp: print out port and ahmac when receiving ADD_ADDR
  mptcp: drop rm_addr_signal flag
  mptcp: rename add_addr_signal and mptcp_add_addr_status
  mptcp: use the variable sk instead of open-coding

 include/net/mptcp.h    |   1 +
 net/mptcp/options.c    | 103 ++++++++++++++++++++++++++---------------
 net/mptcp/pm.c         |  40 +++++++++++-----
 net/mptcp/pm_netlink.c |  31 +++++++++----
 net/mptcp/protocol.h   |  50 ++++++++++++--------
 5 files changed, 146 insertions(+), 79 deletions(-)

-- 
2.29.2

