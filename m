Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAB33CD271
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 12:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236405AbhGSKDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 06:03:46 -0400
Received: from relay.sw.ru ([185.231.240.75]:44452 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235975AbhGSKDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 06:03:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=8P40NsonrJJoThIMYsgSj+KWYiu8Ty9alqCjBkD7j5A=; b=f9Z1kwEDWNzPRNss7dE
        WgQStUzvvT0CjE8M212YgRmDz+3KjPu6OxrWl+TO2NDSb2GLiZodgGlwkLcuj+5U1NXAgmBalYm62
        UUzmwfFluTkElpcL5s0chxLSDibBq28ouLJC/Rtbo8BN+Uu3+IfpAaY+RfQ8wfxUf2nXr4t9FFA=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m5Ql6-004Rc9-59; Mon, 19 Jul 2021 13:44:24 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v5 01/16] memcg: enable accounting for net_device and Tx/Rx
 queues
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Roman Gushchin <guro@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
 <cover.1626688654.git.vvs@virtuozzo.com>
Message-ID: <a5f14f0c-f2db-5c62-b3dc-8bb152fddd40@virtuozzo.com>
Date:   Mon, 19 Jul 2021 13:44:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cover.1626688654.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Container netadmin can create a lot of fake net devices,
then create a new net namespace and repeat it again and again.
Net device can request the creation of up to 4096 tx and rx queues,
and force kernel to allocate up to several tens of megabytes memory
per net device.

It makes sense to account for them to restrict the host's memory
consumption from inside the memcg-limited container.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/core/dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index c253c2a..e9aa1e4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10100,7 +10100,7 @@ static int netif_alloc_rx_queues(struct net_device *dev)
 
 	BUG_ON(count < 1);
 
-	rx = kvzalloc(sz, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	rx = kvzalloc(sz, GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL);
 	if (!rx)
 		return -ENOMEM;
 
@@ -10167,7 +10167,7 @@ static int netif_alloc_netdev_queues(struct net_device *dev)
 	if (count < 1 || count > 0xffff)
 		return -EINVAL;
 
-	tx = kvzalloc(sz, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	tx = kvzalloc(sz, GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL);
 	if (!tx)
 		return -ENOMEM;
 
@@ -10807,7 +10807,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	/* ensure 32-byte alignment of whole construct */
 	alloc_size += NETDEV_ALIGN - 1;
 
-	p = kvzalloc(alloc_size, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	p = kvzalloc(alloc_size, GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL);
 	if (!p)
 		return NULL;
 
-- 
1.8.3.1

