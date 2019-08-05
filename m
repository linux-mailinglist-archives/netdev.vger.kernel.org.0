Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E060482516
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 20:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730147AbfHESzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 14:55:02 -0400
Received: from mga06.intel.com ([134.134.136.31]:43661 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727802AbfHESzC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 14:55:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Aug 2019 11:55:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,350,1559545200"; 
   d="scan'208";a="373801221"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga006.fm.intel.com with ESMTP; 05 Aug 2019 11:55:01 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Dmitrii Golovanov <dmitrii.golovanov@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 1/8] i40e: fix incorrect ethtool statistics veb and veb.tc_
Date:   Mon,  5 Aug 2019 11:54:52 -0700
Message-Id: <20190805185459.12846-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190805185459.12846-1-jeffrey.t.kirsher@intel.com>
References: <20190805185459.12846-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitrii Golovanov <dmitrii.golovanov@intel.com>

This patch fixes missing call of i40e_update_veb_stats() in function
i40e_get_ethtool_stats() to update stats data of VEB and VEB TC
counters before they are written into ethtool buffer.
Before the patch ethtool counters may fell behind interface counters.

Signed-off-by: Dmitrii Golovanov <dmitrii.golovanov@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h         | 1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 8 +++++++-
 drivers/net/ethernet/intel/i40e/i40e_main.c    | 2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 84bd06901014..3e535d3263b3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -1021,6 +1021,7 @@ i40e_find_vsi_by_type(struct i40e_pf *pf, u16 type)
 	return NULL;
 }
 void i40e_update_stats(struct i40e_vsi *vsi);
+void i40e_update_veb_stats(struct i40e_veb *veb);
 void i40e_update_eth_stats(struct i40e_vsi *vsi);
 struct rtnl_link_stats64 *i40e_get_vsi_stats_struct(struct i40e_vsi *vsi);
 int i40e_fetch_switch_configuration(struct i40e_pf *pf,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 527eb52c5401..65e016f54f58 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2250,7 +2250,7 @@ static void i40e_get_ethtool_stats(struct net_device *netdev,
 	struct i40e_netdev_priv *np = netdev_priv(netdev);
 	struct i40e_vsi *vsi = np->vsi;
 	struct i40e_pf *pf = vsi->back;
-	struct i40e_veb *veb = pf->veb[pf->lan_veb];
+	struct i40e_veb *veb = NULL;
 	unsigned int i;
 	bool veb_stats;
 	u64 *p = data;
@@ -2273,8 +2273,14 @@ static void i40e_get_ethtool_stats(struct net_device *netdev,
 		goto check_data_pointer;
 
 	veb_stats = ((pf->lan_veb != I40E_NO_VEB) &&
+		     (pf->lan_veb < I40E_MAX_VEB) &&
 		     (pf->flags & I40E_FLAG_VEB_STATS_ENABLED));
 
+	if (veb_stats) {
+		veb = pf->veb[pf->lan_veb];
+		i40e_update_veb_stats(veb);
+	}
+
 	/* If veb stats aren't enabled, pass NULL instead of the veb so that
 	 * we initialize stats to zero and update the data pointer
 	 * intelligently
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 44da407e0bf9..d39940b9c8b7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -677,7 +677,7 @@ void i40e_update_eth_stats(struct i40e_vsi *vsi)
  * i40e_update_veb_stats - Update Switch component statistics
  * @veb: the VEB being updated
  **/
-static void i40e_update_veb_stats(struct i40e_veb *veb)
+void i40e_update_veb_stats(struct i40e_veb *veb)
 {
 	struct i40e_pf *pf = veb->pf;
 	struct i40e_hw *hw = &pf->hw;
-- 
2.21.0

