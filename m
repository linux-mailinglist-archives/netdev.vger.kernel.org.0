Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489E138FFA4
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 13:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhEYLBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 07:01:50 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:52522 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229581AbhEYLBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 07:01:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Ua4Wylo_1621940413;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Ua4Wylo_1621940413)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 25 May 2021 19:00:18 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     aelior@marvell.com
Cc:     skalluru@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.ne, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] bnx2x: Fix missing error code in bnx2x_iov_init_one()
Date:   Tue, 25 May 2021 19:00:12 +0800
Message-Id: <1621940412-73333-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the follow smatch warning:

drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c:1227
bnx2x_iov_init_one() warn: missing error code 'err'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index d21f085..27943b0 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -1223,8 +1223,10 @@ int bnx2x_iov_init_one(struct bnx2x *bp, int int_mode_param,
 		goto failed;
 
 	/* SR-IOV capability was enabled but there are no VFs*/
-	if (iov->total == 0)
+	if (iov->total == 0) {
+		err = -EINVAL;
 		goto failed;
+	}
 
 	iov->nr_virtfn = min_t(u16, iov->total, num_vfs_param);
 
-- 
1.8.3.1

