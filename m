Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A5F5A1571
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 17:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237654AbiHYPSe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Aug 2022 11:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236708AbiHYPSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 11:18:32 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AABB8F04
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 08:18:30 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-6QukaRmbOSOjbqCzPhBSNA-1; Thu, 25 Aug 2022 11:18:25 -0400
X-MC-Unique: 6QukaRmbOSOjbqCzPhBSNA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6695B8032E3;
        Thu, 25 Aug 2022 15:18:25 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.194.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75D2940D282E;
        Thu, 25 Aug 2022 15:18:24 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH ipsec] esp: choose the correct inner protocol for GSO on inter address family tunnels
Date:   Thu, 25 Aug 2022 17:16:51 +0200
Message-Id: <4b5a7ed6ce98b91362f2d16c84655919299c40e3.1661341717.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 23c7f8d7989e ("net: Fix esp GSO on inter address family
tunnels.") is incomplete. It passes to skb_eth_gso_segment the
protocol for the outer IP version, instead of the inner IP version, so
we end up calling inet_gso_segment on an inner IPv6 packet and
ipv6_gso_segment on an inner IPv4 packet and the packets are dropped.

This patch completes the fix by selecting the correct protocol based
on the inner mode's family.

Fixes: c35fe4106b92 ("xfrm: Add mode handlers for IPsec on layer 2")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/ipv4/esp4_offload.c | 5 ++++-
 net/ipv6/esp6_offload.c | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 935026f4c807..170152772d33 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -110,7 +110,10 @@ static struct sk_buff *xfrm4_tunnel_gso_segment(struct xfrm_state *x,
 						struct sk_buff *skb,
 						netdev_features_t features)
 {
-	return skb_eth_gso_segment(skb, features, htons(ETH_P_IP));
+	__be16 type = x->inner_mode.family == AF_INET6 ? htons(ETH_P_IPV6)
+						       : htons(ETH_P_IP);
+
+	return skb_eth_gso_segment(skb, features, type);
 }
 
 static struct sk_buff *xfrm4_transport_gso_segment(struct xfrm_state *x,
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 3a293838a91d..79d43548279c 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -145,7 +145,10 @@ static struct sk_buff *xfrm6_tunnel_gso_segment(struct xfrm_state *x,
 						struct sk_buff *skb,
 						netdev_features_t features)
 {
-	return skb_eth_gso_segment(skb, features, htons(ETH_P_IPV6));
+	__be16 type = x->inner_mode.family == AF_INET ? htons(ETH_P_IP)
+						      : htons(ETH_P_IPV6);
+
+	return skb_eth_gso_segment(skb, features, type);
 }
 
 static struct sk_buff *xfrm6_transport_gso_segment(struct xfrm_state *x,
-- 
2.37.2

