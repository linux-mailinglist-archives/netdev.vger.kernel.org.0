Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B302613C8D
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 03:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfEEBTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 21:19:25 -0400
Received: from mga18.intel.com ([134.134.136.126]:33074 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727325AbfEEBTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 21:19:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 18:14:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="scan'208";a="297102553"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 04 May 2019 18:14:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sergey Nemov <sergey.nemov@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/12] i40e: add num_vectors checker in iwarp handler
Date:   Sat,  4 May 2019 18:14:02 -0700
Message-Id: <20190505011409.6771-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190505011409.6771-1-jeffrey.t.kirsher@intel.com>
References: <20190505011409.6771-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Nemov <sergey.nemov@intel.com>

Field num_vectors from struct virtchnl_iwarp_qvlist_info should not be
larger than num_msix_vectors_vf in the hw struct.  The iwarp uses the
same set of vectors as the LAN VF driver.

Signed-off-by: Sergey Nemov <sergey.nemov@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 00345bbf68ec..25490cfb06fc 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -442,6 +442,16 @@ static int i40e_config_iwarp_qvlist(struct i40e_vf *vf,
 	u32 next_q_idx, next_q_type;
 	u32 msix_vf, size;
 
+	msix_vf = pf->hw.func_caps.num_msix_vectors_vf;
+
+	if (qvlist_info->num_vectors > msix_vf) {
+		dev_warn(&pf->pdev->dev,
+			 "Incorrect number of iwarp vectors %u. Maximum %u allowed.\n",
+			 qvlist_info->num_vectors,
+			 msix_vf);
+		goto err;
+	}
+
 	size = sizeof(struct virtchnl_iwarp_qvlist_info) +
 	       (sizeof(struct virtchnl_iwarp_qv_info) *
 						(qvlist_info->num_vectors - 1));
-- 
2.20.1

