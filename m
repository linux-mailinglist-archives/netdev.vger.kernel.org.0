Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE39A1174FE
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfLIS6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:58:01 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.166]:12586 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfLIS6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:58:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1575917879;
        s=strato-dkim-0002; d=gerhold.net;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=czq/YCH1Wj+z8SCk2D48pp2Ovd1i9tjA7B44VhwG0Ns=;
        b=Npg42W3hiy0iJ0KtZRgNu29tY52cjwqRzXaRo6r/0K1O6ksXxksDih4040bXYnytby
        Rtg4RCRkT+ywC9yG7+edj99g64HnK9Zy9EQ05pm9SdHdXFCDziqtSrOqelczlCBnvT7z
        AMAwoH1ty98BdMJEzG5svctVgKf+uVWjFJSyvumxu2K+yxWZaoZOCcVpNGZ+m2NtJtpx
        l0PuRwlPDPxLLIS/EwPVOt7JhU+6kf92/uTAFLI1EQm5ORDmt63JVEDGtkb6ATkEITK3
        T8UlJC7FegtNfYKF7MTKANQB/IzRPHLDxaNTPLOPsQVZSTq4G/KACTw4Ins4Hra/mIJZ
        DIBA==
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXQr4OGUPX+1JiWAnI+L0="
X-RZG-CLASS-ID: mo00
Received: from localhost.localdomain
        by smtp.strato.de (RZmta 46.0.2 DYNA|AUTH)
        with ESMTPSA id R01a59vB9IswbS2
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 9 Dec 2019 19:54:58 +0100 (CET)
From:   Stephan Gerhold <stephan@gerhold.net>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stephan Gerhold <stephan@gerhold.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] NFC: nxp-nci: Fix probing without ACPI
Date:   Mon,  9 Dec 2019 19:53:43 +0100
Message-Id: <20191209185343.215893-1-stephan@gerhold.net>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devm_acpi_dev_add_driver_gpios() returns -ENXIO if CONFIG_ACPI
is disabled (e.g. on device tree platforms).
In this case, nxp-nci will silently fail to probe.

The other NFC drivers only log a debug message if
devm_acpi_dev_add_driver_gpios() fails.
Do the same in nxp-nci to fix this problem.

Fixes: ad0acfd69add ("NFC: nxp-nci: Get rid of code duplication in ->probe()")
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
---
 drivers/nfc/nxp-nci/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 4d1909aecd6c..9f60e4dc5a90 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -278,7 +278,7 @@ static int nxp_nci_i2c_probe(struct i2c_client *client,
 
 	r = devm_acpi_dev_add_driver_gpios(dev, acpi_nxp_nci_gpios);
 	if (r)
-		return r;
+		dev_dbg(dev, "Unable to add GPIO mapping table\n");
 
 	phy->gpiod_en = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
 	if (IS_ERR(phy->gpiod_en)) {
-- 
2.24.0

