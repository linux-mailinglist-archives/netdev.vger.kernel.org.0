Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854BB3CD27C
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 12:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236528AbhGSKEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 06:04:05 -0400
Received: from relay.sw.ru ([185.231.240.75]:44520 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235975AbhGSKD7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 06:03:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=5useEdTraDabNukS5dPf+83pq0fTm+yVCCArjRQXtkc=; b=ZF3wupYQ0WUAgiH7K7/
        dig29aXrgdH4SVe8FtsCVpWcJwg2a+CwDwFVrviHd7+tRlaiZiqGSqw1vzwT7AS0mSj15no3AiHQ5
        CgvpAqvNdv1osTD6C27e1lOD1718GUTR88G4oyqCz/suV9CgCL8KwEUCSOt3KGo07ZjUK7x0vk4=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m5QlK-004Rcu-Ex; Mon, 19 Jul 2021 13:44:38 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v5 03/16] memcg: enable accounting for inet_bin_bucket cache
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Roman Gushchin <guro@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
 <cover.1626688654.git.vvs@virtuozzo.com>
Message-ID: <5c328f7f-da1f-7353-a79b-f34c55f863cc@virtuozzo.com>
Date:   Mon, 19 Jul 2021 13:44:37 +0300
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

net namespace can create up to 64K tcp and dccp ports and force kernel
to allocate up to several megabytes of memory per netns
for inet_bind_bucket objects.

It makes sense to account for them to restrict the host's memory
consumption from inside the memcg-limited container.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/dccp/proto.c | 2 +-
 net/ipv4/tcp.c   | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 7eb0fb2..abb5c59 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -1126,7 +1126,7 @@ static int __init dccp_init(void)
 	dccp_hashinfo.bind_bucket_cachep =
 		kmem_cache_create("dccp_bind_bucket",
 				  sizeof(struct inet_bind_bucket), 0,
-				  SLAB_HWCACHE_ALIGN, NULL);
+				  SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, NULL);
 	if (!dccp_hashinfo.bind_bucket_cachep)
 		goto out_free_hashinfo2;
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d5ab5f2..5c0605e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4509,7 +4509,9 @@ void __init tcp_init(void)
 	tcp_hashinfo.bind_bucket_cachep =
 		kmem_cache_create("tcp_bind_bucket",
 				  sizeof(struct inet_bind_bucket), 0,
-				  SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+				  SLAB_HWCACHE_ALIGN | SLAB_PANIC |
+				  SLAB_ACCOUNT,
+				  NULL);
 
 	/* Size and allocate the main established and bind bucket
 	 * hash tables.
-- 
1.8.3.1

