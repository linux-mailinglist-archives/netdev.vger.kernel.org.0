Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E2B367EC2
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 12:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbhDVKhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 06:37:11 -0400
Received: from relay.sw.ru ([185.231.240.75]:33324 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235957AbhDVKg5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 06:36:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=EhwGW+7oUO0ZGtOX5hqiXU1opkapMpApXMMWDDQ0M7c=; b=U0p9V0y92QqPlPmwyLP
        Ij2mib0oK0Fopw+6pCzjkGd01bK2muRNJQ0AJOKlk1jd/iDErBO8/vKzVWiuN5bOjRjZneqt7C+VC
        7b0zrLguxOJupzEiO3brTalsK9OpA+NFCb51BNjiiW7eG/VUfuTUgdfAWbTWftis5EfLw8deFKA=
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94)
        (envelope-from <vvs@virtuozzo.com>)
        id 1lZWh3-001ALC-Py; Thu, 22 Apr 2021 13:36:21 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v3 03/16] memcg: enable accounting for inet_bin_bucket cache
To:     cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
References: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
Message-ID: <1e65700c-b770-61c3-524e-28a26352843c@virtuozzo.com>
Date:   Thu, 22 Apr 2021 13:36:21 +0300
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
index 6d705d9..f90d1e8 100644
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
index de7cc84..5817a86b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4498,7 +4498,9 @@ void __init tcp_init(void)
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

