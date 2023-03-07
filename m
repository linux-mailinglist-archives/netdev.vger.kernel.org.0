Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7386AEFBB
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbjCGS0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232812AbjCGSYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:24:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24BBA4023;
        Tue,  7 Mar 2023 10:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 521C06154C;
        Tue,  7 Mar 2023 18:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4B7C4339C;
        Tue,  7 Mar 2023 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213209;
        bh=LbCwYJ20y8eWkgkIiA04QacuVyTv59uOi6c3cF4SrJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyNeenARGKJlqG3HD8EnysYP8c51Ld33M6PWizLGt8ypsiCtcUuossg80YghysKLN
         zBdbdOiz1ORJt8/CRSnBHrJIM52Hdgs9cQmDfZz4g8g7rmRwplEYzB1WV8QyZSpfkr
         9yZD0xNCw032IjlfyIJiaKpBc0H4zN4b7AvrG0NipBsXlxcHnIUQMoi6G5OFw09WrO
         sebTljQ4yfzf14ka11TlzF7JjLHnaCuV6FM68ybWPUgKKhCoYjm6qT3XT2Mjw2IwyH
         0GFegLnlSQ9xenDfva7lMyNmCMWTT3gnrdDrMWFvYR9ZIfUB0BjYp+++8yb+4h0Ap0
         fe0JN2OjYrflQ==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dimitris Michailidis <dmichail@fungible.com>
Subject: [PATCH 07/28] net/fungible: Drop redundant pci_enable_pcie_error_reporting()
Date:   Tue,  7 Mar 2023 12:19:18 -0600
Message-Id: <20230307181940.868828-8-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230307181940.868828-1-helgaas@kernel.org>
References: <20230307181940.868828-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

pci_enable_pcie_error_reporting() enables the device to send ERR_*
Messages.  Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is
native"), the PCI core does this for all devices during enumeration, so the
driver doesn't need to do it itself.

Remove the redundant pci_enable_pcie_error_reporting() call from the
driver.  Also remove the corresponding pci_disable_pcie_error_reporting()
from the driver .remove() path.

Note that this only controls ERR_* Messages from the device.  An ERR_*
Message may cause the Root Port to generate an interrupt, depending on the
AER Root Error Command register managed by the AER service driver.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Dimitris Michailidis <dmichail@fungible.com>
---
 drivers/net/ethernet/fungible/funcore/fun_dev.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/fungible/funcore/fun_dev.c b/drivers/net/ethernet/fungible/funcore/fun_dev.c
index fb5120d90f26..3680f83feba2 100644
--- a/drivers/net/ethernet/fungible/funcore/fun_dev.c
+++ b/drivers/net/ethernet/fungible/funcore/fun_dev.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 
-#include <linux/aer.h>
 #include <linux/bitmap.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
@@ -748,7 +747,6 @@ void fun_dev_disable(struct fun_dev *fdev)
 	pci_free_irq_vectors(pdev);
 
 	pci_clear_master(pdev);
-	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
 
 	fun_unmap_bars(fdev);
@@ -781,8 +779,6 @@ int fun_dev_enable(struct fun_dev *fdev, struct pci_dev *pdev,
 		goto unmap;
 	}
 
-	pci_enable_pcie_error_reporting(pdev);
-
 	rc = sanitize_dev(fdev);
 	if (rc)
 		goto disable_dev;
@@ -830,7 +826,6 @@ int fun_dev_enable(struct fun_dev *fdev, struct pci_dev *pdev,
 free_irqs:
 	pci_free_irq_vectors(pdev);
 disable_dev:
-	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
 unmap:
 	fun_unmap_bars(fdev);
-- 
2.25.1

