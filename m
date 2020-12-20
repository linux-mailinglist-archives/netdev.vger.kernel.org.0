Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E87A2DF477
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 09:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgLTIgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 03:36:51 -0500
Received: from mail.zju.edu.cn ([61.164.42.155]:45724 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727010AbgLTIgu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Dec 2020 03:36:50 -0500
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Dec 2020 03:36:49 EST
Received: from localhost.localdomain (unknown [10.192.85.18])
        by mail-app3 (Coremail) with SMTP id cC_KCgAXzw5qC99fGvNYAA--.32924S4;
        Sun, 20 Dec 2020 16:29:34 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: mvneta: Fix error handling in mvneta_probe
Date:   Sun, 20 Dec 2020 16:29:30 +0800
Message-Id: <20201220082930.21623-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgAXzw5qC99fGvNYAA--.32924S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Xw13ZF4DJF1DCF1UuryUZFb_yoWfZrcEgr
        WxuFs3Ww45Kryjyw1jyr45C34Ik3Z8XF1vyFsrtFZ3tayxJ3Wjqr1v9FZ2vryDWw40qF9r
        Ar42vrZIy3s3tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbcxFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxF
        aVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
        4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxG
        rwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8Jw
        CI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgUMBlZdtRf+rwAKs-
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When mvneta_port_power_up() fails, we should execute
cleanup functions after label err_netdev to avoid memleak.

Fixes: 41c2b6b4f0f80 ("net: ethernet: mvneta: Add back interface mode validation")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 563ceac3060f..3369ec717a51 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5255,7 +5255,7 @@ static int mvneta_probe(struct platform_device *pdev)
 	err = mvneta_port_power_up(pp, pp->phy_interface);
 	if (err < 0) {
 		dev_err(&pdev->dev, "can't power up port\n");
-		return err;
+		goto err_netdev;
 	}
 
 	/* Armada3700 network controller does not support per-cpu
-- 
2.17.1

