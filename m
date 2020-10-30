Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C65E2A1113
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 23:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgJ3WpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 18:45:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:45959 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbgJ3WpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 18:45:15 -0400
IronPort-SDR: YGhEjGwpUp4BBq+uL/ual+83fPD77LTq+n+IfGWzr5PIH0aHIsJOHlBP9ALEs9yg1k/3W2EqEc
 6fmRew+rNb2w==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="165177397"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="165177397"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 15:45:14 -0700
IronPort-SDR: boY8rD4fhd6diZ4mUkz3dYybOb34BWQxjqfyTPOEyYXLoUN+PI60A6L7mPiT+cMYbBOfAR4UTl
 cPDGCjryxhEg==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="361983938"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.102.227])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 15:45:12 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, mptcp@lists.01.org,
        kuba@kernel.org, davem@davemloft.net,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/6] mptcp: use _fast lock version in __mptcp_move_skbs
Date:   Fri, 30 Oct 2020 15:45:02 -0700
Message-Id: <20201030224506.108377-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201030224506.108377-1-mathew.j.martineau@linux.intel.com>
References: <20201030224506.108377-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The function is short and won't sleep, so this can use the _fast version.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e010ef7585bf..f5bacfc55006 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1493,13 +1493,14 @@ static bool __mptcp_move_skbs(struct mptcp_sock *msk)
 	__mptcp_flush_join_list(msk);
 	do {
 		struct sock *ssk = mptcp_subflow_recv_lookup(msk);
+		bool slowpath;
 
 		if (!ssk)
 			break;
 
-		lock_sock(ssk);
+		slowpath = lock_sock_fast(ssk);
 		done = __mptcp_move_skbs_from_subflow(msk, ssk, &moved);
-		release_sock(ssk);
+		unlock_sock_fast(ssk, slowpath);
 	} while (!done);
 
 	if (mptcp_ofo_queue(msk) || moved > 0) {
-- 
2.29.2

