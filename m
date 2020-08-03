Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7571323AE7D
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgHCUyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:54:06 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28038 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728631AbgHCUyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:54:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596488044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d8mQcGDqGGir7cCKXDffCx/tbT3lFix1eA1/5zXlWUo=;
        b=NSjbEV6Ef5iaOYDWV3ZYhWB6sCIrSfRySK9RQTEWJOBK7CZ0NlIzJp2KguGjvcvLIFhOwp
        jWhpehlx/mOQQIoJ77zc6LBW6MXCnJWyL732vUDv79Utsu7E3Tt9Tgex1rcy40tJsC5c+M
        P00eW2iQBx9WXTc0Tk3yl0y/Z+36vHI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-P2L6wSZPOp2JmsgIj9uwKg-1; Mon, 03 Aug 2020 16:54:00 -0400
X-MC-Unique: P2L6wSZPOp2JmsgIj9uwKg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11AD1106B243;
        Mon,  3 Aug 2020 20:53:59 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E60D710013C1;
        Mon,  3 Aug 2020 20:53:55 +0000 (UTC)
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
Subject: [PATCH net-next 4/6] geneve: Support for PMTU discovery on directly bridged links
Date:   Mon,  3 Aug 2020 22:52:12 +0200
Message-Id: <b4f1d2fecb8931129368a01b60f6117d0a3f9bfd.1596487323.git.sbrivio@redhat.com>
In-Reply-To: <cover.1596487323.git.sbrivio@redhat.com>
References: <cover.1596487323.git.sbrivio@redhat.com>
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

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 drivers/net/geneve.c | 58 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 5 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index de86b6d82132..c169367236c1 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -893,8 +893,32 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
 
-	skb_tunnel_check_pmtu(skb, &rt->dst,
-			      GENEVE_IPV4_HLEN + info->options_len, false);
+	err = skb_tunnel_check_pmtu(skb, &rt->dst,
+				    GENEVE_IPV4_HLEN + info->options_len,
+				    netif_is_bridge_port(dev) ||
+				    netif_is_ovs_port(dev));
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
@@ -955,8 +979,31 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	if (IS_ERR(dst))
 		return PTR_ERR(dst);
 
-	skb_tunnel_check_pmtu(skb, dst, GENEVE_IPV6_HLEN + info->options_len,
-			      false);
+	err = skb_tunnel_check_pmtu(skb, dst,
+				    GENEVE_IPV6_HLEN + info->options_len,
+				    netif_is_bridge_port(dev) ||
+				    netif_is_ovs_port(dev));
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
@@ -1013,7 +1060,8 @@ static netdev_tx_t geneve_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (likely(!err))
 		return NETDEV_TX_OK;
 
-	dev_kfree_skb(skb);
+	if (err != -EMSGSIZE)
+		dev_kfree_skb(skb);
 
 	if (err == -ELOOP)
 		dev->stats.collisions++;
-- 
2.27.0

