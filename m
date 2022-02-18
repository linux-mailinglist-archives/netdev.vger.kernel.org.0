Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52F74BB20F
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 07:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbiBRG3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 01:29:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbiBRG3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 01:29:39 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EC3211463
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 22:29:17 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 3D677202C6; Fri, 18 Feb 2022 14:29:15 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
Cc:     Jeremy Kerr <jk@codeconstruct.com.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net v2] mctp: Fix incorrect netdev unref for extended addr
Date:   Fri, 18 Feb 2022 14:29:08 +0800
Message-Id: <20220218062908.1994506-1-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the extended addressing local route output codepath
dev_get_by_index_rcu() doesn't take a dev_hold() so we shouldn't
dev_put(). Instead we need to hold/put the mctp_dev.

Fixes: 99ce45d5e7db ("mctp: Implement extended addressing")
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
v2: Fix incorrect "Fixes:" ID
---
 net/mctp/route.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index e52cef750500..6ef79ab4a076 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -786,9 +786,8 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 {
 	struct mctp_sock *msk = container_of(sk, struct mctp_sock, sk);
 	struct mctp_skb_cb *cb = mctp_cb(skb);
-	struct mctp_route tmp_rt;
+	struct mctp_route tmp_rt = {0};
 	struct mctp_sk_key *key;
-	struct net_device *dev;
 	struct mctp_hdr *hdr;
 	unsigned long flags;
 	unsigned int mtu;
@@ -801,12 +800,12 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 
 	if (rt) {
 		ext_rt = false;
-		dev = NULL;
-
 		if (WARN_ON(!rt->dev))
 			goto out_release;
 
 	} else if (cb->ifindex) {
+		struct net_device *dev;
+
 		ext_rt = true;
 		rt = &tmp_rt;
 
@@ -816,8 +815,9 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 			rcu_read_unlock();
 			return rc;
 		}
-
 		rt->dev = __mctp_dev_get(dev);
+		if (rt->dev)
+			mctp_dev_hold(rt->dev);
 		rcu_read_unlock();
 
 		if (!rt->dev)
@@ -891,10 +891,10 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 	if (!ext_rt)
 		mctp_route_release(rt);
 
-	dev_put(dev);
+	if (tmp_rt.dev)
+		mctp_dev_put(tmp_rt.dev);
 
 	return rc;
-
 }
 
 /* route management */
-- 
2.32.0

