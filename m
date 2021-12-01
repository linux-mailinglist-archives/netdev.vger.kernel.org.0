Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C204658BF
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 23:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353240AbhLAWEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 17:04:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:6213 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243883AbhLAWEL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 17:04:11 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="223795734"
X-IronPort-AV: E=Sophos;i="5.87,280,1631602800"; 
   d="scan'208";a="223795734"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 14:00:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,280,1631602800"; 
   d="scan'208";a="540980329"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 01 Dec 2021 14:00:24 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Bindushree P <Bindushree.p@intel.com>
Subject: [PATCH net 4/6] i40e: Fix pre-set max number of queues for VF
Date:   Wed,  1 Dec 2021 13:59:12 -0800
Message-Id: <20211201215914.1200153-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201215914.1200153-1-anthony.l.nguyen@intel.com>
References: <20211201215914.1200153-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

After setting pre-set combined to 16 queues and reserving 16 queues by
tc qdisc, pre-set maximum combined queues returned to default value
after VF reset being 4 and this generated errors during removing tc.
Fixed by removing clear num_req_queues before reset VF.

Fixes: e284fc280473 (i40e: Add and delete cloud filter)
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Bindushree P <Bindushree.p@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index f651861442c2..2ea4deb8fc44 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -3823,11 +3823,6 @@ static int i40e_vc_add_qch_msg(struct i40e_vf *vf, u8 *msg)
 
 	/* set this flag only after making sure all inputs are sane */
 	vf->adq_enabled = true;
-	/* num_req_queues is set when user changes number of queues via ethtool
-	 * and this causes issue for default VSI(which depends on this variable)
-	 * when ADq is enabled, hence reset it.
-	 */
-	vf->num_req_queues = 0;
 
 	/* reset the VF in order to allocate resources */
 	i40e_vc_reset_vf(vf, true);
-- 
2.31.1

