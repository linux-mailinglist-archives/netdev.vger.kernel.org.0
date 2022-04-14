Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862A5501968
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 19:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242748AbiDNRDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 13:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245329AbiDNRCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 13:02:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34B9B387B0
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 09:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649954353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Hk3S1Buv3yyod0QHK3mlOCiTiU1ixm5RRzrGyqKGjmQ=;
        b=VubzGTwbYzVTB/CD9mAJZikBVFlKoOJvV+PVw78K5iFw2YTXlFtUMpgCH2D1zLokaN5len
        4HwhLwtHmgWYSJ1GnzeyS8hI4RsxjEZvYnmQvKuUntr5UMbuSSvwTXZxVZ9Hy6pEXbW0eU
        IKgjD7o9j0XtEII9IG1nI1TejkW5TT4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-jgLjM6qaPdKjCmeseOWosg-1; Thu, 14 Apr 2022 12:39:10 -0400
X-MC-Unique: jgLjM6qaPdKjCmeseOWosg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42C6986B8A1;
        Thu, 14 Apr 2022 16:39:10 +0000 (UTC)
Received: from ceranb.redhat.com (unknown [10.40.194.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2906140BAEE;
        Thu, 14 Apr 2022 16:39:08 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     poros@redhat.com, mschmidt@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] ice: Fix race during aux device (un)plugging
Date:   Thu, 14 Apr 2022 18:39:06 +0200
Message-Id: <20220414163907.1456925-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function ice_plug_aux_dev() assigns pf->adev field too early prior
aux device initialization and on other side ice_unplug_aux_dev()
starts aux device deinit and at the end assigns NULL to pf->adev.
This is wrong and can causes a crash when ice_send_event_to_aux()
call occurs during these operations because that function depends
on non-NULL value of pf->adev and does not assume that aux device
is half-initialized or half-destroyed.

Modify affected functions so pf->adev field is set after aux device
init and prior aux device destroy.

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
(unplug) and the function ice_send_event_to_aux() can touch
uninitialized or destroyed fields (e.g. pf->adev->dev.mutex like
in the following crash)

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
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice_idc.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index 25a436d342c2..4d889049231b 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -290,7 +290,6 @@ int ice_plug_aux_dev(struct ice_pf *pf)
 		return -ENOMEM;
 
 	adev = &iadev->adev;
-	pf->adev = adev;
 	iadev->pf = pf;
 
 	adev->id = pf->aux_idx;
@@ -300,18 +299,18 @@ int ice_plug_aux_dev(struct ice_pf *pf)
 
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
 
+	pf->adev = adev;
+
 	return 0;
 }
 
@@ -320,12 +319,14 @@ int ice_plug_aux_dev(struct ice_pf *pf)
  */
 void ice_unplug_aux_dev(struct ice_pf *pf)
 {
-	if (!pf->adev)
+	struct auxiliary_device *adev = pf->adev;
+
+	if (!adev)
 		return;
 
-	auxiliary_device_delete(pf->adev);
-	auxiliary_device_uninit(pf->adev);
 	pf->adev = NULL;
+	auxiliary_device_delete(adev);
+	auxiliary_device_uninit(adev);
 }
 
 /**
-- 
2.35.1

