Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5952031961
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfFADhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 23:37:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbfFADgW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 23:36:22 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C875B270E2;
        Sat,  1 Jun 2019 03:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559360181;
        bh=R/bJoAS/+NS/0axfdULc/yseVUkLCQLZAMRRarRskJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TcLzXxZGHB+oiWQ6R/7uPm/wwuCBnV+Sa9hqhn+H/RyNMeBd+c/lfnr1ujNuSD8LJ
         f2LemfiZVuGk3Pnct6GD5w5SaQjLU501UiAtGhy/afRqa9Z72vecyd+yUErDjHU6Sx
         TulFg8zbqIYahyJnMjAfJWJNtIbTw69MfQ41uyRI=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     alexei.starovoitov@gmail.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH RFC net-next 10/27] ipv6: Handle all fib6_nh in a nexthop in rt6_device_match
Date:   Fri, 31 May 2019 20:36:01 -0700
Message-Id: <20190601033618.27702-11-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601033618.27702-1-dsahern@kernel.org>
References: <20190601033618.27702-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add a hook in rt6_device_match to handle nexthop struct in a fib6_info.
The new rt6_nh_dev_match uses nexthop_for_each_fib6_nh to walk each
fib6_nh in a nexthop and call __rt6_device_match. On match,
rt6_nh_dev_match returns the fib6_nh and rt6_device_match uses it to
setup fib6_result.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 51cb5cb027ae..f15ba228beed 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -494,6 +494,45 @@ static bool __rt6_device_match(struct net *net, const struct fib6_nh *nh,
 	return false;
 }
 
+struct fib6_nh_dm_arg {
+	struct net		*net;
+	const struct in6_addr	*saddr;
+	int			oif;
+	int			flags;
+	struct fib6_nh		*nh;
+};
+
+static int __rt6_nh_dev_match(struct fib6_nh *nh, void *_arg)
+{
+	struct fib6_nh_dm_arg *arg = _arg;
+
+	arg->nh = nh;
+	return __rt6_device_match(arg->net, nh, arg->saddr, arg->oif,
+				  arg->flags);
+}
+
+/* returns fib6_nh from nexthop or NULL */
+static struct fib6_nh *rt6_nh_dev_match(struct net *net, struct nexthop *nh,
+					struct fib6_result *res,
+					const struct in6_addr *saddr,
+					int oif, int flags)
+{
+	struct fib6_nh_dm_arg arg = {
+		.net   = net,
+		.saddr = saddr,
+		.oif   = oif,
+		.flags = flags,
+	};
+
+	if (nexthop_is_blackhole(nh))
+		return NULL;
+
+	if (nexthop_for_each_fib6_nh(nh, __rt6_nh_dev_match, &arg))
+		return arg.nh;
+
+	return NULL;
+}
+
 static void rt6_device_match(struct net *net, struct fib6_result *res,
 			     const struct in6_addr *saddr, int oif, int flags)
 {
@@ -514,8 +553,19 @@ static void rt6_device_match(struct net *net, struct fib6_result *res,
 	}
 
 	for (spf6i = f6i; spf6i; spf6i = rcu_dereference(spf6i->fib6_next)) {
-		nh = spf6i->fib6_nh;
-		if (__rt6_device_match(net, nh, saddr, oif, flags)) {
+		bool matched = false;
+
+		if (unlikely(spf6i->nh)) {
+			nh = rt6_nh_dev_match(net, spf6i->nh, res, saddr,
+					      oif, flags);
+			if (nh)
+				matched = true;
+		} else {
+			nh = spf6i->fib6_nh;
+			if (__rt6_device_match(net, nh, saddr, oif, flags))
+				matched = true;
+		}
+		if (matched) {
 			res->f6i = spf6i;
 			goto out;
 		}
-- 
2.11.0

