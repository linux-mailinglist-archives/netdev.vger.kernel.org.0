Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FAD34F552
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhCaAJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:09:37 -0400
Received: from mga05.intel.com ([192.55.52.43]:14825 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232490AbhCaAJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 20:09:03 -0400
IronPort-SDR: 90Oqf3U8f2dCkDqkmfm7G/Yfz0a8UYLjPPE2hsOjCdlhb4+ENKXIR1JiKQNzzZ4GGniyy0IHVy
 oBaBUA8WAXJA==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="277058938"
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="277058938"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 17:09:02 -0700
IronPort-SDR: /yTy4aUtwoG44/qamjaqFlr7xezLgfxHstXD8rvNqN6YGKZYviasz+3Ljb/Rq368Hq2qgQ0p3j
 Aqs/1YyG6v5A==
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="378682556"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.25.43])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 17:09:01 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/6] mptcp: remove all subflows involving id 0 address
Date:   Tue, 30 Mar 2021 17:08:51 -0700
Message-Id: <20210331000856.117636-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210331000856.117636-1-mathew.j.martineau@linux.intel.com>
References: <20210331000856.117636-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

There's only one subflow involving the non-zero id address, but there
may be multi subflows involving the id 0 address.

Here's an example:

 local_id=0, remote_id=0
 local_id=1, remote_id=0
 local_id=0, remote_id=1

If the removing address id is 0, all the subflows involving the id 0
address need to be removed.

In mptcp_pm_nl_rm_addr_received/mptcp_pm_nl_rm_subflow_received, the
"break" prevents the iteration to the next subflow, so this patch
dropped them.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/pm_netlink.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 73b9245c87b2..87a6133fd778 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -621,8 +621,6 @@ static void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk)
 			WRITE_ONCE(msk->pm.accept_addr, true);
 
 			__MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RMADDR);
-
-			break;
 		}
 	}
 }
@@ -695,8 +693,6 @@ void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk,
 			msk->pm.subflows--;
 
 			__MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RMSUBFLOW);
-
-			break;
 		}
 	}
 }
-- 
2.31.1

