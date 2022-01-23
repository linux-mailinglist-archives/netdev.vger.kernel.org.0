Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4B9496EA1
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 01:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbiAWANZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 19:13:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36920 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235417AbiAWAMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 19:12:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3067160FA2;
        Sun, 23 Jan 2022 00:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBDCC340E5;
        Sun, 23 Jan 2022 00:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896757;
        bh=WXd0m6zcgT7N6TDkAMAEXZcn1LcSqn/7nhcnyZWJ/Gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5fGlwdYFMOuU6OAfqNwLLWlPysuT3HWGcEpFTycNPgRayfS5KWLsf7fUBVpH8aZj
         fo8FxXpBX3nAF0wwX1KB56qupvNJm7K0IhJQfVYOn8uaUQEtyuD+xBPGyXTo0vPzCT
         J5kVGRHQdsaLO7mpqY9pdSvGVNpIowW6UG7aLRW5GZoRQcUTYwHm8bxKgPJocWmENf
         3MUa+lvtWgdfHHDABsQkT8KaMpAkEqww4ri3ZmdVOQQjE/yRXbDSWXkT4hUkWBF5FL
         XwpVFUvlE3KpEkt7kzRe7tHPu1+Vr9lJJLvgT+98SwU8r94zl49VXOIpVYp3y59UNu
         Fmple6+d867SQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ignat Korchagin <ignat@cloudflare.com>,
        Amir Razmjou <arazmjou@cloudflare.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 07/16] sit: allow encapsulated IPv6 traffic to be delivered locally
Date:   Sat, 22 Jan 2022 19:12:06 -0500
Message-Id: <20220123001216.2460383-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001216.2460383-1-sashal@kernel.org>
References: <20220123001216.2460383-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ignat Korchagin <ignat@cloudflare.com>

[ Upstream commit ed6ae5ca437d9d238117d90e95f7f2cc27da1b31 ]

While experimenting with FOU encapsulation Amir noticed that encapsulated IPv6
traffic fails to be delivered, if the peer IP address is configured locally.

It can be easily verified by creating a sit interface like below:

$ sudo ip link add name fou_test type sit remote 127.0.0.1 encap fou encap-sport auto encap-dport 1111
$ sudo ip link set fou_test up

and sending some IPv4 and IPv6 traffic to it

$ ping -I fou_test -c 1 1.1.1.1
$ ping6 -I fou_test -c 1 fe80::d0b0:dfff:fe4c:fcbc

"tcpdump -i any udp dst port 1111" will confirm that only the first IPv4 ping
was encapsulated and attempted to be delivered.

This seems like a limitation: for example, in a cloud environment the "peer"
service may be arbitrarily scheduled on any server within the cluster, where all
nodes are trying to send encapsulated traffic. And the unlucky node will not be
able to. Moreover, delivering encapsulated IPv4 traffic locally is allowed.

But I may not have all the context about this restriction and this code predates
the observable git history.

Reported-by: Amir Razmjou <arazmjou@cloudflare.com>
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220107123842.211335-1-ignat@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/sit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 626cb53aa57ab..a3924dc9dc858 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -956,7 +956,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 		dst_cache_set_ip4(&tunnel->dst_cache, &rt->dst, fl4.saddr);
 	}
 
-	if (rt->rt_type != RTN_UNICAST) {
+	if (rt->rt_type != RTN_UNICAST && rt->rt_type != RTN_LOCAL) {
 		ip_rt_put(rt);
 		dev->stats.tx_carrier_errors++;
 		goto tx_error_icmp;
-- 
2.34.1

