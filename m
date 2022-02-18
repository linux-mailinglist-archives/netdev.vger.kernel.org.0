Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91DDC4BB13F
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 06:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiBRFWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 00:22:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiBRFWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 00:22:22 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764FB366A7
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 21:22:06 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 562C0202C6; Fri, 18 Feb 2022 13:22:04 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>
Subject: [PATCH net] mctp: Fix incorrect netdev unref for extended addr
Date:   Fri, 18 Feb 2022 13:19:18 +0800
Message-Id: <20220218051918.1914025-1-matt@codeconstruct.com.au>
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

Fixes: 2a98db59117e ("mctp: Implement extended addressing")
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
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

