Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE08503596
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 11:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbiDPJWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 05:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiDPJWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 05:22:00 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B283049CB2;
        Sat, 16 Apr 2022 02:19:28 -0700 (PDT)
Received: from kwepemi500026.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KgSM06TsjzQwQV;
        Sat, 16 Apr 2022 17:19:24 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500026.china.huawei.com (7.221.188.247) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Apr 2022 17:19:26 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Apr 2022 17:19:26 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 5/9] net: hns3: add log for setting tx spare buf size
Date:   Sat, 16 Apr 2022 17:13:39 +0800
Message-ID: <20220416091343.35817-6-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220416091343.35817-1-huangguangbin2@huawei.com>
References: <20220416091343.35817-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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
index bea810a26aac..51ee8adab6a3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1868,6 +1868,8 @@ static int hns3_set_tunable(struct net_device *netdev,
 	case ETHTOOL_TX_COPYBREAK_BUF_SIZE:
 		old_tx_spare_buf_size = h->kinfo.tx_spare_buf_size;
 		new_tx_spare_buf_size = *(u32 *)data;
+		netdev_info(netdev, "request to set tx spare buf size from %u to %u\n",
+			    old_tx_spare_buf_size, new_tx_spare_buf_size);
 		ret = hns3_set_tx_spare_buf_size(netdev, new_tx_spare_buf_size);
 		if (ret ||
 		    (!priv->ring->tx_spare && new_tx_spare_buf_size != 0)) {
@@ -1885,6 +1887,10 @@ static int hns3_set_tunable(struct net_device *netdev,
 
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

