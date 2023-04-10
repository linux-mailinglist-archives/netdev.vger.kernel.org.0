Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1DC26DC24A
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 03:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjDJBYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 21:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjDJBYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 21:24:02 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68AC035A7;
        Sun,  9 Apr 2023 18:24:00 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Pvrn80MgGzrXgX;
        Mon, 10 Apr 2023 09:22:36 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 09:23:56 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <mani@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH net v2] net: qrtr: Fix an uninit variable access bug in qrtr_tx_resume()
Date:   Mon, 10 Apr 2023 09:23:52 +0800
Message-ID: <20230410012352.3997823-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported a bug as following:

=====================================================
BUG: KMSAN: uninit-value in qrtr_tx_resume+0x185/0x1f0 net/qrtr/af_qrtr.c:230
 qrtr_tx_resume+0x185/0x1f0 net/qrtr/af_qrtr.c:230
 qrtr_endpoint_post+0xf85/0x11b0 net/qrtr/af_qrtr.c:519
 qrtr_tun_write_iter+0x270/0x400 net/qrtr/tun.c:108
 call_write_iter include/linux/fs.h:2189 [inline]
 aio_write+0x63a/0x950 fs/aio.c:1600
 io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
 __do_sys_io_submit fs/aio.c:2078 [inline]
 __se_sys_io_submit+0x293/0x770 fs/aio.c:2048
 __x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:766 [inline]
 slab_alloc_node mm/slub.c:3452 [inline]
 __kmem_cache_alloc_node+0x71f/0xce0 mm/slub.c:3491
 __do_kmalloc_node mm/slab_common.c:967 [inline]
 __kmalloc_node_track_caller+0x114/0x3b0 mm/slab_common.c:988
 kmalloc_reserve net/core/skbuff.c:492 [inline]
 __alloc_skb+0x3af/0x8f0 net/core/skbuff.c:565
 __netdev_alloc_skb+0x120/0x7d0 net/core/skbuff.c:630
 qrtr_endpoint_post+0xbd/0x11b0 net/qrtr/af_qrtr.c:446
 qrtr_tun_write_iter+0x270/0x400 net/qrtr/tun.c:108
 call_write_iter include/linux/fs.h:2189 [inline]
 aio_write+0x63a/0x950 fs/aio.c:1600
 io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
 __do_sys_io_submit fs/aio.c:2078 [inline]
 __se_sys_io_submit+0x293/0x770 fs/aio.c:2048
 __x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

It is because that skb->len requires at least sizeof(struct qrtr_ctrl_pkt)
in qrtr_tx_resume(). And skb->len equals to size in qrtr_endpoint_post().
But size is less than sizeof(struct qrtr_ctrl_pkt) when qrtr_cb->type
equals to QRTR_TYPE_RESUME_TX in qrtr_endpoint_post() under the syzbot
scenario. This triggers the uninit variable access bug.

Add size check when qrtr_cb->type equals to QRTR_TYPE_RESUME_TX in
qrtr_endpoint_post() to fix the bug.

Fixes: 5fdeb0d372ab ("net: qrtr: Implement outgoing flow control")
Reported-by: syzbot+4436c9630a45820fda76@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=c14607f0963d27d5a3d5f4c8639b500909e43540
Suggested-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
v2:
  - Combine QRTR_TYPE_NEW_SERVER and QRTR_TYPE_RESUME_TX size check.
---
 net/qrtr/af_qrtr.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index 3a70255c8d02..76f0434d3d06 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -498,6 +498,11 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 	if (!size || len != ALIGN(size, 4) + hdrlen)
 		goto err;
 
+	if ((cb->type == QRTR_TYPE_NEW_SERVER ||
+	     cb->type == QRTR_TYPE_RESUME_TX) &&
+	    size < sizeof(struct qrtr_ctrl_pkt))
+		goto err;
+
 	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
 	    cb->type != QRTR_TYPE_RESUME_TX)
 		goto err;
@@ -510,9 +515,6 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 		/* Remote node endpoint can bridge other distant nodes */
 		const struct qrtr_ctrl_pkt *pkt;
 
-		if (size < sizeof(*pkt))
-			goto err;
-
 		pkt = data + hdrlen;
 		qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
 	}
-- 
2.25.1

