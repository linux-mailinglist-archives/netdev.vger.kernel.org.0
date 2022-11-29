Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66BBF63C382
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 16:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbiK2PSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 10:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235824AbiK2PSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 10:18:25 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E095510BF;
        Tue, 29 Nov 2022 07:18:23 -0800 (PST)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NM5Yb4SXdzHwGW;
        Tue, 29 Nov 2022 23:17:39 +0800 (CST)
Received: from huawei.com (10.67.175.21) by kwepemi500012.china.huawei.com
 (7.221.188.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 29 Nov
 2022 23:18:20 +0800
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
Subject: [PATCH v2 3/5] virtio-input: Fix probe failed when modprobe virtio_input
Date:   Wed, 30 Nov 2022 00:06:13 +0800
Message-ID: <20221129160615.3343036-4-lizetao1@huawei.com>
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
  step 1: modprobe virtio_input succeeded
    # modprobe virtio_input      <-- OK

  step 2: fault injection in input_allocate_device()
    # modprobe -r virtio_input   <-- OK
    # ...
      CPU: 0 PID: 4260 Comm: modprobe Tainted: G        W
      6.1.0-rc6-00285-g6a1e40c4b995-dirty #109
      Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
      Call Trace:
       <TASK>
       should_fail.cold+0x5/0x1f
       ...
       kmalloc_trace+0x27/0xa0
       input_allocate_device+0x43/0x280
       virtinput_probe+0x23b/0x1648 [virtio_input]
       ...
       </TASK>
      virtio_input: probe of virtio5 failed with error -12

  step 3: modprobe virtio_input failed
    # modprobe virtio_input       <-- failed
      virtio_input: probe of virtio1 failed with error -2

The root cause of the problem is that the virtqueues are not
stopped on the error handling path when input_allocate_device()
fails in virtinput_probe(), resulting in an error "-ENOENT"
returned in the next modprobe call in setup_vq().

virtio_pci_modern_device uses virtqueues to send or
receive message, and "queue_enable" records whether the
queues are available. In vp_modern_find_vqs(), all queues
will be selected and activated, but once queues are enabled
there is no way to go back except reset.

Fix it by reset virtio device on error handling path. After
virtinput_init_vqs() succeeded, all virtqueues should be
stopped on error handling path.

Fixes: 271c865161c5 ("Add virtio-input driver.")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
---
v1 -> v2: modify the description error of the test case in step 3 and
modify the fixes tag information.

 drivers/virtio/virtio_input.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/virtio/virtio_input.c b/drivers/virtio/virtio_input.c
index 3aa46703872d..f638f1cd3531 100644
--- a/drivers/virtio/virtio_input.c
+++ b/drivers/virtio/virtio_input.c
@@ -330,6 +330,7 @@ static int virtinput_probe(struct virtio_device *vdev)
 err_mt_init_slots:
 	input_free_device(vi->idev);
 err_input_alloc:
+	virtio_reset_device(vdev);
 	vdev->config->del_vqs(vdev);
 err_init_vq:
 	kfree(vi);
-- 
2.25.1

