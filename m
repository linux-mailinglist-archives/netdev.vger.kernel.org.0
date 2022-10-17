Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7DF600900
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 10:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiJQIpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 04:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiJQIo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 04:44:56 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D59513F66
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 01:44:51 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MrVt40ZzhzHv2v;
        Mon, 17 Oct 2022 16:44:44 +0800 (CST)
Received: from kwepemm600008.china.huawei.com (7.193.23.88) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 16:44:49 +0800
Received: from huawei.com (10.175.100.227) by kwepemm600008.china.huawei.com
 (7.193.23.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 17 Oct
 2022 16:44:48 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <bongsu.jeon@samsung.com>, <krzysztof.kozlowski@linaro.org>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH] nfc: virtual_ncidev: Fix memory leak in virtual_nci_send()
Date:   Mon, 17 Oct 2022 16:44:08 +0800
Message-ID: <20221017084408.18834-1-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600008.china.huawei.com (7.193.23.88)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb should be free in virtual_nci_send(), otherwise kmemleak will report
memleak.

Steps for reproduction (simulated in qemu):
	cd tools/testing/selftests/nci
	make
	./nci_dev

BUG: memory leak
unreferenced object 0xffff888107588000 (size 208):
  comm "nci_dev", pid 206, jiffies 4294945376 (age 368.248s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000008d94c8fd>] __alloc_skb+0x1da/0x290
    [<00000000278bc7f8>] nci_send_cmd+0xa3/0x350
    [<0000000081256a22>] nci_reset_req+0x6b/0xa0
    [<000000009e721112>] __nci_request+0x90/0x250
    [<000000005d556e59>] nci_dev_up+0x217/0x5b0
    [<00000000e618ce62>] nfc_dev_up+0x114/0x220
    [<00000000981e226b>] nfc_genl_dev_up+0x94/0xe0
    [<000000009bb03517>] genl_family_rcv_msg_doit.isra.14+0x228/0x2d0
    [<00000000b7f8c101>] genl_rcv_msg+0x35c/0x640
    [<00000000c94075ff>] netlink_rcv_skb+0x11e/0x350
    [<00000000440cfb1e>] genl_rcv+0x24/0x40
    [<0000000062593b40>] netlink_unicast+0x43f/0x640
    [<000000001d0b13cc>] netlink_sendmsg+0x73a/0xbf0
    [<000000003272487f>] __sys_sendto+0x324/0x370
    [<00000000ef9f1747>] __x64_sys_sendto+0xdd/0x1b0
    [<000000001e437841>] do_syscall_64+0x3f/0x90

Fixes: e624e6c3e777 ("nfc: Add a virtual nci device driver")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
---
 drivers/nfc/virtual_ncidev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
index f577449e4935..9f54a4e0eb51 100644
--- a/drivers/nfc/virtual_ncidev.c
+++ b/drivers/nfc/virtual_ncidev.c
@@ -64,6 +64,7 @@ static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 	send_buff = skb_copy(skb, GFP_KERNEL);
 	mutex_unlock(&nci_mutex);
 	wake_up_interruptible(&wq);
+	consume_skb(skb);
 
 	return 0;
 }
-- 
2.17.1

