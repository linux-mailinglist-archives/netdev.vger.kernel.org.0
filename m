Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516433497DF
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 18:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhCYRYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 13:24:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20996 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229908AbhCYRY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 13:24:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616693068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kj+02GhskfLY0G3Xmm+DUMuMtaEG0DTXPMkRuwd9xU8=;
        b=gU0a9MUWvdfWn6WwnMnxjCkBU3YUrz0GlxbCB816Ovsns8xosR+yM0LkmPfEsGZZ2NvSdM
        Oe7jC5m/Z7hFQaY/grNNH9SQIwbflcib5qGcJEruBIMQtrKCOiNhd8RO2Seh+70lkdD7A1
        TLNKY03raDCTeZ+gOCyjpc8OKVyRLZ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-bmg7UaSgOB-DRWTz3OxDjg-1; Thu, 25 Mar 2021 13:24:25 -0400
X-MC-Unique: bmg7UaSgOB-DRWTz3OxDjg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BE11801817;
        Thu, 25 Mar 2021 17:24:23 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-211.ams2.redhat.com [10.36.113.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC228764F2;
        Thu, 25 Mar 2021 17:24:21 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next v2 1/8] udp: fixup csum for GSO receive slow path
Date:   Thu, 25 Mar 2021 18:24:00 +0100
Message-Id: <28d04433c648ea8143c199459bfe60650b1a0d28.1616692794.git.pabeni@redhat.com>
In-Reply-To: <cover.1616692794.git.pabeni@redhat.com>
References: <cover.1616692794.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When UDP packets generated locally by a socket with UDP_SEGMENT
traverse the following path:

UDP tunnel(xmit) -> veth (segmentation) -> veth (gro) ->
	UDP tunnel (rx) -> UDP socket (no UDP_GRO)

they are segmented as part of the rx socket receive operation, and
present a CHECKSUM_NONE after segmentation.

Additionally the segmented packets UDP CB still refers to the original
GSO packet len. Overall that causes unexpected/wrong csum validation
errors later in the UDP receive path.

We could possibly address the issue with some additional checks and
csum mangling in the UDP tunnel code. Since the issue affects only
this UDP receive slow path, let's set a suitable csum status there.

v1 -> v2:
 - restrict the csum update to the packets strictly needing them
 - hopefully clarify the commit message and code comments

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/udp.h | 18 ++++++++++++++++++
 net/ipv4/udp.c    |  2 ++
 net/ipv6/udp.c    |  1 +
 3 files changed, 21 insertions(+)

diff --git a/include/net/udp.h b/include/net/udp.h
index d4d064c592328..7fc735919f4df 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -515,6 +515,24 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 	return segs;
 }
 
+static inline void udp_post_segment_fix_csum(struct sk_buff *skb)
+{
+	/* UDP-lite can't land here - no GRO */
+	WARN_ON_ONCE(UDP_SKB_CB(skb)->partial_cov);
+
+	/* UDP packets generated with UDP_SEGMENT and traversing:
+	 * UDP tunnel(xmit) -> veth (segmentation) -> veth (gro) -> UDP tunnel (rx)
+	 * land here with CHECKSUM_NONE. Instead of adding another check
+	 * in the tunnel fastpath, we can force valid csums here:
+	 * packets are locally generated and the GRO engine already validated
+	 * the csum.
+	 * Additionally fixup the UDP CB
+	 */
+	UDP_SKB_CB(skb)->cscov = skb->len;
+	if (skb->ip_summed == CHECKSUM_NONE && !skb->csum_valid)
+		skb->csum_valid = 1;
+}
+
 #ifdef CONFIG_BPF_SYSCALL
 struct sk_psock;
 struct proto *udp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 4a0478b17243a..fe85dcf8c0087 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2178,6 +2178,8 @@ static int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	segs = udp_rcv_segment(sk, skb, true);
 	skb_list_walk_safe(segs, skb, next) {
 		__skb_pull(skb, skb_transport_offset(skb));
+
+		udp_post_segment_fix_csum(skb);
 		ret = udp_queue_rcv_one_skb(sk, skb);
 		if (ret > 0)
 			ip_protocol_deliver_rcu(dev_net(skb->dev), skb, ret);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index d25e5a9252fdb..fa2f547383925 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -749,6 +749,7 @@ static int udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	skb_list_walk_safe(segs, skb, next) {
 		__skb_pull(skb, skb_transport_offset(skb));
 
+		udp_post_segment_fix_csum(skb);
 		ret = udpv6_queue_rcv_one_skb(sk, skb);
 		if (ret > 0)
 			ip6_protocol_deliver_rcu(dev_net(skb->dev), skb, ret,
-- 
2.26.2

