Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025BD49D24E
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244355AbiAZTLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243816AbiAZTLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:11:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC57C06161C;
        Wed, 26 Jan 2022 11:11:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEE8B616CC;
        Wed, 26 Jan 2022 19:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B34C340EE;
        Wed, 26 Jan 2022 19:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643224275;
        bh=BA2e2HnqZ/HYDxnRurH7RJ+YTM+xt7SWekxZOj76Phs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YwoQ6IVgWlR78tEKo2FVMCjSqxj3P/jRmvXetz5ucFGyOw6NeAtxvngtymt1vuILZ
         ZNrHbpPK6kfxSY5qw4jb/E5GmU0vg9ilvcmM4lLhnjUVBYBcg4fw/P8lJVKSqcz3Ph
         vx57VhNH9R+fLVa4lNsij5LxfTIRJNCLMS+4VXnBNI7NvmU+3+/I7TgzfaAmcA7v5e
         sgRW+aLTuTmDG7aSZtNYHy7mvtrtF0toq+i9O/TH5pk4vVGojbannPK8FKp0Ituen5
         oXlqUMt9kSWk3NNI38KfUzy/7mIDHGjWKbjQusDcyG0CwPthvuc4usnmwkeIXUlHoT
         GaAfUS5u5Hl+w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        ralf@linux-mips.org, linux-hams@vger.kernel.org
Subject: [PATCH net-next 06/15] net: ax25: remove route refcount
Date:   Wed, 26 Jan 2022 11:11:00 -0800
Message-Id: <20220126191109.2822706-7-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126191109.2822706-1-kuba@kernel.org>
References: <20220126191109.2822706-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nothing takes the refcount since v4.9.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: ralf@linux-mips.org
CC: linux-hams@vger.kernel.org
---
 include/net/ax25.h    | 12 ------------
 net/ax25/ax25_route.c |  5 ++---
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index 526e49589197..cb628c5d7c5b 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -187,18 +187,12 @@ typedef struct {
 
 typedef struct ax25_route {
 	struct ax25_route	*next;
-	refcount_t		refcount;
 	ax25_address		callsign;
 	struct net_device	*dev;
 	ax25_digi		*digipeat;
 	char			ip_mode;
 } ax25_route;
 
-static inline void ax25_hold_route(ax25_route *ax25_rt)
-{
-	refcount_inc(&ax25_rt->refcount);
-}
-
 void __ax25_put_route(ax25_route *ax25_rt);
 
 extern rwlock_t ax25_route_lock;
@@ -213,12 +207,6 @@ static inline void ax25_route_lock_unuse(void)
 	read_unlock(&ax25_route_lock);
 }
 
-static inline void ax25_put_route(ax25_route *ax25_rt)
-{
-	if (refcount_dec_and_test(&ax25_rt->refcount))
-		__ax25_put_route(ax25_rt);
-}
-
 typedef struct {
 	char			slave;			/* slave_mode?   */
 	struct timer_list	slave_timer;		/* timeout timer */
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index d0b2e094bd55..be97dc6a53cb 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -111,7 +111,6 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 		return -ENOMEM;
 	}
 
-	refcount_set(&ax25_rt->refcount, 1);
 	ax25_rt->callsign     = route->dest_addr;
 	ax25_rt->dev          = ax25_dev->dev;
 	ax25_rt->digipeat     = NULL;
@@ -160,12 +159,12 @@ static int ax25_rt_del(struct ax25_routes_struct *route)
 		    ax25cmp(&route->dest_addr, &s->callsign) == 0) {
 			if (ax25_route_list == s) {
 				ax25_route_list = s->next;
-				ax25_put_route(s);
+				__ax25_put_route(s);
 			} else {
 				for (t = ax25_route_list; t != NULL; t = t->next) {
 					if (t->next == s) {
 						t->next = s->next;
-						ax25_put_route(s);
+						__ax25_put_route(s);
 						break;
 					}
 				}
-- 
2.34.1

