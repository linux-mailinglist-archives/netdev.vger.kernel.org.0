Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31EAC34A35A
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 09:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhCZIpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 04:45:03 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:44542 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229779AbhCZIou (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 04:44:50 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9124C20547;
        Fri, 26 Mar 2021 09:44:49 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TjQ740ohZN35; Fri, 26 Mar 2021 09:44:49 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 11889200AA;
        Fri, 26 Mar 2021 09:44:49 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 26 Mar 2021 09:44:48 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 26 Mar
 2021 09:44:48 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 19F063180307; Fri, 26 Mar 2021 09:44:48 +0100 (CET)
Date:   Fri, 26 Mar 2021 09:44:48 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <netdev@vger.kernel.org>
CC:     Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec v2] xfrm: Provide private skb extensions for segmented
 and hw offloaded ESP packets
Message-ID: <20210326084448.GA62598@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 94579ac3f6d0 ("xfrm: Fix double ESP trailer insertion in IPsec
crypto offload.") added a XFRM_XMIT flag to avoid duplicate ESP trailer
insertion on HW offload. This flag is set on the secpath that is shared
amongst segments. This lead to a situation where some segments are
not transformed correctly when segmentation happens at layer 3.

Fix this by using private skb extensions for segmented and hw offloaded
ESP packets.

Fixes: 94579ac3f6d0 ("xfrm: Fix double ESP trailer insertion in IPsec crypto offload.")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/esp4_offload.c | 11 ++++++++++-
 net/ipv6/esp6_offload.c | 11 ++++++++++-
 net/xfrm/xfrm_device.c  |  2 --
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 601f5fbfc63f..7d0dff64939e 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -312,8 +312,17 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
 	ip_hdr(skb)->tot_len = htons(skb->len);
 	ip_send_check(ip_hdr(skb));
 
-	if (hw_offload)
+	if (hw_offload) {
+		if (!skb_ext_add(skb, SKB_EXT_SEC_PATH))
+			return -ENOMEM;
+
+		xo = xfrm_offload(skb);
+		if (!xo)
+			return -EINVAL;
+
+		xo->flags |= XFRM_XMIT;
 		return 0;
+	}
 
 	err = esp_output_tail(x, skb, &esp);
 	if (err)
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 1ca516fb30e1..dde9c9149ac5 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -346,8 +346,17 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 
 	ipv6_hdr(skb)->payload_len = htons(len);
 
-	if (hw_offload)
+	if (hw_offload) {
+		if (!skb_ext_add(skb, SKB_EXT_SEC_PATH))
+			return -ENOMEM;
+
+		xo = xfrm_offload(skb);
+		if (!xo)
+			return -EINVAL;
+
+		xo->flags |= XFRM_XMIT;
 		return 0;
+	}
 
 	err = esp6_output_tail(x, skb, &esp);
 	if (err)
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index edf11893dbe8..6d6917b68856 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -134,8 +134,6 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		return skb;
 	}
 
-	xo->flags |= XFRM_XMIT;
-
 	if (skb_is_gso(skb) && unlikely(x->xso.dev != dev)) {
 		struct sk_buff *segs;
 
-- 
2.25.1

