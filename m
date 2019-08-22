Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51E9398BDE
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 08:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731898AbfHVG66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 02:58:58 -0400
Received: from smtpbgsg2.qq.com ([54.254.200.128]:56351 "EHLO smtpbgsg2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731197AbfHVG65 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 02:58:57 -0400
X-QQ-mid: bizesmtp19t1566457103t0y93v7p
Received: from localhost.localdomain (unknown [218.76.23.26])
        by esmtp10.qq.com (ESMTP) with 
        id ; Thu, 22 Aug 2019 14:58:17 +0800 (CST)
X-QQ-SSF: 01400000000000K0JH32000A0000000
X-QQ-FEAT: YGus1B7tLZY6Td56PPA4So/HcXsjkjLQpHMm+zcGLM2RI8tGiaYm85NlJUKvs
        z0KsXC831a4IBeRmVn5PNPCPdChD4tYlOQcMd2yLcGRrGxSUj6VpNq5tlRiZ1fnOsSBnF5z
        UvRtrEUG4iK9G8nFYVAqqOwB2nWYfLRtd3kmoENSh74Or9lmx0104RqHeiuFgHwmNHNHVpT
        S/sZmJOBrRiRGR4NZE+TpYo6Cvs2RJyE4crAKstu4zjlxLU8p2WtYPq6l/OwkrnA2Oi7drS
        eKFKwV99ssNDHvyg15C5dYT1u3Ny4+OGKs8e5dN8K6o5puHL4kWuVO0+54iARWEb3kQf83F
        5sYwAtd
X-QQ-GoodBg: 2
From:   xiaolinkui <xiaolinkui@kylinos.cn>
To:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        xiaolinkui <xiaolinkui@kylinos.cn>
Subject: [PATCH] net: use unlikely for dql_avail case
Date:   Thu, 22 Aug 2019 14:58:16 +0800
Message-Id: <20190822065816.23619-1-xiaolinkui@kylinos.cn>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:kylinos.cn:qybgforeign:qybgforeign1
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



