Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CC047EA59
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 02:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350687AbhLXBfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 20:35:13 -0500
Received: from smtp25.cstnet.cn ([159.226.251.25]:48806 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245122AbhLXBfM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 20:35:12 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-05 (Coremail) with SMTP id zQCowAA3FxS3I8VhQ4LFBA--.65364S2;
        Fri, 24 Dec 2021 09:34:48 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     robin.murphy@arm.com, andy.shevchenko@gmail.com,
        davem@davemloft.net, kuba@kernel.org, yangyingliang@huawei.com,
        sashal@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH v5] fjes: Check for error irq
Date:   Fri, 24 Dec 2021 09:34:45 +0800
Message-Id: <20211224013445.1400507-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowAA3FxS3I8VhQ4LFBA--.65364S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uFyrJw1xGF17uF4kXrW5Jrb_yoW8Xr17pF
        4UKasxZrWkJay0ka12yr48ZF9Iva18tw4UC390k3Wfu3sYqFsxAFy5tFW0qrs7XrZ5X3Wa
        ya1YvrW8uFn8uFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkm14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26F
        4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_
        KwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
        1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
        64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
        0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
        IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUOMKZDUUUU
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The platform_get_irq() is possible to fail.
And the returned irq could be error number and will finally cause the
failure of the request_irq().
Consider that platform_get_irq() can now in certain cases return
-EPROBE_DEFER, and the consequences of letting request_irq() effectively
convert that into -EINVAL, even at probe time rather than later on.
So it might be better to check just now.

Fixes: 658d439b2292 ("fjes: Introduce FUJITSU Extended Socket Network Device driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
Changelog:

v4 -> v5

*Change 1. Using error variable to check.
*Change 2. Correct the word.
*Change 3. Add new commit message.
*Change 4. Refine the commit message to be more reasonable.
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

