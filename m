Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A06D4C93B7
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 19:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbiCATAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 14:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbiCATAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 14:00:11 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC3DE0B9
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 10:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646161169; x=1677697169;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F8J0ErqesH0AWKHhJ4SLGt+AlcgSdn2SNglPAg0WJ+g=;
  b=dFTCjjTFLACmoShTcbA/8dJ+BzI8maAPoIgE54IBY8sMjryg/212zbCr
   +jUzlbs+HfpUKdzHaknY7wg0Ad5D/+xkBHwxgOgbq0ptq0c8bLO++7Sb9
   1ukE9wYu+W+5ZziciisiQeVNeFtj1lNo8qdehBAkKatDJLD61iJOymx7i
   Kt92jcEFLiTf3c5Nol8WPVMY24H5vIzT6iKxIwtif6dK6RW+RBYTzvjXM
   I9p/U+2AiK8cl5Zue5o2NXIjgbi3C+UsuBtjq+4w19SP49D5pwCMVHUZN
   cwn24VMfmz6C4OER+zPF1Ga2wZ7V/Hl8a57+nD1sWKeIhb8Mmn3dCTeSu
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="252042320"
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="252042320"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 10:59:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="507908263"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 01 Mar 2022 10:59:26 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 3/7] iavf: Add usage of new virtchnl format to set default MAC
Date:   Tue,  1 Mar 2022 10:59:35 -0800
Message-Id: <20220301185939.3005116-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220301185939.3005116-1-anthony.l.nguyen@intel.com>
References: <20220301185939.3005116-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

Use new type field of VIRTCHNL_OP_ADD_ETH_ADDR and
VIRTCHNL_OP_DEL_ETH_ADDR requests to indicate that
VF wants to change its default MAC address.

Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c     | 12 +++++++++---
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 16 ++++++++++++++++
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 450a98196235..f339b78262d3 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -876,6 +876,7 @@ struct iavf_mac_filter *iavf_add_filter(struct iavf_adapter *adapter,
 		list_add_tail(&f->list, &adapter->mac_filter_list);
 		f->add = true;
 		f->is_new_mac = true;
+		f->is_primary = false;
 		adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
 	} else {
 		f->remove = false;
@@ -909,17 +910,22 @@ static int iavf_set_mac(struct net_device *netdev, void *p)
 	f = iavf_find_filter(adapter, hw->mac.addr);
 	if (f) {
 		f->remove = true;
+		f->is_primary = true;
 		adapter->aq_required |= IAVF_FLAG_AQ_DEL_MAC_FILTER;
 	}
 
 	f = iavf_add_filter(adapter, addr->sa_data);
-
-	spin_unlock_bh(&adapter->mac_vlan_list_lock);
-
 	if (f) {
+		f->is_primary = true;
 		ether_addr_copy(hw->mac.addr, addr->sa_data);
 	}
 
+	spin_unlock_bh(&adapter->mac_vlan_list_lock);
+
+	/* schedule the watchdog task to immediately process the request */
+	if (f)
+		queue_work(iavf_wq, &adapter->watchdog_task.work);
+
 	return (f == NULL) ? -ENOMEM : 0;
 }
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 5ee1d118fd30..8d53228046a5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -453,6 +453,20 @@ void iavf_map_queues(struct iavf_adapter *adapter)
 	kfree(vimi);
 }
 
+/**
+ * iavf_set_mac_addr_type - Set the correct request type from the filter type
+ * @virtchnl_ether_addr: pointer to requested list element
+ * @filter: pointer to requested filter
+ **/
+static void
+iavf_set_mac_addr_type(struct virtchnl_ether_addr *virtchnl_ether_addr,
+		       const struct iavf_mac_filter *filter)
+{
+	virtchnl_ether_addr->type = filter->is_primary ?
+		VIRTCHNL_ETHER_ADDR_PRIMARY :
+		VIRTCHNL_ETHER_ADDR_EXTRA;
+}
+
 /**
  * iavf_add_ether_addrs
  * @adapter: adapter structure
@@ -508,6 +522,7 @@ void iavf_add_ether_addrs(struct iavf_adapter *adapter)
 	list_for_each_entry(f, &adapter->mac_filter_list, list) {
 		if (f->add) {
 			ether_addr_copy(veal->list[i].addr, f->macaddr);
+			iavf_set_mac_addr_type(&veal->list[i], f);
 			i++;
 			f->add = false;
 			if (i == count)
@@ -577,6 +592,7 @@ void iavf_del_ether_addrs(struct iavf_adapter *adapter)
 	list_for_each_entry_safe(f, ftmp, &adapter->mac_filter_list, list) {
 		if (f->remove) {
 			ether_addr_copy(veal->list[i].addr, f->macaddr);
+			iavf_set_mac_addr_type(&veal->list[i], f);
 			i++;
 			list_del(&f->list);
 			kfree(f);
-- 
2.31.1

