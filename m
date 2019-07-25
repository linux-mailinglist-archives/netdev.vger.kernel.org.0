Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E2F757FC
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 21:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfGYTfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 15:35:22 -0400
Received: from mga12.intel.com ([192.55.52.136]:17415 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbfGYTfS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 15:35:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jul 2019 12:35:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,307,1559545200"; 
   d="scan'208";a="254045937"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga001.jf.intel.com with ESMTP; 25 Jul 2019 12:35:15 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 0F5E3546; Thu, 25 Jul 2019 22:35:12 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sedat Dilek <sedat.dilek@credativ.de>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH v3 07/14] NFC: nxp-nci: Get rid of useless label
Date:   Thu, 25 Jul 2019 22:35:04 +0300
Message-Id: <20190725193511.64274-7-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190725193511.64274-1-andriy.shevchenko@linux.intel.com>
References: <20190725193511.64274-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return directly in ->probe() since there no special cleaning is needed.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/nfc/nxp-nci/i2c.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 6a627d1b6f85..bec9b1ea78e2 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -265,16 +265,13 @@ static int nxp_nci_i2c_probe(struct i2c_client *client,
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
 		nfc_err(&client->dev, "Need I2C_FUNC_I2C\n");
-		r = -ENODEV;
-		goto probe_exit;
+		return -ENODEV;
 	}
 
 	phy = devm_kzalloc(&client->dev, sizeof(struct nxp_nci_i2c_phy),
 			   GFP_KERNEL);
-	if (!phy) {
-		r = -ENOMEM;
-		goto probe_exit;
-	}
+	if (!phy)
+		return -ENOMEM;
 
 	phy->i2c_dev = client;
 	i2c_set_clientdata(client, phy);
@@ -298,7 +295,7 @@ static int nxp_nci_i2c_probe(struct i2c_client *client,
 	r = nxp_nci_probe(phy, &client->dev, &i2c_phy_ops,
 			  NXP_NCI_I2C_MAX_PAYLOAD, &phy->ndev);
 	if (r < 0)
-		goto probe_exit;
+		return r;
 
 	r = request_threaded_irq(client->irq, NULL,
 				 nxp_nci_i2c_irq_thread_fn,
@@ -307,7 +304,6 @@ static int nxp_nci_i2c_probe(struct i2c_client *client,
 	if (r < 0)
 		nfc_err(&client->dev, "Unable to register IRQ handler\n");
 
-probe_exit:
 	return r;
 }
 
-- 
2.20.1

