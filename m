Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B08B42E116
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 20:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbhJNSXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 14:23:51 -0400
Received: from mga04.intel.com ([192.55.52.120]:62163 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232425AbhJNSXu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 14:23:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="226531107"
X-IronPort-AV: E=Sophos;i="5.85,373,1624345200"; 
   d="scan'208";a="226531107"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 11:21:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,373,1624345200"; 
   d="scan'208";a="717815815"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 14 Oct 2021 11:21:44 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, linux-rdma@vger.kernel.org,
        shiraz.saleem@intel.com, Jun Miao <jun.miao@windriver.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net 2/4] ice: Avoid crash from unnecessary IDA free
Date:   Thu, 14 Oct 2021 11:19:51 -0700
Message-Id: <20211014181953.3538330-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211014181953.3538330-1-anthony.l.nguyen@intel.com>
References: <20211014181953.3538330-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

In the remove path, there is an attempt to free the aux_idx IDA whether
it was allocated or not.  This can potentially cause a crash when
unloading the driver on systems that do not initialize support for RDMA.
But, this free cannot be gated by the status bit for RDMA, since it is
allocated if the driver detects support for RDMA at probe time, but the
driver can enter into a state where RDMA is not supported after the IDA
has been allocated at probe time and this would lead to a memory leak.

Initialize aux_idx to an invalid value and check for a valid value when
unloading to determine if an IDA free is necessary.

Fixes: d25a0fc41c1f ("ice: Initialize RDMA support")
Reported-by: Jun Miao <jun.miao@windriver.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0d6c143f6653..94037881bfd8 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4224,6 +4224,9 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	if (!pf)
 		return -ENOMEM;
 
+	/* initialize Auxiliary index to invalid value */
+	pf->aux_idx = -1;
+
 	/* set up for high or low DMA */
 	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
 	if (err)
@@ -4615,7 +4618,8 @@ static void ice_remove(struct pci_dev *pdev)
 
 	ice_aq_cancel_waiting_tasks(pf);
 	ice_unplug_aux_dev(pf);
-	ida_free(&ice_aux_ida, pf->aux_idx);
+	if (pf->aux_idx >= 0)
+		ida_free(&ice_aux_ida, pf->aux_idx);
 	set_bit(ICE_DOWN, pf->state);
 
 	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
-- 
2.31.1

