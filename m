Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6907032278B
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 10:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbhBWJKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 04:10:54 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:45914 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231592AbhBWJKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 04:10:09 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UPMH7Pf_1614071363;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UPMH7Pf_1614071363)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 23 Feb 2021 17:09:24 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     elder@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] drivers: ipa: Add missing IRQF_ONESHOT
Date:   Tue, 23 Feb 2021 17:09:22 +0800
Message-Id: <1614071362-123210-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fixed the following coccicheck:
./drivers/net/ipa/ipa_smp2p.c:186:7-27: ERROR: Threaded IRQ with no
primary handler requested without IRQF_ONESHOT

Make sure threaded IRQs without a primary handler are always request
with IRQF_ONESHOT

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ipa/ipa_smp2p.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
index a5f7a79..1149ed8 100644
--- a/drivers/net/ipa/ipa_smp2p.c
+++ b/drivers/net/ipa/ipa_smp2p.c
@@ -183,7 +183,7 @@ static int ipa_smp2p_irq_init(struct ipa_smp2p *smp2p, const char *name,
 	}
 	irq = ret;
 
-	ret = request_threaded_irq(irq, NULL, handler, 0, name, smp2p);
+	ret = request_threaded_irq(irq, NULL, handler, IRQF_ONESHOT, name, smp2p);
 	if (ret) {
 		dev_err(dev, "error %d requesting \"%s\" IRQ\n", ret, name);
 		return ret;
-- 
1.8.3.1

