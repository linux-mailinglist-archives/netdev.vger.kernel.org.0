Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F0F1AFFD7
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 04:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgDTCSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 22:18:44 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54780 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726050AbgDTCSn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 22:18:43 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 266DAE0A4CACE56D3F2C;
        Mon, 20 Apr 2020 10:18:40 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Mon, 20 Apr 2020 10:18:34 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 04/10] net: hns3: remove useless proto_support field in struct hclge_fd_cfg
Date:   Mon, 20 Apr 2020 10:17:29 +0800
Message-ID: <1587349055-4403-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587349055-4403-1-git-send-email-tanhuazhong@huawei.com>
References: <1587349055-4403-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

proto_support field in struct hclge_fd_cfg shows what protocols
in flow direct table are supported now. It is unnecessary since
checking which one is unsupported will be more efficient,
so this patch removes it.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 17 ++++++-----------
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h |  1 -
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 999f056..e238a9d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4876,9 +4876,6 @@ static int hclge_init_fd_config(struct hclge_dev *hdev)
 		return -EOPNOTSUPP;
 	}
 
-	hdev->fd_cfg.proto_support =
-		TCP_V4_FLOW | UDP_V4_FLOW | SCTP_V4_FLOW | TCP_V6_FLOW |
-		UDP_V6_FLOW | SCTP_V6_FLOW | IPV4_USER_FLOW | IPV6_USER_FLOW;
 	key_cfg = &hdev->fd_cfg.key_cfg[HCLGE_FD_STAGE_1];
 	key_cfg->key_sel = HCLGE_FD_KEY_BASE_ON_TUPLE,
 	key_cfg->inner_sipv6_word_en = LOW_2_WORDS;
@@ -4892,11 +4889,9 @@ static int hclge_init_fd_config(struct hclge_dev *hdev)
 				BIT(INNER_SRC_PORT) | BIT(INNER_DST_PORT);
 
 	/* If use max 400bit key, we can support tuples for ether type */
-	if (hdev->fd_cfg.max_key_length == MAX_KEY_LENGTH) {
-		hdev->fd_cfg.proto_support |= ETHER_FLOW;
+	if (hdev->fd_cfg.fd_mode == HCLGE_FD_MODE_DEPTH_2K_WIDTH_400B_STAGE_1)
 		key_cfg->tuple_active |=
 				BIT(INNER_DST_MAC) | BIT(INNER_SRC_MAC);
-	}
 
 	/* roce_type is used to filter roce frames
 	 * dst_vport is used to specify the rule
@@ -5397,7 +5392,8 @@ static int hclge_fd_check_ext_tuple(struct hclge_dev *hdev,
 	}
 
 	if (fs->flow_type & FLOW_MAC_EXT) {
-		if (!(hdev->fd_cfg.proto_support & ETHER_FLOW))
+		if (hdev->fd_cfg.fd_mode !=
+		    HCLGE_FD_MODE_DEPTH_2K_WIDTH_400B_STAGE_1)
 			return -EOPNOTSUPP;
 
 		if (is_zero_ether_addr(fs->h_ext.h_dest))
@@ -5413,21 +5409,20 @@ static int hclge_fd_check_spec(struct hclge_dev *hdev,
 			       struct ethtool_rx_flow_spec *fs,
 			       u32 *unused_tuple)
 {
+	u32 flow_type;
 	int ret;
 
 	if (fs->location >= hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1])
 		return -EINVAL;
 
-	if (!(fs->flow_type & hdev->fd_cfg.proto_support))
-		return -EOPNOTSUPP;
-
 	if ((fs->flow_type & FLOW_EXT) &&
 	    (fs->h_ext.data[0] != 0 || fs->h_ext.data[1] != 0)) {
 		dev_err(&hdev->pdev->dev, "user-def bytes are not supported\n");
 		return -EOPNOTSUPP;
 	}
 
-	switch (fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT)) {
+	flow_type = fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT);
+	switch (flow_type) {
 	case SCTP_V4_FLOW:
 	case TCP_V4_FLOW:
 	case UDP_V4_FLOW:
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 71df23d..a58c262 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -580,7 +580,6 @@ struct hclge_fd_key_cfg {
 struct hclge_fd_cfg {
 	u8 fd_mode;
 	u16 max_key_length; /* use bit as unit */
-	u32 proto_support;
 	u32 rule_num[MAX_STAGE_NUM]; /* rule entry number */
 	u16 cnt_num[MAX_STAGE_NUM]; /* rule hit counter number */
 	struct hclge_fd_key_cfg key_cfg[MAX_STAGE_NUM];
-- 
2.7.4

