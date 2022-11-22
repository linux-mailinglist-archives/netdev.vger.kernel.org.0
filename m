Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7A86331C6
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 02:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbiKVBE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 20:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbiKVBE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 20:04:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2C1DF40;
        Mon, 21 Nov 2022 17:04:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A4D06151E;
        Tue, 22 Nov 2022 01:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75FB9C43166;
        Tue, 22 Nov 2022 01:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669079063;
        bh=yoNO14jnT7/3wJpWHWo0CYgw8+T0b3nI0VWmVo/0VZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTez867UG51Rj10O9MBv8/3v+xkdrmwVzCDqX9ISWk5WFBZYKeDXeOODA9souyOXQ
         53WH/uy/84JsK2tNKVG2Jvi0x8VhcDvWhBLP0mZQqp6x2bZJqPl3z4afQjFW7ETIX+
         OpceptNxp1GZpjnzC6xWRWl5nqZDjSRBvAarT3P2OOH6PRYJOzrB6Cf9iXiQGD1ZKU
         zr7ICASGaotS6FZUO9zEcuJPFKFuknV5yCsy84GE3hS3YoH3Yjwn9N9Tqvdy3CCXYz
         O2lfCRltmaMbxQLYhotx/3UEQo1EP97pAcoNAmWX2AWBVjzrcYz67tww5M5f1CF82i
         m1p7zPsS+2dhA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 8EC005C1C98; Mon, 21 Nov 2022 17:04:22 -0800 (PST)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@meta.com,
        rostedt@goodmis.org, Eric Dumazet <edumazet@google.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: [PATCH v2 rcu 16/16] net: devinet: Reduce refcount before grace period
Date:   Mon, 21 Nov 2022 17:04:21 -0800
Message-Id: <20221122010421.3799681-16-paulmck@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20221122010408.GA3799268@paulmck-ThinkPad-P17-Gen-1>
References: <20221122010408.GA3799268@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Currently, the inetdev_destroy() function waits for an RCU grace period
before decrementing the refcount and freeing memory. This causes a delay
with a new RCU configuration that tries to save power, which results in the
network interface disappearing later than expected. The resulting delay
causes test failures on ChromeOS.

Refactor the code such that the refcount is freed before the grace period
and memory is freed after. With this a ChromeOS network test passes that
does 'ip netns del' and polls for an interface disappearing, now passes.

Reported-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: <netdev@vger.kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 net/ipv4/devinet.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index e8b9a9202fecd..b0acf6e19aed3 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -234,13 +234,20 @@ static void inet_free_ifa(struct in_ifaddr *ifa)
 	call_rcu(&ifa->rcu_head, inet_rcu_free_ifa);
 }
 
+static void in_dev_free_rcu(struct rcu_head *head)
+{
+	struct in_device *idev = container_of(head, struct in_device, rcu_head);
+
+	kfree(rcu_dereference_protected(idev->mc_hash, 1));
+	kfree(idev);
+}
+
 void in_dev_finish_destroy(struct in_device *idev)
 {
 	struct net_device *dev = idev->dev;
 
 	WARN_ON(idev->ifa_list);
 	WARN_ON(idev->mc_list);
-	kfree(rcu_dereference_protected(idev->mc_hash, 1));
 #ifdef NET_REFCNT_DEBUG
 	pr_debug("%s: %p=%s\n", __func__, idev, dev ? dev->name : "NIL");
 #endif
@@ -248,7 +255,7 @@ void in_dev_finish_destroy(struct in_device *idev)
 	if (!idev->dead)
 		pr_err("Freeing alive in_device %p\n", idev);
 	else
-		kfree(idev);
+		call_rcu(&idev->rcu_head, in_dev_free_rcu);
 }
 EXPORT_SYMBOL(in_dev_finish_destroy);
 
@@ -298,12 +305,6 @@ static struct in_device *inetdev_init(struct net_device *dev)
 	goto out;
 }
 
-static void in_dev_rcu_put(struct rcu_head *head)
-{
-	struct in_device *idev = container_of(head, struct in_device, rcu_head);
-	in_dev_put(idev);
-}
-
 static void inetdev_destroy(struct in_device *in_dev)
 {
 	struct net_device *dev;
@@ -328,7 +329,7 @@ static void inetdev_destroy(struct in_device *in_dev)
 	neigh_parms_release(&arp_tbl, in_dev->arp_parms);
 	arp_ifdown(dev);
 
-	call_rcu(&in_dev->rcu_head, in_dev_rcu_put);
+	in_dev_put(in_dev);
 }
 
 int inet_addr_onlink(struct in_device *in_dev, __be32 a, __be32 b)
-- 
2.31.1.189.g2e36527f23

