Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FA31E13EE
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 20:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388348AbgEYSP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 14:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387644AbgEYSP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 14:15:28 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4BDC061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 11:15:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jdHdG-0007ky-Hw; Mon, 25 May 2020 20:15:26 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     matthieu.baerts@tessares.net, mathew.j.martineau@linux.intel.com,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 net-next 1/2] mptcp: adjust tcp rcvspace after moving skbs from ssk to sk queue
Date:   Mon, 25 May 2020 20:15:07 +0200
Message-Id: <20200525181508.13492-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525181508.13492-1-fw@strlen.de>
References: <20200525181508.13492-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCP does tcp rcvbuf tuning when copying packets to userspace, e.g. in
tcp_read_sock().  In case of mptcp, that function is only rarely used
(when discarding retransmitted duplicate data).

Instead, skbs are moved from the tcp rx queue to the mptcp socket rx
queue.
Adjust subflow rcvbuf when we do so, its the last spot where we can
adjust the ssk rcvbuf -- later we only have the mptcp-level socket.

This greatly improves performance on mptcp bulk transfers.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: no change, added new patch, 2/2

 net/mptcp/protocol.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index ba9d3d5c625f..dbb86cbb9e77 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -248,6 +248,9 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 
 	*bytes = moved;
 
+	if (moved)
+		tcp_rcv_space_adjust(ssk);
+
 	return done;
 }
 
@@ -1263,6 +1266,7 @@ static int mptcp_init_sock(struct sock *sk)
 		return ret;
 
 	sk_sockets_allocated_inc(sk);
+	sk->sk_rcvbuf = sock_net(sk)->ipv4.sysctl_tcp_rmem[1];
 	sk->sk_sndbuf = sock_net(sk)->ipv4.sysctl_tcp_wmem[2];
 
 	return 0;
-- 
2.26.2

