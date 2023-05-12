Return-Path: <netdev+bounces-2107-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 473A97004A0
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 12:04:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03072281A1A
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC09CBE74;
	Fri, 12 May 2023 10:03:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F2ED309
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:03:31 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC415FCF
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 03:03:03 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QHkkL68XrzLpsN;
	Fri, 12 May 2023 17:59:06 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 18:01:57 +0800
From: Hao Lan <lanhao@huawei.com>
To: <netdev@vger.kernel.org>
CC: <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <lanhao@huawei.com>, <huangguangbin2@huawei.com>,
	<simon.horman@corigine.com>, <shaojijie@huawei.com>, <chenhao418@huawei.com>,
	<shenjian15@huawei.com>, <liuyonglong@huawei.com>, <wangjie125@huawei.com>,
	<yuanjilin@cdjrlc.com>, <cai.huoqing@linux.dev>, <xiujianfeng@huawei.com>,
	<tanhuazhong@huawei.com>
Subject: [PATCH net 4/4] net: hns3: fix reset timeout when enable full VF
Date: Fri, 12 May 2023 18:00:14 +0800
Message-ID: <20230512100014.2522-5-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230512100014.2522-1-lanhao@huawei.com>
References: <20230512100014.2522-1-lanhao@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jijie Shao <shaojijie@huawei.com>

The timeout of the cmdq reset command has been increased to
resolve the reset timeout issue in the full VF scenario.
The timeout of other cmdq commands remains unchanged.

Fixes: 8d307f8e8cf1 ("net: hns3: create new set of unified hclge_comm_cmd_send APIs")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
---
 .../hns3/hns3_common/hclge_comm_cmd.c         | 25 ++++++++++++++++---
 .../hns3/hns3_common/hclge_comm_cmd.h         |  8 +++++-
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
index cbbab5b2b402..b85c412683dd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
@@ -331,9 +331,25 @@ static int hclge_comm_cmd_csq_done(struct hclge_comm_hw *hw)
 	return head == hw->cmq.csq.next_to_use;
 }
 
-static void hclge_comm_wait_for_resp(struct hclge_comm_hw *hw,
+static u32 hclge_get_cmdq_tx_timeout(u16 opcode, u32 tx_timeout)
+{
+	static const struct hclge_cmdq_tx_timeout_map cmdq_tx_timeout_map[] = {
+		{HCLGE_OPC_CFG_RST_TRIGGER, HCLGE_COMM_CMDQ_TX_TIMEOUT_500MS},
+	};
+	u32 i;
+
+	for (i = 0; i < ARRAY_SIZE(cmdq_tx_timeout_map); i++)
+		if (cmdq_tx_timeout_map[i].opcode == opcode)
+			return cmdq_tx_timeout_map[i].tx_timeout;
+
+	return tx_timeout;
+}
+
+static void hclge_comm_wait_for_resp(struct hclge_comm_hw *hw, u16 opcode,
 				     bool *is_completed)
 {
+	u32 cmdq_tx_timeout = hclge_get_cmdq_tx_timeout(opcode,
+							hw->cmq.tx_timeout);
 	u32 timeout = 0;
 
 	do {
@@ -343,7 +359,7 @@ static void hclge_comm_wait_for_resp(struct hclge_comm_hw *hw,
 		}
 		udelay(1);
 		timeout++;
-	} while (timeout < hw->cmq.tx_timeout);
+	} while (timeout < cmdq_tx_timeout);
 }
 
 static int hclge_comm_cmd_convert_err_code(u16 desc_ret)
@@ -407,7 +423,8 @@ static int hclge_comm_cmd_check_result(struct hclge_comm_hw *hw,
 	 * if multi descriptors to be sent, use the first one to check
 	 */
 	if (HCLGE_COMM_SEND_SYNC(le16_to_cpu(desc->flag)))
-		hclge_comm_wait_for_resp(hw, &is_completed);
+		hclge_comm_wait_for_resp(hw, le16_to_cpu(desc->opcode),
+					 &is_completed);
 
 	if (!is_completed)
 		ret = -EBADE;
@@ -529,7 +546,7 @@ int hclge_comm_cmd_queue_init(struct pci_dev *pdev, struct hclge_comm_hw *hw)
 	cmdq->crq.desc_num = HCLGE_COMM_NIC_CMQ_DESC_NUM;
 
 	/* Setup Tx write back timeout */
-	cmdq->tx_timeout = HCLGE_COMM_CMDQ_TX_TIMEOUT;
+	cmdq->tx_timeout = HCLGE_COMM_CMDQ_TX_TIMEOUT_DEFAULT;
 
 	/* Setup queue rings */
 	ret = hclge_comm_alloc_cmd_queue(hw, HCLGE_COMM_TYPE_CSQ);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index de72ecbfd5ad..18f1b4bf362d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -54,7 +54,8 @@
 #define HCLGE_COMM_NIC_SW_RST_RDY		BIT(HCLGE_COMM_NIC_SW_RST_RDY_B)
 #define HCLGE_COMM_NIC_CMQ_DESC_NUM_S		3
 #define HCLGE_COMM_NIC_CMQ_DESC_NUM		1024
-#define HCLGE_COMM_CMDQ_TX_TIMEOUT		30000
+#define HCLGE_COMM_CMDQ_TX_TIMEOUT_DEFAULT	30000
+#define HCLGE_COMM_CMDQ_TX_TIMEOUT_500MS	500000
 
 enum hclge_opcode_type {
 	/* Generic commands */
@@ -360,6 +361,11 @@ struct hclge_comm_caps_bit_map {
 	u16 local_bit;
 };
 
+struct hclge_cmdq_tx_timeout_map {
+	u32 opcode;
+	u32 tx_timeout;
+};
+
 struct hclge_comm_firmware_compat_cmd {
 	__le32 compat;
 	u8 rsv[20];
-- 
2.30.0


