Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 072D816FA68
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 10:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgBZJPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 04:15:20 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:60772 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727746AbgBZJPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 04:15:19 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j6smk-0001N3-85; Wed, 26 Feb 2020 10:15:18 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 5/7] mptcp: remove mptcp_read_actor
Date:   Wed, 26 Feb 2020 10:14:50 +0100
Message-Id: <20200226091452.1116-6-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226091452.1116-1-fw@strlen.de>
References: <20200226091452.1116-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only used to discard stale data from the subflow, so move
it where needed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 27 ---------------------------
 net/mptcp/protocol.h |  7 -------
 net/mptcp/subflow.c  | 18 +++++++++++++-----
 3 files changed, 13 insertions(+), 39 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 381d5647a95b..b781498e69b4 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -430,33 +430,6 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	return ret;
 }
 
-int mptcp_read_actor(read_descriptor_t *desc, struct sk_buff *skb,
-		     unsigned int offset, size_t len)
-{
-	struct mptcp_read_arg *arg = desc->arg.data;
-	size_t copy_len;
-
-	copy_len = min(desc->count, len);
-
-	if (likely(arg->msg)) {
-		int err;
-
-		err = skb_copy_datagram_msg(skb, offset, arg->msg, copy_len);
-		if (err) {
-			pr_debug("error path");
-			desc->error = err;
-			return err;
-		}
-	} else {
-		pr_debug("Flushing skb payload");
-	}
-
-	desc->count -= copy_len;
-
-	pr_debug("consumed %zu bytes, %zu left", copy_len, desc->count);
-	return copy_len;
-}
-
 static void mptcp_wait_data(struct sock *sk, long *timeo)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 6e6e162d25f1..d06170c5f191 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -191,13 +191,6 @@ void mptcp_proto_init(void);
 int mptcp_proto_v6_init(void);
 #endif
 
-struct mptcp_read_arg {
-	struct msghdr *msg;
-};
-
-int mptcp_read_actor(read_descriptor_t *desc, struct sk_buff *skb,
-		     unsigned int offset, size_t len);
-
 void mptcp_get_options(const struct sk_buff *skb,
 		       struct tcp_options_received *opt_rx);
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 3dad662840aa..37a4767db441 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -408,6 +408,18 @@ static enum mapping_status get_mapping_status(struct sock *ssk)
 	return MAPPING_OK;
 }
 
+static int subflow_read_actor(read_descriptor_t *desc,
+			      struct sk_buff *skb,
+			      unsigned int offset, size_t len)
+{
+	size_t copy_len = min(desc->count, len);
+
+	desc->count -= copy_len;
+
+	pr_debug("flushed %zu bytes, %zu left", copy_len, desc->count);
+	return copy_len;
+}
+
 static bool subflow_check_data_avail(struct sock *ssk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
@@ -482,16 +494,12 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		pr_debug("discarding %zu bytes, current map len=%d", delta,
 			 map_remaining);
 		if (delta) {
-			struct mptcp_read_arg arg = {
-				.msg = NULL,
-			};
 			read_descriptor_t desc = {
 				.count = delta,
-				.arg.data = &arg,
 			};
 			int ret;
 
-			ret = tcp_read_sock(ssk, &desc, mptcp_read_actor);
+			ret = tcp_read_sock(ssk, &desc, subflow_read_actor);
 			if (ret < 0) {
 				ssk->sk_err = -ret;
 				goto fatal;
-- 
2.24.1

