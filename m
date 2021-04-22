Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9F1367EBC
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 12:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235912AbhDVKgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 06:36:45 -0400
Received: from relay.sw.ru ([185.231.240.75]:33262 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235513AbhDVKgn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 06:36:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=uOkZzTEzLDYGvDz2EcEVr3MAZr7Fo0gfzmPbZqUA8K8=; b=IJW2qTrUgmj+QbyXTMS
        sn1XsfjzFp8BDDhkt1pTpTw5KMJeeSLci/BuLsZXus52iIzs3YmodO0VSewya7W8Lwn0MGc8Kh+qD
        rwdqGhv3wCgP4vsIkHDcYkuyejvIn5qT9OGwVGTBs8nk6wGXJvnizglEDtcDBongh8YbhorRn50=
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94)
        (envelope-from <vvs@virtuozzo.com>)
        id 1lZWgo-001AKn-KF; Thu, 22 Apr 2021 13:36:06 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v3 01/16] memcg: enable accounting for net_device and Tx/Rx
 queues
To:     cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
Message-ID: <63329bfe-a000-a450-fdd2-be829aee8762@virtuozzo.com>
Date:   Thu, 22 Apr 2021 13:36:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
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
index 1f79b9a..87b1e80 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9994,7 +9994,7 @@ static int netif_alloc_rx_queues(struct net_device *dev)
 
 	BUG_ON(count < 1);
 
-	rx = kvzalloc(sz, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	rx = kvzalloc(sz, GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL);
 	if (!rx)
 		return -ENOMEM;
 
@@ -10061,7 +10061,7 @@ static int netif_alloc_netdev_queues(struct net_device *dev)
 	if (count < 1 || count > 0xffff)
 		return -EINVAL;
 
-	tx = kvzalloc(sz, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	tx = kvzalloc(sz, GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL);
 	if (!tx)
 		return -ENOMEM;
 
@@ -10693,7 +10693,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	/* ensure 32-byte alignment of whole construct */
 	alloc_size += NETDEV_ALIGN - 1;
 
-	p = kvzalloc(alloc_size, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	p = kvzalloc(alloc_size, GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL);
 	if (!p)
 		return NULL;
 
-- 
1.8.3.1

