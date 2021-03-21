Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461DB343390
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 18:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhCURCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 13:02:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230156AbhCURBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 13:01:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616346107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SZC/DY9TYkL25R5rmVOy9DZ+7PDHWQdgpNcqb+Z5d5Y=;
        b=YZm8OdwJA+i/TaeTlGlslNmwaPJdZQY79xUjYbF/sLe5LhYKNoj2610QcutcBHXhBXXKQL
        ZIA1O6GcdvlPrx9f5WqzfY7TjjIX9eQzTtyKDMMNm/NkSEiFPISojGDr0ejdyICyygDjUo
        kqo7TJfi9pbMz0xc/WZZpuOchLo8wuE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-bGiuelssNMq5dMz1bWiVug-1; Sun, 21 Mar 2021 13:01:45 -0400
X-MC-Unique: bGiuelssNMq5dMz1bWiVug-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FB4C881278;
        Sun, 21 Mar 2021 17:01:44 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A75505D6B1;
        Sun, 21 Mar 2021 17:01:42 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 1/8] udp: fixup csum for GSO receive slow path
Date:   Sun, 21 Mar 2021 18:01:12 +0100
Message-Id: <4bff28fbaa8c53ca836eb2b9bdabcc3057118916.1616345643.git.pabeni@redhat.com>
In-Reply-To: <cover.1616345643.git.pabeni@redhat.com>
References: <cover.1616345643.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When looping back UDP GSO over UDP tunnel packets to an UDP socket,
the individual packet csum is currently set to CSUM_NONE. That causes
unexpected/wrong csum validation errors later in the UDP receive path.

We could possibly addressing the issue with some additional check and
csum mangling in the UDP tunnel code. Since the issue affects only
this UDP receive slow path, let's set a suitable csum status there.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/udp.h | 18 ++++++++++++++++++
 net/ipv4/udp.c    | 10 ++++++++++
 net/ipv6/udp.c    |  5 +++++
 3 files changed, 33 insertions(+)

diff --git a/include/net/udp.h b/include/net/udp.h
index d4d064c592328..007683eb3e113 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -515,6 +515,24 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 	return segs;
 }
 
+static inline void udp_post_segment_fix_csum(struct sk_buff *skb, int level)
+{
+	/* UDP-lite can't land here - no GRO */
+	WARN_ON_ONCE(UDP_SKB_CB(skb)->partial_cov);
+
+	/* GRO already validated the csum up to 'level', and we just
+	 * consumed one header, update the skb accordingly
+	 */
+	UDP_SKB_CB(skb)->cscov = skb->len;
+	if (level) {
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+		skb->csum_level = 0;
+	} else {
+		skb->ip_summed = CHECKSUM_NONE;
+		skb->csum_valid = 1;
+	}
+}
+
 #ifdef CONFIG_BPF_SYSCALL
 struct sk_psock;
 struct proto *udp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 4a0478b17243a..ff54135c51ffa 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2168,6 +2168,7 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 static int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 {
 	struct sk_buff *next, *segs;
+	int csum_level;
 	int ret;
 
 	if (likely(!udp_unexpected_gso(sk, skb)))
@@ -2175,9 +2176,18 @@ static int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 
 	BUILD_BUG_ON(sizeof(struct udp_skb_cb) > SKB_GSO_CB_OFFSET);
 	__skb_push(skb, -skb_mac_offset(skb));
+	csum_level = !!(skb_shinfo(skb)->gso_type &
+			(SKB_GSO_UDP_TUNNEL | SKB_GSO_UDP_TUNNEL_CSUM));
 	segs = udp_rcv_segment(sk, skb, true);
 	skb_list_walk_safe(segs, skb, next) {
 		__skb_pull(skb, skb_transport_offset(skb));
+
+		/* UDP GSO packets looped back after adding UDP encap land here with CHECKSUM none,
+		 * instead of adding another check in the tunnel fastpath, we can force valid
+		 * csums here (packets are locally generated).
+		 * Additionally fixup the UDP CB
+		 */
+		udp_post_segment_fix_csum(skb, csum_level);
 		ret = udp_queue_rcv_one_skb(sk, skb);
 		if (ret > 0)
 			ip_protocol_deliver_rcu(dev_net(skb->dev), skb, ret);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index d25e5a9252fdb..e7d4bf3a65c72 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -739,16 +739,21 @@ static int udpv6_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 static int udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 {
 	struct sk_buff *next, *segs;
+	int csum_level;
 	int ret;
 
 	if (likely(!udp_unexpected_gso(sk, skb)))
 		return udpv6_queue_rcv_one_skb(sk, skb);
 
 	__skb_push(skb, -skb_mac_offset(skb));
+	csum_level = !!(skb_shinfo(skb)->gso_type &
+			(SKB_GSO_UDP_TUNNEL | SKB_GSO_UDP_TUNNEL_CSUM));
 	segs = udp_rcv_segment(sk, skb, false);
 	skb_list_walk_safe(segs, skb, next) {
 		__skb_pull(skb, skb_transport_offset(skb));
 
+		/* see comments in udp_queue_rcv_skb() */
+		udp_post_segment_fix_csum(skb, csum_level);
 		ret = udpv6_queue_rcv_one_skb(sk, skb);
 		if (ret > 0)
 			ip6_protocol_deliver_rcu(dev_net(skb->dev), skb, ret,
-- 
2.26.2

