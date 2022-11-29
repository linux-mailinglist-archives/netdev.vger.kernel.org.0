Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF4D63C09D
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbiK2NKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbiK2NJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:09:59 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9758559160;
        Tue, 29 Nov 2022 05:09:58 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATBxhCh022460;
        Tue, 29 Nov 2022 05:09:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=V8Qi1qev7WneDs1w4LFJmudicBVWSIWv6DZvNX/IwWA=;
 b=fGdWuQIhIEd+tyAzzzBwgGnrUDMh5wPwCDRUiaCdmg2uZ4TtAiNckS7OWsY0RYqnlinB
 efX6xVW4acsWTptcUSsoTpiUk1BZ+1HAz2ShArK6Fm5JfcNeewzmdvdpAGSzU8Z5ViYe
 J42WpLZKSVUSGdvIpoT4GWuPNTj6Lyj/TvmoE+X1uZIZPOfgt7Ap90Oq0jilu4lFNOQr
 wpv6o4pjg2ldFuuEMzdC7LJ4fwPg9hUQ+EC+gEeQxsZ75DQBMc1H30LnisjSbWh/9KV6
 r4ai8GhICfX16UepiTOAtZhtcgZh/ttXtGK+mNU1GeIuhsG9g5/FEE3TOTWkYaJp2mP3 LA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3m3k6wbcp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 05:09:51 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 29 Nov
 2022 05:09:48 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Nov 2022 05:09:48 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 820B13F7086;
        Tue, 29 Nov 2022 05:09:48 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lironh@marvell.com>, <aayarekar@marvell.com>,
        <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v2 9/9] octeon_ep: add heartbeat monitor
Date:   Tue, 29 Nov 2022 05:09:32 -0800
Message-ID: <20221129130933.25231-10-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221129130933.25231-1-vburru@marvell.com>
References: <20221129130933.25231-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 6p87UxuavVPynHQFDmiTPSmL5FQIfcW2
X-Proofpoint-ORIG-GUID: 6p87UxuavVPynHQFDmiTPSmL5FQIfcW2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_08,2022-11-29_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Monitor periodic heartbeat messages from device firmware.
Presence of heartbeat indicates the device is active and running.
If the heartbeat is missed for configured interval indicates
firmware has crashed and device is unusable; in this case, PF driver
stops and uninitialize the device.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
---
v1 -> v2:
 * reworked the patch for changes made to preceding patches.
 * removed device status oct->status, as it is not required with the
   modified implementation.

 .../marvell/octeon_ep/octep_cn9k_pf.c         |  9 +++++
 .../ethernet/marvell/octeon_ep/octep_config.h |  6 +++
 .../ethernet/marvell/octeon_ep/octep_main.c   | 37 +++++++++++++++++++
 .../ethernet/marvell/octeon_ep/octep_main.h   |  7 ++++
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |  2 +
 5 files changed, 61 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
index 4840133477dc..9c6b2a95bc18 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
@@ -16,6 +16,9 @@
 #define CTRL_MBOX_MAX_PF	128
 #define CTRL_MBOX_SZ		((size_t)(0x400000 / CTRL_MBOX_MAX_PF))
 
+#define FW_HB_INTERVAL_IN_SECS		1
+#define FW_HB_MISS_COUNT		10
+
 /* Names of Hardware non-queue generic interrupts */
 static char *cn93_non_ioq_msix_names[] = {
 	"epf_ire_rint",
@@ -249,6 +252,10 @@ static void octep_init_config_cn93_pf(struct octep_device *oct)
 	conf->ctrl_mbox_cfg.barmem_addr = (void __iomem *)oct->mmio[2].hw_addr +
 					   (0x400000ull * 8) +
 					   (link * CTRL_MBOX_SZ);
+
+	conf->hb_interval = FW_HB_INTERVAL_IN_SECS;
+	conf->max_hb_miss_cnt = FW_HB_MISS_COUNT;
+
 }
 
 /* Setup registers for a hardware Tx Queue  */
@@ -407,6 +414,8 @@ static int octep_poll_non_ioq_interrupts_cn93_pf(struct octep_device *oct)
 		octep_write_csr64(oct, CN93_SDP_EPF_OEI_RINT, reg0);
 		if (reg0 & CN93_SDP_EPF_OEI_RINT_DATA_BIT_MBOX)
 			queue_work(octep_wq, &oct->ctrl_mbox_task);
+		else if (reg0 & CN93_SDP_EPF_OEI_RINT_DATA_BIT_HBEAT)
+			atomic_set(&oct->hb_miss_cnt, 0);
 
 		handled = 1;
 	}
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_config.h b/drivers/net/ethernet/marvell/octeon_ep/octep_config.h
index f208f3f9a447..df7cd39d9fce 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_config.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_config.h
@@ -200,5 +200,11 @@ struct octep_config {
 
 	/* ctrl mbox config */
 	struct octep_ctrl_mbox_config ctrl_mbox_cfg;
+
+	/* Configured maximum heartbeat miss count */
+	u32 max_hb_miss_cnt;
+
+	/* Configured firmware heartbeat interval in secs */
+	u32 hb_interval;
 };
 #endif /* _OCTEP_CONFIG_H_ */
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index cd0d77ceb868..751a3a9c576f 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -903,6 +903,38 @@ static void octep_intr_poll_task(struct work_struct *work)
 			   msecs_to_jiffies(OCTEP_INTR_POLL_TIME_MSECS));
 }
 
+/**
+ * octep_hb_timeout_task - work queue task to check firmware heartbeat.
+ *
+ * @work: pointer to hb work_struct
+ *
+ * Check for heartbeat miss count. Uninitialize oct device if miss count
+ * exceeds configured max heartbeat miss count.
+ *
+ **/
+static void octep_hb_timeout_task(struct work_struct *work)
+{
+	struct octep_device *oct = container_of(work, struct octep_device,
+						hb_task.work);
+
+	int miss_cnt;
+
+	atomic_inc(&oct->hb_miss_cnt);
+	miss_cnt = atomic_read(&oct->hb_miss_cnt);
+	if (miss_cnt < oct->conf->max_hb_miss_cnt) {
+		queue_delayed_work(octep_wq, &oct->hb_task,
+				   msecs_to_jiffies(oct->conf->hb_interval * 1000));
+		return;
+	}
+
+	dev_err(&oct->pdev->dev, "Missed %u heartbeats. Uninitializing\n",
+		miss_cnt);
+	rtnl_lock();
+	if (netif_running(oct->netdev))
+		octep_stop(oct->netdev);
+	rtnl_unlock();
+}
+
 /**
  * octep_ctrl_mbox_task - work queue task to handle ctrl mbox messages.
  *
@@ -979,6 +1011,10 @@ int octep_device_setup(struct octep_device *oct)
 	if (ret)
 		return ret;
 
+	atomic_set(&oct->hb_miss_cnt, 0);
+	INIT_DELAYED_WORK(&oct->hb_task, octep_hb_timeout_task);
+	queue_delayed_work(octep_wq, &oct->hb_task,
+			   msecs_to_jiffies(oct->conf->hb_interval * 1000));
 	return 0;
 
 unsupported_dev:
@@ -1004,6 +1040,7 @@ static void octep_device_cleanup(struct octep_device *oct)
 
 	octep_delete_pfvf_mbox(oct);
 	octep_ctrl_net_uninit(oct);
+	cancel_delayed_work_sync(&oct->hb_task);
 
 	oct->hw_ops.soft_reset(oct);
 	for (i = 0; i < OCTEP_MMIO_REGIONS; i++) {
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
index ad6d324bd525..beedf8dc841d 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
@@ -286,6 +286,13 @@ struct octep_device {
 	bool poll_non_ioq_intr;
 	/* Work entry to poll non-ioq interrupts */
 	struct delayed_work intr_poll_task;
+
+	/* Firmware heartbeat timer */
+	struct timer_list hb_timer;
+	/* Firmware heartbeat miss count tracked by timer */
+	atomic_t hb_miss_cnt;
+	/* Task to reset device on heartbeat miss */
+	struct delayed_work hb_task;
 };
 
 static inline u16 OCTEP_MAJOR_REV(struct octep_device *oct)
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h b/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
index f29c4344fc41..48051e23ef18 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
@@ -376,5 +376,7 @@
 
 /* bit 0 for control mbox interrupt */
 #define CN93_SDP_EPF_OEI_RINT_DATA_BIT_MBOX	BIT_ULL(0)
+/* bit 1 for firmware heartbeat interrupt */
+#define CN93_SDP_EPF_OEI_RINT_DATA_BIT_HBEAT	BIT_ULL(1)
 
 #endif /* _OCTEP_REGS_CN9K_PF_H_ */
-- 
2.36.0

