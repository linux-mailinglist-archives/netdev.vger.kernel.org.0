Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA4636B144
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 12:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbhDZKKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 06:10:03 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:42910 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232173AbhDZKJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 06:09:59 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UWoKdug_1619431698;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UWoKdug_1619431698)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 26 Apr 2021 18:09:16 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     wg@grandegger.com
Cc:     mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] can: softing: Remove redundant variable ptr
Date:   Mon, 26 Apr 2021 18:08:16 +0800
Message-Id: <1619431696-81853-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable ptr is being assigned a value from a calculation
however the variable is never read, so this redundant variable
can be removed.

Cleans up the following clang-analyzer warning:

drivers/net/can/softing/softing_main.c:279:3: warning: Value stored to
'ptr' is never read [clang-analyzer-deadcode.DeadStores].

drivers/net/can/softing/softing_main.c:242:3: warning: Value stored to
'ptr' is never read [clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
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

