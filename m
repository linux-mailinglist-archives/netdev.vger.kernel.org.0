Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF7C2FCF02
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 12:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389151AbhATLQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 06:16:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33868 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387750AbhATKm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 05:42:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611139283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JKcnZfeTiHrtSRMOyvCkxsDxYtxiiPCLl/3DVuahSug=;
        b=JQN4bwm7WA11996k9xJjZRFZ8rotfa63ate+PjzUkx7XVcIE7EwMjb18ZjxKAu8LqeDtJp
        RfaeStykTobsGObQy4QT+acX8R8nHU2qkDv3GtQb7ClBVcGbLH02cq2X4ef3vwTuNByloM
        G3/nOfjNl/uIMGrFmGG/7NVh3ceJx3A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-YqVZahbkM0WlciBxggtYAQ-1; Wed, 20 Jan 2021 05:41:21 -0500
X-MC-Unique: YqVZahbkM0WlciBxggtYAQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09EE7107ACE8;
        Wed, 20 Jan 2021 10:41:20 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-164.ams2.redhat.com [10.36.115.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C322760C6A;
        Wed, 20 Jan 2021 10:41:18 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net-next 5/5] mptcp: implement delegated actions
Date:   Wed, 20 Jan 2021 11:40:40 +0100
Message-Id: <8706d39df58e903238c050999e6f88b8eb78d4a1.1610991949.git.pabeni@redhat.com>
In-Reply-To: <cover.1610991949.git.pabeni@redhat.com>
References: <cover.1610991949.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On MPTCP-level ack reception, the packet scheduler
may select a subflow other than the current one.

Prior to this commit we rely on the workqueue to trigger
action on such subflow.

This changeset introduces an infrastructure that allows
any MPTCP subflow to schedule actions (MPTCP xmit) on
others subflows without resorting to (multiple) processes
reschedule.

A dummy NAPI instance is used instead. When MPTCP needs to
trigger action on a different subflow, it enqueues the target
subflow on the NAPI backlog and schedule such instance as needed.

The dummy NAPI poll method walks the enqueued sockets and tries
to acquire the (BH) socket lock on each of them. If the socket
is owned by the user space, the action will be completed by
the sock release callback, otherwise push is started.

This change leverages the delegated action infrastructure
to avoid invoking the MPTCP worker to spool the pending data,
when the packet scheduler picks a subflow other than the one
currently processing the incoming MPTCP-level ack.

Additionally we further refine the subflow selection
invoking the packet scheduler for each chunk of data
even inside __mptcp_subflow_push_pending().

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 83 +++++++++++++++++++++++++++++++++++++++++---
 net/mptcp/protocol.h | 52 +++++++++++++++++++++++++++
 net/mptcp/subflow.c  | 39 +++++++++++++++++++++
 3 files changed, 170 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 8cb582eee2862..442ad81d4abcf 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -45,6 +45,9 @@ static struct percpu_counter mptcp_sockets_allocated;
 static void __mptcp_destroy_sock(struct sock *sk);
 static void __mptcp_check_send_data_fin(struct sock *sk);
 
+DEFINE_PER_CPU(struct mptcp_delegated_action, mptcp_delegated_actions);
+static struct net_device mptcp_napi_dev;
+
 /* If msk has an initial subflow socket, and the MP_CAPABLE handshake has not
  * completed yet or has failed, return the subflow socket.
  * Otherwise return NULL.
@@ -1506,7 +1509,9 @@ static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk)
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_sendmsg_info info;
 	struct mptcp_data_frag *dfrag;
+	struct sock *xmit_ssk;
 	int len, copied = 0;
+	bool first = true;
 
 	info.flags = 0;
 	while ((dfrag = mptcp_send_head(sk))) {
@@ -1516,6 +1521,18 @@ static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk)
 		while (len > 0) {
 			int ret = 0;
 
+			/* the caller already invoked the packet scheduler,
+			 * check for a different subflow usage only after
+			 * spooling the first chunk of data
+			 */
+			xmit_ssk = first ? ssk : mptcp_subflow_get_send(mptcp_sk(sk));
+			if (!xmit_ssk)
+				goto out;
+			if (xmit_ssk != ssk) {
+				mptcp_subflow_delegate(mptcp_subflow_ctx(xmit_ssk));
+				goto out;
+			}
+
 			if (unlikely(mptcp_must_reclaim_memory(sk, ssk))) {
 				__mptcp_update_wmem(sk);
 				sk_mem_reclaim_partial(sk);
@@ -1534,6 +1551,7 @@ static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk)
 			msk->tx_pending_data -= ret;
 			copied += ret;
 			len -= ret;
+			first = false;
 		}
 		WRITE_ONCE(msk->first_pending, mptcp_send_next(sk));
 	}
@@ -2242,7 +2260,6 @@ static void mptcp_worker(struct work_struct *work)
 	if (unlikely(state == TCP_CLOSE))
 		goto unlock;
 
-	mptcp_push_pending(sk, 0);
 	mptcp_check_data_fin_ack(sk);
 	__mptcp_flush_join_list(msk);
 
@@ -2901,10 +2918,12 @@ void __mptcp_check_push(struct sock *sk, struct sock *ssk)
 		return;
 
 	if (!sock_owned_by_user(sk)) {
-		if (mptcp_subflow_get_send(mptcp_sk(sk)) == ssk)
+		struct sock *xmit_ssk = mptcp_subflow_get_send(mptcp_sk(sk));
+
+		if (xmit_ssk == ssk)
 			__mptcp_subflow_push_pending(sk, ssk);
-		else
-			mptcp_schedule_work(sk);
+		else if (xmit_ssk)
+			mptcp_subflow_delegate(mptcp_subflow_ctx(xmit_ssk));
 	} else {
 		set_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags);
 	}
@@ -2955,6 +2974,20 @@ static void mptcp_release_cb(struct sock *sk)
 	}
 }
 
+void mptcp_subflow_process_delegated(struct sock *ssk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	struct sock *sk = subflow->conn;
+
+	mptcp_data_lock(sk);
+	if (!sock_owned_by_user(sk))
+		__mptcp_subflow_push_pending(sk, ssk);
+	else
+		set_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags);
+	mptcp_data_unlock(sk);
+	mptcp_subflow_delegated_done(subflow);
+}
+
 static int mptcp_hash(struct sock *sk)
 {
 	/* should never be called,
@@ -3365,13 +3398,55 @@ static struct inet_protosw mptcp_protosw = {
 	.flags		= INET_PROTOSW_ICSK,
 };
 
+static int mptcp_napi_poll(struct napi_struct *napi, int budget)
+{
+	struct mptcp_delegated_action *delegated;
+	struct mptcp_subflow_context *subflow;
+	int work_done = 0;
+
+	delegated = container_of(napi, struct mptcp_delegated_action, napi);
+	while ((subflow = mptcp_subflow_delegated_next(delegated)) != NULL) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+		bh_lock_sock_nested(ssk);
+		if (!sock_owned_by_user(ssk))
+			mptcp_subflow_process_delegated(ssk);
+
+		/* if the sock is locked the delegated status will be cleared
+		 * by tcp_release_cb_override
+		 */
+		bh_unlock_sock(ssk);
+
+		if (++work_done == budget)
+			return budget;
+	}
+
+	/* always provide a 0 'work_done' argument, so that napi_complete_done
+	 * will not try accessing the NULL napi->dev ptr
+	 */
+	napi_complete_done(napi, 0);
+	return work_done;
+}
+
 void __init mptcp_proto_init(void)
 {
+	struct mptcp_delegated_action *delegated;
+	int cpu;
+
 	mptcp_prot.h.hashinfo = tcp_prot.h.hashinfo;
 
 	if (percpu_counter_init(&mptcp_sockets_allocated, 0, GFP_KERNEL))
 		panic("Failed to allocate MPTCP pcpu counter\n");
 
+	init_dummy_netdev(&mptcp_napi_dev);
+	for_each_possible_cpu(cpu) {
+		delegated = per_cpu_ptr(&mptcp_delegated_actions, cpu);
+		INIT_LIST_HEAD(&delegated->head);
+		netif_tx_napi_add(&mptcp_napi_dev, &delegated->napi, mptcp_napi_poll,
+				  NAPI_POLL_WEIGHT);
+		napi_enable(&delegated->napi);
+	}
+
 	mptcp_subflow_init();
 	mptcp_pm_init();
 	mptcp_token_init();
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 871534df6140f..7fa2ac3f2f4e8 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -378,6 +378,13 @@ enum mptcp_data_avail {
 	MPTCP_SUBFLOW_OOO_DATA
 };
 
+struct mptcp_delegated_action {
+	struct napi_struct napi;
+	struct list_head head;
+};
+
+DECLARE_PER_CPU(struct mptcp_delegated_action, mptcp_delegated_actions);
+
 /* MPTCP subflow context */
 struct mptcp_subflow_context {
 	struct	list_head node;/* conn_list of subflows */
@@ -415,6 +422,9 @@ struct mptcp_subflow_context {
 	u8	local_id;
 	u8	remote_id;
 
+	long	delegated_status;
+	struct	list_head delegated_node;
+
 	struct	sock *tcp_sock;	    /* tcp sk backpointer */
 	struct	sock *conn;	    /* parent mptcp_sock */
 	const	struct inet_connection_sock_af_ops *icsk_af_ops;
@@ -463,6 +473,48 @@ static inline void mptcp_add_pending_subflow(struct mptcp_sock *msk,
 	spin_unlock_bh(&msk->join_list_lock);
 }
 
+void mptcp_subflow_process_delegated(struct sock *ssk);
+
+static inline void mptcp_subflow_delegate(struct mptcp_subflow_context *subflow)
+{
+	struct mptcp_delegated_action *delegated;
+	bool schedule;
+
+	if (!test_and_set_bit(1, &subflow->delegated_status)) {
+		local_bh_disable();
+		delegated = this_cpu_ptr(&mptcp_delegated_actions);
+		schedule = list_empty(&delegated->head);
+		list_add_tail(&subflow->delegated_node, &delegated->head);
+		if (schedule)
+			napi_schedule(&delegated->napi);
+		local_bh_enable();
+	}
+}
+
+static inline struct mptcp_subflow_context *
+mptcp_subflow_delegated_next(struct mptcp_delegated_action *delegated)
+{
+	struct mptcp_subflow_context *ret;
+
+	if (list_empty(&delegated->head))
+		return NULL;
+
+	ret = list_first_entry(&delegated->head, struct mptcp_subflow_context, delegated_node);
+	list_del_init(&ret->delegated_node);
+	return ret;
+}
+
+static inline bool mptcp_subflow_has_delegated_action(const struct mptcp_subflow_context *subflow)
+{
+	return !test_bit(1, &subflow->delegated_status);
+}
+
+static inline void mptcp_subflow_delegated_done(struct mptcp_subflow_context *subflow)
+{
+	clear_bit(1, &subflow->delegated_status);
+	list_del_init(&subflow->delegated_node);
+}
+
 int mptcp_is_enabled(struct net *net);
 unsigned int mptcp_get_add_addr_timeout(struct net *net);
 void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 1ca0c82b0dbde..4a1e7866cf517 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -18,6 +18,7 @@
 #include <net/tcp.h>
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 #include <net/ip6_route.h>
+#include <net/transp_v6.h>
 #endif
 #include <net/mptcp.h>
 #include <uapi/linux/mptcp.h>
@@ -428,6 +429,7 @@ static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
 static struct tcp_request_sock_ops subflow_request_sock_ipv6_ops;
 static struct inet_connection_sock_af_ops subflow_v6_specific;
 static struct inet_connection_sock_af_ops subflow_v6m_specific;
+static struct proto tcpv6_prot_override;
 
 static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 {
@@ -509,6 +511,14 @@ static void subflow_ulp_fallback(struct sock *sk,
 	icsk->icsk_ulp_ops = NULL;
 	rcu_assign_pointer(icsk->icsk_ulp_data, NULL);
 	tcp_sk(sk)->is_mptcp = 0;
+
+	/* undo override */
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	if (sk->sk_prot == &tcpv6_prot_override)
+		sk->sk_prot = &tcpv6_prot;
+	else
+#endif
+		sk->sk_prot = &tcp_prot;
 }
 
 static void subflow_drop_ctx(struct sock *ssk)
@@ -682,6 +692,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 }
 
 static struct inet_connection_sock_af_ops subflow_specific;
+static struct proto tcp_prot_override;
 
 enum mapping_status {
 	MAPPING_OK,
@@ -1203,6 +1214,16 @@ static void mptcp_attach_cgroup(struct sock *parent, struct sock *child)
 #endif /* CONFIG_SOCK_CGROUP_DATA */
 }
 
+static void mptcp_subflow_ops_override(struct sock *ssk)
+{
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	if (ssk->sk_prot == &tcpv6_prot)
+		ssk->sk_prot = &tcpv6_prot_override;
+	else
+#endif
+		ssk->sk_prot = &tcp_prot_override;
+}
+
 int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 {
 	struct mptcp_subflow_context *subflow;
@@ -1258,6 +1279,7 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 	*new_sock = sf;
 	sock_hold(sk);
 	subflow->conn = sk;
+	mptcp_subflow_ops_override(sf->sk);
 
 	return 0;
 }
@@ -1274,6 +1296,7 @@ static struct mptcp_subflow_context *subflow_create_ctx(struct sock *sk,
 
 	rcu_assign_pointer(icsk->icsk_ulp_data, ctx);
 	INIT_LIST_HEAD(&ctx->node);
+	INIT_LIST_HEAD(&ctx->delegated_node);
 
 	pr_debug("subflow=%p", ctx);
 
@@ -1439,6 +1462,16 @@ static void subflow_ulp_clone(const struct request_sock *req,
 	}
 }
 
+static void tcp_release_cb_override(struct sock *ssk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+
+	if (mptcp_subflow_has_delegated_action(subflow))
+		mptcp_subflow_process_delegated(ssk);
+
+	tcp_release_cb(ssk);
+}
+
 static struct tcp_ulp_ops subflow_ulp_ops __read_mostly = {
 	.name		= "mptcp",
 	.owner		= THIS_MODULE,
@@ -1479,6 +1512,9 @@ void __init mptcp_subflow_init(void)
 	subflow_specific.syn_recv_sock = subflow_syn_recv_sock;
 	subflow_specific.sk_rx_dst_set = subflow_finish_connect;
 
+	tcp_prot_override = tcp_prot;
+	tcp_prot_override.release_cb = tcp_release_cb_override;
+
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 	subflow_request_sock_ipv6_ops = tcp_request_sock_ipv6_ops;
 	subflow_request_sock_ipv6_ops.route_req = subflow_v6_route_req;
@@ -1494,6 +1530,9 @@ void __init mptcp_subflow_init(void)
 	subflow_v6m_specific.net_header_len = ipv4_specific.net_header_len;
 	subflow_v6m_specific.mtu_reduced = ipv4_specific.mtu_reduced;
 	subflow_v6m_specific.net_frag_header_len = 0;
+
+	tcpv6_prot_override = tcpv6_prot;
+	tcpv6_prot_override.release_cb = tcp_release_cb_override;
 #endif
 
 	mptcp_diag_subflow_init(&subflow_ulp_ops);
-- 
2.26.2

