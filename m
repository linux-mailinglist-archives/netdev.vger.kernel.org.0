Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C682C101F
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 17:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732651AbgKWQYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 11:24:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729881AbgKWQYB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 11:24:01 -0500
Received: from localhost.localdomain (adsl-84-226-167-205.adslplus.ch [84.226.167.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBD0A2080A;
        Mon, 23 Nov 2020 16:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606148641;
        bh=aDhRfbKOcmjeCqkKU3WanABMbxUDMyrYDDPRQkOYe88=;
        h=From:To:Cc:Subject:Date:From;
        b=rEjeQOyWLOdgvVAFF7pqvYB/6aNvOawoAS6BA4nTe+900f7znL4NibKAjG+j1t2Bm
         hwc+2eYGAQazY9aDVpbi4oI+3HqVQiqAlEbxiyg+Bi/94tzBnQHA/e6SmVtVIoCTsp
         eSmL6cPECtaDW9To2sMBJUEhOpGyQuwDJSDRvetY=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] nfc: s3fwrn5: use signed integer for parsing GPIO numbers
Date:   Mon, 23 Nov 2020 17:23:51 +0100
Message-Id: <20201123162351.209100-1-krzk@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GPIOs - as returned by of_get_named_gpio() and used by the gpiolib - are
signed integers, where negative number indicates error.  The return
value of of_get_named_gpio() should not be assigned to an unsigned int
because in case of !CONFIG_GPIOLIB such number would be a valid GPIO.

Fixes: c04c674fadeb ("nfc: s3fwrn5: Add driver for Samsung S3FWRN5 NFC Chip")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/nfc/s3fwrn5/i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index 0ffa389066a0..ae26594c7302 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -25,8 +25,8 @@ struct s3fwrn5_i2c_phy {
 	struct i2c_client *i2c_dev;
 	struct nci_dev *ndev;
 
-	unsigned int gpio_en;
-	unsigned int gpio_fw_wake;
+	int gpio_en;
+	int gpio_fw_wake;
 
 	struct mutex mutex;
 
-- 
2.25.1

