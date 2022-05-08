Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D694B51EDCA
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 15:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbiEHNeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 09:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233495AbiEHNeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 09:34:14 -0400
Received: from simonwunderlich.de (simonwunderlich.de [23.88.38.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE2BDF92
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 06:30:24 -0700 (PDT)
Received: from kero.packetmixer.de (p200300fa271A310000945df34724C077.dip0.t-ipconnect.de [IPv6:2003:fa:271a:3100:94:5df3:4724:c077])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 4C7FAFA1FC;
        Sun,  8 May 2022 15:21:15 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Felix Kaechele <felix@kaechele.ca>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 1/1] batman-adv: Don't skb_split skbuffs with frag_list
Date:   Sun,  8 May 2022 15:21:10 +0200
Message-Id: <20220508132110.20451-2-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220508132110.20451-1-sw@simonwunderlich.de>
References: <20220508132110.20451-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The receiving interface might have used GRO to receive more fragments than
MAX_SKB_FRAGS fragments. In this case, these will not be stored in
skb_shinfo(skb)->frags but merged into the frag list.

batman-adv relies on the function skb_split to split packets up into
multiple smaller packets which are not larger than the MTU on the outgoing
interface. But this function cannot handle frag_list entries and is only
operating on skb_shinfo(skb)->frags. If it is still trying to split such an
skb and xmit'ing it on an interface without support for NETIF_F_FRAGLIST,
then validate_xmit_skb() will try to linearize it. But this fails due to
inconsistent information. And __pskb_pull_tail will trigger a BUG_ON after
skb_copy_bits() returns an error.

In case of entries in frag_list, just linearize the skb before operating on
it with skb_split().

Reported-by: Felix Kaechele <felix@kaechele.ca>
Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Tested-by: Felix Kaechele <felix@kaechele.ca>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/fragmentation.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index 0899a729a23f..c120c7c6d25f 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -475,6 +475,17 @@ int batadv_frag_send_packet(struct sk_buff *skb,
 		goto free_skb;
 	}
 
+	/* GRO might have added fragments to the fragment list instead of
+	 * frags[]. But this is not handled by skb_split and must be
+	 * linearized to avoid incorrect length information after all
+	 * batman-adv fragments were created and submitted to the
+	 * hard-interface
+	 */
+	if (skb_has_frag_list(skb) && __skb_linearize(skb)) {
+		ret = -ENOMEM;
+		goto free_skb;
+	}
+
 	/* Create one header to be copied to all fragments */
 	frag_header.packet_type = BATADV_UNICAST_FRAG;
 	frag_header.version = BATADV_COMPAT_VERSION;
-- 
2.30.2

