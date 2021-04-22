Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DA4367EC5
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 12:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235951AbhDVKhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 06:37:15 -0400
Received: from relay.sw.ru ([185.231.240.75]:33366 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235955AbhDVKhI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 06:37:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=uHSxH+z24mqnhtuT7lZ5lO0b/1FeyBNtouCJgBY3h2Q=; b=cohcaQzojQvriQ2f8Hy
        wZqZDZdALIYZfwXouBfTKtx9juQ4X62nixX6BQ40z7LgeST5XRTBsSK6I0k6ECVSJoSAMtAZJruPT
        /LMNsW6JEuV56/bD6zZcRneWrsv2Hmjy6+oIynD4luXiXwpjIoVyKqBvfqA4kJfFlmXQSHZhFLI=
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94)
        (envelope-from <vvs@virtuozzo.com>)
        id 1lZWhC-001ALQ-My; Thu, 22 Apr 2021 13:36:30 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v3 04/16] memcg: enable accounting for VLAN group array
To:     cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
Message-ID: <4fcc28c6-8451-c7e3-b6fb-5af5dd0a3553@virtuozzo.com>
Date:   Thu, 22 Apr 2021 13:36:30 +0300
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

vlan array consume up to 8 pages of memory per net device.

It makes sense to account for them to restrict the host's memory
consumption from inside the memcg-limited container.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/8021q/vlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 8b644113..d0a579d4 100644
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

