Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBF35F9165
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbiJIWcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbiJIWaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:30:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD1565D5;
        Sun,  9 Oct 2022 15:19:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E09260C19;
        Sun,  9 Oct 2022 22:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C90BC433D7;
        Sun,  9 Oct 2022 22:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353979;
        bh=Ejg/7v+bTZwcGpmt1+OnZNJ4KHsjbu7qwQON1oiugCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sAM8Nl0gHE8qcwO7LImF4c1BqauYjwGIcyKDtqHHazADOwtAgrugWuTtq7vChu/05
         msQKFJ/bEFR9pb4Rq0jmFjQNLtVKcQ1ntvkJnaD7GQ4CTKiSZuhE3VVr1lcFsKS4/M
         r9/dPUOMY0V/QDlMUMsHABspyVqmhLxFoScDigg1n2MdvJGLFfSTbIRXgrs5JVurm6
         vO/+J6s+sZQCt4/gsO5YQGJOH29fqjcm1WHoRTWawZ6O8dXnP6Oc9OCLMsjL8AqMhY
         kOp2lYWFxqW7uktJz/Mlev+rqWKnuvvVJGwVvubvOnBXbx73XzhXXturi7wu5Ce0Rx
         FjSku2oCbhNMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jerry Ray <jerry.ray@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, u.kleine-koenig@pengutronix.de,
        stefan@datenfreihafen.org, mkl@pengutronix.de,
        bigeasy@linutronix.de, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 09/46] micrel: ksz8851: fixes struct pointer issue
Date:   Sun,  9 Oct 2022 18:18:34 -0400
Message-Id: <20221009221912.1217372-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221912.1217372-1-sashal@kernel.org>
References: <20221009221912.1217372-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jerry Ray <jerry.ray@microchip.com>

[ Upstream commit fef5de753ff01887cfa50990532c3890fccb9338 ]

Issue found during code review. This bug has no impact as long as the
ks8851_net structure is the first element of the ks8851_net_spi structure.
As long as the offset to the ks8851_net struct is zero, the container_of()
macro is subtracting 0 and therefore no damage done. But if the
ks8851_net_spi struct is ever modified such that the ks8851_net struct
within it is no longer the first element of the struct, then the bug would
manifest itself and cause problems.

struct ks8851_net is contained within ks8851_net_spi.
ks is contained within kss.
kss is the priv_data of the netdev structure.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ks8851_spi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_spi.c b/drivers/net/ethernet/micrel/ks8851_spi.c
index 479406ecbaa3..13c76352ae8d 100644
--- a/drivers/net/ethernet/micrel/ks8851_spi.c
+++ b/drivers/net/ethernet/micrel/ks8851_spi.c
@@ -413,7 +413,8 @@ static int ks8851_probe_spi(struct spi_device *spi)
 
 	spi->bits_per_word = 8;
 
-	ks = netdev_priv(netdev);
+	kss = netdev_priv(netdev);
+	ks = &kss->ks8851;
 
 	ks->lock = ks8851_lock_spi;
 	ks->unlock = ks8851_unlock_spi;
@@ -433,8 +434,6 @@ static int ks8851_probe_spi(struct spi_device *spi)
 		 IRQ_RXPSI)	/* RX process stop */
 	ks->rc_ier = STD_IRQ;
 
-	kss = to_ks8851_spi(ks);
-
 	kss->spidev = spi;
 	mutex_init(&kss->lock);
 	INIT_WORK(&kss->tx_work, ks8851_tx_work);
-- 
2.35.1

