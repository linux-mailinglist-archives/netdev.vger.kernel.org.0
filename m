Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2425BAF78
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 16:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiIPOiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 10:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbiIPOiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 10:38:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D557B2848
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 07:38:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EA0F62B9B
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 14:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BA5C433C1;
        Fri, 16 Sep 2022 14:38:04 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="jXe5c4NO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1663339084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uk+JLVBPOzQxLNskMZuidn60MIk9OXQOF+D1y59gJmA=;
        b=jXe5c4NOlZNZ0w+yzZlvNJxQ5mX8lqM70xwrpRdhsqn6drjQbRTIPnWoexrAL25vDg0gP5
        0FN7kzrhZTzxACTCBMi89qZBdn70z8jY9bvqPp/h017POZi45MtTIoB5LEj2fLnUf5C1tB
        c+IfjDnwNS93+sDzL5FVsgeBUTlg7hE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c3f2cf44 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Fri, 16 Sep 2022 14:38:03 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     kuba@kernel.org, pablo@netfilter.org, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH net 3/3] wireguard: netlink: avoid variable-sized memcpy on sockaddr
Date:   Fri, 16 Sep 2022 15:37:40 +0100
Message-Id: <20220916143740.831881-4-Jason@zx2c4.com>
In-Reply-To: <20220916143740.831881-1-Jason@zx2c4.com>
References: <20220916143740.831881-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Doing a variable-sized memcpy is slower, and the compiler isn't smart
enough to turn this into a constant-size assignment.

Further, Kees' latest fortified memcpy will actually bark, because the
destination pointer is type sockaddr, not explicitly sockaddr_in or
sockaddr_in6, so it thinks there's an overflow:

    memcpy: detected field-spanning write (size 28) of single field
    "&endpoint.addr" at drivers/net/wireguard/netlink.c:446 (size 16)

Fix this by just assigning by using explicit casts for each checked
case.

Cc: Kees Cook <keescook@chromium.org>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/netlink.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireguard/netlink.c b/drivers/net/wireguard/netlink.c
index d0f3b6d7f408..5c804bcabfe6 100644
--- a/drivers/net/wireguard/netlink.c
+++ b/drivers/net/wireguard/netlink.c
@@ -436,14 +436,13 @@ static int set_peer(struct wg_device *wg, struct nlattr **attrs)
 	if (attrs[WGPEER_A_ENDPOINT]) {
 		struct sockaddr *addr = nla_data(attrs[WGPEER_A_ENDPOINT]);
 		size_t len = nla_len(attrs[WGPEER_A_ENDPOINT]);
+		struct endpoint endpoint = { { { 0 } } };
 
-		if ((len == sizeof(struct sockaddr_in) &&
-		     addr->sa_family == AF_INET) ||
-		    (len == sizeof(struct sockaddr_in6) &&
-		     addr->sa_family == AF_INET6)) {
-			struct endpoint endpoint = { { { 0 } } };
-
-			memcpy(&endpoint.addr, addr, len);
+		if (len == sizeof(struct sockaddr_in) && addr->sa_family == AF_INET) {
+			endpoint.addr4 = *(struct sockaddr_in *)addr;
+			wg_socket_set_peer_endpoint(peer, &endpoint);
+		} else if (len == sizeof(struct sockaddr_in6) && addr->sa_family == AF_INET6) {
+			endpoint.addr6 = *(struct sockaddr_in6 *)addr;
 			wg_socket_set_peer_endpoint(peer, &endpoint);
 		}
 	}
-- 
2.37.3

