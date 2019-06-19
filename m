Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9951D4C446
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 02:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730872AbfFTAAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 20:00:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58480 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbfFTAAV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 20:00:21 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7527DC18B2E5;
        Thu, 20 Jun 2019 00:00:20 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F77319C5B;
        Thu, 20 Jun 2019 00:00:17 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v6 03/11] ipv4/route: Allow NULL flowinfo in rt_fill_info()
Date:   Thu, 20 Jun 2019 01:59:43 +0200
Message-Id: <5ba00822d7e86cdcb9231b39fda3cc4a04e2836f.1560987611.git.sbrivio@redhat.com>
In-Reply-To: <cover.1560987611.git.sbrivio@redhat.com>
References: <cover.1560987611.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 20 Jun 2019 00:00:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the next patch, we're going to use rt_fill_info() to dump exception
routes upon RTM_GETROUTE with NLM_F_ROOT, meaning userspace is requesting
a dump and not a specific route selection, which in turn implies the input
interface is not relevant. Update rt_fill_info() to handle a NULL
flowinfo.

Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
v6: New patch

 net/ipv4/route.c | 57 ++++++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 26 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 66cbe8a7a168..052a80373b1d 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2699,7 +2699,8 @@ static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
 	r->rtm_family	 = AF_INET;
 	r->rtm_dst_len	= 32;
 	r->rtm_src_len	= 0;
-	r->rtm_tos	= fl4->flowi4_tos;
+	if (fl4)
+		r->rtm_tos	= fl4->flowi4_tos;
 	r->rtm_table	= table_id < 256 ? table_id : RT_TABLE_COMPAT;
 	if (nla_put_u32(skb, RTA_TABLE, table_id))
 		goto nla_put_failure;
@@ -2727,7 +2728,7 @@ static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
 	    nla_put_u32(skb, RTA_FLOW, rt->dst.tclassid))
 		goto nla_put_failure;
 #endif
-	if (!rt_is_input_route(rt) &&
+	if (fl4 && !rt_is_input_route(rt) &&
 	    fl4->saddr != src) {
 		if (nla_put_in_addr(skb, RTA_PREFSRC, fl4->saddr))
 			goto nla_put_failure;
@@ -2767,36 +2768,40 @@ static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
 	if (rtnetlink_put_metrics(skb, metrics) < 0)
 		goto nla_put_failure;
 
-	if (fl4->flowi4_mark &&
-	    nla_put_u32(skb, RTA_MARK, fl4->flowi4_mark))
-		goto nla_put_failure;
-
-	if (!uid_eq(fl4->flowi4_uid, INVALID_UID) &&
-	    nla_put_u32(skb, RTA_UID,
-			from_kuid_munged(current_user_ns(), fl4->flowi4_uid)))
-		goto nla_put_failure;
+	if (fl4) {
+		if (fl4->flowi4_mark &&
+		    nla_put_u32(skb, RTA_MARK, fl4->flowi4_mark))
+			goto nla_put_failure;
 
-	error = rt->dst.error;
+		if (!uid_eq(fl4->flowi4_uid, INVALID_UID) &&
+		    nla_put_u32(skb, RTA_UID,
+				from_kuid_munged(current_user_ns(),
+						 fl4->flowi4_uid)))
+			goto nla_put_failure;
 
-	if (rt_is_input_route(rt)) {
+		if (rt_is_input_route(rt)) {
 #ifdef CONFIG_IP_MROUTE
-		if (ipv4_is_multicast(dst) && !ipv4_is_local_multicast(dst) &&
-		    IPV4_DEVCONF_ALL(net, MC_FORWARDING)) {
-			int err = ipmr_get_route(net, skb,
-						 fl4->saddr, fl4->daddr,
-						 r, portid);
-
-			if (err <= 0) {
-				if (err == 0)
-					return 0;
-				goto nla_put_failure;
-			}
-		} else
+			if (ipv4_is_multicast(dst) &&
+			    !ipv4_is_local_multicast(dst) &&
+			    IPV4_DEVCONF_ALL(net, MC_FORWARDING)) {
+				int err = ipmr_get_route(net, skb,
+							 fl4->saddr, fl4->daddr,
+							 r, portid);
+
+				if (err <= 0) {
+					if (err == 0)
+						return 0;
+					goto nla_put_failure;
+				}
+			} else
 #endif
-			if (nla_put_u32(skb, RTA_IIF, fl4->flowi4_iif))
-				goto nla_put_failure;
+				if (nla_put_u32(skb, RTA_IIF, fl4->flowi4_iif))
+					goto nla_put_failure;
+		}
 	}
 
+	error = rt->dst.error;
+
 	if (rtnl_put_cacheinfo(skb, &rt->dst, 0, expires, error) < 0)
 		goto nla_put_failure;
 
-- 
2.20.1

