Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF40634E572
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 12:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbhC3KaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 06:30:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40643 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231549AbhC3K3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 06:29:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617100194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O+RB60jrkco7iilpSEpG8xpE0cdbBc0wVlrjO7rBUD8=;
        b=EoMQEXNlAmYG4xY8MSEcIJCBC3hRaoloNnv2EqHeAVaZhImyMh6KhrQC24vY7YrUxyoJXJ
        c1CI1aO6tTrpyFHsJx2PBj/apG8Gzuv/4GJp7er65Ao9Q/DapgAPSpYgcOZ/DvScd43OKB
        YSTIixnpFjwebv7waDtmvv8yyT30oU8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-muhXeFFqMUSbFrBA4lXPNQ-1; Tue, 30 Mar 2021 06:29:52 -0400
X-MC-Unique: muhXeFFqMUSbFrBA4lXPNQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58D5E6B9C1;
        Tue, 30 Mar 2021 10:29:51 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-56.ams2.redhat.com [10.36.115.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDBE019C45;
        Tue, 30 Mar 2021 10:29:49 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next v3 3/8] udp: properly complete L4 GRO over UDP tunnel packet
Date:   Tue, 30 Mar 2021 12:28:51 +0200
Message-Id: <3b721b932b943882f7111c74b6081613db801ffb.1617099959.git.pabeni@redhat.com>
In-Reply-To: <cover.1617099959.git.pabeni@redhat.com>
References: <cover.1617099959.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the previous patch, the stack can do L4 UDP aggregation
on top of a UDP tunnel.

In such scenario, udp{4,6}_gro_complete will be called twice. This function
will enter its is_flist branch immediately, even though that is only
correct on the second call, as GSO_FRAGLIST is only relevant for the
inner packet.

Instead, we need to try first UDP tunnel-based aggregation, if the GRO
packet requires that.

This patch changes udp{4,6}_gro_complete to skip the frag list processing
when while encap_mark == 1, identifying processing of the outer tunnel
header.
Additionally, clears the field in udp_gro_complete() so that we can enter
the frag list path on the next round, for the inner header.

v1 -> v2:
 - hopefully clarified the commit message

Reviewed-by: Willem de Bruijn <willemb@google.com>
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

