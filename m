Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5CD9695C56
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 09:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjBNIK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 03:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjBNIKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 03:10:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4708227B8
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 00:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676362174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rB5ID/2Qs9ceDcs0KHL5dcmrag9/xwe+5cqfsigTfHY=;
        b=AznlYTCqbFhAuO6cCJTA1L6gphNl1wnckJTPtQ3eTZnnr7POkfb3eh1pex6tkjd6Sz+dn0
        geRXNGwofQtzZcnIgP05zjCwwapDUO2c0uIflM8HLrSIAunOVBOHqNP3uxFFTIQ8HB7ZOj
        LyRm3FCIYMgTTOm7wQ/2UKX0wFMle1U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-cI3ZZsQEOxmLpapnfXyNlg-1; Tue, 14 Feb 2023 03:09:31 -0500
X-MC-Unique: cI3ZZsQEOxmLpapnfXyNlg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7D92857A99;
        Tue, 14 Feb 2023 08:09:30 +0000 (UTC)
Received: from server.redhat.com (ovpn-13-103.pek2.redhat.com [10.72.13.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6EDA240C10FA;
        Tue, 14 Feb 2023 08:09:27 +0000 (UTC)
From:   Cindy Lu <lulu@redhat.com>
To:     lulu@redhat.com, jasowang@redhat.com, mst@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v2] vp_vdpa: fix the crash in hot unplug with vp_vdpa
Date:   Tue, 14 Feb 2023 16:09:24 +0800
Message-Id: <20230214080924.131462-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While unplugging the vp_vdpa device, it triggers a kernel panic
The root cause is: vdpa_mgmtdev_unregister() will accesses modern
devices which will cause a use after free.
So need to change the sequence in vp_vdpa_remove

[  195.003359] BUG: unable to handle page fault for address: ff4e8beb80199014
[  195.004012] #PF: supervisor read access in kernel mode
[  195.004486] #PF: error_code(0x0000) - not-present page
[  195.004960] PGD 100000067 P4D 1001b6067 PUD 1001b7067 PMD 1001b8067 PTE 0
[  195.005578] Oops: 0000 1 PREEMPT SMP PTI
[  195.005968] CPU: 13 PID: 164 Comm: kworker/u56:10 Kdump: loaded Not tainted 5.14.0-252.el9.x86_64 #1
[  195.006792] Hardware name: Red Hat KVM/RHEL, BIOS edk2-20221207gitfff6d81270b5-2.el9 unknown
[  195.007556] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[  195.008059] RIP: 0010:ioread8+0x31/0x80
[  195.008418] Code: 77 28 48 81 ff 00 00 01 00 76 0b 89 fa ec 0f b6 c0 c3 cc cc cc cc 8b 15 ad 72 93 01 b8 ff 00 00 00 85 d2 75 0f c3 cc cc cc cc <8a> 07 0f b6 c0 c3 cc cc cc cc 83 ea 01 48 83 ec 08 48 89 fe 48 c7
[  195.010104] RSP: 0018:ff4e8beb8067bab8 EFLAGS: 00010292
[  195.010584] RAX: ffffffffc05834a0 RBX: ffffffffc05843c0 RCX: ff4e8beb8067bae0
[  195.011233] RDX: ff1bcbd580f88000 RSI: 0000000000000246 RDI: ff4e8beb80199014
[  195.011881] RBP: ff1bcbd587e39000 R08: ffffffff916fa2d0 R09: ff4e8beb8067ba68
[  195.012527] R10: 000000000000001c R11: 0000000000000000 R12: ff1bcbd5a3de9120
[  195.013179] R13: ffffffffc062d000 R14: 0000000000000080 R15: ff1bcbe402bc7805
[  195.013826] FS:  0000000000000000(0000) GS:ff1bcbe402740000(0000) knlGS:0000000000000000
[  195.014564] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  195.015093] CR2: ff4e8beb80199014 CR3: 0000000107dea002 CR4: 0000000000771ee0
[  195.015741] PKRU: 55555554
[  195.016001] Call Trace:
[  195.016233]  <TASK>
[  195.016434]  vp_modern_get_status+0x12/0x20
[  195.016823]  vp_vdpa_reset+0x1b/0x50 [vp_vdpa]
[  195.017238]  virtio_vdpa_reset+0x3c/0x48 [virtio_vdpa]
[  195.017709]  remove_vq_common+0x1f/0x3a0 [virtio_net]
[  195.018178]  virtnet_remove+0x5d/0x70 [virtio_net]
[  195.018618]  virtio_dev_remove+0x3d/0x90
[  195.018986]  device_release_driver_internal+0x1aa/0x230
[  195.019466]  bus_remove_device+0xd8/0x150
[  195.019841]  device_del+0x18b/0x3f0
[  195.020167]  ? kernfs_find_ns+0x35/0xd0
[  195.020526]  device_unregister+0x13/0x60
[  195.020894]  unregister_virtio_device+0x11/0x20
[  195.021311]  device_release_driver_internal+0x1aa/0x230
[  195.021790]  bus_remove_device+0xd8/0x150
[  195.022162]  device_del+0x18b/0x3f0
[  195.022487]  device_unregister+0x13/0x60
[  195.022852]  ? vdpa_dev_remove+0x30/0x30 [vdpa]
[  195.023270]  vp_vdpa_dev_del+0x12/0x20 [vp_vdpa]
[  195.023694]  vdpa_match_remove+0x2b/0x40 [vdpa]
[  195.024115]  bus_for_each_dev+0x78/0xc0
[  195.024471]  vdpa_mgmtdev_unregister+0x65/0x80 [vdpa]
[  195.024937]  vp_vdpa_remove+0x23/0x40 [vp_vdpa]
[  195.025353]  pci_device_remove+0x36/0xa0
[  195.025719]  device_release_driver_internal+0x1aa/0x230
[  195.026201]  pci_stop_bus_device+0x6c/0x90
[  195.026580]  pci_stop_and_remove_bus_device+0xe/0x20
[  195.027039]  disable_slot+0x49/0x90
[  195.027366]  acpiphp_disable_and_eject_slot+0x15/0x90
[  195.027832]  hotplug_event+0xea/0x210
[  195.028171]  ? hotplug_event+0x210/0x210
[  195.028535]  acpiphp_hotplug_notify+0x22/0x80
[  195.028942]  ? hotplug_event+0x210/0x210
[  195.029303]  acpi_device_hotplug+0x8a/0x1d0
[  195.029690]  acpi_hotplug_work_fn+0x1a/0x30
[  195.030077]  process_one_work+0x1e8/0x3c0
[  195.030451]  worker_thread+0x50/0x3b0
[  195.030791]  ? rescuer_thread+0x3a0/0x3a0
[  195.031165]  kthread+0xd9/0x100
[  195.031459]  ? kthread_complete_and_exit+0x20/0x20
[  195.031899]  ret_from_fork+0x22/0x30
[  195.032233]  </TASK>

Fixes: ffbda8e9df10 ("vdpa/vp_vdpa : add vdpa tool support in vp_vdpa")
Tested-by: Lei Yang <leiyang@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vdpa/virtio_pci/vp_vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
index 8fe267ca3e76..281287fae89f 100644
--- a/drivers/vdpa/virtio_pci/vp_vdpa.c
+++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
@@ -645,8 +645,8 @@ static void vp_vdpa_remove(struct pci_dev *pdev)
 	struct virtio_pci_modern_device *mdev = NULL;
 
 	mdev = vp_vdpa_mgtdev->mdev;
-	vp_modern_remove(mdev);
 	vdpa_mgmtdev_unregister(&vp_vdpa_mgtdev->mgtdev);
+	vp_modern_remove(mdev);
 	kfree(vp_vdpa_mgtdev->mgtdev.id_table);
 	kfree(mdev);
 	kfree(vp_vdpa_mgtdev);
-- 
2.34.3

