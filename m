Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A26B4F129A
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 12:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355566AbiDDKIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 06:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239305AbiDDKIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 06:08:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 281003C4A0
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 03:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649066780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0Xe46S5f34nJv0CRL++zPQUatYLF7Rj2oPh8nWt9kps=;
        b=MeROQg7OUQrFCJfeQK9x7MXspeu8o8mS3/46PmBAsynxvM38iHsUSXZ5brmpgpAYskB/oY
        WsulDLjFYUdXGs3Y9zlo9Uv9h0nPXyrwmUrgEew8uWKUnbmsQGGVqSwILum7voVtVmkgGB
        Gztk2mDzUcX7weRreo7oVhPTrmtJyco=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-gRNEeTqEMMevNdTVX-Ew5Q-1; Mon, 04 Apr 2022 06:06:18 -0400
X-MC-Unique: gRNEeTqEMMevNdTVX-Ew5Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B67480419D;
        Mon,  4 Apr 2022 10:06:18 +0000 (UTC)
Received: from ceranb.redhat.com (unknown [10.40.192.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD75B40F907E;
        Mon,  4 Apr 2022 10:06:15 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     poros@redhat.com, mschmidt@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Brett Creeley <brett.creeley@intel.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] ice: Fix use-after-free
Date:   Mon,  4 Apr 2022 12:06:14 +0200
Message-Id: <20220404100615.23525-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_RFS_ACCEL is enabled the driver uses CPU affinity
reverse-maps that set CPU affinity notifier in the background.

If the interface is put down then ice_vsi_free_irq() is called
via ice_vsi_close() and this clears affinity notifiers of IRQs
associated with the VSI and old notifier's release callback
is called - for this case this is cpu_rmap_release() that
frees allocated cpu_rmap.

During device removal (ice_remove()) free_irq_cpu_rmap() is called
and it tries to free already de-allocated cpu_rmap.

Do not clear IRQ affinity notifier in ice_vsi_free_irq() when
CONFIG_RFS_ACCEL is enabled. This is a code-path that
commit 28bf26724fdb ("ice: Implement aRFS") forgot to handle.

Reproducer:
[root@host ~]# ip link set ens7f0 up
[root@host ~]# ip link set ens7f0 down
[root@host ~]# rmmod ice

Result:
[  538.173276] =================================================================
[  538.180615] BUG: KASAN: use-after-free in free_irq_cpu_rmap+0x13b/0x173
[  538.187236] Read of size 4 at addr ff110022d1f9e300 by task rmmod/16218
[  538.193849]
[  538.195350] CPU: 0 PID: 16218 Comm: rmmod Kdump: loaded Not tainted 4.18.0-31
[  538.205613] Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS 1.4.4 10/071
[  538.213089] Call Trace:
[  538.215544]  dump_stack+0x5c/0x80
[  538.218873]  print_address_description.constprop.6+0x1a/0x150
[  538.233182]  kasan_report.cold.11+0x7f/0x118
[  538.241739]  free_irq_cpu_rmap+0x13b/0x173
[  538.245852]  ice_free_cpu_rx_rmap.part.2+0x58/0xa0 [ice]
[  538.251208]  ice_remove_arfs+0xb2/0xf0 [ice]
[  538.255506]  ice_remove+0x4e7/0x620 [ice]
[  538.259553]  pci_device_remove+0xf3/0x290
[  538.275025]  device_release_driver_internal+0x204/0x4b0
[  538.280263]  driver_detach+0xf8/0x1ba
[  538.283937]  bus_remove_driver+0x117/0x2db
[  538.288047]  pci_unregister_driver+0x30/0x230
[  538.297650]  ice_module_exit+0xc/0x2b [ice]
[  538.301864]  __x64_sys_delete_module+0x2cc/0x4a0
[  538.320373]  do_syscall_64+0xa5/0x450
[  538.324046]  entry_SYSCALL_64_after_hwframe+0x6a/0xdf
[  538.329103] RIP: 0033:0x7f7a2498c05b
[  538.332686] Code: 73 01 c3 48 8b 0d 2d 4e 38 00 f7 d8 64 89 01 48 83 c8 ff c8
[  538.351437] RSP: 002b:00007ffed8b6f3e8 EFLAGS: 00000206 ORIG_RAX: 00000000000
[  538.359012] RAX: ffffffffffffffda RBX: 000055d81e2547a0 RCX: 00007f7a2498c05b
[  538.366145] RDX: 000000000000000a RSI: 0000000000000800 RDI: 000055d81e254808
[  538.373279] RBP: 0000000000000000 R08: 00007ffed8b6e361 R09: 0000000000000000
[  538.380411] R10: 00007f7a24ac3480 R11: 0000000000000206 R12: 00007ffed8b6f618
[  538.387544] R13: 00007ffed8b712ba R14: 000055d81e2542a0 R15: 000055d81e2547a0
[  538.394695]
[  538.396193] Allocated by task 469:
[  538.399599]  kasan_save_stack+0x19/0x40
[  538.403437]  __kasan_kmalloc+0x7d/0xa0
[  538.407192]  kmem_cache_alloc_trace+0x188/0x2b0
[  538.411732]  irq_cpu_rmap_add+0x4a/0x2e0
[  538.415659]  ice_set_cpu_rx_rmap+0x28a/0x490 [ice]
[  538.420476]  ice_probe+0x1f9c/0x43d0 [ice]
[  538.424594]  local_pci_probe+0xd8/0x170
[  538.428433]  work_for_cpu_fn+0x51/0xa0
[  538.432186]  process_one_work+0x919/0x17d0
[  538.436284]  worker_thread+0x541/0xb40
[  538.440038]  kthread+0x30d/0x3c0
[  538.443269]  ret_from_fork+0x24/0x50
[  538.446850]
[  538.448350] Freed by task 16217:
[  538.451582]  kasan_save_stack+0x19/0x40
[  538.455420]  kasan_set_track+0x1c/0x30
[  538.459172]  kasan_set_free_info+0x20/0x30
[  538.463272]  __kasan_slab_free+0xdf/0x110
[  538.467284]  slab_free_freelist_hook+0xc6/0x190
[  538.471818]  kfree+0xd9/0x2b0
[  538.474791]  irq_set_affinity_notifier+0x246/0x2c0
[  538.479583]  ice_vsi_free_irq+0x719/0xad0 [ice]
[  538.484142]  ice_vsi_close+0x28/0x50 [ice]
[  538.488258]  ice_stop+0x66/0x90 [ice]
[  538.491942]  __dev_close_many+0x19c/0x2c0
[  538.495956]  __dev_change_flags+0x1fd/0x580
[  538.500142]  dev_change_flags+0x7c/0x150
[  538.504068]  do_setlink+0x97d/0x2e70
[  538.507646]  __rtnl_newlink+0x9b7/0x1210
[  538.511573]  rtnl_newlink+0x61/0x90
[  538.515064]  rtnetlink_rcv_msg+0x34e/0x8d0
[  538.519164]  netlink_rcv_skb+0x123/0x390
[  538.523090]  netlink_unicast+0x40f/0x5d0
[  538.527016]  netlink_sendmsg+0x73d/0xb60
[  538.530944]  sock_sendmsg+0xde/0x110
[  538.534531]  ____sys_sendmsg+0x593/0x840
[  538.538458]  ___sys_sendmsg+0xe9/0x160
[  538.542210]  __sys_sendmsg+0xd3/0x170
[  538.545876]  do_syscall_64+0xa5/0x450
[  538.549542]  entry_SYSCALL_64_after_hwframe+0x6a/0xdf
[  538.554594]
[  538.556093] The buggy address belongs to the object at ff110022d1f9e300
[  538.556093]  which belongs to the cache kmalloc-192 of size 192
[  538.568601] The buggy address is located 0 bytes inside of
[  538.568601]  192-byte region [ff110022d1f9e300, ff110022d1f9e3c0)
[  538.580152] The buggy address belongs to the page:
[  538.584946] page:ffd400008b47e780 refcount:1 mapcount:0 mapping:0000000000000
[  538.597538] flags: 0x57ffffc0008100(slab|head|node=1|zone=2|lastcpupid=0x1ff)
[  538.604931] raw: 0057ffffc0008100 dead000000000100 dead000000000200 ff1100010
[  538.612670] raw: 0000000000000000 0000000000200020 00000001ffffffff 000000000
[  538.620408] page dumped because: kasan: bad access detected
[  538.625983]
[  538.627480] Memory state around the buggy address:
[  538.632276]  ff110022d1f9e200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0
[  538.639493]  ff110022d1f9e280: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc c
[  538.646712] >ff110022d1f9e300: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb b
[  538.653931]                    ^
[  538.657164]  ff110022d1f9e380: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc c
[  538.664386]  ff110022d1f9e400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0
[  538.671603] =================================================================

Fixes: 28bf26724fdb ("ice: Implement aRFS")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 6d6233204388..34bc7710a6b5 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2701,7 +2701,8 @@ void ice_vsi_free_irq(struct ice_vsi *vsi)
 			continue;
 
 		/* clear the affinity notifier in the IRQ descriptor */
-		irq_set_affinity_notifier(irq_num, NULL);
+		if (!IS_ENABLED(CONFIG_RFS_ACCEL))
+			irq_set_affinity_notifier(irq_num, NULL);
 
 		/* clear the affinity_mask in the IRQ descriptor */
 		irq_set_affinity_hint(irq_num, NULL);
-- 
2.35.1

