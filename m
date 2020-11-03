Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2132A4FA5
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbgKCTF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:05:28 -0500
Received: from mga12.intel.com ([192.55.52.136]:49621 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727706AbgKCTFZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 14:05:25 -0500
IronPort-SDR: MGJoLZCkvMnN1NOekiEilc8Jq3U2Pr4kflMiAsrLRUMLUW/g3HhxgOG1c7NPSaHepmI95+XN20
 fxUykrM6tC5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="148386931"
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="148386931"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 11:05:14 -0800
IronPort-SDR: iDdxJzbnKKGToarmR8yXP5bfNED/UfquK5mBG2om4Cpr1OLwjQ3icqTU8CVxRm20ZgJBPiQp4t
 NI9QAlPnq3gA==
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="352430147"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.251.18.188])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 11:05:14 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, mptcp@lists.01.org,
        kuba@kernel.org, davem@davemloft.net,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 2/7] mptcp: use _fast lock version in __mptcp_move_skbs
Date:   Tue,  3 Nov 2020 11:05:04 -0800
Message-Id: <20201103190509.27416-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103190509.27416-1-mathew.j.martineau@linux.intel.com>
References: <20201103190509.27416-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The function is short and won't sleep, so this can use the _fast version.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
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

