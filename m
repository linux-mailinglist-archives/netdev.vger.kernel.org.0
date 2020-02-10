Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFC7158391
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 20:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbgBJTaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 14:30:11 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:39921 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727029AbgBJTaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 14:30:10 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id e19eca6f;
        Mon, 10 Feb 2020 19:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=tPApO6i+zldL+F05ZjvxlsXOB
        4I=; b=vENkfId5DGuP3ywatALaA9YOWu71A36RVpWK/iFObW4nJ2yt6Bu8p6Qxu
        sIqU9HU5Ds3J7gJrBUCvOpAYsoXW4Wwj6yT48Oi32wL1NT36eOoT5dvaVzp6ZUKi
        c9OiX+whQq+SRe9A6/UvadZm05sREwtMF+aLUmXptwene2r3YYFhsfKiaHxJiw3c
        irLxzJRViyDSIwjOT2/F4DqAYc5n+LRjXGZNjIMjbJNSIn//ZksyDsFGmsLChu7W
        cNomUx6smKRHPx/Ks4hfQZa8MjBt9n2hDVOoyhhWUW1jo5HjwibiiHC81jTgQxA2
        1sFr72BiID8OLxVO88d8e4j630fhw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4eb8ccee (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 10 Feb 2020 19:28:31 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v2 net 6/5] wireguard: selftests: ensure that icmp src address is correct with NAT
Date:   Mon, 10 Feb 2020 20:30:00 +0100
Message-Id: <20200210193000.453727-1-Jason@zx2c4.com>
In-Reply-To: <20200210141423.173790-1-Jason@zx2c4.com>
References: <20200210141423.173790-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a small test to ensure that icmp_ndo_send is actually doing the
right with with regards to the source address. It measure this by
ensuring that there are a sufficient number of non-errors returned in a
row, which should be impossible with proper rate limiting.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
Here's a test for the WireGuard path of the series I submitted earlier
today. This test correctly fails when using the old code, and succeeds
when using the new code. If the "6/5" stupidity disrupts patchwork, no
need to respond, and I'll just resubmit this later.

 tools/testing/selftests/wireguard/netns.sh | 10 ++++++++++
 1 file changed, 10 insertions(+)

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

