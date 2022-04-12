Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9224FDCC9
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239504AbiDLKlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355970AbiDLKdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 06:33:45 -0400
Received: from mail.strongswan.org (sitav-80046.hsr.ch [152.96.80.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984E45BD12
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 02:35:03 -0700 (PDT)
Received: from think.wlp.is (unknown [185.12.128.225])
        by mail.strongswan.org (Postfix) with ESMTPSA id 4FF3A404C0;
        Tue, 12 Apr 2022 11:35:02 +0200 (CEST)
From:   Martin Willi <martin@strongswan.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jethro Beekman <kernel@jbeekman.nl>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] macvlan: Fix leaking skb in source mode with nodst option
Date:   Tue, 12 Apr 2022 11:34:57 +0200
Message-Id: <20220412093457.22946-1-martin@strongswan.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MACVLAN receive handler clones skbs to all matching source MACVLAN
interfaces, before it passes the packet along to match on destination
based MACVLANs.

When using the MACVLAN nodst mode, passing the packet to destination based
MACVLANs is omitted and the handler returns with RX_HANDLER_CONSUMED.
However, the passed skb is not freed, leaking for any packet processed
with the nodst option.

Properly free the skb when consuming packets to fix that leak.

Fixes: 427f0c8c194b ("macvlan: Add nodst option to macvlan type source")
Signed-off-by: Martin Willi <martin@strongswan.org>
---
 drivers/net/macvlan.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 069e8824c264..b00bc8173abe 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -460,8 +460,10 @@ static rx_handler_result_t macvlan_handle_frame(struct sk_buff **pskb)
 			return RX_HANDLER_CONSUMED;
 		*pskb = skb;
 		eth = eth_hdr(skb);
-		if (macvlan_forward_source(skb, port, eth->h_source))
+		if (macvlan_forward_source(skb, port, eth->h_source)) {
+			kfree_skb(skb);
 			return RX_HANDLER_CONSUMED;
+		}
 		src = macvlan_hash_lookup(port, eth->h_source);
 		if (src && src->mode != MACVLAN_MODE_VEPA &&
 		    src->mode != MACVLAN_MODE_BRIDGE) {
@@ -480,8 +482,10 @@ static rx_handler_result_t macvlan_handle_frame(struct sk_buff **pskb)
 		return RX_HANDLER_PASS;
 	}
 
-	if (macvlan_forward_source(skb, port, eth->h_source))
+	if (macvlan_forward_source(skb, port, eth->h_source)) {
+		kfree_skb(skb);
 		return RX_HANDLER_CONSUMED;
+	}
 	if (macvlan_passthru(port))
 		vlan = list_first_or_null_rcu(&port->vlans,
 					      struct macvlan_dev, list);
-- 
2.25.1

