Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4212E1B6C
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 12:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgLWLHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 06:07:33 -0500
Received: from mail.zju.edu.cn ([61.164.42.155]:28352 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728305AbgLWLHb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 06:07:31 -0500
Received: from localhost.localdomain (unknown [10.192.85.18])
        by mail-app4 (Coremail) with SMTP id cS_KCgAHP3yhJONfjUsAAA--.469S4;
        Wed, 23 Dec 2020 19:06:13 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: Fix memleak in ethoc_probe
Date:   Wed, 23 Dec 2020 19:06:12 +0800
Message-Id: <20201223110615.31389-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgAHP3yhJONfjUsAAA--.469S4
X-Coremail-Antispam: 1UD129KBjvdXoW7JFW8Ary5uFW3XFW5ur1kGrg_yoWDGFc_Kw
        1IvrsYqr4rGF93Cw4UCr4UX34qkrs5Zr18Ars3KayYq3sxXF4UZrZ7Zrn3CF15Wr4IkF9F
        v3sFvr4xC342kjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbc8Fc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vEx4A2
        jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
        x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
        GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
        8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv
        6cx26r4fKr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGw
        C20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48J
        MIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMI
        IF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY
        6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgkDBlZdtRp0WwARsU
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When mdiobus_register() fails, priv->mdio allocated
by mdiobus_alloc() has not been freed, which leads
to memleak.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 drivers/net/ethernet/ethoc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index 0981fe9652e5..3d9b0b161e24 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -1211,7 +1211,7 @@ static int ethoc_probe(struct platform_device *pdev)
 	ret = mdiobus_register(priv->mdio);
 	if (ret) {
 		dev_err(&netdev->dev, "failed to register MDIO bus\n");
-		goto free2;
+		goto free3;
 	}
 
 	ret = ethoc_mdio_probe(netdev);
@@ -1243,6 +1243,7 @@ static int ethoc_probe(struct platform_device *pdev)
 	netif_napi_del(&priv->napi);
 error:
 	mdiobus_unregister(priv->mdio);
+free3:
 	mdiobus_free(priv->mdio);
 free2:
 	clk_disable_unprepare(priv->clk);
-- 
2.17.1

