Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4C6228A04
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730928AbgGUUhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGUUhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:37:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49109C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:37:14 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jxz0i-0003vH-TB; Tue, 21 Jul 2020 22:37:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     mathew.j.martineau@linux.intel.com, edumazet@google.com,
        mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Florian Westphal <fw@strlen.de>
Subject: [RFC v2 mptcp-next 02/12] tcp: syncookies: use single reqsk_free location
Date:   Tue, 21 Jul 2020 22:36:32 +0200
Message-Id: <20200721203642.32753-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200721203642.32753-1-fw@strlen.de>
References: <20200721203642.32753-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a common error label and use it.

Followup patch would need to add a 3rd 'if (err) { free(x); goto out;}.

This will allow use of simpler 'if (err) goto free' instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/syncookies.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 9a4f6b16c9bc..ee17f55401ef 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -363,10 +363,8 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	 */
 	RCU_INIT_POINTER(ireq->ireq_opt, tcp_v4_save_options(sock_net(sk), skb));
 
-	if (security_inet_conn_request(sk, skb, req)) {
-		reqsk_free(req);
-		goto out;
-	}
+	if (security_inet_conn_request(sk, skb, req))
+		goto out_free;
 
 	req->num_retrans = 0;
 
@@ -383,10 +381,8 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 			   ireq->ir_loc_addr, th->source, th->dest, sk->sk_uid);
 	security_req_classify_flow(req, flowi4_to_flowi(&fl4));
 	rt = ip_route_output_key(sock_net(sk), &fl4);
-	if (IS_ERR(rt)) {
-		reqsk_free(req);
-		goto out;
-	}
+	if (IS_ERR(rt))
+		goto out_free;
 
 	/* Try to redo what tcp_v4_send_synack did. */
 	req->rsk_window_clamp = tp->window_clamp ? :dst_metric(&rt->dst, RTAX_WINDOW);
@@ -405,5 +401,10 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	 */
 	if (ret)
 		inet_sk(ret)->cork.fl.u.ip4 = fl4;
-out:	return ret;
+	return ret;
+
+out_free:
+	reqsk_free(req);
+out:
+	return ret;
 }
-- 
2.26.2

