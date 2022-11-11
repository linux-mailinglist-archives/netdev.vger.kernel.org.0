Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0742662544E
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 08:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbiKKHJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 02:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbiKKHJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 02:09:43 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B647918383;
        Thu, 10 Nov 2022 23:09:40 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N7qZJ5vkXzHvgZ;
        Fri, 11 Nov 2022 15:09:12 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 15:09:38 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <vburru@marvell.com>, <aayarekar@marvell.com>,
        <sburla@marvell.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 4/4] octeon_ep: ensure get mac address successfully before eth_hw_addr_set()
Date:   Fri, 11 Nov 2022 15:09:35 +0800
Message-ID: <223ee27c25cc506b8d49c87e8a95b06c6eb2b971.1668150074.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1668150074.git.william.xuanziyang@huawei.com>
References: <cover.1668150074.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

octep_get_mac_addr() can fail because send mbox message failed. If this
happens, octep_dev->mac_addr will be zero. It should not continue to
initialize. Add exception handling for octep_get_mac_addr() to fix it.

Fixes: 862cd659a6fb ("octeon_ep: Add driver framework and device initialization")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 53f288c32238..b45dd7f04e21 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -1072,7 +1072,11 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->max_mtu = OCTEP_MAX_MTU;
 	netdev->mtu = OCTEP_DEFAULT_MTU;
 
-	octep_get_mac_addr(octep_dev, octep_dev->mac_addr);
+	err = octep_get_mac_addr(octep_dev, octep_dev->mac_addr);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to get mac address\n");
+		goto register_dev_err;
+	}
 	eth_hw_addr_set(netdev, octep_dev->mac_addr);
 
 	err = register_netdev(netdev);
-- 
2.25.1

