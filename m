Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3F43274CE
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 05:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729891AbfEWD2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 23:28:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729679AbfEWD2F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 23:28:05 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9744E217F9;
        Thu, 23 May 2019 03:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558582084;
        bh=aNbcd3v3xByk+cZd78TjUM3n+IgfLeDOBL2LFCwgnA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YP3Bu6YwnBkHpLANOwmNOceb+G4gQGomsXrybsDR/xaytPt+Up3ELBUP3glShNzQD
         z8NOwCe6o8/ULhLwlbU7Uxj+6nXT/hPvAZ4ivPzwsW+VwjW8AJxu8QqQGTGpR+9WNr
         jT4ljA4ZQQhWgHlrM2873FO0eB/S6OX4sHuZMrWY=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     eric.dumazet@gmail.com, idosch@mellanox.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 6/7] ipv6: Refactor ip6_route_del for cached routes
Date:   Wed, 22 May 2019 20:28:00 -0700
Message-Id: <20190523032801.11122-7-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190523032801.11122-1-dsahern@kernel.org>
References: <20190523032801.11122-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Move the removal of cached routes to a helper, ip6_del_cached_rt, that
can be invoked per nexthop. Rename the existig ip6_del_cached_rt to
__ip6_del_cached_rt since it is called by ip6_del_cached_rt.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index f248ce807116..fdf598926883 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3430,7 +3430,7 @@ static int __ip6_del_rt_siblings(struct fib6_info *rt, struct fib6_config *cfg)
 	return err;
 }
 
-static int ip6_del_cached_rt(struct rt6_info *rt, struct fib6_config *cfg)
+static int __ip6_del_cached_rt(struct rt6_info *rt, struct fib6_config *cfg)
 {
 	int rc = -ESRCH;
 
@@ -3446,10 +3446,25 @@ static int ip6_del_cached_rt(struct rt6_info *rt, struct fib6_config *cfg)
 	return rc;
 }
 
+static int ip6_del_cached_rt(struct fib6_config *cfg, struct fib6_info *rt,
+			     struct fib6_nh *nh)
+{
+	struct fib6_result res = {
+		.f6i = rt,
+		.nh = nh,
+	};
+	struct rt6_info *rt_cache;
+
+	rt_cache = rt6_find_cached_rt(&res, &cfg->fc_dst, &cfg->fc_src);
+	if (rt_cache)
+		return __ip6_del_cached_rt(rt_cache, cfg);
+
+	return 0;
+}
+
 static int ip6_route_del(struct fib6_config *cfg,
 			 struct netlink_ext_ack *extack)
 {
-	struct rt6_info *rt_cache;
 	struct fib6_table *table;
 	struct fib6_info *rt;
 	struct fib6_node *fn;
@@ -3474,21 +3489,12 @@ static int ip6_route_del(struct fib6_config *cfg,
 
 			nh = rt->fib6_nh;
 			if (cfg->fc_flags & RTF_CACHE) {
-				struct fib6_result res = {
-					.f6i = rt,
-					.nh = nh,
-				};
 				int rc;
 
-				rt_cache = rt6_find_cached_rt(&res,
-							      &cfg->fc_dst,
-							      &cfg->fc_src);
-				if (rt_cache) {
-					rc = ip6_del_cached_rt(rt_cache, cfg);
-					if (rc != -ESRCH) {
-						rcu_read_unlock();
-						return rc;
-					}
+				rc = ip6_del_cached_rt(cfg, rt, nh);
+				if (rc != -ESRCH) {
+					rcu_read_unlock();
+					return rc;
 				}
 				continue;
 			}
-- 
2.11.0

