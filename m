Return-Path: <netdev+bounces-8969-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD5507266CC
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:10:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7961A281234
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E8573733E;
	Wed,  7 Jun 2023 17:10:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751423733A
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:10:08 +0000 (UTC)
Received: from knopi.disroot.org (knopi.disroot.org [178.21.23.139])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719F01FD5;
	Wed,  7 Jun 2023 10:10:05 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id 8752140300;
	Wed,  7 Jun 2023 19:01:28 +0200 (CEST)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from knopi.disroot.org ([127.0.0.1])
	by localhost (disroot.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d703oxH-mOcZ; Wed,  7 Jun 2023 19:01:27 +0200 (CEST)
From: Marco Giorgi <giorgi.marco.96@disroot.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1686157287; bh=BY6Z9ojxQfEjkGc7IncC1FOtcZSuNta18wrMt1D3has=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ESsuo3rWcseMtP1WvA6yvRy5G3VjESh+r+lHC2rIBizpE4nEawyXzonv7jsSllgY/
	 8VZXFL+r6MrU5Rz8WSc7BNPqFdNQIF68RwK3NLNDZfK98SXZ14+Gutj6+oD1K/24DF
	 UqLOANXuon1mHIt/xoxq2ookMU15rUID2lnpD+ZnwquT0z6N4qBMoLPrWDA50FZDOE
	 /Lj1STUgCE9HYt/yGhHgIqL564grjsaYr4J0v17yNYCMOOmvH4rQw50mFDKZGQ4ErO
	 Q5hcWaP2aZXRjJlHVbunogGQWt5yE1rFwzelQ7oqIadN2Gjb0hUH0LcFXxEmIQ8j7t
	 hPDs8Sj0kzjVQ==
To: netdev@vger.kernel.org
Cc: krzysztof.kozlowski@linaro.org,
	u.kleine-koenig@pengutronix.de,
	davem@davemloft.net,
	michael@walle.cc,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	Marco Giorgi <giorgi.marco.96@disroot.org>
Subject: [PATCH RFC net 1/2] nfc: nxp-nci: Fix i2c read on ThinkPad hardware
Date: Wed,  7 Jun 2023 19:00:08 +0200
Message-ID: <20230607170009.9458-2-giorgi.marco.96@disroot.org>
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

Add the IRQ GPIO configuration.

Signed-off-by: Marco Giorgi <giorgi.marco.96@disroot.org>
---
 drivers/nfc/nxp-nci/i2c.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index d4c299be7949..4ba26a958258 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -35,6 +35,7 @@ struct nxp_nci_i2c_phy {
 
 	struct gpio_desc *gpiod_en;
 	struct gpio_desc *gpiod_fw;
+	struct gpio_desc *gpiod_irq;
 
 	int hard_fault; /*
 			 * < 0 if hardware error occurred (e.g. i2c err)
@@ -254,10 +255,12 @@ static irqreturn_t nxp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
 	return IRQ_NONE;
 }
 
+static const struct acpi_gpio_params irq_gpios = { 0, 0, false };
 static const struct acpi_gpio_params firmware_gpios = { 1, 0, false };
 static const struct acpi_gpio_params enable_gpios = { 2, 0, false };
 
 static const struct acpi_gpio_mapping acpi_nxp_nci_gpios[] = {
+	{ "irq-gpios", &irq_gpios, 1 },
 	{ "enable-gpios", &enable_gpios, 1 },
 	{ "firmware-gpios", &firmware_gpios, 1 },
 	{ }
@@ -286,6 +289,12 @@ static int nxp_nci_i2c_probe(struct i2c_client *client)
 	if (r)
 		dev_dbg(dev, "Unable to add GPIO mapping table\n");
 
+	phy->gpiod_irq = devm_gpiod_get(dev, "irq", GPIOD_IN);
+	if (IS_ERR(phy->gpiod_irq)) {
+		nfc_err(dev, "Failed to get IRQ gpio\n");
+		return PTR_ERR(phy->gpiod_irq);
+	}
+
 	phy->gpiod_en = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
 	if (IS_ERR(phy->gpiod_en)) {
 		nfc_err(dev, "Failed to get EN gpio\n");
-- 
2.41.0


