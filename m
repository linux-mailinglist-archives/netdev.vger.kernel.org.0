Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A166B34E571
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 12:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhC3KaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 06:30:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231529AbhC3K3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 06:29:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617100192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jajgI2J2ZIChiEa5C5vh0N2/WMrAV25Sf0fDmUztNLE=;
        b=KxNog1lftCmLEYW4VlwZa+EB72G/2lutt2mqFv2BAdCnKM7SiYmXxkgZAYTuKrykHPqMec
        Tx4KzgtpYbTVQOIB9CKtrWuCN2EW7Jmed3hjRsLXnQcfpfXXULQLwmCsaNZSdpLa2PzTT0
        DlCmzuh0WS7hDykeGClTKN2Li3vf0RQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-oYRXPxgzNnavck4Nn_r6OA-1; Tue, 30 Mar 2021 06:29:48 -0400
X-MC-Unique: oYRXPxgzNnavck4Nn_r6OA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9446710866A3;
        Tue, 30 Mar 2021 10:29:47 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-56.ams2.redhat.com [10.36.115.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F222719718;
        Tue, 30 Mar 2021 10:29:45 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next v3 1/8] udp: fixup csum for GSO receive slow path
Date:   Tue, 30 Mar 2021 12:28:49 +0200
Message-Id: <6430002178b54a389ea50413c7074ba9b48d6212.1617099959.git.pabeni@redhat.com>
In-Reply-To: <cover.1617099959.git.pabeni@redhat.com>
References: <cover.1617099959.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When UDP packets generated locally by a socket with UDP_SEGMENT
traverse the following path:

UDP tunnel(xmit) -> veth (segmentation) -> veth (gro) ->
	UDP tunnel (rx) -> UDP socket (no UDP_GRO)

ip_summed will be set to CHECKSUM_PARTIAL at creation time and
such checksum mode will be preserved in the above path up to the
UDP tunnel receive code where we have:

 __iptunnel_pull_header() -> skb_pull_rcsum() ->
skb_postpull_rcsum() -> __skb_postpull_rcsum()

The latter will convert the skb to CHECKSUM_NONE.

The UDP GSO packet will be later segmented as part of the rx socket
receive operation, and will present a CHECKSUM_NONE after segmentation.

Additionally the segmented packets UDP CB still refers to the original
GSO packet len. Overall that causes unexpected/wrong csum validation
errors later in the UDP receive path.

We could possibly address the issue with some additional checks and
csum mangling in the UDP tunnel code. Since the issue affects only
this UDP receive slow path, let's set a suitable csum status there.

Note that SKB_GSO_UDP_L4 or SKB_GSO_FRAGLIST packets lacking an UDP
encapsulation present a valid checksum when landing to udp_queue_rcv_skb(),
as the UDP checksum has been validated by the GRO engine.

v2 -> v3:
 - even more verbose commit message and comments

v1 -> v2:
 - restrict the csum update to the packets strictly needing them
 - hopefully clarify the commit message and code comments

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/udp.h | 23 +++++++++++++++++++++++
 net/ipv4/udp.c    |  2 ++
 net/ipv6/udp.c    |  1 +
 3 files changed, 26 insertions(+)

diff --git a/include/net/udp.h b/include/net/udp.h
index d4d064c592328..adf2ff8ac87c9 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -515,6 +515,29 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 	return segs;
 }
 
+static inline void udp_post_segment_fix_csum(struct sk_buff *skb)
+{
+	/* UDP-lite can't land here - no GRO */
+	WARN_ON_ONCE(UDP_SKB_CB(skb)->partial_cov);
+
+	/* UDP packets generated with UDP_SEGMENT and traversing:
+	 *
+	 * UDP tunnel(xmit) -> veth (segmentation) -> veth (gro) -> UDP tunnel (rx)
+	 *
+	 * can reach an UDP socket with CHECKSUM_NONE, because
+	 * __iptunnel_pull_header() converts CHECKSUM_PARTIAL into NONE.
+	 * SKB_GSO_UDP_L4 or SKB_GSO_FRAGLIST packets with no UDP tunnel will
+	 * have a valid checksum, as the GRO engine validates the UDP csum
+	 * before the aggregation and nobody strips such info in between.
+	 * Instead of adding another check in the tunnel fastpath, we can force
+	 * a valid csum after the segmentation.
+	 * Additionally fixup the UDP CB.
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

