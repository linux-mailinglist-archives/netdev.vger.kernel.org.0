Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A3E36A6B7
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 12:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhDYKiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 06:38:02 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:25090 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229466AbhDYKiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 06:38:01 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UWgfMXI_1619347024;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UWgfMXI_1619347024)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 25 Apr 2021 18:37:10 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     rajur@chelsio.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] cxgb4: Remove redundant assignment to ret
Date:   Sun, 25 Apr 2021 18:37:03 +0800
Message-Id: <1619347023-49996-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable ret is set to zero but this value is never read as it is
overwritten with a new value later on, hence it is a redundant
assignment and can be removed.

Cleans up the following clang-analyzer warning:

drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:3830:2: warning: Value stored
to 'ret' is never read [clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 80882cf..b9d2d58 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -3827,8 +3827,8 @@ int t4_load_phy_fw(struct adapter *adap, int win,
 		 FW_PARAMS_PARAM_X_V(FW_PARAMS_PARAM_DEV_PHYFW) |
 		 FW_PARAMS_PARAM_Y_V(adap->params.portvec) |
 		 FW_PARAMS_PARAM_Z_V(FW_PARAMS_PARAM_DEV_PHYFW_DOWNLOAD));
-	ret = t4_set_params_timeout(adap, adap->mbox, adap->pf, 0, 1,
-				    &param, &val, 30000);
+	t4_set_params_timeout(adap, adap->mbox, adap->pf, 0, 1,
+			      &param, &val, 30000);
 
 	/* If we have version number support, then check to see that the new
 	 * firmware got loaded properly.
-- 
1.8.3.1

