Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3241D579F
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgEORXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:23:18 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46046 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726249AbgEORXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:23:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589563395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PvcAeFkFaj+9P6eIOQzVUo5OvI0tusYwNLjb3aq1d8w=;
        b=bB0v7NxrGmn07w/zj8NVNKW8a0Eo0Z7WgMoNGWi2Nehkycbv4fq9PqgXHQB3rwCuVkVf+O
        Cs7o3EDxfXCASkvpSSINANMnrxQtrxomZwrLrODELHvweG5P+jJyW3OnlLqOxyNPYdNmm7
        55dSTAIqKzZAGe5h0bgUdYtAY8Qll/I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-8RK92-MRMW-jdCYxJVHXqQ-1; Fri, 15 May 2020 13:23:13 -0400
X-MC-Unique: 8RK92-MRMW-jdCYxJVHXqQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADAD21005512;
        Fri, 15 May 2020 17:23:11 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-115-8.ams2.redhat.com [10.36.115.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BA13600F5;
        Fri, 15 May 2020 17:23:09 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 1/3] mptcp: add new sock flag to deal with join subflows
Date:   Fri, 15 May 2020 19:22:15 +0200
Message-Id: <a5acf97e4f39de13ba178a3a007eedd83b418702.1589558049.git.pabeni@redhat.com>
In-Reply-To: <cover.1589558049.git.pabeni@redhat.com>
References: <cover.1589558049.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MP_JOIN subflows must not land into the accept queue.
Currently tcp_check_req() calls an mptcp specific helper
to detect such scenario.

Such helper leverages the subflow context to check for
MP_JOIN subflows. We need to deal also with MP JOIN
failures, even when the subflow context is not available
due allocation failure.

A possible solution would be changing the syn_recv_sock()
signature to allow returning a more descriptive action/
error code and deal with that in tcp_check_req().

Since the above need is MPTCP specific, this patch instead
uses a TCP request socket hole to add a MPTCP specific flag.
Such flag is used by the MPTCP syn_recv_sock() to tell
tcp_check_req() how to deal with the request socket.

This change is a no-op for !MPTCP build, and makes the
MPTCP code simpler. It allows also the next patch to deal
correctly with MP JOIN failure.

v1 -> v2:
 - be more conservative on drop_req initialization (Mat)

RFC -> v1:
 - move the drop_req bit inside tcp_request_sock (Eric)

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/linux/tcp.h      |  3 +++
 include/net/mptcp.h      | 17 ++++++++++-------
 net/ipv4/tcp_minisocks.c |  2 +-
 net/mptcp/protocol.c     |  7 -------
 net/mptcp/subflow.c      |  3 +++
 5 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index e60db06ec28d..bf44e85d709d 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -120,6 +120,9 @@ struct tcp_request_sock {
 	u64				snt_synack; /* first SYNACK sent time */
 	bool				tfo_listener;
 	bool				is_mptcp;
+#if IS_ENABLED(CONFIG_MPTCP)
+	bool				drop_req;
+#endif
 	u32				txhash;
 	u32				rcv_isn;
 	u32				snt_isn;
diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index e60275659de6..c4a6ef4ba35b 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -68,6 +68,11 @@ static inline bool rsk_is_mptcp(const struct request_sock *req)
 	return tcp_rsk(req)->is_mptcp;
 }
 
+static inline bool rsk_drop_req(const struct request_sock *req)
+{
+	return tcp_rsk(req)->is_mptcp && tcp_rsk(req)->drop_req;
+}
+
 void mptcp_space(const struct sock *ssk, int *space, int *full_space);
 bool mptcp_syn_options(struct sock *sk, const struct sk_buff *skb,
 		       unsigned int *size, struct mptcp_out_options *opts);
@@ -121,8 +126,6 @@ static inline bool mptcp_skb_can_collapse(const struct sk_buff *to,
 				 skb_ext_find(from, SKB_EXT_MPTCP));
 }
 
-bool mptcp_sk_is_subflow(const struct sock *sk);
-
 void mptcp_seq_show(struct seq_file *seq);
 #else
 
@@ -140,6 +143,11 @@ static inline bool rsk_is_mptcp(const struct request_sock *req)
 	return false;
 }
 
+static inline bool rsk_drop_req(const struct request_sock *req)
+{
+	return false;
+}
+
 static inline void mptcp_parse_option(const struct sk_buff *skb,
 				      const unsigned char *ptr, int opsize,
 				      struct tcp_options_received *opt_rx)
@@ -190,11 +198,6 @@ static inline bool mptcp_skb_can_collapse(const struct sk_buff *to,
 	return true;
 }
 
-static inline bool mptcp_sk_is_subflow(const struct sock *sk)
-{
-	return false;
-}
-
 static inline void mptcp_space(const struct sock *ssk, int *s, int *fs) { }
 static inline void mptcp_seq_show(struct seq_file *seq) { }
 #endif /* CONFIG_MPTCP */
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 7e40322cc5ec..495dda2449fe 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -774,7 +774,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 	if (!child)
 		goto listen_overflow;
 
-	if (own_req && sk_is_mptcp(child) && mptcp_sk_is_subflow(child)) {
+	if (own_req && rsk_drop_req(req)) {
 		reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req);
 		inet_csk_reqsk_queue_drop_and_put(sk, req);
 		return child;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 6a812dd8b6b6..b974898eb6b5 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1687,13 +1687,6 @@ bool mptcp_finish_join(struct sock *sk)
 	return ret;
 }
 
-bool mptcp_sk_is_subflow(const struct sock *sk)
-{
-	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
-
-	return subflow->mp_join == 1;
-}
-
 static bool mptcp_memory_free(const struct sock *sk, int wake)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 009d5c478062..5e03ed8ae899 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -470,6 +470,8 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 	if (child && *own_req) {
 		struct mptcp_subflow_context *ctx = mptcp_subflow_ctx(child);
 
+		tcp_rsk(req)->drop_req = false;
+
 		/* we need to fallback on ctx allocation failure and on pre-reqs
 		 * checking above. In the latter scenario we additionally need
 		 * to reset the context to non MPTCP status.
@@ -512,6 +514,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 				goto close_child;
 
 			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKRX);
+			tcp_rsk(req)->drop_req = true;
 		}
 	}
 
-- 
2.21.3

