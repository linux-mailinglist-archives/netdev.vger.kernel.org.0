Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41EF5BA4B9
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 04:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiIPCk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 22:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiIPCkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 22:40:51 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8F197B3C;
        Thu, 15 Sep 2022 19:40:47 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MTJCG2ywlznVFR;
        Fri, 16 Sep 2022 10:38:02 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 16 Sep 2022 10:40:45 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 16 Sep 2022 10:40:44 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <lanhao@huawei.com>, <shenjian15@huawei.com>
Subject: [PATCH net-next 2/4] net: hns3: optimize converting dscp to priority process of hns3_nic_select_queue()
Date:   Fri, 16 Sep 2022 10:38:01 +0800
Message-ID: <20220916023803.23756-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220916023803.23756-1-huangguangbin2@huawei.com>
References: <20220916023803.23756-1-huangguangbin2@huawei.com>
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

Currently, when function hns3_nic_select_queue() converts dscp to priority,
it calls an indirect callback ae_algo->ops->get_dscp_prio to get priority.

However as function hns3_nic_select_queue() is in fast path, the indirect
call may cause degradation of performance. For optimization, this patch
moves dscp_app_cnt and dscp_prio from struct hclge_tm_info to struct
hnae3_knic_private_info, so they can be used in both hclge and hns3 layers.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  4 +++
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 13 ++++-----
 .../hisilicon/hns3/hns3pf/hclge_dcb.c         | 28 +++++++++----------
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     | 17 +++++------
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 11 +++-----
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  4 ---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 18 ++++++------
 7 files changed, 45 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 30a76f44a819..0179fc288f5f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -798,6 +798,8 @@ struct hnae3_tc_info {
 	bool mqprio_active;
 };
 
+#define HNAE3_MAX_DSCP			64
+#define HNAE3_PRIO_ID_INVALID		0xff
 struct hnae3_knic_private_info {
 	struct net_device *netdev; /* Set by KNIC client when init instance */
 	u16 rss_size;		   /* Allocated RSS queues */
@@ -809,6 +811,8 @@ struct hnae3_knic_private_info {
 
 	struct hnae3_tc_info tc_info;
 	u8 tc_map_mode;
+	u8 dscp_app_cnt;
+	u8 dscp_prio[HNAE3_MAX_DSCP];
 
 	u16 num_tqps;		  /* total number of TQPs in this handle */
 	struct hnae3_queue **tqp;  /* array base of all TQPs in this instance */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index db099549e511..39b75b68474c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2987,22 +2987,19 @@ static u16 hns3_nic_select_queue(struct net_device *netdev,
 				 struct net_device *sb_dev)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
-	u8 dscp, priority;
-	int ret;
+	u8 dscp;
 
 	if (h->kinfo.tc_map_mode != HNAE3_TC_MAP_MODE_DSCP ||
 	    !h->ae_algo->ops->get_dscp_prio)
 		goto out;
 
 	dscp = hns3_get_skb_dscp(skb);
-	if (unlikely(dscp == HNS3_INVALID_DSCP))
-		goto out;
-
-	ret = h->ae_algo->ops->get_dscp_prio(h, dscp, NULL, &priority);
-	if (ret)
+	if (unlikely(dscp >= HNAE3_MAX_DSCP))
 		goto out;
 
-	skb->priority = priority;
+	skb->priority = h->kinfo.dscp_prio[dscp];
+	if (skb->priority == HNAE3_PRIO_ID_INVALID)
+		skb->priority = 0;
 
 out:
 	return netdev_pick_tx(netdev, skb, sb_dev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index fbb159f48b6c..c4aded65e848 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -368,14 +368,14 @@ static int hclge_ieee_setapp(struct hnae3_handle *h, struct dcb_app *app)
 	int ret;
 
 	if (app->selector != IEEE_8021QAZ_APP_SEL_DSCP ||
-	    app->protocol >= HCLGE_MAX_DSCP ||
+	    app->protocol >= HNAE3_MAX_DSCP ||
 	    app->priority >= HNAE3_MAX_USER_PRIO)
 		return -EINVAL;
 
 	dev_info(&hdev->pdev->dev, "setapp dscp=%u priority=%u\n",
 		 app->protocol, app->priority);
 
-	if (app->priority == hdev->tm_info.dscp_prio[app->protocol])
+	if (app->priority == h->kinfo.dscp_prio[app->protocol])
 		return 0;
 
 	ret = dcb_ieee_setapp(netdev, app);
@@ -384,21 +384,21 @@ static int hclge_ieee_setapp(struct hnae3_handle *h, struct dcb_app *app)
 
 	old_app.selector = IEEE_8021QAZ_APP_SEL_DSCP;
 	old_app.protocol = app->protocol;
-	old_app.priority = hdev->tm_info.dscp_prio[app->protocol];
+	old_app.priority = h->kinfo.dscp_prio[app->protocol];
 
-	hdev->tm_info.dscp_prio[app->protocol] = app->priority;
+	h->kinfo.dscp_prio[app->protocol] = app->priority;
 	ret = hclge_dscp_to_tc_map(hdev);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"failed to set dscp to tc map, ret = %d\n", ret);
-		hdev->tm_info.dscp_prio[app->protocol] = old_app.priority;
+		h->kinfo.dscp_prio[app->protocol] = old_app.priority;
 		(void)dcb_ieee_delapp(netdev, app);
 		return ret;
 	}
 
 	vport->nic.kinfo.tc_map_mode = HNAE3_TC_MAP_MODE_DSCP;
-	if (old_app.priority == HCLGE_PRIO_ID_INVALID)
-		hdev->tm_info.dscp_app_cnt++;
+	if (old_app.priority == HNAE3_PRIO_ID_INVALID)
+		h->kinfo.dscp_app_cnt++;
 	else
 		ret = dcb_ieee_delapp(netdev, &old_app);
 
@@ -413,9 +413,9 @@ static int hclge_ieee_delapp(struct hnae3_handle *h, struct dcb_app *app)
 	int ret;
 
 	if (app->selector != IEEE_8021QAZ_APP_SEL_DSCP ||
-	    app->protocol >= HCLGE_MAX_DSCP ||
+	    app->protocol >= HNAE3_MAX_DSCP ||
 	    app->priority >= HNAE3_MAX_USER_PRIO ||
-	    app->priority != hdev->tm_info.dscp_prio[app->protocol])
+	    app->priority != h->kinfo.dscp_prio[app->protocol])
 		return -EINVAL;
 
 	dev_info(&hdev->pdev->dev, "delapp dscp=%u priority=%u\n",
@@ -425,20 +425,20 @@ static int hclge_ieee_delapp(struct hnae3_handle *h, struct dcb_app *app)
 	if (ret)
 		return ret;
 
-	hdev->tm_info.dscp_prio[app->protocol] = HCLGE_PRIO_ID_INVALID;
+	h->kinfo.dscp_prio[app->protocol] = HNAE3_PRIO_ID_INVALID;
 	ret = hclge_dscp_to_tc_map(hdev);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"failed to del dscp to tc map, ret = %d\n", ret);
-		hdev->tm_info.dscp_prio[app->protocol] = app->priority;
+		h->kinfo.dscp_prio[app->protocol] = app->priority;
 		(void)dcb_ieee_setapp(netdev, app);
 		return ret;
 	}
 
-	if (hdev->tm_info.dscp_app_cnt)
-		hdev->tm_info.dscp_app_cnt--;
+	if (h->kinfo.dscp_app_cnt)
+		h->kinfo.dscp_app_cnt--;
 
-	if (!hdev->tm_info.dscp_app_cnt) {
+	if (!h->kinfo.dscp_app_cnt) {
 		vport->nic.kinfo.tc_map_mode = HNAE3_TC_MAP_MODE_PRIO;
 		ret = hclge_up_to_tc_map(hdev);
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 55f696d071e5..142415c84c6b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1158,17 +1158,18 @@ static int hclge_dbg_dump_qos_pri_map(struct hclge_dev *hdev, char *buf,
 static int hclge_dbg_dump_qos_dscp_map(struct hclge_dev *hdev, char *buf,
 				       int len)
 {
+	struct hnae3_knic_private_info *kinfo = &hdev->vport[0].nic.kinfo;
 	struct hclge_desc desc[HCLGE_DSCP_MAP_TC_BD_NUM];
 	u8 *req0 = (u8 *)desc[0].data;
 	u8 *req1 = (u8 *)desc[1].data;
-	u8 dscp_tc[HCLGE_MAX_DSCP];
+	u8 dscp_tc[HNAE3_MAX_DSCP];
 	int pos, ret;
 	u8 i, j;
 
 	pos = scnprintf(buf, len, "tc map mode: %s\n",
-			tc_map_mode_str[hdev->vport[0].nic.kinfo.tc_map_mode]);
+			tc_map_mode_str[kinfo->tc_map_mode]);
 
-	if (hdev->vport[0].nic.kinfo.tc_map_mode != HNAE3_TC_MAP_MODE_DSCP)
+	if (kinfo->tc_map_mode != HNAE3_TC_MAP_MODE_DSCP)
 		return 0;
 
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_QOS_MAP, true);
@@ -1184,8 +1185,8 @@ static int hclge_dbg_dump_qos_dscp_map(struct hclge_dev *hdev, char *buf,
 	pos += scnprintf(buf + pos, len - pos, "\nDSCP  PRIO  TC\n");
 
 	/* The low 32 dscp setting use bd0, high 32 dscp setting use bd1 */
-	for (i = 0; i < HCLGE_MAX_DSCP / HCLGE_DSCP_MAP_TC_BD_NUM; i++) {
-		j = i + HCLGE_MAX_DSCP / HCLGE_DSCP_MAP_TC_BD_NUM;
+	for (i = 0; i < HNAE3_MAX_DSCP / HCLGE_DSCP_MAP_TC_BD_NUM; i++) {
+		j = i + HNAE3_MAX_DSCP / HCLGE_DSCP_MAP_TC_BD_NUM;
 		/* Each dscp setting has 4 bits, so each byte saves two dscp
 		 * setting
 		 */
@@ -1195,12 +1196,12 @@ static int hclge_dbg_dump_qos_dscp_map(struct hclge_dev *hdev, char *buf,
 		dscp_tc[j] &= HCLGE_DBG_TC_MASK;
 	}
 
-	for (i = 0; i < HCLGE_MAX_DSCP; i++) {
-		if (hdev->tm_info.dscp_prio[i] == HCLGE_PRIO_ID_INVALID)
+	for (i = 0; i < HNAE3_MAX_DSCP; i++) {
+		if (kinfo->dscp_prio[i] == HNAE3_PRIO_ID_INVALID)
 			continue;
 
 		pos += scnprintf(buf + pos, len - pos, " %2u    %u    %u\n",
-				 i, hdev->tm_info.dscp_prio[i], dscp_tc[i]);
+				 i, kinfo->dscp_prio[i], dscp_tc[i]);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d7278d9a4939..66436801fb8e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -12981,17 +12981,14 @@ static void hclge_clean_vport_config(struct hnae3_ae_dev *ae_dev, int num_vfs)
 static int hclge_get_dscp_prio(struct hnae3_handle *h, u8 dscp, u8 *tc_mode,
 			       u8 *priority)
 {
-	struct hclge_vport *vport = hclge_get_vport(h);
-	struct hclge_dev *hdev = vport->back;
-
-	if (dscp >= HCLGE_MAX_DSCP)
+	if (dscp >= HNAE3_MAX_DSCP)
 		return -EINVAL;
 
 	if (tc_mode)
-		*tc_mode = vport->nic.kinfo.tc_map_mode;
+		*tc_mode = h->kinfo.tc_map_mode;
 	if (priority)
-		*priority = hdev->tm_info.dscp_prio[dscp] == HCLGE_PRIO_ID_INVALID ? 0 :
-			    hdev->tm_info.dscp_prio[dscp];
+		*priority = h->kinfo.dscp_prio[dscp] == HNAE3_PRIO_ID_INVALID ? 0 :
+			    h->kinfo.dscp_prio[dscp];
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 163240adbcce..495b639b0dc2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -351,15 +351,11 @@ struct hclge_cfg {
 	u16 umv_space;
 };
 
-#define HCLGE_MAX_DSCP			64
-#define HCLGE_PRIO_ID_INVALID		0xff
 struct hclge_tm_info {
 	u8 num_tc;
 	u8 num_pg;      /* It must be 1 if vNET-Base schd */
-	u8 dscp_app_cnt;
 	u8 pg_dwrr[HCLGE_PG_NUM];
 	u8 prio_tc[HNAE3_MAX_USER_PRIO];
-	u8 dscp_prio[HCLGE_MAX_DSCP];
 	struct hclge_pg_info pg_info[HCLGE_PG_NUM];
 	struct hclge_tc_info tc_info[HNAE3_MAX_TC];
 	enum hclge_fc_mode fc_mode;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 7630d1f01e04..4a33f65190e2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -271,9 +271,9 @@ static void hclge_dscp_to_prio_map_init(struct hclge_dev *hdev)
 	u8 i;
 
 	hdev->vport[0].nic.kinfo.tc_map_mode = HNAE3_TC_MAP_MODE_PRIO;
-	hdev->tm_info.dscp_app_cnt = 0;
-	for (i = 0; i < HCLGE_MAX_DSCP; i++)
-		hdev->tm_info.dscp_prio[i] = HCLGE_PRIO_ID_INVALID;
+	hdev->vport[0].nic.kinfo.dscp_app_cnt = 0;
+	for (i = 0; i < HNAE3_MAX_DSCP; i++)
+		hdev->vport[0].nic.kinfo.dscp_prio[i] = HNAE3_PRIO_ID_INVALID;
 }
 
 int hclge_dscp_to_tc_map(struct hclge_dev *hdev)
@@ -288,18 +288,18 @@ int hclge_dscp_to_tc_map(struct hclge_dev *hdev)
 	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_OPC_QOS_MAP, false);
 
 	/* The low 32 dscp setting use bd0, high 32 dscp setting use bd1 */
-	for (i = 0; i < HCLGE_MAX_DSCP / HCLGE_DSCP_MAP_TC_BD_NUM; i++) {
-		pri_id = hdev->tm_info.dscp_prio[i];
-		pri_id = pri_id == HCLGE_PRIO_ID_INVALID ? 0 : pri_id;
+	for (i = 0; i < HNAE3_MAX_DSCP / HCLGE_DSCP_MAP_TC_BD_NUM; i++) {
+		pri_id = hdev->vport[0].nic.kinfo.dscp_prio[i];
+		pri_id = pri_id == HNAE3_PRIO_ID_INVALID ? 0 : pri_id;
 		tc_id = hdev->tm_info.prio_tc[pri_id];
 		/* Each dscp setting has 4 bits, so each byte saves two dscp
 		 * setting
 		 */
 		req0[i >> 1] |= tc_id << HCLGE_DSCP_TC_SHIFT(i);
 
-		j = i + HCLGE_MAX_DSCP / HCLGE_DSCP_MAP_TC_BD_NUM;
-		pri_id = hdev->tm_info.dscp_prio[j];
-		pri_id = pri_id == HCLGE_PRIO_ID_INVALID ? 0 : pri_id;
+		j = i + HNAE3_MAX_DSCP / HCLGE_DSCP_MAP_TC_BD_NUM;
+		pri_id = hdev->vport[0].nic.kinfo.dscp_prio[j];
+		pri_id = pri_id == HNAE3_PRIO_ID_INVALID ? 0 : pri_id;
 		tc_id = hdev->tm_info.prio_tc[pri_id];
 		req1[i >> 1] |= tc_id << HCLGE_DSCP_TC_SHIFT(i);
 	}
-- 
2.33.0

