Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AE163C385
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 16:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbiK2PS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 10:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235463AbiK2PSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 10:18:25 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D0C52895;
        Tue, 29 Nov 2022 07:18:23 -0800 (PST)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NM5Yc6XbdzmWL6;
        Tue, 29 Nov 2022 23:17:40 +0800 (CST)
Received: from huawei.com (10.67.175.21) by kwepemi500012.china.huawei.com
 (7.221.188.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 29 Nov
 2022 23:18:19 +0800
From:   Li Zetao <lizetao1@huawei.com>
To:     <lizetao1@huawei.com>
CC:     <st@redhat.com>, <jasowang@redhat.com>, <pbonzini@redhat.com>,
        <stefanha@redhat.com>, <axboe@kernel.dk>, <airlied@redhat.com>,
        <kraxel@redhat.com>, <gurchetansingh@chromium.org>,
        <olvaffe@gmail.com>, <daniel@ffwll.ch>, <david@redhat.com>,
        <ericvh@gmail.com>, <lucho@ionkov.net>, <asmadeus@codewreck.org>,
        <linux_oss@crudebyte.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pmorel@linux.vnet.ibm.com>, <cornelia.huck@de.ibm.com>,
        <pankaj.gupta.linux@gmail.com>, <rusty@rustcorp.com.au>,
        <airlied@gmail.com>, <virtualization@lists.linux-foundation.org>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        <v9fs-developer@lists.sourceforge.net>, <netdev@vger.kernel.org>
Subject: [PATCH v2 2/5] virtio-mem: Fix probe failed when modprobe virtio_mem
Date:   Wed, 30 Nov 2022 00:06:12 +0800
Message-ID: <20221129160615.3343036-3-lizetao1@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221129160615.3343036-1-lizetao1@huawei.com>
References: <20221128021005.232105-1-lizetao1@huawei.com>
 <20221129160615.3343036-1-lizetao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.175.21]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
  step 1: modprobe virtio_mem succeeded
    # modprobe virtio_mem      <-- OK

  step 2: fault injection in virtio_mem_init()
    # modprobe -r virtio_mem   <-- OK
    # ...
      CPU: 0 PID: 1837 Comm: modprobe Not tainted
      6.1.0-rc6-00285-g6a1e40c4b995-dirty
      Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
      Call Trace:
       <TASK>
       should_fail.cold+0x5/0x1f
       ...
       virtio_mem_init_hotplug+0x9ae/0xe57 [virtio_mem]
       virtio_mem_init.cold+0x327/0x339 [virtio_mem]
       virtio_mem_probe+0x48e/0x910 [virtio_mem]
       virtio_dev_probe+0x608/0xae0
       ...
       </TASK>
      virtio_mem virtio4: could not reserve device region
      virtio_mem: probe of virtio4 failed with error -16

  step 3: modprobe virtio_mem failed
    # modprobe virtio_mem       <-- failed
      virtio_mem: probe of virtio4 failed with error -16

The root cause of the problem is that the virtqueues are not
stopped on the error handling path when virtio_mem_init()
fails in virtio_mem_probe(), resulting in an error "-ENOENT"
returned in the next modprobe call in setup_vq().

virtio_pci_modern_device uses virtqueues to send or
receive message, and "queue_enable" records whether the
queues are available. In vp_modern_find_vqs(), all queues
will be selected and activated, but once queues are enabled
there is no way to go back except reset.

Fix it by reset virtio device on error handling path. After
virtio_mem_init_vq() succeeded, all virtqueues should be
stopped on error handling path.

Fixes: 5f1f79bbc9e2 ("virtio-mem: Paravirtualized memory hotplug")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
v1 -> v2: modify the description error of the test case in step 3 and
modify the fixes tag information.

 drivers/virtio/virtio_mem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index 0c2892ec6817..c7f09c2ce982 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -2793,6 +2793,7 @@ static int virtio_mem_probe(struct virtio_device *vdev)
 
 	return 0;
 out_del_vq:
+	virtio_reset_device(vdev);
 	vdev->config->del_vqs(vdev);
 out_free_vm:
 	kfree(vm);
-- 
2.25.1

