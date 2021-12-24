Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CB247EB00
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 04:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351206AbhLXD4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 22:56:05 -0500
Received: from smtp23.cstnet.cn ([159.226.251.23]:60738 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235118AbhLXD4E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 22:56:04 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-03 (Coremail) with SMTP id rQCowABXXVm+RMVhrsR5BA--.63259S2;
        Fri, 24 Dec 2021 11:55:42 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     davem@davemloft.net, kuba@kernel.org, thunder.leizhen@huawei.com,
        yangyingliang@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] fjes: Fix wrong check for irq
Date:   Fri, 24 Dec 2021 11:55:39 +0800
Message-Id: <20211224035539.1564861-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: rQCowABXXVm+RMVhrsR5BA--.63259S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKry5WFWkZFWxGF1rAFy7KFg_yoWDJwc_Cr
        1Iqa17Ww4UuryqkF17Kr43ZF929r4qgr10gw1vya9Yq395CasrXryDuF13Xw4UWayYyF9F
        kr9rXF1ay345AjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb48FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r48
        MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
        W8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Gr0_Cr1l
        IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUUEfO7UUUU
        U==
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because hw->hw_res.irq is unsigned, the check is useless.
Therefore, we need to correct the check by using error variable.

Fixes: db6d6afe382d ("fjes: Check for error irq")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 drivers/net/fjes/fjes_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index ebd287039a54..70fbe40a598c 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -1261,11 +1261,11 @@ static int fjes_probe(struct platform_device *plat_dev)
 	}
 	hw->hw_res.start = res->start;
 	hw->hw_res.size = resource_size(res);
-	hw->hw_res.irq = platform_get_irq(plat_dev, 0);
-	if (hw->hw_res.irq < 0) {
-		err = hw->hw_res.irq;
+
+	err = platform_get_irq(plat_dev, 0);
+	if (err < 0)
 		goto err_free_control_wq;
-	}
+	hw->hw_res.irq = err;
 
 	err = fjes_hw_init(&adapter->hw);
 	if (err)
-- 
2.25.1

