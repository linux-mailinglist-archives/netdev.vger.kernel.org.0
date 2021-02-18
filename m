Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1579231F307
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 00:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhBRX0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 18:26:05 -0500
Received: from mga12.intel.com ([192.55.52.136]:20144 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229845AbhBRXZs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 18:25:48 -0500
IronPort-SDR: uiDCjQaSBjujUQKbkTWuKGRa1gjjlKWnlrs2cLswL0l621NWK2U1UzaXFGgz5EpwIyKVn4gpjr
 bKuoOw5qnHDQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9899"; a="162823066"
X-IronPort-AV: E=Sophos;i="5.81,187,1610438400"; 
   d="scan'208";a="162823066"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2021 15:24:08 -0800
IronPort-SDR: dseAGv/tOe8co453dbOI1zxtGE80i2yn/qHXwYHpeXdndPQtowwvEhjYSE7Pw0na0tadt8B12Z
 /rHc99h+Svnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,187,1610438400"; 
   d="scan'208";a="581457634"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 18 Feb 2021 15:24:07 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 2/8] i40e: Fix memory leak in i40e_probe
Date:   Thu, 18 Feb 2021 15:24:58 -0800
Message-Id: <20210218232504.2422834-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210218232504.2422834-1-anthony.l.nguyen@intel.com>
References: <20210218232504.2422834-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>

Struct i40e_veb is allocated in function i40e_setup_pf_switch, and
stored to an array field veb inside struct i40e_pf. However when
i40e_setup_misc_vector fails, this memory leaks.

Fix this by calling exit and teardown functions.

Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 1db482d310c2..84916261f5df 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -15122,6 +15122,8 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		if (err) {
 			dev_info(&pdev->dev,
 				 "setup of misc vector failed: %d\n", err);
+			i40e_cloud_filter_exit(pf);
+			i40e_fdir_teardown(pf);
 			goto err_vsis;
 		}
 	}
-- 
2.26.2

