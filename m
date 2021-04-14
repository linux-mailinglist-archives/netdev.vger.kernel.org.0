Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A2C35FE68
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237445AbhDNX0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:26:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233459AbhDNX0O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:26:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B38CE61242;
        Wed, 14 Apr 2021 23:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618442753;
        bh=T7KqcsJXuzCajU7swIRrYJFoQd5vgDu/miTpVfFOxRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmmiQomsK14szSeFW/FfGOVbOivgka0CCqvkJ4KLfHQG/5x1/Q09uu6x4uma9geoz
         SxWdjew002fr9h77VA6n84pD2Wc3LihbLILe4qSSqmGwWPfCncNG8aGXQNJA56EM+0
         OVGVfVvhkn1/eX5HsNo1EIh9EqPyscXoLfCU5gAkeCjNZI1u2mKT5b382/pE8ILsDR
         WL9/QR0n1dw/r4CTv8yK4F3VoC3v0nvyMqAPKMslNxIpLjEOFM22N5dItBd9Vd+n/P
         s9RF1v15nJVLch/+JAwizRX98tLjDdXeg4wLWD6TyWDETLwDEFEfiz2SK3ZuVeDXaR
         6yNxjDS9VtfhA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        "Cc : Steffen Klassert" <steffen.klassert@secunet.com>,
        Huy Nguyen <huyn@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [PATCH net 2/3] net/xfrm: Add inner_ipproto into sec_path
Date:   Wed, 14 Apr 2021 16:25:39 -0700
Message-Id: <20210414232540.138232-3-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414232540.138232-1-saeed@kernel.org>
References: <20210414232540.138232-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@nvidia.com>

The inner_ipproto saves the inner IP protocol of the plain
text packet. This allows vendor's IPsec feature making offload
decision at skb's features_check and configuring hardware at
ndo_start_xmit.

For example, ConnectX6-DX IPsec device needs the plaintext's
IP protocol to support partial checksum offload on
VXLAN/GENEVE packet over IPsec transport mode tunnel.

Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h     |  1 +
 net/xfrm/xfrm_output.c | 36 +++++++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index c58a6d4eb610..e535700431fb 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1032,6 +1032,7 @@ struct sec_path {
 
 	struct xfrm_state	*xvec[XFRM_MAX_DEPTH];
 	struct xfrm_offload	ovec[XFRM_MAX_OFFLOAD_DEPTH];
+	u8			inner_ipproto;
 };
 
 struct sec_path *secpath_set(struct sk_buff *skb);
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index e4cb0ff4dcf4..da412928093b 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -565,6 +565,36 @@ static int xfrm_output_gso(struct net *net, struct sock *sk, struct sk_buff *skb
 	return 0;
 }
 
+/* Save inner ip protocol for vendor offload usage */
+static void get_inner_ipproto(struct sk_buff *skb, struct sec_path *sp)
+{
+	const struct ethhdr *eth;
+
+	if (!skb->inner_protocol)
+		return;
+
+	if (skb->inner_protocol_type == ENCAP_TYPE_IPPROTO) {
+		sp->inner_ipproto = skb->inner_protocol;
+		return;
+	}
+
+	if (skb->inner_protocol_type != ENCAP_TYPE_ETHER)
+		return;
+
+	eth = (struct ethhdr *)skb_inner_mac_header(skb);
+
+	switch (eth->h_proto) {
+	case ntohs(ETH_P_IPV6):
+		sp->inner_ipproto = inner_ipv6_hdr(skb)->nexthdr;
+		break;
+	case ntohs(ETH_P_IP):
+		sp->inner_ipproto = inner_ip_hdr(skb)->protocol;
+		break;
+	default:
+		return;
+	}
+}
+
 int xfrm_output(struct sock *sk, struct sk_buff *skb)
 {
 	struct net *net = dev_net(skb_dst(skb)->dev);
@@ -594,8 +624,12 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 			kfree_skb(skb);
 			return -ENOMEM;
 		}
-		skb->encapsulation = 1;
 
+		sp->inner_ipproto = 0;
+		if (skb->encapsulation)
+			get_inner_ipproto(skb, sp);
+
+		skb->encapsulation = 1;
 		sp->olen++;
 		sp->xvec[sp->len++] = x;
 		xfrm_state_hold(x);
-- 
2.30.2

