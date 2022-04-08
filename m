Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFCB14F9DC2
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 21:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbiDHTs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 15:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbiDHTsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 15:48:17 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CE1114
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 12:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649447173; x=1680983173;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8mvYeN//jyhruds3zSZPUfIAa/8HM8kPyXTpqdPQdT0=;
  b=Qs0mbOixiiIftEdqmt2pDkX2LJwiHm7PDI4ksq0qjSsPBpxucsRHOGPg
   HKuNfmH+IgC9dQi1PrqtfcpmborTbYtRL9AcHV3rHkoZIvV6XKiNBQCtS
   Veo++yFhA+40khzX+fYNt7RPAGlPMGhg9zw/+vCdOPVP0YZuRFrLfcnaS
   llGjT+axibMAZ5kaIPR2VZmjrUCGmQbAylfx6pIFf2wFrTmzv0vD1HzAD
   KDes/dVv6zIgEx4AzxPVOHDcUeXspt8Z2fJZqKBq2A4Go9+f0Q2P20C4j
   yKzzXTv+OjOX+p56aWC9pHlLZPfs6yvTvBae1DCLnmjJMfSvVDs4z42vN
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10311"; a="322365311"
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="322365311"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 12:46:11 -0700
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="659602177"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.134.75.99])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 12:46:10 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 7/8] mptcp: listen diag dump support
Date:   Fri,  8 Apr 2022 12:46:00 -0700
Message-Id: <20220408194601.305969-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220408194601.305969-1-mathew.j.martineau@linux.intel.com>
References: <20220408194601.305969-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

makes 'ss -Ml' show mptcp listen sockets.

Iterate over the tcp listen sockets and pick those that have mptcp ulp
info attached.

mptcp_diag_get_info() is modified to prefer msk->first for mptcp sockets
in listen state.  This reports accurate number for recv and send queue
(pending / max connection backlog counters).

Sample output:
ss -Mil
State        Recv-Q Send-Q Local Address:Port  Peer Address:Port
LISTEN       0      20     127.0.0.1:12000     0.0.0.0:*
         subflows_max:2

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/mptcp_diag.c | 91 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/net/mptcp/mptcp_diag.c b/net/mptcp/mptcp_diag.c
index c4992eeb67d8..dbb6d876a203 100644
--- a/net/mptcp/mptcp_diag.c
+++ b/net/mptcp/mptcp_diag.c
@@ -69,8 +69,83 @@ static int mptcp_diag_dump_one(struct netlink_callback *cb,
 struct mptcp_diag_ctx {
 	long s_slot;
 	long s_num;
+	unsigned int l_slot;
+	unsigned int l_num;
 };
 
+static void mptcp_diag_dump_listeners(struct sk_buff *skb, struct netlink_callback *cb,
+				      const struct inet_diag_req_v2 *r,
+				      bool net_admin)
+{
+	struct inet_diag_dump_data *cb_data = cb->data;
+	struct mptcp_diag_ctx *diag_ctx = (void *)cb->ctx;
+	struct nlattr *bc = cb_data->inet_diag_nla_bc;
+	struct net *net = sock_net(skb->sk);
+	int i;
+
+	for (i = diag_ctx->l_slot; i < INET_LHTABLE_SIZE; i++) {
+		struct inet_listen_hashbucket *ilb;
+		struct hlist_nulls_node *node;
+		struct sock *sk;
+		int num = 0;
+
+		ilb = &tcp_hashinfo.listening_hash[i];
+
+		rcu_read_lock();
+		spin_lock(&ilb->lock);
+		sk_nulls_for_each(sk, node, &ilb->nulls_head) {
+			const struct mptcp_subflow_context *ctx = mptcp_subflow_ctx(sk);
+			struct inet_sock *inet = inet_sk(sk);
+			int ret;
+
+			if (num < diag_ctx->l_num)
+				goto next_listen;
+
+			if (!ctx || strcmp(inet_csk(sk)->icsk_ulp_ops->name, "mptcp"))
+				goto next_listen;
+
+			sk = ctx->conn;
+			if (!sk || !net_eq(sock_net(sk), net))
+				goto next_listen;
+
+			if (r->sdiag_family != AF_UNSPEC &&
+			    sk->sk_family != r->sdiag_family)
+				goto next_listen;
+
+			if (r->id.idiag_sport != inet->inet_sport &&
+			    r->id.idiag_sport)
+				goto next_listen;
+
+			if (!refcount_inc_not_zero(&sk->sk_refcnt))
+				goto next_listen;
+
+			ret = sk_diag_dump(sk, skb, cb, r, bc, net_admin);
+
+			sock_put(sk);
+
+			if (ret < 0) {
+				spin_unlock(&ilb->lock);
+				rcu_read_unlock();
+				diag_ctx->l_slot = i;
+				diag_ctx->l_num = num;
+				return;
+			}
+			diag_ctx->l_num = num + 1;
+			num = 0;
+next_listen:
+			++num;
+		}
+		spin_unlock(&ilb->lock);
+		rcu_read_unlock();
+
+		cond_resched();
+		diag_ctx->l_num = 0;
+	}
+
+	diag_ctx->l_num = 0;
+	diag_ctx->l_slot = i;
+}
+
 static void mptcp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 			    const struct inet_diag_req_v2 *r)
 {
@@ -114,6 +189,9 @@ static void mptcp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 		}
 		cond_resched();
 	}
+
+	if ((r->idiag_states & TCPF_LISTEN) && r->id.idiag_dport == 0)
+		mptcp_diag_dump_listeners(skb, cb, r, net_admin);
 }
 
 static void mptcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
@@ -124,6 +202,19 @@ static void mptcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 
 	r->idiag_rqueue = sk_rmem_alloc_get(sk);
 	r->idiag_wqueue = sk_wmem_alloc_get(sk);
+
+	if (inet_sk_state_load(sk) == TCP_LISTEN) {
+		struct sock *lsk = READ_ONCE(msk->first);
+
+		if (lsk) {
+			/* override with settings from tcp listener,
+			 * so Send-Q will show accept queue.
+			 */
+			r->idiag_rqueue = READ_ONCE(lsk->sk_ack_backlog);
+			r->idiag_wqueue = READ_ONCE(lsk->sk_max_ack_backlog);
+		}
+	}
+
 	if (!info)
 		return;
 
-- 
2.35.1

