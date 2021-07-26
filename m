Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68EA03D670D
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 21:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbhGZSUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 14:20:19 -0400
Received: from relay.sw.ru ([185.231.240.75]:55148 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232897AbhGZSUG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 14:20:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=AZePevufwLfIw+HZXFzYrAu9HJFcrBqN7a5eGmS+F6o=; b=OCYnI1D+kIDAM3W3PkD
        UygoUhUyuAeVsJ+M3NO3XVRFyjGx+ilOH9LQeObbypVFBER+S7/iCrRqQXjbn1ITehS0p5L+cZhhn
        qp58uUnx8BMfOzhw6DfHe2XmQbjVbv09PzygHK/S93ZiJMv1TjcB0dus+NukMXTAr8X8iUjea48=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m85q5-005JTO-2U; Mon, 26 Jul 2021 22:00:33 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v6 05/16] memcg: ipv6/sit: account and don't WARN on
 ip_tunnel_prl structs allocation
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Roman Gushchin <guro@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <9bf9d9bd-03b1-2adb-17b4-5d59a86a9394@virtuozzo.com>
 <cover.1627321321.git.vvs@virtuozzo.com>
Message-ID: <52f7bed9-a0a1-24ff-2305-ef3224fa4c67@virtuozzo.com>
Date:   Mon, 26 Jul 2021 22:00:31 +0300
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

Author: Andrey Ryabinin <aryabinin@virtuozzo.com>

The size of the ip_tunnel_prl structs allocation is controllable from
user-space, thus it's better to avoid spam in dmesg if allocation failed.
Also add __GFP_ACCOUNT as this is a good candidate for per-memcg
accounting. Allocation is temporary and limited by 4GB.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/ipv6/sit.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index df5bea8..33adc12 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -321,7 +321,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ifreq *ifr)
 	 * we try harder to allocate.
 	 */
 	kp = (cmax <= 1 || capable(CAP_NET_ADMIN)) ?
-		kcalloc(cmax, sizeof(*kp), GFP_KERNEL | __GFP_NOWARN) :
+		kcalloc(cmax, sizeof(*kp), GFP_KERNEL_ACCOUNT | __GFP_NOWARN) :
 		NULL;
 
 	rcu_read_lock();
@@ -334,7 +334,8 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ifreq *ifr)
 		 * For root users, retry allocating enough memory for
 		 * the answer.
 		 */
-		kp = kcalloc(ca, sizeof(*kp), GFP_ATOMIC);
+		kp = kcalloc(ca, sizeof(*kp), GFP_ATOMIC | __GFP_ACCOUNT |
+					      __GFP_NOWARN);
 		if (!kp) {
 			ret = -ENOMEM;
 			goto out;
-- 
1.8.3.1

