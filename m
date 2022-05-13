Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A6D525CB5
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 10:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377962AbiEMH4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 03:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377984AbiEMH4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 03:56:20 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493B22B1B0;
        Fri, 13 May 2022 00:56:18 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4L01C95hXWz1JBrR;
        Fri, 13 May 2022 15:55:01 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 13 May
 2022 15:56:16 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <chandrashekar.devegowda@intel.com>, <linuxwwan@intel.com>,
        <chiranjeevi.rapolu@linux.intel.com>, <haijun.liu@mediatek.com>,
        <m.chetan.kumar@linux.intel.com>,
        <ricardo.martinez@linux.intel.com>, <loic.poulain@linaro.org>,
        <ryazanov.s.a@gmail.com>, <johannes@sipsolutions.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <yuehaibing@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net-next] net: wwan: t7xx: Fix return type of t7xx_dl_add_timedout()
Date:   Fri, 13 May 2022 15:56:11 +0800
Message-ID: <20220513075611.1972-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

t7xx_dl_add_timedout() now return int 'ret', but the return type
is bool. Change the return type to int for furthor errcode upstream.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: Remove unneeded ret variable
---
 drivers/net/wwan/t7xx/t7xx_dpmaif.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_dpmaif.c b/drivers/net/wwan/t7xx/t7xx_dpmaif.c
index c8bf6929af51..6d3edadecbec 100644
--- a/drivers/net/wwan/t7xx/t7xx_dpmaif.c
+++ b/drivers/net/wwan/t7xx/t7xx_dpmaif.c
@@ -1043,15 +1043,13 @@ unsigned int t7xx_dpmaif_dl_dlq_pit_get_wr_idx(struct dpmaif_hw_info *hw_info,
 	return value & DPMAIF_DL_RD_WR_IDX_MSK;
 }
 
-static bool t7xx_dl_add_timedout(struct dpmaif_hw_info *hw_info)
+static int t7xx_dl_add_timedout(struct dpmaif_hw_info *hw_info)
 {
 	u32 value;
-	int ret;
 
-	ret = ioread32_poll_timeout_atomic(hw_info->pcie_base + DPMAIF_DL_BAT_ADD,
+	return ioread32_poll_timeout_atomic(hw_info->pcie_base + DPMAIF_DL_BAT_ADD,
 					   value, !(value & DPMAIF_DL_ADD_NOT_READY), 0,
 					   DPMAIF_CHECK_TIMEOUT_US);
-	return ret;
 }
 
 int t7xx_dpmaif_dl_snd_hw_bat_cnt(struct dpmaif_hw_info *hw_info, unsigned int bat_entry_cnt)
-- 
2.17.1

