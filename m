Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913E763C380
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 16:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbiK2PS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 10:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235705AbiK2PSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 10:18:24 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A2E2EF4F;
        Tue, 29 Nov 2022 07:18:22 -0800 (PST)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NM5Yb6d5xzmWHl;
        Tue, 29 Nov 2022 23:17:39 +0800 (CST)
Received: from huawei.com (10.67.175.21) by kwepemi500012.china.huawei.com
 (7.221.188.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 29 Nov
 2022 23:18:18 +0800
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
Subject: [PATCH v2 1/5] 9p: Fix probe failed when modprobe 9pnet_virtio
Date:   Wed, 30 Nov 2022 00:06:11 +0800
Message-ID: <20221129160615.3343036-2-lizetao1@huawei.com>
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
  step 1: modprobe 9pnet_virtio succeeded
    # modprobe 9pnet_virtio      <-- OK

  step 2: fault injection in sysfs_create_file()
    # modprobe -r 9pnet_virtio   <-- OK
    # ...
      FAULT_INJECTION: forcing a failure.
      name failslab, interval 1, probability 0, space 0, times 0
      CPU: 0 PID: 3790 Comm: modprobe Tainted: G        W
      6.1.0-rc6-00285-g6a1e40c4b995-dirty #108
      Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
      Call Trace:
       <TASK>
       ...
       should_failslab+0xa/0x20
       ...
       sysfs_create_file_ns+0x130/0x1d0
       p9_virtio_probe+0x662/0xb30 [9pnet_virtio]
       virtio_dev_probe+0x608/0xae0
       ...
       </TASK>
      9pnet_virtio: probe of virtio3 failed with error -12

  step 3: modprobe 9pnet_virtio failed
    # modprobe 9pnet_virtio       <-- failed
      9pnet_virtio: probe of virtio3 failed with error -2

The root cause of the problem is that the virtqueues are not
stopped on the error handling path when sysfs_create_file()
fails in p9_virtio_probe(), resulting in an error "-ENOENT"
returned in the next modprobe call in setup_vq().

virtio_pci_modern_device uses virtqueues to send or
receive message, and "queue_enable" records whether the
queues are available. In vp_modern_find_vqs(), all queues
will be selected and activated, but once queues are enabled
there is no way to go back except reset.

Fix it by reset virtio device on error handling path. After
virtio_find_single_vq() succeeded, all virtqueues should be
stopped on error handling path.

Fixes: ea52bf8eda98 ("9p/trans_virtio: reset virtio device on remove")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
v1 -> v2: modify the description error of the test case in step 3 and
modify the fixes tag information.

 net/9p/trans_virtio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index e757f0601304..39933187284b 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -668,6 +668,7 @@ static int p9_virtio_probe(struct virtio_device *vdev)
 out_free_tag:
 	kfree(tag);
 out_free_vq:
+	virtio_reset_device(vdev);
 	vdev->config->del_vqs(vdev);
 out_free_chan:
 	kfree(chan);
-- 
2.25.1

