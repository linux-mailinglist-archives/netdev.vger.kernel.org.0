Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5BFC350D07
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 05:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbhDADYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 23:24:07 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:15840 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhDADXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 23:23:43 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F9pPR1ZKZz93hB;
        Thu,  1 Apr 2021 11:21:31 +0800 (CST)
Received: from mdc.localdomain (10.175.104.57) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Thu, 1 Apr 2021 11:23:29 +0800
From:   Xu Jia <xujia39@huawei.com>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xu Jia <xujia39@huawei.com>
Subject: [PATCH net-next] net: ipv6: Refactor in rt6_age_examine_exception
Date:   Thu, 1 Apr 2021 11:22:23 +0800
Message-ID: <1617247343-48200-1-git-send-email-xujia39@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.104.57]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The logic in rt6_age_examine_exception is confusing. The commit is
to refactor the code.

Signed-off-by: Xu Jia <xujia39@huawei.com>
---
 net/ipv6/route.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index ebb7519bec2a..f15c7605b11d 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2085,13 +2085,10 @@ static void rt6_age_examine_exception(struct rt6_exception_bucket *bucket,
 
 	if (rt->rt6i_flags & RTF_GATEWAY) {
 		struct neighbour *neigh;
-		__u8 neigh_flags = 0;
 
 		neigh = __ipv6_neigh_lookup_noref(rt->dst.dev, &rt->rt6i_gateway);
-		if (neigh)
-			neigh_flags = neigh->flags;
 
-		if (!(neigh_flags & NTF_ROUTER)) {
+		if (!(neigh && (neigh->flags & NTF_ROUTER))) {
 			RT6_TRACE("purging route %p via non-router but gateway\n",
 				  rt);
 			rt6_remove_exception(bucket, rt6_ex);
-- 
2.25.1

