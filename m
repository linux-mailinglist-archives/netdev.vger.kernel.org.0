Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2886343391
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 18:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhCURCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 13:02:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25523 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230157AbhCURBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 13:01:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616346111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KkzUM6dglBHFViDDSNVczD6u9U8t/Hm4v+wMxl4rRKU=;
        b=bO2MIfgsEjP/alwdEaF0rROTvU0O4Cm3JTJVV5y5nuWsvX6Ia18SySaZzxnrMJN7SL6mnZ
        I3O1u1Augd9yCeUO55znI8e3ge6cfgsmzvcoCMvjVc19L/PcsKLX5tuHDh4RJHj2zovLiJ
        o8NZcYPIAalmUr7RFHv1ECebpfxXOkg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-_1pX0gQeN8ul7eeTzSPWLg-1; Sun, 21 Mar 2021 13:01:47 -0400
X-MC-Unique: _1pX0gQeN8ul7eeTzSPWLg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A655101371B;
        Sun, 21 Mar 2021 17:01:46 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA5E35D6B1;
        Sun, 21 Mar 2021 17:01:44 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 2/8] udp: skip fwd/list GRO for tunnel packets
Date:   Sun, 21 Mar 2021 18:01:13 +0100
Message-Id: <661b8bc7571c4619226fad9a00ca49352f43de45.1616345643.git.pabeni@redhat.com>
In-Reply-To: <cover.1616345643.git.pabeni@redhat.com>
References: <cover.1616345643.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If UDP GRO forwarding (or list) is enabled, and there are
udp tunnel available in the system, we could end-up doing L4
aggregation for packets targeting the UDP tunnel.

That could inner protocol corruption, as no overaly network
parameters is taken in account at aggregation time.

Just skip the fwd GRO if this packet could land in an UDP
tunnel. The current check is broader than what is strictly
needed, as the UDP tunnel could be e.g. on top of a different
device, but is simple and the performance downside looks not
relevant.

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

