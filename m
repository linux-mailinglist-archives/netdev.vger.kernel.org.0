Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A30895278D8
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 19:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237836AbiEORCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 13:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237829AbiEORCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 13:02:06 -0400
Received: from smtp.smtpout.orange.fr (smtp05.smtpout.orange.fr [80.12.242.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D6812A92
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 10:02:02 -0700 (PDT)
Received: from pop-os.home ([86.243.180.246])
        by smtp.orange.fr with ESMTPA
        id qHd0n1JemFyeGqHd0n8uTs; Sun, 15 May 2022 19:02:00 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 15 May 2022 19:02:00 +0200
X-ME-IP: 86.243.180.246
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] net: systemport: Fix an error handling path in bcm_sysport_probe()
Date:   Sun, 15 May 2022 19:01:56 +0200
Message-Id: <99d70634a81c229885ae9e4ee69b2035749f7edc.1652634040.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if devm_clk_get_optional() fails, we still need to go through the error
handling path.

Add the missing goto.

Fixes: 6328a126896ea ("net: systemport: Manage Wake-on-LAN clock")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index f1805fb857c5..47fc8e6963d5 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2581,8 +2581,10 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 		device_set_wakeup_capable(&pdev->dev, 1);
 
 	priv->wol_clk = devm_clk_get_optional(&pdev->dev, "sw_sysportwol");
-	if (IS_ERR(priv->wol_clk))
-		return PTR_ERR(priv->wol_clk);
+	if (IS_ERR(priv->wol_clk)) {
+		ret = PTR_ERR(priv->wol_clk);
+		goto err_deregister_fixed_link;
+	}
 
 	/* Set the needed headroom once and for all */
 	BUILD_BUG_ON(sizeof(struct bcm_tsb) != 8);
-- 
2.34.1

