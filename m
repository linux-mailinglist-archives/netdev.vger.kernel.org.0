Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0232B20BA14
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 22:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgFZUOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 16:14:31 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:54259 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgFZUOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 16:14:31 -0400
Received: from kiste.fritz.box ([88.130.61.76]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MderZ-1jG81J2sNd-00Zfqw; Fri, 26 Jun 2020 22:14:24 +0200
From:   Hans Wippel <ndev@hwipl.net>
To:     "Jason A . Donenfeld" <Jason@zx2c4.com>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org
Cc:     Hans Wippel <ndev@hwipl.net>
Subject: wireguard: problem sending via libpcap's packet socket
Date:   Fri, 26 Jun 2020 22:13:30 +0200
Message-Id: <20200626201330.325840-1-ndev@hwipl.net>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:+NUI8ZsHCdMlmrdMoTpnkm9Tp59Rc99XH431g1+zqt8bqv5z3Ni
 W1SZxzx5cgjFuXwJkzWs6EeBDFceGPOeS9cjeFdDRs50KlhzU6Iv4ZytRQpDjlpDrAJXeJQ
 hwC0ijHvlVckmOQUWpfJPVR+Li1cWmoiBsSgwEGTQhCtdijN8ZCxGNW3tm/d2yng0YFloP5
 9oX5SLDMkqByuvefrBzFQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:e9WWx370YBw=:XYj8nRBR3JKiCvaFs7cGde
 GfiklhIQ0Q/wyIweKwYueth2AJ3gJfej9UhS52x5eo+BbqPr98ufQ29xzApGQ0DEXFWLvMqag
 jhzTZgtNWXCTvypXnp+F7+jrqXq5RHdINx7lxIBiEVQU89EmtvWFi5UPZlRYnkwCcrHcwSyq+
 cAw4gP3GBpC7KCbNWd7jPHwyJMBOOF4eMPFIBnpgybv0reUBOqkqtDtKyUiESOlouVuBvhUV6
 Gzg271QGIjDEfD25iJhucB/KZCZABbeplimvnliD9N379I/KauhDmbAXoNlIrUQTHd5a5OCG/
 +iMmvCpTAX8nA+fzdU/+niMDGJ9xEbLSwjjXYzc1IBRMR0QbXHYK/tN0im1LtHHe587wnRgOY
 v56H/UwM+PTTwcVT4Oo9vls5SNZ+SQPXtGEBCk85GLDjtLq1KXduGz34XKrAAy17+2KakmF6E
 tJjIOhZizKoMuvYxWAYiL37aStXhWpZSqZFw7lQnyhW/XVQoiwuqpiZrax3S9DCJ1JCEIyoH1
 zVTeUFtnbBehty1KkNO4GovlDFNoOO8QgHZGcRKp5XBEAvB6ONN+IEXPdLQpo7qAAdlsJeL0r
 vOHWmRoe/mhXcVcNAQKqLBTaA2Y9COVuen2H60vNZiTaKAP8A9hiXLwlSybyQe2CBlytkX+df
 wxgekzPCuCipTzx2XAqH4nueUtecw5IMjRPP0SCX06ShhWwOUV5IIlEu8AbLBdg59qHfsyLwD
 m9D8lcBLfLBLRWIvhuHwX1oH6VbH8MDxjkz7khI4poOox6VwavQt7cLke9VnleSCrqmnhZBbe
 9INIWFN8MIWV6VQXSdVxDdk8T4cSN2hEXKkYri9XTiwjzQuo8DedZ6DmsE2pYrCmc4Coknl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

while toying around with sending packets with libpcap, I noticed that it
did not work with a wireguard interface in contrast to my regular
ethernet interface.

It seems like libpcap does not set a protocol on the packet socket and
the following checks

  "skb->protocol == real_protocol",
  "skb->protocol == htons(ETH_P_IP)" and
  "skb->protocol == htons(ETH_P_IPV6)"

in the functions

  wg_check_packet_protocol(),
  wg_xmit() and
  wg_allowedips_lookup_dst()

fail because skb->protocol is 0.

Is this intended behaviour? Should these checks be changed in the kernel
or should this rather be reported to libpcap? Just in case, you can find
changes that made it work for me below (probably not the best solution).

Again, if this is not the right place to ask, just let me know and I am
sorry for the noise.
  Hans

Signed-off-by: Hans Wippel <ndev@hwipl.net>
---
 drivers/net/wireguard/allowedips.c | 5 +++--
 drivers/net/wireguard/device.c     | 4 ++--
 drivers/net/wireguard/queueing.h   | 3 ++-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
index 3725e9cd85f4..08e16907fde5 100644
--- a/drivers/net/wireguard/allowedips.c
+++ b/drivers/net/wireguard/allowedips.c
@@ -5,6 +5,7 @@
 
 #include "allowedips.h"
 #include "peer.h"
+#include "queueing.h"
 
 static void swap_endian(u8 *dst, const u8 *src, u8 bits)
 {
@@ -356,9 +357,9 @@ int wg_allowedips_read_node(struct allowedips_node *node, u8 ip[16], u8 *cidr)
 struct wg_peer *wg_allowedips_lookup_dst(struct allowedips *table,
 					 struct sk_buff *skb)
 {
-	if (skb->protocol == htons(ETH_P_IP))
+	if (wg_examine_packet_protocol(skb) == htons(ETH_P_IP))
 		return lookup(table->root4, 32, &ip_hdr(skb)->daddr);
-	else if (skb->protocol == htons(ETH_P_IPV6))
+	else if (wg_examine_packet_protocol(skb) == htons(ETH_P_IPV6))
 		return lookup(table->root6, 128, &ipv6_hdr(skb)->daddr);
 	return NULL;
 }
diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index a8f151b1b5fa..baed429b2ed1 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -132,10 +132,10 @@ static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
 	peer = wg_allowedips_lookup_dst(&wg->peer_allowedips, skb);
 	if (unlikely(!peer)) {
 		ret = -ENOKEY;
-		if (skb->protocol == htons(ETH_P_IP))
+		if (wg_examine_packet_protocol(skb) == htons(ETH_P_IP))
 			net_dbg_ratelimited("%s: No peer has allowed IPs matching %pI4\n",
 					    dev->name, &ip_hdr(skb)->daddr);
-		else if (skb->protocol == htons(ETH_P_IPV6))
+		else if (wg_examine_packet_protocol(skb) == htons(ETH_P_IPV6))
 			net_dbg_ratelimited("%s: No peer has allowed IPs matching %pI6\n",
 					    dev->name, &ipv6_hdr(skb)->daddr);
 		goto err;
diff --git a/drivers/net/wireguard/queueing.h b/drivers/net/wireguard/queueing.h
index c58df439dbbe..36badcf8a11d 100644
--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -84,7 +84,8 @@ static inline __be16 wg_examine_packet_protocol(struct sk_buff *skb)
 static inline bool wg_check_packet_protocol(struct sk_buff *skb)
 {
 	__be16 real_protocol = wg_examine_packet_protocol(skb);
-	return real_protocol && skb->protocol == real_protocol;
+	return real_protocol == htons(ETH_P_IP) ||
+		real_protocol == htons(ETH_P_IPV6);
 }
 
 static inline void wg_reset_packet(struct sk_buff *skb, bool encapsulating)
-- 
2.27.0

