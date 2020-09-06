Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9211725EEB5
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 17:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbgIFPjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 11:39:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728986AbgIFPhl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 11:37:41 -0400
Received: from localhost.localdomain (unknown [194.230.155.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F38A420DD4;
        Sun,  6 Sep 2020 15:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599406661;
        bh=ipXNcf/TRHvf+ZR7u/TpP2y/IWKhoPj+ksZzOBS6oeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EN5QpLwReQiJ4Glm7ap6/s/E+bad2seEm2qD979OOsHwJO6NxtBNuVQWXu46iwk5I
         sb3UUYxeaQVGzwhn/yk/g0OKHsuRUBZzCte1FsF7UN0HpJnSG3crg3+F0ct4b95UNf
         r+XbvXDH1sBVNqzlUD1VNdYoeJsBOswU5qejeKUM=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-nfc@lists.01.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 3/9] nfc: s3fwrn5: Remove wrong vendor prefix from GPIOs
Date:   Sun,  6 Sep 2020 17:36:48 +0200
Message-Id: <20200906153654.2925-4-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200906153654.2925-1-krzk@kernel.org>
References: <20200906153654.2925-1-krzk@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device tree property prefix describes the vendor, which in case of
S3FWRN5 chip is Samsung.  Therefore the "s3fwrn5" prefix for "en-gpios"
and "fw-gpios" is not correct and should be deprecated.  Introduce
properly named properties for these GPIOs but still support deprecated
ones.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/nfc/s3fwrn5/i2c.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index b4eb926d220a..557279492503 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -200,13 +200,21 @@ static int s3fwrn5_i2c_parse_dt(struct i2c_client *client)
 	if (!np)
 		return -ENODEV;
 
-	phy->gpio_en = of_get_named_gpio(np, "s3fwrn5,en-gpios", 0);
-	if (!gpio_is_valid(phy->gpio_en))
-		return -ENODEV;
+	phy->gpio_en = of_get_named_gpio(np, "en-gpios", 0);
+	if (!gpio_is_valid(phy->gpio_en)) {
+		/* Support also deprecated property */
+		phy->gpio_en = of_get_named_gpio(np, "s3fwrn5,en-gpios", 0);
+		if (!gpio_is_valid(phy->gpio_en))
+			return -ENODEV;
+	}
 
-	phy->gpio_fw_wake = of_get_named_gpio(np, "s3fwrn5,fw-gpios", 0);
-	if (!gpio_is_valid(phy->gpio_fw_wake))
-		return -ENODEV;
+	phy->gpio_fw_wake = of_get_named_gpio(np, "wake-gpios", 0);
+	if (!gpio_is_valid(phy->gpio_fw_wake)) {
+		/* Support also deprecated property */
+		phy->gpio_fw_wake = of_get_named_gpio(np, "s3fwrn5,fw-gpios", 0);
+		if (!gpio_is_valid(phy->gpio_fw_wake))
+			return -ENODEV;
+	}
 
 	return 0;
 }
-- 
2.17.1

