Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5A54D5013
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 18:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244422AbiCJRSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 12:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244481AbiCJRR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 12:17:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA225186405
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 09:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646932615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+vBaDCvIEZvSxB2vvfgeDxXoY9yQPk8bK+m5bKAq3ls=;
        b=TjB5TQT3+ICwJVZnKRkjXRSHyqtt7Iyb1o+RtMX3Ygx9ykGg17ZYC/xqGOLMXmP0MaTbvv
        aiw6Qn9cp42+co2jCmizFerZC0izpks+uDtVkufe7wJ7H2mgYK/x5F+pjQQc8YOJ84jNap
        GWXtmLJLKx7VGOTrkL8it7T26z8A9pk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-6p7-5q2ONC6WsqYnoWuYKg-1; Thu, 10 Mar 2022 12:16:51 -0500
X-MC-Unique: 6p7-5q2ONC6WsqYnoWuYKg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 387E41091DA0;
        Thu, 10 Mar 2022 17:16:50 +0000 (UTC)
Received: from ceranb.redhat.com (unknown [10.39.192.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 981DC101E692;
        Thu, 10 Mar 2022 17:16:42 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Petr Oros <poros@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] ice: Fix race condition during interface enslave
Date:   Thu, 10 Mar 2022 18:16:41 +0100
Message-Id: <20220310171641.3863659-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 5dbbbd01cbba83 ("ice: Avoid RTNL lock when re-creating
auxiliary device") changes a process of re-creation of aux device
so ice_plug_aux_dev() is called from ice_service_task() context.
This unfortunately opens a race window that can result in dead-lock
when interface has left LAG and immediately enters LAG again.

Reproducer:
```
#!/bin/sh

ip link add lag0 type bond mode 1 miimon 100
ip link set lag0

for n in {1..10}; do
        echo Cycle: $n
        ip link set ens7f0 master lag0
        sleep 1
        ip link set ens7f0 nomaster
done
```

This results in:
[20976.208697] Workqueue: ice ice_service_task [ice]
[20976.213422] Call Trace:
[20976.215871]  __schedule+0x2d1/0x830
[20976.219364]  schedule+0x35/0xa0
[20976.222510]  schedule_preempt_disabled+0xa/0x10
[20976.227043]  __mutex_lock.isra.7+0x310/0x420
[20976.235071]  enum_all_gids_of_dev_cb+0x1c/0x100 [ib_core]
[20976.251215]  ib_enum_roce_netdev+0xa4/0xe0 [ib_core]
[20976.256192]  ib_cache_setup_one+0x33/0xa0 [ib_core]
[20976.261079]  ib_register_device+0x40d/0x580 [ib_core]
[20976.266139]  irdma_ib_register_device+0x129/0x250 [irdma]
[20976.281409]  irdma_probe+0x2c1/0x360 [irdma]
[20976.285691]  auxiliary_bus_probe+0x45/0x70
[20976.289790]  really_probe+0x1f2/0x480
[20976.298509]  driver_probe_device+0x49/0xc0
[20976.302609]  bus_for_each_drv+0x79/0xc0
[20976.306448]  __device_attach+0xdc/0x160
[20976.310286]  bus_probe_device+0x9d/0xb0
[20976.314128]  device_add+0x43c/0x890
[20976.321287]  __auxiliary_device_add+0x43/0x60
[20976.325644]  ice_plug_aux_dev+0xb2/0x100 [ice]
[20976.330109]  ice_service_task+0xd0c/0xed0 [ice]
[20976.342591]  process_one_work+0x1a7/0x360
[20976.350536]  worker_thread+0x30/0x390
[20976.358128]  kthread+0x10a/0x120
[20976.365547]  ret_from_fork+0x1f/0x40
...
[20976.438030] task:ip              state:D stack:    0 pid:213658 ppid:213627 flags:0x00004084
[20976.446469] Call Trace:
[20976.448921]  __schedule+0x2d1/0x830
[20976.452414]  schedule+0x35/0xa0
[20976.455559]  schedule_preempt_disabled+0xa/0x10
[20976.460090]  __mutex_lock.isra.7+0x310/0x420
[20976.464364]  device_del+0x36/0x3c0
[20976.467772]  ice_unplug_aux_dev+0x1a/0x40 [ice]
[20976.472313]  ice_lag_event_handler+0x2a2/0x520 [ice]
[20976.477288]  notifier_call_chain+0x47/0x70
[20976.481386]  __netdev_upper_dev_link+0x18b/0x280
[20976.489845]  bond_enslave+0xe05/0x1790 [bonding]
[20976.494475]  do_setlink+0x336/0xf50
[20976.502517]  __rtnl_newlink+0x529/0x8b0
[20976.543441]  rtnl_newlink+0x43/0x60
[20976.546934]  rtnetlink_rcv_msg+0x2b1/0x360
[20976.559238]  netlink_rcv_skb+0x4c/0x120
[20976.563079]  netlink_unicast+0x196/0x230
[20976.567005]  netlink_sendmsg+0x204/0x3d0
[20976.570930]  sock_sendmsg+0x4c/0x50
[20976.574423]  ____sys_sendmsg+0x1eb/0x250
[20976.586807]  ___sys_sendmsg+0x7c/0xc0
[20976.606353]  __sys_sendmsg+0x57/0xa0
[20976.609930]  do_syscall_64+0x5b/0x1a0
[20976.613598]  entry_SYSCALL_64_after_hwframe+0x65/0xca

1. Command 'ip link ... set nomaster' causes that ice_plug_aux_dev()
   is called from ice_service_task() context, aux device is created
   and associated device->lock is taken.
2. Command 'ip link ... set master...' calls ice's notifier under
   RTNL lock and that notifier calls ice_unplug_aux_dev(). That
   function tries to take aux device->lock but this is already taken
   by ice_plug_aux_dev() in step 1
3. Later ice_plug_aux_dev() tries to take RTNL lock but this is already
   taken in step 2
4. Dead-lock

The patch fixes this issue by following changes:
- Bit ICE_FLAG_PLUG_AUX_DEV is kept to be set during ice_plug_aux_dev()
  call in ice_service_task()
- The bit is checked in ice_clear_rdma_cap() and only if it is not set
  then ice_unplug_aux_dev() is called. If it is set (in other words
  plugging of aux device was requested and ice_plug_aux_dev() is
  potentially running) then the function only clears the bit
- Once ice_plug_aux_dev() call (in ice_service_task) is finished
  the bit ICE_FLAG_PLUG_AUX_DEV is cleared but it is also checked
  whether it was already cleared by ice_clear_rdma_cap(). If so then
  aux device is unplugged.

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Co-developed-by: Petr Oros <poros@redhat.com>
Signed-off-by: Petr Oros <poros@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice.h      | 11 ++++++++++-
 drivers/net/ethernet/intel/ice/ice_main.c | 12 +++++++++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 3121f9b04f59..bea1d1e39fa2 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -898,7 +898,16 @@ static inline void ice_set_rdma_cap(struct ice_pf *pf)
  */
 static inline void ice_clear_rdma_cap(struct ice_pf *pf)
 {
-	ice_unplug_aux_dev(pf);
+	/* We can directly unplug aux device here only if the flag bit
+	 * ICE_FLAG_PLUG_AUX_DEV is not set because ice_unplug_aux_dev()
+	 * could race with ice_plug_aux_dev() called from
+	 * ice_service_task(). In this case we only clear that bit now and
+	 * aux device will be unplugged later once ice_plug_aux_device()
+	 * called from ice_service_task() finishes (see ice_service_task()).
+	 */
+	if (!test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
+		ice_unplug_aux_dev(pf);
+
 	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
 	clear_bit(ICE_FLAG_AUX_ENA, pf->flags);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 83e3e8aae6cf..493942e910be 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2255,9 +2255,19 @@ static void ice_service_task(struct work_struct *work)
 		return;
 	}
 
-	if (test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
+	if (test_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags)) {
+		/* Plug aux device per request */
 		ice_plug_aux_dev(pf);
 
+		/* Mark plugging as done but check whether unplug was
+		 * requested during ice_plug_aux_dev() call
+		 * (e.g. from ice_clear_rdma_cap()) and if so then
+		 * plug aux device.
+		 */
+		if (!test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
+			ice_unplug_aux_dev(pf);
+	}
+
 	if (test_and_clear_bit(ICE_FLAG_MTU_CHANGED, pf->flags)) {
 		struct iidc_event *event;
 
-- 
2.34.1

