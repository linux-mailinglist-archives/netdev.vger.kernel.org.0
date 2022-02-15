Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F059B4B6D11
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 14:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238120AbiBONJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 08:09:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238131AbiBONJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 08:09:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D25C4E32;
        Tue, 15 Feb 2022 05:08:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 010E2616F2;
        Tue, 15 Feb 2022 13:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6B3C340EB;
        Tue, 15 Feb 2022 13:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644930529;
        bh=M9dGCrg25xSqLmzuNJblhpsqJiY6neOR0yBD5oH5SF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RN1fn9gX1Wk+0mNQaPEbhlvjDFB7l8k+O1c4ick8iQJO1ZUOXzPsz+TWI7Vip4N1a
         gDIw2ja+mlfD+sw0Tbxwu2qgL6rPfYcdy1GntRIFqz/42UZHuPVgNZKTBruAHoffN9
         J3ym1LssKlxYwjZ7K6Sg8Csii3ubglzVWkQt+tG1MjOYjFMAmYByLnY7dXQYf1PgKu
         3FunWC/LiIYosd/osLXctiTcjobX1MfrsbAmvQvFuTMHSWeY8Tqra4vdnNZ5B7yt4Y
         11yq8V5Nupgx7KGB8t2Qm+NsXlXGBNX4bBaWfaLguXv82yRPAtK4QUlj/RYI01bDvJ
         05+YUkIDUxRyw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: [PATCH v2 bpf-next 3/3] veth: allow jumbo frames in xdp mode
Date:   Tue, 15 Feb 2022 14:08:11 +0100
Message-Id: <15943b59b1638515770b7ab841b0d741dc314c3a.1644930125.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1644930124.git.lorenzo@kernel.org>
References: <cover.1644930124.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/net/veth.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index a45aaaecc21f..2e048f957bc6 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -292,8 +292,6 @@ static int veth_forward_skb(struct net_device *dev, struct sk_buff *skb,
 /* return true if the specified skb has chances of GRO aggregation
  * Don't strive for accuracy, but try to avoid GRO overhead in the most
  * common scenarios.
- * When XDP is enabled, all traffic is considered eligible, as the xmit
- * device has TSO off.
  * When TSO is enabled on the xmit device, we are likely interested only
  * in UDP aggregation, explicitly check for that if the skb is suspected
  * - the sock_wfree destructor is used by UDP, ICMP and XDP sockets -
@@ -334,7 +332,8 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 		 * Don't bother with napi/GRO if the skb can't be aggregated
 		 */
 		use_napi = rcu_access_pointer(rq->napi) &&
-			   veth_skb_is_eligible_for_gro(dev, rcv, skb);
+			   (rcu_access_pointer(rq->xdp_prog) ||
+			    veth_skb_is_eligible_for_gro(dev, rcv, skb));
 	}
 
 	skb_tx_timestamp(skb);
@@ -1508,7 +1507,6 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	struct veth_priv *priv = netdev_priv(dev);
 	struct bpf_prog *old_prog;
 	struct net_device *peer;
-	unsigned int max_mtu;
 	int err;
 
 	old_prog = priv->_xdp_prog;
@@ -1516,6 +1514,8 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	peer = rtnl_dereference(priv->peer);
 
 	if (prog) {
+		unsigned int max_mtu;
+
 		if (!peer) {
 			NL_SET_ERR_MSG_MOD(extack, "Cannot set XDP when peer is detached");
 			err = -ENOTCONN;
@@ -1525,9 +1525,9 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
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
 
@@ -1545,10 +1545,8 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
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
@@ -1556,10 +1554,8 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
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

