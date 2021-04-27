Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BA136C469
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 12:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235611AbhD0Kxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 06:53:43 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:55943 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230365AbhD0Kxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 06:53:43 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UWzhUGU_1619520768;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UWzhUGU_1619520768)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 27 Apr 2021 18:52:57 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     wg@grandegger.com
Cc:     mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH v2] can: softing: Remove redundant variable ptr
Date:   Tue, 27 Apr 2021 18:52:47 +0800
Message-Id: <1619520767-80948-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value stored to ptr in the calculations this patch removes is not
used, so the calculation and the assignment can be removed.

Cleans up the following clang-analyzer warning:

drivers/net/can/softing/softing_main.c:279:3: warning: Value stored to
'ptr' is never read [clang-analyzer-deadcode.DeadStores].

drivers/net/can/softing/softing_main.c:242:3: warning: Value stored to
'ptr' is never read [clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
Changes in v2:
  -Make the commit message more clearer.

 drivers/net/can/softing/softing_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/softing/softing_main.c
index c44f341..cfc1325 100644
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -239,7 +239,6 @@ static int softing_handle_1(struct softing *card)
 				DPRAM_INFO_BUSSTATE2 : DPRAM_INFO_BUSSTATE]);
 		/* timestamp */
 		tmp_u32 = le32_to_cpup((void *)ptr);
-		ptr += 4;
 		ktime = softing_raw2ktime(card, tmp_u32);
 
 		++netdev->stats.rx_errors;
@@ -276,7 +275,6 @@ static int softing_handle_1(struct softing *card)
 		ktime = softing_raw2ktime(card, tmp_u32);
 		if (!(msg.can_id & CAN_RTR_FLAG))
 			memcpy(&msg.data[0], ptr, 8);
-		ptr += 8;
 		/* update socket */
 		if (cmd & CMD_ACK) {
 			/* acknowledge, was tx msg */
-- 
1.8.3.1

