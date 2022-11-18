Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB3262EE82
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 08:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241232AbiKRHgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 02:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240978AbiKRHgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 02:36:50 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7DE85A3E;
        Thu, 17 Nov 2022 23:36:48 -0800 (PST)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ND7rD0tlDzHvsl;
        Fri, 18 Nov 2022 15:36:12 +0800 (CST)
Received: from dggpemm100009.china.huawei.com (7.185.36.113) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 15:36:44 +0800
Received: from huawei.com (10.175.113.32) by dggpemm100009.china.huawei.com
 (7.185.36.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 18 Nov
 2022 15:36:43 +0800
From:   Liu Shixin <liushixin2@huawei.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH] NFC: nci: fix memory leak in nci_rx_data_packet()
Date:   Fri, 18 Nov 2022 16:24:19 +0800
Message-ID: <20221118082419.239475-1-liushixin2@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm100009.china.huawei.com (7.185.36.113)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported a memory leak about skb:

unreferenced object 0xffff88810e144e00 (size 240):
  comm "syz-executor284", pid 3701, jiffies 4294952403 (age 12.620s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff83ab79a9>] __alloc_skb+0x1f9/0x270 net/core/skbuff.c:497
    [<ffffffff82a5cf64>] alloc_skb include/linux/skbuff.h:1267 [inline]
    [<ffffffff82a5cf64>] virtual_ncidev_write+0x24/0xe0 drivers/nfc/virtual_ncidev.c:116
    [<ffffffff815f6503>] do_loop_readv_writev fs/read_write.c:759 [inline]
    [<ffffffff815f6503>] do_loop_readv_writev fs/read_write.c:743 [inline]
    [<ffffffff815f6503>] do_iter_write+0x253/0x300 fs/read_write.c:863
    [<ffffffff815f66ed>] vfs_writev+0xdd/0x240 fs/read_write.c:934
    [<ffffffff815f68f6>] do_writev+0xa6/0x1c0 fs/read_write.c:977
    [<ffffffff848802d5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff848802d5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

In nci_rx_data_packet(), if we don't get a valid conn_info, we will return
directly but forget to release the skb.

Reported-by: syzbot+cdb9a427d1bc08815104@syzkaller.appspotmail.com
Fixes: 4aeee6871e8c ("NFC: nci: Add dynamic logical connections support")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
---
 net/nfc/nci/data.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index aa5e712adf07..3d36ea5701f0 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -279,8 +279,10 @@ void nci_rx_data_packet(struct nci_dev *ndev, struct sk_buff *skb)
 		 nci_plen(skb->data));
 
 	conn_info = nci_get_conn_info_by_conn_id(ndev, nci_conn_id(skb->data));
-	if (!conn_info)
+	if (!conn_info) {
+		kfree_skb(skb);
 		return;
+	}
 
 	/* strip the nci data header */
 	skb_pull(skb, NCI_DATA_HDR_SIZE);
-- 
2.25.1

