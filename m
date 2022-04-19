Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD825062AF
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 05:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348065AbiDSDf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 23:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347750AbiDSDfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 23:35:41 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776BC2BB1D;
        Mon, 18 Apr 2022 20:32:56 -0700 (PDT)
Received: from kwepemi500005.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Kj8Vz2Ncyz1GD6J;
        Tue, 19 Apr 2022 11:32:11 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500005.china.huawei.com (7.221.188.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 11:32:54 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 11:32:53 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH V2 net-next 5/9] net: hns3: add log for setting tx spare buf size
Date:   Tue, 19 Apr 2022 11:27:05 +0800
Message-ID: <20220419032709.15408-6-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220419032709.15408-1-huangguangbin2@huawei.com>
References: <20220419032709.15408-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

For the active tx spare buffer size maybe changed according
to the page size, so add log to notice it.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index e647751e9054..73498e125492 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1898,6 +1898,8 @@ static int hns3_set_tunable(struct net_device *netdev,
 	case ETHTOOL_TX_COPYBREAK_BUF_SIZE:
 		old_tx_spare_buf_size = h->kinfo.tx_spare_buf_size;
 		new_tx_spare_buf_size = *(u32 *)data;
+		netdev_info(netdev, "request to set tx spare buf size from %u to %u\n",
+			    old_tx_spare_buf_size, new_tx_spare_buf_size);
 		ret = hns3_set_tx_spare_buf_size(netdev, new_tx_spare_buf_size);
 		if (ret ||
 		    (!priv->ring->tx_spare && new_tx_spare_buf_size != 0)) {
@@ -1915,6 +1917,10 @@ static int hns3_set_tunable(struct net_device *netdev,
 
 			return ret;
 		}
+
+		netdev_info(netdev, "the actvie tx spare buf size is %u, due to page order\n",
+			    priv->ring->tx_spare->len);
+
 		break;
 	default:
 		ret = -EOPNOTSUPP;
-- 
2.33.0

