Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7DD47E30F
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 13:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348167AbhLWMRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 07:17:01 -0500
Received: from smtp23.cstnet.cn ([159.226.251.23]:45222 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243479AbhLWMRA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 07:17:00 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-03 (Coremail) with SMTP id rQCowADX3FinaMRhtdFnBA--.41853S2;
        Thu, 23 Dec 2021 20:16:40 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     andy.shevchenko@gmail.com, davem@davemloft.net, kuba@kernel.org,
        yangyingliang@huawei.com, sashal@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH v4] fjes: Check for error irq
Date:   Thu, 23 Dec 2021 20:16:39 +0800
Message-Id: <20211223121639.1330292-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: rQCowADX3FinaMRhtdFnBA--.41853S2
X-Coremail-Antispam: 1UD129KBjvdXoW7XFyUKw48XF4DWw4fKw45KFg_yoWkXrg_Cr
        n2va17Ww409ryvkF1DGr43Z3W2kr1qqr10gas2yaySq398Ca47XryDZrs8J3y5W34YyF9F
        kr9xXr43A343AjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb2AFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s
        1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0
        cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8Jw
        ACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6ryUMxAI
        w28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
        4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxG
        rwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJw
        CI42IY6xAIw20EY4v20xvaj40_Zr0_Wr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
        x4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU6wZcUUUUU=
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The platform_get_irq() is possible to fail.
So the return value needs to check to prevent the use of error irq
number.

Fixes: 658d439b2292 ("fjes: Introduce FUJITSU Extended Socket Network Device driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
Changelog:

v3 -> v4

*Change 1. Using error variable to check.
*Change 2. Correct the word.
*Change 3. Add new commit message.
---
 drivers/net/fjes/fjes_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index e449d9466122..17f2fd937e4d 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -1268,7 +1268,12 @@ static int fjes_probe(struct platform_device *plat_dev)
 	}
 	hw->hw_res.start = res->start;
 	hw->hw_res.size = resource_size(res);
-	hw->hw_res.irq = platform_get_irq(plat_dev, 0);
+
+	err = platform_get_irq(plat_dev, 0);
+	if (err < 0)
+		goto err_free_control_wq;
+	hw->hw_res.irq = err;
+
 	err = fjes_hw_init(&adapter->hw);
 	if (err)
 		goto err_free_control_wq;
-- 
2.25.1

