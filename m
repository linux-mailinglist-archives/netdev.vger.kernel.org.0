Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B98404792
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 11:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbhIIJPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 05:15:04 -0400
Received: from m15114.mail.126.com ([220.181.15.114]:45113 "EHLO
        m15114.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhIIJPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 05:15:04 -0400
X-Greylist: delayed 1956 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Sep 2021 05:15:03 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=FdVnE8dqneJD33E5HI
        B6C5thLfLaj9xAJii2UP8mF5U=; b=XpFGwryvCTbc7w5NyYHqsk3ZT96JaQ0rrT
        QE0qWN1s938S2baU7RP1lUyxeCEfDR6JEznnIPe9IRm+q5jo1pS39aurKbhRVPPi
        Ke5Kvff5VcDD0IlIwSW/9I2TdUbWHvDDMXlc3sfT4oFKuUh7bHOIteWvqBvovZIK
        4JVeoNiB8=
Received: from localhost.localdomain (unknown [221.221.167.32])
        by smtp7 (Coremail) with SMTP id DsmowABngVg8yDlh1WPDUQ--.41134S4;
        Thu, 09 Sep 2021 16:39:25 +0800 (CST)
From:   zhang kai <zhangkaiheb@126.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhang kai <zhangkaiheb@126.com>
Subject: [PATCH] ipv6: delay fib6_sernum increase in fib6_add
Date:   Thu,  9 Sep 2021 16:39:18 +0800
Message-Id: <20210909083918.27008-1-zhangkaiheb@126.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: DsmowABngVg8yDlh1WPDUQ--.41134S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrZryDCryfKF13tr1xAw48Xrb_yoWDJrX_Ga
        97Ww15uF1jgrZ2kw1DZw43JFyrta1fWFyfZFWSyFZ7t3Zxtry5Aws3ZanxAFWfGry3Kay7
        ur45GFyrAr1IgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUgAw3UUUUU==
X-Originating-IP: [221.221.167.32]
X-CM-SenderInfo: x2kd0wxndlxvbe6rjloofrz/1tbikx0J-lpECQ6N+AAAsV
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

only increase fib6_sernum in net namespace after add fib6_info
successfully.

Signed-off-by: zhang kai <zhangkaiheb@126.com>
---
 net/ipv6/ip6_fib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 4d7b93baa..07de2fbc9 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1377,7 +1377,6 @@ int fib6_add(struct fib6_node *root, struct fib6_info *rt,
 	int err = -ENOMEM;
 	int allow_create = 1;
 	int replace_required = 0;
-	int sernum = fib6_new_sernum(info->nl_net);
 
 	if (info->nlh) {
 		if (!(info->nlh->nlmsg_flags & NLM_F_CREATE))
@@ -1477,7 +1476,7 @@ int fib6_add(struct fib6_node *root, struct fib6_info *rt,
 	if (!err) {
 		if (rt->nh)
 			list_add(&rt->nh_list, &rt->nh->f6i_list);
-		__fib6_update_sernum_upto_root(rt, sernum);
+		__fib6_update_sernum_upto_root(rt, fib6_new_sernum(info->nl_net));
 		fib6_start_gc(info->nl_net, rt);
 	}
 
-- 
2.17.1

