Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E113957C265
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 04:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbiGUCov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 22:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiGUCou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 22:44:50 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05717774BD;
        Wed, 20 Jul 2022 19:44:48 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VJzcuX0_1658371484;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VJzcuX0_1658371484)
          by smtp.aliyun-inc.com;
          Thu, 21 Jul 2022 10:44:45 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     ap420073@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] amt: Return true/false (not 1/0) from bool function
Date:   Thu, 21 Jul 2022 10:44:43 +0800
Message-Id: <20220721024443.112126-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return boolean values ("true" or "false") instead of 1 or 0 from bool
functions. This fixes the following warnings from coccicheck:

./drivers/net/amt.c:901:9-10: WARNING: return of 0/1 in function 'amt_queue_event' with return type bool

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/amt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index febfcf2d92af..2ff53e73f10f 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -898,7 +898,7 @@ static bool amt_queue_event(struct amt_dev *amt, enum amt_event event,
 	spin_lock_bh(&amt->lock);
 	if (amt->nr_events >= AMT_MAX_EVENTS) {
 		spin_unlock_bh(&amt->lock);
-		return 1;
+		return true;
 	}
 
 	index = (amt->event_idx + amt->nr_events) % AMT_MAX_EVENTS;
@@ -909,7 +909,7 @@ static bool amt_queue_event(struct amt_dev *amt, enum amt_event event,
 	queue_work(amt_wq, &amt->event_wq);
 	spin_unlock_bh(&amt->lock);
 
-	return 0;
+	return false;
 }
 
 static void amt_secret_work(struct work_struct *work)
-- 
2.20.1.7.g153144c

