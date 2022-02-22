Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5208A4BF0ED
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiBVE24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 23:28:56 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiBVE2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 23:28:52 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A21C639F
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 20:17:57 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 9AF58202B9; Tue, 22 Feb 2022 12:17:54 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>
Subject: [PATCH net-next v3 2/2] mctp: Fix incorrect netdev unref for extended addr
Date:   Tue, 22 Feb 2022 12:17:39 +0800
Message-Id: <20220222041739.511255-3-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220222041739.511255-1-matt@codeconstruct.com.au>
References: <20220222041739.511255-1-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the extended addressing local route output codepath
dev_get_by_index_rcu() doesn't take a dev_hold() so we shouldn't
dev_put().

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 net/mctp/route.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index 6f277e56b168..5078ce3315cf 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -838,7 +838,6 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 	struct mctp_skb_cb *cb = mctp_cb(skb);
 	struct mctp_route tmp_rt = {0};
 	struct mctp_sk_key *key;
-	struct net_device *dev;
 	struct mctp_hdr *hdr;
 	unsigned long flags;
 	unsigned int mtu;
@@ -851,12 +850,12 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 
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
 
@@ -866,7 +865,6 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 			rcu_read_unlock();
 			return rc;
 		}
-
 		rt->dev = __mctp_dev_get(dev);
 		rcu_read_unlock();
 
@@ -947,11 +945,9 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 	if (!ext_rt)
 		mctp_route_release(rt);
 
-	dev_put(dev);
 	mctp_dev_put(tmp_rt.dev);
 
 	return rc;
-
 }
 
 /* route management */
-- 
2.32.0

