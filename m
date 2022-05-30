Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082FD537C7C
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 15:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236940AbiE3NbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237104AbiE3NaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:30:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550BBB3B;
        Mon, 30 May 2022 06:26:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C64DB80DA7;
        Mon, 30 May 2022 13:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB182C3411E;
        Mon, 30 May 2022 13:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917186;
        bh=TR74+tfIx5LPTfO6NYsObBj1oQozGcliwE9T2Z1bW0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F18ijXCltInlSOygQazdR8rxx2VKVcssT3RvNRsm2izs43uc/CkXqbMyrB6LpZacs
         uvRMQr8EO7Es68H90nGpayoHWf3WyP+ro4qXXH7KDS7pjfsg+WQOJoX3B/WZzXawVn
         RaOwJXbZGSpAm26hnjxPH0hJR34H0fc8xGmW1BpA1mlq5t5cPtGlL+U+BIvuqkCb9U
         HkescsjzTaHz0/SyECIzUClcpw8flZMAAp/wcY7Ozh8VKOG16oweZiKcphY4qKKqaQ
         t6jHjfVoPuh0RYnIPpF5ZkyzBfoHHr8IgVnFkHZv/ZATAM8dHV8nMJpICBAeme9Ynd
         GOMe2ds/g2Y0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 046/159] net: macb: In ZynqMP initialization make SGMII phy configuration optional
Date:   Mon, 30 May 2022 09:22:31 -0400
Message-Id: <20220530132425.1929512-46-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

[ Upstream commit 29e96fe9e0ec0f0fe1dd306a4ccb7b8983eae67a ]

In the macb binding documentation "phys" is an optional property. Make
implementation in line with it. This change allows the traditional flow
in which first stage bootloader does PS-GT configuration to work along
with newer use cases in which PS-GT configuration is managed by the
phy-zynqmp driver.

It fixes below macb probe failure when macb DT node doesn't have SGMII
phys handle.
"macb ff0b0000.ethernet: error -ENODEV: failed to get PS-GTR PHY"

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Reviewed-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 61284baa0496..ed7c2c2c4401 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4594,7 +4594,7 @@ static int zynqmp_init(struct platform_device *pdev)
 
 	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
 		/* Ensure PS-GTR PHY device used in SGMII mode is ready */
-		bp->sgmii_phy = devm_phy_get(&pdev->dev, "sgmii-phy");
+		bp->sgmii_phy = devm_phy_optional_get(&pdev->dev, NULL);
 
 		if (IS_ERR(bp->sgmii_phy)) {
 			ret = PTR_ERR(bp->sgmii_phy);
-- 
2.35.1

