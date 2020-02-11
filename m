Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61FBD159A06
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 20:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731124AbgBKTrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 14:47:37 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:52685 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731108AbgBKTre (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 14:47:34 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 69e48d18;
        Tue, 11 Feb 2020 19:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=Y+hV0WUS8UMO6USWQpk1nhjSX
        XA=; b=v889WBPm1nzWavrkXjzlxPc+lOd1usdRf2SGkCefa/++XwoeSJAUaIacN
        6ZZvDhOWGyhylPRQQ8Lpu65JmeDiLLEBn9THmjm7ksx6NomrXGFHyQ6wHknI2Nml
        ZS3r9Ib98JskZCsYIn/Tz6sd/185Ba2uBIHzXuDNMQvTtn75Yz7G2t6cnUmqhMCv
        KAPbrwLIOmx/xZcG9DoXccU/dOefxUA8rZDfYlZIzqFl7JVogBhHztMduJLEWZKc
        Bw8/qCDAy0+HIKYOYxpukpc8CtCF/C1RIUaldgPb1+CkOAJcGZZAAVrPBb9n+hUQ
        G0xgwqTfEnctOWO/7u0Z0U+hkPGKw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 20cf6139 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 11 Feb 2020 19:45:46 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v4 net 4/5] wireguard: device: use icmp_ndo_send helper
Date:   Tue, 11 Feb 2020 20:47:08 +0100
Message-Id: <20200211194709.723383-5-Jason@zx2c4.com>
In-Reply-To: <20200211194709.723383-1-Jason@zx2c4.com>
References: <20200211194709.723383-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because wireguard is calling icmp from network device context, it should
use the ndo helper so that the rate limiting applies correctly.  This
commit adds a small test to the wireguard test suite to ensure that the
new functions continue doing the right thing in the context of
wireguard. It does this by setting up a condition that will definately
evoke an icmp error message from the driver, but along a nat'd path.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/device.c             |  4 ++--
 tools/testing/selftests/wireguard/netns.sh | 11 +++++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 16b19824b9ad..43db442b1373 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -203,9 +203,9 @@ static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
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
index f5ab1cda8bb5..138d46b3f330 100755
--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -24,6 +24,7 @@
 set -e
 
 exec 3>&1
+export LANG=C
 export WG_HIDE_KEYS=never
 netns0="wg-test-$$-0"
 netns1="wg-test-$$-1"
@@ -297,7 +298,17 @@ ip1 -4 rule add table main suppress_prefixlength 0
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

