Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5CF7378100
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 12:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhEJKPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 06:15:48 -0400
Received: from fgw23-7.mail.saunalahti.fi ([62.142.5.84]:37912 "EHLO
        fgw23-7.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230151AbhEJKPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 06:15:35 -0400
Received: from localhost (88-115-248-186.elisa-laajakaista.fi [88.115.248.186])
        by fgw23.mail.saunalahti.fi (Halon) with ESMTP
        id 3b2b3978-b176-11eb-8ccd-005056bdfda7;
        Mon, 10 May 2021 12:58:12 +0300 (EEST)
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH net-next v1 2/4] net: mvpp2: Use device_get_match_data() helper
Date:   Mon, 10 May 2021 12:58:06 +0300
Message-Id: <20210510095808.3302997-2-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510095808.3302997-1-andy.shevchenko@gmail.com>
References: <20210510095808.3302997-1-andy.shevchenko@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Use the device_get_match_data() helper instead of open coding.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index b48c08829a31..6bfad75c4087 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -7311,7 +7311,6 @@ static int mvpp2_get_sram(struct platform_device *pdev,
 
 static int mvpp2_probe(struct platform_device *pdev)
 {
-	const struct acpi_device_id *acpi_id;
 	struct fwnode_handle *fwnode = pdev->dev.fwnode;
 	struct fwnode_handle *port_fwnode;
 	struct mvpp2 *priv;
@@ -7324,16 +7323,7 @@ static int mvpp2_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
-	if (has_acpi_companion(&pdev->dev)) {
-		acpi_id = acpi_match_device(pdev->dev.driver->acpi_match_table,
-					    &pdev->dev);
-		if (!acpi_id)
-			return -EINVAL;
-		priv->hw_version = (unsigned long)acpi_id->driver_data;
-	} else {
-		priv->hw_version =
-			(unsigned long)of_device_get_match_data(&pdev->dev);
-	}
+	priv->hw_version = (unsigned long)device_get_match_data(&pdev->dev);
 
 	/* multi queue mode isn't supported on PPV2.1, fallback to single
 	 * mode
-- 
2.31.1

