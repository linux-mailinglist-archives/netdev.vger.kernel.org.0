Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446AD6AEFE6
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbjCGS1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:27:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbjCGS0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:26:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F67FA92FF;
        Tue,  7 Mar 2023 10:20:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A452FCE1C81;
        Tue,  7 Mar 2023 18:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9034C433D2;
        Tue,  7 Mar 2023 18:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213230;
        bh=nZWihkCB3+64Nvms7t3o5MvdKzSCnCMWUPwklzyFewQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQYvDfn3TwVSoLlYr0Fli6KVLssSRynOqK7WfDIh1Fjs7cmSNir8VTvzfVL8rbwx6
         KGwz3Ue5obr5LHMOYcAMhNuC8xTiXTNg/cGZI3tGQUO/F4q1IrAIpKxnCJEgugJXdM
         5uAVhnruzYqFo4qLg1cjdmuctc/itLePLhZ34VcvZbCplgXAo7w9sXRt4Eq9Kvoqdt
         QoCIlKmG54H8SC2FvbtBcOqG++V2HZls0hUlW/pLIquLRRXW5dZ/7hNDyjx7GoxxCo
         dfnkLg9FvZO6lMy3mb6/QcE95iouWRbBS8R8OV0DzC/WRHkFqgj6W1jsZxc3StZwH7
         lFD1zplDLQ8xQ==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
Subject: [PATCH 18/28] sfc_ef100: Drop redundant pci_disable_pcie_error_reporting()
Date:   Tue,  7 Mar 2023 12:19:29 -0600
Message-Id: <20230307181940.868828-19-helgaas@kernel.org>
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

51b35a454efd ("sfc: skeleton EF100 PF driver") added a call to
pci_disable_pcie_error_reporting() in ef100_pci_remove().

Remove this call since there's no apparent reason to disable error
reporting when it was not previously enabled.

Note that since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is
native"), the PCI core enables PCIe error reporting for all devices during
enumeration, so the driver doesn't need to do it itself.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Edward Cree <ecree.xilinx@gmail.com>
Cc: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
index 71aab3d0480f..6334992b0af4 100644
--- a/drivers/net/ethernet/sfc/ef100.c
+++ b/drivers/net/ethernet/sfc/ef100.c
@@ -11,7 +11,6 @@
 
 #include "net_driver.h"
 #include <linux/module.h>
-#include <linux/aer.h>
 #include "efx_common.h"
 #include "efx_channels.h"
 #include "io.h"
@@ -440,8 +439,6 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
 
 	pci_dbg(pci_dev, "shutdown successful\n");
 
-	pci_disable_pcie_error_reporting(pci_dev);
-
 	pci_set_drvdata(pci_dev, NULL);
 	efx_fini_struct(efx);
 	kfree(probe_data);
-- 
2.25.1

