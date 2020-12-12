Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820FF2D8934
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 19:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439709AbgLLSVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 13:21:52 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:21671 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407719AbgLLSVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 13:21:52 -0500
Received: from localhost.localdomain ([93.22.39.196])
        by mwinf5d05 with ME
        id 3WL42400A4Dvdm503WL4id; Sat, 12 Dec 2020 19:20:08 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 12 Dec 2020 19:20:08 +0100
X-ME-IP: 93.22.39.196
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: bcmgenet: Fix a resource leak in an error handling path in the probe functin
Date:   Sat, 12 Dec 2020 19:20:05 +0100
Message-Id: <20201212182005.120437-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the 'register_netdev()' call fails, we must undo a previous
'bcmgenet_mii_init()' call.

Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
The missing 'bcmgenet_mii_exit()' call is added here, instead of in the
error handling path in order to avoid some goto spaghetti code.
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index be85dad2e3bc..fcca023f22e5 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4069,8 +4069,10 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	clk_disable_unprepare(priv->clk);
 
 	err = register_netdev(dev);
-	if (err)
+	if (err) {
+		bcmgenet_mii_exit(dev);
 		goto err;
+	}
 
 	return err;
 
-- 
2.27.0

