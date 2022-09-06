Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278985AF776
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiIFV4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiIFV4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:56:15 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6F08E9B7
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 14:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662501374; x=1694037374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oR0NDucJarVUObB3Y0VJfYNB5fQ9HqwueEDXb8y7OvU=;
  b=NzvQPmQLYtV65J6D68twIth7F7k8Jm2xdrHVt9H5RXUR2jlLxFGBd8js
   mBhxNbEFT08lDPgCNRpFFa9FtEQ6OVHWptp1Ntqbtyoq6kO0G2IaYLzOn
   NvajghzQyFoRoG0lyVvL2vYt+Frrr9H+/IvSWOg9Eb9eAQ7Jr4G0DoDCt
   G4OqWKt+6u8jaBJnferrFn1bcypma86HfyOWmPYiIjoSGDEQMCIiCKk1u
   JaL3jAt5+2zc/ZmR4B+cKmL+Lb3N69nFzaaAJnUNPsISBUp8vVNhg+v8q
   Oftcv5m7/FKcgOAijm6/FQAHa4pPLWPw8Ir8bnj37yzDtM756mKoixz1p
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="383012348"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="383012348"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 14:56:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="682562903"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 06 Sep 2022 14:56:14 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Jaron <michalx.jaron@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 3/3] iavf: Fix race between iavf_close and iavf_reset_task
Date:   Tue,  6 Sep 2022 14:56:06 -0700
Message-Id: <20220906215606.3501995-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906215606.3501995-1-anthony.l.nguyen@intel.com>
References: <20220906215606.3501995-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Jaron <michalx.jaron@intel.com>

During stress tests with adding VF to namespace and changing vf's
trust there was a race between iavf_reset_task and iavf_close.
Sometimes when IAVF_FLAG_AQ_DISABLE_QUEUES from iavf_close was sent
to PF after reset and before IAVF_AQ_GET_CONFIG was sent then PF
returns error IAVF_NOT_SUPPORTED to disable queues request and
following requests. There is need to get_config before other
aq_required will be send but iavf_close clears all flags, if
get_config was not sent before iavf_close, then it will not be send
at all.

In case when IAVF_FLAG_AQ_GET_OFFLOAD_VLAN_V2_CAPS was sent before
IAVF_FLAG_AQ_DISABLE_QUEUES then there was rtnl_lock deadlock
between iavf_close and iavf_adminq_task until iavf_close timeouts
and disable queues was sent after iavf_close ends.

There was also a problem with sending delete/add filters.
Sometimes when filters was not yet added to PF and in
iavf_close all filters was set to remove there might be a try
to remove nonexistent filters on PF.

Add aq_required_tmp to save aq_required flags and send them after
disable_queues will be handled. Clear flags given to iavf_down
different than IAVF_FLAG_AQ_GET_CONFIG as this flag is necessary
to sent other aq_required. Remove some flags that we don't
want to send as we are in iavf_close and we want to disable
interface. Remove filters which was not yet sent and send del
filters flags only when there are filters to remove.

Signed-off-by: Michal Jaron <michalx.jaron@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 177 ++++++++++++++++----
 1 file changed, 141 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index f39440ad5c50..b62bf4eb6870 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1270,66 +1270,138 @@ static void iavf_up_complete(struct iavf_adapter *adapter)
 }
 
 /**
- * iavf_down - Shutdown the connection processing
+ * iavf_clear_mac_vlan_filters - Remove mac and vlan filters not sent to PF
+ * yet and mark other to be removed.
  * @adapter: board private structure
- *
- * Expects to be called while holding the __IAVF_IN_CRITICAL_TASK bit lock.
  **/
-void iavf_down(struct iavf_adapter *adapter)
+static void iavf_clear_mac_vlan_filters(struct iavf_adapter *adapter)
 {
-	struct net_device *netdev = adapter->netdev;
-	struct iavf_vlan_filter *vlf;
-	struct iavf_cloud_filter *cf;
-	struct iavf_fdir_fltr *fdir;
-	struct iavf_mac_filter *f;
-	struct iavf_adv_rss *rss;
-
-	if (adapter->state <= __IAVF_DOWN_PENDING)
-		return;
-
-	netif_carrier_off(netdev);
-	netif_tx_disable(netdev);
-	adapter->link_up = false;
-	iavf_napi_disable_all(adapter);
-	iavf_irq_disable(adapter);
+	struct iavf_vlan_filter *vlf, *vlftmp;
+	struct iavf_mac_filter *f, *ftmp;
 
 	spin_lock_bh(&adapter->mac_vlan_list_lock);
-
 	/* clear the sync flag on all filters */
 	__dev_uc_unsync(adapter->netdev, NULL);
 	__dev_mc_unsync(adapter->netdev, NULL);
 
 	/* remove all MAC filters */
-	list_for_each_entry(f, &adapter->mac_filter_list, list) {
-		f->remove = true;
+	list_for_each_entry_safe(f, ftmp, &adapter->mac_filter_list,
+				 list) {
+		if (f->add) {
+			list_del(&f->list);
+			kfree(f);
+		} else {
+			f->remove = true;
+		}
 	}
 
 	/* remove all VLAN filters */
-	list_for_each_entry(vlf, &adapter->vlan_filter_list, list) {
-		vlf->remove = true;
+	list_for_each_entry_safe(vlf, vlftmp, &adapter->vlan_filter_list,
+				 list) {
+		if (vlf->add) {
+			list_del(&vlf->list);
+			kfree(vlf);
+		} else {
+			vlf->remove = true;
+		}
 	}
-
 	spin_unlock_bh(&adapter->mac_vlan_list_lock);
+}
+
+/**
+ * iavf_clear_cloud_filters - Remove cloud filters not sent to PF yet and
+ * mark other to be removed.
+ * @adapter: board private structure
+ **/
+static void iavf_clear_cloud_filters(struct iavf_adapter *adapter)
+{
+	struct iavf_cloud_filter *cf, *cftmp;
 
 	/* remove all cloud filters */
 	spin_lock_bh(&adapter->cloud_filter_list_lock);
-	list_for_each_entry(cf, &adapter->cloud_filter_list, list) {
-		cf->del = true;
+	list_for_each_entry_safe(cf, cftmp, &adapter->cloud_filter_list,
+				 list) {
+		if (cf->add) {
+			list_del(&cf->list);
+			kfree(cf);
+			adapter->num_cloud_filters--;
+		} else {
+			cf->del = true;
+		}
 	}
 	spin_unlock_bh(&adapter->cloud_filter_list_lock);
+}
+
+/**
+ * iavf_clear_fdir_filters - Remove fdir filters not sent to PF yet and mark
+ * other to be removed.
+ * @adapter: board private structure
+ **/
+static void iavf_clear_fdir_filters(struct iavf_adapter *adapter)
+{
+	struct iavf_fdir_fltr *fdir, *fdirtmp;
 
 	/* remove all Flow Director filters */
 	spin_lock_bh(&adapter->fdir_fltr_lock);
-	list_for_each_entry(fdir, &adapter->fdir_list_head, list) {
-		fdir->state = IAVF_FDIR_FLTR_DEL_REQUEST;
+	list_for_each_entry_safe(fdir, fdirtmp, &adapter->fdir_list_head,
+				 list) {
+		if (fdir->state == IAVF_FDIR_FLTR_ADD_REQUEST) {
+			list_del(&fdir->list);
+			kfree(fdir);
+			adapter->fdir_active_fltr--;
+		} else {
+			fdir->state = IAVF_FDIR_FLTR_DEL_REQUEST;
+		}
 	}
 	spin_unlock_bh(&adapter->fdir_fltr_lock);
+}
+
+/**
+ * iavf_clear_adv_rss_conf - Remove adv rss conf not sent to PF yet and mark
+ * other to be removed.
+ * @adapter: board private structure
+ **/
+static void iavf_clear_adv_rss_conf(struct iavf_adapter *adapter)
+{
+	struct iavf_adv_rss *rss, *rsstmp;
 
 	/* remove all advance RSS configuration */
 	spin_lock_bh(&adapter->adv_rss_lock);
-	list_for_each_entry(rss, &adapter->adv_rss_list_head, list)
-		rss->state = IAVF_ADV_RSS_DEL_REQUEST;
+	list_for_each_entry_safe(rss, rsstmp, &adapter->adv_rss_list_head,
+				 list) {
+		if (rss->state == IAVF_ADV_RSS_ADD_REQUEST) {
+			list_del(&rss->list);
+			kfree(rss);
+		} else {
+			rss->state = IAVF_ADV_RSS_DEL_REQUEST;
+		}
+	}
 	spin_unlock_bh(&adapter->adv_rss_lock);
+}
+
+/**
+ * iavf_down - Shutdown the connection processing
+ * @adapter: board private structure
+ *
+ * Expects to be called while holding the __IAVF_IN_CRITICAL_TASK bit lock.
+ **/
+void iavf_down(struct iavf_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+
+	if (adapter->state <= __IAVF_DOWN_PENDING)
+		return;
+
+	netif_carrier_off(netdev);
+	netif_tx_disable(netdev);
+	adapter->link_up = false;
+	iavf_napi_disable_all(adapter);
+	iavf_irq_disable(adapter);
+
+	iavf_clear_mac_vlan_filters(adapter);
+	iavf_clear_cloud_filters(adapter);
+	iavf_clear_fdir_filters(adapter);
+	iavf_clear_adv_rss_conf(adapter);
 
 	if (!(adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)) {
 		/* cancel any current operation */
@@ -1338,11 +1410,16 @@ void iavf_down(struct iavf_adapter *adapter)
 		 * here for this to complete. The watchdog is still running
 		 * and it will take care of this.
 		 */
-		adapter->aq_required = IAVF_FLAG_AQ_DEL_MAC_FILTER;
-		adapter->aq_required |= IAVF_FLAG_AQ_DEL_VLAN_FILTER;
-		adapter->aq_required |= IAVF_FLAG_AQ_DEL_CLOUD_FILTER;
-		adapter->aq_required |= IAVF_FLAG_AQ_DEL_FDIR_FILTER;
-		adapter->aq_required |= IAVF_FLAG_AQ_DEL_ADV_RSS_CFG;
+		if (!list_empty(&adapter->mac_filter_list))
+			adapter->aq_required |= IAVF_FLAG_AQ_DEL_MAC_FILTER;
+		if (!list_empty(&adapter->vlan_filter_list))
+			adapter->aq_required |= IAVF_FLAG_AQ_DEL_VLAN_FILTER;
+		if (!list_empty(&adapter->cloud_filter_list))
+			adapter->aq_required |= IAVF_FLAG_AQ_DEL_CLOUD_FILTER;
+		if (!list_empty(&adapter->fdir_list_head))
+			adapter->aq_required |= IAVF_FLAG_AQ_DEL_FDIR_FILTER;
+		if (!list_empty(&adapter->adv_rss_list_head))
+			adapter->aq_required |= IAVF_FLAG_AQ_DEL_ADV_RSS_CFG;
 		adapter->aq_required |= IAVF_FLAG_AQ_DISABLE_QUEUES;
 	}
 
@@ -4173,6 +4250,7 @@ static int iavf_open(struct net_device *netdev)
 static int iavf_close(struct net_device *netdev)
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
+	u64 aq_to_restore;
 	int status;
 
 	mutex_lock(&adapter->crit_lock);
@@ -4185,6 +4263,29 @@ static int iavf_close(struct net_device *netdev)
 	set_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
 	if (CLIENT_ENABLED(adapter))
 		adapter->flags |= IAVF_FLAG_CLIENT_NEEDS_CLOSE;
+	/* We cannot send IAVF_FLAG_AQ_GET_OFFLOAD_VLAN_V2_CAPS before
+	 * IAVF_FLAG_AQ_DISABLE_QUEUES because in such case there is rtnl
+	 * deadlock with adminq_task() until iavf_close timeouts. We must send
+	 * IAVF_FLAG_AQ_GET_CONFIG before IAVF_FLAG_AQ_DISABLE_QUEUES to make
+	 * disable queues possible for vf. Give only necessary flags to
+	 * iavf_down and save other to set them right before iavf_close()
+	 * returns, when IAVF_FLAG_AQ_DISABLE_QUEUES will be already sent and
+	 * iavf will be in DOWN state.
+	 */
+	aq_to_restore = adapter->aq_required;
+	adapter->aq_required &= IAVF_FLAG_AQ_GET_CONFIG;
+
+	/* Remove flags which we do not want to send after close or we want to
+	 * send before disable queues.
+	 */
+	aq_to_restore &= ~(IAVF_FLAG_AQ_GET_CONFIG		|
+			   IAVF_FLAG_AQ_ENABLE_QUEUES		|
+			   IAVF_FLAG_AQ_CONFIGURE_QUEUES	|
+			   IAVF_FLAG_AQ_ADD_VLAN_FILTER		|
+			   IAVF_FLAG_AQ_ADD_MAC_FILTER		|
+			   IAVF_FLAG_AQ_ADD_CLOUD_FILTER	|
+			   IAVF_FLAG_AQ_ADD_FDIR_FILTER		|
+			   IAVF_FLAG_AQ_ADD_ADV_RSS_CFG);
 
 	iavf_down(adapter);
 	iavf_change_state(adapter, __IAVF_DOWN_PENDING);
@@ -4208,6 +4309,10 @@ static int iavf_close(struct net_device *netdev)
 				    msecs_to_jiffies(500));
 	if (!status)
 		netdev_warn(netdev, "Device resources not yet released\n");
+
+	mutex_lock(&adapter->crit_lock);
+	adapter->aq_required |= aq_to_restore;
+	mutex_unlock(&adapter->crit_lock);
 	return 0;
 }
 
-- 
2.35.1

