Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358FA24EC4A
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 10:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgHWI5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 04:57:14 -0400
Received: from mail.zju.edu.cn ([61.164.42.155]:24282 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726231AbgHWI5O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 04:57:14 -0400
Received: from localhost.localdomain (unknown [210.32.144.184])
        by mail-app2 (Coremail) with SMTP id by_KCgBHF7xSL0JfbI8cAg--.24790S4;
        Sun, 23 Aug 2020 16:56:53 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Caesar Wang <wxt@rock-chips.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: arc_emac: Fix memleak in arc_mdio_probe
Date:   Sun, 23 Aug 2020 16:56:47 +0800
Message-Id: <20200823085650.912-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgBHF7xSL0JfbI8cAg--.24790S4
X-Coremail-Antispam: 1UD129KBjvdXoWruryfCrWrGrW8GrWfKF4DArb_yoW3twcEkr
        1rXwnaga1akrn09w1j9r47Wryjk3Z8XrnayF4fKrWrJ3y7ZF17WF1kZryfJrnrWrn7WFyD
        tw17ZFyfC343tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbIkFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r43MxAIw28IcxkI7VAKI48J
        MxAIw28IcVCjz48v1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
        02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_
        GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
        CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE
        14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf
        9x0JUhdbbUUUUU=
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgoSBlZdtPnBhAA-sg
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When devm_gpiod_get_optional() fails, bus should be
freed just like when of_mdiobus_register() fails.

Fixes: 1bddd96cba03d ("net: arc_emac: support the phy reset for emac driver")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 drivers/net/ethernet/arc/emac_mdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/arc/emac_mdio.c b/drivers/net/ethernet/arc/emac_mdio.c
index 0187dbf3b87d..54cdafdd067d 100644
--- a/drivers/net/ethernet/arc/emac_mdio.c
+++ b/drivers/net/ethernet/arc/emac_mdio.c
@@ -153,6 +153,7 @@ int arc_mdio_probe(struct arc_emac_priv *priv)
 	if (IS_ERR(data->reset_gpio)) {
 		error = PTR_ERR(data->reset_gpio);
 		dev_err(priv->dev, "Failed to request gpio: %d\n", error);
+		mdiobus_free(bus);
 		return error;
 	}
 
-- 
2.17.1

