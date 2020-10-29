Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0B229F2A7
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 18:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727292AbgJ2RKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 13:10:24 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:49942 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725957AbgJ2RKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 13:10:23 -0400
Received: from sas1-5717c3cea310.qloud-c.yandex.net (sas1-5717c3cea310.qloud-c.yandex.net [IPv6:2a02:6b8:c14:3616:0:640:5717:c3ce])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id A79072E15D7
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 20:10:20 +0300 (MSK)
Received: from sas1-58a37b48fb94.qloud-c.yandex.net (sas1-58a37b48fb94.qloud-c.yandex.net [2a02:6b8:c08:1d1b:0:640:58a3:7b48])
        by sas1-5717c3cea310.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id A4adymdPxU-AKwevbVH;
        Thu, 29 Oct 2020 20:10:20 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1603991420; bh=3m8I1/MfgLTSQUZStpA6Pe9ZMKmleLMDguhpLYicIs0=;
        h=Message-Id:Date:Subject:To:From;
        b=jz1L0Ba/I/qfUtKbNrt0wlpBzskPpF/7tArPoq3s4fDluizfGisoNwq6l307zkJ7O
         skqNJ9R1CQtKIcTQ6g8pBeQs40hYa76JEsqkHn/VcMzsus0l3sMbdiRBgpVeA5k0c6
         YMXhBq5WBpm7LPJgXECkJW7cPJGlej7CHDhl7lGs=
Authentication-Results: sas1-5717c3cea310.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from ov.sas.yp-c.yandex.net (ov.sas.yp-c.yandex.net [2a02:6b8:c1b:2b1b:0:696:6703:0])
        by sas1-58a37b48fb94.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 2F9SLoQM8C-AHmmEVws;
        Thu, 29 Oct 2020 20:10:20 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Alexander Ovechkin <ovov@yandex-team.ru>
To:     netdev@vger.kernel.org
Subject: [PATCH v2 net] ip6_tunnel: set inner ipproto before ip6_tnl_encap
Date:   Thu, 29 Oct 2020 20:10:12 +0300
Message-Id: <20201029171012.20904-1-ovov@yandex-team.ru>
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

Fixes: 6c11fbf97e69 ("ip6_tunnel: add MPLS transmit support")
Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
---
Changes in v2:
  - add Fixes line (Willem de Bruijn)

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

