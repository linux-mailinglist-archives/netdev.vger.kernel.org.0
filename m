Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081D123AE7C
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgHCUyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:54:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26318 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728631AbgHCUyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:54:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596488040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0/65yfsdqrRVSb63lzQEu+Q3qfUkAneeMSmAc67RlYI=;
        b=hRmcBltMMTatnBLkGm6DIKxu93SEvCB8+XcueJKjq9M8KbmXQDdU8cy9iJiipJxgC/Z/MN
        J5/lvWZQUuAhN5dDnlbOuC7m4GouijkhhPN3oBU6Zcv/3lFU0zTswQXMH5+IiyxyhMumGU
        QCdfbo39jySvUkMAbUYxt1g+SG0nfVY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-XEruAru-NlafYjqoITqDpg-1; Mon, 03 Aug 2020 16:53:57 -0400
X-MC-Unique: XEruAru-NlafYjqoITqDpg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 842BD1005504;
        Mon,  3 Aug 2020 20:53:55 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5DF710013C1;
        Mon,  3 Aug 2020 20:53:52 +0000 (UTC)
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
Subject: [PATCH net-next 3/6] vxlan: Support for PMTU discovery on directly bridged links
Date:   Mon,  3 Aug 2020 22:52:11 +0200
Message-Id: <9c5e81621d9fc94cc1d1f77e177986434ca9564f.1596487323.git.sbrivio@redhat.com>
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

If metadata collection is enabled, reverse destination and source
addresses, so that Open vSwitch is able to match this packet against
the existing, reverse flow.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 drivers/net/vxlan.c | 49 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 6 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 21ea79f65410..88941f26f851 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2494,7 +2494,8 @@ static struct dst_entry *vxlan6_get_route(struct vxlan_dev *vxlan,
 
 /* Bypass encapsulation if the destination is local */
 static void vxlan_encap_bypass(struct sk_buff *skb, struct vxlan_dev *src_vxlan,
-			       struct vxlan_dev *dst_vxlan, __be32 vni)
+			       struct vxlan_dev *dst_vxlan, __be32 vni,
+			       bool snoop)
 {
 	struct pcpu_sw_netstats *tx_stats, *rx_stats;
 	union vxlan_addr loopback;
@@ -2526,7 +2527,7 @@ static void vxlan_encap_bypass(struct sk_buff *skb, struct vxlan_dev *src_vxlan,
 		goto drop;
 	}
 
-	if (dst_vxlan->cfg.flags & VXLAN_F_LEARN)
+	if ((dst_vxlan->cfg.flags & VXLAN_F_LEARN) && snoop)
 		vxlan_snoop(dev, &loopback, eth_hdr(skb)->h_source, 0, vni);
 
 	u64_stats_update_begin(&tx_stats->syncp);
@@ -2575,7 +2576,7 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
 
 			return -ENOENT;
 		}
-		vxlan_encap_bypass(skb, vxlan, dst_vxlan, vni);
+		vxlan_encap_bypass(skb, vxlan, dst_vxlan, vni, true);
 		return 1;
 	}
 
@@ -2611,7 +2612,8 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		if (vxlan_addr_any(dst)) {
 			if (did_rsc) {
 				/* short-circuited back to local bridge */
-				vxlan_encap_bypass(skb, vxlan, vxlan, default_vni);
+				vxlan_encap_bypass(skb, vxlan, vxlan,
+						   default_vni, true);
 				return;
 			}
 			goto drop;
@@ -2714,7 +2716,24 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		}
 
 		ndst = &rt->dst;
-		skb_tunnel_check_pmtu(skb, ndst, VXLAN_HEADROOM, false);
+		err = skb_tunnel_check_pmtu(skb, ndst, VXLAN_HEADROOM,
+					    netif_is_bridge_port(dev) ||
+					    netif_is_ovs_port(dev));
+		if (err < 0) {
+			goto tx_error;
+		} else if (err) {
+			if (info) {
+				struct in_addr src, dst;
+
+				src = remote_ip.sin.sin_addr;
+				dst = local_ip.sin.sin_addr;
+				info->key.u.ipv4.src = src.s_addr;
+				info->key.u.ipv4.dst = dst.s_addr;
+			}
+			vxlan_encap_bypass(skb, vxlan, vxlan, vni, false);
+			dst_release(ndst);
+			goto out_unlock;
+		}
 
 		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
 		ttl = ttl ? : ip4_dst_hoplimit(&rt->dst);
@@ -2754,7 +2773,25 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 				goto out_unlock;
 		}
 
-		skb_tunnel_check_pmtu(skb, ndst, VXLAN6_HEADROOM, false);
+		err = skb_tunnel_check_pmtu(skb, ndst, VXLAN6_HEADROOM,
+					    netif_is_bridge_port(dev) ||
+					    netif_is_ovs_port(dev));
+		if (err < 0) {
+			goto tx_error;
+		} else if (err) {
+			if (info) {
+				struct in6_addr src, dst;
+
+				src = remote_ip.sin6.sin6_addr;
+				dst = local_ip.sin6.sin6_addr;
+				info->key.u.ipv6.src = src;
+				info->key.u.ipv6.dst = dst;
+			}
+
+			vxlan_encap_bypass(skb, vxlan, vxlan, vni, false);
+			dst_release(ndst);
+			goto out_unlock;
+		}
 
 		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
 		ttl = ttl ? : ip6_dst_hoplimit(ndst);
-- 
2.27.0

