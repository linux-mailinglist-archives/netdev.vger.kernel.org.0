Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B463636E8A6
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 12:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240395AbhD2K0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 06:26:47 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:48897 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233114AbhD2K0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 06:26:46 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0UX9cCYY_1619691948;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UX9cCYY_1619691948)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 29 Apr 2021 18:25:58 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     nicolas.ferre@microchip.com
Cc:     claudiu.beznea@microchip.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, palmer@dabbelt.com,
        paul.walmsley@sifive.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] net: macb: Remove redundant assignment to queue
Date:   Thu, 29 Apr 2021 18:25:46 +0800
Message-Id: <1619691946-90305-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable queue is set to bp->queues but these values is not used as it
is overwritten later on, hence redundant assignment  can be removed.

Cleans up the following clang-analyzer warning:

drivers/net/ethernet/cadence/macb_main.c:4919:21: warning: Value stored
to 'queue' during its initialization is never read
[clang-analyzer-deadcode.DeadStores].

drivers/net/ethernet/cadence/macb_main.c:4832:21: warning: Value stored
to 'queue' during its initialization is never read
[clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 0f6a6cb..5693850 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4829,7 +4829,7 @@ static int __maybe_unused macb_suspend(struct device *dev)
 {
 	struct net_device *netdev = dev_get_drvdata(dev);
 	struct macb *bp = netdev_priv(netdev);
-	struct macb_queue *queue = bp->queues;
+	struct macb_queue *queue;
 	unsigned long flags;
 	unsigned int q;
 	int err;
@@ -4916,7 +4916,7 @@ static int __maybe_unused macb_resume(struct device *dev)
 {
 	struct net_device *netdev = dev_get_drvdata(dev);
 	struct macb *bp = netdev_priv(netdev);
-	struct macb_queue *queue = bp->queues;
+	struct macb_queue *queue;
 	unsigned long flags;
 	unsigned int q;
 	int err;
-- 
1.8.3.1

