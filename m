Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB4926A88
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbfEVTHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:07:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728761AbfEVTHq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:07:46 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4165820868;
        Wed, 22 May 2019 19:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552065;
        bh=qbi4NVyh48owbMZMzm7pmrmwfREtXZKWolCJwh2u6t0=;
        h=From:To:Cc:Subject:Date:From;
        b=Rx4PQ/8wgNP1s/wr7e/wMIsMOhmu4gbszgR1CbQvG6gNbV6YkoHtLXwgK6W8zEwGz
         YCoR+4d4po0AGo0+bB5K11x7nGvYCJ1DzrDPYmLZcb998Y0EaNGfReUzhNwQmaW+Dd
         yIpkrhYYvmq/dGwI32ISGPbVUvz7FF52k9cI8uDE=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next] net: Set strict_start_type for routes and rules
Date:   Wed, 22 May 2019 12:07:43 -0700
Message-Id: <20190522190743.15583-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

New userspace on an older kernel can send unknown and unsupported
attributes resulting in an incompelete config which is almost
always wrong for routing (few exceptions are passthrough settings
like the protocol that installed the route).

Set strict_start_type in the policies for IPv4 and IPv6 routes and
rules to detect new, unsupported attributes and fail the route add.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/fib_rules.h | 1 +
 net/ipv4/fib_frontend.c | 1 +
 net/ipv6/route.c        | 1 +
 3 files changed, 3 insertions(+)

diff --git a/include/net/fib_rules.h b/include/net/fib_rules.h
index b473df5b9512..eba8465e1d86 100644
--- a/include/net/fib_rules.h
+++ b/include/net/fib_rules.h
@@ -103,6 +103,7 @@ struct fib_rule_notifier_info {
 };
 
 #define FRA_GENERIC_POLICY \
+	[FRA_UNSPEC]	= { .strict_start_type = FRA_DPORT_RANGE + 1 }, \
 	[FRA_IIFNAME]	= { .type = NLA_STRING, .len = IFNAMSIZ - 1 }, \
 	[FRA_OIFNAME]	= { .type = NLA_STRING, .len = IFNAMSIZ - 1 }, \
 	[FRA_PRIORITY]	= { .type = NLA_U32 }, \
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index b298255f6fdb..7325c0265c5b 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -645,6 +645,7 @@ int ip_rt_ioctl(struct net *net, unsigned int cmd, struct rtentry *rt)
 }
 
 const struct nla_policy rtm_ipv4_policy[RTA_MAX + 1] = {
+	[RTA_UNSPEC]		= { .strict_start_type = RTA_DPORT + 1 },
 	[RTA_DST]		= { .type = NLA_U32 },
 	[RTA_SRC]		= { .type = NLA_U32 },
 	[RTA_IIF]		= { .type = NLA_U32 },
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 7a014ca877ed..c302a3832582 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4221,6 +4221,7 @@ void rt6_mtu_change(struct net_device *dev, unsigned int mtu)
 }
 
 static const struct nla_policy rtm_ipv6_policy[RTA_MAX+1] = {
+	[RTA_UNSPEC]		= { .strict_start_type = RTA_DPORT + 1 },
 	[RTA_GATEWAY]           = { .len = sizeof(struct in6_addr) },
 	[RTA_PREFSRC]		= { .len = sizeof(struct in6_addr) },
 	[RTA_OIF]               = { .type = NLA_U32 },
-- 
2.11.0

