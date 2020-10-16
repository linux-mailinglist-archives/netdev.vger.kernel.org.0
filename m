Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1012903E0
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 13:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394802AbgJPLNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 07:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390640AbgJPLNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 07:13:46 -0400
X-Greylist: delayed 101 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 16 Oct 2020 04:13:46 PDT
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C647C061755
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 04:13:46 -0700 (PDT)
Received: from sas1-ec30c78b6c5b.qloud-c.yandex.net (sas1-ec30c78b6c5b.qloud-c.yandex.net [IPv6:2a02:6b8:c14:2704:0:640:ec30:c78b])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id EB6192E0464
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 14:12:02 +0300 (MSK)
Received: from sas2-32987e004045.qloud-c.yandex.net (sas2-32987e004045.qloud-c.yandex.net [2a02:6b8:c08:b889:0:640:3298:7e00])
        by sas1-ec30c78b6c5b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id 9Cnn0ft1Bp-C2wCGX8h;
        Fri, 16 Oct 2020 14:12:02 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1602846722; bh=sGeI+dxdC2AKxxRLqvASEnrSpM9wSJUG8pFLAOLj0Go=;
        h=Message-Id:Date:Subject:To:From;
        b=rs1iVXnmL9EYtU5OCxQi1MMIZmrQ4/wIo0NMjyQZaigpcSEPf0VmVy4rIZYIFIrfz
         Kby6NFBu3jYFf5DYg8eq5ZegES4Rni3VMwz7SyRpJv+2dWLLBBUMa48dPzeA2UDcnr
         /v7WUPbVMTd9qJg6r4nrhX0Oe4iQN+I7j8UkHNPk=
Authentication-Results: sas1-ec30c78b6c5b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from ov.sas.yp-c.yandex.net (ov.sas.yp-c.yandex.net [2a02:6b8:c1b:2b1b:0:696:6703:0])
        by sas2-32987e004045.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id Vozt16rNmX-C2n4iwCt;
        Fri, 16 Oct 2020 14:12:02 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Alexander Ovechkin <ovov@yandex-team.ru>
To:     netdev@vger.kernel.org
Subject: [PATCH net] ip6_tunnel: set inner ipproto before ip6_tnl_encap.
Date:   Fri, 16 Oct 2020 14:11:56 +0300
Message-Id: <20201016111156.26927-1-ovov@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip6_tnl_encap assigns to proto transport protocol which
encapsulates inner packet, but we must pass to set_inner_ipproto
protocol of that inner packet.

Calling set_inner_ipproto after ip6_tnl_encap might break gso.
For example, in case of encapsulating ipv6 packet in fou6 packet, inner_ipproto 
would be set to IPPROTO_UDP instead of IPPROTO_IPV6. This would lead to
incorrect calling sequence of gso functions:
ipv6_gso_segment -> udp6_ufo_fragment -> skb_udp_tunnel_segment -> udp6_ufo_fragment
instead of:
ipv6_gso_segment -> udp6_ufo_fragment -> skb_udp_tunnel_segment -> ip6ip6_gso_segment

Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
---
 net/ipv6/ip6_tunnel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index a0217e5bf3bc..648db3fe508f 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1271,6 +1271,8 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 	if (max_headroom > dev->needed_headroom)
 		dev->needed_headroom = max_headroom;
 
+	skb_set_inner_ipproto(skb, proto);
+
 	err = ip6_tnl_encap(skb, t, &proto, fl6);
 	if (err)
 		return err;
@@ -1280,8 +1282,6 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 		ipv6_push_frag_opts(skb, &opt.ops, &proto);
 	}
 
-	skb_set_inner_ipproto(skb, proto);
-
 	skb_push(skb, sizeof(struct ipv6hdr));
 	skb_reset_network_header(skb);
 	ipv6h = ipv6_hdr(skb);
-- 
2.17.1

