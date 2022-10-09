Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B305F9130
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbiJIWaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbiJIW2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:28:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768FD3C8F6;
        Sun,  9 Oct 2022 15:19:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4ED7B80DF9;
        Sun,  9 Oct 2022 22:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFE7C433D6;
        Sun,  9 Oct 2022 22:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353752;
        bh=Kh8Sla+Un1KkjfHIh8LWbAk/NpfHmZyyc25lnnifXUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUcRAcWR2CeggCjUxjgdpWhPg9VyAZRCpVJtEiL0LhVepy68NgMRq5Ha2lbxlxLu6
         khYcWx5yNXpHs0C78ltotAkMGZ/JY956UTnIlvxJYR2Bu9H2hdBbSBcoBfMw9pPtXT
         tfzn0S3wQV1y4oOQgrjOd5b9B6gHX00qsukDrZdm91KWPLouAhj6uxiCQAxCkgtijI
         SYMXPRbqmoa6AZw6x10f64NqhJ7+vIZsC6TwBYIkMZkHJo5ucLchWpTW3TjgiQ2jG5
         xFxgkwYIIjSzS2AK5IbQxox8+TweUmWbd+wpTU6wsKTnROgDo/j0IhUDlaglc9ZaVF
         w7M4pDRW97vpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jerry Ray <jerry.ray@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, u.kleine-koenig@pengutronix.de,
        marcus.folkesson@gmail.com, lee.jones@linaro.org,
        stefan@datenfreihafen.org, bigeasy@linutronix.de,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 13/73] micrel: ksz8851: fixes struct pointer issue
Date:   Sun,  9 Oct 2022 18:13:51 -0400
Message-Id: <20221009221453.1216158-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
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
index 82d55fc27edc..70bc7253454f 100644
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

