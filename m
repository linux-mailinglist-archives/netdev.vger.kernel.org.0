Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C675A47B6BB
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 02:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhLUBPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 20:15:00 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:51596 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229436AbhLUBPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 20:15:00 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0V.Hgt7._1640049297;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V.Hgt7._1640049297)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 21 Dec 2021 09:14:57 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] net/sched: use min() macro instead of doing it manually
Date:   Tue, 21 Dec 2021 09:14:55 +0800
Message-Id: <20211221011455.10163-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following coccicheck warnings:
./net/sched/cls_api.c:3333:17-18: WARNING opportunity for min()
./net/sched/cls_api.c:3389:17-18: WARNING opportunity for min()
./net/sched/cls_api.c:3427:17-18: WARNING opportunity for min()

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 net/sched/cls_api.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index c93699ddae36..a53c72e6d944 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3333,7 +3333,7 @@ int tc_setup_cb_add(struct tcf_block *block, struct tcf_proto *tp,
 	up_read(&block->cb_lock);
 	if (take_rtnl)
 		rtnl_unlock();
-	return ok_count < 0 ? ok_count : 0;
+	return min(ok_count, 0);
 }
 EXPORT_SYMBOL(tc_setup_cb_add);
 
@@ -3389,7 +3389,7 @@ int tc_setup_cb_replace(struct tcf_block *block, struct tcf_proto *tp,
 	up_read(&block->cb_lock);
 	if (take_rtnl)
 		rtnl_unlock();
-	return ok_count < 0 ? ok_count : 0;
+	return min(ok_count, 0);
 }
 EXPORT_SYMBOL(tc_setup_cb_replace);
 
@@ -3427,7 +3427,7 @@ int tc_setup_cb_destroy(struct tcf_block *block, struct tcf_proto *tp,
 	up_read(&block->cb_lock);
 	if (take_rtnl)
 		rtnl_unlock();
-	return ok_count < 0 ? ok_count : 0;
+	return min(ok_count, 0);
 }
 EXPORT_SYMBOL(tc_setup_cb_destroy);
 
-- 
2.20.1.7.g153144c

