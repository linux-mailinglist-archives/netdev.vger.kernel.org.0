Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314993D66FF
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 21:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbhGZSTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 14:19:34 -0400
Received: from relay.sw.ru ([185.231.240.75]:54980 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231640AbhGZSTd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 14:19:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=8P40NsonrJJoThIMYsgSj+KWYiu8Ty9alqCjBkD7j5A=; b=t/Wbc2X6e4hgS6K/esz
        rDRgLQP+44k4Ks3i8TtCrVRYU0P5ktfE/Yc9vT6+0wqF0ZgziueAylfctEJXEJvxTYDVK6qwyZWGr
        OMPEvv8HrnQmso/PYifm+LD7dFR5AaihJ3yStFxz04OgrrZhdYz3eTA1welGVASrj7qsH60MVsE=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m85pY-005JR2-7h; Mon, 26 Jul 2021 22:00:00 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v6 01/16] memcg: enable accounting for net_device and Tx/Rx
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
References: <9bf9d9bd-03b1-2adb-17b4-5d59a86a9394@virtuozzo.com>
 <cover.1627321321.git.vvs@virtuozzo.com>
Message-ID: <d6a9a9f6-0221-01ab-991b-baeeca2bae3d@virtuozzo.com>
Date:   Mon, 26 Jul 2021 21:59:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cover.1627321321.git.vvs@virtuozzo.com>
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

