Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6384A159271
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbgBKPA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:00:56 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:34135 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728073AbgBKPA4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 10:00:56 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 063461ac;
        Tue, 11 Feb 2020 14:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=P9Jcfk0RuYp4b4xyImJ9B/Wl8
        SA=; b=JpoqBIPl89T39vBfmvNKtq2Wi6hh7GTdAU5sumt+GLcFsccAsJl/gwKvs
        iokm69Su3A1kJI94sn767R2EzmWvtwqTvTZyRBwmcSZomMOOS52HCXDzYuMcY/sN
        mKRutzSeZ+zfSm05NibvEYS0TbNQE7myfULd8DGJRdHGojmJ2ywJsb0SzE9mBpxO
        GidQ6Zw/BGcP0LvOaS/0KCRU/Hn7bDK25CFqxojVrywdHgNvtt0XA9GVEqZqDfFi
        LTwlh59kMMjA9RRsm7pthWueMgKp50WZ7b2ZTmTLUJk9yMZz3hP2w7dUEcpfIAj3
        TKvEvJ2roVIeA8nToJ4LUtMZVTZng==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 953adfde (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 11 Feb 2020 14:59:09 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v3 net 5/9] wireguard: device: use icmp_ndo_send helper and remove skb_share_check
Date:   Tue, 11 Feb 2020 16:00:24 +0100
Message-Id: <20200211150028.688073-6-Jason@zx2c4.com>
In-Reply-To: <20200211150028.688073-1-Jason@zx2c4.com>
References: <20200210141423.173790-2-Jason@zx2c4.com>
 <20200211150028.688073-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because wireguard is calling icmp from network device context, it should
use the ndo helper so that the rate limiting applies correctly. Also,
skb_share_check in the xmit path is an impossible condition to reach; an
skb in ndo_start_xmit won't be shared by definition.

This commit adds a small test to the wireguard test suite to ensure that
the new functions continue doing the right thing in the context of
wireguard. It does this by setting up a condition that will definately
evoke an icmp error message from the driver, but along a nat'd path.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://lore.kernel.org/netdev/CAHmME9pk8HEFRq_mBeatNbwXTx7UEfiQ_HG_+Lyz7E+80GmbSA@mail.gmail.com/
---
 drivers/net/wireguard/device.c             |  8 ++------
 tools/testing/selftests/wireguard/netns.sh | 10 ++++++++++
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 16b19824b9ad..62cb7b106c52 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -167,10 +167,6 @@ static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb_list_walk_safe(skb, skb, next) {
 		skb_mark_not_on_list(skb);
 
-		skb = skb_share_check(skb, GFP_ATOMIC);
-		if (unlikely(!skb))
-			continue;
-
 		/* We only need to keep the original dst around for icmp,
 		 * so at this point we're in a position to drop it.
 		 */
@@ -203,9 +199,9 @@ static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
 err:
 	++dev->stats.tx_errors;
 	if (skb->protocol == htons(ETH_P_IP))
-		icmp_send(skb, ICMP_DEST_UNREACH, ICMP_HOST_UNREACH, 0);
+		icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_HOST_UNREACH, 0);
 	else if (skb->protocol == htons(ETH_P_IPV6))
-		icmpv6_send(skb, ICMPV6_DEST_UNREACH, ICMPV6_ADDR_UNREACH, 0);
+		icmpv6_ndo_send(skb, ICMPV6_DEST_UNREACH, ICMPV6_ADDR_UNREACH, 0);
 	kfree_skb(skb);
 	return ret;
 }
diff --git a/tools/testing/selftests/wireguard/netns.sh b/tools/testing/selftests/wireguard/netns.sh
index f5ab1cda8bb5..4e31d5b1bf7f 100755
--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -297,7 +297,17 @@ ip1 -4 rule add table main suppress_prefixlength 0
 n1 ping -W 1 -c 100 -f 192.168.99.7
 n1 ping -W 1 -c 100 -f abab::1111
 
+# Have ns2 NAT into wg0 packets from ns0, but return an icmp error along the right route.
+n2 iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -d 192.168.241.0/24 -j SNAT --to 192.168.241.2
+n0 iptables -t filter -A INPUT \! -s 10.0.0.0/24 -i vethrs -j DROP # Manual rpfilter just to be explicit.
+n2 bash -c 'printf 1 > /proc/sys/net/ipv4/ip_forward'
+ip0 -4 route add 192.168.241.1 via 10.0.0.100
+n2 wg set wg0 peer "$pub1" remove
+[[ $(! n0 ping -W 1 -c 1 192.168.241.1 || false) == *"From 10.0.0.100 icmp_seq=1 Destination Host Unreachable"* ]]
+
 n0 iptables -t nat -F
+n0 iptables -t filter -F
+n2 iptables -t nat -F
 ip0 link del vethrc
 ip0 link del vethrs
 ip1 link del wg0
-- 
2.25.0

