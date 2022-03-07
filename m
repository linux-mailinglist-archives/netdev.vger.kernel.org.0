Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6634D08B8
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 21:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238752AbiCGUpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 15:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239959AbiCGUpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 15:45:45 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3E882D10
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 12:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646685888; x=1678221888;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KPNpdu3Rldm+3QB1r5PQ/DRLndD3TF2UZnkx5oNTpfc=;
  b=awgZ2QSzT7Pww+n2vJD2e/+3XByABav7FxJGsa+IA9pCxl4cM9vD26sf
   LHduqSdb0G2fT8AJWxR71jn4J+Dzz0gcyWnWYSt2t3QKXn2NTMNd0yUG7
   0T685koM3XQ7IweeN4nNB2GHAm8EnF+KA5E4dMuRWOuFb52vlZ5FnZNCv
   XZghFXL8CsdEAJX9JVOetN1o801nH7PgqJ84miffVVHLbTsc6BsoCaUw4
   yROVmitEBRqSKIgO6OdwwUX4EBZPB14LydUrPVqXjP11Mx6jkkK3Iul6n
   cvi9qknA/yM4gAQ0/5gMCeUwnba+gWQ2jogXmxjC71Fdyag9H5GlXKaoX
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="254440169"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="254440169"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 12:44:45 -0800
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="553320492"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.192.43])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 12:44:45 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 7/9] mptcp: strict local address ID selection
Date:   Mon,  7 Mar 2022 12:44:37 -0800
Message-Id: <20220307204439.65164-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307204439.65164-1-mathew.j.martineau@linux.intel.com>
References: <20220307204439.65164-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The address ID selection for MPJ subflows created in response
to incoming ADD_ADDR option is currently unreliable: it happens
at MPJ socket creation time, when the local address could be
unknown.

Additionally, if the no local endpoint is available for the local
address, a new dummy endpoint is created, confusing the user-land.

This change refactor the code to move the address ID selection inside
the rebuild_header() helper, when the local address eventually
selected by the route lookup is finally known. If the address used
is not mapped by any endpoint - and thus can't be advertised/removed
pick the id 0 instead of allocate a new endpoint.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c | 13 --------
 net/mptcp/protocol.c   |  3 ++
 net/mptcp/protocol.h   |  3 +-
 net/mptcp/subflow.c    | 67 ++++++++++++++++++++++++++++++++++++------
 4 files changed, 63 insertions(+), 23 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 10368a4f1c4a..e090810bb35d 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -83,16 +83,6 @@ static bool addresses_equal(const struct mptcp_addr_info *a,
 	return a->port == b->port;
 }
 
-static bool address_zero(const struct mptcp_addr_info *addr)
-{
-	struct mptcp_addr_info zero;
-
-	memset(&zero, 0, sizeof(zero));
-	zero.family = addr->family;
-
-	return addresses_equal(addr, &zero, true);
-}
-
 static void local_address(const struct sock_common *skc,
 			  struct mptcp_addr_info *addr)
 {
@@ -1039,9 +1029,6 @@ int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 	if (addresses_equal(&msk_local, &skc_local, false))
 		return 0;
 
-	if (address_zero(&skc_local))
-		return 0;
-
 	pernet = net_generic(sock_net((struct sock *)msk), pm_nl_pernet_id);
 
 	rcu_read_lock();
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 36a7d33f670a..101aeebeb9eb 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -117,6 +117,9 @@ static int __mptcp_socket_create(struct mptcp_sock *msk)
 	list_add(&subflow->node, &msk->conn_list);
 	sock_hold(ssock->sk);
 	subflow->request_mptcp = 1;
+
+	/* This is the first subflow, always with id 0 */
+	subflow->local_id_valid = 1;
 	mptcp_sock_graft(msk->first, sk->sk_socket);
 
 	return 0;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 9d0ee6cee07f..3c1a3036550f 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -442,7 +442,8 @@ struct mptcp_subflow_context {
 		rx_eof : 1,
 		can_ack : 1,        /* only after processing the remote a key */
 		disposable : 1,	    /* ctx can be free at ulp release time */
-		stale : 1;	    /* unable to snd/rcv data, do not use for xmit */
+		stale : 1,	    /* unable to snd/rcv data, do not use for xmit */
+		local_id_valid : 1; /* local_id is correctly initialized */
 	enum mptcp_data_avail data_avail;
 	u32	remote_nonce;
 	u64	thmac;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index bb09a008e733..aba260f547da 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -481,6 +481,51 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 	mptcp_subflow_reset(sk);
 }
 
+static void subflow_set_local_id(struct mptcp_subflow_context *subflow, int local_id)
+{
+	subflow->local_id = local_id;
+	subflow->local_id_valid = 1;
+}
+
+static int subflow_chk_local_id(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
+	int err;
+
+	if (likely(subflow->local_id_valid))
+		return 0;
+
+	err = mptcp_pm_get_local_id(msk, (struct sock_common *)sk);
+	if (err < 0)
+		return err;
+
+	subflow_set_local_id(subflow, err);
+	return 0;
+}
+
+static int subflow_rebuild_header(struct sock *sk)
+{
+	int err = subflow_chk_local_id(sk);
+
+	if (unlikely(err < 0))
+		return err;
+
+	return inet_sk_rebuild_header(sk);
+}
+
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+static int subflow_v6_rebuild_header(struct sock *sk)
+{
+	int err = subflow_chk_local_id(sk);
+
+	if (unlikely(err < 0))
+		return err;
+
+	return inet6_sk_rebuild_header(sk);
+}
+#endif
+
 struct request_sock_ops mptcp_subflow_request_sock_ops;
 static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops __ro_after_init;
 
@@ -1398,13 +1443,8 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 		get_random_bytes(&subflow->local_nonce, sizeof(u32));
 	} while (!subflow->local_nonce);
 
-	if (!local_id) {
-		err = mptcp_pm_get_local_id(msk, (struct sock_common *)ssk);
-		if (err < 0)
-			goto failed;
-
-		local_id = err;
-	}
+	if (local_id)
+		subflow_set_local_id(subflow, local_id);
 
 	mptcp_pm_get_flags_and_ifindex_by_id(sock_net(sk), local_id,
 					     &flags, &ifindex);
@@ -1429,7 +1469,6 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	pr_debug("msk=%p remote_token=%u local_id=%d remote_id=%d", msk,
 		 remote_token, local_id, remote_id);
 	subflow->remote_token = remote_token;
-	subflow->local_id = local_id;
 	subflow->remote_id = remote_id;
 	subflow->request_join = 1;
 	subflow->request_bkup = !!(flags & MPTCP_PM_ADDR_FLAG_BACKUP);
@@ -1728,15 +1767,22 @@ static void subflow_ulp_clone(const struct request_sock *req,
 		new_ctx->token = subflow_req->token;
 		new_ctx->ssn_offset = subflow_req->ssn_offset;
 		new_ctx->idsn = subflow_req->idsn;
+
+		/* this is the first subflow, id is always 0 */
+		new_ctx->local_id_valid = 1;
 	} else if (subflow_req->mp_join) {
 		new_ctx->ssn_offset = subflow_req->ssn_offset;
 		new_ctx->mp_join = 1;
 		new_ctx->fully_established = 1;
 		new_ctx->backup = subflow_req->backup;
-		new_ctx->local_id = subflow_req->local_id;
 		new_ctx->remote_id = subflow_req->remote_id;
 		new_ctx->token = subflow_req->token;
 		new_ctx->thmac = subflow_req->thmac;
+
+		/* the subflow req id is valid, fetched via subflow_check_req()
+		 * and subflow_token_join_request()
+		 */
+		subflow_set_local_id(new_ctx, subflow_req->local_id);
 	}
 }
 
@@ -1789,6 +1835,7 @@ void __init mptcp_subflow_init(void)
 	subflow_specific.conn_request = subflow_v4_conn_request;
 	subflow_specific.syn_recv_sock = subflow_syn_recv_sock;
 	subflow_specific.sk_rx_dst_set = subflow_finish_connect;
+	subflow_specific.rebuild_header = subflow_rebuild_header;
 
 	tcp_prot_override = tcp_prot;
 	tcp_prot_override.release_cb = tcp_release_cb_override;
@@ -1801,6 +1848,7 @@ void __init mptcp_subflow_init(void)
 	subflow_v6_specific.conn_request = subflow_v6_conn_request;
 	subflow_v6_specific.syn_recv_sock = subflow_syn_recv_sock;
 	subflow_v6_specific.sk_rx_dst_set = subflow_finish_connect;
+	subflow_v6_specific.rebuild_header = subflow_v6_rebuild_header;
 
 	subflow_v6m_specific = subflow_v6_specific;
 	subflow_v6m_specific.queue_xmit = ipv4_specific.queue_xmit;
@@ -1808,6 +1856,7 @@ void __init mptcp_subflow_init(void)
 	subflow_v6m_specific.net_header_len = ipv4_specific.net_header_len;
 	subflow_v6m_specific.mtu_reduced = ipv4_specific.mtu_reduced;
 	subflow_v6m_specific.net_frag_header_len = 0;
+	subflow_v6m_specific.rebuild_header = subflow_rebuild_header;
 
 	tcpv6_prot_override = tcpv6_prot;
 	tcpv6_prot_override.release_cb = tcp_release_cb_override;
-- 
2.35.1

