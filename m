Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA33F3CD281
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 12:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbhGSKER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 06:04:17 -0400
Received: from relay.sw.ru ([185.231.240.75]:44570 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236536AbhGSKEG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 06:04:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=w+0FNs53pgnmzx96zi7TBJAdHiw/aP1PrzGmhZUmSkE=; b=IO1vcqg4VE8nP6Skqrj
        94WKAjOjSObrDnICD6nbIGI921wjlD0hPgSg20oEXGcgnMqhdIIl27qyTUILZ1YzbCB0Fqs5TEtww
        yDgqt0/G8hFOspvB8rxqfB1CeKRNUSxdee7eEKlrRqEqalNeGtTOZIwDbfxZA3mW7/S7NvPaC/Y=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m5QlR-004Rdb-6R; Mon, 19 Jul 2021 13:44:45 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v5 04/16] memcg: enable accounting for VLAN group array
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
Message-ID: <71acccea-fc9a-13bc-3744-ae5638bd9cc7@virtuozzo.com>
Date:   Mon, 19 Jul 2021 13:44:44 +0300
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

