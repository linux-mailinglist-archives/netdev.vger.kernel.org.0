Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D98061965C5
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 12:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgC1L3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 07:29:35 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:33424 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbgC1L3d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Mar 2020 07:29:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 48AF320536;
        Sat, 28 Mar 2020 12:29:32 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id p8tcGHD2MmRc; Sat, 28 Mar 2020 12:29:31 +0100 (CET)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 22CFF2055E;
        Sat, 28 Mar 2020 12:29:30 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Sat, 28 Mar
 2020 12:29:29 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 66E813180317; Sat, 28 Mar 2020 12:29:29 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 5/5] xfrm: add prep for esp beet mode offload
Date:   Sat, 28 Mar 2020 12:29:24 +0100
Message-ID: <20200328112924.676-6-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200328112924.676-1-steffen.klassert@secunet.com>
References: <20200328112924.676-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 cas-essen-01.secunet.de (10.53.40.201)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

Like __xfrm_transport/mode_tunnel_prep(), this patch is to add
__xfrm_mode_beet_prep() to fix the transport_header for gso
segments, and reset skb mac_len, and pull skb data to the
proto inside esp.

This patch also fixes a panic, reported by ltp:

  # modprobe esp4_offload
  # runltp -f net_stress.ipsec_tcp

  [ 2452.780511] kernel BUG at net/core/skbuff.c:109!
  [ 2452.799851] Call Trace:
  [ 2452.800298]  <IRQ>
  [ 2452.800705]  skb_push.cold.98+0x14/0x20
  [ 2452.801396]  esp_xmit+0x17b/0x270 [esp4_offload]
  [ 2452.802799]  validate_xmit_xfrm+0x22f/0x2e0
  [ 2452.804285]  __dev_queue_xmit+0x589/0x910
  [ 2452.806264]  __neigh_update+0x3d7/0xa50
  [ 2452.806958]  arp_process+0x259/0x810
  [ 2452.807589]  arp_rcv+0x18a/0x1c

It was caused by the skb going to esp_xmit with a wrong transport
header.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_device.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 50f567a88f45..fa2a506c8163 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -46,6 +46,25 @@ static void __xfrm_mode_tunnel_prep(struct xfrm_state *x, struct sk_buff *skb,
 	pskb_pull(skb, skb->mac_len + x->props.header_len);
 }
 
+static void __xfrm_mode_beet_prep(struct xfrm_state *x, struct sk_buff *skb,
+				  unsigned int hsize)
+{
+	struct xfrm_offload *xo = xfrm_offload(skb);
+	int phlen = 0;
+
+	if (xo->flags & XFRM_GSO_SEGMENT)
+		skb->transport_header = skb->network_header + hsize;
+
+	skb_reset_mac_len(skb);
+	if (x->sel.family != AF_INET6) {
+		phlen = IPV4_BEET_PHMAXLEN;
+		if (x->outer_mode.family == AF_INET6)
+			phlen += sizeof(struct ipv6hdr) - sizeof(struct iphdr);
+	}
+
+	pskb_pull(skb, skb->mac_len + hsize + (x->props.header_len - phlen));
+}
+
 /* Adjust pointers into the packet when IPsec is done at layer2 */
 static void xfrm_outer_mode_prep(struct xfrm_state *x, struct sk_buff *skb)
 {
@@ -66,9 +85,16 @@ static void xfrm_outer_mode_prep(struct xfrm_state *x, struct sk_buff *skb)
 			return __xfrm_transport_prep(x, skb,
 						     sizeof(struct ipv6hdr));
 		break;
+	case XFRM_MODE_BEET:
+		if (x->outer_mode.family == AF_INET)
+			return __xfrm_mode_beet_prep(x, skb,
+						     sizeof(struct iphdr));
+		if (x->outer_mode.family == AF_INET6)
+			return __xfrm_mode_beet_prep(x, skb,
+						     sizeof(struct ipv6hdr));
+		break;
 	case XFRM_MODE_ROUTEOPTIMIZATION:
 	case XFRM_MODE_IN_TRIGGER:
-	case XFRM_MODE_BEET:
 		break;
 	}
 }
-- 
2.17.1

