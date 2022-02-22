Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE084C0233
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 20:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbiBVTpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 14:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiBVTo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 14:44:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30189B0D30;
        Tue, 22 Feb 2022 11:44:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C085F6163D;
        Tue, 22 Feb 2022 19:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B074C340F3;
        Tue, 22 Feb 2022 19:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645559071;
        bh=FCKPGGvywe0YKN4vs2b1LNVgdd2LaRLVyMjVlj1lhDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1AD2g5TCCeedxhBYn6chyDUgjXoTiK9re/zOCVaY6ZfR6X6OG5+BQrmENRWVDIZj
         4j1K8SlQ1A7FPbsx6ZMrvU1eUv5SLFmFy3eq7/PRAmlInb5jRI2QmwfH4RHdWoi0Kp
         SMO3A+WP/Oq55F+FZ6qF3/+aYcH8v58SNSDEgxFwqMZgRb1RvmHCHpYKR8NYZy4j8i
         vL1mxWOiRNkEXX1Bqn99Mr7lY3tpmWZWGdmF5P8MkCC7xS6MNCuGQsCMCwyhNcRL2m
         km7G7joPlUh0BuVlp/6UVItJ9zPsqvt5ez6/FGI7ooT4iFHTg6mTGRnVEz1LyKDiXm
         ybC21sJ4U493A==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: [PATCH v3 bpf-next 3/3] veth: allow jumbo frames in xdp mode
Date:   Tue, 22 Feb 2022 20:43:39 +0100
Message-Id: <45ea33144947e90b66b858cd6716836c84234922.1645558706.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1645558706.git.lorenzo@kernel.org>
References: <cover.1645558706.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow increasing the MTU over page boundaries on veth devices
if the attached xdp program declares to support xdp fragments.
Enable NETIF_F_ALL_TSO when the device is running in xdp mode.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 47b21b1d2fd9..2d6777aabef1 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -293,8 +293,7 @@ static int veth_forward_skb(struct net_device *dev, struct sk_buff *skb,
 /* return true if the specified skb has chances of GRO aggregation
  * Don't strive for accuracy, but try to avoid GRO overhead in the most
  * common scenarios.
- * When XDP is enabled, all traffic is considered eligible, as the xmit
- * device has TSO off.
+ * When XDP is enabled, all traffic is considered eligible.
  * When TSO is enabled on the xmit device, we are likely interested only
  * in UDP aggregation, explicitly check for that if the skb is suspected
  * - the sock_wfree destructor is used by UDP, ICMP and XDP sockets -
@@ -302,11 +301,13 @@ static int veth_forward_skb(struct net_device *dev, struct sk_buff *skb,
  */
 static bool veth_skb_is_eligible_for_gro(const struct net_device *dev,
 					 const struct net_device *rcv,
+					 const struct veth_rq *rq,
 					 const struct sk_buff *skb)
 {
-	return !(dev->features & NETIF_F_ALL_TSO) ||
-		(skb->destructor == sock_wfree &&
-		 rcv->features & (NETIF_F_GRO_FRAGLIST | NETIF_F_GRO_UDP_FWD));
+	return rcu_access_pointer(rq->xdp_prog) ||
+	       !(dev->features & NETIF_F_ALL_TSO) ||
+	       (skb->destructor == sock_wfree &&
+		rcv->features & (NETIF_F_GRO_FRAGLIST | NETIF_F_GRO_UDP_FWD));
 }
 
 static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -335,7 +336,7 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 		 * Don't bother with napi/GRO if the skb can't be aggregated
 		 */
 		use_napi = rcu_access_pointer(rq->napi) &&
-			   veth_skb_is_eligible_for_gro(dev, rcv, skb);
+			   veth_skb_is_eligible_for_gro(dev, rcv, rq, skb);
 	}
 
 	skb_tx_timestamp(skb);
@@ -1511,7 +1512,6 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	struct veth_priv *priv = netdev_priv(dev);
 	struct bpf_prog *old_prog;
 	struct net_device *peer;
-	unsigned int max_mtu;
 	int err;
 
 	old_prog = priv->_xdp_prog;
@@ -1519,6 +1519,8 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	peer = rtnl_dereference(priv->peer);
 
 	if (prog) {
+		unsigned int max_mtu;
+
 		if (!peer) {
 			NL_SET_ERR_MSG_MOD(extack, "Cannot set XDP when peer is detached");
 			err = -ENOTCONN;
@@ -1528,9 +1530,9 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 		max_mtu = PAGE_SIZE - VETH_XDP_HEADROOM -
 			  peer->hard_header_len -
 			  SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-		if (peer->mtu > max_mtu) {
-			NL_SET_ERR_MSG_MOD(extack, "Peer MTU is too large to set XDP");
-			err = -ERANGE;
+		if (!prog->aux->xdp_has_frags && peer->mtu > max_mtu) {
+			NL_SET_ERR_MSG_MOD(extack, "prog does not support XDP frags");
+			err = -EOPNOTSUPP;
 			goto err;
 		}
 
@@ -1548,10 +1550,8 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			}
 		}
 
-		if (!old_prog) {
-			peer->hw_features &= ~NETIF_F_GSO_SOFTWARE;
-			peer->max_mtu = max_mtu;
-		}
+		if (!old_prog)
+			peer->hw_features &= ~NETIF_F_GSO_FRAGLIST;
 	}
 
 	if (old_prog) {
@@ -1559,10 +1559,8 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			if (dev->flags & IFF_UP)
 				veth_disable_xdp(dev);
 
-			if (peer) {
-				peer->hw_features |= NETIF_F_GSO_SOFTWARE;
-				peer->max_mtu = ETH_MAX_MTU;
-			}
+			if (peer)
+				peer->hw_features |= NETIF_F_GSO_FRAGLIST;
 		}
 		bpf_prog_put(old_prog);
 	}
-- 
2.35.1

