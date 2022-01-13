Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C366A48DB70
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 17:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236296AbiAMQOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 11:14:20 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:59737 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229483AbiAMQOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 11:14:19 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0V1kw-GB_1642090398;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0V1kw-GB_1642090398)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 14 Jan 2022 00:14:16 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     ecree.xilinx@gmail.com
Cc:     habetsm.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] sfc: Fix missing error code in efx_reset_up()
Date:   Fri, 14 Jan 2022 00:13:15 +0800
Message-Id: <20220113161315.126410-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'rc'.

Eliminate the follow smatch warning:

drivers/net/ethernet/sfc/efx_common.c:758 efx_reset_up() warn: missing
error code 'rc'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/sfc/efx_common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index af37c990217e..bdfcda8bb5d0 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -754,8 +754,10 @@ int efx_reset_up(struct efx_nic *efx, enum reset_type method, bool ok)
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
2.20.1.7.g153144c

