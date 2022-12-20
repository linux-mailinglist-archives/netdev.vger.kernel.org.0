Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F33652577
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 18:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiLTRS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 12:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234004AbiLTRSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 12:18:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC241D312
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 09:18:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A7A56151F
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 17:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04578C433D2;
        Tue, 20 Dec 2022 17:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671556708;
        bh=R5IFTKNT0vebHOzgnonYmqWrlLSrujWOsBk+f1EULQk=;
        h=From:To:Cc:Subject:Date:From;
        b=FzlITNicY5B7qJSG2t7AHrrxBanKXhovBrToUjn/yfzHv4Lq/6isso7me1pfN2y1s
         MmpH7SPng1xL3XsITp2YS5j+C5DlyELs33OXc1XWA6E/IyJE85MOOCwEeCeankToxo
         JQoVxO+0dB5yo5cnwj634Q+ZJZaS6Ck8NWjrkhDWfiGDBohNeQSurRS9Kph7XwTRqJ
         xUHYV3sjFeZPzAZ5qSkalucbUX2dUnA4d5cZc2VhbYE3judd/1Qgq25jTMuZAUkZOc
         72QClCldhlFr/xVvsGVb2H2meKPN+fNIr8fQzn6vErWr6qh3ZbdOd3QeQYgjjPmJq7
         wLPxgT9Qi5D2w==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Jianlin Shi <jishi@redhat.com>
Subject: [PATCH net] net: vrf: determine the dst using the original ifindex for multicast
Date:   Tue, 20 Dec 2022 18:18:25 +0100
Message-Id: <20221220171825.1172237-1-atenart@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multicast packets received on an interface bound to a VRF are marked as
belonging to the VRF and the skb device is updated to point to the VRF
device itself. This was fine even when a route was associated to a
device as when performing a fib table lookup 'oif' in fib6_table_lookup
(coming from 'skb->dev->ifindex' in ip6_route_input) was set to 0 when
FLOWI_FLAG_SKIP_NH_OIF was set.

With commit 40867d74c374 ("net: Add l3mdev index to flow struct and
avoid oif reset for port devices") this is not longer true and multicast
traffic is not received on the original interface.

Instead of adding back a similar check in fib6_table_lookup determine
the dst using the original ifindex for multicast VRF traffic. To make
things consistent across the function do the above for all strict
packets, which was the logic before commit 6f12fa775530 ("vrf: mark skb
for multicast or link-local as enslaved to VRF"). Note that reverting to
this behavior should be fine as the change was about marking packets
belonging to the VRF, not about their dst.

Fixes: 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif reset for port devices")
Cc: David Ahern <dsahern@kernel.org>
Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/vrf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 6b5a4d036d15..bdb3a76a352e 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1385,8 +1385,8 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 
 	/* loopback, multicast & non-ND link-local traffic; do not push through
 	 * packet taps again. Reset pkt_type for upper layers to process skb.
-	 * For strict packets with a source LLA, determine the dst using the
-	 * original ifindex.
+	 * For non-loopback strict packets, determine the dst using the original
+	 * ifindex.
 	 */
 	if (skb->pkt_type == PACKET_LOOPBACK || (need_strict && !is_ndisc)) {
 		skb->dev = vrf_dev;
@@ -1395,7 +1395,7 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 
 		if (skb->pkt_type == PACKET_LOOPBACK)
 			skb->pkt_type = PACKET_HOST;
-		else if (ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL)
+		else
 			vrf_ip6_input_dst(skb, vrf_dev, orig_iif);
 
 		goto out;
-- 
2.38.1

