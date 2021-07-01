Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35C63B95CF
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 20:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbhGASEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 14:04:05 -0400
Received: from mga12.intel.com ([192.55.52.136]:63745 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233212AbhGASD7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 14:03:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="188272888"
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="188272888"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 11:01:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="409018414"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 01 Jul 2021 11:01:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>
Subject: [PATCH net 05/11] igc: Fix an error handling path in 'igc_probe()'
Date:   Thu,  1 Jul 2021 11:04:14 -0700
Message-Id: <20210701180420.346126-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210701180420.346126-1-anthony.l.nguyen@intel.com>
References: <20210701180420.346126-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: c9a11c23ceb6 ("igc: Add netdev")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 1d00a63eb935..e29aadbc6744 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6056,6 +6056,7 @@ static int igc_probe(struct pci_dev *pdev,
 err_ioremap:
 	free_netdev(netdev);
 err_alloc_etherdev:
+	pci_disable_pcie_error_reporting(pdev);
 	pci_release_mem_regions(pdev);
 err_pci_reg:
 err_dma:
-- 
2.26.2

