Return-Path: <netdev+bounces-2664-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21B0A702EA9
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:49:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3020F1C20A5F
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DD0AD2FD;
	Mon, 15 May 2023 13:48:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930E4D2EA
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:48:37 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582D21BC
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:48:35 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QKgdR3n1szsRlm;
	Mon, 15 May 2023 21:46:35 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 21:48:33 +0800
From: Hao Lan <lanhao@huawei.com>
To: <netdev@vger.kernel.org>
CC: <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <richardcochran@gmail.com>, <lanhao@huawei.com>,
	<wangpeiyang1@huawei.com>, <shenjian15@huawei.com>, <chenhao418@huawei.com>,
	<simon.horman@corigine.com>, <wangjie125@huawei.com>, <yuanjilin@cdjrlc.com>,
	<cai.huoqing@linux.dev>, <xiujianfeng@huawei.com>
Subject: [PATCH net-next 2/4] net: hns3: fix hns3 driver header file not self-contained issue
Date: Mon, 15 May 2023 21:46:41 +0800
Message-ID: <20230515134643.48314-3-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230515134643.48314-1-lanhao@huawei.com>
References: <20230515134643.48314-1-lanhao@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Hao Chen <chenhao418@huawei.com>

Hns3 driver header file uses the structure of other files, but does
not include corresponding file, which causes a check warning that the
header file is not self-contained by clang-tidy checker.

For example,
Header file 'hclge_mbx.h' is not self contained.
It should include following headers: (1) 'hclgevf_main.h'
due to symbols 'struct hclgevf_dev'. The main source file is hns3_enet.c

Therefore, the required header file is included in the header file, and
the structure declaration is added to the header file to avoid cyclic
dependency of the header file.

Signed-off-by: Hao Chen <chenhao418@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h              | 4 +++-
 .../hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.h        | 2 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h              | 3 +++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h       | 5 ++++-
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index abcd7877f7d2..487216aeae50 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -7,6 +7,8 @@
 #include <linux/mutex.h>
 #include <linux/types.h>
 
+struct hclgevf_dev;
+
 enum HCLGE_MBX_OPCODE {
 	HCLGE_MBX_RESET = 0x01,		/* (VF -> PF) assert reset */
 	HCLGE_MBX_ASSERTING_RESET,	/* (PF -> VF) PF is asserting reset */
@@ -233,7 +235,7 @@ struct hclgevf_mbx_arq_ring {
 	__le16 msg_q[HCLGE_MBX_MAX_ARQ_MSG_NUM][HCLGE_MBX_MAX_ARQ_MSG_SIZE];
 };
 
-struct hclge_dev;
+struct hclge_vport;
 
 #define HCLGE_MBX_OPCODE_MAX 256
 struct hclge_mbx_ops_param {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.h
index a46350162ee8..7aff1a544cf4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.h
@@ -7,6 +7,8 @@
 #include <linux/etherdevice.h>
 #include "hnae3.h"
 
+struct hclge_comm_hw;
+
 /* each tqp has TX & RX two queues */
 #define HCLGE_COMM_QUEUE_PAIR_SIZE 2
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 88af34bbee34..1b360aa52e5d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -13,6 +13,9 @@
 
 struct iphdr;
 struct ipv6hdr;
+struct gre_base_hdr;
+struct tcphdr;
+struct udphdr;
 
 enum hns3_nic_state {
 	HNS3_NIC_STATE_TESTING,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h
index bbee74cd8404..bceb61c791a1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h
@@ -8,8 +8,11 @@
 #include <linux/net_tstamp.h>
 #include <linux/types.h>
 
-struct hclge_dev;
 struct ifreq;
+struct ethtool_ts_info;
+
+struct hnae3_handle;
+struct hclge_dev;
 
 #define HCLGE_PTP_REG_OFFSET	0x29000
 
-- 
2.30.0


