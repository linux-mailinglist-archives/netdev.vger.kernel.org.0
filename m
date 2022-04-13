Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB0E64FFD0A
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237296AbiDMRp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236567AbiDMRp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:45:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8C16CA6E
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:43:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2A74B826AF
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371D7C385AB;
        Wed, 13 Apr 2022 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649871811;
        bh=YDACq5n/khiWKHPt9ApJ5UkZcq2vAvOJzdJm3kX3+9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nnbO9wTO46b/RGwVDALO2RP5oOv+FT4fGJ4CDE0M8RCUDtrddI4pDeadbXLIk6ueV
         5eQxeRZnR2F/EMJLDgRQuu7ZLWDjetTpoDf+l2WyA5lY6UesaMjSGYZTFe38Ss3nRH
         q9U3URco5gTxxSS9ORY5crgAgG2/IM7FSUKYZtL7TGvVR05voaBqylLt9xRHCLsVss
         ospBGFpL4dPDubPF143ZUULaZ2IElU2xrlXw+PsgKAS1R3k8Y4wAUhgKNt2V2v2w+Y
         sol70m7bSHVNdJvdmEr0Pf8eADkxSX6k0xFwLHFrs5jZrVmLzcgfS5kg61ewu1Xu0t
         TKcnOkuCvdIjg==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com
Cc:     David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@idosch.org>
Subject: [PATCH net 2/2] net: Handle l3mdev in ip_tunnel_init_flow
Date:   Wed, 13 Apr 2022 11:43:20 -0600
Message-Id: <20220413174320.28989-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20220413174320.28989-1-dsahern@kernel.org>
References: <20220413174320.28989-1-dsahern@kernel.org>
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

Ido reported that the commit referenced in the Fixes tag broke
a gre use case with dummy devices. Add a check to ip_tunnel_init_flow
to see if the oif is an l3mdev port and if so set the oif to 0 to
avoid the oif comparison in fib_lookup_good_nhc.

Fixes: 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif reset for port devices")
Reported-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: David Ahern <dsahern@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c |  2 +-
 include/net/ip_tunnels.h                            | 11 +++++++++--
 net/ipv4/ip_gre.c                                   |  4 ++--
 net/ipv4/ip_tunnel.c                                |  9 +++++----
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index b73466470f75..fe663b0ab708 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -423,7 +423,7 @@ mlxsw_sp_span_gretap4_route(const struct net_device *to_dev,
 
 	parms = mlxsw_sp_ipip_netdev_parms4(to_dev);
 	ip_tunnel_init_flow(&fl4, parms.iph.protocol, *daddrp, *saddrp,
-			    0, 0, parms.link, tun->fwmark, 0);
+			    0, 0, dev_net(to_dev), parms.link, tun->fwmark, 0);
 
 	rt = ip_route_output_key(tun->net, &fl4);
 	if (IS_ERR(rt))
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 0219fe907b26..88dee57eac8a 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -243,11 +243,18 @@ static inline __be32 tunnel_id_to_key32(__be64 tun_id)
 static inline void ip_tunnel_init_flow(struct flowi4 *fl4,
 				       int proto,
 				       __be32 daddr, __be32 saddr,
-				       __be32 key, __u8 tos, int oif,
+				       __be32 key, __u8 tos,
+				       struct net *net, int oif,
 				       __u32 mark, __u32 tun_inner_hash)
 {
 	memset(fl4, 0, sizeof(*fl4));
-	fl4->flowi4_oif = oif;
+
+	if (oif) {
+		fl4->flowi4_l3mdev = l3mdev_master_upper_ifindex_by_index_rcu(net, oif);
+		/* Legacy VRF/l3mdev use case */
+		fl4->flowi4_oif = fl4->flowi4_l3mdev ? 0 : oif;
+	}
+
 	fl4->daddr = daddr;
 	fl4->saddr = saddr;
 	fl4->flowi4_tos = tos;
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 99db2e41ed10..365caebf51ab 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -605,8 +605,8 @@ static int gre_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
 	key = &info->key;
 	ip_tunnel_init_flow(&fl4, IPPROTO_GRE, key->u.ipv4.dst, key->u.ipv4.src,
 			    tunnel_id_to_key32(key->tun_id),
-			    key->tos & ~INET_ECN_MASK, 0, skb->mark,
-			    skb_get_hash(skb));
+			    key->tos & ~INET_ECN_MASK, dev_net(dev), 0,
+			    skb->mark, skb_get_hash(skb));
 	rt = ip_route_output_key(dev_net(dev), &fl4);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 5a473319d3a5..94017a8c3994 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -294,8 +294,8 @@ static int ip_tunnel_bind_dev(struct net_device *dev)
 
 		ip_tunnel_init_flow(&fl4, iph->protocol, iph->daddr,
 				    iph->saddr, tunnel->parms.o_key,
-				    RT_TOS(iph->tos), tunnel->parms.link,
-				    tunnel->fwmark, 0);
+				    RT_TOS(iph->tos), dev_net(dev),
+				    tunnel->parms.link, tunnel->fwmark, 0);
 		rt = ip_route_output_key(tunnel->net, &fl4);
 
 		if (!IS_ERR(rt)) {
@@ -570,7 +570,7 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	}
 	ip_tunnel_init_flow(&fl4, proto, key->u.ipv4.dst, key->u.ipv4.src,
 			    tunnel_id_to_key32(key->tun_id), RT_TOS(tos),
-			    0, skb->mark, skb_get_hash(skb));
+			    dev_net(dev), 0, skb->mark, skb_get_hash(skb));
 	if (tunnel->encap.type != TUNNEL_ENCAP_NONE)
 		goto tx_error;
 
@@ -726,7 +726,8 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	ip_tunnel_init_flow(&fl4, protocol, dst, tnl_params->saddr,
-			    tunnel->parms.o_key, RT_TOS(tos), tunnel->parms.link,
+			    tunnel->parms.o_key, RT_TOS(tos),
+			    dev_net(dev), tunnel->parms.link,
 			    tunnel->fwmark, skb_get_hash(skb));
 
 	if (ip_tunnel_encap(skb, tunnel, &protocol, &fl4) < 0)
-- 
2.24.3 (Apple Git-128)

