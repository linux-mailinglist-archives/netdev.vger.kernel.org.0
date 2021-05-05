Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA16373EA5
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 17:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbhEEPhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 11:37:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27589 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233525AbhEEPhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 11:37:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620228975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hgkEObWrhPpU0VWlIFg59d/bFDsmQ4iUBVoNuyOzllY=;
        b=Ps+Uicae+ArtTTTBlmcnYvUqN8N0ZlmI1NlMSESMtaMlkGPK7J7bEOXr5pUBJiOLlChRDI
        tx6teUkNUC99AH2/NwPUykCh4JI6oLe7LsiWaV8uDgOqbkiY/z27mCZgMmeQW5kRYEpaer
        o5JhH99t3QozE0rA+mlRAky7XkErbRM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-QvKtzQ0dNSqwtQjUaT4kGA-1; Wed, 05 May 2021 11:36:13 -0400
X-MC-Unique: QvKtzQ0dNSqwtQjUaT4kGA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0086107ACC7;
        Wed,  5 May 2021 15:36:11 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-175.ams2.redhat.com [10.36.113.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A7635C1A3;
        Wed,  5 May 2021 15:36:10 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH net 2/4] udp: fix out-of-bound at segmentation time
Date:   Wed,  5 May 2021 17:35:02 +0200
Message-Id: <5e72b33838c6f19d770062e736f0517610ada4e7.1620223174.git.pabeni@redhat.com>
In-Reply-To: <cover.1620223174.git.pabeni@redhat.com>
References: <cover.1620223174.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the following scenario:

GRO -> SKB_GSO_FRAGLIST aggregation -> forward ->
  xmit over UDP tunnel -> segmentation

__udp_gso_segment_list() will take place and later
skb_udp_tunnel_segment() will try to make the segmented
packets outer UDP header checksum via gso_make_checksum().

The latter expect valids SKB_GSO_CB(skb)->csum and
SKB_GSO_CB(skb)->csum_start, but such fields are not
initialized by __udp_gso_segment_list().

gso_make_checksum() will end-up using a negative offset and
that will trigger the following splat:

 ==================================================================
 BUG: KASAN: slab-out-of-bounds in do_csum+0x3d8/0x400
 Read of size 1 at addr ffff888113ab5880 by task napi/br_port-81/1105

 CPU: 1 PID: 1105 Comm: napi/br_port-81 Not tainted 5.12.0-rc2.mptcp_autotune_ce84e1323bebe+ #268
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
 Call Trace:
  dump_stack+0xfa/0x151
  print_address_description.constprop.0+0x16/0xa0
  __kasan_report.cold+0x37/0x80
  kasan_report+0x3a/0x50
  do_csum+0x3d8/0x400
  csum_partial+0x21/0x30
  __skb_udp_tunnel_segment+0xd79/0x1ae0
  skb_udp_tunnel_segment+0x233/0x460
  udp4_ufo_fragment+0x50d/0x720
  inet_gso_segment+0x525/0x1120
  skb_mac_gso_segment+0x278/0x570

__udp_gso_segment_list() already has all the relevant data handy,
fix the issue traversing the segments list and updating the
GSO CB, if this is a tunnel GSO packet.

The issue is present since SKB_GSO_FRAGLIST introduction, but is
observable only since commit 18f25dc39990 ("udp: skip L4 aggregation
for UDP tunnel packets")

Fixes: 18f25dc39990 ("udp: skip L4 aggregation for UDP tunnel packets")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv4/udp_offload.c | 45 +++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 54e06b88af69..9f6022ba6bcd 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -214,8 +214,10 @@ static void __udpv4_gso_segment_csum(struct sk_buff *seg,
 	*oldip = *newip;
 }
 
-static struct sk_buff *__udpv4_gso_segment_list_csum(struct sk_buff *segs)
+static void __udp_gso_segment_list_csum(struct sk_buff *segs, bool is_ipv6,
+					bool is_tunnel)
 {
+	bool update_csum = !is_ipv6;
 	struct sk_buff *seg;
 	struct udphdr *uh, *uh2;
 	struct iphdr *iph, *iph2;
@@ -224,31 +226,45 @@ static struct sk_buff *__udpv4_gso_segment_list_csum(struct sk_buff *segs)
 	uh = udp_hdr(seg);
 	iph = ip_hdr(seg);
 
-	if ((udp_hdr(seg)->dest == udp_hdr(seg->next)->dest) &&
+	if (update_csum && (udp_hdr(seg)->dest == udp_hdr(seg->next)->dest) &&
 	    (udp_hdr(seg)->source == udp_hdr(seg->next)->source) &&
 	    (ip_hdr(seg)->daddr == ip_hdr(seg->next)->daddr) &&
 	    (ip_hdr(seg)->saddr == ip_hdr(seg->next)->saddr))
-		return segs;
+		update_csum = false;
+
+	if (!update_csum && !is_tunnel)
+		return;
 
+	/* this skb is CHECKSUM_NONE, if it has also a tunnel header
+	 * later __skb_udp_tunnel_segment() will try to make the
+	 * outer header csum and will need valid csum* fields
+	 */
+	SKB_GSO_CB(seg)->csum = ~uh->check;
+	SKB_GSO_CB(seg)->csum_start = seg->transport_header;
 	while ((seg = seg->next)) {
 		uh2 = udp_hdr(seg);
-		iph2 = ip_hdr(seg);
-
-		__udpv4_gso_segment_csum(seg,
-					 &iph2->saddr, &iph->saddr,
-					 &uh2->source, &uh->source);
-		__udpv4_gso_segment_csum(seg,
-					 &iph2->daddr, &iph->daddr,
-					 &uh2->dest, &uh->dest);
-	}
+		if (update_csum) {
+			iph2 = ip_hdr(seg);
+
+			__udpv4_gso_segment_csum(seg,
+						 &iph2->saddr, &iph->saddr,
+						 &uh2->source, &uh->source);
+			__udpv4_gso_segment_csum(seg,
+						 &iph2->daddr, &iph->daddr,
+						 &uh2->dest, &uh->dest);
+		}
 
-	return segs;
+		SKB_GSO_CB(seg)->csum = ~uh2->check;
+		SKB_GSO_CB(seg)->csum_start = seg->transport_header;
+	}
 }
 
 static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
 					      netdev_features_t features,
 					      bool is_ipv6)
 {
+	bool is_tunnel = !!(skb_shinfo(skb)->gso_type &
+			    (SKB_GSO_UDP_TUNNEL | SKB_GSO_UDP_TUNNEL_CSUM));
 	unsigned int mss = skb_shinfo(skb)->gso_size;
 
 	skb = skb_segment_list(skb, features, skb_mac_header_len(skb));
@@ -257,7 +273,8 @@ static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
 
 	udp_hdr(skb)->len = htons(sizeof(struct udphdr) + mss);
 
-	return is_ipv6 ? skb : __udpv4_gso_segment_list_csum(skb);
+	__udp_gso_segment_list_csum(skb, is_ipv6, is_tunnel);
+	return skb;
 }
 
 struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
-- 
2.26.2

