Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE444B1B1F
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 02:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346756AbiBKBVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 20:21:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346750AbiBKBVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 20:21:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683E7267F;
        Thu, 10 Feb 2022 17:21:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0133160AE2;
        Fri, 11 Feb 2022 01:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B5BC004E1;
        Fri, 11 Feb 2022 01:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644542480;
        bh=dgo1FNTJve+xV7yk8jxbNm48UnIcYRqlLHMgTFHQK/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D8zxNwbZGbR/uR8iEinOXuuUP0fNMeC16tZLZ8uIbia3DodYur3nL3O9UIfXCeBIe
         L9QLEaEGY9RrGj5reMCSKcLf1rBSANej8nNCoLaGr2zySKTxXnWDsz7sICT3eZnemz
         hKYSPAc9CNjo2Drhl0MGewfEBC2KMWk5xUAqHkb5/tL9w0WM/1UAq6RHJF5/M5Jc6o
         IXX3uoq1aVqYMPFmms38oLHpfpjC+y8YaWSNSk948FVpE8F3cI1BLYY45OC99N9rKz
         NkLLDcT4wTRvfneraWNMyWXzsssmlmO4F8JhE9n1RTkmZ9ihU1WEC37rN0Co6BXU4k
         E+ts46PpKY4UQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 3/3] veth: allow jumbo frames in xdp mode
Date:   Fri, 11 Feb 2022 02:20:32 +0100
Message-Id: <1a33c57f5cc39c6e58326f9f4841deac607df7e1.1644541123.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1644541123.git.lorenzo@kernel.org>
References: <cover.1644541123.git.lorenzo@kernel.org>
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
 drivers/net/veth.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 6419de5d1f49..d6ebbfe52969 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1498,7 +1498,6 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	struct veth_priv *priv = netdev_priv(dev);
 	struct bpf_prog *old_prog;
 	struct net_device *peer;
-	unsigned int max_mtu;
 	int err;
 
 	old_prog = priv->_xdp_prog;
@@ -1506,6 +1505,8 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	peer = rtnl_dereference(priv->peer);
 
 	if (prog) {
+		unsigned int max_mtu;
+
 		if (!peer) {
 			NL_SET_ERR_MSG_MOD(extack, "Cannot set XDP when peer is detached");
 			err = -ENOTCONN;
@@ -1515,9 +1516,9 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
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
 
@@ -1535,10 +1536,8 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
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
@@ -1546,10 +1545,8 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
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
2.34.1

