Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDE2451BEE
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348373AbhKPAJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:09:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:18275 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349240AbhKPAGa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 19:06:30 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="220768891"
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="220768891"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 16:01:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="506163136"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 15 Nov 2021 16:00:57 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net 09/10] iavf: Fix for setting queues to 0
Date:   Mon, 15 Nov 2021 15:59:33 -0800
Message-Id: <20211115235934.880882-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
References: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>

Now setting combine to 0 will be rejected with the
appropriate error code.
This has been implemented by adding a condition that checks
the value of combine equal to zero.
Without this patch, when the user requested it, no error was
returned and combine was set to the default value for VF.

Fixes: 5520deb15326 ("iavf: Enable support for up to 16 queues")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 25ee0606e625..144a77679359 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -1787,7 +1787,7 @@ static int iavf_set_channels(struct net_device *netdev,
 	/* All of these should have already been checked by ethtool before this
 	 * even gets to us, but just to be sure.
 	 */
-	if (num_req > adapter->vsi_res->num_queue_pairs)
+	if (num_req == 0 || num_req > adapter->vsi_res->num_queue_pairs)
 		return -EINVAL;
 
 	if (num_req == adapter->num_active_queues)
-- 
2.31.1

