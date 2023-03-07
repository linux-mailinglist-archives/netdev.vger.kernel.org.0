Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752506AEFD9
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbjCGS1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbjCGSZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:25:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F93A92ED;
        Tue,  7 Mar 2023 10:20:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7C27B819C8;
        Tue,  7 Mar 2023 18:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64066C433EF;
        Tue,  7 Mar 2023 18:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213224;
        bh=R3qhJIRBpujHIxRFlynDnmucTd3u0pBuUk2cqVlrcQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQdBO/VodaUeYxo9roFtmtJ//orvmW8XFYRtfFtrYAh4dq05C9J9VWZ/NKLbQAEU5
         2fNXtH9thudx4KsqU+3+Ry0Vt/fHx6r5GJzLRg6vqxeNJ/NH4Y0htjfEwVAbKwcO40
         MbyevcC2iw80VCIXqVarhgTxPuKPjxiOHcPcWWsrXQ6PjLK3Ce1dKzjK0a9KDgXxTz
         rExNzLW8lLrZuNUPpnyJG8s0NC7nrW24ubAef0PiEpCTKiicbsa+dE8gR2MW8vJ6Q6
         Q96N4xCmovWntbI1A/X7jOg/25Z/ODNB3Y0Vs6eWEwuQIG2fAhKgrHtEBr/KO0HRY3
         g8nyZdqMwIHHw==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
Subject: [PATCH 15/28] sfc: Drop redundant pci_enable_pcie_error_reporting()
Date:   Tue,  7 Mar 2023 12:19:26 -0600
Message-Id: <20230307181940.868828-16-helgaas@kernel.org>
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
Cc: Edward Cree <ecree.xilinx@gmail.com>
Cc: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/efx.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 02c2adeb0a12..92c390ec4735 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -18,7 +18,6 @@
 #include <linux/ethtool.h>
 #include <linux/topology.h>
 #include <linux/gfp.h>
-#include <linux/aer.h>
 #include <linux/interrupt.h>
 #include "net_driver.h"
 #include <net/gre.h>
@@ -892,8 +891,6 @@ static void efx_pci_remove(struct pci_dev *pci_dev)
 	free_netdev(efx->net_dev);
 	probe_data = container_of(efx, struct efx_probe_data, efx);
 	kfree(probe_data);
-
-	pci_disable_pcie_error_reporting(pci_dev);
 };
 
 /* NIC VPD information
@@ -1126,8 +1123,6 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 		netif_warn(efx, probe, efx->net_dev,
 			   "failed to create MTDs (%d)\n", rc);
 
-	(void)pci_enable_pcie_error_reporting(pci_dev);
-
 	if (efx->type->udp_tnl_push_ports)
 		efx->type->udp_tnl_push_ports(efx);
 
-- 
2.25.1

