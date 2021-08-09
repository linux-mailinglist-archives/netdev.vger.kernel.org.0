Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2153E4A8C
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 19:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbhHIRLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 13:11:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:27774 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233644AbhHIRLD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 13:11:03 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="236736374"
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="scan'208";a="236736374"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 10:10:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="scan'208";a="570519350"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 09 Aug 2021 10:10:39 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 4/4] iavf: Set RSS LUT and key in reset handle path
Date:   Mon,  9 Aug 2021 10:14:02 -0700
Message-Id: <20210809171402.17838-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210809171402.17838-1-anthony.l.nguyen@intel.com>
References: <20210809171402.17838-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>

iavf driver should set RSS LUT and key unconditionally in reset
path. Currently, the driver does not do that. This patch fixes
this issue.

Fixes: 2c86ac3c7079 ("i40evf: create a generic config RSS function")
Signed-off-by: Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 44bafedd09f2..244ec74ceca7 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1506,11 +1506,6 @@ static int iavf_reinit_interrupt_scheme(struct iavf_adapter *adapter)
 	set_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
 
 	iavf_map_rings_to_vectors(adapter);
-
-	if (RSS_AQ(adapter))
-		adapter->aq_required |= IAVF_FLAG_AQ_CONFIGURE_RSS;
-	else
-		err = iavf_init_rss(adapter);
 err:
 	return err;
 }
@@ -2200,6 +2195,14 @@ static void iavf_reset_task(struct work_struct *work)
 			goto reset_err;
 	}
 
+	if (RSS_AQ(adapter)) {
+		adapter->aq_required |= IAVF_FLAG_AQ_CONFIGURE_RSS;
+	} else {
+		err = iavf_init_rss(adapter);
+		if (err)
+			goto reset_err;
+	}
+
 	adapter->aq_required |= IAVF_FLAG_AQ_GET_CONFIG;
 	adapter->aq_required |= IAVF_FLAG_AQ_MAP_VECTORS;
 
-- 
2.26.2

