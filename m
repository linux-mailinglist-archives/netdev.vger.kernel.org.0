Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCEC217C712
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 21:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgCFUaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 15:30:06 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:59404 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726300AbgCFUaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 15:30:06 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jAJbg-0002cN-TW; Fri, 06 Mar 2020 21:30:04 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 2/2] mptcp: don't grow mptcp socket receive buffer when rcvbuf is locked
Date:   Fri,  6 Mar 2020 21:29:46 +0100
Message-Id: <20200306202946.8285-3-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200306202946.8285-1-fw@strlen.de>
References: <20200306202946.8285-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mptcp rcvbuf size is adjusted according to the subflow rcvbuf size.
This should not be done if userspace did set a fixed value.

Fixes: 600911ff5f72bae ("mptcp: add rmem queue accounting")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 4c075a9f7ed0..95007e433109 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -141,11 +141,13 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 	bool more_data_avail;
 	struct tcp_sock *tp;
 	bool done = false;
-	int rcvbuf;
 
-	rcvbuf = max(ssk->sk_rcvbuf, sk->sk_rcvbuf);
-	if (rcvbuf > sk->sk_rcvbuf)
-		sk->sk_rcvbuf = rcvbuf;
+	if (!(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
+		int rcvbuf = max(ssk->sk_rcvbuf, sk->sk_rcvbuf);
+
+		if (rcvbuf > sk->sk_rcvbuf)
+			sk->sk_rcvbuf = rcvbuf;
+	}
 
 	tp = tcp_sk(ssk);
 	do {
-- 
2.24.1

