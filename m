Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E9536990E
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243570AbhDWSRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:17:55 -0400
Received: from mga03.intel.com ([134.134.136.65]:40508 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232244AbhDWSRw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 14:17:52 -0400
IronPort-SDR: 1pTr8p+NWXvo2S0NQhahd5iULzHG8jue6R3LIncoMn+PSq9I+omQCGIP+1Z2VtDimXyTw0cVUK
 0M/LbmcZiU/Q==
X-IronPort-AV: E=McAfee;i="6200,9189,9963"; a="196172521"
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="196172521"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 11:17:14 -0700
IronPort-SDR: yIadxR139Tm/3VtAXEVjoW3YSJ90Be8vXGB7pEp1JvZqn4i2YR99dJbPWKH02TrrrKhSQ9pb8a
 wpYBBEogpqdQ==
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="402264969"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.72.13])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 11:17:14 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/5] mptcp: ignore unsupported msg flags
Date:   Fri, 23 Apr 2021 11:17:07 -0700
Message-Id: <20210423181709.330233-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210423181709.330233-1-mathew.j.martineau@linux.intel.com>
References: <20210423181709.330233-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Currently mptcp_sendmsg() fails with EOPNOTSUPP if the
user-space provides some unsupported flag. That is unexpected
and may foul existing applications migrated to MPTCP, which
expect a different behavior.

Change the mentioned function to silently ignore the unsupported
flags except MSG_FASTOPEN. This is the only flags currently not
supported by MPTCP with user-space visible side-effects.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/162
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index ae08c563c712..a996dd5bb0c2 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1614,9 +1614,13 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	int ret = 0;
 	long timeo;
 
-	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
+	/* we don't support FASTOPEN yet */
+	if (msg->msg_flags & MSG_FASTOPEN)
 		return -EOPNOTSUPP;
 
+	/* silently ignore everything else */
+	msg->msg_flags &= MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL;
+
 	mptcp_lock_sock(sk, __mptcp_wmem_reserve(sk, min_t(size_t, 1 << 20, len)));
 
 	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
@@ -1951,9 +1955,6 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
-	if (msg->msg_flags & ~(MSG_WAITALL | MSG_DONTWAIT))
-		return -EOPNOTSUPP;
-
 	mptcp_lock_sock(sk, __mptcp_splice_receive_queue(sk));
 	if (unlikely(sk->sk_state == TCP_LISTEN)) {
 		copied = -ENOTCONN;
-- 
2.31.1

