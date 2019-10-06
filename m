Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 764BBCD94F
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 23:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfJFV3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 17:29:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbfJFV3C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Oct 2019 17:29:02 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C6E22077B
        for <netdev@vger.kernel.org>; Sun,  6 Oct 2019 21:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570397341;
        bh=qLvRQsok7yap2UmJosxY8CUF92CnskhRGVgg/HdR96Q=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=wjp8mE3CCA10B0krCtBkAcB+yqMYRzL3cIiu9xmMAfVQdFsF2X6ch8+koI9VaN6Uf
         ymsnJVbqnwtWGQ5nX9rV5rGwGR6w4rWNS/pzAcbGsUaF3D9v57jf6DEH4i5TcoGOhv
         B/EAHLc9cMT86iGupmNzORbbpsTfNhn1OU59zG7c=
From:   Eric Biggers <ebiggers@kernel.org>
To:     netdev@vger.kernel.org
Subject: [PATCH net 4/4] llc: fix sk_buff refcounting in llc_conn_state_process()
Date:   Sun,  6 Oct 2019 14:24:27 -0700
Message-Id: <20191006212427.427682-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006212427.427682-1-ebiggers@kernel.org>
References: <20191006212427.427682-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

If llc_conn_state_process() sees that llc_conn_service() put the skb on
a list, it will drop one fewer references to it.  This is wrong because
the current behavior is that llc_conn_service() never consumes a
reference to the skb.

The code also makes the number of skb references being dropped
conditional on which of ind_prim and cfm_prim are nonzero, yet neither
of these affects how many references are *acquired*.  So there is extra
code that tries to fix this up by sometimes taking another reference.

Remove the unnecessary/broken refcounting logic and instead just add an
skb_get() before the only two places where an extra reference is
actually consumed.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 net/llc/llc_conn.c | 33 ++++++---------------------------
 1 file changed, 6 insertions(+), 27 deletions(-)

diff --git a/net/llc/llc_conn.c b/net/llc/llc_conn.c
index 0b0c6f12153b..a79b739eb223 100644
--- a/net/llc/llc_conn.c
+++ b/net/llc/llc_conn.c
@@ -64,12 +64,6 @@ int llc_conn_state_process(struct sock *sk, struct sk_buff *skb)
 	struct llc_sock *llc = llc_sk(skb->sk);
 	struct llc_conn_state_ev *ev = llc_conn_ev(skb);
 
-	/*
-	 * We have to hold the skb, because llc_conn_service will kfree it in
-	 * the sending path and we need to look at the skb->cb, where we encode
-	 * llc_conn_state_ev.
-	 */
-	skb_get(skb);
 	ev->ind_prim = ev->cfm_prim = 0;
 	/*
 	 * Send event to state machine
@@ -77,21 +71,12 @@ int llc_conn_state_process(struct sock *sk, struct sk_buff *skb)
 	rc = llc_conn_service(skb->sk, skb);
 	if (unlikely(rc != 0)) {
 		printk(KERN_ERR "%s: llc_conn_service failed\n", __func__);
-		goto out_kfree_skb;
-	}
-
-	if (unlikely(!ev->ind_prim && !ev->cfm_prim)) {
-		/* indicate or confirm not required */
-		if (!skb->next)
-			goto out_kfree_skb;
 		goto out_skb_put;
 	}
 
-	if (unlikely(ev->ind_prim && ev->cfm_prim)) /* Paranoia */
-		skb_get(skb);
-
 	switch (ev->ind_prim) {
 	case LLC_DATA_PRIM:
+		skb_get(skb);
 		llc_save_primitive(sk, skb, LLC_DATA_PRIM);
 		if (unlikely(sock_queue_rcv_skb(sk, skb))) {
 			/*
@@ -108,6 +93,7 @@ int llc_conn_state_process(struct sock *sk, struct sk_buff *skb)
 		 * skb->sk pointing to the newly created struct sock in
 		 * llc_conn_handler. -acme
 		 */
+		skb_get(skb);
 		skb_queue_tail(&sk->sk_receive_queue, skb);
 		sk->sk_state_change(sk);
 		break;
@@ -123,7 +109,6 @@ int llc_conn_state_process(struct sock *sk, struct sk_buff *skb)
 				sk->sk_state_change(sk);
 			}
 		}
-		kfree_skb(skb);
 		sock_put(sk);
 		break;
 	case LLC_RESET_PRIM:
@@ -132,14 +117,11 @@ int llc_conn_state_process(struct sock *sk, struct sk_buff *skb)
 		 * RESET is not being notified to upper layers for now
 		 */
 		printk(KERN_INFO "%s: received a reset ind!\n", __func__);
-		kfree_skb(skb);
 		break;
 	default:
-		if (ev->ind_prim) {
+		if (ev->ind_prim)
 			printk(KERN_INFO "%s: received unknown %d prim!\n",
 				__func__, ev->ind_prim);
-			kfree_skb(skb);
-		}
 		/* No indication */
 		break;
 	}
@@ -181,15 +163,12 @@ int llc_conn_state_process(struct sock *sk, struct sk_buff *skb)
 		printk(KERN_INFO "%s: received a reset conf!\n", __func__);
 		break;
 	default:
-		if (ev->cfm_prim) {
+		if (ev->cfm_prim)
 			printk(KERN_INFO "%s: received unknown %d prim!\n",
 					__func__, ev->cfm_prim);
-			break;
-		}
-		goto out_skb_put; /* No confirmation */
+		/* No confirmation */
+		break;
 	}
-out_kfree_skb:
-	kfree_skb(skb);
 out_skb_put:
 	kfree_skb(skb);
 	return rc;
-- 
2.23.0

