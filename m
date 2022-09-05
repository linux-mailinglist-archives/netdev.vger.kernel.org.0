Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4AC75ACD98
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 10:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237243AbiIEISw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 04:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236505AbiIEISV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 04:18:21 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B2531DEE;
        Mon,  5 Sep 2022 01:18:17 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MLh9m0B7SzWfWm;
        Mon,  5 Sep 2022 16:13:48 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 5 Sep 2022 16:18:15 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 5 Sep 2022 16:18:12 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <lanhao@huawei.com>
Subject: [PATCH net-next 1/5] net: hns3: add support config dscp map to tc
Date:   Mon, 5 Sep 2022 16:15:35 +0800
Message-ID: <20220905081539.62131-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220905081539.62131-1-huangguangbin2@huawei.com>
References: <20220905081539.62131-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add support config dscp map to tc by implementing ieee_setapp
and ieee_delapp of struct dcbnl_rtnl_ops. Driver will convert mapping
relationship from dscp-prio to dscp-tc.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  10 ++
 .../net/ethernet/hisilicon/hns3/hns3_dcbnl.c  |  28 +++++
 .../hisilicon/hns3/hns3pf/hclge_dcb.c         | 107 ++++++++++++++++++
 .../hisilicon/hns3/hns3pf/hclge_dcb.h         |   3 +
 .../hisilicon/hns3/hns3pf/hclge_main.c        |   1 +
 .../hisilicon/hns3/hns3pf/hclge_main.h        |   4 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c |  50 +++++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.h |   5 +
 8 files changed, 207 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 795df7111119..33b5ac47f342 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -310,6 +310,11 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
+enum hnae3_tc_map_mode {
+	HNAE3_TC_MAP_MODE_PRIO,
+	HNAE3_TC_MAP_MODE_DSCP,
+};
+
 struct hnae3_vector_info {
 	u8 __iomem *io_addr;
 	int vector;
@@ -739,6 +744,8 @@ struct hnae3_ae_ops {
 	int (*get_link_diagnosis_info)(struct hnae3_handle *handle,
 				       u32 *status_code);
 	void (*clean_vf_config)(struct hnae3_ae_dev *ae_dev, int num_vfs);
+	int (*get_dscp_prio)(struct hnae3_handle *handle, u8 dscp,
+			     u8 *tc_map_mode, u8 *priority);
 };
 
 struct hnae3_dcb_ops {
@@ -747,6 +754,8 @@ struct hnae3_dcb_ops {
 	int (*ieee_setets)(struct hnae3_handle *, struct ieee_ets *);
 	int (*ieee_getpfc)(struct hnae3_handle *, struct ieee_pfc *);
 	int (*ieee_setpfc)(struct hnae3_handle *, struct ieee_pfc *);
+	int (*ieee_setapp)(struct hnae3_handle *h, struct dcb_app *app);
+	int (*ieee_delapp)(struct hnae3_handle *h, struct dcb_app *app);
 
 	/* DCBX configuration */
 	u8   (*getdcbx)(struct hnae3_handle *);
@@ -786,6 +795,7 @@ struct hnae3_knic_private_info {
 	u32 tx_spare_buf_size;
 
 	struct hnae3_tc_info tc_info;
+	u8 tc_map_mode;
 
 	u16 num_tqps;		  /* total number of TQPs in this handle */
 	struct hnae3_queue **tqp;  /* array base of all TQPs in this instance */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_dcbnl.c b/drivers/net/ethernet/hisilicon/hns3/hns3_dcbnl.c
index d2ec4c573bf8..3b6dbf158b98 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_dcbnl.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_dcbnl.c
@@ -56,6 +56,32 @@ static int hns3_dcbnl_ieee_setpfc(struct net_device *ndev, struct ieee_pfc *pfc)
 	return -EOPNOTSUPP;
 }
 
+static int hns3_dcbnl_ieee_setapp(struct net_device *ndev, struct dcb_app *app)
+{
+	struct hnae3_handle *h = hns3_get_handle(ndev);
+
+	if (hns3_nic_resetting(ndev))
+		return -EBUSY;
+
+	if (h->kinfo.dcb_ops->ieee_setapp)
+		return h->kinfo.dcb_ops->ieee_setapp(h, app);
+
+	return -EOPNOTSUPP;
+}
+
+static int hns3_dcbnl_ieee_delapp(struct net_device *ndev, struct dcb_app *app)
+{
+	struct hnae3_handle *h = hns3_get_handle(ndev);
+
+	if (hns3_nic_resetting(ndev))
+		return -EBUSY;
+
+	if (h->kinfo.dcb_ops->ieee_setapp)
+		return h->kinfo.dcb_ops->ieee_delapp(h, app);
+
+	return -EOPNOTSUPP;
+}
+
 /* DCBX configuration */
 static u8 hns3_dcbnl_getdcbx(struct net_device *ndev)
 {
@@ -83,6 +109,8 @@ static const struct dcbnl_rtnl_ops hns3_dcbnl_ops = {
 	.ieee_setets	= hns3_dcbnl_ieee_setets,
 	.ieee_getpfc	= hns3_dcbnl_ieee_getpfc,
 	.ieee_setpfc	= hns3_dcbnl_ieee_setpfc,
+	.ieee_setapp    = hns3_dcbnl_ieee_setapp,
+	.ieee_delapp    = hns3_dcbnl_ieee_delapp,
 	.getdcbx	= hns3_dcbnl_getdcbx,
 	.setdcbx	= hns3_dcbnl_setdcbx,
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 69b8673436ca..7fcacc76e749 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -359,6 +359,111 @@ static int hclge_ieee_setpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 	return hclge_notify_client(hdev, HNAE3_UP_CLIENT);
 }
 
+static int hclge_ieee_setapp(struct hnae3_handle *h, struct dcb_app *app)
+{
+	struct hclge_vport *vport = hclge_get_vport(h);
+	struct net_device *netdev = h->kinfo.netdev;
+	struct hclge_dev *hdev = vport->back;
+	struct dcb_app old_app;
+	int ret;
+
+	if (app->selector != IEEE_8021QAZ_APP_SEL_DSCP ||
+	    app->protocol >= HCLGE_MAX_DSCP ||
+	    app->priority >= HNAE3_MAX_USER_PRIO)
+		return -EINVAL;
+
+	dev_info(&hdev->pdev->dev, "setapp dscp=%u priority=%u\n",
+		 app->protocol, app->priority);
+
+	if (app->priority == hdev->tm_info.dscp_prio[app->protocol])
+		return 0;
+
+	ret = dcb_ieee_setapp(netdev, app);
+	if (ret)
+		return ret;
+
+	old_app.selector = IEEE_8021QAZ_APP_SEL_DSCP;
+	old_app.protocol = app->protocol;
+	old_app.priority = hdev->tm_info.dscp_prio[app->protocol];
+
+	hdev->tm_info.dscp_prio[app->protocol] = app->priority;
+	ret = hclge_dscp_to_tc_map(hdev);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to set dscp to tc map, ret = %d\n", ret);
+		hdev->tm_info.dscp_prio[app->protocol] = old_app.priority;
+		(void)dcb_ieee_delapp(netdev, app);
+		return ret;
+	}
+
+	vport->nic.kinfo.tc_map_mode = HNAE3_TC_MAP_MODE_DSCP;
+	if (old_app.priority == HCLGE_PRIO_ID_INVALID)
+		hdev->tm_info.dscp_app_cnt++;
+	else
+		ret = dcb_ieee_delapp(netdev, &old_app);
+
+	return ret;
+}
+
+static int hclge_ieee_delapp(struct hnae3_handle *h, struct dcb_app *app)
+{
+	struct hclge_vport *vport = hclge_get_vport(h);
+	struct net_device *netdev = h->kinfo.netdev;
+	struct hclge_dev *hdev = vport->back;
+	int ret;
+
+	if (app->selector != IEEE_8021QAZ_APP_SEL_DSCP ||
+	    app->protocol >= HCLGE_MAX_DSCP ||
+	    app->priority >= HNAE3_MAX_USER_PRIO ||
+	    app->priority != hdev->tm_info.dscp_prio[app->protocol])
+		return -EINVAL;
+
+	dev_info(&hdev->pdev->dev, "delapp dscp=%u priority=%u\n",
+		 app->protocol, app->priority);
+
+	ret = dcb_ieee_delapp(netdev, app);
+	if (ret)
+		return ret;
+
+	hdev->tm_info.dscp_prio[app->protocol] = HCLGE_PRIO_ID_INVALID;
+	ret = hclge_dscp_to_tc_map(hdev);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to del dscp to tc map, ret = %d\n", ret);
+		hdev->tm_info.dscp_prio[app->protocol] = app->priority;
+		(void)dcb_ieee_setapp(netdev, app);
+		return ret;
+	}
+
+	if (hdev->tm_info.dscp_app_cnt)
+		hdev->tm_info.dscp_app_cnt--;
+
+	if (!hdev->tm_info.dscp_app_cnt) {
+		vport->nic.kinfo.tc_map_mode = HNAE3_TC_MAP_MODE_PRIO;
+		ret = hclge_up_to_tc_map(hdev);
+	}
+
+	return ret;
+}
+
+int hclge_get_dscp_prio(struct hnae3_handle *h, u8 dscp, u8 *tc_mode,
+			u8 *priority)
+{
+	struct hclge_vport *vport = hclge_get_vport(h);
+	struct hclge_dev *hdev = vport->back;
+
+	if (dscp >= HCLGE_MAX_DSCP)
+		return -EINVAL;
+
+	if (tc_mode)
+		*tc_mode = vport->nic.kinfo.tc_map_mode;
+	if (priority)
+		*priority = hdev->tm_info.dscp_prio[dscp] == HCLGE_PRIO_ID_INVALID ? 0 :
+			    hdev->tm_info.dscp_prio[dscp];
+
+	return 0;
+}
+
 /* DCBX configuration */
 static u8 hclge_getdcbx(struct hnae3_handle *h)
 {
@@ -543,6 +648,8 @@ static const struct hnae3_dcb_ops hns3_dcb_ops = {
 	.ieee_setets	= hclge_ieee_setets,
 	.ieee_getpfc	= hclge_ieee_getpfc,
 	.ieee_setpfc	= hclge_ieee_setpfc,
+	.ieee_setapp    = hclge_ieee_setapp,
+	.ieee_delapp    = hclge_ieee_delapp,
 	.getdcbx	= hclge_getdcbx,
 	.setdcbx	= hclge_setdcbx,
 	.setup_tc	= hclge_setup_tc,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.h
index b04702e65689..17a5460e7ea9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.h
@@ -12,4 +12,7 @@ void hclge_dcb_ops_set(struct hclge_dev *hdev);
 static inline void hclge_dcb_ops_set(struct hclge_dev *hdev) {}
 #endif
 
+int hclge_get_dscp_prio(struct hnae3_handle *h, u8 dscp, u8 *tc_mode,
+			u8 *priority);
+
 #endif /* __HCLGE_DCB_H__ */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index fcdc978379ff..f43c7d392d1a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -12907,6 +12907,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.get_ts_info = hclge_ptp_get_ts_info,
 	.get_link_diagnosis_info = hclge_get_link_diagnosis_info,
 	.clean_vf_config = hclge_clean_vport_config,
+	.get_dscp_prio = hclge_get_dscp_prio,
 };
 
 static struct hnae3_ae_algo ae_algo = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 18caddd541f8..8498cd8d36f9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -349,11 +349,15 @@ struct hclge_cfg {
 	u16 umv_space;
 };
 
+#define HCLGE_MAX_DSCP			64
+#define HCLGE_PRIO_ID_INVALID		0xff
 struct hclge_tm_info {
 	u8 num_tc;
 	u8 num_pg;      /* It must be 1 if vNET-Base schd */
+	u8 dscp_app_cnt;
 	u8 pg_dwrr[HCLGE_PG_NUM];
 	u8 prio_tc[HNAE3_MAX_USER_PRIO];
+	u8 dscp_prio[HCLGE_MAX_DSCP];
 	struct hclge_pg_info pg_info[HCLGE_PG_NUM];
 	struct hclge_tc_info tc_info[HNAE3_MAX_TC];
 	enum hclge_fc_mode fc_mode;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 2f33b036a47a..7630d1f01e04 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -248,7 +248,7 @@ static int hclge_fill_pri_array(struct hclge_dev *hdev, u8 *pri, u8 pri_id)
 	return 0;
 }
 
-static int hclge_up_to_tc_map(struct hclge_dev *hdev)
+int hclge_up_to_tc_map(struct hclge_dev *hdev)
 {
 	struct hclge_desc desc;
 	u8 *pri = (u8 *)desc.data;
@@ -266,6 +266,47 @@ static int hclge_up_to_tc_map(struct hclge_dev *hdev)
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
 
+static void hclge_dscp_to_prio_map_init(struct hclge_dev *hdev)
+{
+	u8 i;
+
+	hdev->vport[0].nic.kinfo.tc_map_mode = HNAE3_TC_MAP_MODE_PRIO;
+	hdev->tm_info.dscp_app_cnt = 0;
+	for (i = 0; i < HCLGE_MAX_DSCP; i++)
+		hdev->tm_info.dscp_prio[i] = HCLGE_PRIO_ID_INVALID;
+}
+
+int hclge_dscp_to_tc_map(struct hclge_dev *hdev)
+{
+	struct hclge_desc desc[HCLGE_DSCP_MAP_TC_BD_NUM];
+	u8 *req0 = (u8 *)desc[0].data;
+	u8 *req1 = (u8 *)desc[1].data;
+	u8 pri_id, tc_id, i, j;
+
+	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_QOS_MAP, false);
+	desc[0].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
+	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_OPC_QOS_MAP, false);
+
+	/* The low 32 dscp setting use bd0, high 32 dscp setting use bd1 */
+	for (i = 0; i < HCLGE_MAX_DSCP / HCLGE_DSCP_MAP_TC_BD_NUM; i++) {
+		pri_id = hdev->tm_info.dscp_prio[i];
+		pri_id = pri_id == HCLGE_PRIO_ID_INVALID ? 0 : pri_id;
+		tc_id = hdev->tm_info.prio_tc[pri_id];
+		/* Each dscp setting has 4 bits, so each byte saves two dscp
+		 * setting
+		 */
+		req0[i >> 1] |= tc_id << HCLGE_DSCP_TC_SHIFT(i);
+
+		j = i + HCLGE_MAX_DSCP / HCLGE_DSCP_MAP_TC_BD_NUM;
+		pri_id = hdev->tm_info.dscp_prio[j];
+		pri_id = pri_id == HCLGE_PRIO_ID_INVALID ? 0 : pri_id;
+		tc_id = hdev->tm_info.prio_tc[pri_id];
+		req1[i >> 1] |= tc_id << HCLGE_DSCP_TC_SHIFT(i);
+	}
+
+	return hclge_cmd_send(&hdev->hw, desc, HCLGE_DSCP_MAP_TC_BD_NUM);
+}
+
 static int hclge_tm_pg_to_pri_map_cfg(struct hclge_dev *hdev,
 				      u8 pg_id, u8 pri_bit_map)
 {
@@ -1275,6 +1316,12 @@ static int hclge_tm_map_cfg(struct hclge_dev *hdev)
 	if (ret)
 		return ret;
 
+	if (hdev->vport[0].nic.kinfo.tc_map_mode == HNAE3_TC_MAP_MODE_DSCP) {
+		ret = hclge_dscp_to_tc_map(hdev);
+		if (ret)
+			return ret;
+	}
+
 	ret = hclge_tm_pg_to_pri_map(hdev);
 	if (ret)
 		return ret;
@@ -1646,6 +1693,7 @@ int hclge_tm_schd_init(struct hclge_dev *hdev)
 		return -EINVAL;
 
 	hclge_tm_schd_info_init(hdev);
+	hclge_dscp_to_prio_map_init(hdev);
 
 	return hclge_tm_init_hw(hdev, true);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index d943943912f7..68f28a98e380 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -30,6 +30,9 @@ enum hclge_opcode_type;
 #define HCLGE_TM_PF_MAX_PRI_NUM		8
 #define HCLGE_TM_PF_MAX_QSET_NUM	8
 
+#define HCLGE_DSCP_MAP_TC_BD_NUM	2
+#define HCLGE_DSCP_TC_SHIFT(n)		(((n) & 1) * 4)
+
 struct hclge_pg_to_pri_link_cmd {
 	u8 pg_id;
 	u8 rsvd1[3];
@@ -262,4 +265,6 @@ int hclge_tm_get_pg_shaper(struct hclge_dev *hdev, u8 pg_id,
 			   struct hclge_tm_shaper_para *para);
 int hclge_tm_get_port_shaper(struct hclge_dev *hdev,
 			     struct hclge_tm_shaper_para *para);
+int hclge_up_to_tc_map(struct hclge_dev *hdev);
+int hclge_dscp_to_tc_map(struct hclge_dev *hdev);
 #endif
-- 
2.33.0

