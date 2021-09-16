Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B7140DE35
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 17:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239190AbhIPPhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 11:37:42 -0400
Received: from mx22.baidu.com ([220.181.50.185]:36842 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238146AbhIPPhm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 11:37:42 -0400
Received: from BJHW-Mail-Ex10.internal.baidu.com (unknown [10.127.64.33])
        by Forcepoint Email with ESMTPS id DF4F4EA15FE88E80F55C;
        Thu, 16 Sep 2021 23:36:19 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex10.internal.baidu.com (10.127.64.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Thu, 16 Sep 2021 23:36:19 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Thu, 16 Sep 2021 23:36:19 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] nfc: st95hf: Make use of the helper function dev_err_probe()
Date:   Thu, 16 Sep 2021 23:36:13 +0800
Message-ID: <20210916153614.16523-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex11.internal.baidu.com (172.31.51.51) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex10_2021-09-16 23:36:19:858
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
 drivers/nfc/st95hf/core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index d16cf3ff644e..8337c0e0c964 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -1087,10 +1087,9 @@ static int st95hf_probe(struct spi_device *nfc_spi_dev)
 		st95context->st95hf_supply =
 			devm_regulator_get(&nfc_spi_dev->dev,
 					   "st95hfvin");
-		if (IS_ERR(st95context->st95hf_supply)) {
-			dev_err(&nfc_spi_dev->dev, "failed to acquire regulator\n");
-			return PTR_ERR(st95context->st95hf_supply);
-		}
+		if (IS_ERR(st95context->st95hf_supply))
+			return dev_err_probe(&nfc_spi_dev->dev, PTR_ERR(st95context->st95hf_supply),
+					     "failed to acquire regulator\n");
 
 		ret = regulator_enable(st95context->st95hf_supply);
 		if (ret) {
-- 
2.25.1

