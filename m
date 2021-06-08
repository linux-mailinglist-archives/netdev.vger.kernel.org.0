Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433EA39FAD9
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 17:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbhFHPhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 11:37:24 -0400
Received: from simonwunderlich.de ([79.140.42.25]:34610 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbhFHPhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 11:37:23 -0400
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jun 2021 11:37:22 EDT
Received: from kero.packetmixer.de (p200300c5970dd3e020a52263b5aabfb3.dip0.t-ipconnect.de [IPv6:2003:c5:970d:d3e0:20a5:2263:b5aa:bfb3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 8DB35174026;
        Tue,  8 Jun 2021 17:27:03 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 04/11] batman-adv: bcast: avoid skb-copy for (re)queued broadcasts
Date:   Tue,  8 Jun 2021 17:26:53 +0200
Message-Id: <20210608152700.30315-5-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210608152700.30315-1-sw@simonwunderlich.de>
References: <20210608152700.30315-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

Broadcast packets send via batadv_send_outstanding_bcast_packet() were
originally copied in batadv_forw_bcast_packet_to_list() before being
queued. And after that only the ethernet header will be pushed through
batadv_send_broadcast_skb()->batadv_send_skb_packet() which works safely
on skb clones as it uses batadv_skb_head_push()->skb_cow_head().

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/send.c b/net/batman-adv/send.c
index 07b0ba265472..0b9dd29d3b6a 100644
--- a/net/batman-adv/send.c
+++ b/net/batman-adv/send.c
@@ -1072,7 +1072,7 @@ static void batadv_send_outstanding_bcast_packet(struct work_struct *work)
 	}
 
 	/* send a copy of the saved skb */
-	skb1 = skb_copy(forw_packet->skb, GFP_ATOMIC);
+	skb1 = skb_clone(forw_packet->skb, GFP_ATOMIC);
 	if (!skb1)
 		goto out;
 
-- 
2.20.1

