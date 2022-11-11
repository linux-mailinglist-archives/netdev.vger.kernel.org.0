Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7959F62544C
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 08:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiKKHJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 02:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233170AbiKKHJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 02:09:29 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0189318351;
        Thu, 10 Nov 2022 23:09:28 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N7qZL6kZnzRp9n;
        Fri, 11 Nov 2022 15:09:14 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 15:09:26 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <vburru@marvell.com>, <aayarekar@marvell.com>,
        <sburla@marvell.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 3/4] octeon_ep: fix potential memory leak in octep_device_setup()
Date:   Fri, 11 Nov 2022 15:09:23 +0800
Message-ID: <d92f76537c8258f6d1dedd4fc84bbb76fe735190.1668150074.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1668150074.git.william.xuanziyang@huawei.com>
References: <cover.1668150074.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When occur unsupported_dev and mbox init errors, it did not free oct->conf
and iounmap() oct->mmio[i].hw_addr. That would trigger memory leak problem.
Add kfree() for oct->conf and iounmap() for oct->mmio[i].hw_addr under
unsupported_dev and mbox init errors to fix the problem.

Fixes: 862cd659a6fb ("octeon_ep: Add driver framework and device initialization")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 546bcebf4462..53f288c32238 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -956,7 +956,7 @@ int octep_device_setup(struct octep_device *oct)
 	ret = octep_ctrl_mbox_init(ctrl_mbox);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to initialize control mbox\n");
-		return -1;
+		goto unsupported_dev;
 	}
 	oct->ctrl_mbox_ifstats_offset = OCTEP_CTRL_MBOX_SZ(ctrl_mbox->h2fq.elem_sz,
 							   ctrl_mbox->h2fq.elem_cnt,
@@ -966,6 +966,10 @@ int octep_device_setup(struct octep_device *oct)
 	return 0;
 
 unsupported_dev:
+	for (i = 0; i < OCTEP_MMIO_REGIONS; i++)
+		iounmap(oct->mmio[i].hw_addr);
+
+	kfree(oct->conf);
 	return -1;
 }
 
-- 
2.25.1

