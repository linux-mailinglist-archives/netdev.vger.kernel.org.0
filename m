Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFF6343392
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 18:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhCURCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 13:02:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31582 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230159AbhCURBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 13:01:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616346111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WKP8yMkcDSS4Xm8PcjQemsX2UfUPX2HL3W4OvvHoa68=;
        b=KjucdljY6b/vw3dJ0LJZGgXlvz4EG4NthqvS5ChQDjqoVmaOBHZdbNzxv5XSOFlxinpBf9
        rTI2/mxUXTUjC+znIStakWkDTRJL+uZfINny6uA9og29dphT0JtelPt4EJ6B1Xe35zxPcx
        uuWHjZzzELK5FDwik7m8vblafAZCvEk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-J5omoFk-PMCTrIhnmmdssg-1; Sun, 21 Mar 2021 13:01:49 -0400
X-MC-Unique: J5omoFk-PMCTrIhnmmdssg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 507B3180FCA7;
        Sun, 21 Mar 2021 17:01:48 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C03685D6B1;
        Sun, 21 Mar 2021 17:01:46 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 3/8] udp: properly complete L4 GRO over UDP tunnel packet
Date:   Sun, 21 Mar 2021 18:01:14 +0100
Message-Id: <72d8fc8a6d35a74d267cca6c9eddb3ff7852868b.1616345643.git.pabeni@redhat.com>
In-Reply-To: <cover.1616345643.git.pabeni@redhat.com>
References: <cover.1616345643.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the previous patch the stack can do L4 UDP aggregation
on top of an UDP tunnel.

The current GRO complete code tries frag based aggregation first;
in the above scenario will generate corrupted frames.

We need to try first UDP tunnel based aggregation, if the GRO
packet requires that. We can use time GRO 'encap_mark' field
to track the need GRO complete action. If encap_mark is set,
skip the frag_list aggregation.

On tunnel encap GRO complete clear such field, so that an inner
frag_list GRO complete could take action.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv4/udp_offload.c | 8 +++++++-
 net/ipv6/udp_offload.c | 3 ++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 25134a3548e99..54e06b88af69a 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -642,6 +642,11 @@ int udp_gro_complete(struct sk_buff *skb, int nhoff,
 		skb_shinfo(skb)->gso_type = uh->check ? SKB_GSO_UDP_TUNNEL_CSUM
 					: SKB_GSO_UDP_TUNNEL;
 
+		/* clear the encap mark, so that inner frag_list gro_complete
+		 * can take place
+		 */
+		NAPI_GRO_CB(skb)->encap_mark = 0;
+
 		/* Set encapsulation before calling into inner gro_complete()
 		 * functions to make them set up the inner offsets.
 		 */
@@ -665,7 +670,8 @@ INDIRECT_CALLABLE_SCOPE int udp4_gro_complete(struct sk_buff *skb, int nhoff)
 	const struct iphdr *iph = ip_hdr(skb);
 	struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
 
-	if (NAPI_GRO_CB(skb)->is_flist) {
+	/* do fraglist only if there is no outer UDP encap (or we already processed it) */
+	if (NAPI_GRO_CB(skb)->is_flist && !NAPI_GRO_CB(skb)->encap_mark) {
 		uh->len = htons(skb->len - nhoff);
 
 		skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index faa823c242923..b3d9ed96e5ea5 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -163,7 +163,8 @@ INDIRECT_CALLABLE_SCOPE int udp6_gro_complete(struct sk_buff *skb, int nhoff)
 	const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 	struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
 
-	if (NAPI_GRO_CB(skb)->is_flist) {
+	/* do fraglist only if there is no outer UDP encap (or we already processed it) */
+	if (NAPI_GRO_CB(skb)->is_flist && !NAPI_GRO_CB(skb)->encap_mark) {
 		uh->len = htons(skb->len - nhoff);
 
 		skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
-- 
2.26.2

