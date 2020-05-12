Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026731CF688
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbgELOLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:11:19 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52648 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728085AbgELOLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 10:11:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589292677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t6r+aWF2mByE1BEe/eFrEtGteU5NwcU6UeHrM2x9QnA=;
        b=Tq5uKEl6bSw/EMSZ1T4pVg98TLAL/lrxXcLm6irPABQvwcRXqpp9O68VeDH4I4Zv+kSP00
        u5Qvc0Jf4xy2HMEzZC8c3MRdWZOk4x/V4g/ueNgQ1mRqUI8+ozE6Sxj13Mc51saXpw95mu
        Jp5ZzX4RdaJ7YAVOGwrq1wHJa8m9Eeg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-i0RdEZBFOo2iAA5P6Yn-SQ-1; Tue, 12 May 2020 10:11:15 -0400
X-MC-Unique: i0RdEZBFOo2iAA5P6Yn-SQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AC791083E8B;
        Tue, 12 May 2020 14:11:14 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-115-10.ams2.redhat.com [10.36.115.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7D2E5D9DD;
        Tue, 12 May 2020 14:11:12 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>
Subject: [RFC PATCH 1/3] mptcp: add new sock flag to deal with join subflows
Date:   Tue, 12 May 2020 16:08:08 +0200
Message-Id: <81c3f2f857c2e68e22f8e8b077410ffd2960a29f.1589280857.git.pabeni@redhat.com>
In-Reply-To: <cover.1589280857.git.pabeni@redhat.com>
References: <cover.1589280857.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
due to allocation failure.

A possible solution would be changing the syn_recv_sock()
signature to allow returning a more descriptive action/
error code and deal with that in tcp_check_req().

Since the above need is MPTCP specific, this patch instead
uses a TCP socket hole to add an MPTCP specific flag.
Such flag is used by the MPTCP syn_recv_sock() to tell
tcp_check_req() how to deal with the request socket.

This change is a no-op for !MPTCP build, and makes the
MPTCP code simpler. It allows also the next patch to deal
correctly with MP JOIN failure.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/linux/tcp.h      |  1 +
 include/net/mptcp.h      | 17 ++++++++++-------
 net/ipv4/tcp_minisocks.c |  2 +-
 net/mptcp/protocol.c     |  7 -------
 net/mptcp/subflow.c      |  2 ++
 5 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index e60db06ec28d..dc12c59db41e 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -385,6 +385,7 @@ struct tcp_sock {
 			   */
 #if IS_ENABLED(CONFIG_MPTCP)
 	bool	is_mptcp;
+	bool	drop_req;
 #endif
 
 #ifdef CONFIG_TCP_MD5SIG
diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index e60275659de6..c4809c24a185 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -68,6 +68,11 @@ static inline bool rsk_is_mptcp(const struct request_sock *req)
 	return tcp_rsk(req)->is_mptcp;
 }
 
+static inline bool sk_drop_req(const struct sock *sk)
+{
+	return tcp_sk(sk)->is_mptcp && tcp_sk(sk)->drop_req;
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
 
+static inline bool sk_drop_req(const struct sock *sk)
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
index 7e40322cc5ec..ba7cfb22dc79 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -774,7 +774,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 	if (!child)
 		goto listen_overflow;
 
-	if (own_req && sk_is_mptcp(child) && mptcp_sk_is_subflow(child)) {
+	if (own_req && sk_drop_req(child)) {
 		reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req);
 		inet_csk_reqsk_queue_drop_and_put(sk, req);
 		return child;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e1f23016ed3f..a61e60e94137 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1638,13 +1638,6 @@ bool mptcp_finish_join(struct sock *sk)
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
index 009d5c478062..b39a66ffac7a 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -500,6 +500,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			ctx->remote_key = mp_opt.sndr_key;
 			ctx->fully_established = mp_opt.mp_capable;
 			ctx->can_ack = mp_opt.mp_capable;
+			tcp_sk(child)->drop_req = false;
 		} else if (ctx->mp_join) {
 			struct mptcp_sock *owner;
 
@@ -512,6 +513,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 				goto close_child;
 
 			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKRX);
+			tcp_sk(child)->drop_req = true;
 		}
 	}
 
-- 
2.21.3

