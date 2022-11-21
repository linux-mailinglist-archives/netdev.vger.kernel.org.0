Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC7063227A
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 13:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiKUMla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 07:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiKUMl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 07:41:29 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46D2B7000;
        Mon, 21 Nov 2022 04:41:27 -0800 (PST)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NG6SL4zJ5zHvRd;
        Mon, 21 Nov 2022 20:40:50 +0800 (CST)
Received: from huawei.com (10.67.175.21) by kwepemi500012.china.huawei.com
 (7.221.188.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 21 Nov
 2022 20:41:25 +0800
From:   Li Zetao <lizetao1@huawei.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <lizetao1@huawei.com>, <rusty@rustcorp.com.au>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] virtio_net: Fix probe failed when modprobe virtio_net
Date:   Mon, 21 Nov 2022 21:29:35 +0800
Message-ID: <20221121132935.2032325-1-lizetao1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.175.21]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When doing the following test steps, an error was found:
  step 1: modprobe virtio_net succeeded
    # modprobe virtio_net        <-- OK

  step 2: fault injection in register_netdevice()
    # modprobe -r virtio_net     <-- OK
    # ...
      FAULT_INJECTION: forcing a failure.
      name failslab, interval 1, probability 0, space 0, times 0
      CPU: 0 PID: 3521 Comm: modprobe
      Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
      Call Trace:
       <TASK>
       ...
       should_failslab+0xa/0x20
       ...
       dev_set_name+0xc0/0x100
       netdev_register_kobject+0xc2/0x340
       register_netdevice+0xbb9/0x1320
       virtnet_probe+0x1d72/0x2658 [virtio_net]
       ...
       </TASK>
      virtio_net: probe of virtio0 failed with error -22

  step 3: modprobe virtio_net failed
    # modprobe virtio_net        <-- failed
      virtio_net: probe of virtio0 failed with error -2

The root cause of the problem is that the queues are not
disable on the error handling path when register_netdevice()
fails in virtnet_probe(), resulting in an error "-ENOENT"
returned in the next modprobe call in setup_vq().

virtio_pci_modern_device uses virtqueues to send or
receive message, and "queue_enable" records whether the
queues are available. In vp_modern_find_vqs(), all queues
will be selected and activated, but once queues are enabled
there is no way to go back except reset.

Fix it by reset virtio device on error handling path.

Fixes: 1fcf0512c9c8 ("virtio_pci: modern driver")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
---
 drivers/net/virtio_net.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7106932c6f88..86e52454b5b5 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3949,12 +3949,11 @@ static int virtnet_probe(struct virtio_device *vdev)
 	return 0;
 
 free_unregister_netdev:
-	virtio_reset_device(vdev);
-
 	unregister_netdev(dev);
 free_failover:
 	net_failover_destroy(vi->failover);
 free_vqs:
+	virtio_reset_device(vdev);
 	cancel_delayed_work_sync(&vi->refill);
 	free_receive_page_frags(vi);
 	virtnet_del_vqs(vi);
-- 
2.25.1

