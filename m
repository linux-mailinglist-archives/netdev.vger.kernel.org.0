Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D3E3C2C01
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 02:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbhGJAXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 20:23:51 -0400
Received: from mga06.intel.com ([134.134.136.31]:60426 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231382AbhGJAXp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 20:23:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10040"; a="270913465"
X-IronPort-AV: E=Sophos;i="5.84,228,1620716400"; 
   d="scan'208";a="270913465"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 17:20:57 -0700
X-IronPort-AV: E=Sophos;i="5.84,228,1620716400"; 
   d="scan'208";a="462343530"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.240.68])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 17:20:56 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        pabeni@redhat.com, fw@strlen.de, geliangtang@gmail.com,
        mptcp@lists.linux.dev
Subject: [PATCH net 0/6] mptcp: Connection and accounting fixes
Date:   Fri,  9 Jul 2021 17:20:45 -0700
Message-Id: <20210710002051.216010-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are some miscellaneous fixes for MPTCP:

Patch 1 modifies an MPTCP hash so it doesn't depend on one of skb->dev
and skb->sk being non-NULL.

Patch 2 removes an extra destructor call when rejecting a join due to
port mismatch.

Patches 3 and 5 more cleanly handle error conditions with MP_JOIN and
syncookies, and update a related self test.

Patch 4 makes sure packets that trigger a subflow TCP reset during MPTCP
option header processing are correctly dropped.

Patch 6 addresses a rmem accounting issue that could keep packets in
subflow receive buffers longer than necessary, delaying MPTCP-level
ACKs.


Jianguo Wu (5):
  mptcp: fix warning in __skb_flow_dissect() when do syn cookie for
    subflow join
  mptcp: remove redundant req destruct in subflow_check_req()
  mptcp: fix syncookie process if mptcp can not_accept new subflow
  mptcp: avoid processing packet if a subflow reset
  selftests: mptcp: fix case multiple subflows limited by server

Paolo Abeni (1):
  mptcp: properly account bulk freed memory

 include/net/mptcp.h                           |  5 +++--
 net/ipv4/tcp_input.c                          | 19 +++++++++++++++----
 net/mptcp/mib.c                               |  1 +
 net/mptcp/mib.h                               |  1 +
 net/mptcp/options.c                           | 19 +++++++++++++------
 net/mptcp/protocol.c                          | 12 +++++++-----
 net/mptcp/protocol.h                          | 10 +++++++++-
 net/mptcp/subflow.c                           | 11 +++--------
 net/mptcp/syncookies.c                        | 16 +++++++++++++++-
 .../testing/selftests/net/mptcp/mptcp_join.sh |  2 +-
 10 files changed, 68 insertions(+), 28 deletions(-)

-- 
2.32.0

