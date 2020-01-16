Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3A2213ED74
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393751AbgAPRk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:40:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405002AbgAPRk4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:40:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 505932467C;
        Thu, 16 Jan 2020 17:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196455;
        bh=3HUrsoAGzyMXuXoLktI3spSeHqXSbtp2TOdGTMmPOf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R9V8qNUrm94GqyYIN/k9YSkN9Xf651bBWnHC1kQ6eHOWq7nN2nclQ46xCLDWGmBnl
         FWv0qfLwvtkZC5LYIm8cDAtyocXC9qavo+wQSPgZdklqj260NQayQM69Oe1OrgQvAN
         kQuQuoSyAhuQm9BcMkQ1sB2lzGwoRR4/QxcYwAUw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 212/251] llc: fix another potential sk_buff leak in llc_ui_sendmsg()
Date:   Thu, 16 Jan 2020 12:36:01 -0500
Message-Id: <20200116173641.22137-172-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit fc8d5db10cbe1338a52ebc74e7feab9276721774 ]

All callers of llc_conn_state_process() except llc_build_and_send_pkt()
(via llc_ui_sendmsg() -> llc_ui_send_data()) assume that it always
consumes a reference to the skb.  Fix this caller to do the same.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/llc/af_llc.c   | 34 ++++++++++++++++++++--------------
 net/llc/llc_conn.c |  2 ++
 net/llc/llc_if.c   | 12 ++++++++----
 3 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 789e66b0187a..2a859f967c8a 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -111,22 +111,26 @@ static inline u8 llc_ui_header_len(struct sock *sk, struct sockaddr_llc *addr)
  *
  *	Send data via reliable llc2 connection.
  *	Returns 0 upon success, non-zero if action did not succeed.
+ *
+ *	This function always consumes a reference to the skb.
  */
 static int llc_ui_send_data(struct sock* sk, struct sk_buff *skb, int noblock)
 {
 	struct llc_sock* llc = llc_sk(sk);
-	int rc = 0;
 
 	if (unlikely(llc_data_accept_state(llc->state) ||
 		     llc->remote_busy_flag ||
 		     llc->p_flag)) {
 		long timeout = sock_sndtimeo(sk, noblock);
+		int rc;
 
 		rc = llc_ui_wait_for_busy_core(sk, timeout);
+		if (rc) {
+			kfree_skb(skb);
+			return rc;
+		}
 	}
-	if (unlikely(!rc))
-		rc = llc_build_and_send_pkt(sk, skb);
-	return rc;
+	return llc_build_and_send_pkt(sk, skb);
 }
 
 static void llc_ui_sk_init(struct socket *sock, struct sock *sk)
@@ -896,7 +900,7 @@ static int llc_ui_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	DECLARE_SOCKADDR(struct sockaddr_llc *, addr, msg->msg_name);
 	int flags = msg->msg_flags;
 	int noblock = flags & MSG_DONTWAIT;
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
 	size_t size = 0;
 	int rc = -EINVAL, copied = 0, hdrlen;
 
@@ -905,10 +909,10 @@ static int llc_ui_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	lock_sock(sk);
 	if (addr) {
 		if (msg->msg_namelen < sizeof(*addr))
-			goto release;
+			goto out;
 	} else {
 		if (llc_ui_addr_null(&llc->addr))
-			goto release;
+			goto out;
 		addr = &llc->addr;
 	}
 	/* must bind connection to sap if user hasn't done it. */
@@ -916,7 +920,7 @@ static int llc_ui_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		/* bind to sap with null dev, exclusive. */
 		rc = llc_ui_autobind(sock, addr);
 		if (rc)
-			goto release;
+			goto out;
 	}
 	hdrlen = llc->dev->hard_header_len + llc_ui_header_len(sk, addr);
 	size = hdrlen + len;
@@ -925,12 +929,12 @@ static int llc_ui_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	copied = size - hdrlen;
 	rc = -EINVAL;
 	if (copied < 0)
-		goto release;
+		goto out;
 	release_sock(sk);
 	skb = sock_alloc_send_skb(sk, size, noblock, &rc);
 	lock_sock(sk);
 	if (!skb)
-		goto release;
+		goto out;
 	skb->dev      = llc->dev;
 	skb->protocol = llc_proto_type(addr->sllc_arphrd);
 	skb_reserve(skb, hdrlen);
@@ -940,29 +944,31 @@ static int llc_ui_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	if (sk->sk_type == SOCK_DGRAM || addr->sllc_ua) {
 		llc_build_and_send_ui_pkt(llc->sap, skb, addr->sllc_mac,
 					  addr->sllc_sap);
+		skb = NULL;
 		goto out;
 	}
 	if (addr->sllc_test) {
 		llc_build_and_send_test_pkt(llc->sap, skb, addr->sllc_mac,
 					    addr->sllc_sap);
+		skb = NULL;
 		goto out;
 	}
 	if (addr->sllc_xid) {
 		llc_build_and_send_xid_pkt(llc->sap, skb, addr->sllc_mac,
 					   addr->sllc_sap);
+		skb = NULL;
 		goto out;
 	}
 	rc = -ENOPROTOOPT;
 	if (!(sk->sk_type == SOCK_STREAM && !addr->sllc_ua))
 		goto out;
 	rc = llc_ui_send_data(sk, skb, noblock);
+	skb = NULL;
 out:
-	if (rc) {
-		kfree_skb(skb);
-release:
+	kfree_skb(skb);
+	if (rc)
 		dprintk("%s: failed sending from %02X to %02X: %d\n",
 			__func__, llc->laddr.lsap, llc->daddr.lsap, rc);
-	}
 	release_sock(sk);
 	return rc ? : copied;
 }
diff --git a/net/llc/llc_conn.c b/net/llc/llc_conn.c
index 94c78cc49d3e..2689e95471dc 100644
--- a/net/llc/llc_conn.c
+++ b/net/llc/llc_conn.c
@@ -55,6 +55,8 @@ int sysctl_llc2_busy_timeout = LLC2_BUSY_TIME * HZ;
  *	(executing it's actions and changing state), upper layer will be
  *	indicated or confirmed, if needed. Returns 0 for success, 1 for
  *	failure. The socket lock has to be held before calling this function.
+ *
+ *	This function always consumes a reference to the skb.
  */
 int llc_conn_state_process(struct sock *sk, struct sk_buff *skb)
 {
diff --git a/net/llc/llc_if.c b/net/llc/llc_if.c
index 6daf391b3e84..fc4d2bd8816f 100644
--- a/net/llc/llc_if.c
+++ b/net/llc/llc_if.c
@@ -38,6 +38,8 @@
  *	closed and -EBUSY when sending data is not permitted in this state or
  *	LLC has send an I pdu with p bit set to 1 and is waiting for it's
  *	response.
+ *
+ *	This function always consumes a reference to the skb.
  */
 int llc_build_and_send_pkt(struct sock *sk, struct sk_buff *skb)
 {
@@ -46,20 +48,22 @@ int llc_build_and_send_pkt(struct sock *sk, struct sk_buff *skb)
 	struct llc_sock *llc = llc_sk(sk);
 
 	if (unlikely(llc->state == LLC_CONN_STATE_ADM))
-		goto out;
+		goto out_free;
 	rc = -EBUSY;
 	if (unlikely(llc_data_accept_state(llc->state) || /* data_conn_refuse */
 		     llc->p_flag)) {
 		llc->failed_data_req = 1;
-		goto out;
+		goto out_free;
 	}
 	ev = llc_conn_ev(skb);
 	ev->type      = LLC_CONN_EV_TYPE_PRIM;
 	ev->prim      = LLC_DATA_PRIM;
 	ev->prim_type = LLC_PRIM_TYPE_REQ;
 	skb->dev      = llc->dev;
-	rc = llc_conn_state_process(sk, skb);
-out:
+	return llc_conn_state_process(sk, skb);
+
+out_free:
+	kfree_skb(skb);
 	return rc;
 }
 
-- 
2.20.1

