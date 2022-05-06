Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC8651DE6E
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 19:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444248AbiEFRsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 13:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444245AbiEFRsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 13:48:15 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B291B56FAC
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 10:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651859070; x=1683395070;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mmMFAl0Q+bKks7tt4SXE+0WLzhSzifPs9qk4G1cEgvg=;
  b=f4q52rhfQIyzTY0wr/W+zeAAeg5BUg4Z7ixWKN+Y0Ij/jh6LulUH4eDq
   gNs+rYFgEFrYNYPivaWUC2KG4z9tcq7o4HDmdeTfp1cga6pyueabIvlNg
   tpP+LjfTG9uam4sD8nGqn3LIdCzXYHl1soM870wPabXTmgHvQp2mP0MFQ
   etZMuU13a+6laxeuy0D9vEL+66rOBpui8bK90M95CMQdSjjRLACl1QZrQ
   PL20guR6RCX9H7tVmiTxsNnxYQ55HEYo02bzqBpEVslsQ9jm12UB8vUhO
   ++8eLRr6VfMMy6qXzx6llZ6a0w4yzPfhWilOBzoOeVAzr6uoDdT+7clWg
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="331523433"
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="331523433"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 10:44:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="891929170"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 06 May 2022 10:44:28 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net v2 1/3] ice: Fix race during aux device (un)plugging
Date:   Fri,  6 May 2022 10:41:27 -0700
Message-Id: <20220506174129.4976-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506174129.4976-1-anthony.l.nguyen@intel.com>
References: <20220506174129.4976-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>

Function ice_plug_aux_dev() assigns pf->adev field too early prior
aux device initialization and on other side ice_unplug_aux_dev()
starts aux device deinit and at the end assigns NULL to pf->adev.
This is wrong because pf->adev should always be non-NULL only when
aux device is fully initialized and ready. This wrong order causes
a crash when ice_send_event_to_aux() call occurs because that function
depends on non-NULL value of pf->adev and does not assume that
aux device is half-initialized or half-destroyed.
After order correction the race window is tiny but it is still there,
as Leon mentioned and manipulation with pf->adev needs to be protected
by mutex.

Fix (un-)plugging functions so pf->adev field is set after aux device
init and prior aux device destroy and protect pf->adev assignment by
new mutex. This mutex is also held during ice_send_event_to_aux()
call to ensure that aux device is valid during that call.
Note that device lock used ice_send_event_to_aux() needs to be kept
to avoid race with aux drv unload.

Reproducer:
cycle=1
while :;do
        echo "#### Cycle: $cycle"

        ip link set ens7f0 mtu 9000
        ip link add bond0 type bond mode 1 miimon 100
        ip link set bond0 up
        ifenslave bond0 ens7f0
        ip link set bond0 mtu 9000
        ethtool -L ens7f0 combined 1
        ip link del bond0
        ip link set ens7f0 mtu 1500
        sleep 1

        let cycle++
done

In short when the device is added/removed to/from bond the aux device
is unplugged/plugged. When MTU of the device is changed an event is
sent to aux device asynchronously. This can race with (un)plugging
operation and because pf->adev is set too early (plug) or too late
(unplug) the function ice_send_event_to_aux() can touch uninitialized
or destroyed fields. In the case of crash below pf->adev->dev.mutex.

Crash:
[   53.372066] bond0: (slave ens7f0): making interface the new active one
[   53.378622] bond0: (slave ens7f0): Enslaving as an active interface with an u
p link
[   53.386294] IPv6: ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
[   53.549104] bond0: (slave ens7f1): Enslaving as a backup interface with an up
 link
[   54.118906] ice 0000:ca:00.0 ens7f0: Number of in use tx queues changed inval
idating tc mappings. Priority traffic classification disabled!
[   54.233374] ice 0000:ca:00.1 ens7f1: Number of in use tx queues changed inval
idating tc mappings. Priority traffic classification disabled!
[   54.248204] bond0: (slave ens7f0): Releasing backup interface
[   54.253955] bond0: (slave ens7f1): making interface the new active one
[   54.274875] bond0: (slave ens7f1): Releasing backup interface
[   54.289153] bond0 (unregistering): Released all slaves
[   55.383179] MII link monitoring set to 100 ms
[   55.398696] bond0: (slave ens7f0): making interface the new active one
[   55.405241] BUG: kernel NULL pointer dereference, address: 0000000000000080
[   55.405289] bond0: (slave ens7f0): Enslaving as an active interface with an u
p link
[   55.412198] #PF: supervisor write access in kernel mode
[   55.412200] #PF: error_code(0x0002) - not-present page
[   55.412201] PGD 25d2ad067 P4D 0
[   55.412204] Oops: 0002 [#1] PREEMPT SMP NOPTI
[   55.412207] CPU: 0 PID: 403 Comm: kworker/0:2 Kdump: loaded Tainted: G S
           5.17.0-13579-g57f2d6540f03 #1
[   55.429094] bond0: (slave ens7f1): Enslaving as a backup interface with an up
 link
[   55.430224] Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS 1.4.4 10/07/
2021
[   55.430226] Workqueue: ice ice_service_task [ice]
[   55.468169] RIP: 0010:mutex_unlock+0x10/0x20
[   55.472439] Code: 0f b1 13 74 96 eb e0 4c 89 ee eb d8 e8 79 54 ff ff 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 65 48 8b 04 25 40 ef 01 00 31 d2 <f0> 48 0f b1 17 75 01 c3 e9 e3 fe ff ff 0f 1f 00 0f 1f 44 00 00 48
[   55.491186] RSP: 0018:ff4454230d7d7e28 EFLAGS: 00010246
[   55.496413] RAX: ff1a79b208b08000 RBX: ff1a79b2182e8880 RCX: 0000000000000001
[   55.503545] RDX: 0000000000000000 RSI: ff4454230d7d7db0 RDI: 0000000000000080
[   55.510678] RBP: ff1a79d1c7e48b68 R08: ff4454230d7d7db0 R09: 0000000000000041
[   55.517812] R10: 00000000000000a5 R11: 00000000000006e6 R12: ff1a79d1c7e48bc0
[   55.524945] R13: 0000000000000000 R14: ff1a79d0ffc305c0 R15: 0000000000000000
[   55.532076] FS:  0000000000000000(0000) GS:ff1a79d0ffc00000(0000) knlGS:0000000000000000
[   55.540163] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   55.545908] CR2: 0000000000000080 CR3: 00000003487ae003 CR4: 0000000000771ef0
[   55.553041] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   55.560173] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   55.567305] PKRU: 55555554
[   55.570018] Call Trace:
[   55.572474]  <TASK>
[   55.574579]  ice_service_task+0xaab/0xef0 [ice]
[   55.579130]  process_one_work+0x1c5/0x390
[   55.583141]  ? process_one_work+0x390/0x390
[   55.587326]  worker_thread+0x30/0x360
[   55.590994]  ? process_one_work+0x390/0x390
[   55.595180]  kthread+0xe6/0x110
[   55.598325]  ? kthread_complete_and_exit+0x20/0x20
[   55.603116]  ret_from_fork+0x1f/0x30
[   55.606698]  </TASK>

Fixes: f9f5301e7e2d ("ice: Register auxiliary device to provide RDMA")
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      |  1 +
 drivers/net/ethernet/intel/ice/ice_idc.c  | 25 +++++++++++++++--------
 drivers/net/ethernet/intel/ice/ice_main.c |  2 ++
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 8ed3c9ab7ff7..a895e3a8e988 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -540,6 +540,7 @@ struct ice_pf {
 	struct mutex avail_q_mutex;	/* protects access to avail_[rx|tx]qs */
 	struct mutex sw_mutex;		/* lock for protecting VSI alloc flow */
 	struct mutex tc_mutex;		/* lock to protect TC changes */
+	struct mutex adev_mutex;	/* lock to protect aux device access */
 	u32 msg_enable;
 	struct ice_ptp ptp;
 	struct tty_driver *ice_gnss_tty_driver;
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index 25a436d342c2..3e3b2ed4cd5d 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -37,14 +37,17 @@ void ice_send_event_to_aux(struct ice_pf *pf, struct iidc_event *event)
 	if (WARN_ON_ONCE(!in_task()))
 		return;
 
+	mutex_lock(&pf->adev_mutex);
 	if (!pf->adev)
-		return;
+		goto finish;
 
 	device_lock(&pf->adev->dev);
 	iadrv = ice_get_auxiliary_drv(pf);
 	if (iadrv && iadrv->event_handler)
 		iadrv->event_handler(pf, event);
 	device_unlock(&pf->adev->dev);
+finish:
+	mutex_unlock(&pf->adev_mutex);
 }
 
 /**
@@ -290,7 +293,6 @@ int ice_plug_aux_dev(struct ice_pf *pf)
 		return -ENOMEM;
 
 	adev = &iadev->adev;
-	pf->adev = adev;
 	iadev->pf = pf;
 
 	adev->id = pf->aux_idx;
@@ -300,18 +302,20 @@ int ice_plug_aux_dev(struct ice_pf *pf)
 
 	ret = auxiliary_device_init(adev);
 	if (ret) {
-		pf->adev = NULL;
 		kfree(iadev);
 		return ret;
 	}
 
 	ret = auxiliary_device_add(adev);
 	if (ret) {
-		pf->adev = NULL;
 		auxiliary_device_uninit(adev);
 		return ret;
 	}
 
+	mutex_lock(&pf->adev_mutex);
+	pf->adev = adev;
+	mutex_unlock(&pf->adev_mutex);
+
 	return 0;
 }
 
@@ -320,12 +324,17 @@ int ice_plug_aux_dev(struct ice_pf *pf)
  */
 void ice_unplug_aux_dev(struct ice_pf *pf)
 {
-	if (!pf->adev)
-		return;
+	struct auxiliary_device *adev;
 
-	auxiliary_device_delete(pf->adev);
-	auxiliary_device_uninit(pf->adev);
+	mutex_lock(&pf->adev_mutex);
+	adev = pf->adev;
 	pf->adev = NULL;
+	mutex_unlock(&pf->adev_mutex);
+
+	if (adev) {
+		auxiliary_device_delete(adev);
+		auxiliary_device_uninit(adev);
+	}
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 9a0a358a15c2..949669fed7d6 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3769,6 +3769,7 @@ u16 ice_get_avail_rxq_count(struct ice_pf *pf)
 static void ice_deinit_pf(struct ice_pf *pf)
 {
 	ice_service_task_stop(pf);
+	mutex_destroy(&pf->adev_mutex);
 	mutex_destroy(&pf->sw_mutex);
 	mutex_destroy(&pf->tc_mutex);
 	mutex_destroy(&pf->avail_q_mutex);
@@ -3847,6 +3848,7 @@ static int ice_init_pf(struct ice_pf *pf)
 
 	mutex_init(&pf->sw_mutex);
 	mutex_init(&pf->tc_mutex);
+	mutex_init(&pf->adev_mutex);
 
 	INIT_HLIST_HEAD(&pf->aq_wait_list);
 	spin_lock_init(&pf->aq_wait_lock);
-- 
2.35.1

