Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA632D55EA
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 09:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730087AbgLJI5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 03:57:25 -0500
Received: from s2.neomailbox.net ([5.148.176.60]:18464 "EHLO s2.neomailbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728600AbgLJI5Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 03:57:16 -0500
From:   Antonio Quartulli <a@unstable.cc>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Antonio Quartulli <a@unstable.cc>
Subject: [PATCH] wireguard: avoid double unlikely() notation when using IS_ERR()
Date:   Thu, 10 Dec 2020 09:55:05 +0100
Message-Id: <20201210085505.21575-1-a@unstable.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The definition of IS_ERR() already applies the unlikely() notation
when checking the error status of the passed pointer. For this
reason there is no need to have the same notation outside of
IS_ERR() itself.

Clean up code by removing redundant notation.

Signed-off-by: Antonio Quartulli <a@unstable.cc>
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
index c33e2c81635f..e9c35130846c 100644
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
2.29.2

