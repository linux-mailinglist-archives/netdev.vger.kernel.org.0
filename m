Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CE540DE36
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 17:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239257AbhIPPhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 11:37:53 -0400
Received: from mx24.baidu.com ([111.206.215.185]:36928 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238146AbhIPPht (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 11:37:49 -0400
Received: from BJHW-Mail-Ex13.internal.baidu.com (unknown [10.127.64.36])
        by Forcepoint Email with ESMTPS id 5D66053E3965FAC9A189;
        Thu, 16 Sep 2021 23:36:27 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Thu, 16 Sep 2021 23:36:27 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Thu, 16 Sep 2021 23:36:26 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Mark Greer <mgreer@animalcreek.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] nfc: trf7970a: Make use of the helper function dev_err_probe()
Date:   Thu, 16 Sep 2021 23:36:21 +0800
Message-ID: <20210916153621.16576-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex09.internal.baidu.com (172.31.51.49) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex13_2021-09-16 23:36:27:470
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When possible use dev_err_probe help to properly deal with the
PROBE_DEFER error, the benefit is that DEFER issue will be logged
in the devices_deferred debugfs file.
Using dev_err_probe() can reduce code size, and the error value
gets printed.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/nfc/trf7970a.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 8890fcd59c39..8459a2735f2c 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -2067,8 +2067,8 @@ static int trf7970a_probe(struct spi_device *spi)
 
 	trf->regulator = devm_regulator_get(&spi->dev, "vin");
 	if (IS_ERR(trf->regulator)) {
-		ret = PTR_ERR(trf->regulator);
-		dev_err(trf->dev, "Can't get VIN regulator: %d\n", ret);
+		ret = dev_err_probe(trf->dev, PTR_ERR(trf->regulator),
+				    "Can't get VIN regulator\n");
 		goto err_destroy_lock;
 	}
 
@@ -2084,8 +2084,8 @@ static int trf7970a_probe(struct spi_device *spi)
 
 	trf->regulator = devm_regulator_get(&spi->dev, "vdd-io");
 	if (IS_ERR(trf->regulator)) {
-		ret = PTR_ERR(trf->regulator);
-		dev_err(trf->dev, "Can't get VDD_IO regulator: %d\n", ret);
+		ret = dev_err_probe(trf->dev, PTR_ERR(trf->regulator),
+				    "Can't get VDD_IO regulator\n");
 		goto err_destroy_lock;
 	}
 
-- 
2.25.1

