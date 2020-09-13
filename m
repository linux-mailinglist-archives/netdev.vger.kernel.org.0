Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2212680D8
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 20:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgIMSnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 14:43:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbgIMSnl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Sep 2020 14:43:41 -0400
Received: from Davids-MacBook-Pro.local.net (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 835FC2223E;
        Sun, 13 Sep 2020 18:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600022620;
        bh=iibIW1OnRugOXQZpnNTWIqR3nlrzxr/VJtN/uzkYp0k=;
        h=From:To:Cc:Subject:Date:From;
        b=ddxNsN0AV4LFEeCeVlzBnWnAQYhgF34jpX9SBOwISPwbJYprCbQ+dWVBx+uVUNy9n
         XJjuBeokCd2fXKyfqu3RnJe9bYZPpWpQ6ujeT8mE8r9IjU6+5SXaEj8sEdX2FNHoFl
         oMzJ5ONG8mgp9rfKD3YMIPZzfdf63vdSoUWJU8vI=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        David Ahern <dsahern@gmail.com>, wenxu <wenxu@ucloud.cn>
Subject: [PATCH net] ipv4: Initialize flowi4_multipath_hash in data path
Date:   Sun, 13 Sep 2020 12:43:39 -0600
Message-Id: <20200913184339.35927-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

flowi4_multipath_hash was added by the commit referenced below for
tunnels. Unfortunately, the patch did not initialize the new field
for several fast path lookups that do not initialize the entire flow
struct to 0. Fix those locations. Currently, flowi4_multipath_hash
is random garbage and affects the hash value computed by
fib_multipath_hash for multipath selection.

Fixes: 24ba14406c5c ("route: Add multipath_hash in flowi_common to make user-define hash")
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: wenxu <wenxu@ucloud.cn>
---
 include/net/flow.h      | 1 +
 net/core/filter.c       | 1 +
 net/ipv4/fib_frontend.c | 1 +
 net/ipv4/route.c        | 1 +
 4 files changed, 4 insertions(+)

diff --git a/include/net/flow.h b/include/net/flow.h
index 929d3ca614d0..b2531df3f65f 100644
--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -116,6 +116,7 @@ static inline void flowi4_init_output(struct flowi4 *fl4, int oif,
 	fl4->saddr = saddr;
 	fl4->fl4_dport = dport;
 	fl4->fl4_sport = sport;
+	fl4->flowi4_multipath_hash = 0;
 }
 
 /* Reset some input parameters after previous lookup */
diff --git a/net/core/filter.c b/net/core/filter.c
index 1f647ab986b6..1b168371ba96 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4838,6 +4838,7 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 	fl4.saddr = params->ipv4_src;
 	fl4.fl4_sport = params->sport;
 	fl4.fl4_dport = params->dport;
+	fl4.flowi4_multipath_hash = 0;
 
 	if (flags & BPF_FIB_LOOKUP_DIRECT) {
 		u32 tbid = l3mdev_fib_table_rcu(dev) ? : RT_TABLE_MAIN;
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 41079490a118..86a23e4a6a50 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -362,6 +362,7 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
 	fl4.flowi4_tun_key.tun_id = 0;
 	fl4.flowi4_flags = 0;
 	fl4.flowi4_uid = sock_net_uid(net, NULL);
+	fl4.flowi4_multipath_hash = 0;
 
 	no_addr = idev->ifa_list == NULL;
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 8ca6bcab7b03..e5f210d00851 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2147,6 +2147,7 @@ static int ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	fl4.daddr = daddr;
 	fl4.saddr = saddr;
 	fl4.flowi4_uid = sock_net_uid(net, NULL);
+	fl4.flowi4_multipath_hash = 0;
 
 	if (fib4_rules_early_flow_dissect(net, skb, &fl4, &_flkeys)) {
 		flkeys = &_flkeys;
-- 
2.24.3 (Apple Git-128)

