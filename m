Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03ED3D6711
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 21:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhGZSUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 14:20:23 -0400
Received: from relay.sw.ru ([185.231.240.75]:55118 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232754AbhGZST6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 14:19:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=w+0FNs53pgnmzx96zi7TBJAdHiw/aP1PrzGmhZUmSkE=; b=kMRAY6JBbUXgmAw9dOW
        EYTUeFdnFpc6mIFKMIiT1BHbhnGqcvbMvhv4GcELknYw+UTxIxAo69Ha9jPl3hEosozXHCSDRTvXS
        Xg1U2IMvsUJ4aZoLEr3f7GlZG8Q0jwdJvb4qMKByFG4H0BZ7TvRZWIRvaP58qknKqpeg+IaEMuQ=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m85px-005JSj-Jm; Mon, 26 Jul 2021 22:00:25 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v6 04/16] memcg: enable accounting for VLAN group array
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
Message-ID: <787536ed-6257-ac73-0ccc-c487f776671b@virtuozzo.com>
Date:   Mon, 26 Jul 2021 22:00:24 +0300
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

vlan array consume up to 8 pages of memory per net device.

It makes sense to account for them to restrict the host's memory
consumption from inside the memcg-limited container.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/8021q/vlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 4cdf841..55275ef 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -67,7 +67,7 @@ static int vlan_group_prealloc_vid(struct vlan_group *vg,
 		return 0;
 
 	size = sizeof(struct net_device *) * VLAN_GROUP_ARRAY_PART_LEN;
-	array = kzalloc(size, GFP_KERNEL);
+	array = kzalloc(size, GFP_KERNEL_ACCOUNT);
 	if (array == NULL)
 		return -ENOBUFS;
 
-- 
1.8.3.1

