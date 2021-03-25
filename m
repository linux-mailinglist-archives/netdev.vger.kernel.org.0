Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8A83497E0
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 18:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhCYRYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 13:24:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58234 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229984AbhCYRYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 13:24:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616693071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ILxEghaIijc/ZBEYoThX2CXg3jWa3dtNjMIooaRA6c=;
        b=PeSKF8EaLJ0sRTrUs9r+5sWI7Rh9NbYDiPJbsB+s4J45vvTQce747SHpsteqCIrd4bnCoO
        I4xnLpfevefGTDtHBZJGKJSJ+3ptc/u9k/6oo6RlrD0dedQDFjyTUCTT+QX/u3CkrKnUNo
        it32NkvhxKZHDaNI94QRFHRwcy+/g4k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-IQOOhvi3OU-olXng0Ox0Aw-1; Thu, 25 Mar 2021 13:24:27 -0400
X-MC-Unique: IQOOhvi3OU-olXng0Ox0Aw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A0E783DD33;
        Thu, 25 Mar 2021 17:24:25 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-211.ams2.redhat.com [10.36.113.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1C11794A0;
        Thu, 25 Mar 2021 17:24:23 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next v2 2/8] udp: skip L4 aggregation for UDP tunnel packets
Date:   Thu, 25 Mar 2021 18:24:01 +0100
Message-Id: <400ebbc750178183155a9419cd5c3d32f53abcef.1616692794.git.pabeni@redhat.com>
In-Reply-To: <cover.1616692794.git.pabeni@redhat.com>
References: <cover.1616692794.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If NETIF_F_GRO_FRAGLIST or NETIF_F_GRO_UDP_FWD are enabled, and there
are UDP tunnels available in the system, udp_gro_receive() could end-up
doing L4 aggregation (either SKB_GSO_UDP_L4 or SKB_GSO_FRAGLIST) at
the outer UDP tunnel level for packets effectively carrying and UDP
tunnel header.

That could cause inner protocol corruption. If e.g. the relevant
packets carry a vxlan header, different vxlan ids will be ignored/
aggregated to the same GSO packet. Inner headers will be ignored, too,
so that e.g. TCP over vxlan push packets will be held in the GRO
engine till the next flush, etc.

Just skip the SKB_GSO_UDP_L4 and SKB_GSO_FRAGLIST code path if the
current packet could land in a UDP tunnel, and let udp_gro_receive()
do GRO via udp_sk(sk)->gro_receive.

The check implemented in this patch is broader than what is strictly
needed, as the existing UDP tunnel could be e.g. configured on top of
a different device: we could end-up skipping GRO at-all for some packets.

Anyhow, the latter is a very thin corner case and covering it would add
quite a bit of complexity.

v1 -> v2:
 - hopefully clarify the commit message

Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
Fixes: 36707061d6ba ("udp: allow forwarding of plain (non-fraglisted) UDP GRO packets")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv4/udp_offload.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index c5b4b586570fe..25134a3548e99 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -515,21 +515,24 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
 	unsigned int off = skb_gro_offset(skb);
 	int flush = 1;
 
+	/* we can do L4 aggregation only if the packet can't land in a tunnel
+	 * otherwise we could corrupt the inner stream
+	 */
 	NAPI_GRO_CB(skb)->is_flist = 0;
-	if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
-		NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled: 1;
+	if (!sk || !udp_sk(sk)->gro_receive) {
+		if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
+			NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled : 1;
 
-	if ((!sk && (skb->dev->features & NETIF_F_GRO_UDP_FWD)) ||
-	    (sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist) {
-		pp = call_gro_receive(udp_gro_receive_segment, head, skb);
+		if ((!sk && (skb->dev->features & NETIF_F_GRO_UDP_FWD)) ||
+		    (sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist)
+			pp = call_gro_receive(udp_gro_receive_segment, head, skb);
 		return pp;
 	}
 
-	if (!sk || NAPI_GRO_CB(skb)->encap_mark ||
+	if (NAPI_GRO_CB(skb)->encap_mark ||
 	    (uh->check && skb->ip_summed != CHECKSUM_PARTIAL &&
 	     NAPI_GRO_CB(skb)->csum_cnt == 0 &&
-	     !NAPI_GRO_CB(skb)->csum_valid) ||
-	    !udp_sk(sk)->gro_receive)
+	     !NAPI_GRO_CB(skb)->csum_valid))
 		goto out;
 
 	/* mark that this skb passed once through the tunnel gro layer */
-- 
2.26.2

