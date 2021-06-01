Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C59E397211
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 13:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbhFALIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 07:08:46 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:44892 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233299AbhFALIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 07:08:39 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R421e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Uaw9rLl_1622545613;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Uaw9rLl_1622545613)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Jun 2021 19:06:56 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     ecree.xilinx@gmail.com
Cc:     habetsm.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] sfc-falcon: Fix missing error code in ef4_reset_up()
Date:   Tue,  1 Jun 2021 19:06:42 +0800
Message-Id: <1622545602-19483-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'rc'.

Eliminate the follow smatch warning:

drivers/net/ethernet/sfc/falcon/efx.c:2389 ef4_reset_up() warn: missing
error code 'rc'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/sfc/falcon/efx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 5e7a57b..d336c24 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2385,8 +2385,10 @@ int ef4_reset_up(struct ef4_nic *efx, enum reset_type method, bool ok)
 		goto fail;
 	}
 
-	if (!ok)
+	if (!ok) {
+		rc = -EINVAL;
 		goto fail;
+	}
 
 	if (efx->port_initialized && method != RESET_TYPE_INVISIBLE &&
 	    method != RESET_TYPE_DATAPATH) {
-- 
1.8.3.1

