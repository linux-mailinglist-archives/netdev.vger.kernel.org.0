Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7626913A853
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 12:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbgANLXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 06:23:52 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34849 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726053AbgANLXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 06:23:51 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DB48621DC6;
        Tue, 14 Jan 2020 06:23:50 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 14 Jan 2020 06:23:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=niMjvdO5QhBKqMJQ3DOAw6nr9t2lmQieVaGOEY8mFt4=; b=THPmCPUD
        y3o0cw16DCynA2N+s/SSsxXePIKWPRb99KNoIto1XAt//oAuZjv4FyjCvV5lETlK
        mg9KUzWgxmUOt+VAeeRWpAcOMrs27xNg7dtZZs7Dv2VFjDlt+4eua0KIWg8pwP4y
        uzBO7xZmtBtY/4W5TlLNYzqFAiv3WkoKepz5ZFXUnYhd/d4v0RLss7dwVWfxz24q
        WN2kT9ndGlWoDzkcXi1EAC7vLhuKUnfZFtSvavD5QAMk87IgNdyPbPgaInvzAtbD
        LO/wrHGD6HeY2Nvsw/bb5j8xX5jyoBVywblPBhGqVnh41oRfMSHz5YN9qOmhxpGZ
        djdVmgcF7ND6gw==
X-ME-Sender: <xms:xqQdXl0R2BJimZ8sJl4ihUTRcxI80LTLwrx0A02DDxytHmhpp2VbqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtddtgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepfe
X-ME-Proxy: <xmx:xqQdXoJHA69CUOWY6i42sHxR_880NQugYMfXLw7sIDb6Hs_6vYnyAQ>
    <xmx:xqQdXimNvFGuVbV8sXIiADtavxJR68ZSHHt1qr0y6ByUGLUumup97w>
    <xmx:xqQdXpIeEAXuHwkv9xc8TaHTeLdcCeVrI6sRO_caFCS1i8Xe4okL9Q>
    <xmx:xqQdXj8H96WKD0cYsXakR1bw40Q6yWeoIr3noq3Bp9I039Mr-Kfnqg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5166C80061;
        Tue, 14 Jan 2020 06:23:49 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 04/10] ipv6: Add "offload" and "trap" indications to routes
Date:   Tue, 14 Jan 2020 13:23:12 +0200
Message-Id: <20200114112318.876378-5-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114112318.876378-1-idosch@idosch.org>
References: <20200114112318.876378-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

In a similar fashion to previous patch, add "offload" and "trap"
indication to IPv6 routes.

This is done by using two unused bits in 'struct fib6_info' to hold
these indications. Capable drivers are expected to set these when
processing the various in-kernel route notifications.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 include/net/ip6_fib.h | 11 ++++++++++-
 net/ipv6/route.c      |  7 +++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index b579faea41e9..fd60a8ac02ee 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -192,7 +192,9 @@ struct fib6_info {
 					dst_nopolicy:1,
 					dst_host:1,
 					fib6_destroying:1,
-					unused:3;
+					offload:1,
+					trap:1,
+					unused:1;
 
 	struct rcu_head			rcu;
 	struct nexthop			*nh;
@@ -329,6 +331,13 @@ static inline void fib6_info_release(struct fib6_info *f6i)
 		call_rcu(&f6i->rcu, fib6_info_destroy_rcu);
 }
 
+static inline void fib6_info_hw_flags_set(struct fib6_info *f6i, bool offload,
+					  bool trap)
+{
+	f6i->offload = offload;
+	f6i->trap = trap;
+}
+
 enum fib6_walk_state {
 #ifdef CONFIG_IPV6_SUBTREES
 	FWS_S,
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 0253b702afb7..4fbdc60b4e07 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5576,6 +5576,13 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 		expires -= jiffies;
 	}
 
+	if (!dst) {
+		if (rt->offload)
+			rtm->rtm_flags |= RTM_F_OFFLOAD;
+		if (rt->trap)
+			rtm->rtm_flags |= RTM_F_TRAP;
+	}
+
 	if (rtnl_put_cacheinfo(skb, dst, 0, expires, dst ? dst->error : 0) < 0)
 		goto nla_put_failure;
 
-- 
2.24.1

