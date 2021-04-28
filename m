Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7CB36D278
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 08:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236448AbhD1Gwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 02:52:44 -0400
Received: from relay.sw.ru ([185.231.240.75]:48098 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236270AbhD1Gwo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 02:52:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=EhwGW+7oUO0ZGtOX5hqiXU1opkapMpApXMMWDDQ0M7c=; b=urQ5DYrAw7oWqMIGmyH
        MS2OKrNrYE2BLu0hwPIHFoelQByQksnIMQbef7ggh5gXngNGs22NLLgryJoBsbRqsX9yepTuPHfvF
        5IS6iFWq1gi/FD/e34SV46o6zGPDyQ4octxQRmi+3PcvbF/U+mUwWGb/EocHaI4grEbjoZbK+wk=
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94)
        (envelope-from <vvs@virtuozzo.com>)
        id 1lbe3C-001Vib-Hj; Wed, 28 Apr 2021 09:51:58 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v4 03/16] memcg: enable accounting for inet_bin_bucket cache
To:     cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <8664122a-99d3-7199-869a-781b21b7e712@virtuozzo.com>
Message-ID: <377aea0b-63e7-f30c-6f30-0611067c705b@virtuozzo.com>
Date:   Wed, 28 Apr 2021 09:51:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <8664122a-99d3-7199-869a-781b21b7e712@virtuozzo.com>
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

