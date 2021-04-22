Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2500367EC7
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 12:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbhDVKhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 06:37:20 -0400
Received: from relay.sw.ru ([185.231.240.75]:33424 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235998AbhDVKhQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 06:37:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=g4kPPij7yw/SNe+T6KcFKxDI8sjPhlS263iU2VL1Y74=; b=BZPkBqyT53/99DufxDE
        TYVeyViV37StggjdRlsUiG9OLi+M31kDNcoAjueC6/k4YUIWCGifONDyEs/WliCfKFoo+TwZYbenR
        sXTpSh4bAG0mUJHl5QXJmVP6tufbJOnDzm/g/jnRzYiYzqsnJbV4+1d0GqEX7O3XuvkaXPW7GN4=
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94)
        (envelope-from <vvs@virtuozzo.com>)
        id 1lZWhM-001ALd-EK; Thu, 22 Apr 2021 13:36:40 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v3 05/16] memcg: ipv6/sit: account and don't WARN on
 ip_tunnel_prl structs allocation
To:     cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
References: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
Message-ID: <2053653d-a975-59bf-0f16-7d4fddf923fa@virtuozzo.com>
Date:   Thu, 22 Apr 2021 13:36:40 +0300
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
index 9fdccf0..2ba147c 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -320,7 +320,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ifreq *ifr)
 	 * we try harder to allocate.
 	 */
 	kp = (cmax <= 1 || capable(CAP_NET_ADMIN)) ?
-		kcalloc(cmax, sizeof(*kp), GFP_KERNEL | __GFP_NOWARN) :
+		kcalloc(cmax, sizeof(*kp), GFP_KERNEL_ACCOUNT | __GFP_NOWARN) :
 		NULL;
 
 	rcu_read_lock();
@@ -333,7 +333,8 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ifreq *ifr)
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

