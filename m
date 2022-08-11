Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B8F590342
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237739AbiHKQV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237899AbiHKQU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:20:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35719C22B;
        Thu, 11 Aug 2022 09:03:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EEB5613E2;
        Thu, 11 Aug 2022 16:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FA1C433B5;
        Thu, 11 Aug 2022 16:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233791;
        bh=Sp5JihRVAfi7GOifL1NK2AOKdWRE7r9oXZwdCzXYjwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SaRy/W/v3FSPsADUbjzBUltkhhM2a/DuVuK2QBAL4PBX+H82sZqTFuNbkGHAgsM4N
         lhKSIlMe7fTfiLiPVNPXfzZOWEc7FDNy7XFFJoZpOLUjo2p7mXNcp6hZmyBHM2LFF5
         JwAuvhAfDJX9K3RPOqJ3H4uksTPYFyELSq/o6QfBvGHTmMlaWWcguySIu2HU9eEaOY
         4Ru6EhG5ntMu4xlkLUDxHp4GWnUG12axqwljav7yjN5NFU/dTUqcE5JMN4mOEocxWr
         96JufYfjX5JDgg9O1A+hhWsKosLQmubud1NFUWK9+1GOH1teVb40QrbbzETb7H+uWP
         Qrb+RMGwxflhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, wg@grandegger.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mailhol.vincent@wanadoo.fr,
        stefan.maetje@esd.eu, socketcan@hartkopp.net,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 55/69] can: sja1000: Add Quirk for RZ/N1 SJA1000 CAN controller
Date:   Thu, 11 Aug 2022 11:56:04 -0400
Message-Id: <20220811155632.1536867-55-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811155632.1536867-1-sashal@kernel.org>
References: <20220811155632.1536867-1-sashal@kernel.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 2d99bfbf3386962692dcccd73931cb0db07a1a43 ]

As per Chapter 6.5.16 of the RZ/N1 Peripheral Manual, The SJA1000
CAN controller does not support Clock Divider Register compared to
the reference Philips SJA1000 device.

This patch adds a device quirk to handle this difference.

Link: https://lore.kernel.org/all/20220710115248.190280-4-biju.das.jz@bp.renesas.com
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/sja1000/sja1000.c | 8 +++++---
 drivers/net/can/sja1000/sja1000.h | 3 ++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 3fad54646746..225db8c124d3 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -184,8 +184,9 @@ static void chipset_init(struct net_device *dev)
 {
 	struct sja1000_priv *priv = netdev_priv(dev);
 
-	/* set clock divider and output control register */
-	priv->write_reg(priv, SJA1000_CDR, priv->cdr | CDR_PELICAN);
+	if (!(priv->flags & SJA1000_QUIRK_NO_CDR_REG))
+		/* set clock divider and output control register */
+		priv->write_reg(priv, SJA1000_CDR, priv->cdr | CDR_PELICAN);
 
 	/* set acceptance filter (accept all) */
 	priv->write_reg(priv, SJA1000_ACCC0, 0x00);
@@ -210,7 +211,8 @@ static void sja1000_start(struct net_device *dev)
 		set_reset_mode(dev);
 
 	/* Initialize chip if uninitialized at this stage */
-	if (!(priv->read_reg(priv, SJA1000_CDR) & CDR_PELICAN))
+	if (!(priv->flags & SJA1000_QUIRK_NO_CDR_REG ||
+	      priv->read_reg(priv, SJA1000_CDR) & CDR_PELICAN))
 		chipset_init(dev);
 
 	/* Clear error counters and error code capture */
diff --git a/drivers/net/can/sja1000/sja1000.h b/drivers/net/can/sja1000/sja1000.h
index 9d46398f8154..7f736f1df547 100644
--- a/drivers/net/can/sja1000/sja1000.h
+++ b/drivers/net/can/sja1000/sja1000.h
@@ -145,7 +145,8 @@
 /*
  * Flags for sja1000priv.flags
  */
-#define SJA1000_CUSTOM_IRQ_HANDLER 0x1
+#define SJA1000_CUSTOM_IRQ_HANDLER	BIT(0)
+#define SJA1000_QUIRK_NO_CDR_REG	BIT(1)
 
 /*
  * SJA1000 private data structure
-- 
2.35.1

