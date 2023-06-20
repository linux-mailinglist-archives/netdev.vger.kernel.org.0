Return-Path: <netdev+bounces-12112-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20A9973637D
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:18:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C029280F7A
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 06:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92BFB1FD0;
	Tue, 20 Jun 2023 06:18:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821BD1FA9
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 06:18:32 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1595310D7
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 23:18:29 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Qlbw80XjqzMpkP;
	Tue, 20 Jun 2023 14:15:20 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 20 Jun
 2023 14:18:27 +0800
From: Zhengchao Shao <shaozhengchao@huawei.com>
To: <netdev@vger.kernel.org>, <jiawenwu@trustnetic.com>,
	<mengyuanlou@net-swift.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
	<shaozhengchao@huawei.com>
Subject: [PATCH net-next,v2] net: txgbe: remove unused buffer in txgbe_calc_eeprom_checksum
Date: Tue, 20 Jun 2023 14:25:19 +0800
Message-ID: <20230620062519.1575298-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Half a year passed since commit 049fe5365324c ("net: txgbe: Add operations
to interact with firmware") was submitted, the buffer in
txgbe_calc_eeprom_checksum was not used. So remove it and the related
branch codes.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306200242.FXsHokaJ-lkp@intel.com/
Reviewed-by: Jiawen Wu <jiawenwu@trustnetic.com>
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
v2: remove unused buffer_size
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 32 +++++++------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index ebc46f3be056..12405d71c5ee 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -160,34 +160,24 @@ int txgbe_read_pba_string(struct wx *wx, u8 *pba_num, u32 pba_num_size)
 static int txgbe_calc_eeprom_checksum(struct wx *wx, u16 *checksum)
 {
 	u16 *eeprom_ptrs = NULL;
-	u32 buffer_size = 0;
-	u16 *buffer = NULL;
 	u16 *local_buffer;
 	int status;
 	u16 i;
 
 	wx_init_eeprom_params(wx);
 
-	if (!buffer) {
-		eeprom_ptrs = kvmalloc_array(TXGBE_EEPROM_LAST_WORD, sizeof(u16),
-					     GFP_KERNEL);
-		if (!eeprom_ptrs)
-			return -ENOMEM;
-		/* Read pointer area */
-		status = wx_read_ee_hostif_buffer(wx, 0,
-						  TXGBE_EEPROM_LAST_WORD,
-						  eeprom_ptrs);
-		if (status != 0) {
-			wx_err(wx, "Failed to read EEPROM image\n");
-			kvfree(eeprom_ptrs);
-			return status;
-		}
-		local_buffer = eeprom_ptrs;
-	} else {
-		if (buffer_size < TXGBE_EEPROM_LAST_WORD)
-			return -EFAULT;
-		local_buffer = buffer;
+	eeprom_ptrs = kvmalloc_array(TXGBE_EEPROM_LAST_WORD, sizeof(u16),
+				     GFP_KERNEL);
+	if (!eeprom_ptrs)
+		return -ENOMEM;
+	/* Read pointer area */
+	status = wx_read_ee_hostif_buffer(wx, 0, TXGBE_EEPROM_LAST_WORD, eeprom_ptrs);
+	if (status != 0) {
+		wx_err(wx, "Failed to read EEPROM image\n");
+		kvfree(eeprom_ptrs);
+		return status;
 	}
+	local_buffer = eeprom_ptrs;
 
 	for (i = 0; i < TXGBE_EEPROM_LAST_WORD; i++)
 		if (i != wx->eeprom.sw_region_offset + TXGBE_EEPROM_CHECKSUM)
-- 
2.34.1


