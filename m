Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745DC4855C2
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241416AbiAEPWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:22:50 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:54895 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241413AbiAEPWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:22:49 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0V11dpZL_1641396160;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0V11dpZL_1641396160)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 05 Jan 2022 23:22:45 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     ecree.xilinx@gmail.com
Cc:     habetsm.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] sfc: Use swap() instead of open coding it
Date:   Wed,  5 Jan 2022 23:22:37 +0800
Message-Id: <20220105152237.45991-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean the following coccicheck warning:

./drivers/net/ethernet/sfc/efx_channels.c:870:36-37: WARNING opportunity
for swap().

./drivers/net/ethernet/sfc/efx_channels.c:824:36-37: WARNING opportunity
for swap().

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index b015d1f2e204..ead550ae2709 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -819,11 +819,8 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 	old_txq_entries = efx->txq_entries;
 	efx->rxq_entries = rxq_entries;
 	efx->txq_entries = txq_entries;
-	for (i = 0; i < efx->n_channels; i++) {
-		channel = efx->channel[i];
-		efx->channel[i] = other_channel[i];
-		other_channel[i] = channel;
-	}
+	for (i = 0; i < efx->n_channels; i++)
+		swap(efx->channel[i], other_channel[i]);
 
 	/* Restart buffer table allocation */
 	efx->next_buffer_table = next_buffer_table;
@@ -865,11 +862,8 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 	/* Swap back */
 	efx->rxq_entries = old_rxq_entries;
 	efx->txq_entries = old_txq_entries;
-	for (i = 0; i < efx->n_channels; i++) {
-		channel = efx->channel[i];
-		efx->channel[i] = other_channel[i];
-		other_channel[i] = channel;
-	}
+	for (i = 0; i < efx->n_channels; i++)
+		swap(efx->channel[i], other_channel[i]);
 	goto out;
 }
 
-- 
2.20.1.7.g153144c

