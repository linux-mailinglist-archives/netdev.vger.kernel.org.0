Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D0C228A0C
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731041AbgGUUhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728856AbgGUUhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:37:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9E1C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:37:37 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jxz15-0003xN-MF; Tue, 21 Jul 2020 22:37:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     mathew.j.martineau@linux.intel.com, edumazet@google.com,
        mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Florian Westphal <fw@strlen.de>
Subject: [RFC v2 mptcp-next 10/12] tcp: handle want_cookie clause via reqsk_put
Date:   Tue, 21 Jul 2020 22:36:40 +0200
Message-Id: <20200721203642.32753-11-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200721203642.32753-1-fw@strlen.de>
References: <20200721203642.32753-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will allow the syn_recv_sock callback to keep the request socket
around even when syncookies are used.

This will be needed to make MPTCP JOIN requests work in cookie mode.

When a JOIN request is received, we cannot use cookies because we need
to remember the peers nonce value for HMAC validation.

Next patch will handle the cookie+join case by allowing the
rsk to stay around provided:
 1. We can find a valid mptcp socket for the 32bit token provided
    by the join and
 2. the found mptcp socket doesn't exceed the maximum number of
    subflows.

To handle 2) the request socket will not only be accounted with the
listener but also with the mptcp (parent) socket.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/tcp_input.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 7f4c21bca3b5..184c6d111ca0 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6697,6 +6697,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	/* Note: tcp_v6_init_req() might override ir_iif for link locals */
 	inet_rsk(req)->ir_iif = inet_request_bound_dev_if(sk, skb);
 
+	refcount_set(&req->rsk_refcnt, 1);
 	af_ops->init_req(req, sk, skb, want_cookie);
 
 	if (security_inet_conn_request(sk, skb, req))
@@ -6767,10 +6768,6 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 		af_ops->send_synack(sk, dst, &fl, req, &foc,
 				    !want_cookie ? TCP_SYNACK_NORMAL :
 						   TCP_SYNACK_COOKIE);
-		if (want_cookie) {
-			reqsk_free(req);
-			return 0;
-		}
 	}
 	reqsk_put(req);
 	return 0;
@@ -6778,7 +6775,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 drop_and_release:
 	dst_release(dst);
 drop_and_free:
-	__reqsk_free(req);
+	reqsk_put(req);
 drop:
 	tcp_listendrop(sk);
 	return 0;
-- 
2.26.2

