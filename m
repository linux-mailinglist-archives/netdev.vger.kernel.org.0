Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC90459670
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 22:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240073AbhKVVPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 16:15:53 -0500
Received: from mga17.intel.com ([192.55.52.151]:19484 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239882AbhKVVPt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 16:15:49 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10176"; a="215593739"
X-IronPort-AV: E=Sophos;i="5.87,255,1631602800"; 
   d="scan'208";a="215593739"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2021 13:12:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,255,1631602800"; 
   d="scan'208";a="570478301"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 22 Nov 2021 13:12:41 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, linux-rdma@vger.kernel.org,
        mustafa.ismail@intel.com, jacob.e.keller@intel.com,
        parav@nvidia.com, jiri@nvidia.com,
        Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
Subject: [PATCH net-next 3/3] RDMA/irdma: Set protocol based on PF rdma_mode flag
Date:   Mon, 22 Nov 2021 13:11:19 -0800
Message-Id: <20211122211119.279885-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211122211119.279885-1-anthony.l.nguyen@intel.com>
References: <20211122211119.279885-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem@intel.com>

Set the RDMA protocol to use at driver bind time based on the ice PF's
rdma_mode flag.

Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Tested-by: Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/infiniband/hw/irdma/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/main.c b/drivers/infiniband/hw/irdma/main.c
index 51a41359e0b4..3fda7b78a9af 100644
--- a/drivers/infiniband/hw/irdma/main.c
+++ b/drivers/infiniband/hw/irdma/main.c
@@ -228,7 +228,8 @@ static void irdma_fill_device_info(struct irdma_device *iwdev, struct ice_pf *pf
 	rf->msix_count =  pf->num_rdma_msix;
 	rf->msix_entries = &pf->msix_entries[pf->rdma_base_vector];
 	rf->default_vsi.vsi_idx = vsi->vsi_num;
-	rf->protocol_used = IRDMA_ROCE_PROTOCOL_ONLY;
+	rf->protocol_used = pf->rdma_mode & IIDC_RDMA_PROTOCOL_ROCEV2 ?
+			    IRDMA_ROCE_PROTOCOL_ONLY : IRDMA_IWARP_PROTOCOL_ONLY;
 	rf->rdma_ver = IRDMA_GEN_2;
 	rf->rsrc_profile = IRDMA_HMC_PROFILE_DEFAULT;
 	rf->rst_to = IRDMA_RST_TIMEOUT_HZ;
-- 
2.31.1

