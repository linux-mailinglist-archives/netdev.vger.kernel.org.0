Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79F30121F0D
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 00:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfLPXjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 18:39:07 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34839 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfLPXjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 18:39:06 -0500
Received: by mail-pg1-f196.google.com with SMTP id l24so4610596pgk.2
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 15:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fE7hZh0hQhl5YAtLL3Xf5ol7YwdY/D2+Oyjz61bF8qE=;
        b=IbedSCJ5OUTJL5Of4O+8UDu1C5w6oSYYmO7Xg7PoXwqFxndLuet1UGP/wn18UkomUx
         Dd1zGn0izyUTpqj+3VqhRnB7LI9pdBofdhMlIAm+hdbg0D8nYefkrCsk6ftIAcAjc8U/
         vCX72vzZWRE5lv0l1yvirQQB3sJ/dAC+QvIdiBAi2yaTC4kY4QXrFSNw2uZjnKUS1hOA
         sExPejINiBf7kHDC5/Y86EyhgBN4Ci9vRqfskHf1KfZSFE+FpdPb2KHPC2uWCX722n7Q
         MAXJ3UZELXMUyLKISFL4DIq3XKMA6mIL1aGX1YcUKR5eeA8J2luxuqW8vVpouokrVdhh
         k0Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fE7hZh0hQhl5YAtLL3Xf5ol7YwdY/D2+Oyjz61bF8qE=;
        b=PlcOCqfNLp65vKKsSvvXYmNDIVlFR7BwmmYBTro7aO/Y3JUYRwChyiApSUyfBfmAXS
         hlpju7t+zPRp632url+watomHP6s+5OwY9I7wM3SUQo6Dd/4xBD1zHyS0U4xi3WjQmtU
         NzMD+mXUxC6yhyIsCn7jPw/EJYE278GCKkk9RBQmrHdOPP6buKQtcDqsnemJ0bhIU+ZK
         UEdfTUUPPrhZuJ1hW9ieNudhd0zICZMCP4GDxHjdUWYs4itJKqT0BEYLU+Kw9vFoAogA
         eUkdl9zwpN9VnPc9+YcQkpg7JUgNlhRpb4cIZpUhOZXZyRF0o6t4GqvVXu2IBAOS0n7i
         o/iA==
X-Gm-Message-State: APjAAAVrVBee+7vmqFfi9DofAvYnfgTHok9ALIe24+GIi7vpcXBGiqUb
        IVhJePR2YWY8BfJAF5STjF9g19FX
X-Google-Smtp-Source: APXvYqw56vcfrE6BlsZpUY7UbmBFZS8qOy71/KTRdT7fhdelzOMwo4yb4E3b6BSCaTZjEAYGEwW57g==
X-Received: by 2002:a63:215d:: with SMTP id s29mr19977580pgm.200.1576539545373;
        Mon, 16 Dec 2019 15:39:05 -0800 (PST)
Received: from ajayg.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id k12sm23105146pgm.65.2019.12.16.15.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 15:39:04 -0800 (PST)
From:   Ajay Gupta <ajaykuee@gmail.com>
X-Google-Original-From: Ajay Gupta <ajayg@nvidia.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, treding@nvidia.com,
        Ajay Gupta <ajayg@nvidia.com>
Subject: [PATCH v3 2/2] net: stmmac: dwc-qos: avoid clk and reset for acpi device
Date:   Sun, 15 Dec 2019 22:14:52 -0800
Message-Id: <20191216061452.6514-3-ajayg@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191216061452.6514-1-ajayg@nvidia.com>
References: <20191216061452.6514-1-ajayg@nvidia.com>
X-NVConfidentiality: public
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ajay Gupta <ajayg@nvidia.com>

There are no clocks, resets or gpios referenced by Tegra ACPI
device so don't access clocks, resets or gpios interface with
ACPI device.

Clocks, resets and GPIOs for ACPI devices will be handled via
ACPI interface.

Signed-off-by: Ajay Gupta <ajayg@nvidia.com>
---
Change from v2->v3: Fix comments from Jakub.

 drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index f87306b3cdae..2342d497348e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -271,6 +271,7 @@ static void *tegra_eqos_probe(struct platform_device *pdev,
 			      struct plat_stmmacenet_data *data,
 			      struct stmmac_resources *res)
 {
+	struct device *dev = &pdev->dev;
 	struct tegra_eqos *eqos;
 	int err;
 
@@ -283,6 +284,9 @@ static void *tegra_eqos_probe(struct platform_device *pdev,
 	eqos->dev = &pdev->dev;
 	eqos->regs = res->addr;
 
+	if (!is_of_node(dev->fwnode))
+		goto bypass_clk_reset_gpio;
+
 	eqos->clk_master = devm_clk_get(&pdev->dev, "master_bus");
 	if (IS_ERR(eqos->clk_master)) {
 		err = PTR_ERR(eqos->clk_master);
@@ -355,6 +359,7 @@ static void *tegra_eqos_probe(struct platform_device *pdev,
 
 	usleep_range(2000, 4000);
 
+bypass_clk_reset_gpio:
 	data->fix_mac_speed = tegra_eqos_fix_speed;
 	data->init = tegra_eqos_init;
 	data->bsp_priv = eqos;
-- 
2.17.1

