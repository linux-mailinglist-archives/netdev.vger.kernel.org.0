Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E7D6420FE
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 02:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbiLEBMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 20:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiLEBMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 20:12:45 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F455F80
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 17:12:43 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NQQVx6wblzRphL;
        Mon,  5 Dec 2022 09:11:53 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 5 Dec
 2022 09:12:40 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH] net: dsa: sja1105: fix memory leak in sja1105_setup_devlink_regions()
Date:   Mon, 5 Dec 2022 09:21:32 +0800
Message-ID: <20221205012132.2110979-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When dsa_devlink_region_create failed in sja1105_setup_devlink_regions(), 
priv->regions is not released.

Fixes: bf425b82059e ("net: dsa: sja1105: expose static config as devlink region")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/dsa/sja1105/sja1105_devlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_devlink.c b/drivers/net/dsa/sja1105/sja1105_devlink.c
index 10c6fea1227f..bdbbff2a7909 100644
--- a/drivers/net/dsa/sja1105/sja1105_devlink.c
+++ b/drivers/net/dsa/sja1105/sja1105_devlink.c
@@ -95,6 +95,8 @@ static int sja1105_setup_devlink_regions(struct dsa_switch *ds)
 		if (IS_ERR(region)) {
 			while (--i >= 0)
 				dsa_devlink_region_destroy(priv->regions[i]);
+
+			kfree(priv->regions);
 			return PTR_ERR(region);
 		}
 
-- 
2.34.1

