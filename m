Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287BD1F61FE
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 09:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgFKHBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 03:01:10 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34024 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726603AbgFKHBJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 03:01:09 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 00986E67CDEEE3698471;
        Thu, 11 Jun 2020 15:01:07 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Thu, 11 Jun 2020
 15:01:00 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH -next] netfilter: ctnetlink: Fix memleak in ctnetlink_alloc_filter
Date:   Thu, 11 Jun 2020 15:08:05 +0800
Message-ID: <20200611070805.2982-1-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ctnetlink_alloc_filter
  filter = kzalloc

  In the following process(such as ctnetlink_parse_zone,
  ctnetlink_parse_filter), if return fail, need to kfree filter.

Fixes: cb8aa9a3affb ("netfilter: ctnetlink: add kernel side filtering for dump")
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 net/netfilter/nf_conntrack_netlink.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d7bd8b1f27d5..f7fdd91ece6d 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -939,7 +939,8 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 			filter->mark.mask = 0xffffffff;
 		}
 	} else if (cda[CTA_MARK_MASK]) {
-		return ERR_PTR(-EINVAL);
+		err = -EINVAL;
+		goto error;
 	}
 #endif
 	if (!cda[CTA_FILTER])
@@ -947,15 +948,17 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)

 	err = ctnetlink_parse_zone(cda[CTA_ZONE], &filter->zone);
 	if (err < 0)
-		return ERR_PTR(err);
+		goto error;

 	err = ctnetlink_parse_filter(cda[CTA_FILTER], filter);
 	if (err < 0)
-		return ERR_PTR(err);
+		goto error;

 	if (filter->orig_flags) {
-		if (!cda[CTA_TUPLE_ORIG])
-			return ERR_PTR(-EINVAL);
+		if (!cda[CTA_TUPLE_ORIG]) {
+			err = -EINVAL;
+			goto error;
+		}

 		err = ctnetlink_parse_tuple_filter(cda, &filter->orig,
 						   CTA_TUPLE_ORIG,
@@ -963,12 +966,14 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 						   &filter->zone,
 						   filter->orig_flags);
 		if (err < 0)
-			return ERR_PTR(err);
+			goto error;
 	}

 	if (filter->reply_flags) {
-		if (!cda[CTA_TUPLE_REPLY])
-			return ERR_PTR(-EINVAL);
+		if (!cda[CTA_TUPLE_REPLY]) {
+			err = -EINVAL;
+			goto error;
+		}

 		err = ctnetlink_parse_tuple_filter(cda, &filter->reply,
 						   CTA_TUPLE_REPLY,
@@ -976,10 +981,14 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 						   &filter->zone,
 						   filter->orig_flags);
 		if (err < 0)
-			return ERR_PTR(err);
+			goto error;
 	}

 	return filter;
+
+error:
+	kfree(filter);
+	return ERR_PTR(err);
 }

 static bool ctnetlink_needs_filter(u8 family, const struct nlattr * const *cda)
--
2.26.0.106.g9fadedd

