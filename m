Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0B94EB7D4
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 03:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241655AbiC3Bdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 21:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241644AbiC3Bda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 21:33:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D0017156E;
        Tue, 29 Mar 2022 18:31:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D849061307;
        Wed, 30 Mar 2022 01:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B1EC3410F;
        Wed, 30 Mar 2022 01:31:44 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="efRzOqUA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1648603904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BHmlRXCg3bn61peNZ2mYON7rFLflhQaM57TPzk0GIP0=;
        b=efRzOqUAoG+yLoMZMocBVa9go3twFmpT6yptfbB1Ji4OP34qIfxcZnckJVIp4OSoCwLXDF
        /YJuQHZ9LjLHoewhdxf+5U9bP1F1Y4155FeZ1K5t3wODalhIZPjTofMiwhuReAxev9Ss4v
        uzlqAtgQsAARwZWx1Z25FoKJET2GIoU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 01209830 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 30 Mar 2022 01:31:44 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH net 4/4] wireguard: socket: ignore v6 endpoints when ipv6 is disabled
Date:   Tue, 29 Mar 2022 21:31:27 -0400
Message-Id: <20220330013127.426620-5-Jason@zx2c4.com>
In-Reply-To: <20220330013127.426620-1-Jason@zx2c4.com>
References: <20220330013127.426620-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous commit fixed a memory leak on the send path in the event
that IPv6 is disabled at compile time, but how did a packet even arrive
there to begin with? It turns out we have previously allowed IPv6
endpoints even when IPv6 support is disabled at compile time. This is
awkward and inconsistent. Instead, let's just ignore all things IPv6,
the same way we do other malformed endpoints, in the case where IPv6 is
disabled.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireguard/socket.c b/drivers/net/wireguard/socket.c
index 467eef0e563b..0414d7a6ce74 100644
--- a/drivers/net/wireguard/socket.c
+++ b/drivers/net/wireguard/socket.c
@@ -242,7 +242,7 @@ int wg_socket_endpoint_from_skb(struct endpoint *endpoint,
 		endpoint->addr4.sin_addr.s_addr = ip_hdr(skb)->saddr;
 		endpoint->src4.s_addr = ip_hdr(skb)->daddr;
 		endpoint->src_if4 = skb->skb_iif;
-	} else if (skb->protocol == htons(ETH_P_IPV6)) {
+	} else if (IS_ENABLED(CONFIG_IPV6) && skb->protocol == htons(ETH_P_IPV6)) {
 		endpoint->addr6.sin6_family = AF_INET6;
 		endpoint->addr6.sin6_port = udp_hdr(skb)->source;
 		endpoint->addr6.sin6_addr = ipv6_hdr(skb)->saddr;
@@ -285,7 +285,7 @@ void wg_socket_set_peer_endpoint(struct wg_peer *peer,
 		peer->endpoint.addr4 = endpoint->addr4;
 		peer->endpoint.src4 = endpoint->src4;
 		peer->endpoint.src_if4 = endpoint->src_if4;
-	} else if (endpoint->addr.sa_family == AF_INET6) {
+	} else if (IS_ENABLED(CONFIG_IPV6) && endpoint->addr.sa_family == AF_INET6) {
 		peer->endpoint.addr6 = endpoint->addr6;
 		peer->endpoint.src6 = endpoint->src6;
 	} else {
-- 
2.35.1

