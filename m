Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3350643F521
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 05:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhJ2DEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 23:04:31 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:43078 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbhJ2DEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 23:04:30 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 60C9D2028B; Fri, 29 Oct 2021 11:01:53 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>
Subject: [PATCH net-next v2 1/3] mctp: Return new key from mctp_alloc_local_tag
Date:   Fri, 29 Oct 2021 11:01:43 +0800
Message-Id: <20211029030145.633626-2-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211029030145.633626-1-jk@codeconstruct.com.au>
References: <20211029030145.633626-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a future change, we will want the key available for future use after
allocating a new tag. This change returns the key from
mctp_alloc_local_tag, rather than just key->tag.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/route.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index c23ab3547ee5..82cc10a2fb0c 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -532,14 +532,14 @@ static void mctp_reserve_tag(struct net *net, struct mctp_sk_key *key,
 /* Allocate a locally-owned tag value for (saddr, daddr), and reserve
  * it for the socket msk
  */
-static int mctp_alloc_local_tag(struct mctp_sock *msk,
-				mctp_eid_t saddr, mctp_eid_t daddr, u8 *tagp)
+static struct mctp_sk_key *mctp_alloc_local_tag(struct mctp_sock *msk,
+						mctp_eid_t saddr,
+						mctp_eid_t daddr, u8 *tagp)
 {
 	struct net *net = sock_net(&msk->sk);
 	struct netns_mctp *mns = &net->mctp;
 	struct mctp_sk_key *key, *tmp;
 	unsigned long flags;
-	int rc = -EAGAIN;
 	u8 tagbits;
 
 	/* for NULL destination EIDs, we may get a response from any peer */
@@ -549,7 +549,7 @@ static int mctp_alloc_local_tag(struct mctp_sock *msk,
 	/* be optimistic, alloc now */
 	key = mctp_key_alloc(msk, saddr, daddr, 0, GFP_KERNEL);
 	if (!key)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	/* 8 possible tag values */
 	tagbits = 0xff;
@@ -591,18 +591,16 @@ static int mctp_alloc_local_tag(struct mctp_sock *msk,
 		trace_mctp_key_acquire(key);
 
 		*tagp = key->tag;
-		/* done with the key in this scope */
-		mctp_key_unref(key);
-		key = NULL;
-		rc = 0;
 	}
 
 	spin_unlock_irqrestore(&mns->keys_lock, flags);
 
-	if (!tagbits)
+	if (!tagbits) {
 		kfree(key);
+		return ERR_PTR(-EBUSY);
+	}
 
-	return rc;
+	return key;
 }
 
 /* routing lookups */
@@ -740,6 +738,7 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 	struct mctp_sock *msk = container_of(sk, struct mctp_sock, sk);
 	struct mctp_skb_cb *cb = mctp_cb(skb);
 	struct mctp_route tmp_rt;
+	struct mctp_sk_key *key;
 	struct net_device *dev;
 	struct mctp_hdr *hdr;
 	unsigned long flags;
@@ -799,11 +798,16 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 		goto out_release;
 
 	if (req_tag & MCTP_HDR_FLAG_TO) {
-		rc = mctp_alloc_local_tag(msk, saddr, daddr, &tag);
-		if (rc)
+		key = mctp_alloc_local_tag(msk, saddr, daddr, &tag);
+		if (IS_ERR(key)) {
+			rc = PTR_ERR(key);
 			goto out_release;
+		}
+		/* done with the key in this scope */
+		mctp_key_unref(key);
 		tag |= MCTP_HDR_FLAG_TO;
 	} else {
+		key = NULL;
 		tag = req_tag;
 	}
 
-- 
2.33.0

