Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565C7484ADA
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 23:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235803AbiADWj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 17:39:27 -0500
Received: from mga12.intel.com ([192.55.52.136]:28286 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235685AbiADWjX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 17:39:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641335963; x=1672871963;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bezs6mT1IMZ9g/hiVcXDtCIDzb7keF2witojcZiEb2I=;
  b=JJE4OyIkzkQeGScGa+JhWwl35/V7GV+IVazuAJMCEHWiila0a3xugUa3
   zrGciYoO3qm41vNGAYu0K8HIQF9lyvMX1QWry0nGpVcEB1nw6Dpki63Nm
   pXOILeSFJsYUGivTHFBvU0ujytV6OWryD7R/8a0DgVmuOk94LA5EDwbOb
   wtmoBByozl4JEb6AMrhy4QUE1fenICQKGj8KGINOv26i5ixLScuqS6C5V
   wDBYxFX4DSEnwwMzB9xDfAkP7+U9pmHFIkku05XBLOotEsPwQ4e+VW1u3
   OJYJlQYg7cUjGl7qyjFuYXkfu3Yu3zUku5Qe04c+yP+BlBCGNFSb7p8OB
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="222305236"
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="222305236"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 14:39:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="470312806"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 04 Jan 2022 14:39:21 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Lukasz Cieplicki <lukaszx.cieplicki@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 4/5] i40e: Fix incorrect netdev's real number of RX/TX queues
Date:   Tue,  4 Jan 2022 14:38:41 -0800
Message-Id: <20220104223842.2325297-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220104223842.2325297-1-anthony.l.nguyen@intel.com>
References: <20220104223842.2325297-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

There was a wrong queues representation in sysfs during
driver's reinitialization in case of online cpus number is
less than combined queues. It was caused by stopped
NetworkManager, which is responsible for calling vsi_open
function during driver's initialization.
In specific situation (ex. 12 cpus online) there were 16 queues
in /sys/class/net/<iface>/queues. In case of modifying queues with
value higher, than number of online cpus, then it caused write
errors and other errors.
Add updating of sysfs's queues representation during driver
initialization.

Fixes: 41c445ff0f48 ("i40e: main driver core")
Signed-off-by: Lukasz Cieplicki <lukaszx.cieplicki@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 32 ++++++++++++++++-----
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 17c3f6d69740..61afc220fc6c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -8740,6 +8740,27 @@ int i40e_open(struct net_device *netdev)
 	return 0;
 }
 
+/**
+ * i40e_netif_set_realnum_tx_rx_queues - Update number of tx/rx queues
+ * @vsi: vsi structure
+ *
+ * This updates netdev's number of tx/rx queues
+ *
+ * Returns status of setting tx/rx queues
+ **/
+static int i40e_netif_set_realnum_tx_rx_queues(struct i40e_vsi *vsi)
+{
+	int ret;
+
+	ret = netif_set_real_num_rx_queues(vsi->netdev,
+					   vsi->num_queue_pairs);
+	if (ret)
+		return ret;
+
+	return netif_set_real_num_tx_queues(vsi->netdev,
+					    vsi->num_queue_pairs);
+}
+
 /**
  * i40e_vsi_open -
  * @vsi: the VSI to open
@@ -8776,13 +8797,7 @@ int i40e_vsi_open(struct i40e_vsi *vsi)
 			goto err_setup_rx;
 
 		/* Notify the stack of the actual queue counts. */
-		err = netif_set_real_num_tx_queues(vsi->netdev,
-						   vsi->num_queue_pairs);
-		if (err)
-			goto err_set_queues;
-
-		err = netif_set_real_num_rx_queues(vsi->netdev,
-						   vsi->num_queue_pairs);
+		err = i40e_netif_set_realnum_tx_rx_queues(vsi);
 		if (err)
 			goto err_set_queues;
 
@@ -14173,6 +14188,9 @@ struct i40e_vsi *i40e_vsi_setup(struct i40e_pf *pf, u8 type,
 	case I40E_VSI_MAIN:
 	case I40E_VSI_VMDQ2:
 		ret = i40e_config_netdev(vsi);
+		if (ret)
+			goto err_netdev;
+		ret = i40e_netif_set_realnum_tx_rx_queues(vsi);
 		if (ret)
 			goto err_netdev;
 		ret = register_netdev(vsi->netdev);
-- 
2.31.1

