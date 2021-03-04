Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2415132DBDE
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 22:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239545AbhCDVff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 16:35:35 -0500
Received: from mga03.intel.com ([134.134.136.65]:46776 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239482AbhCDVfb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 16:35:31 -0500
IronPort-SDR: WEBTP5BIbrCek49sS/mOqbNR4AeQOPCGqqxmdQSyZsNs48/DuLrdbmFXbCY/2w1hZlELff3ugb
 ZAc+XSi8km9A==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="187566592"
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="187566592"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 13:32:24 -0800
IronPort-SDR: sAj+Y87z/a7Cpr75vhux/FBqNKH5NnVEOKxiq2dRN5tHp5hX93SQVhw6ftE+Jbex1/K0gmlli3
 X9VM2zeLcWvQ==
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="368329485"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.105.71])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 13:32:23 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 5/9] mptcp: reset 'first' and ack_hint on subflow close
Date:   Thu,  4 Mar 2021 13:32:12 -0800
Message-Id: <20210304213216.205472-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
References: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Just like with last_snd, we have to NULL 'first' on subflow close.

ack_hint isn't strictly required (its never dereferenced), but better to
clear this explicitly as well instead of making it an exception.

msk->first is dereferenced unconditionally at accept time, but
at that point the ssk is not on the conn_list yet -- this means
worker can't see it when iterating the conn_list.

Reported-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index a58da04bed71..3dcb564b03ad 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2169,6 +2169,12 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	if (ssk == msk->last_snd)
 		msk->last_snd = NULL;
 
+	if (ssk == msk->ack_hint)
+		msk->ack_hint = NULL;
+
+	if (ssk == msk->first)
+		msk->first = NULL;
+
 	if (msk->subflow && ssk == msk->subflow->sk)
 		mptcp_dispose_initial_subflow(msk);
 }
@@ -3297,6 +3303,9 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 		/* PM/worker can now acquire the first subflow socket
 		 * lock without racing with listener queue cleanup,
 		 * we can notify it, if needed.
+		 *
+		 * Even if remote has reset the initial subflow by now
+		 * the refcnt is still at least one.
 		 */
 		subflow = mptcp_subflow_ctx(msk->first);
 		list_add(&subflow->node, &msk->conn_list);
-- 
2.30.1

