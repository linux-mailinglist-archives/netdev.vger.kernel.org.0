Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CF76AEFAD
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbjCGSZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:25:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbjCGSYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:24:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32F59FE4F;
        Tue,  7 Mar 2023 10:20:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F368B819C2;
        Tue,  7 Mar 2023 18:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A1DC4339C;
        Tue,  7 Mar 2023 18:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213206;
        bh=s4Z5SneGnLA3UHvVIg+sNkMWzINirxbbbRYKROhaFH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pjGP5Jg36iyH9IhbzJWBKbfbXiU8B9+cX9V081gQ8GNKQcA/rBHOculzG3oa1Le2z
         Hjurwn2jwQhwbTcU7a5DzP9VhFblvGKOzEBZBdMkNobvrUF1PgL9Mq0p8jsqfIYL8L
         H7ufXLnqZqO3nNnTQhQpZ2w8enoH6ZTKiZ4sOFrvx6qE0qtUW5IYZ7/RQiWC3d+OQZ
         hr0HZ3xsxSg8AKBjsZhBmOI0ve/gva2rh7c5j+BZ1TOXMjQl+00ilKfqe0gb2kY3U9
         E5ZnBsoKpzMbxMjG4ETwOqEAnEhAOhqTxm1GUl9HTa9hvbX8CRVDOBnt9fHTGMlurW
         3Db4aSDT9eEfA==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH 05/28] bnxt: Drop redundant pci_enable_pcie_error_reporting()
Date:   Tue,  7 Mar 2023 12:19:16 -0600
Message-Id: <20230307181940.868828-6-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230307181940.868828-1-helgaas@kernel.org>
References: <20230307181940.868828-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

pci_enable_pcie_error_reporting() enables the device to send ERR_*
Messages.  Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is
native"), the PCI core does this for all devices during enumeration.

Remove the redundant pci_enable_pcie_error_reporting() call from the
driver.  Also remove the corresponding pci_disable_pcie_error_reporting()
from the driver .remove() path.

Note that this only controls ERR_* Messages from the device.  An ERR_*
Message may cause the Root Port to generate an interrupt, depending on the
AER Root Error Command register managed by the AER service driver.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 5d4b1f2ebeac..7245fee13ad0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -48,7 +48,6 @@
 #include <linux/prefetch.h>
 #include <linux/cache.h>
 #include <linux/log2.h>
-#include <linux/aer.h>
 #include <linux/bitmap.h>
 #include <linux/cpu_rmap.h>
 #include <linux/cpumask.h>
@@ -12706,8 +12705,6 @@ static int bnxt_init_board(struct pci_dev *pdev, struct net_device *dev)
 		goto init_err_release;
 	}
 
-	pci_enable_pcie_error_reporting(pdev);
-
 	INIT_WORK(&bp->sp_task, bnxt_sp_task);
 	INIT_DELAYED_WORK(&bp->fw_reset_task, bnxt_fw_reset_task);
 
@@ -13187,7 +13184,6 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	bnxt_rdma_aux_device_uninit(bp);
 
 	bnxt_ptp_clear(bp);
-	pci_disable_pcie_error_reporting(pdev);
 	unregister_netdev(dev);
 	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
 	/* Flush any pending tasks */
-- 
2.25.1

