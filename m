Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33A9911EFE1
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 03:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfLNCG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 21:06:58 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7237 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726422AbfLNCGm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 21:06:42 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id ED5DD12AA0164EA4F897;
        Sat, 14 Dec 2019 10:06:38 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Sat, 14 Dec 2019 10:06:30 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/5] net: hns3: remove mailbox and reset work in hclge_main
Date:   Sat, 14 Dec 2019 10:06:38 +0800
Message-ID: <1576289201-57017-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576289201-57017-1-git-send-email-tanhuazhong@huawei.com>
References: <1576289201-57017-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

There are three work (mbx_service_task, service_task,
rst_service_task) in the HNS3 driver, mbx_service_task is for
handling mailbox work, service_task is for periodic management
issue and rst_service_task is for reset related issue, which can
be handled in a single work.

This patch removes the mbx_service_task and rst_service_task
work, and moves the related handling to the service_task work
in order to remove concurrency between the three work and to
improve efficiency.

BTW, since stats_timer in struct hclge_hw_stats is not needed
anymore, so removes the definition of struct hclge_hw_stats,
and moves mac_stats into struct hclge_dev.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  10 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 163 +++++++++++++--------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  17 +--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   1 -
 4 files changed, 118 insertions(+), 73 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 112df34..92a99e4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -976,6 +976,14 @@ void hclge_dbg_dump_rst_info(struct hclge_dev *hdev)
 	dev_info(&hdev->pdev->dev, "hdev state: 0x%lx\n", hdev->state);
 }
 
+static void hclge_dbg_dump_serv_info(struct hclge_dev *hdev)
+{
+	dev_info(&hdev->pdev->dev, "last_serv_processed: %lu\n",
+		 hdev->last_serv_processed);
+	dev_info(&hdev->pdev->dev, "last_serv_cnt: %lu\n",
+		 hdev->serv_processed_cnt);
+}
+
 static void hclge_dbg_get_m7_stats_info(struct hclge_dev *hdev)
 {
 	struct hclge_desc *desc_src, *desc_tmp;
@@ -1227,6 +1235,8 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 		hclge_dbg_dump_reg_cmd(hdev, &cmd_buf[sizeof(DUMP_REG)]);
 	} else if (strncmp(cmd_buf, "dump reset info", 15) == 0) {
 		hclge_dbg_dump_rst_info(hdev);
+	} else if (strncmp(cmd_buf, "dump serv info", 14) == 0) {
+		hclge_dbg_dump_serv_info(hdev);
 	} else if (strncmp(cmd_buf, "dump m7 info", 12) == 0) {
 		hclge_dbg_get_m7_stats_info(hdev);
 	} else if (strncmp(cmd_buf, "dump ncl_config", 15) == 0) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d862e9b..a0177e3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -416,7 +416,7 @@ static int hclge_mac_update_stats_defective(struct hclge_dev *hdev)
 {
 #define HCLGE_MAC_CMD_NUM 21
 
-	u64 *data = (u64 *)(&hdev->hw_stats.mac_stats);
+	u64 *data = (u64 *)(&hdev->mac_stats);
 	struct hclge_desc desc[HCLGE_MAC_CMD_NUM];
 	__le64 *desc_data;
 	int i, k, n;
@@ -453,7 +453,7 @@ static int hclge_mac_update_stats_defective(struct hclge_dev *hdev)
 
 static int hclge_mac_update_stats_complete(struct hclge_dev *hdev, u32 desc_num)
 {
-	u64 *data = (u64 *)(&hdev->hw_stats.mac_stats);
+	u64 *data = (u64 *)(&hdev->mac_stats);
 	struct hclge_desc *desc;
 	__le64 *desc_data;
 	u16 i, k, n;
@@ -802,7 +802,7 @@ static void hclge_get_stats(struct hnae3_handle *handle, u64 *data)
 	struct hclge_dev *hdev = vport->back;
 	u64 *p;
 
-	p = hclge_comm_get_stats(&hdev->hw_stats.mac_stats, g_mac_stats_string,
+	p = hclge_comm_get_stats(&hdev->mac_stats, g_mac_stats_string,
 				 ARRAY_SIZE(g_mac_stats_string), data);
 	p = hclge_tqps_get_stats(handle, p);
 }
@@ -815,8 +815,8 @@ static void hclge_get_mac_stat(struct hnae3_handle *handle,
 
 	hclge_update_stats(handle, NULL);
 
-	mac_stats->tx_pause_cnt = hdev->hw_stats.mac_stats.mac_tx_mac_pause_num;
-	mac_stats->rx_pause_cnt = hdev->hw_stats.mac_stats.mac_rx_mac_pause_num;
+	mac_stats->tx_pause_cnt = hdev->mac_stats.mac_tx_mac_pause_num;
+	mac_stats->rx_pause_cnt = hdev->mac_stats.mac_rx_mac_pause_num;
 }
 
 static int hclge_parse_func_status(struct hclge_dev *hdev,
@@ -2665,31 +2665,26 @@ static int hclge_mac_init(struct hclge_dev *hdev)
 
 static void hclge_mbx_task_schedule(struct hclge_dev *hdev)
 {
-	if (!test_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state) &&
+	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
 	    !test_and_set_bit(HCLGE_STATE_MBX_SERVICE_SCHED, &hdev->state))
-		queue_work_on(cpumask_first(&hdev->affinity_mask), system_wq,
-			      &hdev->mbx_service_task);
+		mod_delayed_work_on(cpumask_first(&hdev->affinity_mask),
+				    system_wq, &hdev->service_task, 0);
 }
 
 static void hclge_reset_task_schedule(struct hclge_dev *hdev)
 {
 	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
 	    !test_and_set_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state))
-		queue_work_on(cpumask_first(&hdev->affinity_mask), system_wq,
-			      &hdev->rst_service_task);
+		mod_delayed_work_on(cpumask_first(&hdev->affinity_mask),
+				    system_wq, &hdev->service_task, 0);
 }
 
 void hclge_task_schedule(struct hclge_dev *hdev, unsigned long delay_time)
 {
-	if (!test_bit(HCLGE_STATE_DOWN, &hdev->state) &&
-	    !test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
-	    !test_and_set_bit(HCLGE_STATE_SERVICE_SCHED, &hdev->state)) {
-		hdev->hw_stats.stats_timer++;
-		hdev->fd_arfs_expire_timer++;
+	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state))
 		mod_delayed_work_on(cpumask_first(&hdev->affinity_mask),
 				    system_wq, &hdev->service_task,
 				    delay_time);
-	}
 }
 
 static int hclge_get_mac_link_status(struct hclge_dev *hdev)
@@ -2748,6 +2743,10 @@ static void hclge_update_link_status(struct hclge_dev *hdev)
 
 	if (!client)
 		return;
+
+	if (test_and_set_bit(HCLGE_STATE_LINK_UPDATING, &hdev->state))
+		return;
+
 	state = hclge_get_mac_phy_link(hdev);
 	if (state != hdev->hw.mac.link) {
 		for (i = 0; i < hdev->num_vmdq_vport + 1; i++) {
@@ -2761,6 +2760,8 @@ static void hclge_update_link_status(struct hclge_dev *hdev)
 		}
 		hdev->hw.mac.link = state;
 	}
+
+	clear_bit(HCLGE_STATE_LINK_UPDATING, &hdev->state);
 }
 
 static void hclge_update_port_capability(struct hclge_mac *mac)
@@ -3352,6 +3353,18 @@ static int hclge_set_all_vf_rst(struct hclge_dev *hdev, bool reset)
 	return 0;
 }
 
+static void hclge_mailbox_service_task(struct hclge_dev *hdev)
+{
+	if (!test_and_clear_bit(HCLGE_STATE_MBX_SERVICE_SCHED, &hdev->state) ||
+	    test_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state) ||
+	    test_and_set_bit(HCLGE_STATE_MBX_HANDLING, &hdev->state))
+		return;
+
+	hclge_mbx_handler(hdev);
+
+	clear_bit(HCLGE_STATE_MBX_HANDLING, &hdev->state);
+}
+
 static int hclge_func_reset_sync_vf(struct hclge_dev *hdev)
 {
 	struct hclge_pf_rst_sync_cmd *req;
@@ -3363,6 +3376,9 @@ static int hclge_func_reset_sync_vf(struct hclge_dev *hdev)
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_QUERY_VF_RST_RDY, true);
 
 	do {
+		/* vf need to down netdev by mbx during PF or FLR reset */
+		hclge_mailbox_service_task(hdev);
+
 		ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 		/* for compatible with old firmware, wait
 		 * 100 ms for VF to stop IO
@@ -3939,36 +3955,19 @@ static void hclge_reset_subtask(struct hclge_dev *hdev)
 	hdev->reset_type = HNAE3_NONE_RESET;
 }
 
-static void hclge_reset_service_task(struct work_struct *work)
+static void hclge_reset_service_task(struct hclge_dev *hdev)
 {
-	struct hclge_dev *hdev =
-		container_of(work, struct hclge_dev, rst_service_task);
+	if (!test_and_clear_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state))
+		return;
 
 	if (test_and_set_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
 		return;
 
-	clear_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state);
-
 	hclge_reset_subtask(hdev);
 
 	clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
 }
 
-static void hclge_mailbox_service_task(struct work_struct *work)
-{
-	struct hclge_dev *hdev =
-		container_of(work, struct hclge_dev, mbx_service_task);
-
-	if (test_and_set_bit(HCLGE_STATE_MBX_HANDLING, &hdev->state))
-		return;
-
-	clear_bit(HCLGE_STATE_MBX_SERVICE_SCHED, &hdev->state);
-
-	hclge_mbx_handler(hdev);
-
-	clear_bit(HCLGE_STATE_MBX_HANDLING, &hdev->state);
-}
-
 static void hclge_update_vport_alive(struct hclge_dev *hdev)
 {
 	int i;
@@ -3986,29 +3985,62 @@ static void hclge_update_vport_alive(struct hclge_dev *hdev)
 	}
 }
 
-static void hclge_service_task(struct work_struct *work)
+static void hclge_periodic_service_task(struct hclge_dev *hdev)
 {
-	struct hclge_dev *hdev =
-		container_of(work, struct hclge_dev, service_task.work);
+	unsigned long delta = round_jiffies_relative(HZ);
 
-	clear_bit(HCLGE_STATE_SERVICE_SCHED, &hdev->state);
+	/* Always handle the link updating to make sure link state is
+	 * updated when it is triggered by mbx.
+	 */
+	hclge_update_link_status(hdev);
 
-	if (hdev->hw_stats.stats_timer >= HCLGE_STATS_TIMER_INTERVAL) {
-		hclge_update_stats_for_all(hdev);
-		hdev->hw_stats.stats_timer = 0;
+	if (time_is_after_jiffies(hdev->last_serv_processed + HZ)) {
+		delta = jiffies - hdev->last_serv_processed;
+
+		if (delta < round_jiffies_relative(HZ)) {
+			delta = round_jiffies_relative(HZ) - delta;
+			goto out;
+		}
 	}
 
-	hclge_update_port_info(hdev);
-	hclge_update_link_status(hdev);
+	hdev->serv_processed_cnt++;
 	hclge_update_vport_alive(hdev);
+
+	if (test_bit(HCLGE_STATE_DOWN, &hdev->state)) {
+		hdev->last_serv_processed = jiffies;
+		goto out;
+	}
+
+	if (!(hdev->serv_processed_cnt % HCLGE_STATS_TIMER_INTERVAL))
+		hclge_update_stats_for_all(hdev);
+
+	hclge_update_port_info(hdev);
 	hclge_sync_vlan_filter(hdev);
 
-	if (hdev->fd_arfs_expire_timer >= HCLGE_FD_ARFS_EXPIRE_TIMER_INTERVAL) {
+	if (!(hdev->serv_processed_cnt % HCLGE_ARFS_EXPIRE_INTERVAL))
 		hclge_rfs_filter_expire(hdev);
-		hdev->fd_arfs_expire_timer = 0;
-	}
 
-	hclge_task_schedule(hdev, round_jiffies_relative(HZ));
+	hdev->last_serv_processed = jiffies;
+
+out:
+	hclge_task_schedule(hdev, delta);
+}
+
+static void hclge_service_task(struct work_struct *work)
+{
+	struct hclge_dev *hdev =
+		container_of(work, struct hclge_dev, service_task.work);
+
+	hclge_reset_service_task(hdev);
+	hclge_mailbox_service_task(hdev);
+	hclge_periodic_service_task(hdev);
+
+	/* Handle reset and mbx again in case periodical task delays the
+	 * handling by calling hclge_task_schedule() in
+	 * hclge_periodic_service_task().
+	 */
+	hclge_reset_service_task(hdev);
+	hclge_mailbox_service_task(hdev);
 }
 
 struct hclge_vport *hclge_get_vport(struct hnae3_handle *handle)
@@ -6734,6 +6766,19 @@ static void hclge_reset_tqp_stats(struct hnae3_handle *handle)
 	}
 }
 
+static void hclge_flush_link_update(struct hclge_dev *hdev)
+{
+#define HCLGE_FLUSH_LINK_TIMEOUT	100000
+
+	unsigned long last = hdev->serv_processed_cnt;
+	int i = 0;
+
+	while (test_bit(HCLGE_STATE_LINK_UPDATING, &hdev->state) &&
+	       i++ < HCLGE_FLUSH_LINK_TIMEOUT &&
+	       last == hdev->serv_processed_cnt)
+		usleep_range(1, 1);
+}
+
 static void hclge_set_timer_task(struct hnae3_handle *handle, bool enable)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
@@ -6742,12 +6787,12 @@ static void hclge_set_timer_task(struct hnae3_handle *handle, bool enable)
 	if (enable) {
 		hclge_task_schedule(hdev, round_jiffies_relative(HZ));
 	} else {
-		/* Set the DOWN flag here to disable the service to be
-		 * scheduled again
-		 */
+		/* Set the DOWN flag here to disable link updating */
 		set_bit(HCLGE_STATE_DOWN, &hdev->state);
-		cancel_delayed_work_sync(&hdev->service_task);
-		clear_bit(HCLGE_STATE_SERVICE_SCHED, &hdev->state);
+
+		/* flush memory to make sure DOWN is seen by service task */
+		smp_mb__before_atomic();
+		hclge_flush_link_update(hdev);
 	}
 }
 
@@ -9269,10 +9314,6 @@ static void hclge_state_uninit(struct hclge_dev *hdev)
 		del_timer_sync(&hdev->reset_timer);
 	if (hdev->service_task.work.func)
 		cancel_delayed_work_sync(&hdev->service_task);
-	if (hdev->rst_service_task.func)
-		cancel_work_sync(&hdev->rst_service_task);
-	if (hdev->mbx_service_task.func)
-		cancel_work_sync(&hdev->mbx_service_task);
 }
 
 static void hclge_flr_prepare(struct hnae3_ae_dev *ae_dev)
@@ -9477,8 +9518,6 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 	timer_setup(&hdev->reset_timer, hclge_reset_timer, 0);
 	INIT_DELAYED_WORK(&hdev->service_task, hclge_service_task);
-	INIT_WORK(&hdev->rst_service_task, hclge_reset_service_task);
-	INIT_WORK(&hdev->mbx_service_task, hclge_mailbox_service_task);
 
 	/* Setup affinity after service timer setup because add_timer_on
 	 * is called in affinity notify.
@@ -9512,6 +9551,8 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	dev_info(&hdev->pdev->dev, "%s driver initialization finished.\n",
 		 HCLGE_DRIVER_NAME);
 
+	hclge_task_schedule(hdev, round_jiffies_relative(HZ));
+
 	return 0;
 
 err_mdiobus_unreg:
@@ -9534,7 +9575,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 static void hclge_stats_clear(struct hclge_dev *hdev)
 {
-	memset(&hdev->hw_stats, 0, sizeof(hdev->hw_stats));
+	memset(&hdev->mac_stats, 0, sizeof(hdev->mac_stats));
 }
 
 static int hclge_set_mac_spoofchk(struct hclge_dev *hdev, int vf, bool enable)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index ebb4c6e..ad40cf6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -208,13 +208,13 @@ enum HCLGE_DEV_STATE {
 	HCLGE_STATE_NIC_REGISTERED,
 	HCLGE_STATE_ROCE_REGISTERED,
 	HCLGE_STATE_SERVICE_INITED,
-	HCLGE_STATE_SERVICE_SCHED,
 	HCLGE_STATE_RST_SERVICE_SCHED,
 	HCLGE_STATE_RST_HANDLING,
 	HCLGE_STATE_MBX_SERVICE_SCHED,
 	HCLGE_STATE_MBX_HANDLING,
 	HCLGE_STATE_STATISTICS_UPDATING,
 	HCLGE_STATE_CMD_DISABLE,
+	HCLGE_STATE_LINK_UPDATING,
 	HCLGE_STATE_MAX
 };
 
@@ -454,11 +454,7 @@ struct hclge_mac_stats {
 	u64 mac_rx_ctrl_pkt_num;
 };
 
-#define HCLGE_STATS_TIMER_INTERVAL	(60 * 5)
-struct hclge_hw_stats {
-	struct hclge_mac_stats      mac_stats;
-	u32 stats_timer;
-};
+#define HCLGE_STATS_TIMER_INTERVAL	300UL
 
 struct hclge_vlan_type_cfg {
 	u16 rx_ot_fst_vlan_type;
@@ -549,7 +545,7 @@ struct key_info {
 
 /* assigned by firmware, the real filter number for each pf may be less */
 #define MAX_FD_FILTER_NUM	4096
-#define HCLGE_FD_ARFS_EXPIRE_TIMER_INTERVAL	5
+#define HCLGE_ARFS_EXPIRE_INTERVAL	5UL
 
 enum HCLGE_FD_ACTIVE_RULE_TYPE {
 	HCLGE_FD_RULE_NONE,
@@ -712,7 +708,7 @@ struct hclge_dev {
 	struct hnae3_ae_dev *ae_dev;
 	struct hclge_hw hw;
 	struct hclge_misc_vector misc_vector;
-	struct hclge_hw_stats hw_stats;
+	struct hclge_mac_stats mac_stats;
 	unsigned long state;
 	unsigned long flr_state;
 	unsigned long last_reset_time;
@@ -774,8 +770,6 @@ struct hclge_dev {
 	unsigned long service_timer_previous;
 	struct timer_list reset_timer;
 	struct delayed_work service_task;
-	struct work_struct rst_service_task;
-	struct work_struct mbx_service_task;
 
 	bool cur_promisc;
 	int num_alloc_vfs;	/* Actual number of VFs allocated */
@@ -811,7 +805,8 @@ struct hclge_dev {
 	struct hlist_head fd_rule_list;
 	spinlock_t fd_rule_lock; /* protect fd_rule_list and fd_bmap */
 	u16 hclge_fd_rule_num;
-	u16 fd_arfs_expire_timer;
+	unsigned long serv_processed_cnt;
+	unsigned long last_serv_processed;
 	unsigned long fd_bmap[BITS_TO_LONGS(MAX_FD_FILTER_NUM)];
 	enum HCLGE_FD_ACTIVE_RULE_TYPE fd_active_type;
 	u8 fd_en;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 0b433eb..a79d151 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -635,7 +635,6 @@ static void hclge_handle_link_change_event(struct hclge_dev *hdev,
 #define LINK_STATUS_OFFSET	1
 #define LINK_FAIL_CODE_OFFSET	2
 
-	clear_bit(HCLGE_STATE_SERVICE_SCHED, &hdev->state);
 	hclge_task_schedule(hdev, 0);
 
 	if (!req->msg[LINK_STATUS_OFFSET])
-- 
2.7.4

