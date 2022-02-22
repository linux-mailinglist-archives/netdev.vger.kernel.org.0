Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEEA04BF0E9
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiBVE2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 23:28:55 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiBVE2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 23:28:52 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798E96397
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 20:17:57 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 8C343202B3; Tue, 22 Feb 2022 12:17:53 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>
Subject: [PATCH net-next v3 1/2] mctp: make __mctp_dev_get() take a refcount hold
Date:   Tue, 22 Feb 2022 12:17:38 +0800
Message-Id: <20220222041739.511255-2-matt@codeconstruct.com.au>
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

Previously there was a race that could allow the mctp_dev refcount
to hit zero:

rcu_read_lock();
mdev = __mctp_dev_get(dev);
// mctp_unregister() happens here, mdev->refs hits zero
mctp_dev_hold(dev);
rcu_read_unlock();

Now we make __mctp_dev_get() take the hold itself. It is safe to test
against the zero refcount because __mctp_dev_get() is called holding
rcu_read_lock and mctp_dev uses kfree_rcu().

Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 net/mctp/device.c     | 21 ++++++++++++++++++---
 net/mctp/route.c      |  5 ++++-
 net/mctp/test/utils.c |  1 -
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index 9e097e61f23a..b754c31162b1 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -25,12 +25,25 @@ struct mctp_dump_cb {
 	size_t a_idx;
 };
 
-/* unlocked: caller must hold rcu_read_lock */
+/* unlocked: caller must hold rcu_read_lock.
+ * Returned mctp_dev has its refcount incremented, or NULL if unset.
+ */
 struct mctp_dev *__mctp_dev_get(const struct net_device *dev)
 {
-	return rcu_dereference(dev->mctp_ptr);
+	struct mctp_dev *mdev = rcu_dereference(dev->mctp_ptr);
+
+	/* RCU guarantees that any mdev is still live.
+	 * Zero refcount implies a pending free, return NULL.
+	 */
+	if (mdev)
+		if (!refcount_inc_not_zero(&mdev->refs))
+			return NULL;
+	return mdev;
 }
 
+/* Returned mctp_dev does not have refcount incremented. The returned pointer
+ * remains live while rtnl_lock is held, as that prevents mctp_unregister()
+ */
 struct mctp_dev *mctp_dev_get_rtnl(const struct net_device *dev)
 {
 	return rtnl_dereference(dev->mctp_ptr);
@@ -124,6 +137,7 @@ static int mctp_dump_addrinfo(struct sk_buff *skb, struct netlink_callback *cb)
 				if (mdev) {
 					rc = mctp_dump_dev_addrinfo(mdev,
 								    skb, cb);
+					mctp_dev_put(mdev);
 					// Error indicates full buffer, this
 					// callback will get retried.
 					if (rc < 0)
@@ -298,7 +312,7 @@ void mctp_dev_hold(struct mctp_dev *mdev)
 
 void mctp_dev_put(struct mctp_dev *mdev)
 {
-	if (refcount_dec_and_test(&mdev->refs)) {
+	if (mdev && refcount_dec_and_test(&mdev->refs)) {
 		dev_put(mdev->dev);
 		kfree_rcu(mdev, rcu);
 	}
@@ -370,6 +384,7 @@ static size_t mctp_get_link_af_size(const struct net_device *dev,
 	if (!mdev)
 		return 0;
 	ret = nla_total_size(4); /* IFLA_MCTP_NET */
+	mctp_dev_put(mdev);
 	return ret;
 }
 
diff --git a/net/mctp/route.c b/net/mctp/route.c
index fe6c8bf1ec2c..6f277e56b168 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -836,7 +836,7 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 {
 	struct mctp_sock *msk = container_of(sk, struct mctp_sock, sk);
 	struct mctp_skb_cb *cb = mctp_cb(skb);
-	struct mctp_route tmp_rt;
+	struct mctp_route tmp_rt = {0};
 	struct mctp_sk_key *key;
 	struct net_device *dev;
 	struct mctp_hdr *hdr;
@@ -948,6 +948,7 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 		mctp_route_release(rt);
 
 	dev_put(dev);
+	mctp_dev_put(tmp_rt.dev);
 
 	return rc;
 
@@ -1124,11 +1125,13 @@ static int mctp_pkttype_receive(struct sk_buff *skb, struct net_device *dev,
 
 	rt->output(rt, skb);
 	mctp_route_release(rt);
+	mctp_dev_put(mdev);
 
 	return NET_RX_SUCCESS;
 
 err_drop:
 	kfree_skb(skb);
+	mctp_dev_put(mdev);
 	return NET_RX_DROP;
 }
 
diff --git a/net/mctp/test/utils.c b/net/mctp/test/utils.c
index 7b7918702592..e03ba66bbe18 100644
--- a/net/mctp/test/utils.c
+++ b/net/mctp/test/utils.c
@@ -54,7 +54,6 @@ struct mctp_test_dev *mctp_test_create_dev(void)
 
 	rcu_read_lock();
 	dev->mdev = __mctp_dev_get(ndev);
-	mctp_dev_hold(dev->mdev);
 	rcu_read_unlock();
 
 	return dev;
-- 
2.32.0

