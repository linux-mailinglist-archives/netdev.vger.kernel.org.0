Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49A53D0A92
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 10:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236390AbhGUHmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 03:42:37 -0400
Received: from mga03.intel.com ([134.134.136.65]:20225 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236872AbhGUHkP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 03:40:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10051"; a="211454845"
X-IronPort-AV: E=Sophos;i="5.84,257,1620716400"; 
   d="scan'208";a="211454845"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 01:20:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,257,1620716400"; 
   d="scan'208";a="432531578"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 21 Jul 2021 01:20:33 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 14B9423A; Wed, 21 Jul 2021 11:21:00 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v1 1/1] net: wwan: iosm: Switch to use module_pci_driver() macro
Date:   Wed, 21 Jul 2021 11:20:58 +0300
Message-Id: <20210721082058.71098-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate some boilerplate code by using module_pci_driver() instead of
init/exit, moving the salient bits from init into probe.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_pcie.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index 7f7d364d3a51..2fe88b8be348 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -479,6 +479,7 @@ static struct pci_driver iosm_ipc_driver = {
 	},
 	.id_table = iosm_ipc_ids,
 };
+module_pci_driver(iosm_ipc_driver);
 
 int ipc_pcie_addr_map(struct iosm_pcie *ipc_pcie, unsigned char *data,
 		      size_t size, dma_addr_t *mapping, int direction)
@@ -560,21 +561,3 @@ void ipc_pcie_kfree_skb(struct iosm_pcie *ipc_pcie, struct sk_buff *skb)
 	IPC_CB(skb)->mapping = 0;
 	dev_kfree_skb(skb);
 }
-
-static int __init iosm_ipc_driver_init(void)
-{
-	if (pci_register_driver(&iosm_ipc_driver)) {
-		pr_err("registering of IOSM PCIe driver failed");
-		return -1;
-	}
-
-	return 0;
-}
-
-static void __exit iosm_ipc_driver_exit(void)
-{
-	pci_unregister_driver(&iosm_ipc_driver);
-}
-
-module_init(iosm_ipc_driver_init);
-module_exit(iosm_ipc_driver_exit);
-- 
2.30.2

