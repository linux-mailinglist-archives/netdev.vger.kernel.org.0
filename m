Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 872A361D898
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 09:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiKEIHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 04:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiKEIHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 04:07:46 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FEA2B197;
        Sat,  5 Nov 2022 01:07:44 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N494Q5mpgzpWBQ;
        Sat,  5 Nov 2022 16:04:06 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 5 Nov
 2022 16:07:42 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <jiawenwu@trustnetic.com>, <mengyuanlou@net-swift.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next 1/2] net: txgbe: Fix memleak in txgbe_calc_eeprom_checksum()
Date:   Sat, 5 Nov 2022 16:07:21 +0800
Message-ID: <20221105080722.20292-2-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20221105080722.20292-1-yuehaibing@huawei.com>
References: <20221105080722.20292-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

eeprom_ptrs should be freed before returned.

Fixes: 049fe5365324 ("net: txgbe: Add operations to interact with firmware")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 0b1032195859..9cf5fe33118e 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -183,6 +183,7 @@ static int txgbe_calc_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum)
 						  eeprom_ptrs);
 		if (status != 0) {
 			wx_err(wxhw, "Failed to read EEPROM image\n");
+			kvfree(eeprom_ptrs);
 			return status;
 		}
 		local_buffer = eeprom_ptrs;
@@ -196,13 +197,13 @@ static int txgbe_calc_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum)
 		if (i != wxhw->eeprom.sw_region_offset + TXGBE_EEPROM_CHECKSUM)
 			*checksum += local_buffer[i];
 
+	if (eeprom_ptrs)
+		kvfree(eeprom_ptrs);
+
 	*checksum = TXGBE_EEPROM_SUM - *checksum;
 	if (*checksum < 0)
 		return -EINVAL;
 
-	if (eeprom_ptrs)
-		kvfree(eeprom_ptrs);
-
 	return 0;
 }
 
-- 
2.17.1

