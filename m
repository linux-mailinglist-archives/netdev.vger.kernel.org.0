Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F453ABFB8
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 01:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbhFQXsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 19:48:55 -0400
Received: from mga03.intel.com ([134.134.136.65]:13474 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233120AbhFQXsp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 19:48:45 -0400
IronPort-SDR: gn4fUY9zTvK6DhOq7qL+MJMyXTd3GF3SLfuCIPQLv4zLPuRtenmt+VVLBiSHrMtAtZy7ADaO26
 P+OH/GtZn17Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="206506657"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="206506657"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:33 -0700
IronPort-SDR: 8GiAdAH02eEJVaKhqz+FI74k4TAUwJATquH5i8T8DQqHm/rmH+Zmp3cL26N0GxNeZc8WpgXWU7
 u6RSLo02bPpA==
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="452943918"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.250.143])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:32 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, geliangtang@gmail.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 11/16] mptcp: tune re-injections for csum enabled mode
Date:   Thu, 17 Jun 2021 16:46:17 -0700
Message-Id: <20210617234622.472030-12-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
References: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

If the MPTCP-level checksum is enabled, on re-injections we
must spool a complete DSS, or the receive side will not be
able to compute the csum and process any data.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b6e5c0930533..42fc7187beee 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2375,8 +2375,8 @@ static void __mptcp_retrans(struct sock *sk)
 
 	/* limit retransmission to the bytes already sent on some subflows */
 	info.sent = 0;
-	info.limit = dfrag->already_sent;
-	while (info.sent < dfrag->already_sent) {
+	info.limit = READ_ONCE(msk->csum_enabled) ? dfrag->data_len : dfrag->already_sent;
+	while (info.sent < info.limit) {
 		if (!mptcp_alloc_tx_skb(sk, ssk))
 			break;
 
@@ -2388,9 +2388,11 @@ static void __mptcp_retrans(struct sock *sk)
 		copied += ret;
 		info.sent += ret;
 	}
-	if (copied)
+	if (copied) {
+		dfrag->already_sent = max(dfrag->already_sent, info.sent);
 		tcp_push(ssk, 0, info.mss_now, tcp_sk(ssk)->nonagle,
 			 info.size_goal);
+	}
 
 	mptcp_set_timeout(sk, ssk);
 	release_sock(ssk);
-- 
2.32.0

