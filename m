Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013FF36166A
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237081AbhDOXpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:45:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:63174 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234969AbhDOXpb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:45:31 -0400
IronPort-SDR: rnhSldgPV+UmRLambx70Lwhw/KQbtFJKWHtj6orEH5KLjvL7SdcLA+FCzaTJV2sRbg6VFHqWme
 /XWrwAEd6xDg==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="215480150"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="215480150"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 16:45:07 -0700
IronPort-SDR: g82DuLSt65Mcvx6G1dH2lYc2wkySD9Hbw2hn94CyITyRuNRJSeFiuGV6vRQnNNUineBUDncdJc
 Sc5ceQnTq7HA==
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="461793353"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.243.150])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 16:45:07 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 01/13] mptcp: revert "mptcp: forbit mcast-related sockopt on MPTCP sockets"
Date:   Thu, 15 Apr 2021 16:44:50 -0700
Message-Id: <20210415234502.224225-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415234502.224225-1-mathew.j.martineau@linux.intel.com>
References: <20210415234502.224225-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

This change reverts commit 86581852d771 ("mptcp: forbit mcast-related sockopt on MPTCP sockets").

As announced in the cover letter of the mentioned patch above, the
following commits introduce a larger MPTCP sockopt implementation
refactor.

This time, we switch from a blocklist to an allowlist. This is safer for
the future where new sockoptions could be added while not being fully
supported with MPTCP sockets and thus causing unstabilities.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 45 --------------------------------------------
 1 file changed, 45 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 8009b3f8e4c1..2fcdc611c122 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2869,48 +2869,6 @@ static int mptcp_setsockopt_v6(struct mptcp_sock *msk, int optname,
 	return ret;
 }
 
-static bool mptcp_unsupported(int level, int optname)
-{
-	if (level == SOL_IP) {
-		switch (optname) {
-		case IP_ADD_MEMBERSHIP:
-		case IP_ADD_SOURCE_MEMBERSHIP:
-		case IP_DROP_MEMBERSHIP:
-		case IP_DROP_SOURCE_MEMBERSHIP:
-		case IP_BLOCK_SOURCE:
-		case IP_UNBLOCK_SOURCE:
-		case MCAST_JOIN_GROUP:
-		case MCAST_LEAVE_GROUP:
-		case MCAST_JOIN_SOURCE_GROUP:
-		case MCAST_LEAVE_SOURCE_GROUP:
-		case MCAST_BLOCK_SOURCE:
-		case MCAST_UNBLOCK_SOURCE:
-		case MCAST_MSFILTER:
-			return true;
-		}
-		return false;
-	}
-	if (level == SOL_IPV6) {
-		switch (optname) {
-		case IPV6_ADDRFORM:
-		case IPV6_ADD_MEMBERSHIP:
-		case IPV6_DROP_MEMBERSHIP:
-		case IPV6_JOIN_ANYCAST:
-		case IPV6_LEAVE_ANYCAST:
-		case MCAST_JOIN_GROUP:
-		case MCAST_LEAVE_GROUP:
-		case MCAST_JOIN_SOURCE_GROUP:
-		case MCAST_LEAVE_SOURCE_GROUP:
-		case MCAST_BLOCK_SOURCE:
-		case MCAST_UNBLOCK_SOURCE:
-		case MCAST_MSFILTER:
-			return true;
-		}
-		return false;
-	}
-	return false;
-}
-
 static int mptcp_setsockopt(struct sock *sk, int level, int optname,
 			    sockptr_t optval, unsigned int optlen)
 {
@@ -2919,9 +2877,6 @@ static int mptcp_setsockopt(struct sock *sk, int level, int optname,
 
 	pr_debug("msk=%p", msk);
 
-	if (mptcp_unsupported(level, optname))
-		return -ENOPROTOOPT;
-
 	if (level == SOL_SOCKET)
 		return mptcp_setsockopt_sol_socket(msk, optname, optval, optlen);
 
-- 
2.31.1

