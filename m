Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1745550972D
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 08:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384670AbiDUGMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 02:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384666AbiDUGMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 02:12:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ECBFF12AB5
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 23:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650521353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/dOQNsOmM1MUaVrem0LP2ZSBzVM1GxsxZUNbZeeUFHQ=;
        b=FbG0vtSZbGjX8pnU4NcF+CciKMqxTyZIVHKpiokmFB6Gr04+q5WipZet+FG/sLubsuA7SR
        iic/6qnxVRzZVBIjs51BN4dWE1CXGYD1nZD5tnnB6qYporBlkWCxX3oc8EJparlcC/eHHj
        X5NLbwkQDRjkE/b72pYnIY9bKGMk1gU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-NG4R3TM5OumtvfGnALpU7A-1; Thu, 21 Apr 2022 02:09:09 -0400
X-MC-Unique: NG4R3TM5OumtvfGnALpU7A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF1C2811E78;
        Thu, 21 Apr 2022 06:09:08 +0000 (UTC)
Received: from ceranb.redhat.com (unknown [10.40.194.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8BE0145B96B;
        Thu, 21 Apr 2022 06:09:06 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     poros@redhat.com, mschmidt@redhat.com,
        Leon Romanovsky <leon@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net v3] ice: Fix race during aux device (un)plugging
Date:   Thu, 21 Apr 2022 08:09:05 +0200
Message-Id: <20220421060906.1902576-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
call to ensure that aux device is valid during that call. Device
lock used ice_send_event_to_aux() to avoid its concurrent run can
be removed as this is secured by that mutex.

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
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice.h      |  1 +
 drivers/net/ethernet/intel/ice/ice_idc.c  | 33 ++++++++++++++---------
 drivers/net/ethernet/intel/ice/ice_main.c |  2 ++
 3 files changed, 23 insertions(+), 13 deletions(-)

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
index 25a436d342c2..b9e471137f6a 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -10,13 +10,15 @@
  * ice_get_auxiliary_drv - retrieve iidc_auxiliary_drv struct
  * @pf: pointer to PF struct
  *
- * This function has to be called with a device_lock on the
- * pf->adev.dev to avoid race conditions.
+ * This function has to be called with pf->adev_mutex held
+ * to avoid race conditions.
  */
 static struct iidc_auxiliary_drv *ice_get_auxiliary_drv(struct ice_pf *pf)
 {
 	struct auxiliary_device *adev;
 
+	lockdep_assert_held(&pf->adev_mutex);
+
 	adev = pf->adev;
 	if (!adev || !adev->dev.driver)
 		return NULL;
@@ -37,14 +39,13 @@ void ice_send_event_to_aux(struct ice_pf *pf, struct iidc_event *event)
 	if (WARN_ON_ONCE(!in_task()))
 		return;
 
-	if (!pf->adev)
-		return;
+	mutex_lock(&pf->adev_mutex);
 
-	device_lock(&pf->adev->dev);
 	iadrv = ice_get_auxiliary_drv(pf);
 	if (iadrv && iadrv->event_handler)
 		iadrv->event_handler(pf, event);
-	device_unlock(&pf->adev->dev);
+
+	mutex_unlock(&pf->adev_mutex);
 }
 
 /**
@@ -290,7 +291,6 @@ int ice_plug_aux_dev(struct ice_pf *pf)
 		return -ENOMEM;
 
 	adev = &iadev->adev;
-	pf->adev = adev;
 	iadev->pf = pf;
 
 	adev->id = pf->aux_idx;
@@ -300,18 +300,20 @@ int ice_plug_aux_dev(struct ice_pf *pf)
 
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
 
@@ -320,12 +322,17 @@ int ice_plug_aux_dev(struct ice_pf *pf)
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
index 5b1198859da7..2cbbf7abefc4 100644
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

