Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B422CBD673
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 04:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633714AbfIYClg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 22:41:36 -0400
Received: from smtpbgbr2.qq.com ([54.207.22.56]:55353 "EHLO smtpbgbr2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391325AbfIYClg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 22:41:36 -0400
X-QQ-mid: bizesmtp18t1569379254tzkmnbxl
Received: from localhost.localdomain (unknown [218.76.23.26])
        by esmtp6.qq.com (ESMTP) with 
        id ; Wed, 25 Sep 2019 10:40:50 +0800 (CST)
X-QQ-SSF: 01400000000000K0JI32B00A0000000
X-QQ-FEAT: nlEsdtYYU0EkYKhuJyP0vVp51b28v4A4aA77W9hgunsQobpg28/tQCVSiCtT1
        QhFGHAe4+pViBb6IZrcfizC2GKO13QnQ8yvrdvHb0yn2jWIP4QvfcqJOAtma/M3xn/SOZcf
        cGIIM5nWY/LIurl6G9qgI2NnF+tuwU3S//AqWVQquTten85KD6QEh934l8aZU9qyEUKpCOJ
        0YsrrNoDQZbhErT3O1g5gY3C9IQAGWOCraH8IB9R8vdK1R+BbCvRIaVywUPM+OzR6nDc3ao
        NaZF/0B1GRtunzagPLwxuH/7le3iaPLieF7YKC7+lEmhDomcSPhJUGCgwhrhpC1Go/GQ==
X-QQ-GoodBg: 2
From:   xiaolinkui <xiaolinkui@kylinos.cn>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, xiaolinkui <xiaolinkui@kylinos.cn>
Subject: [PATCH] net: use unlikely for dql_avail case
Date:   Wed, 25 Sep 2019 10:40:43 +0800
Message-Id: <20190925024043.31030-1-xiaolinkui@kylinos.cn>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:kylinos.cn:qybgforeign:qybgforeign2
X-QQ-Bgrelay: 1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an unlikely case, use unlikely() on it seems logical.

Signed-off-by: xiaolinkui <xiaolinkui@kylinos.cn>
---
 include/linux/netdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 88292953aa6f..005f3da1b13d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3270,7 +3270,7 @@ static inline void netdev_tx_completed_queue(struct netdev_queue *dev_queue,
 	 */
 	smp_mb();
 
-	if (dql_avail(&dev_queue->dql) < 0)
+	if (unlikely(dql_avail(&dev_queue->dql) < 0))
 		return;
 
 	if (test_and_clear_bit(__QUEUE_STATE_STACK_XOFF, &dev_queue->state))
-- 
2.17.1



