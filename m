Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51345E7178
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 03:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbiIWBlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 21:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiIWBlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 21:41:11 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4963D1EBE;
        Thu, 22 Sep 2022 18:41:07 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MYZY34DFrzpVbP;
        Fri, 23 Sep 2022 09:38:15 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 09:41:06 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 09:41:05 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <jiri@mellanox.com>, <moshe@mellanox.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <idosch@nvidia.com>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <chenhao418@huawei.com>
Subject: [PATCH net-next 2/2] net: hns3: PF add support setting parameters of congestion control algorithm by devlink param
Date:   Fri, 23 Sep 2022 09:38:18 +0800
Message-ID: <20220923013818.51003-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220923013818.51003-1-huangguangbin2@huawei.com>
References: <20220923013818.51003-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao418@huawei.com>

Some new devices support dynamiclly configuring parameters of congestion
control algorithm, this patch implement it by devlink param.

Examples of read and set command are as follows:

$ devlink dev param set pci/0000:35:00.0 name algo_param value \
  "type@dcqcn_alp@30_f@35_tmp@11_tkp@11_ai@60_maxspeed@17_g@11_al@19_cnptime@20" \
  cmode runtime

$ devlink dev param show pci/0000:35:00.0 name algo_param
pci/0000:35:00.0:
  name algo_param type driver-specific
    values:
      cmode runtime value type@dcqcn_ai@60_f@35_tkp@11_tmp@11_alp@30_maxspeed@17_g@11_al@19_cnptime@20

Signed-off-by: Hao Chen <chenhao418@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hns3/hns3_common/hclge_comm_cmd.h         |   6 +
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  44 +
 .../hisilicon/hns3/hns3pf/hclge_devlink.c     | 788 ++++++++++++++++++
 .../hisilicon/hns3/hns3pf/hclge_devlink.h     |   6 +
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 122 +++
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  61 ++
 6 files changed, 1027 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index b1f9383b418f..8ee477a39d4a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -243,6 +243,12 @@ enum hclge_opcode_type {
 	HCLGE_OPC_QCN_AJUST_INIT	= 0x1A07,
 	HCLGE_OPC_QCN_DFX_CNT_STATUS    = 0x1A08,
 
+	/* Algo param commands */
+	HCLGE_OPC_ALGO_PARAM_DCQCN	= 0x1A80,
+	HCLGE_OPC_ALGO_PARAM_LDCP	= 0x1A81,
+	HCLGE_OPC_ALGO_PARAM_HC3	= 0x1A82,
+	HCLGE_OPC_ALGO_PARAM_DIP	= 0x1A83,
+
 	/* Mailbox command */
 	HCLGEVF_OPC_MBX_PF_TO_VF	= 0x2000,
 	HCLGEVF_OPC_MBX_VF_TO_PF	= 0x2001,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 43cada51d8cb..e19d0da6ae35 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -872,6 +872,50 @@ struct hclge_phy_reg_cmd {
 	u8 rsv1[18];
 };
 
+struct hclge_dcqcn_param_cfg_cmd {
+	__le16 ai;
+	u8 f;
+	u8 tkp;
+	__le16 tmp;
+	__le16 alp;
+	__le32 max_speed;
+	u8 g;
+	u8 al;
+	u8 cnp_time;
+	u8 alp_shift;
+};
+
+struct hclge_ldcp_param_cfg_cmd {
+	__le32 cwd0;
+	u8 la;
+	u8 ly;
+	u8 lb;
+	u8 lg;
+};
+
+struct hclge_hc3_param_cfg_cmd {
+	__le32 win;
+	__le32 hcb;
+	u8 maxqs;
+	u8 hcalp;
+	u8 hct;
+	u8 maxstg;
+	u8 gamshift;
+};
+
+struct hclge_dip_param_cfg_cmd {
+	__le16 ai;
+	u8 f;
+	u8 tkp;
+	__le16 tmp;
+	__le16 alp;
+	__le32 max_speed;
+	u8 g;
+	u8 al;
+	u8 cnp_time;
+	u8 alp_shift;
+};
+
 struct hclge_hw;
 int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num);
 enum hclge_comm_cmd_status hclge_cmd_mdio_write(struct hclge_hw *hw,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
index 4c441e6a5082..699c433fdf4a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
@@ -5,6 +5,9 @@
 
 #include "hclge_devlink.h"
 
+#define HCLGE_DEVLINK_MAX_ALGO_TYPE_LEN		16
+#define HCLGE_DEVLINK_MAX_ALGO_PARAM_NUM	12
+
 static int hclge_devlink_info_get(struct devlink *devlink,
 				  struct devlink_info_req *req,
 				  struct netlink_ext_ack *extack)
@@ -97,6 +100,751 @@ static int hclge_devlink_reload_up(struct devlink *devlink,
 	}
 }
 
+static void
+hclge_devlink_dcqcn_param_get(struct devlink *devlink,
+			      struct devlink_param_gset_ctx *ctx, char *type)
+{
+#define DCQCN_ALL_PARAM_STRING \
+	"type@%s_ai@%u_f@%u_tkp@%u_tmp@%u_alp@%u_maxspeed@%u_g@%u_al@%u_cnptime@%u_alpshift@%u\n"
+
+	struct hclge_devlink_priv *priv = devlink_priv(devlink);
+	struct hclge_dev *hdev = priv->hdev;
+	struct hclge_cfg_dcqcn_param *param = &hdev->algo_param.dcqcn_param;
+	char str[__DEVLINK_PARAM_MAX_STRING_VALUE] = {0};
+
+	scnprintf(str, __DEVLINK_PARAM_MAX_STRING_VALUE, DCQCN_ALL_PARAM_STRING,
+		  type, param->ai, param->f, param->tkp, param->tmp, param->alp,
+		  param->max_speed, param->g, param->al, param->cnp_time,
+		  param->alp_shift);
+	strncpy(ctx->val.vstr, str, __DEVLINK_PARAM_MAX_STRING_VALUE);
+}
+
+static void
+hclge_devlink_ldcp_param_get(struct devlink *devlink,
+			     struct devlink_param_gset_ctx *ctx, char *type)
+{
+	struct hclge_devlink_priv *priv = devlink_priv(devlink);
+	struct hclge_dev *hdev = priv->hdev;
+	struct hclge_cfg_ldcp_param *param = &hdev->algo_param.ldcp_param;
+	char str[__DEVLINK_PARAM_MAX_STRING_VALUE] = {0};
+
+	scnprintf(str, __DEVLINK_PARAM_MAX_STRING_VALUE,
+		  "type@%s_cwd0@%u_la@%u_ly@%u_lb@%u_lg@%u\n", type,
+		  param->cwd0, param->la, param->ly, param->lb, param->lg);
+	strncpy(ctx->val.vstr, str, __DEVLINK_PARAM_MAX_STRING_VALUE);
+}
+
+static void
+hclge_devlink_hc3_param_get(struct devlink *devlink,
+			    struct devlink_param_gset_ctx *ctx, char *type)
+{
+#define HC3_ALL_PARAM_STRING \
+	"type@%s_win@%u_hcb@%u_maxqs@%u_hcalp@%u_hct@%u_maxstg@%u_gamshift@%u\n"
+
+	struct hclge_devlink_priv *priv = devlink_priv(devlink);
+	struct hclge_dev *hdev = priv->hdev;
+	struct hclge_cfg_hc3_param *param = &hdev->algo_param.hc3_param;
+	char str[__DEVLINK_PARAM_MAX_STRING_VALUE] = {0};
+
+	scnprintf(str, __DEVLINK_PARAM_MAX_STRING_VALUE, HC3_ALL_PARAM_STRING,
+		  type, param->win, param->hcb, param->maxqs, param->hcalp,
+		  param->hct, param->maxstg, param->gamshift);
+	strncpy(ctx->val.vstr, str, __DEVLINK_PARAM_MAX_STRING_VALUE);
+}
+
+static void
+hclge_devlink_dip_param_get(struct devlink *devlink,
+			    struct devlink_param_gset_ctx *ctx, char *type)
+{
+#define DIP_ALL_PARAM_STRING \
+	"type@%s_ai@%u_f@%u_tkp@%u_tmp@%u_alp@%u_maxspeed@%u_g@%u_al@%u_cnptime@%u_alpshift@%u\n"
+
+	struct hclge_devlink_priv *priv = devlink_priv(devlink);
+	struct hclge_dev *hdev = priv->hdev;
+	struct hclge_cfg_dip_param *param = &hdev->algo_param.dip_param;
+	char str[__DEVLINK_PARAM_MAX_STRING_VALUE] = {0};
+
+	scnprintf(str, __DEVLINK_PARAM_MAX_STRING_VALUE, DIP_ALL_PARAM_STRING,
+		  type, param->ai, param->f, param->tkp, param->tmp, param->alp,
+		  param->max_speed, param->g, param->al, param->cnp_time,
+		  param->alp_shift);
+	strncpy(ctx->val.vstr, str, __DEVLINK_PARAM_MAX_STRING_VALUE);
+}
+
+static int
+hclge_devlink_algo_param_get(struct devlink *devlink, u32 id,
+			     struct devlink_param_gset_ctx *ctx)
+{
+	struct hclge_devlink_priv *priv = devlink_priv(devlink);
+	char type[HCLGE_DEVLINK_MAX_ALGO_TYPE_LEN] = {0};
+	struct hclge_dev *hdev = priv->hdev;
+
+	switch (hdev->algo_param_type) {
+	case HCLGE_ALGO_PARAM_DCQCN:
+		strncpy(type, "dcqcn", strlen("dcqcn") + 1);
+		hclge_devlink_dcqcn_param_get(devlink, ctx, type);
+		break;
+	case HCLGE_ALGO_PARAM_LDCP:
+		strncpy(type, "ldcp", strlen("ldcp") + 1);
+		hclge_devlink_ldcp_param_get(devlink, ctx, type);
+		break;
+	case HCLGE_ALGO_PARAM_HC3:
+		strncpy(type, "hc3", strlen("hc3") + 1);
+		hclge_devlink_hc3_param_get(devlink, ctx, type);
+		break;
+	case HCLGE_ALGO_PARAM_DIP:
+		strncpy(type, "dip", strlen("dip") + 1);
+		hclge_devlink_dip_param_get(devlink, ctx, type);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static void
+hclge_algo_param_print_dcqcn(struct hclge_dev *hdev,
+			     const struct hclge_cfg_dcqcn_param *dcqcn_param)
+{
+	char str[__DEVLINK_PARAM_MAX_STRING_VALUE] = {0};
+	int len = __DEVLINK_PARAM_MAX_STRING_VALUE;
+	int pos = 0;
+
+	pos += scnprintf(str + pos, len - pos, "type:  dcqcn\n");
+	pos += scnprintf(str + pos, len - pos, "AI:  %u\n", dcqcn_param->ai);
+	pos += scnprintf(str + pos, len - pos, "F:  %u\n", dcqcn_param->f);
+	pos += scnprintf(str + pos, len - pos, "TKP:  %u\n", dcqcn_param->tkp);
+	pos += scnprintf(str + pos, len - pos, "TMP:  %u\n", dcqcn_param->tmp);
+	pos += scnprintf(str + pos, len - pos, "ALP:  %u\n", dcqcn_param->alp);
+	pos += scnprintf(str + pos, len - pos, "MAX_SPEED:  %u\n",
+			 dcqcn_param->max_speed);
+	pos += scnprintf(str + pos, len - pos, "G:  %u\n", dcqcn_param->g);
+	pos += scnprintf(str + pos, len - pos, "AL:  %u\n", dcqcn_param->al);
+	pos += scnprintf(str + pos, len - pos, "CNP_TIME:  %u\n",
+			 dcqcn_param->cnp_time);
+	pos += scnprintf(str + pos, len - pos, "ALP_SHIFT:  %u\n",
+			 dcqcn_param->alp_shift);
+	dev_info(&hdev->pdev->dev, "%s", str);
+}
+
+static void
+hclge_algo_param_print_ldcp(struct hclge_dev *hdev,
+			    const struct hclge_cfg_ldcp_param *param)
+{
+	char str[__DEVLINK_PARAM_MAX_STRING_VALUE] = {0};
+	int len = __DEVLINK_PARAM_MAX_STRING_VALUE;
+	int pos = 0;
+
+	pos += scnprintf(str + pos, len - pos, "type:  ldcp\n");
+	pos += scnprintf(str + pos, len - pos, "CWD_0:  %u\n", param->cwd0);
+	pos += scnprintf(str + pos, len - pos, "L_A:  %u\n", param->la);
+	pos += scnprintf(str + pos, len - pos, "L_Y:  %u\n", param->ly);
+	pos += scnprintf(str + pos, len - pos, "L_B:  %u\n", param->lb);
+	pos += scnprintf(str + pos, len - pos, "L_G:  %u\n", param->lg);
+	dev_info(&hdev->pdev->dev, "%s", str);
+}
+
+static void hclge_algo_param_print_hc3(struct hclge_dev *hdev,
+				       const struct hclge_cfg_hc3_param *param)
+{
+	char str[__DEVLINK_PARAM_MAX_STRING_VALUE] = {0};
+	int len = __DEVLINK_PARAM_MAX_STRING_VALUE;
+	int pos = 0;
+
+	pos += scnprintf(str + pos, len - pos, "type:  hc3\n");
+	pos += scnprintf(str + pos, len - pos, "WIN:  %u\n", param->win);
+	pos += scnprintf(str + pos, len - pos, "HC_B:  %u\n", param->hcb);
+	pos += scnprintf(str + pos, len - pos, "MAX_QS:  %u\n", param->maxqs);
+	pos += scnprintf(str + pos, len - pos, "HC_ALP:  %u\n", param->hcalp);
+	pos += scnprintf(str + pos, len - pos, "HC_T:  %u\n", param->hct);
+	pos += scnprintf(str + pos, len - pos, "MAX_STG:  %u\n", param->maxstg);
+	pos += scnprintf(str + pos, len - pos, "GAM_SHIFT:  %u\n",
+			 param->gamshift);
+	dev_info(&hdev->pdev->dev, "%s", str);
+}
+
+static void hclge_algo_param_print_dip(struct hclge_dev *hdev,
+				       const struct hclge_cfg_dip_param *param)
+{
+	char str[__DEVLINK_PARAM_MAX_STRING_VALUE] = {0};
+	int len = __DEVLINK_PARAM_MAX_STRING_VALUE;
+	int pos = 0;
+
+	pos += scnprintf(str + pos, len - pos, "type:  dip\n");
+	pos += scnprintf(str + pos, len - pos, "AI:  %u\n", param->ai);
+	pos += scnprintf(str + pos, len - pos, "F:  %u\n", param->f);
+	pos += scnprintf(str + pos, len - pos, "TKP:  %u\n", param->tkp);
+	pos += scnprintf(str + pos, len - pos, "TMP:  %u\n", param->tmp);
+	pos += scnprintf(str + pos, len - pos, "ALP:  %u\n", param->alp);
+	pos += scnprintf(str + pos, len - pos, "MAX_SPEED:  %u\n",
+			 param->max_speed);
+	pos += scnprintf(str + pos, len - pos, "G:  %u\n", param->g);
+	pos += scnprintf(str + pos, len - pos, "AL:  %u\n", param->al);
+	pos += scnprintf(str + pos, len - pos, "CNP_TIME:  %u\n",
+			 param->cnp_time);
+	pos += scnprintf(str + pos, len - pos, "ALP_SHIFT:  %u\n",
+			 param->alp_shift);
+	dev_info(&hdev->pdev->dev, "%s", str);
+}
+
+enum HCLGE_ALGO_PARAM_SIZE_TYPE {
+	ALGO_SIZE_U8,
+	ALGO_SIZE_U16,
+	ALGO_SIZE_U32,
+};
+
+struct algo_param_item {
+	const char *name;
+	u64 max;
+	u64 value;
+	int offset;
+	enum HCLGE_ALGO_PARAM_SIZE_TYPE size_type;
+	const char *error_log;
+};
+
+struct algo_param_item dcqcn_items[] = {
+	{"ai@", 65535, 0, offsetof(struct hclge_cfg_dcqcn_param, ai),
+	 ALGO_SIZE_U16, "param ai of dcqcn overflow!\n"},
+	{"f@", 255, 0, offsetof(struct hclge_cfg_dcqcn_param, f),
+	 ALGO_SIZE_U8, "param f of dcqcn overflow!\n"},
+	{"tkp@", 15, 0, offsetof(struct hclge_cfg_dcqcn_param, tkp),
+	 ALGO_SIZE_U8, "param tkp of dcqcn overflow!\n"},
+	{"tmp@", 15, 0, offsetof(struct hclge_cfg_dcqcn_param, tmp),
+	 ALGO_SIZE_U16, "param tmp of dcqcn overflow!\n"},
+	{"alp@", 65535, 0, offsetof(struct hclge_cfg_dcqcn_param, alp),
+	 ALGO_SIZE_U16, "param alp of dcqcn overflow!\n"},
+	{"maxspeed@", UINT_MAX, 0, offsetof(struct hclge_cfg_dcqcn_param, max_speed),
+	 ALGO_SIZE_U32, "param maxspeed of dcqcn overflow!\n"},
+	{"g@", 15, 0, offsetof(struct hclge_cfg_dcqcn_param, g),
+	 ALGO_SIZE_U8, "param g of dcqcn overflow!\n"},
+	{"al@", 255, 0, offsetof(struct hclge_cfg_dcqcn_param, al),
+	 ALGO_SIZE_U8, "param al of dcqcn overflow!\n"},
+	{"cnptime@", 255, 0, offsetof(struct hclge_cfg_dcqcn_param, cnp_time),
+	 ALGO_SIZE_U8, "param cnptime of dcqcn overflow!\n"},
+	{"alpshift@", 15, 0, offsetof(struct hclge_cfg_dcqcn_param, alp_shift),
+	 ALGO_SIZE_U8, "param alpshift of dcqcn overflow!\n"},
+};
+
+struct algo_param_item ldcp_items[] = {
+	{"cwd0@", UINT_MAX, 0, offsetof(struct hclge_cfg_ldcp_param, cwd0),
+	 ALGO_SIZE_U32, "param cwd0 of ldcp overflow!\n"},
+	{"la@", 255, 0, offsetof(struct hclge_cfg_ldcp_param, la),
+	 ALGO_SIZE_U8, "param la of ldcp overflow!\n"},
+	{"ly@", 255, 0, offsetof(struct hclge_cfg_ldcp_param, ly),
+	 ALGO_SIZE_U8, "param ly of ldcp overflow!\n"},
+	{"lb@", 255, 0, offsetof(struct hclge_cfg_ldcp_param, lb),
+	 ALGO_SIZE_U8, "param lb of ldcp overflow!\n"},
+	{"lg@", 255, 0, offsetof(struct hclge_cfg_ldcp_param, lg),
+	 ALGO_SIZE_U8, "param lg of ldcp overflow!\n"},
+};
+
+struct algo_param_item hc3_items[] = {
+	{"win@", UINT_MAX, 0, offsetof(struct hclge_cfg_hc3_param, win),
+	 ALGO_SIZE_U32, "param win of hc3 overflow!\n"},
+	{"hcb@", UINT_MAX, 0, offsetof(struct hclge_cfg_hc3_param, hcb),
+	 ALGO_SIZE_U32, "param hcb of hc3 overflow!\n"},
+	{"maxqs@", 255, 0, offsetof(struct hclge_cfg_hc3_param, maxqs),
+	 ALGO_SIZE_U8, "param maxqs of hc3 overflow!\n"},
+	{"hcalp@", 255, 0, offsetof(struct hclge_cfg_hc3_param, hcalp),
+	 ALGO_SIZE_U8, "param hcalp of hc3 overflow!\n"},
+	{"hct@", 255, 0, offsetof(struct hclge_cfg_hc3_param, hct),
+	 ALGO_SIZE_U8, "param hct of hc3 overflow!\n"},
+	{"maxstg@", 255, 0, offsetof(struct hclge_cfg_hc3_param, maxstg),
+	 ALGO_SIZE_U8, "param maxstg of hc3 overflow!\n"},
+	{"gamshift@", 15, 0, offsetof(struct hclge_cfg_hc3_param, gamshift),
+	 ALGO_SIZE_U8, "param gamshift of hc3 overflow!\n"},
+};
+
+struct algo_param_item dip_items[] = {
+	{"ai@", 65535, 0, offsetof(struct hclge_cfg_dip_param, ai),
+	 ALGO_SIZE_U16, "param ai of dip overflow!\n"},
+	{"f@", 255, 0, offsetof(struct hclge_cfg_dip_param, f),
+	 ALGO_SIZE_U8, "param f of dip overflow!\n"},
+	{"tkp@", 15, 0, offsetof(struct hclge_cfg_dip_param, tkp),
+	 ALGO_SIZE_U8, "param tkp of dip overflow!\n"},
+	{"tmp@", 15, 0, offsetof(struct hclge_cfg_dip_param, tmp),
+	 ALGO_SIZE_U16, "param tmp of dip overflow!\n"},
+	{"alp@", 65535, 0, offsetof(struct hclge_cfg_dip_param, alp),
+	 ALGO_SIZE_U16, "param alp of dip overflow!\n"},
+	{"maxspeed@", UINT_MAX, 0, offsetof(struct hclge_cfg_dip_param, max_speed),
+	 ALGO_SIZE_U32, "param maxspeed of dip overflow!\n"},
+	{"g@", 15, 0, offsetof(struct hclge_cfg_dip_param, g),
+	 ALGO_SIZE_U8, "param g of dip overflow!\n"},
+	{"al@", 255, 0, offsetof(struct hclge_cfg_dip_param, al),
+	 ALGO_SIZE_U8, "param al of dip overflow!\n"},
+	{"cnptime@", 255, 0, offsetof(struct hclge_cfg_dip_param, cnp_time),
+	 ALGO_SIZE_U8, "param cnptime of dip overflow!\n"},
+	{"alpshift@", 15, 0, offsetof(struct hclge_cfg_dip_param, alp_shift),
+	 ALGO_SIZE_U8, "param alpshift of dip overflow!\n"},
+};
+
+struct algo_param_item *algo_items[] = {
+	[HCLGE_ALGO_PARAM_DCQCN] = dcqcn_items,
+	[HCLGE_ALGO_PARAM_LDCP] = ldcp_items,
+	[HCLGE_ALGO_PARAM_HC3] = hc3_items,
+	[HCLGE_ALGO_PARAM_DIP] = dip_items,
+};
+
+const u32 algo_items_size[] = {
+	[HCLGE_ALGO_PARAM_DCQCN] = ARRAY_SIZE(dcqcn_items),
+	[HCLGE_ALGO_PARAM_LDCP] = ARRAY_SIZE(ldcp_items),
+	[HCLGE_ALGO_PARAM_HC3] = ARRAY_SIZE(hc3_items),
+	[HCLGE_ALGO_PARAM_DIP] = ARRAY_SIZE(dip_items),
+};
+
+const u64 algo_items_param_offset[] = {
+	[HCLGE_ALGO_PARAM_DCQCN] = offsetof(struct hclge_cfg_algo_param, dcqcn_param),
+	[HCLGE_ALGO_PARAM_LDCP] = offsetof(struct hclge_cfg_algo_param, ldcp_param),
+	[HCLGE_ALGO_PARAM_HC3] = offsetof(struct hclge_cfg_algo_param, hc3_param),
+	[HCLGE_ALGO_PARAM_DIP] = offsetof(struct hclge_cfg_algo_param, dip_param),
+};
+
+static int hclge_devlink_find_item(const struct algo_param_item *items,
+				   u32 size, const char *str)
+{
+	int i;
+
+	for (i = 0; i < size; i++) {
+		if (!strncmp(str, items[i].name, strlen(items[i].name)))
+			return i;
+	}
+
+	return -EINVAL;
+}
+
+static int hclge_devlink_get_algo_param_value(const char *str, u64 *param_value)
+{
+	char *value, *value_tmp, *tmp;
+	int ret = 0;
+	int i;
+
+	value = kmalloc(sizeof(char) * __DEVLINK_PARAM_MAX_STRING_VALUE,
+			GFP_KERNEL);
+	if (!value)
+		return -ENOMEM;
+
+	strncpy(value, str, __DEVLINK_PARAM_MAX_STRING_VALUE);
+	value_tmp = value;
+
+	tmp = strsep(&value, "@");
+
+	for (i = 0; i < strlen(value); i++) {
+		if (!(value[i] >= '0' && value[i] <= '9')) {
+			kfree(value_tmp);
+			return -EINVAL;
+		}
+	}
+
+	ret = kstrtou64(value, 0, param_value);
+
+	kfree(value_tmp);
+	return ret;
+}
+
+static int hclge_devlink_set_algo_param_dcqcn(struct hclge_dev *hdev,
+					      u8 *param_addr)
+{
+	struct hclge_cfg_dcqcn_param *dcqcn_param =
+				(struct hclge_cfg_dcqcn_param *)param_addr;
+	struct hclge_dcqcn_param_cfg_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_OPC_ALGO_PARAM_DCQCN,
+					false);
+	req = (struct hclge_dcqcn_param_cfg_cmd *)desc.data;
+	req->ai = cpu_to_le16(dcqcn_param->ai);
+	req->f = dcqcn_param->f;
+	req->tkp = dcqcn_param->tkp;
+	req->tmp = cpu_to_le16(dcqcn_param->tmp);
+	req->alp = cpu_to_le16(dcqcn_param->alp);
+	req->max_speed = cpu_to_le32(dcqcn_param->max_speed);
+	req->g = dcqcn_param->g;
+	req->al = dcqcn_param->al;
+	req->cnp_time = dcqcn_param->cnp_time;
+	req->alp_shift = dcqcn_param->alp_shift;
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"set dcqcn param fail, ret = %d\n", ret);
+	return ret;
+}
+
+static int hclge_devlink_set_algo_param_ldcp(struct hclge_dev *hdev,
+					     u8 *param_addr)
+{
+	struct hclge_cfg_ldcp_param *ldcp_param =
+				(struct hclge_cfg_ldcp_param *)param_addr;
+	struct hclge_ldcp_param_cfg_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_OPC_ALGO_PARAM_LDCP,
+					false);
+	req = (struct hclge_ldcp_param_cfg_cmd *)desc.data;
+	req->cwd0 = cpu_to_le32(ldcp_param->cwd0);
+	req->la = ldcp_param->la;
+	req->ly = ldcp_param->ly;
+	req->lb = ldcp_param->lb;
+	req->lg = ldcp_param->lg;
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"set ldcp param fail, ret = %d\n", ret);
+	return ret;
+}
+
+static int hclge_devlink_set_algo_param_hc3(struct hclge_dev *hdev,
+					    u8 *param_addr)
+{
+	struct hclge_cfg_hc3_param *hc3_param =
+				(struct hclge_cfg_hc3_param *)param_addr;
+	struct hclge_hc3_param_cfg_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_OPC_ALGO_PARAM_HC3, false);
+	req = (struct hclge_hc3_param_cfg_cmd *)desc.data;
+	req->win = cpu_to_le32(hc3_param->win);
+	req->hcb = cpu_to_le32(hc3_param->hcb);
+	req->maxqs = hc3_param->maxqs;
+	req->hcalp = hc3_param->hcalp;
+	req->hct = hc3_param->hct;
+	req->maxstg = hc3_param->maxstg;
+	req->gamshift = hc3_param->gamshift;
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"set hc3 param fail, ret = %d\n", ret);
+	return ret;
+}
+
+static int hclge_devlink_set_algo_param_dip(struct hclge_dev *hdev,
+					    u8 *param_addr)
+{
+	struct hclge_cfg_dip_param *dip_param =
+				(struct hclge_cfg_dip_param *)param_addr;
+	struct hclge_dip_param_cfg_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_OPC_ALGO_PARAM_DIP, false);
+	req = (struct hclge_dip_param_cfg_cmd *)desc.data;
+	req->ai = cpu_to_le16(dip_param->ai);
+	req->f = dip_param->f;
+	req->tkp = dip_param->tkp;
+	req->tmp = cpu_to_le16(dip_param->tmp);
+	req->alp = cpu_to_le16(dip_param->alp);
+	req->max_speed = cpu_to_le32(dip_param->max_speed);
+	req->g = dip_param->g;
+	req->al = dip_param->al;
+	req->cnp_time = dip_param->cnp_time;
+	req->alp_shift = dip_param->alp_shift;
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"set dip param fail, ret = %d\n", ret);
+	return ret;
+}
+
+void hclge_restore_algo_param(struct hclge_dev *hdev)
+{
+	int ret;
+
+	if (hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2)
+		return;
+
+	ret = hclge_devlink_set_algo_param_dcqcn(hdev, (u8 *)&hdev->algo_param.dcqcn_param);
+	if (ret)
+		return;
+
+	ret = hclge_devlink_set_algo_param_ldcp(hdev, (u8 *)&hdev->algo_param.ldcp_param);
+	if (ret)
+		return;
+
+	ret = hclge_devlink_set_algo_param_hc3(hdev, (u8 *)&hdev->algo_param.hc3_param);
+	if (ret)
+		return;
+
+	ret = hclge_devlink_set_algo_param_dip(hdev, (u8 *)&hdev->algo_param.dip_param);
+}
+
+static int hclge_devlink_set_algo_param(struct hclge_dev *hdev, u8 *param_addr,
+					enum HCLGE_ALGO_PARAM_TYPE type)
+{
+	int ret;
+
+	switch (type) {
+	case HCLGE_ALGO_PARAM_DCQCN:
+		ret = hclge_devlink_set_algo_param_dcqcn(hdev, param_addr);
+		if (ret)
+			return ret;
+
+		hdev->algo_param.dcqcn_param = *(struct hclge_cfg_dcqcn_param *)param_addr;
+		hclge_algo_param_print_dcqcn(hdev, &hdev->algo_param.dcqcn_param);
+		break;
+	case HCLGE_ALGO_PARAM_LDCP:
+		ret = hclge_devlink_set_algo_param_ldcp(hdev, param_addr);
+		if (ret)
+			return ret;
+
+		hdev->algo_param.ldcp_param = *(struct hclge_cfg_ldcp_param *)param_addr;
+		hclge_algo_param_print_ldcp(hdev, &hdev->algo_param.ldcp_param);
+		break;
+	case HCLGE_ALGO_PARAM_HC3:
+		ret = hclge_devlink_set_algo_param_hc3(hdev, param_addr);
+		if (ret)
+			return ret;
+
+		hdev->algo_param.hc3_param = *(struct hclge_cfg_hc3_param *)param_addr;
+		hclge_algo_param_print_hc3(hdev, &hdev->algo_param.hc3_param);
+		break;
+	case HCLGE_ALGO_PARAM_DIP:
+		ret = hclge_devlink_set_algo_param_dip(hdev, param_addr);
+		if (ret)
+			return ret;
+
+		hdev->algo_param.dip_param = *(struct hclge_cfg_dip_param *)param_addr;
+		hclge_algo_param_print_dip(hdev, &hdev->algo_param.dip_param);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static int
+hclge_devlink_algo_param_set_value(struct hclge_dev *hdev,
+				   enum HCLGE_ALGO_PARAM_TYPE type,
+				   struct devlink_param_gset_ctx *ctx)
+{
+	struct hclge_cfg_algo_param algo_param = hdev->algo_param;
+	char *tmp[HCLGE_DEVLINK_MAX_ALGO_PARAM_NUM] = {0};
+	struct algo_param_item *items = algo_items[type];
+	u64 algo_offset = algo_items_param_offset[type];
+	u8 *param_addr = (u8 *)&algo_param + algo_offset;
+	u32 size = algo_items_size[type];
+	char *str, *str_tmp;
+	u8 *item_addr;
+	int ret = 0;
+	int i = 0;
+	int y, k;
+
+	str = kmalloc(sizeof(char) * __DEVLINK_PARAM_MAX_STRING_VALUE,
+		      GFP_KERNEL);
+	if (!str)
+		return -ENOMEM;
+
+	strncpy(str, ctx->val.vstr, __DEVLINK_PARAM_MAX_STRING_VALUE);
+	str_tmp = str;
+	dev_info(&hdev->pdev->dev, "devlink algo param is setting: %s\n", str);
+	do {
+		tmp[i++] = strsep(&str, "_");
+	} while (i < HCLGE_DEVLINK_MAX_ALGO_PARAM_NUM && tmp[i - 1] && str);
+
+	for (y = 1; y < i; y++) {
+		/* k has been checked in validate function */
+		k = hclge_devlink_find_item(items, size, tmp[y]);
+		ret = hclge_devlink_get_algo_param_value(tmp[y],
+							 &items[k].value);
+		if (ret)
+			break;
+
+		switch (items[k].size_type) {
+		case ALGO_SIZE_U8:
+			item_addr = param_addr + items[k].offset;
+			*item_addr = (u8)items[k].value;
+			break;
+		case ALGO_SIZE_U16:
+			item_addr = param_addr + items[k].offset;
+			*(u16 *)item_addr = (u16)items[k].value;
+			break;
+		case ALGO_SIZE_U32:
+			item_addr = param_addr + items[k].offset;
+			*(u32 *)item_addr = (u32)items[k].value;
+			break;
+		default:
+			break;
+		}
+	}
+
+	ret = hclge_devlink_set_algo_param(hdev, param_addr, type);
+
+	kfree(str_tmp);
+	return ret;
+}
+
+static int hclge_devlink_algo_param_set(struct devlink *devlink, u32 id,
+					struct devlink_param_gset_ctx *ctx)
+{
+	struct hclge_devlink_priv *priv = devlink_priv(devlink);
+	char tmp_a[HCLGE_DEVLINK_MAX_ALGO_TYPE_LEN] = {0};
+	char type[HCLGE_DEVLINK_MAX_ALGO_TYPE_LEN] = {0};
+	struct hclge_dev *hdev = priv->hdev;
+	char *value, *value_tmp, *tmp;
+	int cnt = 0;
+	int ret;
+
+	value = kmalloc(sizeof(char) * __DEVLINK_PARAM_MAX_STRING_VALUE,
+			GFP_KERNEL);
+	if (!value)
+		return -ENOMEM;
+
+	strncpy(value, ctx->val.vstr, __DEVLINK_PARAM_MAX_STRING_VALUE);
+	value_tmp = value;
+	tmp = strsep(&value, "_");
+	strncpy(tmp_a, tmp, strlen(tmp) + 1);
+	cnt = sscanf(tmp_a, "type@%s", type);
+
+	if (!strcmp(type, "dcqcn")) {
+		hdev->algo_param_type = HCLGE_ALGO_PARAM_DCQCN;
+	} else if (!strcmp(type, "ldcp")) {
+		hdev->algo_param_type = HCLGE_ALGO_PARAM_LDCP;
+	} else if (!strcmp(type, "hc3")) {
+		hdev->algo_param_type = HCLGE_ALGO_PARAM_HC3;
+	} else if (!strcmp(type, "dip")) {
+		hdev->algo_param_type = HCLGE_ALGO_PARAM_DIP;
+	} else {
+		dev_err(&hdev->pdev->dev, "unsupported algo type!\n");
+		kfree(value_tmp);
+		return -EINVAL;
+	}
+
+	ret = hclge_devlink_algo_param_set_value(hdev, hdev->algo_param_type,
+						 ctx);
+
+	kfree(value_tmp);
+	return ret;
+}
+
+static int hclge_devlink_is_algo_param_valid(char *str, u32 max)
+{
+	char *value, *value_tmp, *tmp;
+	int ret, i;
+	u64 tmp_u;
+
+	value = kmalloc(sizeof(char) * __DEVLINK_PARAM_MAX_STRING_VALUE,
+			GFP_KERNEL);
+	if (!value)
+		return -ENOMEM;
+
+	strncpy(value, str, __DEVLINK_PARAM_MAX_STRING_VALUE);
+	value_tmp = value;
+
+	tmp = strsep(&value, "@");
+
+	for (i = 0; i < strlen(value); i++) {
+		if (!(value[i] >= '0' && value[i] <= '9')) {
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	ret = kstrtou64(value, 0, &tmp_u);
+	if (ret)
+		goto out;
+
+	if (tmp_u > max)
+		ret = -EINVAL;
+
+out:
+	kfree(value_tmp);
+	return ret;
+}
+
+static int hclge_devlink_algo_param_check(struct hclge_dev *hdev,
+					  union devlink_param_value val,
+					  enum HCLGE_ALGO_PARAM_TYPE type)
+{
+	const struct algo_param_item *items = algo_items[type];
+	char *tmp[HCLGE_DEVLINK_MAX_ALGO_PARAM_NUM] = {0};
+	u32 size = algo_items_size[type];
+	char *str, *str_tmp;
+	int ret = 0;
+	int i = 0;
+	int y, k;
+
+	str = kmalloc(sizeof(char) * __DEVLINK_PARAM_MAX_STRING_VALUE,
+		      GFP_KERNEL);
+	if (!str)
+		return -ENOMEM;
+
+	strncpy(str, val.vstr, __DEVLINK_PARAM_MAX_STRING_VALUE);
+	str_tmp = str;
+
+	do {
+		tmp[i++] = strsep(&str, "_");
+	} while (i < HCLGE_DEVLINK_MAX_ALGO_PARAM_NUM && tmp[i - 1] && str);
+
+	for (y = 1; y < i; y++) {
+		k = hclge_devlink_find_item(items, size, tmp[y]);
+		if (k < 0) {
+			dev_err(&hdev->pdev->dev, "unsupported algo param!\n");
+			ret = k;
+			break;
+		}
+
+		ret = hclge_devlink_is_algo_param_valid(tmp[y], items[k].max);
+		if (ret) {
+			dev_err(&hdev->pdev->dev, "%s", items[k].error_log);
+			break;
+		}
+	}
+
+	kfree(str_tmp);
+	return ret;
+}
+
+static int
+hclge_devlink_algo_param_validate(struct devlink *devlink, u32 id,
+				  union devlink_param_value val,
+				  struct netlink_ext_ack *extack)
+{
+	struct hclge_devlink_priv *priv = devlink_priv(devlink);
+	char tmp_a[__DEVLINK_PARAM_MAX_STRING_VALUE] = {0};
+	char type[__DEVLINK_PARAM_MAX_STRING_VALUE] = {0};
+	struct hclge_dev *hdev = priv->hdev;
+	char *str, *str_tmp, *tmp;
+	int ret = 0;
+
+	str = kmalloc(sizeof(char) * __DEVLINK_PARAM_MAX_STRING_VALUE,
+		      GFP_KERNEL);
+	if (!str)
+		return -ENOMEM;
+
+	strncpy(str, val.vstr, __DEVLINK_PARAM_MAX_STRING_VALUE);
+	str_tmp = str;
+	tmp = strsep(&str, "_");
+	strncpy(tmp_a, tmp, strlen(tmp) + 1);
+	ret = sscanf(tmp_a, "type@%s", type);
+	if (ret < 0) {
+		NL_SET_ERR_MSG_MOD(extack, "invalid algo type!");
+		kfree(str_tmp);
+		return ret;
+	}
+
+	if (!strcmp(type, "dcqcn")) {
+		ret = hclge_devlink_algo_param_check(hdev, val, HCLGE_ALGO_PARAM_DCQCN);
+	} else if (!strcmp(type, "ldcp")) {
+		ret = hclge_devlink_algo_param_check(hdev, val, HCLGE_ALGO_PARAM_LDCP);
+	} else if (!strcmp(type, "hc3")) {
+		ret = hclge_devlink_algo_param_check(hdev, val, HCLGE_ALGO_PARAM_HC3);
+	} else if (!strcmp(type, "dip")) {
+		ret = hclge_devlink_algo_param_check(hdev, val, HCLGE_ALGO_PARAM_DIP);
+	} else {
+		ret = -EINVAL;
+		NL_SET_ERR_MSG_MOD(extack, "unsupported algo type!");
+	}
+
+	kfree(str_tmp);
+	return ret;
+}
+
 static const struct devlink_ops hclge_devlink_ops = {
 	.info_get = hclge_devlink_info_get,
 	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
@@ -104,11 +852,31 @@ static const struct devlink_ops hclge_devlink_ops = {
 	.reload_up = hclge_devlink_reload_up,
 };
 
+static const struct devlink_param hclge_devlink_params[] = {
+	DEVLINK_PARAM_DRIVER(HCLGE_DEVLINK_PARAM_ID_ALGO_PARAM,
+			     "algo_param", DEVLINK_PARAM_TYPE_STRING,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     hclge_devlink_algo_param_get,
+			     hclge_devlink_algo_param_set,
+			     hclge_devlink_algo_param_validate),
+};
+
+static void hclge_devlink_set_params_init_values(struct devlink *devlink)
+{
+	union devlink_param_value value;
+
+	strncpy(value.vstr, "type@dcqcn", strlen("type@dcqcn") + 1);
+	devlink_param_driverinit_value_set(devlink,
+					   HCLGE_DEVLINK_PARAM_ID_ALGO_PARAM,
+					   value);
+}
+
 int hclge_devlink_init(struct hclge_dev *hdev)
 {
 	struct pci_dev *pdev = hdev->pdev;
 	struct hclge_devlink_priv *priv;
 	struct devlink *devlink;
+	int ret = 0;
 
 	devlink = devlink_alloc(&hclge_devlink_ops,
 				sizeof(struct hclge_devlink_priv), &pdev->dev);
@@ -119,8 +887,23 @@ int hclge_devlink_init(struct hclge_dev *hdev)
 	priv->hdev = hdev;
 	hdev->devlink = devlink;
 
+	if (pdev->revision > HNAE3_DEVICE_VERSION_V2) {
+		ret = devlink_params_register(devlink, hclge_devlink_params,
+					      ARRAY_SIZE(hclge_devlink_params));
+		if (ret) {
+			dev_err(&pdev->dev,
+				"failed to register devlink params, ret = %d\n",
+				ret);
+			devlink_free(devlink);
+			return ret;
+		}
+
+		hclge_devlink_set_params_init_values(devlink);
+	}
+
 	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devlink_register(devlink);
+
 	return 0;
 }
 
@@ -130,5 +913,10 @@ void hclge_devlink_uninit(struct hclge_dev *hdev)
 
 	devlink_unregister(devlink);
 
+	if (hdev->pdev->revision > HNAE3_DEVICE_VERSION_V2) {
+		devlink_params_unregister(devlink, hclge_devlink_params,
+					  ARRAY_SIZE(hclge_devlink_params));
+	}
+
 	devlink_free(devlink);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h
index 918be04507a5..93616080504e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h
@@ -10,6 +10,12 @@ struct hclge_devlink_priv {
 	struct hclge_dev *hdev;
 };
 
+enum hclge_devlink_param_id {
+	HCLGE_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	HCLGE_DEVLINK_PARAM_ID_ALGO_PARAM,
+};
+
 int hclge_devlink_init(struct hclge_dev *hdev);
 void hclge_devlink_uninit(struct hclge_dev *hdev);
+void hclge_restore_algo_param(struct hclge_dev *hdev);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6962a9d69cf8..47045dcc947d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10244,6 +10244,7 @@ static void hclge_restore_hw_table(struct hclge_dev *hdev)
 	hclge_restore_vport_vlan_table(vport);
 	set_bit(HCLGE_STATE_FD_USER_DEF_CHANGED, &hdev->state);
 	hclge_restore_fd_entries(handle);
+	hclge_restore_algo_param(hdev);
 }
 
 int hclge_en_hw_strip_rxvtag(struct hnae3_handle *handle, bool enable)
@@ -11488,6 +11489,125 @@ static int hclge_clear_hw_resource(struct hclge_dev *hdev)
 	return 0;
 }
 
+static void hclge_query_dcqcn_param(struct hclge_dev *hdev)
+{
+	struct hclge_cfg_dcqcn_param *dcqcn_param;
+	struct hclge_dcqcn_param_cfg_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_ALGO_PARAM_DCQCN, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to query dcqcn param, ret = %d\n", ret);
+		return;
+	}
+
+	req = (struct hclge_dcqcn_param_cfg_cmd *)desc.data;
+	dcqcn_param = &hdev->algo_param.dcqcn_param;
+	dcqcn_param->ai = __le16_to_cpu(req->ai);
+	dcqcn_param->f = req->f;
+	dcqcn_param->tkp = req->tkp;
+	dcqcn_param->tmp = __le16_to_cpu(req->tmp);
+	dcqcn_param->alp = __le16_to_cpu(req->alp);
+	dcqcn_param->max_speed = __le32_to_cpu(req->max_speed);
+	dcqcn_param->g = req->g;
+	dcqcn_param->al = req->al;
+	dcqcn_param->cnp_time = req->cnp_time;
+	dcqcn_param->alp_shift = req->alp_shift;
+}
+
+static void hclge_query_ldcp_param(struct hclge_dev *hdev)
+{
+	struct hclge_cfg_ldcp_param *ldcp_param;
+	struct hclge_ldcp_param_cfg_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_ALGO_PARAM_LDCP, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to query ldcp param, ret = %d\n", ret);
+		return;
+	}
+
+	req = (struct hclge_ldcp_param_cfg_cmd *)desc.data;
+	ldcp_param = &hdev->algo_param.ldcp_param;
+	ldcp_param->cwd0 =  __le32_to_cpu(req->cwd0);
+	ldcp_param->la = req->la;
+	ldcp_param->ly = req->ly;
+	ldcp_param->lb = req->lb;
+	ldcp_param->lg = req->lg;
+}
+
+static void hclge_query_hc3_param(struct hclge_dev *hdev)
+{
+	struct hclge_cfg_hc3_param *hc3_param;
+	struct hclge_hc3_param_cfg_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_ALGO_PARAM_HC3, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to query hc3 param, ret = %d\n", ret);
+		return;
+	}
+
+	req = (struct hclge_hc3_param_cfg_cmd *)desc.data;
+	hc3_param = &hdev->algo_param.hc3_param;
+	hc3_param->win = __le32_to_cpu(req->win);
+	hc3_param->hcb = __le32_to_cpu(req->hcb);
+	hc3_param->maxqs = req->maxqs;
+	hc3_param->hcalp = req->hcalp;
+	hc3_param->hct = req->hct;
+	hc3_param->maxstg = req->maxstg;
+	hc3_param->gamshift = req->gamshift;
+}
+
+static void hclge_query_dip_param(struct hclge_dev *hdev)
+{
+	struct hclge_cfg_dip_param *dip_param;
+	struct hclge_dip_param_cfg_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_ALGO_PARAM_DIP, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to query dip param, ret = %d\n", ret);
+		return;
+	}
+
+	req = (struct hclge_dip_param_cfg_cmd *)desc.data;
+	dip_param = &hdev->algo_param.dip_param;
+	dip_param->ai = __le16_to_cpu(req->ai);
+	dip_param->f = req->f;
+	dip_param->tkp = req->tkp;
+	dip_param->tmp = __le16_to_cpu(req->tmp);
+	dip_param->alp = __le16_to_cpu(req->alp);
+	dip_param->max_speed = __le32_to_cpu(req->max_speed);
+	dip_param->g = req->g;
+	dip_param->al = req->al;
+	dip_param->cnp_time = req->cnp_time;
+	dip_param->alp_shift = req->alp_shift;
+}
+
+static void hclge_query_algo_param(struct hclge_dev *hdev)
+{
+	if (hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2)
+		return;
+
+	hclge_query_dcqcn_param(hdev);
+	hclge_query_ldcp_param(hdev);
+	hclge_query_hc3_param(hdev);
+	hclge_query_dip_param(hdev);
+}
+
 static void hclge_init_rxd_adv_layout(struct hclge_dev *hdev)
 {
 	if (hnae3_ae_dev_rxd_adv_layout_supported(hdev->ae_dev))
@@ -11690,6 +11810,8 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 	hclge_init_rxd_adv_layout(hdev);
 
+	hclge_query_algo_param(hdev);
+
 	/* Enable MISC vector(vector0) */
 	hclge_enable_vector(&hdev->misc_vector, true);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 495b639b0dc2..69f1b9a363fc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -811,6 +811,65 @@ struct hclge_vf_vlan_cfg {
 
 #pragma pack()
 
+struct hclge_cfg_dcqcn_param {
+	u16 ai;
+	u8 f;
+	u8 tkp;
+	u16 tmp;
+	u16 alp;
+	u32 max_speed;
+	u8 g;
+	u8 al;
+	u8 cnp_time;
+	u8 alp_shift;
+};
+
+struct hclge_cfg_ldcp_param {
+	u32 cwd0;
+	u8 la;
+	u8 ly;
+	u8 lb;
+	u8 lg;
+};
+
+struct hclge_cfg_hc3_param {
+	u32 win;
+	u32 hcb;
+	u8 maxqs;
+	u8 hcalp;
+	u8 hct;
+	u8 maxstg;
+	u8 gamshift;
+};
+
+struct hclge_cfg_dip_param {
+	u16 ai;
+	u8 f;
+	u8 tkp;
+	u16 tmp;
+	u16 alp;
+	u32 max_speed;
+	u8 g;
+	u8 al;
+	u8 cnp_time;
+	u8 alp_shift;
+};
+
+struct hclge_cfg_algo_param {
+	struct hclge_cfg_dcqcn_param dcqcn_param;
+	struct hclge_cfg_ldcp_param ldcp_param;
+	struct hclge_cfg_hc3_param hc3_param;
+	struct hclge_cfg_dip_param dip_param;
+};
+
+enum HCLGE_ALGO_PARAM_TYPE {
+	HCLGE_ALGO_PARAM_DCQCN,
+	HCLGE_ALGO_PARAM_LDCP,
+	HCLGE_ALGO_PARAM_HC3,
+	HCLGE_ALGO_PARAM_DIP,
+	HCLGE_ALGO_PARAM_UNSUPPORT
+};
+
 /* For each bit of TCAM entry, it uses a pair of 'x' and
  * 'y' to indicate which value to match, like below:
  * ----------------------------------
@@ -869,6 +928,8 @@ struct hclge_dev {
 	u16 vf_rss_size_max;		/* HW defined VF max RSS task queue */
 	u16 pf_rss_size_max;		/* HW defined PF max RSS task queue */
 	u32 tx_spare_buf_size;		/* HW defined TX spare buffer size */
+	struct hclge_cfg_algo_param algo_param;
+	enum HCLGE_ALGO_PARAM_TYPE algo_param_type;
 
 	u16 fdir_pf_filter_count; /* Num of guaranteed filters for this PF */
 	u16 num_alloc_vport;		/* Num vports this driver supports */
-- 
2.33.0

