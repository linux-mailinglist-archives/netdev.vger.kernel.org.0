Return-Path: <netdev+bounces-8968-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 814A07266CB
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:10:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE54F1C20DD2
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:10:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D6163733C;
	Wed,  7 Jun 2023 17:10:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE123732E
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:10:07 +0000 (UTC)
Received: from knopi.disroot.org (knopi.disroot.org [178.21.23.139])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7199F1FCF;
	Wed,  7 Jun 2023 10:10:05 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id C086F402E6;
	Wed,  7 Jun 2023 19:01:37 +0200 (CEST)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from knopi.disroot.org ([127.0.0.1])
	by localhost (disroot.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eqpLI8lZY9kl; Wed,  7 Jun 2023 19:01:36 +0200 (CEST)
From: Marco Giorgi <giorgi.marco.96@disroot.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1686157296; bh=VWIGXKJBaSPk62uMp1JJvhDaUo0SD9DpzLcl/ZxKKCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PhPhjMujy68M7L+PDm7zQuoDsYOGB88WB/E74ugTJg3+NFOAFqxgXtY2XWVuxzmwL
	 zBsE8ndZ8P9tuY7W/dFCc9kMU3xfhmktfklWOxJqMhX9GePiw2oYuXIScuerQ7oGyS
	 X+4DfO4vsmBOyL5Cw9niwujhiXI64cqhRaHpxS9cEwMZc9WCYEmDovxsSxBfuWspan
	 DkJXMXo5tJYCb3S8kXwSfFbpZhHF/r9ZztdXifsZWC+N5D+gkYRSN7hrazMH9HPOx3
	 FabJsd15K/MsNV+F+oFxArq+XdKsoGXmorc9o3K4YLATgyV/WWamrSpFwL6WCn2fJp
	 5TN4dfRaWD1xw==
To: netdev@vger.kernel.org
Cc: krzysztof.kozlowski@linaro.org,
	u.kleine-koenig@pengutronix.de,
	davem@davemloft.net,
	michael@walle.cc,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	Marco Giorgi <giorgi.marco.96@disroot.org>
Subject: [PATCH RFC net 2/2] nfc: nxp-nci: Fix i2c read on ThinkPad hardware
Date: Wed,  7 Jun 2023 19:00:09 +0200
Message-ID: <20230607170009.9458-3-giorgi.marco.96@disroot.org>
In-Reply-To: <20230607170009.9458-1-giorgi.marco.96@disroot.org>
References: <20230607170009.9458-1-giorgi.marco.96@disroot.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Read IRQ GPIO value and exit from IRQ if the device is not ready.

Signed-off-by: Marco Giorgi <giorgi.marco.96@disroot.org>
---
 drivers/nfc/nxp-nci/i2c.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 4ba26a958258..d40a640c64d6 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -148,6 +148,16 @@ static int nxp_nci_i2c_nci_read(struct nxp_nci_i2c_phy *phy,
 	struct i2c_client *client = phy->i2c_dev;
 	int r;
 
+	r = gpiod_get_value(phy->gpiod_irq);
+	if (r < 0) {
+		nfc_err(&client->dev, "Error reading IRQ GPIO\n");
+		goto nci_read_exit;
+	}
+	if (r != 1) { /* Device is busy, go out */
+		r = -EBUSY;
+		goto nci_read_exit;
+	}
+
 	r = i2c_master_recv(client, (u8 *) &header, NCI_CTRL_HDR_SIZE);
 	if (r < 0) {
 		goto nci_read_exit;
@@ -226,6 +236,9 @@ static irqreturn_t nxp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
 		break;
 	}
 
+	if (r == -EBUSY) {
+		goto exit_irq_handled;
+	}
 	if (r == -EREMOTEIO) {
 		phy->hard_fault = r;
 		if (info->mode == NXP_NCI_MODE_FW)
-- 
2.41.0


