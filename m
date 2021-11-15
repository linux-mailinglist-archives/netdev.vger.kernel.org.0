Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617E9451BC0
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhKPAGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:06:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:18510 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353383AbhKPAEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 19:04:38 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="220768893"
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="220768893"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 16:01:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="506163125"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 15 Nov 2021 16:00:57 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Piotr Marczak <piotr.marczak@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net 05/10] iavf: Fix failure to exit out from last all-multicast mode
Date:   Mon, 15 Nov 2021 15:59:29 -0800
Message-Id: <20211115235934.880882-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
References: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Piotr Marczak <piotr.marczak@intel.com>

The driver could only quit allmulti when allmulti and promisc modes are
turn on at the same time. If promisc had been off there was no way to turn
off allmulti mode.
The patch corrects this behavior. Switching allmulti does not depends on
promisc state mode anymore

Fixes: f42a5c74da99 ("i40e: Add allmulti support for the VF")
Signed-off-by: Piotr Marczak <piotr.marczak@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 28661e4425f1..76c4ca0f055e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1639,8 +1639,7 @@ static int iavf_process_aq_command(struct iavf_adapter *adapter)
 		iavf_set_promiscuous(adapter, FLAG_VF_MULTICAST_PROMISC);
 		return 0;
 	}
-
-	if ((adapter->aq_required & IAVF_FLAG_AQ_RELEASE_PROMISC) &&
+	if ((adapter->aq_required & IAVF_FLAG_AQ_RELEASE_PROMISC) ||
 	    (adapter->aq_required & IAVF_FLAG_AQ_RELEASE_ALLMULTI)) {
 		iavf_set_promiscuous(adapter, 0);
 		return 0;
-- 
2.31.1

