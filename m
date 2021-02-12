Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C41F31A889
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhBMADY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:03:24 -0500
Received: from mga04.intel.com ([192.55.52.120]:41399 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231628AbhBMADU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 19:03:20 -0500
IronPort-SDR: D2vZkI6KCjbGVvRDXAWYcq/c1b5HVupgOylZo8+843di3w69slc2bc6FokoxFwbegC1PFDu+5X
 hg0T7tCNKY+A==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="179937488"
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="179937488"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 16:00:14 -0800
IronPort-SDR: 4E58yi8dHLyr8MNkYHRF50tOsKqqTvw7J9iuNivYOcy1bARin/4RYXfOpoM3+yNR86JzjgjU6r
 VAfNdSnUvpgg==
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="423381136"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.85.171])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 16:00:14 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 6/8] mptcp: avoid lock_fast usage in accept path
Date:   Fri, 12 Feb 2021 15:59:59 -0800
Message-Id: <20210213000001.379332-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210213000001.379332-1-mathew.j.martineau@linux.intel.com>
References: <20210213000001.379332-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Once event support is added this may need to allocate memory while msk
lock is held with softirqs disabled.

Not using lock_fast also allows to do the allocation with GFP_KERNEL.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 56240b87d464..fe6da1b77723 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3260,9 +3260,8 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 		struct mptcp_sock *msk = mptcp_sk(newsock->sk);
 		struct mptcp_subflow_context *subflow;
 		struct sock *newsk = newsock->sk;
-		bool slowpath;
 
-		slowpath = lock_sock_fast(newsk);
+		lock_sock(newsk);
 
 		/* PM/worker can now acquire the first subflow socket
 		 * lock without racing with listener queue cleanup,
@@ -3288,7 +3287,7 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 			if (!ssk->sk_socket)
 				mptcp_sock_graft(ssk, newsock);
 		}
-		unlock_sock_fast(newsk, slowpath);
+		release_sock(newsk);
 	}
 
 	if (inet_csk_listen_poll(ssock->sk))
-- 
2.30.1

