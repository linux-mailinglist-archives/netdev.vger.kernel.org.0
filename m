Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2708323B4A8
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 07:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729869AbgHDFy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 01:54:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43498 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729779AbgHDFy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 01:54:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596520465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=glKD2EyLrDz+ukCrc57rYFINuXBiVj2Vi5xHxFKQPdI=;
        b=a+8cbN3le2dwNx/S2ECy2GvFqAdnaYoQ/W2ESyWjb+8TCSYqs46PjKWzBQLWIJS8AGHzpP
        GJzb8p+A1ZFU+apbQhbOmtABJaWJYzTwoaN0Ys1a4UiQbNqyUHApBfO6HRUPtJ+gxoao5J
        nkFT/MKjJxjD2QJ1aqBur6DOmN/2pKg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-lu8z5gxDOjKO8bvEES7lfg-1; Tue, 04 Aug 2020 01:54:23 -0400
X-MC-Unique: lu8z5gxDOjKO8bvEES7lfg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADC5C106B242;
        Tue,  4 Aug 2020 05:54:21 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E78221000320;
        Tue,  4 Aug 2020 05:54:18 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Westphal <fw@strlen.de>, David Ahern <dsahern@gmail.com>,
        Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Lourdes Pedrajas <lu@pplo.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 4/6] geneve: Support for PMTU discovery on directly bridged links
Date:   Tue,  4 Aug 2020 07:53:45 +0200
Message-Id: <a6d807bfdd238a54b7e18475a040dbc001b93b95.1596520062.git.sbrivio@redhat.com>
In-Reply-To: <cover.1596520062.git.sbrivio@redhat.com>
References: <cover.1596520062.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the interface is a bridge or Open vSwitch port, and we can't
forward a packet because it exceeds the local PMTU estimate,
trigger an ICMP or ICMPv6 reply to the sender, using the same
interface to forward it back.

If metadata collection is enabled, set destination and source
addresses for the flow as if we were receiving the packet, so that
Open vSwitch can match the ICMP error against the existing
association.

v2: Use netif_is_any_bridge_port() (David Ahern)

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 drivers/net/geneve.c | 56 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 5 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index de86b6d82132..c71f994fbc73 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -893,8 +893,31 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
 
-	skb_tunnel_check_pmtu(skb, &rt->dst,
-			      GENEVE_IPV4_HLEN + info->options_len, false);
+	err = skb_tunnel_check_pmtu(skb, &rt->dst,
+				    GENEVE_IPV4_HLEN + info->options_len,
+				    netif_is_any_bridge_port(dev));
+	if (err < 0) {
+		dst_release(&rt->dst);
+		return err;
+	} else if (err) {
+		struct ip_tunnel_info *info;
+
+		info = skb_tunnel_info(skb);
+		if (info) {
+			info->key.u.ipv4.dst = fl4.saddr;
+			info->key.u.ipv4.src = fl4.daddr;
+		}
+
+		if (!pskb_may_pull(skb, ETH_HLEN)) {
+			dst_release(&rt->dst);
+			return -EINVAL;
+		}
+
+		skb->protocol = eth_type_trans(skb, geneve->dev);
+		netif_rx(skb);
+		dst_release(&rt->dst);
+		return -EMSGSIZE;
+	}
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	if (geneve->cfg.collect_md) {
@@ -955,8 +978,30 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	if (IS_ERR(dst))
 		return PTR_ERR(dst);
 
-	skb_tunnel_check_pmtu(skb, dst, GENEVE_IPV6_HLEN + info->options_len,
-			      false);
+	err = skb_tunnel_check_pmtu(skb, dst,
+				    GENEVE_IPV6_HLEN + info->options_len,
+				    netif_is_any_bridge_port(dev));
+	if (err < 0) {
+		dst_release(dst);
+		return err;
+	} else if (err) {
+		struct ip_tunnel_info *info = skb_tunnel_info(skb);
+
+		if (info) {
+			info->key.u.ipv6.dst = fl6.saddr;
+			info->key.u.ipv6.src = fl6.daddr;
+		}
+
+		if (!pskb_may_pull(skb, ETH_HLEN)) {
+			dst_release(dst);
+			return -EINVAL;
+		}
+
+		skb->protocol = eth_type_trans(skb, geneve->dev);
+		netif_rx(skb);
+		dst_release(dst);
+		return -EMSGSIZE;
+	}
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	if (geneve->cfg.collect_md) {
@@ -1013,7 +1058,8 @@ static netdev_tx_t geneve_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (likely(!err))
 		return NETDEV_TX_OK;
 
-	dev_kfree_skb(skb);
+	if (err != -EMSGSIZE)
+		dev_kfree_skb(skb);
 
 	if (err == -ELOOP)
 		dev->stats.collisions++;
-- 
2.27.0

