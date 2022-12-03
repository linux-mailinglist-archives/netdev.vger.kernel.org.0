Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC80641315
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 03:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbiLCCAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 21:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbiLCCAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 21:00:10 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42107A9E8D
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 18:00:09 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NPCfg6YQxz15MxP;
        Sat,  3 Dec 2022 09:59:23 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 3 Dec
 2022 10:00:06 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <m.chetan.kumar@intel.com>,
        <linuxwwan@intel.com>, <loic.poulain@linaro.org>,
        <ryazanov.s.a@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <johannes@sipsolutions.net>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH] net: wwan: iosm: fix memory leak in ipc_mux_init()
Date:   Sat, 3 Dec 2022 10:09:03 +0800
Message-ID: <20221203020903.383235-1-shaozhengchao@huawei.com>
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

When failed to alloc ipc_mux->ul_adb.pp_qlt in ipc_mux_init(), ipc_mux
is not released.

Fixes: 1f52d7b62285 ("net: wwan: iosm: Enable M.2 7360 WWAN card support")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/wwan/iosm/iosm_ipc_mux.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mux.c b/drivers/net/wwan/iosm/iosm_ipc_mux.c
index 9c7a9a2a1f25..fc928b298a98 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mux.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mux.c
@@ -332,6 +332,7 @@ struct iosm_mux *ipc_mux_init(struct ipc_mux_config *mux_cfg,
 			if (!ipc_mux->ul_adb.pp_qlt[i]) {
 				for (j = i - 1; j >= 0; j--)
 					kfree(ipc_mux->ul_adb.pp_qlt[j]);
+				kfree(ipc_mux);
 				return NULL;
 			}
 		}
-- 
2.34.1

