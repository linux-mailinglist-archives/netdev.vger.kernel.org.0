Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7533D3E28
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhGWQ0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:26:42 -0400
Received: from mga18.intel.com ([134.134.136.126]:1865 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhGWQ0l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 12:26:41 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10054"; a="199180182"
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="199180182"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2021 10:07:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="502586228"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Jul 2021 10:07:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>
Subject: [PATCH net 5/5] i40e: Fix log TC creation failure when max num of queues is exceeded
Date:   Fri, 23 Jul 2021 10:10:23 -0700
Message-Id: <20210723171023.296927-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210723171023.296927-1-anthony.l.nguyen@intel.com>
References: <20210723171023.296927-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

Fix missing failed message if driver does not have enough queues to
complete TC command. Without this fix no message is displayed in dmesg.

Fixes: a9ce82f744dc ("i40e: Enable 'channel' mode in mqprio for TC configs")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 278077208f37..1d1f52756a93 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7290,6 +7290,8 @@ static int i40e_validate_mqprio_qopt(struct i40e_vsi *vsi,
 	}
 	if (vsi->num_queue_pairs <
 	    (mqprio_qopt->qopt.offset[i] + mqprio_qopt->qopt.count[i])) {
+		dev_err(&vsi->back->pdev->dev,
+			"Failed to create traffic channel, insufficient number of queues.\n");
 		return -EINVAL;
 	}
 	if (sum_max_rate > i40e_get_link_speed(vsi)) {
-- 
2.26.2

