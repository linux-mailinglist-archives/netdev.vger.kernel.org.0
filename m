Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54A1F3A24B
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 00:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbfFHWW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 18:22:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727807AbfFHWWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 18:22:24 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 318C9216FD;
        Sat,  8 Jun 2019 21:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560030824;
        bh=5MuoLP/mWrU35wqrSVug4h02FTODHdANMN2VmmdAzws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1XKXO/k5vGb6Nm1xDywL92D7BVyzj6V7ErIwSlMIfNyp3qKqUb15YAd7N6YwRkyko
         MNcYXLjph5n4UQarEjpOwyaS0MiU5oRfC43dDE6WsOVdkWJQ3hNqZv+W5nkWCDFn0B
         feenzc6AHfllxpglk43HGljbaeOtO3oWmV1iiSX4=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v4 net-next 03/20] ipv6: Handle all fib6_nh in a nexthop in rt6_device_match
Date:   Sat,  8 Jun 2019 14:53:24 -0700
Message-Id: <20190608215341.26592-4-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190608215341.26592-1-dsahern@kernel.org>
References: <20190608215341.26592-1-dsahern@kernel.org>
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
index fd0dc18ec574..aac209381903 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -490,6 +490,45 @@ static bool __rt6_device_match(struct net *net, const struct fib6_nh *nh,
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
@@ -510,8 +549,19 @@ static void rt6_device_match(struct net *net, struct fib6_result *res,
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

