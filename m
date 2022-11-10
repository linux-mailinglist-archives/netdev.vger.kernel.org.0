Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECF66238C6
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 02:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbiKJBY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 20:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiKJBY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 20:24:26 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843B122B13
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 17:24:24 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N73yc5h7RzmVWB;
        Thu, 10 Nov 2022 09:24:08 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 10 Nov
 2022 09:24:22 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <dchickles@marvell.com>,
        <sburla@marvell.com>, <fmanlunas@marvell.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>
CC:     <rvatsavayi@caviumnetworks.com>, <gregkh@linuxfoundation.org>,
        <tseewald@gmail.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net] net: liquidio: release resources when liquidio driver open failed
Date:   Thu, 10 Nov 2022 09:31:16 +0800
Message-ID: <20221110013116.270258-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When liquidio driver open failed, it doesn't release resources. Compile
tested only.

Fixes: 5b07aee11227 ("liquidio: MSIX support for CN23XX")
Fixes: dbc97bfd3918 ("net: liquidio: Add missing null pointer checks")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../net/ethernet/cavium/liquidio/lio_main.c   | 40 ++++++++++++++++---
 1 file changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index d312bd594935..713689cf212c 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1795,12 +1795,15 @@ static int liquidio_open(struct net_device *netdev)
 	ifstate_set(lio, LIO_IFSTATE_RUNNING);
 
 	if (OCTEON_CN23XX_PF(oct)) {
-		if (!oct->msix_on)
-			if (setup_tx_poll_fn(netdev))
-				return -1;
+		if (!oct->msix_on) {
+			ret = setup_tx_poll_fn(netdev);
+			if (ret)
+				goto err_poll;
+		}
 	} else {
-		if (setup_tx_poll_fn(netdev))
-			return -1;
+		ret = setup_tx_poll_fn(netdev);
+		if (ret)
+			goto err_poll;
 	}
 
 	netif_tx_start_all_queues(netdev);
@@ -1813,7 +1816,7 @@ static int liquidio_open(struct net_device *netdev)
 	/* tell Octeon to start forwarding packets to host */
 	ret = send_rx_ctrl_cmd(lio, 1);
 	if (ret)
-		return ret;
+		goto err_rx_ctrl;
 
 	/* start periodical statistics fetch */
 	INIT_DELAYED_WORK(&lio->stats_wk.work, lio_fetch_stats);
@@ -1824,6 +1827,31 @@ static int liquidio_open(struct net_device *netdev)
 	dev_info(&oct->pci_dev->dev, "%s interface is opened\n",
 		 netdev->name);
 
+	return 0;
+
+err_rx_ctrl:
+	if (OCTEON_CN23XX_PF(oct)) {
+		if (!oct->msix_on)
+			cleanup_tx_poll_fn(netdev);
+	} else {
+		cleanup_tx_poll_fn(netdev);
+	}
+err_poll:
+	if (lio->ptp_clock) {
+		ptp_clock_unregister(lio->ptp_clock);
+		lio->ptp_clock = NULL;
+	}
+
+	if (oct->props[lio->ifidx].napi_enabled == 1) {
+		list_for_each_entry_safe(napi, n, &netdev->napi_list, dev_list)
+			napi_disable(napi);
+
+		oct->props[lio->ifidx].napi_enabled = 0;
+
+		if (OCTEON_CN23XX_PF(oct))
+			oct->droq[0]->ops.poll_mode = 0;
+	}
+
 	return ret;
 }
 
-- 
2.17.1

