Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406F536C338
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 12:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbhD0KZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 06:25:50 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:57758 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230365AbhD0KZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 06:25:46 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UWzIRcK_1619519088;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UWzIRcK_1619519088)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 27 Apr 2021 18:25:01 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     santosh.shilimkar@oracle.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        inux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] rds: Remove redundant assignment to nr_sig
Date:   Tue, 27 Apr 2021 18:24:47 +0800
Message-Id: <1619519087-55904-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable nr_sig is being assigned a value however the assignment is
never read, so this redundant assignment can be removed.

Cleans up the following clang-analyzer warning:

net/rds/ib_send.c:297:2: warning: Value stored to 'nr_sig' is never read
[clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/rds/ib_send.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index 92b4a86..4190b90 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -294,7 +294,6 @@ void rds_ib_send_cqe_handler(struct rds_ib_connection *ic, struct ib_wc *wc)
 
 	rds_ib_ring_free(&ic->i_send_ring, completed);
 	rds_ib_sub_signaled(ic, nr_sig);
-	nr_sig = 0;
 
 	if (test_and_clear_bit(RDS_LL_SEND_FULL, &conn->c_flags) ||
 	    test_bit(0, &conn->c_map_queued))
-- 
1.8.3.1

