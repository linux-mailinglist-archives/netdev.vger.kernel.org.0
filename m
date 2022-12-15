Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFD764E404
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 23:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiLOWwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 17:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiLOWwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 17:52:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE00A4387E
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 14:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671144687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dsHJetG27yiI6FUr4kvtQJoD3YgYVHON/vF/PBZ7EyM=;
        b=NTYJ+Q7xcKd9fNDI2KlGRASnNvDFseJkTYSbVLMeFjBZRjKA3my552p6HFqCx4Ivh46xTa
        KMPzJmZIwBrYwZTOp/U+uLZmk6kMbRGg8TVBeLftkp7PlAS3vDWpJFWCrVndwAwWvfwrSi
        E4ukvgNYLDZAV6z0KFh5LWqnoo/Zl0Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-n_RPPt5kN-mHhzjDCvnNDA-1; Thu, 15 Dec 2022 17:51:17 -0500
X-MC-Unique: n_RPPt5kN-mHhzjDCvnNDA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D37C03806116;
        Thu, 15 Dec 2022 22:51:16 +0000 (UTC)
Received: from toolbox.redhat.com (ovpn-192-38.brq.redhat.com [10.40.192.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C88F62166B29;
        Thu, 15 Dec 2022 22:51:15 +0000 (UTC)
From:   Michal Schmidt <mschmidt@redhat.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Patryk Piotrowski <patryk.piotrowski@intel.com>
Subject: [PATCH net 2/2] iavf: avoid taking rtnl_lock in adminq_task
Date:   Thu, 15 Dec 2022 23:50:49 +0100
Message-Id: <20221215225049.508812-3-mschmidt@redhat.com>
In-Reply-To: <20221215225049.508812-1-mschmidt@redhat.com>
References: <20221215225049.508812-1-mschmidt@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

adminq_task processes virtchnl completions. iavf_set_mac() needs
virtchnl communication to progress while it holds rtnl_lock.
So adminq_task must not take rtnl_lock.

Do the handling of netdev features updates in a new work, features_task.
The new work cannot run on the same ordered workqueue as adminq_task.
The system-wide system_unbound_wq will do.

iavf_set_queue_vlan_tag_loc(), which iterates through queues, must run
under crit_lock to prevent a concurrent iavf_free_queues() possibly
called from watchdog_task or reset_task.

IAVF_FLAG_SETUP_NETDEV_FEATURES becomes unnecessary. features_task can
be queued directly from iavf_virtchnl_completion().

Fixes: 35a2443d0910 ("iavf: Add waiting for response from PF in set mac")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 49 ++++++++++++-------
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  6 ++-
 3 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 2a9f1eeeb701..7dfd6dac74e4 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -252,6 +252,7 @@ struct iavf_adapter {
 	struct workqueue_struct *wq;
 	struct work_struct reset_task;
 	struct work_struct adminq_task;
+	struct work_struct features_task;
 	struct delayed_work client_task;
 	wait_queue_head_t down_waitqueue;
 	wait_queue_head_t vc_waitqueue;
@@ -297,7 +298,6 @@ struct iavf_adapter {
 #define IAVF_FLAG_LEGACY_RX			BIT(15)
 #define IAVF_FLAG_REINIT_ITR_NEEDED		BIT(16)
 #define IAVF_FLAG_QUEUES_DISABLED		BIT(17)
-#define IAVF_FLAG_SETUP_NETDEV_FEATURES		BIT(18)
 #define IAVF_FLAG_REINIT_MSIX_NEEDED		BIT(20)
 /* duplicates for common code */
 #define IAVF_FLAG_DCB_ENABLED			0
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index e7380f1b4acc..e53f5262c047 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3187,6 +3187,35 @@ static void iavf_reset_task(struct work_struct *work)
 	rtnl_unlock();
 }
 
+/**
+ * iavf_features_task - update netdev features after caps negotiation
+ * @work: pointer to work_struct
+ *
+ * After negotiating VLAN caps with the PF, we need to update our netdev
+ * features, but this requires rtnl_lock. We cannot take it directly in
+ * adminq_task - we might deadlock with iavf_set_mac, which waits on
+ * virtchnl communication while holding rtnl_lock.
+ * So the features are updated here, using a different workqueue.
+ **/
+static void iavf_features_task(struct work_struct *work)
+{
+	struct iavf_adapter *adapter = container_of(work,
+						    struct iavf_adapter,
+						    features_task);
+	struct net_device *netdev = adapter->netdev;
+
+	rtnl_lock();
+	netdev_update_features(netdev);
+	rtnl_unlock();
+	/* Request VLAN offload settings */
+	if (VLAN_V2_ALLOWED(adapter))
+		iavf_set_vlan_offload_features(adapter, 0, netdev->features);
+
+	mutex_lock(&adapter->crit_lock);
+	iavf_set_queue_vlan_tag_loc(adapter);
+	mutex_unlock(&adapter->crit_lock);
+}
+
 /**
  * iavf_adminq_task - worker thread to clean the admin queue
  * @work: pointer to work_struct containing our data
@@ -3233,24 +3262,6 @@ static void iavf_adminq_task(struct work_struct *work)
 	} while (pending);
 	mutex_unlock(&adapter->crit_lock);
 
-	if ((adapter->flags & IAVF_FLAG_SETUP_NETDEV_FEATURES)) {
-		if (adapter->netdev_registered ||
-		    !test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section)) {
-			struct net_device *netdev = adapter->netdev;
-
-			rtnl_lock();
-			netdev_update_features(netdev);
-			rtnl_unlock();
-			/* Request VLAN offload settings */
-			if (VLAN_V2_ALLOWED(adapter))
-				iavf_set_vlan_offload_features
-					(adapter, 0, netdev->features);
-
-			iavf_set_queue_vlan_tag_loc(adapter);
-		}
-
-		adapter->flags &= ~IAVF_FLAG_SETUP_NETDEV_FEATURES;
-	}
 	if ((adapter->flags &
 	     (IAVF_FLAG_RESET_PENDING | IAVF_FLAG_RESET_NEEDED)) ||
 	    adapter->state == __IAVF_RESETTING)
@@ -4948,6 +4959,7 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	INIT_WORK(&adapter->reset_task, iavf_reset_task);
 	INIT_WORK(&adapter->adminq_task, iavf_adminq_task);
+	INIT_WORK(&adapter->features_task, iavf_features_task);
 	INIT_DELAYED_WORK(&adapter->watchdog_task, iavf_watchdog_task);
 	INIT_DELAYED_WORK(&adapter->client_task, iavf_client_task);
 	queue_delayed_work(adapter->wq, &adapter->watchdog_task,
@@ -5115,6 +5127,7 @@ static void iavf_remove(struct pci_dev *pdev)
 	cancel_delayed_work_sync(&adapter->watchdog_task);
 	cancel_work_sync(&adapter->adminq_task);
 	cancel_delayed_work_sync(&adapter->client_task);
+	cancel_work_sync(&adapter->features_task);
 
 	adapter->aq_required = 0;
 	adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 0752fd67c96e..a644ab3804de 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -2225,7 +2225,6 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 				     sizeof(adapter->vlan_v2_caps)));
 
 		iavf_process_config(adapter);
-		adapter->flags |= IAVF_FLAG_SETUP_NETDEV_FEATURES;
 		was_mac_changed = !ether_addr_equal(netdev->dev_addr,
 						    adapter->hw.mac.addr);
 
@@ -2266,6 +2265,11 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 
 		adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER |
 			aq_required;
+
+		if (adapter->netdev_registered ||
+		    !test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
+			queue_work(system_unbound_wq,
+				   &adapter->features_task);
 		}
 		break;
 	case VIRTCHNL_OP_ENABLE_QUEUES:
-- 
2.37.2

