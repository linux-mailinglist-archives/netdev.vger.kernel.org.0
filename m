Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D5247EB86
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 06:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237702AbhLXFSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 00:18:18 -0500
Received: from smtp21.cstnet.cn ([159.226.251.21]:53954 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229946AbhLXFSS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Dec 2021 00:18:18 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-01 (Coremail) with SMTP id qwCowADn7lYCWMVhLjcBBQ--.62077S2;
        Fri, 24 Dec 2021 13:17:54 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     davem@davemloft.net, kuba@kernel.org,
        u.kleine-koenig@pengutronix.de, marex@denx.de, trix@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] net: ks8851: Fix wrong check for irq
Date:   Fri, 24 Dec 2021 13:17:53 +0800
Message-Id: <20211224051753.1565175-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: qwCowADn7lYCWMVhLjcBBQ--.62077S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKr4rKrWxAr45XF4DAw4DCFg_yoWDJrbEkw
        109F13Xr4DAFyYvr4Utr1akr9Y9F1DXr1kZF97ta9a93s8A347XrykZrWrXw4kW34UGFZr
        WFnF9FW7u34IvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbc8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8WwCF
        04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr
        1lIxAIcVCF04k26cxKx2IYs7xG6Fyj6rWUJwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY
        6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYPEfDUUUU
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because netdev->irq is unsigned, the check is useless.
Therefore, we need to correct the check by using error variable.

Fixes: 99d7fbb5cedf ("net: ks8851: Check for error irq")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 drivers/net/ethernet/micrel/ks8851_par.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_par.c b/drivers/net/ethernet/micrel/ks8851_par.c
index 7f49042484bd..2f3c67c35b18 100644
--- a/drivers/net/ethernet/micrel/ks8851_par.c
+++ b/drivers/net/ethernet/micrel/ks8851_par.c
@@ -320,9 +320,10 @@ static int ks8851_probe_par(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	netdev->irq = platform_get_irq(pdev, 0);
-	if (netdev->irq < 0)
-		return netdev->irq;
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		return ret;
+	netdev->irq = ret;
 
 	return ks8851_probe_common(netdev, dev, msg_enable);
 }
-- 
2.25.1

