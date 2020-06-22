Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C2E203576
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgFVLP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728249AbgFVLPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:15:45 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591C4C061794;
        Mon, 22 Jun 2020 04:15:45 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t6so192709pgq.1;
        Mon, 22 Jun 2020 04:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2XaRcZP1I/yNj4dxWvPGShRfEGGKyDmu4yyyk3d3G+8=;
        b=BrEn9vJ/G0xuOSNq7YWcdvYWIBmWN99jCzPi+NRx8HZIpSyxsmDNyuHnzqgMauDnp4
         WhQu7fweqY8jTzjEw/SvaKZ1DUCmIDQn6+J6ocZIJ/j10d54OcpEh9r7inP+1bOL4iaZ
         FYjo6jt9rcMrnNJuZ5uKJq7xvHZFPULk+OTVmUf6+Yh3c2TbWpxdGTqWWP1K3EHERnJ3
         JJHyoUcCOP1lbMNY84UvaXktl98iwUsxucgb8YqzZnZauCocFRhpIKMK67w/W4spdHF0
         TXGz9paFEheUeacRfenMhTiouFCtw1dB0ohMahx3QqwEMhc/2HRCcec6m6qPPHKCvK3U
         o0kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2XaRcZP1I/yNj4dxWvPGShRfEGGKyDmu4yyyk3d3G+8=;
        b=LX1M/sGc8mbr/oXiQ6IphOqLlEHfyHy2BE1SyV7CsqIJWqFsLt/+LyKwJhgWWsrPLm
         QMzR+pmgRrsImMLcEYf0RpU3KjMl3c1mpMl0ul+vguWSwUXDbRZXdU3J0oQmPj6vXEcI
         2UtlDwVtKBarRzdUBU5A9iWKza8wjfI0NxZB86V+LBkjeSU0J0YR9GGD9QB4Ig2hoo37
         pXmirSdh0L31VagTFanoOKRuyeVCUXrG9zMHaSZUaazKb40ecCcbtV3rQS1ze4BDGXP/
         Edy72IzNmbdbnROg3Q80PzkrBGNm596AYGFwuZEy5gm9z4KB1IOUlp9fqv8P5VtYG0C7
         1wEQ==
X-Gm-Message-State: AOAM5306olzura0YzNzcCsj3Z25jDqaHo+8MX1Nznh8XqQiSTOgiAhxh
        pLpR5ydHXQpgSEbTajxbLXk=
X-Google-Smtp-Source: ABdhPJzQr0DmsdnK/ME7ERsccmB6MxIt/i1mUG6fqIK9c7qaVUgBOqunsOMVOtd/xn/Zed9PgC0UIg==
X-Received: by 2002:a63:ff51:: with SMTP id s17mr10896461pgk.300.1592824544924;
        Mon, 22 Jun 2020 04:15:44 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id n189sm13950150pfn.108.2020.06.22.04.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 04:15:44 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Don Fry <pcnet32@frontier.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v2 3/3] amd-xgbe: Convert to generic power management
Date:   Mon, 22 Jun 2020 16:44:00 +0530
Message-Id: <20200622111400.55956-4-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200622111400.55956-1-vaibhavgupta40@gmail.com>
References: <20200622111400.55956-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use dev_pm_ops structure to call generic suspend() and resume() callbacks.

Drivers should avoid saving device register and/or change power states
using PCI helper functions. With the generic approach, all these are handled
by PCI core.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
index 7b86240ecd5f..90cb55eb5466 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
@@ -421,10 +421,9 @@ static void xgbe_pci_remove(struct pci_dev *pdev)
 	xgbe_free_pdata(pdata);
 }
 
-#ifdef CONFIG_PM
-static int xgbe_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused xgbe_pci_suspend(struct device *dev)
 {
-	struct xgbe_prv_data *pdata = pci_get_drvdata(pdev);
+	struct xgbe_prv_data *pdata = dev_get_drvdata(dev);
 	struct net_device *netdev = pdata->netdev;
 	int ret = 0;
 
@@ -438,9 +437,9 @@ static int xgbe_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	return ret;
 }
 
-static int xgbe_pci_resume(struct pci_dev *pdev)
+static int __maybe_unused xgbe_pci_resume(struct device *dev)
 {
-	struct xgbe_prv_data *pdata = pci_get_drvdata(pdev);
+	struct xgbe_prv_data *pdata = dev_get_drvdata(dev);
 	struct net_device *netdev = pdata->netdev;
 	int ret = 0;
 
@@ -460,7 +459,6 @@ static int xgbe_pci_resume(struct pci_dev *pdev)
 
 	return ret;
 }
-#endif /* CONFIG_PM */
 
 static const struct xgbe_version_data xgbe_v2a = {
 	.init_function_ptrs_phy_impl	= xgbe_init_function_ptrs_phy_v2,
@@ -502,15 +500,16 @@ static const struct pci_device_id xgbe_pci_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, xgbe_pci_table);
 
+static SIMPLE_DEV_PM_OPS(xgbe_pci_pm_ops, xgbe_pci_suspend, xgbe_pci_resume);
+
 static struct pci_driver xgbe_driver = {
 	.name = XGBE_DRV_NAME,
 	.id_table = xgbe_pci_table,
 	.probe = xgbe_pci_probe,
 	.remove = xgbe_pci_remove,
-#ifdef CONFIG_PM
-	.suspend = xgbe_pci_suspend,
-	.resume = xgbe_pci_resume,
-#endif
+	.driver = {
+		.pm = &xgbe_pci_pm_ops,
+	}
 };
 
 int xgbe_pci_init(void)
-- 
2.27.0

