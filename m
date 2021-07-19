Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC013CD286
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 12:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236578AbhGSKEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 06:04:21 -0400
Received: from relay.sw.ru ([185.231.240.75]:44630 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236507AbhGSKES (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 06:04:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=UZrH4BVKP7hsH0Ef9AbThzsAu5M7Nu3PE7kKwMt/YWY=; b=XHVkIpI92bVaY20EHc5
        GtWFwWzv6wl4oufrCaN5OCs1l6PwTbHZydRscCdAV8vZ9BpzdZnbzPstQYpTOMnvEtgB+zqcMpbO7
        mopc2HiC1RqmEa2odgR7qj8iBG0JI03+3LIvcSyIkwfDCJlZuB5Xl+2BZMDK4aNvZOzfYPf4gOA=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m5Qld-004ReZ-88; Mon, 19 Jul 2021 13:44:57 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v5 06/16] memcg: enable accounting for scm_fp_list objects
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Roman Gushchin <guro@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
 <cover.1626688654.git.vvs@virtuozzo.com>
Message-ID: <4fe78621-16a8-ebd9-d7f5-f13c52eb36ff@virtuozzo.com>
Date:   Mon, 19 Jul 2021 13:44:56 +0300
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

unix sockets allows to send file descriptors via SCM_RIGHTS type messages.
Each such send call forces kernel to allocate up to 2Kb memory for
struct scm_fp_list.

It makes sense to account for them to restrict the host's memory
consumption from inside the memcg-limited container.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/core/scm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/scm.c b/net/core/scm.c
index ae3085d..5c356f0 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -79,7 +79,7 @@ static int scm_fp_copy(struct cmsghdr *cmsg, struct scm_fp_list **fplp)
 
 	if (!fpl)
 	{
-		fpl = kmalloc(sizeof(struct scm_fp_list), GFP_KERNEL);
+		fpl = kmalloc(sizeof(struct scm_fp_list), GFP_KERNEL_ACCOUNT);
 		if (!fpl)
 			return -ENOMEM;
 		*fplp = fpl;
@@ -355,7 +355,7 @@ struct scm_fp_list *scm_fp_dup(struct scm_fp_list *fpl)
 		return NULL;
 
 	new_fpl = kmemdup(fpl, offsetof(struct scm_fp_list, fp[fpl->count]),
-			  GFP_KERNEL);
+			  GFP_KERNEL_ACCOUNT);
 	if (new_fpl) {
 		for (i = 0; i < fpl->count; i++)
 			get_file(fpl->fp[i]);
-- 
1.8.3.1

