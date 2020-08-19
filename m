Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D94249CD2
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 13:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgHSL4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 07:56:06 -0400
Received: from spam.zju.edu.cn ([61.164.42.155]:41910 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728063AbgHSLys (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 07:54:48 -0400
Received: from localhost.localdomain (unknown [210.32.144.184])
        by mail-app2 (Coremail) with SMTP id by_KCgBXWZzyEj1fPjQCAg--.62095S4;
        Wed, 19 Aug 2020 19:54:30 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: Fix memleak in wilc_bus_probe
Date:   Wed, 19 Aug 2020 19:54:26 +0800
Message-Id: <20200819115426.29852-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgBXWZzyEj1fPjQCAg--.62095S4
X-Coremail-Antispam: 1UD129KBjvdXoWruFWUAw4fWF4UZrykJrWxCrg_yoWkWwb_Cr
        18XFnay34xur1jvryjkrW5ZrZIyFykuFn5Gw4Iq3yfCa1UArZ7CFWfuF43JwsIk3W09F4j
        kr4DWFyfAr4SqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb-xFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_
        JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc2xSY4AK
        67AK6r4kMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_GFWkJr1UJwCFx2IqxV
        CFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r10
        6r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxV
        WUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG
        6Fyj6rWUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r
        4UJbIYCTnIWIevJa73UjIFyTuYvjfUOKsjUUUUU
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgcLBlZdtPihowAlso
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When devm_clk_get() returns -EPROBE_DEFER, spi_priv
should be freed just like when wilc_cfg80211_init()
fails.

Fixes: 854d66df74aed ("staging: wilc1000: look for rtc_clk clock in spi mode")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 drivers/net/wireless/microchip/wilc1000/spi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index 3f19e3f38a39..a18dac0aa6b6 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -112,9 +112,10 @@ static int wilc_bus_probe(struct spi_device *spi)
 	wilc->dev_irq_num = spi->irq;
 
 	wilc->rtc_clk = devm_clk_get(&spi->dev, "rtc_clk");
-	if (PTR_ERR_OR_ZERO(wilc->rtc_clk) == -EPROBE_DEFER)
+	if (PTR_ERR_OR_ZERO(wilc->rtc_clk) == -EPROBE_DEFER) {
+		kfree(spi_priv);
 		return -EPROBE_DEFER;
-	else if (!IS_ERR(wilc->rtc_clk))
+	} else if (!IS_ERR(wilc->rtc_clk))
 		clk_prepare_enable(wilc->rtc_clk);
 
 	return 0;
-- 
2.17.1

