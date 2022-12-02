Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24908640DA8
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbiLBSn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233505AbiLBSne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:43:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8941901D
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 10:41:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A591B82221
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 18:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7144CC433C1;
        Fri,  2 Dec 2022 18:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670006513;
        bh=20/HYPFkoqYmlzwbHxATpPmucontFt+izILkZymGnpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+RKGL9Jjoz/0imFDiUMgdpmbajYfYTWNPpgMIhxQllF7vGHnOt2IND6L59WLtwoY
         n9Hj24iGzzT/S2qvqKuDi1tK2IckBKGCgwjawV8EZh5hnq9EJy0aaGlxB66EA3Yc5J
         BKISM0kvX//AsHXCtQxSoCevrPVUKGcFMWgv3F929w78xivt4EbUG2LsDxvIRe9rIw
         lMRSnSO5pDWz07lf0AMJCWtiMKgCC80Jf/DBAgErUFSzkhGjNsqrCE+sRDpFH24Eye
         oIQ4rP8S1Ynep7WXqIQelU9luvlrBWdZcIJxY6Zyxt9Nn5py9vQvsBtbQyGZx0ch4E
         leGgSwLOijCFA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH xfrm-next v10 4/8] xfrm: add TX datapath support for IPsec packet offload mode
Date:   Fri,  2 Dec 2022 20:41:30 +0200
Message-Id: <9a9bd1a8b3c3ed3d31a7ec7bf9b5e16353240a8a.1670005543.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670005543.git.leonro@nvidia.com>
References: <cover.1670005543.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

In IPsec packet mode, the device is going to encrypt and encapsulate
packets that are associated with offloaded policy. After successful
policy lookup to indicate if packets should be offloaded or not,
the stack forwards packets to the device to do the magic.

Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/xfrm/xfrm_device.c |  15 ++++-
 net/xfrm/xfrm_output.c |  12 +++-
 net/xfrm/xfrm_state.c  | 121 ++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 142 insertions(+), 6 deletions(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 04ae510dcc66..3e9e874522a8 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -132,6 +132,16 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	if (xo->flags & XFRM_GRO || x->xso.dir == XFRM_DEV_OFFLOAD_IN)
 		return skb;
 
+	/* The packet was sent to HW IPsec packet offload engine,
+	 * but to wrong device. Drop the packet, so it won't skip
+	 * XFRM stack.
+	 */
+	if (x->xso.type == XFRM_DEV_OFFLOAD_PACKET && x->xso.dev != dev) {
+		kfree_skb(skb);
+		dev_core_stats_tx_dropped_inc(dev);
+		return NULL;
+	}
+
 	/* This skb was already validated on the upper/virtual dev */
 	if ((x->xso.dev != dev) && (x->xso.real_dev == dev))
 		return skb;
@@ -398,8 +408,9 @@ bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 	if (!x->type_offload || x->encap)
 		return false;
 
-	if ((!dev || (dev == xfrm_dst_path(dst)->dev)) &&
-	    (!xdst->child->xfrm)) {
+	if (x->xso.type == XFRM_DEV_OFFLOAD_PACKET ||
+	    ((!dev || (dev == xfrm_dst_path(dst)->dev)) &&
+	     !xdst->child->xfrm)) {
 		mtu = xfrm_state_mtu(x, xdst->child_mtu_cached);
 		if (skb->len <= mtu)
 			goto ok;
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 78cb8d0a6a18..ff114d68cc43 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -492,7 +492,7 @@ static int xfrm_output_one(struct sk_buff *skb, int err)
 	struct xfrm_state *x = dst->xfrm;
 	struct net *net = xs_net(x);
 
-	if (err <= 0)
+	if (err <= 0 || x->xso.type == XFRM_DEV_OFFLOAD_PACKET)
 		goto resume;
 
 	do {
@@ -717,6 +717,16 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 		break;
 	}
 
+	if (x->xso.type == XFRM_DEV_OFFLOAD_PACKET) {
+		if (!xfrm_dev_offload_ok(skb, x)) {
+			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTERROR);
+			kfree_skb(skb);
+			return -EHOSTUNREACH;
+		}
+
+		return xfrm_output_resume(sk, skb, 0);
+	}
+
 	secpath_reset(skb);
 
 	if (xfrm_dev_offload_ok(skb, x)) {
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 9ec481fbfb63..4d315e1a88fa 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -951,6 +951,49 @@ xfrm_init_tempstate(struct xfrm_state *x, const struct flowi *fl,
 	x->props.family = tmpl->encap_family;
 }
 
+static struct xfrm_state *__xfrm_state_lookup_all(struct net *net, u32 mark,
+						  const xfrm_address_t *daddr,
+						  __be32 spi, u8 proto,
+						  unsigned short family,
+						  struct xfrm_dev_offload *xdo)
+{
+	unsigned int h = xfrm_spi_hash(net, daddr, spi, proto, family);
+	struct xfrm_state *x;
+
+	hlist_for_each_entry_rcu(x, net->xfrm.state_byspi + h, byspi) {
+#ifdef CONFIG_XFRM_OFFLOAD
+		if (xdo->type == XFRM_DEV_OFFLOAD_PACKET) {
+			if (x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
+				/* HW states are in the head of list, there is
+				 * no need to iterate further.
+				 */
+				break;
+
+			/* Packet offload: both policy and SA should
+			 * have same device.
+			 */
+			if (xdo->dev != x->xso.dev)
+				continue;
+		} else if (x->xso.type == XFRM_DEV_OFFLOAD_PACKET)
+			/* Skip HW policy for SW lookups */
+			continue;
+#endif
+		if (x->props.family != family ||
+		    x->id.spi       != spi ||
+		    x->id.proto     != proto ||
+		    !xfrm_addr_equal(&x->id.daddr, daddr, family))
+			continue;
+
+		if ((mark & x->mark.m) != x->mark.v)
+			continue;
+		if (!xfrm_state_hold_rcu(x))
+			continue;
+		return x;
+	}
+
+	return NULL;
+}
+
 static struct xfrm_state *__xfrm_state_lookup(struct net *net, u32 mark,
 					      const xfrm_address_t *daddr,
 					      __be32 spi, u8 proto,
@@ -1092,6 +1135,23 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 	rcu_read_lock();
 	h = xfrm_dst_hash(net, daddr, saddr, tmpl->reqid, encap_family);
 	hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h, bydst) {
+#ifdef CONFIG_XFRM_OFFLOAD
+		if (pol->xdo.type == XFRM_DEV_OFFLOAD_PACKET) {
+			if (x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
+				/* HW states are in the head of list, there is
+				 * no need to iterate further.
+				 */
+				break;
+
+			/* Packet offload: both policy and SA should
+			 * have same device.
+			 */
+			if (pol->xdo.dev != x->xso.dev)
+				continue;
+		} else if (x->xso.type == XFRM_DEV_OFFLOAD_PACKET)
+			/* Skip HW policy for SW lookups */
+			continue;
+#endif
 		if (x->props.family == encap_family &&
 		    x->props.reqid == tmpl->reqid &&
 		    (mark & x->mark.m) == x->mark.v &&
@@ -1109,6 +1169,23 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 
 	h_wildcard = xfrm_dst_hash(net, daddr, &saddr_wildcard, tmpl->reqid, encap_family);
 	hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h_wildcard, bydst) {
+#ifdef CONFIG_XFRM_OFFLOAD
+		if (pol->xdo.type == XFRM_DEV_OFFLOAD_PACKET) {
+			if (x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
+				/* HW states are in the head of list, there is
+				 * no need to iterate further.
+				 */
+				break;
+
+			/* Packet offload: both policy and SA should
+			 * have same device.
+			 */
+			if (pol->xdo.dev != x->xso.dev)
+				continue;
+		} else if (x->xso.type == XFRM_DEV_OFFLOAD_PACKET)
+			/* Skip HW policy for SW lookups */
+			continue;
+#endif
 		if (x->props.family == encap_family &&
 		    x->props.reqid == tmpl->reqid &&
 		    (mark & x->mark.m) == x->mark.v &&
@@ -1126,8 +1203,10 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 	x = best;
 	if (!x && !error && !acquire_in_progress) {
 		if (tmpl->id.spi &&
-		    (x0 = __xfrm_state_lookup(net, mark, daddr, tmpl->id.spi,
-					      tmpl->id.proto, encap_family)) != NULL) {
+		    (x0 = __xfrm_state_lookup_all(net, mark, daddr,
+						  tmpl->id.spi, tmpl->id.proto,
+						  encap_family,
+						  &pol->xdo)) != NULL) {
 			to_put = x0;
 			error = -EEXIST;
 			goto out;
@@ -1161,7 +1240,31 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 			x = NULL;
 			goto out;
 		}
-
+#ifdef CONFIG_XFRM_OFFLOAD
+		if (pol->xdo.type == XFRM_DEV_OFFLOAD_PACKET) {
+			struct xfrm_dev_offload *xdo = &pol->xdo;
+			struct xfrm_dev_offload *xso = &x->xso;
+
+			xso->type = XFRM_DEV_OFFLOAD_PACKET;
+			xso->dir = xdo->dir;
+			xso->dev = xdo->dev;
+			xso->real_dev = xdo->real_dev;
+			netdev_tracker_alloc(xso->dev, &xso->dev_tracker,
+					     GFP_ATOMIC);
+			error = xso->dev->xfrmdev_ops->xdo_dev_state_add(x);
+			if (error) {
+				xso->dir = 0;
+				netdev_put(xso->dev, &xso->dev_tracker);
+				xso->dev = NULL;
+				xso->real_dev = NULL;
+				xso->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
+				x->km.state = XFRM_STATE_DEAD;
+				to_put = x;
+				x = NULL;
+				goto out;
+			}
+		}
+#endif
 		if (km_query(x, tmpl, pol) == 0) {
 			spin_lock_bh(&net->xfrm.xfrm_state_lock);
 			x->km.state = XFRM_STATE_ACQ;
@@ -1185,6 +1288,18 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 			xfrm_hash_grow_check(net, x->bydst.next != NULL);
 			spin_unlock_bh(&net->xfrm.xfrm_state_lock);
 		} else {
+#ifdef CONFIG_XFRM_OFFLOAD
+			struct xfrm_dev_offload *xso = &x->xso;
+
+			if (xso->type == XFRM_DEV_OFFLOAD_PACKET) {
+				xso->dev->xfrmdev_ops->xdo_dev_state_delete(x);
+				xso->dir = 0;
+				netdev_put(xso->dev, &xso->dev_tracker);
+				xso->dev = NULL;
+				xso->real_dev = NULL;
+				xso->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
+			}
+#endif
 			x->km.state = XFRM_STATE_DEAD;
 			to_put = x;
 			x = NULL;
-- 
2.38.1

