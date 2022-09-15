Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2DB35B99B4
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 13:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiIOLgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 07:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiIOLf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 07:35:56 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AF096FEC
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 04:35:55 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MSw5l1XFrz14QX1;
        Thu, 15 Sep 2022 19:31:55 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 15 Sep 2022 19:35:22 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 15 Sep
 2022 19:35:22 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <hauke@hauke-m.de>,
        <andrew@lunn.ch>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@foss.st.com>
Subject: [PATCH -next 3/7] net: ethernet: ti: cpsw_new: Switch to use dev_err_probe() helper
Date:   Thu, 15 Sep 2022 19:42:10 +0800
Message-ID: <20220915114214.3145427-4-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220915114214.3145427-1-yangyingliang@huawei.com>
References: <20220915114214.3145427-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_err() can be replace with dev_err_probe() which will check if error
code is -EPROBE_DEFER.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/ti/cpsw_new.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 007de15179f0..14fd90da32fd 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1288,9 +1288,8 @@ static int cpsw_probe_dt(struct cpsw_common *cpsw)
 		if (of_phy_is_fixed_link(port_np)) {
 			ret = of_phy_register_fixed_link(port_np);
 			if (ret) {
-				if (ret != -EPROBE_DEFER)
-					dev_err(dev, "%pOF failed to register fixed-link phy: %d\n",
-						port_np, ret);
+				dev_err_probe(dev, ret, "%pOF failed to register fixed-link phy\n",
+					      port_np);
 				goto err_node_put;
 			}
 			slave_data->phy_node = of_node_get(port_np);
-- 
2.25.1

