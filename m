Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6F2321CE9
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 17:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhBVQ1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 11:27:34 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:60986 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231689AbhBVQ06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 11:26:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1614011154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N6xDFdEFdQ6jS23xmeafoPQPPFJphZfu48UKYzkjnas=;
        b=PxUD1db6wi1mQA0Jjo4rEA9Xpx0eFLOn4CqsQqyN8+zWwv+8+iuEsES8/OP8fLJjhRqlzx
        c+CGtomqDbYQwYoyEO1p8mlCGkcgQjxAQfnX27Hzv8HL6mQUAkCxENoXJTXkaiDWNWAQr+
        ksDXbgE6X7GEca4Tzm4d4NL49U+0958=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2022fa9a (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 22 Feb 2021 16:25:54 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH net 1/7] wireguard: avoid double unlikely() notation when using IS_ERR()
Date:   Mon, 22 Feb 2021 17:25:43 +0100
Message-Id: <20210222162549.3252778-2-Jason@zx2c4.com>
In-Reply-To: <20210222162549.3252778-1-Jason@zx2c4.com>
References: <20210222162549.3252778-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antonio Quartulli <a@unstable.cc>

The definition of IS_ERR() already applies the unlikely() notation
when checking the error status of the passed pointer. For this
reason there is no need to have the same notation outside of
IS_ERR() itself.

Clean up code by removing redundant notation.

Signed-off-by: Antonio Quartulli <a@unstable.cc>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/device.c | 2 +-
 drivers/net/wireguard/socket.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index a3ed49cd95c3..cd51a2afa28e 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -157,7 +157,7 @@ static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
 	} else {
 		struct sk_buff *segs = skb_gso_segment(skb, 0);
 
-		if (unlikely(IS_ERR(segs))) {
+		if (IS_ERR(segs)) {
 			ret = PTR_ERR(segs);
 			goto err_peer;
 		}
diff --git a/drivers/net/wireguard/socket.c b/drivers/net/wireguard/socket.c
index 410b318e57fb..41430c0e465a 100644
--- a/drivers/net/wireguard/socket.c
+++ b/drivers/net/wireguard/socket.c
@@ -71,7 +71,7 @@ static int send4(struct wg_device *wg, struct sk_buff *skb,
 				ip_rt_put(rt);
 			rt = ip_route_output_flow(sock_net(sock), &fl, sock);
 		}
-		if (unlikely(IS_ERR(rt))) {
+		if (IS_ERR(rt)) {
 			ret = PTR_ERR(rt);
 			net_dbg_ratelimited("%s: No route to %pISpfsc, error %d\n",
 					    wg->dev->name, &endpoint->addr, ret);
@@ -138,7 +138,7 @@ static int send6(struct wg_device *wg, struct sk_buff *skb,
 		}
 		dst = ipv6_stub->ipv6_dst_lookup_flow(sock_net(sock), sock, &fl,
 						      NULL);
-		if (unlikely(IS_ERR(dst))) {
+		if (IS_ERR(dst)) {
 			ret = PTR_ERR(dst);
 			net_dbg_ratelimited("%s: No route to %pISpfsc, error %d\n",
 					    wg->dev->name, &endpoint->addr, ret);
-- 
2.30.1

