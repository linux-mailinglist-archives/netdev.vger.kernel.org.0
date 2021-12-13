Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86FD47271A
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 10:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbhLMJ6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 04:58:17 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:53376 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238718AbhLMJyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 04:54:19 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0V-V3Tqn_1639389254;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V-V3Tqn_1639389254)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 13 Dec 2021 17:54:15 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        nathan@kernel.org, ndesaulniers@google.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] mt76: remove variable set but not used
Date:   Mon, 13 Dec 2021 17:54:13 +0800
Message-Id: <20211213095413.99456-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code that uses variable queued has been removed,
and "mt76_is_usb(dev) ? q->ndesc - q->queued : q->queued"
didn't do anything, so all they should be removed as well.

Eliminate the following clang warnings:
drivers/net/wireless/mediatek/mt76/debugfs.c:77:9: warning: variable
‘queued’ set but not used.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: 2d8be76c1674 ("mt76: debugfs: improve queue node readability")
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/wireless/mediatek/mt76/debugfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/debugfs.c b/drivers/net/wireless/mediatek/mt76/debugfs.c
index b8bcf22a07fd..027d9ea17d04 100644
--- a/drivers/net/wireless/mediatek/mt76/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/debugfs.c
@@ -74,13 +74,12 @@ EXPORT_SYMBOL_GPL(mt76_queues_read);
 static int mt76_rx_queues_read(struct seq_file *s, void *data)
 {
 	struct mt76_dev *dev = dev_get_drvdata(s->private);
-	int i, queued;
+	int i;
 
 	seq_puts(s, "     queue | hw-queued |      head |      tail |\n");
 	mt76_for_each_q_rx(dev, i) {
 		struct mt76_queue *q = &dev->q_rx[i];
 
-		queued = mt76_is_usb(dev) ? q->ndesc - q->queued : q->queued;
 		seq_printf(s, " %9d | %9d | %9d | %9d |\n",
 			   i, q->queued, q->head, q->tail);
 	}
-- 
2.20.1.7.g153144c

