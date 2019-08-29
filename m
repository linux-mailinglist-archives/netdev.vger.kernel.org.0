Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D5AA1743
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 12:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbfH2KyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 06:54:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728122AbfH2Kug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 06:50:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC8B923426;
        Thu, 29 Aug 2019 10:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567075835;
        bh=8kno17t5G0+IQF9Amfj1SsO5zRRh4PZmqZoEBgEN3Kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wA9IY1BT1HHoYYGelF785HIQ0hMnu1SgT169GKQsPrO3xEgG/mjihlKKpMbZ9hMa8
         0UWPGNXk/Hw9dW3M104PfJBIMa8oIzaVwPMGjzuGO6xn6fPaznnb1gj0mCKOdtwuZY
         pNCyb6pyCBwKc2Plpz0isJMk3YA0fL122TUKj1go=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>, Chen Yi <yiche@redhat.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 22/29] netfilter: ipset: Copy the right MAC address in bitmap:ip,mac and hash:ip,mac sets
Date:   Thu, 29 Aug 2019 06:50:02 -0400
Message-Id: <20190829105009.2265-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829105009.2265-1-sashal@kernel.org>
References: <20190829105009.2265-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

[ Upstream commit 1b4a75108d5bc153daf965d334e77e8e94534f96 ]

In commit 8cc4ccf58379 ("ipset: Allow matching on destination MAC address
for mac and ipmac sets"), ipset.git commit 1543514c46a7, I added to the
KADT functions for sets matching on MAC addreses the copy of source or
destination MAC address depending on the configured match.

This was done correctly for hash:mac, but for hash:ip,mac and
bitmap:ip,mac, copying and pasting the same code block presents an
obvious problem: in these two set types, the MAC address is the second
dimension, not the first one, and we are actually selecting the MAC
address depending on whether the first dimension (IP address) specifies
source or destination.

Fix this by checking for the IPSET_DIM_TWO_SRC flag in option flags.

This way, mixing source and destination matches for the two dimensions
of ip,mac set types works as expected. With this setup:

  ip netns add A
  ip link add veth1 type veth peer name veth2 netns A
  ip addr add 192.0.2.1/24 dev veth1
  ip -net A addr add 192.0.2.2/24 dev veth2
  ip link set veth1 up
  ip -net A link set veth2 up

  dst=$(ip netns exec A cat /sys/class/net/veth2/address)

  ip netns exec A ipset create test_bitmap bitmap:ip,mac range 192.0.0.0/16
  ip netns exec A ipset add test_bitmap 192.0.2.1,${dst}
  ip netns exec A iptables -A INPUT -m set ! --match-set test_bitmap src,dst -j DROP

  ip netns exec A ipset create test_hash hash:ip,mac
  ip netns exec A ipset add test_hash 192.0.2.1,${dst}
  ip netns exec A iptables -A INPUT -m set ! --match-set test_hash src,dst -j DROP

ipset correctly matches a test packet:

  # ping -c1 192.0.2.2 >/dev/null
  # echo $?
  0

Reported-by: Chen Yi <yiche@redhat.com>
Fixes: 8cc4ccf58379 ("ipset: Allow matching on destination MAC address for mac and ipmac sets")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 2 +-
 net/netfilter/ipset/ip_set_hash_ipmac.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 13ade5782847b..4f01321e793ce 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -230,7 +230,7 @@ bitmap_ipmac_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 	e.id = ip_to_id(map, ip);
 
-	if (opt->flags & IPSET_DIM_ONE_SRC)
+	if (opt->flags & IPSET_DIM_TWO_SRC)
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_source);
 	else
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_dest);
diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipset/ip_set_hash_ipmac.c
index 75c21c8b76514..16ec822e40447 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -99,7 +99,7 @@ hash_ipmac4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	    (skb_mac_header(skb) + ETH_HLEN) > skb->data)
 		return -EINVAL;
 
-	if (opt->flags & IPSET_DIM_ONE_SRC)
+	if (opt->flags & IPSET_DIM_TWO_SRC)
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_source);
 	else
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_dest);
-- 
2.20.1

