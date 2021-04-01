Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219A6350D68
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 06:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhDAEDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 00:03:35 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:46874 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229476AbhDAEDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 00:03:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=xuchunmei@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UU0YESz_1617249783;
Received: from localhost(mailfrom:xuchunmei@linux.alibaba.com fp:SMTPD_---0UU0YESz_1617249783)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 01 Apr 2021 12:03:10 +0800
From:   Chunmei Xu <xuchunmei@linux.alibaba.com>
To:     idosch@idosch.org, dsahern@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2] ip-nexthop: support flush by id
Date:   Thu,  1 Apr 2021 12:03:03 +0800
Message-Id: <20210401040303.61743-1-xuchunmei@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

since id is unique for nexthop, it is heavy to dump all nexthops.
use existing delete_nexthop to support flush by id

Signed-off-by: Chunmei Xu <xuchunmei@linux.alibaba.com>
---
 ip/ipnexthop.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 20cde586..419bcb0a 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -460,6 +460,24 @@ static int ipnh_get_id(__u32 id)
 	return 0;
 }
 
+static int ipnh_list_flush_id(__u32 id, int action)
+{
+	int err;
+
+	if (action == IPNH_LIST)
+		return ipnh_get_id(id);
+
+	if (rtnl_open(&rth_del, 0) < 0) {
+		fprintf(stderr, "Cannot open rtnetlink\n");
+		return EXIT_FAILURE;
+	}
+
+	err = delete_nexthop(id);
+	rtnl_close(&rth_del);
+
+	return err;
+}
+
 static int ipnh_list_flush(int argc, char **argv, int action)
 {
 	unsigned int all = (argc == 0);
@@ -490,7 +508,7 @@ static int ipnh_list_flush(int argc, char **argv, int action)
 			NEXT_ARG();
 			if (get_unsigned(&id, *argv, 0))
 				invarg("invalid id value", *argv);
-			return ipnh_get_id(id);
+			return ipnh_list_flush_id(id, action);
 		} else if (!matches(*argv, "protocol")) {
 			__u32 proto;
 
-- 
2.27.0

