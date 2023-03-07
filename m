Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474126AEFDF
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbjCGS1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbjCGS0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:26:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F1DA92EF;
        Tue,  7 Mar 2023 10:20:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 875A6B819C5;
        Tue,  7 Mar 2023 18:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19035C4339E;
        Tue,  7 Mar 2023 18:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213228;
        bh=PO6YJGQP/E2abwSNE1uA5K3WGNLi+m5nTKH5md2eNqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qCkGvFlev3wtOuj6vmcxP/ryEytiA8D4qpywAn0hCDzUoVADw7OotaO+NXtxiuJoO
         6Hc/0Cq2RAU+xrZ3KyB2mA+/zUQ9SIiPUNC24KU7xjXTQYMmnbeK3S25uw5vO8DnZC
         paJ3+7y2igLXwYlRYNtTLwbOMYdNLtwgbwABxekov0F+JSaB4BjqjRYRZ0iOhaIAQm
         lv10wxYE3C18AG8C+v6kaE13zqvozBT7riwL8lSyY5dVOe+BLHnWQFR5/qq4ojwhv4
         zsthNfxMqY7/dyU3O1MYPosqjqjihO3Wn70d3CzPGJHpgWGbi4pWgMGs3oJh+1cMWE
         zQVXpTayVzqyQ==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
Subject: [PATCH 17/28] sfc/siena: Drop redundant pci_enable_pcie_error_reporting()
Date:   Tue,  7 Mar 2023 12:19:28 -0600
Message-Id: <20230307181940.868828-18-helgaas@kernel.org>
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
native"), the PCI core does this for all devices during enumeration, so the
driver doesn't need to do it itself.

Remove the redundant pci_enable_pcie_error_reporting() call from the
driver.  Also remove the corresponding pci_disable_pcie_error_reporting()
from the driver .remove() path.

Note that this only controls ERR_* Messages from the device.  An ERR_*
Message may cause the Root Port to generate an interrupt, depending on the
AER Root Error Command register managed by the AER service driver.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Edward Cree <ecree.xilinx@gmail.com>
Cc: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/efx.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index ef52ec71d197..8c557f6a183c 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -18,7 +18,6 @@
 #include <linux/ethtool.h>
 #include <linux/topology.h>
 #include <linux/gfp.h>
-#include <linux/aer.h>
 #include <linux/interrupt.h>
 #include "net_driver.h"
 #include <net/gre.h>
@@ -874,8 +873,6 @@ static void efx_pci_remove(struct pci_dev *pci_dev)
 
 	efx_siena_fini_struct(efx);
 	free_netdev(efx->net_dev);
-
-	pci_disable_pcie_error_reporting(pci_dev);
 };
 
 /* NIC VPD information
@@ -1094,8 +1091,6 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 		netif_warn(efx, probe, efx->net_dev,
 			   "failed to create MTDs (%d)\n", rc);
 
-	(void)pci_enable_pcie_error_reporting(pci_dev);
-
 	if (efx->type->udp_tnl_push_ports)
 		efx->type->udp_tnl_push_ports(efx);
 
-- 
2.25.1

