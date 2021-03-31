Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AE634F693
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 04:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbhCaCWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 22:22:46 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:46593 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233080AbhCaCWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 22:22:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xuchunmei@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UTunqWB_1617157354;
Received: from localhost(mailfrom:xuchunmei@linux.alibaba.com fp:SMTPD_---0UTunqWB_1617157354)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 31 Mar 2021 10:22:40 +0800
From:   Chunmei Xu <xuchunmei@linux.alibaba.com>
To:     idosch@idosch.org, dsahern@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH] ip-nexthop: support flush by id
Date:   Wed, 31 Mar 2021 10:22:34 +0800
Message-Id: <20210331022234.52977-1-xuchunmei@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add id to struct filter to record the 'id',
filter id only when id is set, otherwise flush all. 

Signed-off-by: Chunmei Xu <xuchunmei@linux.alibaba.com>
---
 ip/ipnexthop.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 22c66491..fd759140 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -21,6 +21,7 @@ static struct {
 	unsigned int master;
 	unsigned int proto;
 	unsigned int fdb;
+	unsigned int id;
 } filter;
 
 enum {
@@ -124,6 +125,9 @@ static int flush_nexthop(struct nlmsghdr *nlh, void *arg)
 	if (tb[NHA_ID])
 		id = rta_getattr_u32(tb[NHA_ID]);
 
+	if (filter.id && filter.id != id)
+		return 0;
+
 	if (id && !delete_nexthop(id))
 		filter.flushed++;
 
@@ -491,7 +495,10 @@ static int ipnh_list_flush(int argc, char **argv, int action)
 			NEXT_ARG();
 			if (get_unsigned(&id, *argv, 0))
 				invarg("invalid id value", *argv);
-			return ipnh_get_id(id);
+			if (action == IPNH_FLUSH)
+				filter.id = id;
+			else
+				return ipnh_get_id(id);
 		} else if (!matches(*argv, "protocol")) {
 			__u32 proto;
 
-- 
2.27.0

