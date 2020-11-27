Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F372C6AB8
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 18:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732342AbgK0RjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 12:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732209AbgK0RjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 12:39:01 -0500
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9974C0617A7
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 09:39:00 -0800 (PST)
Received: from kero.packetmixer.de (p200300c59712a4e04204e2f79fd8c031.dip0.t-ipconnect.de [IPv6:2003:c5:9712:a4e0:4204:e2f7:9fd8:c031])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 30C37174062;
        Fri, 27 Nov 2020 18:38:59 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 3/3] batman-adv: Don't always reallocate the fragmentation skb head
Date:   Fri, 27 Nov 2020 18:38:49 +0100
Message-Id: <20201127173849.19208-4-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201127173849.19208-1-sw@simonwunderlich.de>
References: <20201127173849.19208-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

When a packet is fragmented by batman-adv, the original batman-adv header
is not modified. Only a new fragmentation is inserted between the original
one and the ethernet header. The code must therefore make sure that it has
a writable region of this size in the skbuff head.

But it is not useful to always reallocate the skbuff by this size even when
there would be more than enough headroom still in the skb. The reallocation
is just to costly during in this codepath.

Fixes: ee75ed88879a ("batman-adv: Fragment and send skbs larger than mtu")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/fragmentation.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index 8de1fb567fd7..1f1f5b0873b2 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -527,13 +527,14 @@ int batadv_frag_send_packet(struct sk_buff *skb,
 		frag_header.no++;
 	}
 
-	/* Make room for the fragment header. */
-	if (batadv_skb_head_push(skb, header_size) < 0 ||
-	    pskb_expand_head(skb, header_size + ETH_HLEN, 0, GFP_ATOMIC) < 0) {
-		ret = -ENOMEM;
+	/* make sure that there is at least enough head for the fragmentation
+	 * and ethernet headers
+	 */
+	ret = skb_cow_head(skb, ETH_HLEN + header_size);
+	if (ret < 0)
 		goto put_primary_if;
-	}
 
+	skb_push(skb, header_size);
 	memcpy(skb->data, &frag_header, header_size);
 
 	/* Send the last fragment */
-- 
2.20.1

