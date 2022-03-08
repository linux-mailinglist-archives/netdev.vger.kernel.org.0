Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7FA4D1CC5
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 17:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348144AbiCHQHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 11:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348141AbiCHQHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 11:07:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED28506ED;
        Tue,  8 Mar 2022 08:06:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEBF761700;
        Tue,  8 Mar 2022 16:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E95C340EB;
        Tue,  8 Mar 2022 16:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646755600;
        bh=SzMKhNQ5lQgLCj4MtTg1AA64E4vnZL1Bd6/sbl/i9/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCEJImAk10jIGT06538PWfpo8F5Kzfd/HrG2syJDv8iPvyVhb7R8lUi4xBi+EJsfN
         Net7iYUAcO2qeVKcyNGmVdnir6v3tnOY/HNWoPoRzJ/CbbLqqdkbWfhlvIUjlKw95S
         lvNNoiX6G2PMePkuegZd/KJ13SNiSqjz2uiiUvi4JeqzsAmKhEKC0vpAFE/OQgKxmP
         RclibLu4je9fDLl7hCRhCEwaPbCsJeog7afWLOraLzKwAlS/df5huYzj4l06RTVJFc
         2UwsroHI9o1BzIp4zAyoE3FfsNwAab/tW+H6rYTceAcuw3Ltnqh8LYkj5qBbKTAWzJ
         o1LKxdsUVpncA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: [PATCH v4 bpf-next 3/3] veth: allow jumbo frames in xdp mode
Date:   Tue,  8 Mar 2022 17:06:00 +0100
Message-Id: <930b1ad3d84f7ca5a41ba75571f9146a932c5394.1646755129.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1646755129.git.lorenzo@kernel.org>
References: <cover.1646755129.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/net/veth.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 47b21b1d2fd9..c5a2dc2b2e4b 100644
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
@@ -1525,9 +1526,14 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			goto err;
 		}
 
-		max_mtu = PAGE_SIZE - VETH_XDP_HEADROOM -
-			  peer->hard_header_len -
-			  SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+		max_mtu = SKB_WITH_OVERHEAD(PAGE_SIZE - VETH_XDP_HEADROOM) -
+			  peer->hard_header_len;
+		/* Allow increasing the max_mtu if the program supports
+		 * XDP fragments.
+		 */
+		if (prog->aux->xdp_has_frags)
+			max_mtu += PAGE_SIZE * MAX_SKB_FRAGS;
+
 		if (peer->mtu > max_mtu) {
 			NL_SET_ERR_MSG_MOD(extack, "Peer MTU is too large to set XDP");
 			err = -ERANGE;
@@ -1549,7 +1555,7 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 		}
 
 		if (!old_prog) {
-			peer->hw_features &= ~NETIF_F_GSO_SOFTWARE;
+			peer->hw_features &= ~NETIF_F_GSO_FRAGLIST;
 			peer->max_mtu = max_mtu;
 		}
 	}
@@ -1560,7 +1566,7 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 				veth_disable_xdp(dev);
 
 			if (peer) {
-				peer->hw_features |= NETIF_F_GSO_SOFTWARE;
+				peer->hw_features |= NETIF_F_GSO_FRAGLIST;
 				peer->max_mtu = ETH_MAX_MTU;
 			}
 		}
-- 
2.35.1

