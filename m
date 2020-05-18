Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1EC1D896B
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgERUkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:40:35 -0400
Received: from novek.ru ([213.148.174.62]:49118 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbgERUk1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 16:40:27 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id A4376502936;
        Mon, 18 May 2020 23:34:01 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru A4376502936
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1589834046; bh=UGuoSo4+SBdiwXbzU5+yRGblSw51ZVQBHeBkjQ1mAyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHUb5qKf8Co2s1Xxre+YRu7S83D4WYIK3CU4dlllipxmALM8XnYcxlCOI4sClP1cn
         zNzXN14r6K9aalV91PEKdzJ44ZdASJ4EDaP/87g7amCbjZd8oMd8l4uVPKu6+q200T
         r8pBILdQW/nd4VSzrTKj0iWrNNxCF4QnHs5R769U=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [net-next 2/5] ip6_tunnel: add MPLS transmit support
Date:   Mon, 18 May 2020 23:33:45 +0300
Message-Id: <1589834028-9929-3-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589834028-9929-1-git-send-email-vfedorenko@novek.ru>
References: <1589834028-9929-1-git-send-email-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ETH_P_MPLS_UC as supported protocol.

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/ipv6/ip6_tunnel.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index dae6f71..00ddd57 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1232,6 +1232,8 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 		ipv6_push_frag_opts(skb, &opt.ops, &proto);
 	}
 
+	skb_set_inner_ipproto(skb, proto);
+
 	skb_push(skb, sizeof(struct ipv6hdr));
 	skb_reset_network_header(skb);
 	ipv6h = ipv6_hdr(skb);
@@ -1348,6 +1350,7 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 				fl6.flowlabel |= ip6_flowlabel(ipv6h);
 			break;
 		default:
+			orig_dsfield = dsfield = ip6_tclass(t->parms.flowinfo);
 			break;
 		}
 	}
@@ -1358,8 +1361,6 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 	if (iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6))
 		return -1;
 
-	skb_set_inner_ipproto(skb, protocol);
-
 	err = ip6_tnl_xmit(skb, dev, dsfield, &fl6, encap_limit, &mtu,
 			   protocol);
 	if (err != 0) {
@@ -1402,6 +1403,11 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 			goto tx_err;
 		ipproto = IPPROTO_IPV6;
 		break;
+#if IS_ENABLED(CONFIG_MPLS)
+	case htons(ETH_P_MPLS_UC):
+		ipproto = IPPROTO_MPLS;
+		break;
+#endif
 	default:
 		goto tx_err;
 	}
-- 
1.8.3.1

