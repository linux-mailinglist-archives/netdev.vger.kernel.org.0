Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1EA671BFE
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 13:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjARMZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 07:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjARMYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 07:24:39 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004905B46C;
        Wed, 18 Jan 2023 03:44:44 -0800 (PST)
X-UUID: 7dbab066972511eda06fc9ecc4dadd91-20230118
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=G/4mCylFmsmeRC8FlFxTgS4ymv5vJDdZUlfVlLEXu2g=;
        b=AkCD3FCGEqyEp7T9YTRPhm2eEymStij24FYRUeCbXWDY6ltWo6FqLfPo8Pwmz+615HQaG0VayA6LHf37tcjmjvt263iYB9NtIr18U9g8ah5djXflXh+k0qYXnBwmAgBs7vH/CiyTQHCbI1VYay3fZ/lPF1B4oho3NoVCBZyEfFM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.18,REQID:a4c1887f-7f87-45b5-aa51-0ca3d1e4667e,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:-25
X-CID-META: VersionHash:3ca2d6b,CLOUDID:73a89e8c-8530-4eff-9f77-222cf6e2895b,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:1,OSI:0,OSA:0
X-CID-BVR: 2,OSH
X-UUID: 7dbab066972511eda06fc9ecc4dadd91-20230118
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1665747071; Wed, 18 Jan 2023 19:44:39 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 18 Jan 2023 19:44:38 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 18 Jan 2023 19:44:36 +0800
From:   Yanchao Yang <yanchao.yang@mediatek.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev ML <netdev@vger.kernel.org>,
        kernel ML <linux-kernel@vger.kernel.org>
CC:     Intel experts <linuxwwan@intel.com>,
        Chetan <m.chetan.kumar@intel.com>,
        MTK ML <linux-mediatek@lists.infradead.org>,
        Liang Lu <liang.lu@mediatek.com>,
        Haijun Liu <haijun.liu@mediatek.com>,
        Hua Yang <hua.yang@mediatek.com>,
        Ting Wang <ting.wang@mediatek.com>,
        Felix Chen <felix.chen@mediatek.com>,
        Mingliang Xu <mingliang.xu@mediatek.com>,
        Min Dong <min.dong@mediatek.com>,
        Aiden Wang <aiden.wang@mediatek.com>,
        Guohao Zhang <guohao.zhang@mediatek.com>,
        Chris Feng <chris.feng@mediatek.com>,
        "Yanchao Yang" <yanchao.yang@mediatek.com>,
        Lambert Wang <lambert.wang@mediatek.com>,
        Mingchuang Qiao <mingchuang.qiao@mediatek.com>,
        Xiayu Zhang <xiayu.zhang@mediatek.com>,
        Haozhe Chang <haozhe.chang@mediatek.com>
Subject: [PATCH net-next v2 08/12] net: wwan: tmi: Add data plane transaction layer
Date:   Wed, 18 Jan 2023 19:38:55 +0800
Message-ID: <20230118113859.175836-9-yanchao.yang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20230118113859.175836-1-yanchao.yang@mediatek.com>
References: <20230118113859.175836-1-yanchao.yang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Data Path Modem AP Interface (DPMAIF) provides methods for initialization,
ring buffer management, ISR, control and handling of TX/RX services' flows.

DPMAIF TX
It exposes the function 'mtk_dpmaif_send' which can be called by the port layer
indirectly to transmit packets. The transaction layer manages uplink data with
Descriptor Ring Buffer (DRB), which includes one message DRB entry and one or
more normal DRB entries. Message DRB holds the general packet information and
each normal DRB entry holds the address of the packet segment. At the same
time, DPMAIF provides multiple virtual queues with different priorities.

DPMAIF RX
The downlink buffer management uses Buffer Address Table (BAT), which includes
normal BAT and fragment BAT, and Packet Information Table (PIT) rings.
The BAT ring holds the address of the skb data buffer for the hardware to use,
while the PIT contains metadata about a whole network packet including a
reference to the BAT entry holding the data buffer address. The driver reads
the PIT and BAT entries written by the modem. When reaching a threshold, the
driver reloads the PIT and BAT rings.

Signed-off-by: Yanchao Yang <yanchao.yang@mediatek.com>
---
 drivers/net/wwan/mediatek/Makefile         |    3 +-
 drivers/net/wwan/mediatek/mtk_data_plane.h |  101 +
 drivers/net/wwan/mediatek/mtk_dev.c        |    8 +
 drivers/net/wwan/mediatek/mtk_dev.h        |   17 +
 drivers/net/wwan/mediatek/mtk_dpmaif.c     | 4005 ++++++++++++++++++++
 drivers/net/wwan/mediatek/pcie/mtk_pci.c   |    6 +
 6 files changed, 4139 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wwan/mediatek/mtk_data_plane.h
 create mode 100644 drivers/net/wwan/mediatek/mtk_dpmaif.c

diff --git a/drivers/net/wwan/mediatek/Makefile b/drivers/net/wwan/mediatek/Makefile
index 1049b0a0a339..8c37a7f9d598 100644
--- a/drivers/net/wwan/mediatek/Makefile
+++ b/drivers/net/wwan/mediatek/Makefile
@@ -11,7 +11,8 @@ mtk_tmi-y = \
 	pcie/mtk_dpmaif_drv_t800.o \
 	mtk_port.o \
 	mtk_port_io.o \
-	mtk_fsm.o
+	mtk_fsm.o \
+	mtk_dpmaif.o
 
 ccflags-y += -I$(srctree)/$(src)/
 ccflags-y += -I$(srctree)/$(src)/pcie/
diff --git a/drivers/net/wwan/mediatek/mtk_data_plane.h b/drivers/net/wwan/mediatek/mtk_data_plane.h
new file mode 100644
index 000000000000..4daf3ec32c91
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_data_plane.h
@@ -0,0 +1,101 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear
+ *
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#ifndef __MTK_DATA_PLANE_H__
+#define __MTK_DATA_PLANE_H__
+
+#include <linux/bitops.h>
+#include <linux/completion.h>
+#include <linux/skbuff.h>
+
+#define SKB_TO_CMD(skb) ((struct mtk_data_cmd *)(skb)->data)
+#define CMD_TO_DATA(cmd) (*(void **)(cmd)->data)
+#define SKB_TO_CMD_DATA(skb) (*(void **)SKB_TO_CMD(skb)->data)
+
+#define IPV4_VERSION 0x40
+#define IPV6_VERSION 0x60
+
+enum mtk_data_feature {
+	DATA_F_LRO = BIT(0),
+	DATA_F_RXFH = BIT(1),
+	DATA_F_INTR_COALESCE = BIT(2),
+	DATA_F_MULTI_NETDEV = BIT(16),
+	DATA_F_ETH_PDN = BIT(17),
+};
+
+struct mtk_data_blk {
+	struct mtk_md_dev *mdev;
+	struct mtk_dpmaif_ctlb *dcb;
+};
+
+enum mtk_data_type {
+	DATA_PKT,
+	DATA_CMD,
+};
+
+enum mtk_pkt_type {
+	PURE_IP,
+};
+
+enum mtk_data_cmd_type {
+	DATA_CMD_TRANS_CTL,
+	DATA_CMD_RXFH_GET,
+	DATA_CMD_RXFH_SET,
+	DATA_CMD_TRANS_DUMP,
+	DATA_CMD_RXQ_NUM_GET,
+	DATA_CMD_HKEY_SIZE_GET,
+	DATA_CMD_INDIR_SIZE_GET,
+	DATA_CMD_INTR_COALESCE_GET,
+	DATA_CMD_INTR_COALESCE_SET,
+	DATA_CMD_STRING_CNT_GET,
+	DATA_CMD_STRING_GET,
+};
+
+struct mtk_data_intr_coalesce {
+	unsigned int rx_coalesce_usecs;
+	unsigned int tx_coalesce_usecs;
+	unsigned int rx_coalesced_frames;
+	unsigned int tx_coalesced_frames;
+};
+
+struct mtk_data_rxfh {
+	unsigned int *indir;
+	u8 *key;
+};
+
+struct mtk_data_trans_ctl {
+	bool enable;
+};
+
+struct mtk_data_cmd {
+	void (*data_complete)(void *data);
+	struct completion done;
+	int ret;
+	enum mtk_data_cmd_type cmd;
+	unsigned int len;
+	char data[];
+};
+
+struct mtk_data_trans_ops {
+	int (*poll)(struct napi_struct *napi, int budget);
+	int (*select_txq)(struct sk_buff *skb, enum mtk_pkt_type pkt_type);
+	int (*send)(struct mtk_data_blk *data_blk, enum mtk_data_type type,
+		    struct sk_buff *skb, u64 data);
+};
+
+struct mtk_data_trans_info {
+	u32 cap;
+	unsigned char rxq_cnt;
+	unsigned char txq_cnt;
+	unsigned int max_mtu;
+	struct napi_struct **napis;
+};
+
+int mtk_data_init(struct mtk_md_dev *mdev);
+int mtk_data_exit(struct mtk_md_dev *mdev);
+
+extern struct mtk_data_trans_ops data_trans_ops;
+
+#endif /* __MTK_DATA_PLANE_H__ */
diff --git a/drivers/net/wwan/mediatek/mtk_dev.c b/drivers/net/wwan/mediatek/mtk_dev.c
index 408a30ce3d3a..50a05921e698 100644
--- a/drivers/net/wwan/mediatek/mtk_dev.c
+++ b/drivers/net/wwan/mediatek/mtk_dev.c
@@ -4,6 +4,7 @@
  */
 
 #include "mtk_ctrl_plane.h"
+#include "mtk_data_plane.h"
 #include "mtk_dev.h"
 #include "mtk_fsm.h"
 
@@ -19,6 +20,12 @@ int mtk_dev_init(struct mtk_md_dev *mdev)
 	if (ret)
 		goto err_ctrl_init;
 
+	ret = mtk_data_init(mdev);
+	if (ret)
+		goto err_data_init;
+
+err_data_init:
+	mtk_ctrl_exit(mdev);
 err_ctrl_init:
 	mtk_fsm_exit(mdev);
 err_fsm_init:
@@ -29,6 +36,7 @@ void mtk_dev_exit(struct mtk_md_dev *mdev)
 {
 	mtk_fsm_evt_submit(mdev, FSM_EVT_DEV_RM, 0, NULL, 0,
 			   EVT_MODE_BLOCKING | EVT_MODE_TOHEAD);
+	mtk_data_exit(mdev);
 	mtk_ctrl_exit(mdev);
 	mtk_fsm_exit(mdev);
 }
diff --git a/drivers/net/wwan/mediatek/mtk_dev.h b/drivers/net/wwan/mediatek/mtk_dev.h
index bc824294f17c..0dc73b40554f 100644
--- a/drivers/net/wwan/mediatek/mtk_dev.h
+++ b/drivers/net/wwan/mediatek/mtk_dev.h
@@ -86,6 +86,7 @@ struct mtk_md_dev;
  * @get_ext_evt_status:Callback to get HW Layer external event status.
  * @reset:          Callback to reset device.
  * @reinit:         Callback to execute device re-initialization.
+ * @mmio_check:     Callback to check whether it is available to mmio access device.
  * @get_hp_status:  Callback to get link hotplug status.
  */
 struct mtk_hw_ops {
@@ -117,6 +118,7 @@ struct mtk_hw_ops {
 
 	int (*reset)(struct mtk_md_dev *mdev, enum mtk_reset_type type);
 	int (*reinit)(struct mtk_md_dev *mdev, enum mtk_reinit_type type);
+	bool (*mmio_check)(struct mtk_md_dev *mdev);
 	int (*get_hp_status)(struct mtk_md_dev *mdev);
 };
 
@@ -130,6 +132,7 @@ struct mtk_hw_ops {
  * @dev_str:    to keep device B-D-F information.
  * @fsm:        pointer to the context of fsm submodule.
  * @ctrl_blk:   pointer to the context of control plane submodule.
+ * @data_blk:   pointer to the context of data plane submodule.
  * @bm_ctrl:    pointer to the context of buffer management submodule.
  */
 struct mtk_md_dev {
@@ -142,6 +145,7 @@ struct mtk_md_dev {
 
 	struct mtk_md_fsm *fsm;
 	void *ctrl_blk;
+	void *data_blk;
 	struct mtk_bm_ctrl *bm_ctrl;
 };
 
@@ -457,6 +461,19 @@ static inline int mtk_hw_reinit(struct mtk_md_dev *mdev, enum mtk_reinit_type ty
 	return mdev->hw_ops->reinit(mdev, type);
 }
 
+/**
+ * mtk_hw_mmio_check() - Check if the PCIe MMIO is ready.
+ * @mdev: Device instance.
+ *
+ * Return:
+ * * 0 - indicates PCIe MMIO is ready.
+ * * other value - indicates not ready.
+ */
+static inline bool mtk_hw_mmio_check(struct mtk_md_dev *mdev)
+{
+	return mdev->hw_ops->mmio_check(mdev);
+}
+
 /**
  * mtk_hw_get_hp_status() - Get whether the device can be hot-plugged.
  * @mdev: Device instance.
diff --git a/drivers/net/wwan/mediatek/mtk_dpmaif.c b/drivers/net/wwan/mediatek/mtk_dpmaif.c
new file mode 100644
index 000000000000..36f247146bca
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_dpmaif.c
@@ -0,0 +1,4005 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/*
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/icmp.h>
+#include <linux/ip.h>
+#include <linux/kthread.h>
+#include <linux/skbuff.h>
+#include <net/ipv6.h>
+#include <net/pkt_sched.h>
+
+#include "mtk_data_plane.h"
+#include "mtk_dev.h"
+#include "mtk_dpmaif_drv.h"
+#include "mtk_fsm.h"
+#include "mtk_reg.h"
+
+#define DPMAIF_PIT_CNT_UPDATE_THRESHOLD 60
+#define DPMAIF_SKB_TX_WEIGHT		5
+
+/* Interrupt coalesce default value */
+#define DPMAIF_DFLT_INTR_RX_COA_FRAMES 0
+#define DPMAIF_DFLT_INTR_TX_COA_FRAMES 0
+#define DPMAIF_DFLT_INTR_RX_COA_USECS 0
+#define DPMAIF_DFLT_INTR_TX_COA_USECS 0
+#define DPMAIF_INTR_EN_TIME BIT(0)
+#define DPMAIF_INTR_EN_PKT BIT(1)
+
+/* Dpmaif hardware DMA descriptor structure. */
+enum dpmaif_rcsum_state {
+	CS_RESULT_INVALID = -1,
+	CS_RESULT_PASS = 0,
+	CS_RESULT_FAIL = 1,
+	CS_RESULT_NOTSUPP = 2,
+	CS_RESULT_RSV = 3
+};
+
+struct dpmaif_msg_pit {
+	__le32 dword1;
+	__le32 dword2;
+	__le32 dword3;
+	__le32 dword4;
+};
+
+#define PIT_MSG_DP		BIT(31) /* Indicates software to drop this packet if set. */
+#define PIT_MSG_DW1_RSV1	GENMASK(30, 27)
+#define PIT_MSG_NET_TYPE	GENMASK(26, 24)
+#define PIT_MSG_CHNL_ID		GENMASK(23, 16) /* channel index */
+#define PIT_MSG_DW1_RSV2	GENMASK(15, 12)
+#define PIT_MSG_HPC_IDX		GENMASK(11, 8)
+#define PIT_MSG_SRC_QID		GENMASK(7, 5)
+#define PIT_MSG_ERR		BIT(4)
+#define PIT_MSG_CHECKSUM	GENMASK(3, 2)
+#define PIT_MSG_CONT		BIT(1) /* 0b: last entry; 1b: more entry */
+#define PIT_MSG_PKT_TYPE	BIT(0) /* 0b: normal PIT entry; 1b: message PIT entry */
+
+#define PIT_MSG_HP_IDX		GENMASK(31, 27)
+#define PIT_MSG_CMD		GENMASK(26, 24)
+#define PIT_MSG_DW2_RSV		GENMASK(23, 21)
+#define PIT_MSG_FLOW		GENMASK(20, 16)
+#define PIT_MSG_COUNT_L		GENMASK(15, 0)
+
+#define PIT_MSG_HASH		GENMASK(31, 24) /* Hash value calculated by Hardware using packet */
+#define PIT_MSG_DW3_RSV1	GENMASK(23, 18)
+#define PIT_MSG_PRO		GENMASK(17, 16)
+#define PIT_MSG_VBID		GENMASK(15, 3)
+#define PIT_MSG_DW3_RSV2	GENMASK(2, 0)
+
+#define PIT_MSG_DLQ_DONE	GENMASK(31, 30)
+#define PIT_MSG_ULQ_DONE	GENMASK(29, 24)
+#define PIT_MSG_IP		BIT(23)
+#define PIT_MSG_DW4_RSV1	BIT(22)
+#define PIT_MSG_MR		GENMASK(21, 20)
+#define PIT_MSG_DW4_RSV2	GENMASK(19, 17)
+#define PIT_MSG_IG		BIT(16)
+#define PIT_MSG_DW4_RSV3	GENMASK(15, 11)
+#define PIT_MSG_H_BID		GENMASK(10, 8)
+/* An incremental number for each PIT, updated for each PIT entries.
+ * It is reset to 0 when its value reaches the maximum value.
+ */
+#define PIT_MSG_PIT_SEQ		GENMASK(7, 0)
+
+/* c_bit */
+#define DPMAIF_PIT_LASTONE	0x00
+#define DPMAIF_PIT_MORE		0x01
+
+/* pit type */
+enum dpmaif_pit_type {
+	PD_PIT = 0,
+	MSG_PIT,
+};
+
+/* buffer type */
+enum dpmaif_bat_type {
+	NORMAL_BAT = 0,
+	FRAG_BAT = 1,
+};
+
+struct dpmaif_pd_pit {
+	__le32 pd_header;
+	__le32 addr_low;
+	__le32 addr_high;
+	__le32 pd_footer;
+};
+
+#define PIT_PD_DATA_LEN		GENMASK(31, 16) /* Indicates the data length of current packet. */
+#define PIT_PD_BUF_ID		GENMASK(15, 3) /* The low order of buffer index */
+#define PIT_PD_BUF_TYPE		BIT(2) /* 0b: normal BAT entry; 1b: fragment BAT entry */
+#define PIT_PD_CONT		BIT(1) /* 0b: last entry; 1b: more entry */
+#define PIT_PD_PKT_TYPE		BIT(0) /* 0b: normal PIT entry; 1b: message PIT entry */
+
+#define PIT_PD_DLQ_DONE		GENMASK(31, 30)
+#define PIT_PD_ULQ_DONE		GENMASK(29, 24)
+/* The header length of transport layer and internet layer. */
+#define PIT_PD_HD_OFFSET	GENMASK(23, 19)
+#define PIT_PD_BI_F		GENMASK(18, 17)
+#define PIT_PD_IG		BIT(16)
+#define PIT_PD_RSV		GENMASK(15, 11)
+#define PIT_PD_H_BID		GENMASK(10, 8) /* The high order of buffer index */
+#define PIT_PD_SEQ		GENMASK(7, 0) /* PIT sequence */
+
+/* RX: buffer address table */
+struct dpmaif_bat {
+	__le32 buf_addr_low;
+	__le32 buf_addr_high;
+};
+
+/* drb->type */
+enum dpmaif_drb_type {
+	PD_DRB,
+	MSG_DRB,
+};
+
+#define DPMAIF_DRB_LASTONE	0x00
+#define DPMAIF_DRB_MORE		0x01
+
+struct dpmaif_msg_drb {
+	__le32 msg_header1;
+	__le32 msg_header2;
+	__le32 msg_rsv1;
+	__le32 msg_rsv2;
+};
+
+#define DRB_MSG_PKT_LEN		GENMASK(31, 16) /* The length of a whole packet. */
+#define DRB_MSG_DW1_RSV		GENMASK(15, 3)
+#define DRB_MSG_CONT		BIT(2) /* 0b: last entry; 1b: more entry */
+#define DRB_MSG_DTYP		GENMASK(1, 0) /* 00b: normal DRB entry; 01b: message DRB entry */
+
+#define DRB_MSG_DW2_RSV1	GENMASK(31, 30)
+#define DRB_MSG_L4_CHK		BIT(29) /* 0b: disable layer4 checksum offload; 1b: enable */
+#define DRB_MSG_IP_CHK		BIT(28) /* 0b: disable IP checksum, 1b: enable IP checksum */
+#define DRB_MSG_DW2_RSV2	BIT(27)
+#define DRB_MSG_NET_TYPE	GENMASK(26, 24)
+#define DRB_MSG_CHNL_ID		GENMASK(23, 16) /* channel index */
+#define DRB_MSG_COUNT_L		GENMASK(15, 0)
+
+struct dpmaif_pd_drb {
+	__le32 pd_header;
+	__le32 addr_low;
+	__le32 addr_high;
+	__le32 pd_rsv;
+};
+
+#define DRB_PD_DATA_LEN		GENMASK(31, 16) /* the length of a payload. */
+#define DRB_PD_RSV		GENMASK(15, 3)
+#define DRB_PD_CONT		BIT(2)/* 0b: last entry; 1b: more entry */
+#define DRB_PD_DTYP		GENMASK(1, 0) /* 00b: normal DRB entry; 01b: message DRB entry. */
+
+/* software resource structure */
+#define DPMAIF_SRV_CNT_MAX DPMAIF_TXQ_CNT_MAX
+
+/**
+ * struct dpmaif_res_cfg - Dpmaif resource configuration
+ * @tx_srv_cnt: Transmit services count.
+ * @tx_vq_cnt: Transmit virtual queue count.
+ * @tx_vq_srv_map: Transmit virtual queue and service map.
+ * Array index indicates virtual queue id, Array value indicates service id.
+ * @srv_prio_tbl: Transmit services priority
+ * Array index indicates service id, Array value indicates kthread nice value.
+ * @txq_doorbell_delay: Delay to send doorbell.
+ * @irq_cnt: Dpmaif interrupt source count.
+ * @irq_src: Dpmaif interrupt source id.
+ * @txq_cnt: Dpmaif Transmit queue count.
+ * @rxq_cnt: Dpmaif Receive queue count.
+ * @normal_bat_cnt: Dpmaif normal bat entry count.
+ * @frag_bat_cnt: Dpmaif frag bat entry count.
+ * @pit_cnt: Dpmaif pit entry count per receive queue.
+ * @drb_cnt: Dpmaif drb entry count per transmit queue.
+ * @cap: Dpmaif capability.
+ */
+struct dpmaif_res_cfg {
+	unsigned char tx_srv_cnt;
+	unsigned char tx_vq_cnt;
+	unsigned char tx_vq_srv_map[DPMAIF_TXQ_CNT_MAX];
+	int srv_prio_tbl[DPMAIF_SRV_CNT_MAX];
+	unsigned int txq_doorbell_delay[DPMAIF_TXQ_CNT_MAX];
+	unsigned char irq_cnt;
+	enum mtk_irq_src irq_src[DPMAIF_IRQ_CNT_MAX];
+	unsigned char txq_cnt;
+	unsigned char rxq_cnt;
+	unsigned int normal_bat_cnt;
+	unsigned int frag_bat_cnt;
+	unsigned int pit_cnt[DPMAIF_RXQ_CNT_MAX];
+	unsigned int drb_cnt[DPMAIF_TXQ_CNT_MAX];
+	unsigned int cap;
+};
+
+static const struct dpmaif_res_cfg res_cfg_t800 = {
+	.tx_srv_cnt = 4,
+	.tx_vq_cnt = 5,
+	.tx_vq_srv_map = {3, 1, 2, 0, 3},
+	.srv_prio_tbl = {-20, -15, -10, -5},
+	.txq_doorbell_delay = {0},
+	.irq_cnt = 3,
+	.irq_src = {MTK_IRQ_SRC_DPMAIF, MTK_IRQ_SRC_DPMAIF2, MTK_IRQ_SRC_DPMAIF3},
+	.txq_cnt = 5,
+	.rxq_cnt = 2,
+	.normal_bat_cnt = 16384,
+	.frag_bat_cnt = 8192,
+	.pit_cnt = {16384, 16384},
+	.drb_cnt = {6144, 6144, 6144, 6144, 6144},
+	.cap = DATA_F_LRO | DATA_F_RXFH | DATA_F_INTR_COALESCE,
+};
+
+enum dpmaif_state {
+	DPMAIF_STATE_MIN,
+	DPMAIF_STATE_PWROFF,
+	DPMAIF_STATE_PWRON,
+	DPMAIF_STATE_MAX
+};
+
+struct dpmaif_vq {
+	unsigned char q_id;
+	u32 max_len; /* align network tx qdisc 1000 */
+	struct sk_buff_head list;
+};
+
+struct dpmaif_cmd_srv {
+	struct mtk_dpmaif_ctlb *dcb;
+	struct work_struct work;
+	struct dpmaif_vq *vq;
+};
+
+struct dpmaif_tx_srv {
+	struct mtk_dpmaif_ctlb *dcb;
+	unsigned char id;
+	int prio;
+	wait_queue_head_t wait;
+	struct task_struct *srv;
+
+	unsigned long txq_drb_lack_sta;
+	unsigned char cur_vq_id;
+	unsigned char vq_cnt;
+	struct dpmaif_vq *vq[DPMAIF_TXQ_CNT_MAX];
+};
+
+struct dpmaif_drb_skb {
+	struct sk_buff *skb;
+	dma_addr_t data_dma_addr;
+	unsigned short data_len;
+	unsigned short drb_idx:13;
+	unsigned short is_msg:1;
+	unsigned short is_frag:1;
+	unsigned short is_last:1;
+};
+
+struct dpmaif_txq {
+	struct mtk_dpmaif_ctlb *dcb;
+	unsigned char id;
+	atomic_t budget;
+	atomic_t to_submit_cnt;
+	struct dpmaif_pd_drb *drb_base;
+	dma_addr_t drb_dma_addr;
+	unsigned int drb_cnt;
+	unsigned short drb_wr_idx;
+	unsigned short drb_rd_idx;
+	unsigned short drb_rel_rd_idx;
+	unsigned long long dma_map_errs;
+	unsigned short last_ch_id;
+	struct dpmaif_drb_skb *sw_drb_base;
+	unsigned int doorbell_delay;
+	struct delayed_work doorbell_work;
+	struct delayed_work tx_done_work;
+	unsigned int intr_coalesce_frame;
+};
+
+struct dpmaif_rx_record {
+	bool msg_pit_recv;
+	struct sk_buff *cur_skb;
+	struct sk_buff *lro_parent;
+	struct sk_buff *lro_last_skb;
+	unsigned int lro_pkt_cnt;
+	unsigned int cur_ch_id;
+	unsigned int checksum;
+	unsigned int hash;
+	unsigned char pit_dp;
+	unsigned char err_payload;
+};
+
+struct dpmaif_rxq {
+	struct mtk_dpmaif_ctlb *dcb;
+	unsigned char id;
+	bool started;
+	struct dpmaif_pd_pit *pit_base;
+	dma_addr_t pit_dma_addr;
+	unsigned int pit_cnt;
+	unsigned short pit_wr_idx;
+	unsigned short pit_rd_idx;
+	unsigned short pit_rel_rd_idx;
+	unsigned char pit_seq_expect;
+	unsigned int pit_rel_cnt;
+	bool pit_cnt_err_intr_set;
+	unsigned int pit_burst_rel_cnt;
+	unsigned int pit_seq_fail_cnt;
+	struct napi_struct napi;
+	struct dpmaif_rx_record rx_record;
+	unsigned int intr_coalesce_frame;
+};
+
+struct skb_mapped_t {
+	struct sk_buff *skb;
+	dma_addr_t data_dma_addr;
+	unsigned int data_len;
+};
+
+struct page_mapped_t {
+	struct page *page;
+	dma_addr_t data_dma_addr;
+	unsigned int offset;
+	unsigned int data_len;
+};
+
+union dpmaif_bat_record {
+	struct skb_mapped_t normal;
+	struct page_mapped_t frag;
+};
+
+struct dpmaif_bat_ring {
+	enum dpmaif_bat_type type;
+	struct dpmaif_bat *bat_base;
+	dma_addr_t bat_dma_addr;
+	unsigned int bat_cnt;
+	unsigned short bat_wr_idx;
+	unsigned short bat_rd_idx;
+	unsigned short bat_rel_rd_idx;
+	union dpmaif_bat_record *sw_record_base;
+	unsigned int buf_size;
+	unsigned char *mask_tbl;
+	struct work_struct reload_work;
+	bool bat_cnt_err_intr_set;
+};
+
+struct dpmaif_bat_info {
+	struct mtk_dpmaif_ctlb *dcb;
+	unsigned int max_mtu;
+	bool frag_bat_enabled;
+
+	struct dpmaif_bat_ring normal_bat_ring;
+	struct dpmaif_bat_ring frag_bat_ring;
+
+	struct workqueue_struct *reload_wq;
+};
+
+struct dpmaif_irq_param {
+	unsigned char idx;
+	struct mtk_dpmaif_ctlb *dcb;
+	enum mtk_irq_src dpmaif_irq_src;
+	int dev_irq_id;
+};
+
+struct dpmaif_tx_evt {
+	unsigned long long ul_done;
+	unsigned long long ul_drb_empty;
+};
+
+struct dpmaif_rx_evt {
+	unsigned long long dl_done;
+	unsigned long long pit_len_err;
+};
+
+struct dpmaif_other_evt {
+	unsigned long long ul_md_notready;
+	unsigned long long ul_md_pwr_notready;
+	unsigned long long ul_len_err;
+
+	unsigned long long dl_skb_len_err;
+	unsigned long long dl_bat_cnt_len_err;
+	unsigned long long dl_pkt_empty;
+	unsigned long long dl_frag_empty;
+	unsigned long long dl_mtu_err;
+	unsigned long long dl_frag_cnt_len_err;
+	unsigned long long hpc_ent_type_err;
+};
+
+struct dpmaif_traffic_stats {
+	/* txq traffic */
+	unsigned long long tx_sw_packets[DPMAIF_TXQ_CNT_MAX];
+	unsigned long long tx_hw_packets[DPMAIF_TXQ_CNT_MAX];
+	unsigned long long tx_done_last_time[DPMAIF_TXQ_CNT_MAX];
+	unsigned int tx_done_last_cnt[DPMAIF_TXQ_CNT_MAX];
+
+	/* rxq traffic */
+	unsigned long long rx_packets[DPMAIF_RXQ_CNT_MAX];
+	unsigned long long rx_errors[DPMAIF_RXQ_CNT_MAX];
+	unsigned long long rx_dropped[DPMAIF_RXQ_CNT_MAX];
+	unsigned long long rx_hw_ind_dropped[DPMAIF_RXQ_CNT_MAX];
+	unsigned long long rx_done_last_time[DPMAIF_RXQ_CNT_MAX];
+	unsigned int rx_done_last_cnt[DPMAIF_RXQ_CNT_MAX];
+
+	/* irq traffic */
+	unsigned long long irq_total_cnt[DPMAIF_IRQ_CNT_MAX];
+	unsigned long long irq_last_time[DPMAIF_IRQ_CNT_MAX];
+	struct dpmaif_tx_evt irq_tx_evt[DPMAIF_TXQ_CNT_MAX];
+	struct dpmaif_rx_evt irq_rx_evt[DPMAIF_RXQ_CNT_MAX];
+	struct dpmaif_other_evt irq_other_evt;
+};
+
+enum dpmaif_dump_flag {
+	DPMAIF_DUMP_TX_PKT = 0,
+	DPMAIF_DUMP_RX_PKT,
+	DPMAIF_DUMP_DRB,
+	DPMAIF_DUMP_PIT
+};
+
+struct mtk_dpmaif_ctlb {
+	struct mtk_data_blk *data_blk;
+	struct dpmaif_drv_info *drv_info;
+	struct napi_struct *napi[DPMAIF_RXQ_CNT_MAX];
+
+	enum dpmaif_state dpmaif_state;
+	bool dpmaif_user_ready;
+	bool trans_enabled;
+	/* lock for enable/disable routine */
+	struct mutex trans_ctl_lock;
+	const struct dpmaif_res_cfg *res_cfg;
+
+	struct dpmaif_cmd_srv cmd_srv;
+	struct dpmaif_vq cmd_vq;
+	struct dpmaif_tx_srv *tx_srvs;
+	struct dpmaif_vq *tx_vqs;
+
+	struct workqueue_struct *tx_done_wq;
+	struct workqueue_struct *tx_doorbell_wq;
+	struct dpmaif_txq *txqs;
+	struct dpmaif_rxq *rxqs;
+	struct dpmaif_bat_info bat_info;
+	bool irq_enabled;
+	struct dpmaif_irq_param *irq_params;
+
+	struct dpmaif_traffic_stats traffic_stats;
+	struct mtk_data_intr_coalesce intr_coalesce;
+};
+
+struct dpmaif_pkt_info {
+	unsigned char intf_id;
+	unsigned char drb_cnt;
+};
+
+#define DPMAIF_SKB_CB(__skb) ((struct dpmaif_pkt_info *)&((__skb)->cb[0]))
+
+#define DCB_TO_DEV(dcb) ((dcb)->data_blk->mdev->dev)
+#define DCB_TO_MDEV(dcb) ((dcb)->data_blk->mdev)
+#define DCB_TO_DEV_STR(dcb) ((dcb)->data_blk->mdev->dev_str)
+#define DPMAIF_GET_HW_VER(dcb) ((dcb)->data_blk->mdev->hw_ver)
+#define DPMAIF_GET_DRB_CNT(__skb) (skb_shinfo(__skb)->nr_frags + 1 + 1)
+
+#define DPMAIF_JUMBO_SIZE 9000
+#define DPMAIF_DFLT_MTU 3000
+#define DPMAIF_DFLT_LRO_ENABLE true
+#define DPMAIF_DL_BUF_MIN_SIZE 128
+#define DPMAIF_BUF_THRESHOLD (DPMAIF_DL_BUF_MIN_SIZE * 28) /* 3.5k, should be less than page size */
+#define DPMAIF_NORMAL_BUF_SIZE_IN_JUMBO (128 * 13) /* 1664 */
+#define DPMAIF_FRAG_BUF_SIZE_IN_JUMBO (128 * 15) /* 1920 */
+
+static bool dpmaif_lro_enable = DPMAIF_DFLT_LRO_ENABLE;
+
+static unsigned int mtk_dpmaif_ring_buf_get_next_idx(unsigned int buf_len, unsigned int buf_idx)
+{
+	return (++buf_idx) % buf_len;
+}
+
+static unsigned int mtk_dpmaif_ring_buf_readable(unsigned int total_cnt, unsigned int rd_idx,
+						 unsigned int  wr_idx)
+{
+	unsigned int pkt_cnt;
+
+	if (wr_idx >= rd_idx)
+		pkt_cnt = wr_idx - rd_idx;
+	else
+		pkt_cnt = total_cnt + wr_idx - rd_idx;
+
+	return pkt_cnt;
+}
+
+static unsigned int mtk_dpmaif_ring_buf_writable(unsigned int total_cnt, unsigned int rel_idx,
+						 unsigned int wr_idx)
+{
+	unsigned int pkt_cnt;
+
+	if (wr_idx < rel_idx)
+		pkt_cnt = rel_idx - wr_idx - 1;
+	else
+		pkt_cnt = total_cnt + rel_idx - wr_idx - 1;
+
+	return pkt_cnt;
+}
+
+static unsigned int mtk_dpmaif_ring_buf_releasable(unsigned int total_cnt, unsigned int rel_idx,
+						   unsigned int rd_idx)
+{
+	unsigned int pkt_cnt;
+
+	if (rel_idx <= rd_idx)
+		pkt_cnt = rd_idx - rel_idx;
+	else
+		pkt_cnt = total_cnt + rd_idx - rel_idx;
+
+	return pkt_cnt;
+}
+
+static void mtk_dpmaif_trigger_dev_exception(struct mtk_dpmaif_ctlb *dcb)
+{
+	mtk_hw_send_ext_evt(DCB_TO_MDEV(dcb), EXT_EVT_H2D_RESERVED_FOR_DPMAIF);
+}
+
+static void mtk_dpmaif_common_err_handle(struct mtk_dpmaif_ctlb *dcb, bool is_hw)
+{
+	if (!is_hw) {
+		dev_err(DCB_TO_DEV(dcb), "ASSERT file: %s, function: %s, line %d",
+			__FILE__, __func__, __LINE__);
+		return;
+	}
+
+	if (mtk_hw_mmio_check(DCB_TO_MDEV(dcb)))
+		dev_err(DCB_TO_DEV(dcb), "Failed to access mmio\n");
+	else
+		mtk_dpmaif_trigger_dev_exception(dcb);
+}
+
+static unsigned int mtk_dpmaif_pit_bid(struct dpmaif_pd_pit *pit_info)
+{
+	unsigned int buf_id = FIELD_GET(PIT_PD_H_BID, le32_to_cpu(pit_info->pd_footer)) << 13;
+
+	return buf_id + FIELD_GET(PIT_PD_BUF_ID, le32_to_cpu(pit_info->pd_header));
+}
+
+static void mtk_dpmaif_disable_irq(struct mtk_dpmaif_ctlb *dcb)
+{
+	unsigned char irq_cnt = dcb->res_cfg->irq_cnt;
+	struct dpmaif_irq_param *irq_param;
+	int i;
+
+	if (!dcb->irq_enabled)
+		return;
+
+	dcb->irq_enabled = false;
+	for (i = 0; i < irq_cnt; i++) {
+		irq_param = &dcb->irq_params[i];
+		if (mtk_hw_mask_irq(DCB_TO_MDEV(dcb), irq_param->dev_irq_id) != 0)
+			dev_err(DCB_TO_DEV(dcb), "Failed to mask dev irq%d\n",
+				irq_param->dev_irq_id);
+	}
+}
+
+static void mtk_dpmaif_enable_irq(struct mtk_dpmaif_ctlb *dcb)
+{
+	unsigned char irq_cnt = dcb->res_cfg->irq_cnt;
+	struct dpmaif_irq_param *irq_param;
+	int i;
+
+	if (dcb->irq_enabled)
+		return;
+
+	dcb->irq_enabled = true;
+	for (i = 0; i < irq_cnt; i++) {
+		irq_param = &dcb->irq_params[i];
+		if (mtk_hw_unmask_irq(DCB_TO_MDEV(dcb), irq_param->dev_irq_id) != 0)
+			dev_err(DCB_TO_DEV(dcb), "Failed to unmask dev irq%d\n",
+				irq_param->dev_irq_id);
+	}
+}
+
+static int mtk_dpmaif_set_rx_bat(struct mtk_dpmaif_ctlb *dcb, struct dpmaif_bat_ring *bat_ring,
+				 unsigned int bat_cnt)
+{
+	unsigned short old_sw_rel_rd_idx, new_sw_wr_idx, old_sw_wr_idx;
+	int ret = 0;
+
+	old_sw_rel_rd_idx = bat_ring->bat_rel_rd_idx;
+	old_sw_wr_idx = bat_ring->bat_wr_idx;
+	new_sw_wr_idx = old_sw_wr_idx + bat_cnt;
+
+	/* bat_wr_idx should not exceed bat_rel_rd_idx. */
+	if (old_sw_rel_rd_idx > old_sw_wr_idx) {
+		if (new_sw_wr_idx >= old_sw_rel_rd_idx)
+			ret = -DATA_FLOW_CHK_ERR;
+	} else {
+		if (new_sw_wr_idx >= bat_ring->bat_cnt) {
+			new_sw_wr_idx = new_sw_wr_idx - bat_ring->bat_cnt;
+			if (new_sw_wr_idx >= old_sw_rel_rd_idx)
+				ret = -DATA_FLOW_CHK_ERR;
+		}
+	}
+
+	if (ret < 0) {
+		dev_err(DCB_TO_DEV(dcb),
+			"Failed to check bat, new_sw_wr_idx=%u, old_sw_rl_idx=%u\n",
+			new_sw_wr_idx, old_sw_rel_rd_idx);
+		goto out;
+	}
+
+	bat_ring->bat_wr_idx = new_sw_wr_idx;
+out:
+	return ret;
+}
+
+static int mtk_dpmaif_reload_rx_skb(struct mtk_dpmaif_ctlb *dcb,
+				    struct dpmaif_bat_ring *bat_ring, unsigned int buf_cnt)
+{
+	union dpmaif_bat_record *cur_bat_record;
+	struct skb_mapped_t *skb_info;
+	unsigned short cur_bat_idx;
+	struct dpmaif_bat *cur_bat;
+	unsigned int i;
+	int ret;
+
+	/* Pin rx buffers to BAT entries */
+	cur_bat_idx = bat_ring->bat_wr_idx;
+	for (i = 0 ; i < buf_cnt; i++) {
+		/* For re-init flow, in re-init flow, we don't release
+		 * the rx buffer on FSM_STATE_OFF state.
+		 * because we will pin rx buffers to BAT entries
+		 * again on FSM_STATE_BOOTUP state.
+		 */
+		cur_bat_record = bat_ring->sw_record_base + cur_bat_idx;
+		skb_info = &cur_bat_record->normal;
+		if (!skb_info->skb) {
+			skb_info->skb = __dev_alloc_skb(dcb->bat_info.normal_bat_ring.buf_size,
+							GFP_KERNEL);
+			if (unlikely(!skb_info->skb)) {
+				dev_err(DCB_TO_DEV(dcb), "Failed to alloc skb, bat%d buf_cnt:%u/%u\n",
+					bat_ring->type, buf_cnt, i);
+				break;
+			}
+
+			skb_info->data_len = bat_ring->buf_size;
+			skb_info->data_dma_addr = dma_map_single(DCB_TO_MDEV(dcb)->dev,
+								 skb_info->skb->data,
+								 skb_info->data_len,
+								 DMA_FROM_DEVICE);
+			ret = dma_mapping_error(DCB_TO_MDEV(dcb)->dev, skb_info->data_dma_addr);
+			if (unlikely(ret)) {
+				dev_err(DCB_TO_MDEV(dcb)->dev, "Failed to map dma!\n");
+				dev_kfree_skb_any(skb_info->skb);
+				skb_info->skb = NULL;
+				break;
+			}
+		}
+
+		cur_bat = bat_ring->bat_base + cur_bat_idx;
+		cur_bat->buf_addr_high = cpu_to_le32(upper_32_bits(skb_info->data_dma_addr));
+		cur_bat->buf_addr_low = cpu_to_le32(lower_32_bits(skb_info->data_dma_addr));
+
+		cur_bat_idx = mtk_dpmaif_ring_buf_get_next_idx(bat_ring->bat_cnt, cur_bat_idx);
+	}
+
+	ret = i;
+	if (unlikely(ret == 0))
+		ret = -DATA_LOW_MEM_SKB;
+
+	return ret;
+}
+
+static int mtk_dpmaif_reload_rx_page(struct mtk_dpmaif_ctlb *dcb,
+				     struct dpmaif_bat_ring *bat_ring, unsigned int buf_cnt)
+{
+	union dpmaif_bat_record *cur_bat_record;
+	struct page_mapped_t *page_info;
+	unsigned short cur_bat_idx;
+	struct dpmaif_bat *cur_bat;
+	unsigned int i;
+	void *data;
+	int ret;
+
+	/* Pin rx buffers to BAT entries */
+	cur_bat_idx = bat_ring->bat_wr_idx;
+	for (i = 0 ; i < buf_cnt; i++) {
+		/* For re-init flow, In re-init flow, we don't release
+		 * the rx buffer on FSM_STATE_OFF state.
+		 * because we will pin rx buffers to BAT
+		 * entries again on FSM_STATE_BOOTUP state.
+		 */
+		cur_bat_record = bat_ring->sw_record_base + cur_bat_idx;
+		page_info = &cur_bat_record->frag;
+
+		if (!page_info->page) {
+			data = netdev_alloc_frag(dcb->bat_info.frag_bat_ring.buf_size);
+			if (unlikely(!data)) {
+				dev_err(DCB_TO_DEV(dcb), "Failed to alloc page, bat%d buf_cnt:%u/%u\n",
+					bat_ring->type, buf_cnt, i);
+				break;
+			}
+
+			page_info->page = virt_to_head_page(data);
+			page_info->offset = data - page_address(page_info->page);
+			page_info->data_len = bat_ring->buf_size;
+			page_info->data_dma_addr = dma_map_page(DCB_TO_MDEV(dcb)->dev,
+								page_info->page,
+								page_info->offset,
+								page_info->data_len,
+								DMA_FROM_DEVICE);
+			ret = dma_mapping_error(DCB_TO_MDEV(dcb)->dev, page_info->data_dma_addr);
+			if (unlikely(ret)) {
+				dev_err(DCB_TO_MDEV(dcb)->dev, "Failed to map dma!\n");
+				put_page(page_info->page);
+				page_info->page = NULL;
+				break;
+			}
+		}
+
+		cur_bat = bat_ring->bat_base + cur_bat_idx;
+		cur_bat->buf_addr_high = cpu_to_le32(upper_32_bits(page_info->data_dma_addr));
+		cur_bat->buf_addr_low = cpu_to_le32(lower_32_bits(page_info->data_dma_addr));
+		cur_bat_idx = mtk_dpmaif_ring_buf_get_next_idx(bat_ring->bat_cnt, cur_bat_idx);
+	}
+
+	ret = i;
+	if (unlikely(ret == 0))
+		ret = -DATA_LOW_MEM_SKB;
+
+	return ret;
+}
+
+static int mtk_dpmaif_reload_rx_buf(struct mtk_dpmaif_ctlb *dcb,
+				    struct dpmaif_bat_ring *bat_ring,
+				    unsigned int buf_cnt, bool send_doorbell)
+{
+	unsigned int reload_cnt, bat_cnt;
+	int ret;
+
+	if (unlikely(buf_cnt == 0 || buf_cnt > bat_ring->bat_cnt)) {
+		dev_err(DCB_TO_DEV(dcb), "Invalid alloc bat buffer count\n");
+		return -DATA_FLOW_CHK_ERR;
+	}
+
+	/* Get bat count that be reloaded rx buffer and check
+	 * Rx buffer count should not be greater than bat entry count,
+	 * because one rx buffer is pined to one bat entry.
+	 */
+	bat_cnt = mtk_dpmaif_ring_buf_writable(bat_ring->bat_cnt, bat_ring->bat_rel_rd_idx,
+					       bat_ring->bat_wr_idx);
+	if (unlikely(buf_cnt > bat_cnt)) {
+		dev_err(DCB_TO_DEV(dcb),
+			"Invalid parameter,bat%d: rx_buff>bat_entries(%u>%u), w/r/rel-%u,%u,%u\n",
+			bat_ring->type, buf_cnt, bat_cnt, bat_ring->bat_wr_idx,
+			bat_ring->bat_rd_idx, bat_ring->bat_rel_rd_idx);
+		return -DATA_FLOW_CHK_ERR;
+	}
+
+	/* Allocate rx buffer and pin it to bat entry. */
+	if (bat_ring->type == NORMAL_BAT)
+		ret = mtk_dpmaif_reload_rx_skb(dcb, bat_ring, buf_cnt);
+	else
+		ret = mtk_dpmaif_reload_rx_page(dcb, bat_ring, buf_cnt);
+
+	if (ret < 0)
+		return -DATA_LOW_MEM_SKB;
+
+	/* Check and update bat_wr_idx */
+	reload_cnt = ret;
+	ret = mtk_dpmaif_set_rx_bat(dcb, bat_ring, reload_cnt);
+	if (unlikely(ret < 0)) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to update bat_wr_idx\n");
+		goto out;
+	}
+
+	/* Make sure all frag bat information write done before notify HW. */
+	dma_wmb();
+
+	/* Notify hw the available frag bat buffer count. */
+	if (send_doorbell) {
+		if (bat_ring->type == NORMAL_BAT)
+			ret = mtk_dpmaif_drv_send_doorbell(dcb->drv_info, DPMAIF_BAT,
+							   0, reload_cnt);
+		else
+			ret = mtk_dpmaif_drv_send_doorbell(dcb->drv_info, DPMAIF_FRAG,
+							   0, reload_cnt);
+		if (unlikely(ret < 0)) {
+			dev_err(DCB_TO_DEV(dcb), "Failed to send frag bat doorbell\n");
+			mtk_dpmaif_common_err_handle(dcb, true);
+			goto out;
+		}
+	}
+
+	return 0;
+out:
+	return ret;
+}
+
+static unsigned int mtk_dpmaif_chk_rel_bat_cnt(struct mtk_dpmaif_ctlb *dcb,
+					       struct dpmaif_bat_ring *bat_ring)
+{
+	unsigned int i, cur_idx;
+	unsigned int count = 0;
+	unsigned char mask_val;
+
+	/* Check and get the continuous used entries,
+	 * and it is also the count that will be recycle.
+	 */
+	cur_idx = bat_ring->bat_rel_rd_idx;
+	for (i = 0; i < bat_ring->bat_cnt; i++) {
+		mask_val = bat_ring->mask_tbl[cur_idx];
+		if (mask_val == 1)
+			count++;
+		else
+			break;
+
+		cur_idx = mtk_dpmaif_ring_buf_get_next_idx(bat_ring->bat_cnt, cur_idx);
+	}
+
+	return count;
+}
+
+static int mtk_dpmaif_recycle_bat(struct mtk_dpmaif_ctlb *dcb, struct dpmaif_bat_ring *bat_ring,
+				  unsigned int rel_bat_cnt)
+{
+	unsigned short old_sw_rel_idx, new_sw_rel_idx, hw_rd_idx;
+	bool type = bat_ring->type == NORMAL_BAT;
+	unsigned int cur_idx;
+	unsigned int i;
+	int ret;
+
+	old_sw_rel_idx = bat_ring->bat_rel_rd_idx;
+	new_sw_rel_idx = old_sw_rel_idx + rel_bat_cnt;
+
+	ret = mtk_dpmaif_drv_get_ring_idx(dcb->drv_info,
+					  type ? DPMAIF_BAT_RIDX : DPMAIF_FRAG_RIDX, 0);
+	if (unlikely(ret < 0)) {
+		mtk_dpmaif_common_err_handle(dcb, true);
+		return ret;
+	}
+
+	hw_rd_idx = ret;
+	bat_ring->bat_rd_idx = hw_rd_idx;
+
+	/* Queue is empty and no need to release. */
+	if (bat_ring->bat_wr_idx == old_sw_rel_idx) {
+		ret = -DATA_FLOW_CHK_ERR;
+		goto out;
+	}
+
+	/* bat_rel_rd_idx should not exceed bat_rd_idx. */
+	if (hw_rd_idx > old_sw_rel_idx) {
+		if (new_sw_rel_idx > hw_rd_idx) {
+			ret = -DATA_FLOW_CHK_ERR;
+			goto out;
+		}
+	} else if (hw_rd_idx < old_sw_rel_idx) {
+		if (new_sw_rel_idx >= bat_ring->bat_cnt) {
+			new_sw_rel_idx = new_sw_rel_idx - bat_ring->bat_cnt;
+			if (new_sw_rel_idx > hw_rd_idx) {
+				ret = -DATA_FLOW_CHK_ERR;
+				goto out;
+			}
+		}
+	}
+
+	/* Reset bat mask value. */
+	cur_idx = bat_ring->bat_rel_rd_idx;
+	for (i = 0; i < rel_bat_cnt; i++) {
+		bat_ring->mask_tbl[cur_idx] = 0;
+		cur_idx = mtk_dpmaif_ring_buf_get_next_idx(bat_ring->bat_cnt, cur_idx);
+	}
+
+	bat_ring->bat_rel_rd_idx = new_sw_rel_idx;
+
+	return rel_bat_cnt;
+
+out:
+	dev_err(DCB_TO_DEV(dcb),
+		"Failed to check bat%d rel_rd_idx, bat_rd=%u,old_sw_rel=%u, new_sw_rel=%u\n",
+		bat_ring->type, bat_ring->bat_rd_idx, old_sw_rel_idx, new_sw_rel_idx);
+
+	return ret;
+}
+
+static int mtk_dpmaif_reload_bat(struct mtk_dpmaif_ctlb *dcb, struct dpmaif_bat_ring *bat_ring)
+{
+	unsigned int rel_bat_cnt;
+	int ret = 0;
+
+	rel_bat_cnt = mtk_dpmaif_chk_rel_bat_cnt(dcb, bat_ring);
+	if (unlikely(rel_bat_cnt == 0))
+		goto out;
+
+	/* Check and update bat_rd_idx, bat_rel_rd_idx. */
+	ret = mtk_dpmaif_recycle_bat(dcb, bat_ring, rel_bat_cnt);
+	if (unlikely(ret < 0))
+		goto out;
+
+	/* Reload rx buffer, pin buffer to bat entries.
+	 * update bat_wr_idx
+	 * send doorbell to HW about new available BAT entries.
+	 */
+	ret = mtk_dpmaif_reload_rx_buf(dcb, bat_ring, rel_bat_cnt, true);
+out:
+	return ret;
+}
+
+static void mtk_dpmaif_bat_reload_work(struct work_struct *work)
+{
+	struct dpmaif_bat_ring *bat_ring;
+	struct dpmaif_bat_info *bat_info;
+	struct mtk_dpmaif_ctlb *dcb;
+	int ret;
+
+	bat_ring = container_of(work, struct dpmaif_bat_ring, reload_work);
+
+	if (bat_ring->type == NORMAL_BAT)
+		bat_info = container_of(bat_ring, struct dpmaif_bat_info, normal_bat_ring);
+	else
+		bat_info = container_of(bat_ring, struct dpmaif_bat_info, frag_bat_ring);
+
+	dcb = bat_info->dcb;
+
+	if (bat_ring->type == NORMAL_BAT) {
+		/* Recycle normal bat and reload rx normal buffer. */
+		ret = mtk_dpmaif_reload_bat(dcb, bat_ring);
+		if (unlikely(ret < 0)) {
+			dev_err(DCB_TO_DEV(dcb),
+				"Failed to recycle normal bat and reload rx buffer\n");
+			return;
+		}
+
+		if (bat_ring->bat_cnt_err_intr_set) {
+			bat_ring->bat_cnt_err_intr_set = false;
+			mtk_dpmaif_drv_intr_complete(dcb->drv_info,
+						     DPMAIF_INTR_DL_BATCNT_LEN_ERR, 0, 0);
+		}
+	} else {
+		/* Recycle frag bat and reload rx page buffer. */
+		if (dcb->bat_info.frag_bat_enabled) {
+			ret = mtk_dpmaif_reload_bat(dcb, bat_ring);
+			if (unlikely(ret < 0)) {
+				dev_err(DCB_TO_DEV(dcb),
+					"Failed to recycle frag bat and reload rx buffer\n");
+				return;
+			}
+
+			if (bat_ring->bat_cnt_err_intr_set) {
+				bat_ring->bat_cnt_err_intr_set = false;
+				mtk_dpmaif_drv_intr_complete(dcb->drv_info,
+							     DPMAIF_INTR_DL_FRGCNT_LEN_ERR, 0, 0);
+			}
+		}
+	}
+}
+
+static void mtk_dpmaif_queue_bat_reload_work(struct mtk_dpmaif_ctlb *dcb)
+{
+	/* Recycle normal bat and reload rx skb buffer. */
+	queue_work(dcb->bat_info.reload_wq, &dcb->bat_info.normal_bat_ring.reload_work);
+	/* Recycle frag bat and reload rx page buffer. */
+	if (dcb->bat_info.frag_bat_enabled)
+		queue_work(dcb->bat_info.reload_wq, &dcb->bat_info.frag_bat_ring.reload_work);
+}
+
+static void mtk_dpmaif_set_bat_buf_size(struct mtk_dpmaif_ctlb *dcb, unsigned int mtu)
+{
+	struct dpmaif_bat_info *bat_info = &dcb->bat_info;
+	unsigned int buf_size;
+
+	bat_info->max_mtu = mtu;
+
+	/* Normal and frag BAT buffer size setting. */
+	buf_size = mtu + DPMAIF_HW_PKT_ALIGN + DPMAIF_HW_BAT_RSVLEN;
+	if (buf_size <= DPMAIF_BUF_THRESHOLD) {
+		bat_info->frag_bat_enabled = false;
+		bat_info->normal_bat_ring.buf_size = ALIGN(buf_size, DPMAIF_DL_BUF_MIN_SIZE);
+		bat_info->frag_bat_ring.buf_size = 0;
+	} else {
+		bat_info->frag_bat_enabled = true;
+		bat_info->normal_bat_ring.buf_size = DPMAIF_NORMAL_BUF_SIZE_IN_JUMBO;
+		bat_info->frag_bat_ring.buf_size = DPMAIF_FRAG_BUF_SIZE_IN_JUMBO;
+	}
+}
+
+static int mtk_dpmaif_bat_init(struct mtk_dpmaif_ctlb *dcb,
+			       struct dpmaif_bat_ring *bat_ring,
+			       enum dpmaif_bat_type type)
+{
+	int ret;
+
+	bat_ring->type = type;
+	if (bat_ring->type == FRAG_BAT)
+		bat_ring->bat_cnt = dcb->res_cfg->frag_bat_cnt;
+	else
+		bat_ring->bat_cnt = dcb->res_cfg->normal_bat_cnt;
+
+	bat_ring->bat_cnt_err_intr_set = false;
+	bat_ring->bat_rd_idx = 0;
+	bat_ring->bat_wr_idx = 0;
+	bat_ring->bat_rel_rd_idx = 0;
+
+	/* Allocate BAT memory for HW and SW. */
+	bat_ring->bat_base = dma_alloc_coherent(DCB_TO_DEV(dcb), bat_ring->bat_cnt *
+						sizeof(*bat_ring->bat_base),
+						&bat_ring->bat_dma_addr, GFP_KERNEL);
+	if (!bat_ring->bat_base) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to allocate bat%d\n", bat_ring->type);
+		return -ENOMEM;
+	}
+
+	/* Allocate buffer for SW to record skb information */
+	bat_ring->sw_record_base = devm_kcalloc(DCB_TO_DEV(dcb), bat_ring->bat_cnt,
+						sizeof(*bat_ring->sw_record_base), GFP_KERNEL);
+	if (!bat_ring->sw_record_base) {
+		ret = -ENOMEM;
+		goto err_alloc_bat_buf;
+	}
+
+	/* Alloc buffer for SW to recycle BAT. */
+	bat_ring->mask_tbl = devm_kcalloc(DCB_TO_DEV(dcb), bat_ring->bat_cnt,
+					  sizeof(*bat_ring->mask_tbl), GFP_KERNEL);
+	if (!bat_ring->mask_tbl) {
+		ret = -ENOMEM;
+		goto err_alloc_mask_tbl;
+	}
+
+	INIT_WORK(&bat_ring->reload_work, mtk_dpmaif_bat_reload_work);
+
+	return 0;
+
+err_alloc_mask_tbl:
+	devm_kfree(DCB_TO_DEV(dcb), bat_ring->sw_record_base);
+	bat_ring->sw_record_base = NULL;
+
+err_alloc_bat_buf:
+	dma_free_coherent(DCB_TO_DEV(dcb), bat_ring->bat_cnt * sizeof(*bat_ring->bat_base),
+			  bat_ring->bat_base, bat_ring->bat_dma_addr);
+	bat_ring->bat_base = NULL;
+
+	return ret;
+}
+
+static void mtk_dpmaif_bat_exit(struct mtk_dpmaif_ctlb *dcb, struct dpmaif_bat_ring *bat_ring,
+				enum dpmaif_bat_type type)
+{
+	union dpmaif_bat_record *bat_record;
+	struct page *page;
+	unsigned int i;
+
+	flush_work(&bat_ring->reload_work);
+
+	devm_kfree(DCB_TO_DEV(dcb), bat_ring->mask_tbl);
+	bat_ring->mask_tbl = NULL;
+
+	if (bat_ring->sw_record_base) {
+		if (type == NORMAL_BAT) {
+			for (i = 0; i < bat_ring->bat_cnt; i++) {
+				bat_record = bat_ring->sw_record_base + i;
+				if (bat_record->normal.skb) {
+					dma_unmap_single(DCB_TO_DEV(dcb),
+							 bat_record->normal.data_dma_addr,
+							 bat_record->normal.data_len,
+							 DMA_FROM_DEVICE);
+					dev_kfree_skb_any(bat_record->normal.skb);
+				}
+			}
+		} else {
+			for (i = 0; i < bat_ring->bat_cnt; i++) {
+				bat_record = bat_ring->sw_record_base + i;
+				page = bat_record->frag.page;
+				if (page) {
+					dma_unmap_page(DCB_TO_DEV(dcb),
+						       bat_record->frag.data_dma_addr,
+						       bat_record->frag.data_len,
+						       DMA_FROM_DEVICE);
+					put_page(page);
+				}
+			}
+		}
+
+		devm_kfree(DCB_TO_DEV(dcb), bat_ring->sw_record_base);
+		bat_ring->sw_record_base = NULL;
+	}
+
+	if (bat_ring->bat_base) {
+		dma_free_coherent(DCB_TO_DEV(dcb),
+				  bat_ring->bat_cnt * sizeof(*bat_ring->bat_base),
+				  bat_ring->bat_base, bat_ring->bat_dma_addr);
+		bat_ring->bat_base = NULL;
+	}
+}
+
+static void mtk_dpmaif_bat_ring_reset(struct dpmaif_bat_ring *bat_ring)
+{
+	bat_ring->bat_cnt_err_intr_set = false;
+	bat_ring->bat_wr_idx = 0;
+	bat_ring->bat_rd_idx = 0;
+	bat_ring->bat_rel_rd_idx = 0;
+	memset(bat_ring->bat_base, 0x00, (bat_ring->bat_cnt * sizeof(*bat_ring->bat_base)));
+	memset(bat_ring->mask_tbl, 0x00, (bat_ring->bat_cnt * sizeof(*bat_ring->mask_tbl)));
+}
+
+static void mtk_dpmaif_bat_res_reset(struct dpmaif_bat_info *bat_info)
+{
+	mtk_dpmaif_bat_ring_reset(&bat_info->normal_bat_ring);
+	if (bat_info->frag_bat_enabled)
+		mtk_dpmaif_bat_ring_reset(&bat_info->frag_bat_ring);
+}
+
+static int mtk_dpmaif_bat_res_init(struct mtk_dpmaif_ctlb *dcb)
+{
+	struct dpmaif_bat_info *bat_info = &dcb->bat_info;
+	int ret;
+
+	bat_info->dcb = dcb;
+	ret = mtk_dpmaif_bat_init(dcb, &bat_info->normal_bat_ring, NORMAL_BAT);
+	if (ret < 0) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to initialize normal bat resource\n");
+		goto out;
+	}
+
+	if (bat_info->frag_bat_enabled) {
+		ret = mtk_dpmaif_bat_init(dcb, &bat_info->frag_bat_ring, FRAG_BAT);
+		if (ret < 0) {
+			dev_err(DCB_TO_DEV(dcb), "Failed to initialize frag bat resource\n");
+			goto err_init_frag_bat;
+		}
+	}
+
+	bat_info->reload_wq =
+		alloc_workqueue("dpmaif_bat_reload_wq_%s", WQ_HIGHPRI | WQ_UNBOUND |
+				WQ_MEM_RECLAIM, FRAG_BAT + 1, DCB_TO_DEV_STR(dcb));
+	if (!bat_info->reload_wq) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to allocate bat reload workqueue\n");
+		ret = -ENOMEM;
+		goto err_init_reload_wq;
+	}
+
+	return 0;
+
+err_init_reload_wq:
+	mtk_dpmaif_bat_exit(dcb, &bat_info->frag_bat_ring, FRAG_BAT);
+
+err_init_frag_bat:
+	mtk_dpmaif_bat_exit(dcb, &bat_info->normal_bat_ring, NORMAL_BAT);
+
+out:
+	return ret;
+}
+
+static void mtk_dpmaif_bat_res_exit(struct mtk_dpmaif_ctlb *dcb)
+{
+	struct dpmaif_bat_info *bat_info = &dcb->bat_info;
+
+	if (bat_info->reload_wq) {
+		flush_workqueue(bat_info->reload_wq);
+		destroy_workqueue(bat_info->reload_wq);
+		bat_info->reload_wq = NULL;
+	}
+
+	if (bat_info->frag_bat_enabled)
+		mtk_dpmaif_bat_exit(dcb, &bat_info->frag_bat_ring, FRAG_BAT);
+
+	mtk_dpmaif_bat_exit(dcb, &bat_info->normal_bat_ring, NORMAL_BAT);
+}
+
+static int mtk_dpmaif_rxq_init(struct mtk_dpmaif_ctlb *dcb, struct dpmaif_rxq *rxq)
+{
+	rxq->started = false;
+	rxq->pit_cnt = dcb->res_cfg->pit_cnt[rxq->id];
+	rxq->pit_wr_idx = 0;
+	rxq->pit_rd_idx = 0;
+	rxq->pit_rel_rd_idx = 0;
+	rxq->pit_seq_expect = 0;
+	rxq->pit_rel_cnt = 0;
+	rxq->pit_cnt_err_intr_set = false;
+	rxq->pit_burst_rel_cnt = DPMAIF_PIT_CNT_UPDATE_THRESHOLD;
+	rxq->intr_coalesce_frame = dcb->intr_coalesce.rx_coalesced_frames;
+	rxq->pit_seq_fail_cnt = 0;
+
+	memset(&rxq->rx_record, 0x00, sizeof(rxq->rx_record));
+
+	rxq->pit_base = dma_alloc_coherent(DCB_TO_DEV(dcb),
+					   rxq->pit_cnt * sizeof(*rxq->pit_base),
+					   &rxq->pit_dma_addr, GFP_KERNEL);
+	if (!rxq->pit_base) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to allocate rxq%u pit resource\n", rxq->id);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void mtk_dpmaif_rxq_exit(struct mtk_dpmaif_ctlb *dcb, struct dpmaif_rxq *rxq)
+{
+	if (rxq->pit_base) {
+		dma_free_coherent(DCB_TO_DEV(dcb),
+				  rxq->pit_cnt * sizeof(*rxq->pit_base), rxq->pit_base,
+				  rxq->pit_dma_addr);
+		rxq->pit_base = NULL;
+	}
+}
+
+static int mtk_dpmaif_sw_stop_rxq(struct mtk_dpmaif_ctlb *dcb, struct dpmaif_rxq *rxq)
+{
+	/* Rxq done process will check this flag, if rxq->started is false, process will stop. */
+	rxq->started = false;
+
+	/* Make sure rxq->started value update done. */
+	smp_mb();
+
+	/* Wait rxq process done. */
+	napi_synchronize(&rxq->napi);
+
+	return 0;
+}
+
+static void mtk_dpmaif_sw_stop_rx(struct mtk_dpmaif_ctlb *dcb)
+{
+	unsigned char rxq_cnt = dcb->res_cfg->rxq_cnt;
+	struct dpmaif_rxq *rxq;
+	int i;
+
+	/* Stop all rx process. */
+	for (i = 0; i < rxq_cnt; i++) {
+		rxq = &dcb->rxqs[i];
+		mtk_dpmaif_sw_stop_rxq(dcb, rxq);
+	}
+}
+
+static void mtk_dpmaif_sw_start_rx(struct mtk_dpmaif_ctlb *dcb)
+{
+	unsigned char rxq_cnt = dcb->res_cfg->rxq_cnt;
+	struct dpmaif_rxq *rxq;
+	int i;
+
+	for (i = 0; i < rxq_cnt; i++) {
+		rxq = &dcb->rxqs[i];
+		rxq->started = true;
+	}
+}
+
+static void mtk_dpmaif_sw_reset_rxq(struct dpmaif_rxq *rxq)
+{
+	memset(rxq->pit_base, 0x00, (rxq->pit_cnt * sizeof(*rxq->pit_base)));
+	memset(&rxq->rx_record, 0x00, sizeof(rxq->rx_record));
+
+	rxq->started = false;
+	rxq->pit_wr_idx = 0;
+	rxq->pit_rd_idx = 0;
+	rxq->pit_rel_rd_idx = 0;
+	rxq->pit_seq_expect = 0;
+	rxq->pit_rel_cnt = 0;
+	rxq->pit_cnt_err_intr_set = false;
+	rxq->pit_seq_fail_cnt = 0;
+}
+
+static void mtk_dpmaif_rx_res_reset(struct mtk_dpmaif_ctlb *dcb)
+{
+	unsigned char rxq_cnt = dcb->res_cfg->rxq_cnt;
+	struct dpmaif_rxq *rxq;
+	int i;
+
+	for (i = 0; i < rxq_cnt; i++) {
+		rxq = &dcb->rxqs[i];
+		mtk_dpmaif_sw_reset_rxq(rxq);
+	}
+}
+
+static int mtk_dpmaif_rx_res_init(struct mtk_dpmaif_ctlb *dcb)
+{
+	unsigned char rxq_cnt = dcb->res_cfg->rxq_cnt;
+	struct dpmaif_rxq *rxq;
+	int i, j;
+	int ret;
+
+	dcb->rxqs = devm_kcalloc(DCB_TO_DEV(dcb), rxq_cnt, sizeof(*rxq), GFP_KERNEL);
+	if (!dcb->rxqs)
+		return -ENOMEM;
+
+	for (i = 0; i < rxq_cnt; i++) {
+		rxq = &dcb->rxqs[i];
+		rxq->id = i;
+		rxq->dcb = dcb;
+		ret = mtk_dpmaif_rxq_init(dcb, rxq);
+		if (ret < 0) {
+			dev_err(DCB_TO_DEV(dcb), "Failed to init rxq%u resource\n", rxq->id);
+			goto err_init_rxq;
+		}
+	}
+
+	return 0;
+
+err_init_rxq:
+	for (j = i - 1; j >= 0; j--)
+		mtk_dpmaif_rxq_exit(dcb, &dcb->rxqs[j]);
+
+	devm_kfree(DCB_TO_DEV(dcb), dcb->rxqs);
+	dcb->rxqs = NULL;
+
+	return ret;
+}
+
+static void mtk_dpmaif_rx_res_exit(struct mtk_dpmaif_ctlb *dcb)
+{
+	unsigned char rxq_cnt = dcb->res_cfg->rxq_cnt;
+	int i;
+
+	for (i = 0; i < rxq_cnt; i++)
+		mtk_dpmaif_rxq_exit(dcb, &dcb->rxqs[i]);
+
+	devm_kfree(DCB_TO_DEV(dcb), dcb->rxqs);
+	dcb->rxqs = NULL;
+}
+
+static void mtk_dpmaif_tx_doorbell(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct mtk_dpmaif_ctlb *dcb;
+	unsigned int to_submit_cnt;
+	struct dpmaif_txq *txq;
+	int ret;
+
+	txq = container_of(dwork, struct dpmaif_txq, doorbell_work);
+	dcb = txq->dcb;
+
+	to_submit_cnt = atomic_read(&txq->to_submit_cnt);
+
+	if (to_submit_cnt > 0) {
+		ret = mtk_dpmaif_drv_send_doorbell(dcb->drv_info, DPMAIF_DRB,
+						   txq->id, to_submit_cnt);
+		if (unlikely(ret < 0)) {
+			dev_err(DCB_TO_DEV(dcb), "Failed to send txq%u doorbell\n", txq->id);
+			mtk_dpmaif_common_err_handle(dcb, true);
+		}
+
+		atomic_sub(to_submit_cnt, &txq->to_submit_cnt);
+	}
+}
+
+static unsigned int mtk_dpmaif_poll_tx_drb(struct dpmaif_txq *txq)
+{
+	unsigned short old_sw_rd_idx, new_hw_rd_idx;
+	struct mtk_dpmaif_ctlb *dcb = txq->dcb;
+	unsigned int drb_cnt;
+	int ret;
+
+	old_sw_rd_idx = txq->drb_rd_idx;
+	ret = mtk_dpmaif_drv_get_ring_idx(dcb->drv_info, DPMAIF_DRB_RIDX, txq->id);
+	if (unlikely(ret < 0)) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to read txq%u drb_rd_idx, ret=%d\n", txq->id, ret);
+		mtk_dpmaif_common_err_handle(dcb, true);
+		return 0;
+	}
+
+	new_hw_rd_idx = ret;
+
+	if (old_sw_rd_idx <= new_hw_rd_idx)
+		drb_cnt = new_hw_rd_idx - old_sw_rd_idx;
+	else
+		drb_cnt = txq->drb_cnt - old_sw_rd_idx + new_hw_rd_idx;
+
+	txq->drb_rd_idx = new_hw_rd_idx;
+
+	return drb_cnt;
+}
+
+static int mtk_dpmaif_tx_rel_internal(struct dpmaif_txq *txq,
+				      unsigned int rel_cnt, unsigned int *real_rel_cnt)
+{
+	struct dpmaif_pd_drb *cur_drb = NULL, *drb_base = txq->drb_base;
+	struct mtk_dpmaif_ctlb *dcb = txq->dcb;
+	struct dpmaif_drb_skb *cur_drb_skb;
+	struct dpmaif_msg_drb *msg_drb;
+	struct sk_buff *skb_free;
+	unsigned short cur_idx;
+	unsigned int i;
+
+	cur_idx = txq->drb_rel_rd_idx;
+	for (i = 0 ; i < rel_cnt; i++) {
+		cur_drb = drb_base + cur_idx;
+		cur_drb_skb = txq->sw_drb_base + cur_idx;
+		if (FIELD_GET(DRB_PD_DTYP, le32_to_cpu(cur_drb->pd_header)) == PD_DRB) {
+			dma_unmap_single(DCB_TO_MDEV(dcb)->dev,
+					 cur_drb_skb->data_dma_addr,
+					 cur_drb_skb->data_len,
+					 DMA_TO_DEVICE);
+
+			/* The last one drb entry of one tx packet, so, skb will be released. */
+			if (FIELD_GET(DRB_PD_CONT, le32_to_cpu(cur_drb->pd_header)) ==
+			    DPMAIF_DRB_LASTONE) {
+				skb_free = cur_drb_skb->skb;
+				if (!skb_free) {
+					dev_err(DCB_TO_DEV(dcb),
+						"txq%u pkt(%u), drb check fail, drb-w/r/rel-%u,%u,%u\n",
+						txq->id, cur_idx, txq->drb_wr_idx,
+						txq->drb_rd_idx, txq->drb_rel_rd_idx);
+					dev_err(DCB_TO_DEV(dcb), "release_cnt=%u, cur_id=%u\n",
+						rel_cnt, i);
+
+					mtk_dpmaif_common_err_handle(dcb, false);
+					return -DATA_FLOW_CHK_ERR;
+				}
+
+				dev_kfree_skb_any(skb_free);
+				dcb->traffic_stats.tx_hw_packets[txq->id]++;
+			}
+		} else {
+			msg_drb = (struct dpmaif_msg_drb *)cur_drb;
+			txq->last_ch_id = FIELD_GET(DRB_MSG_CHNL_ID,
+						    le32_to_cpu(msg_drb->msg_header2));
+		}
+
+		cur_drb_skb->skb = NULL;
+		cur_idx = mtk_dpmaif_ring_buf_get_next_idx(txq->drb_cnt, cur_idx);
+		txq->drb_rel_rd_idx = cur_idx;
+
+		atomic_inc(&txq->budget);
+	}
+
+	*real_rel_cnt = i;
+
+	return 0;
+}
+
+static int mtk_dpmaif_tx_rel(struct dpmaif_txq *txq)
+{
+	struct mtk_dpmaif_ctlb *dcb = txq->dcb;
+	unsigned int real_rel_cnt = 0;
+	int ret = 0, rel_cnt;
+
+	/* Update drb_rd_idx. */
+	mtk_dpmaif_poll_tx_drb(txq);
+
+	rel_cnt = mtk_dpmaif_ring_buf_releasable(txq->drb_cnt, txq->drb_rel_rd_idx,
+						 txq->drb_rd_idx);
+	if (likely(rel_cnt > 0)) {
+		/* Release tx data buffer. */
+		ret = mtk_dpmaif_tx_rel_internal(txq, rel_cnt, &real_rel_cnt);
+		dcb->traffic_stats.tx_done_last_cnt[txq->id] = real_rel_cnt;
+	}
+
+	return ret;
+}
+
+static void mtk_dpmaif_tx_done(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct mtk_dpmaif_ctlb *dcb;
+	struct dpmaif_txq *txq;
+
+	txq = container_of(dwork, struct dpmaif_txq, tx_done_work);
+	dcb = txq->dcb;
+
+	dcb->traffic_stats.tx_done_last_time[txq->id] = local_clock();
+
+	/* Recycle drb and release hardware tx done buffer around drb. */
+	mtk_dpmaif_tx_rel(txq);
+
+	/* try best to recycle drb */
+	if (mtk_dpmaif_poll_tx_drb(txq) > 0) {
+		mtk_dpmaif_drv_clear_ip_busy(dcb->drv_info);
+		mtk_dpmaif_drv_intr_complete(dcb->drv_info, DPMAIF_INTR_UL_DONE,
+					     txq->id, DPMAIF_CLEAR_INTR);
+		queue_delayed_work(dcb->tx_done_wq, &txq->tx_done_work, msecs_to_jiffies(0));
+	} else {
+		mtk_dpmaif_drv_clear_ip_busy(dcb->drv_info);
+		mtk_dpmaif_drv_intr_complete(dcb->drv_info, DPMAIF_INTR_UL_DONE,
+					     txq->id, DPMAIF_UNMASK_INTR);
+	}
+}
+
+static int mtk_dpmaif_txq_init(struct mtk_dpmaif_ctlb *dcb, struct dpmaif_txq *txq)
+{
+	unsigned int drb_cnt = dcb->res_cfg->drb_cnt[txq->id];
+	int ret;
+
+	atomic_set(&txq->budget, drb_cnt);
+	atomic_set(&txq->to_submit_cnt, 0);
+	txq->drb_cnt = drb_cnt;
+	txq->drb_wr_idx = 0;
+	txq->drb_rd_idx = 0;
+	txq->drb_rel_rd_idx = 0;
+	txq->dma_map_errs = 0;
+	txq->last_ch_id = 0;
+	txq->doorbell_delay = dcb->res_cfg->txq_doorbell_delay[txq->id];
+	txq->intr_coalesce_frame = dcb->intr_coalesce.tx_coalesced_frames;
+
+	/* Allocate DRB memory for HW and SW. */
+	txq->drb_base = dma_alloc_coherent(DCB_TO_DEV(dcb),
+					   txq->drb_cnt * sizeof(*txq->drb_base),
+					   &txq->drb_dma_addr, GFP_KERNEL);
+	if (!txq->drb_base) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to allocate txq%u drb resource\n", txq->id);
+		return -ENOMEM;
+	}
+
+	/* Allocate buffer for SW to record the skb information. */
+	txq->sw_drb_base = devm_kcalloc(DCB_TO_DEV(dcb), txq->drb_cnt,
+					sizeof(*txq->sw_drb_base), GFP_KERNEL);
+	if (!txq->sw_drb_base) {
+		ret = -ENOMEM;
+		goto err_alloc_drb_buf;
+	}
+
+	/* It belongs to dcb->tx_done_wq. */
+	INIT_DELAYED_WORK(&txq->tx_done_work, mtk_dpmaif_tx_done);
+
+	/* It belongs to dcb->tx_doorbell_wq. */
+	INIT_DELAYED_WORK(&txq->doorbell_work, mtk_dpmaif_tx_doorbell);
+
+	return 0;
+
+err_alloc_drb_buf:
+	dma_free_coherent(DCB_TO_DEV(dcb), txq->drb_cnt * sizeof(*txq->drb_base),
+			  txq->drb_base, txq->drb_dma_addr);
+	txq->drb_base = NULL;
+
+	return ret;
+}
+
+static void mtk_dpmaif_txq_exit(struct mtk_dpmaif_ctlb *dcb, struct dpmaif_txq *txq)
+{
+	struct dpmaif_drb_skb *drb_skb;
+	int i;
+
+	if (txq->drb_base) {
+		dma_free_coherent(DCB_TO_DEV(dcb), txq->drb_cnt * sizeof(*txq->drb_base),
+				  txq->drb_base, txq->drb_dma_addr);
+		txq->drb_base = NULL;
+	}
+
+	if (txq->sw_drb_base) {
+		for (i = 0; i < txq->drb_cnt; i++) {
+			drb_skb = txq->sw_drb_base + i;
+			if (drb_skb->skb) {
+				/* Verify msg drb or payload drb,
+				 * and only payload drb need to unmap dma.
+				 */
+				if (drb_skb->data_dma_addr)
+					dma_unmap_single(DCB_TO_MDEV(dcb)->dev,
+							 drb_skb->data_dma_addr,
+							 drb_skb->data_len,
+							 DMA_TO_DEVICE);
+				if (drb_skb->is_last) {
+					dev_kfree_skb_any(drb_skb->skb);
+					drb_skb->skb = NULL;
+				}
+			}
+		}
+
+		devm_kfree(DCB_TO_DEV(dcb), txq->sw_drb_base);
+		txq->sw_drb_base = NULL;
+	}
+}
+
+static int mtk_dpmaif_sw_wait_txq_stop(struct mtk_dpmaif_ctlb *dcb, struct dpmaif_txq *txq)
+{
+	/* Wait tx done work done. */
+	flush_delayed_work(&txq->tx_done_work);
+
+	/* Wait tx doorbell work done. */
+	flush_delayed_work(&txq->doorbell_work);
+
+	return 0;
+}
+
+static void mtk_dpmaif_sw_wait_tx_stop(struct mtk_dpmaif_ctlb *dcb)
+{
+	unsigned char txq_cnt = dcb->res_cfg->txq_cnt;
+	int i;
+
+	/* Wait all tx handle complete */
+	for (i = 0; i < txq_cnt; i++)
+		mtk_dpmaif_sw_wait_txq_stop(dcb, &dcb->txqs[i]);
+}
+
+static void mtk_dpmaif_sw_reset_txq(struct dpmaif_txq *txq)
+{
+	struct dpmaif_drb_skb *drb_skb;
+	int i;
+
+	/* Drop all tx buffer around drb. */
+	for (i = 0; i < txq->drb_cnt; i++) {
+		drb_skb = txq->sw_drb_base + i;
+		if (drb_skb->skb) {
+			dma_unmap_single(DCB_TO_MDEV(txq->dcb)->dev,
+					 drb_skb->data_dma_addr, drb_skb->data_len, DMA_TO_DEVICE);
+			if (drb_skb->is_last) {
+				dev_kfree_skb_any(drb_skb->skb);
+				drb_skb->skb = NULL;
+			}
+		}
+	}
+
+	/* Reset all txq resource. */
+	memset(txq->drb_base, 0x00, (txq->drb_cnt * sizeof(*txq->drb_base)));
+	memset(txq->sw_drb_base, 0x00, (txq->drb_cnt * sizeof(*txq->sw_drb_base)));
+
+	atomic_set(&txq->budget, txq->drb_cnt);
+	atomic_set(&txq->to_submit_cnt, 0);
+	txq->drb_rd_idx = 0;
+	txq->drb_wr_idx = 0;
+	txq->drb_rel_rd_idx = 0;
+	txq->last_ch_id = 0;
+}
+
+static void mtk_dpmaif_tx_res_reset(struct mtk_dpmaif_ctlb *dcb)
+{
+	unsigned char txq_cnt = dcb->res_cfg->txq_cnt;
+	struct dpmaif_txq *txq;
+	int i;
+
+	for (i = 0; i < txq_cnt; i++) {
+		txq = &dcb->txqs[i];
+		mtk_dpmaif_sw_reset_txq(txq);
+	}
+}
+
+static int mtk_dpmaif_tx_res_init(struct mtk_dpmaif_ctlb *dcb)
+{
+	unsigned char txq_cnt = dcb->res_cfg->txq_cnt;
+	struct dpmaif_txq *txq;
+	int i, j;
+	int ret;
+
+	dcb->txqs = devm_kcalloc(DCB_TO_DEV(dcb), txq_cnt, sizeof(*txq), GFP_KERNEL);
+	if (!dcb->txqs)
+		return -ENOMEM;
+
+	for (i = 0; i < txq_cnt; i++) {
+		txq = &dcb->txqs[i];
+		txq->id = i;
+		txq->dcb = dcb;
+		ret = mtk_dpmaif_txq_init(dcb, txq);
+		if (ret < 0) {
+			dev_err(DCB_TO_DEV(dcb), "Failed to init txq%d resource\n", txq->id);
+			goto err_init_txq;
+		}
+	}
+
+	dcb->tx_done_wq = alloc_workqueue("dpmaif_tx_done_wq_%s",
+					  WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_HIGHPRI,
+					  txq_cnt, DCB_TO_DEV_STR(dcb));
+	if (!dcb->tx_done_wq) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to allocate tx done workqueue\n");
+		ret = -ENOMEM;
+		goto err_init_txq;
+	}
+
+	dcb->tx_doorbell_wq = alloc_workqueue("dpmaif_tx_doorbell_wq_%s",
+					      WQ_FREEZABLE | WQ_UNBOUND |
+					      WQ_MEM_RECLAIM | WQ_HIGHPRI,
+					      txq_cnt, DCB_TO_DEV_STR(dcb));
+	if (!dcb->tx_doorbell_wq) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to allocate tx doorbell workqueue\n");
+		ret = -ENOMEM;
+		goto err_alloc_tx_doorbell_wq;
+	}
+
+	return 0;
+
+err_alloc_tx_doorbell_wq:
+	flush_workqueue(dcb->tx_done_wq);
+	destroy_workqueue(dcb->tx_done_wq);
+
+err_init_txq:
+	for (j = i - 1; j >= 0; j--)
+		mtk_dpmaif_txq_exit(dcb, &dcb->txqs[j]);
+
+	devm_kfree(DCB_TO_DEV(dcb), dcb->txqs);
+	dcb->txqs = NULL;
+
+	return ret;
+}
+
+static void mtk_dpmaif_tx_res_exit(struct mtk_dpmaif_ctlb *dcb)
+{
+	unsigned char txq_cnt = dcb->res_cfg->txq_cnt;
+	struct dpmaif_txq *txq;
+	int i;
+
+	for (i = 0; i < txq_cnt; i++) {
+		txq = &dcb->txqs[i];
+		flush_delayed_work(&txq->tx_done_work);
+		flush_delayed_work(&txq->doorbell_work);
+	}
+
+	if (dcb->tx_doorbell_wq) {
+		flush_workqueue(dcb->tx_doorbell_wq);
+		destroy_workqueue(dcb->tx_doorbell_wq);
+		dcb->tx_doorbell_wq = NULL;
+	}
+
+	if (dcb->tx_done_wq) {
+		flush_workqueue(dcb->tx_done_wq);
+		destroy_workqueue(dcb->tx_done_wq);
+		dcb->tx_done_wq = NULL;
+	}
+
+	for (i = 0; i < txq_cnt; i++)
+		mtk_dpmaif_txq_exit(dcb, &dcb->txqs[i]);
+
+	devm_kfree(DCB_TO_DEV(dcb), dcb->txqs);
+	dcb->txqs = NULL;
+}
+
+static int mtk_dpmaif_sw_res_init(struct mtk_dpmaif_ctlb *dcb)
+{
+	int ret;
+
+	ret = mtk_dpmaif_bat_res_init(dcb);
+	if (ret < 0) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to initialize bat reource, ret=%d\n", ret);
+		goto err_init_bat_res;
+	}
+
+	ret = mtk_dpmaif_rx_res_init(dcb);
+	if (ret < 0) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to initialize rx reource, ret=%d\n", ret);
+		goto err_init_rx_res;
+	}
+
+	ret = mtk_dpmaif_tx_res_init(dcb);
+	if (ret < 0) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to initialize tx reource, ret=%d\n", ret);
+		goto err_init_tx_res;
+	}
+
+	return 0;
+
+err_init_tx_res:
+	mtk_dpmaif_rx_res_exit(dcb);
+
+err_init_rx_res:
+	mtk_dpmaif_bat_res_exit(dcb);
+
+err_init_bat_res:
+	return ret;
+}
+
+static void mtk_dpmaif_sw_res_exit(struct mtk_dpmaif_ctlb *dcb)
+{
+	mtk_dpmaif_tx_res_exit(dcb);
+	mtk_dpmaif_rx_res_exit(dcb);
+	mtk_dpmaif_bat_res_exit(dcb);
+}
+
+static bool mtk_dpmaif_all_vqs_empty(struct dpmaif_tx_srv *tx_srv)
+{
+	bool is_empty = true;
+	struct dpmaif_vq *vq;
+	int i;
+
+	for (i = 0; i < tx_srv->vq_cnt; i++) {
+		vq = tx_srv->vq[i];
+		if (!skb_queue_empty(&vq->list)) {
+			is_empty = false;
+			break;
+		}
+	}
+
+	return is_empty;
+}
+
+static bool mtk_dpmaif_all_txqs_drb_lack(struct dpmaif_tx_srv *tx_srv)
+{
+	return !!tx_srv->txq_drb_lack_sta;
+}
+
+static void mtk_dpmaif_set_drb_msg(struct mtk_dpmaif_ctlb *dcb, unsigned char q_id,
+				   unsigned short cur_idx, unsigned int pkt_len,
+				   unsigned short count_l, unsigned char channel_id,
+				   unsigned short network_type)
+{
+	struct dpmaif_msg_drb *drb = (struct dpmaif_msg_drb *)dcb->txqs[q_id].drb_base + cur_idx;
+
+	drb->msg_header1 = cpu_to_le32(FIELD_PREP(DRB_MSG_DTYP, MSG_DRB) |
+				       FIELD_PREP(DRB_MSG_CONT, DPMAIF_DRB_MORE) |
+				       FIELD_PREP(DRB_MSG_PKT_LEN, pkt_len));
+	drb->msg_header2 = cpu_to_le32(FIELD_PREP(DRB_MSG_COUNT_L, count_l) |
+				       FIELD_PREP(DRB_MSG_CHNL_ID, channel_id) |
+				       FIELD_PREP(DRB_MSG_L4_CHK, 1) |
+				       FIELD_PREP(DRB_MSG_NET_TYPE, 0));
+}
+
+static void mtk_dpmaif_set_drb_payload(struct mtk_dpmaif_ctlb *dcb, unsigned char q_id,
+				       unsigned short cur_idx, unsigned long long data_addr,
+				       unsigned int pkt_size, char last_one)
+{
+	struct dpmaif_pd_drb *drb = dcb->txqs[q_id].drb_base + cur_idx;
+
+	drb->pd_header = cpu_to_le32(FIELD_PREP(DRB_PD_DTYP, PD_DRB));
+	if (last_one)
+		drb->pd_header |= cpu_to_le32(FIELD_PREP(DRB_PD_CONT, DPMAIF_DRB_LASTONE));
+	else
+		drb->pd_header |= cpu_to_le32(FIELD_PREP(DRB_PD_CONT, DPMAIF_DRB_MORE));
+
+	drb->pd_header |= cpu_to_le32(FIELD_PREP(DRB_PD_DATA_LEN, pkt_size));
+	drb->addr_low = cpu_to_le32(lower_32_bits(data_addr));
+	drb->addr_high = cpu_to_le32(upper_32_bits(data_addr));
+}
+
+static void mtk_dpmaif_record_drb_skb(struct mtk_dpmaif_ctlb *dcb, unsigned char q_id,
+				      unsigned short cur_idx, struct sk_buff *skb,
+				      unsigned short is_msg, unsigned short is_frag,
+				      unsigned short is_last, dma_addr_t data_dma_addr,
+				      unsigned int data_len)
+{
+	struct dpmaif_drb_skb *drb_skb = dcb->txqs[q_id].sw_drb_base + cur_idx;
+
+	drb_skb->skb = skb;
+	drb_skb->data_dma_addr = data_dma_addr;
+	drb_skb->data_len = data_len;
+	drb_skb->drb_idx = cur_idx;
+	drb_skb->is_msg = is_msg;
+	drb_skb->is_frag = is_frag;
+	drb_skb->is_last = is_last;
+}
+
+static int mtk_dpmaif_tx_fill_drb(struct mtk_dpmaif_ctlb *dcb,
+				  unsigned char q_id, struct sk_buff *skb)
+{
+	unsigned short cur_idx, cur_backup_idx, is_frag, is_last;
+	unsigned int send_drb_cnt, wt_cnt, payload_cnt;
+	struct dpmaif_txq *txq = &dcb->txqs[q_id];
+	struct dpmaif_drb_skb *cur_drb_skb;
+	struct skb_shared_info *info;
+	unsigned int data_len;
+	dma_addr_t data_dma_addr;
+	skb_frag_t *frag;
+	void *data_addr;
+	int i, ret;
+
+	info = skb_shinfo(skb);
+	send_drb_cnt = DPMAIF_SKB_CB(skb)->drb_cnt;
+	payload_cnt = send_drb_cnt - 1;
+	cur_idx = txq->drb_wr_idx;
+	cur_backup_idx = cur_idx;
+
+	/* Update tx drb, a msg drb first, then payload drb. */
+	/* Update and record payload drb information. */
+	mtk_dpmaif_set_drb_msg(dcb, txq->id, cur_idx, skb->len, 0, DPMAIF_SKB_CB(skb)->intf_id,
+			       be16_to_cpu(skb->protocol));
+	mtk_dpmaif_record_drb_skb(dcb, txq->id, cur_idx, skb, 1, 0, 0, 0, 0);
+
+	/* Payload drb: skb->data + frags[]. */
+	cur_idx = mtk_dpmaif_ring_buf_get_next_idx(txq->drb_cnt, cur_idx);
+	for (wt_cnt = 0; wt_cnt < payload_cnt; wt_cnt++) {
+		/* Get data_addr and data_len. */
+		if (wt_cnt == 0) {
+			data_len = skb_headlen(skb);
+			data_addr = skb->data;
+			is_frag = 0;
+		} else {
+			frag = info->frags + wt_cnt - 1;
+			data_len = skb_frag_size(frag);
+			data_addr = skb_frag_address(frag);
+			is_frag = 1;
+		}
+
+		if (wt_cnt == payload_cnt - 1)
+			is_last = 1;
+		else
+			is_last = 0;
+
+		data_dma_addr = dma_map_single(DCB_TO_MDEV(dcb)->dev,
+					       data_addr, data_len, DMA_TO_DEVICE);
+		ret = dma_mapping_error(DCB_TO_MDEV(dcb)->dev, data_dma_addr);
+		if (unlikely(ret)) {
+			dev_err(DCB_TO_MDEV(dcb)->dev, "Failed to map dma!\n");
+			txq->dma_map_errs++;
+			ret = -DATA_DMA_MAP_ERR;
+			goto err_dma_map;
+		}
+
+		/* Update and record payload drb information. */
+		mtk_dpmaif_set_drb_payload(dcb, txq->id, cur_idx, data_dma_addr, data_len, is_last);
+		mtk_dpmaif_record_drb_skb(dcb, txq->id, cur_idx, skb, 0, is_frag, is_last,
+					  data_dma_addr, data_len);
+
+		cur_idx = mtk_dpmaif_ring_buf_get_next_idx(txq->drb_cnt, cur_idx);
+	}
+
+	txq->drb_wr_idx += send_drb_cnt;
+	if (txq->drb_wr_idx >= txq->drb_cnt)
+		txq->drb_wr_idx -= txq->drb_cnt;
+
+	/* Make sure host write memory done before adding to_submit_cnt */
+	smp_mb();
+
+	atomic_sub(send_drb_cnt, &txq->budget);
+	atomic_add(send_drb_cnt, &txq->to_submit_cnt);
+
+	return 0;
+
+err_dma_map:
+	cur_drb_skb = txq->sw_drb_base + cur_backup_idx;
+	mtk_dpmaif_record_drb_skb(dcb, txq->id, cur_idx, NULL, 0, 0, 0, 0, 0);
+	cur_backup_idx = mtk_dpmaif_ring_buf_get_next_idx(txq->drb_cnt, cur_backup_idx);
+	for (i = 0; i < wt_cnt; i++) {
+		cur_drb_skb = txq->sw_drb_base + cur_backup_idx;
+
+		dma_unmap_single(DCB_TO_MDEV(dcb)->dev,
+				 cur_drb_skb->data_dma_addr, cur_drb_skb->data_len, DMA_TO_DEVICE);
+
+		cur_backup_idx = mtk_dpmaif_ring_buf_get_next_idx(txq->drb_cnt, cur_backup_idx);
+		mtk_dpmaif_record_drb_skb(dcb, txq->id, cur_idx, NULL, 0, 0, 0, 0, 0);
+	}
+
+	return ret;
+}
+
+static int mtk_dpmaif_tx_update_ring(struct mtk_dpmaif_ctlb *dcb, struct dpmaif_tx_srv *tx_srv,
+				     struct dpmaif_vq *vq)
+{
+	struct dpmaif_txq *txq = &dcb->txqs[vq->q_id];
+	unsigned char q_id = vq->q_id;
+	unsigned char skb_drb_cnt;
+	int i, drb_available_cnt;
+	struct sk_buff *skb;
+	int ret;
+
+	drb_available_cnt = mtk_dpmaif_ring_buf_writable(txq->drb_cnt,
+							 txq->drb_rel_rd_idx, txq->drb_wr_idx);
+
+	clear_bit(q_id, &tx_srv->txq_drb_lack_sta);
+	for (i = 0; i < DPMAIF_SKB_TX_WEIGHT; i++) {
+		skb = skb_dequeue(&vq->list);
+		if (!skb) {
+			ret = 0;
+			break;
+		}
+
+		skb_drb_cnt = DPMAIF_SKB_CB(skb)->drb_cnt;
+		if (drb_available_cnt < skb_drb_cnt) {
+			skb_queue_head(&vq->list, skb);
+			set_bit(q_id, &tx_srv->txq_drb_lack_sta);
+			ret = -DATA_LOW_MEM_DRB;
+			break;
+		}
+
+		ret = mtk_dpmaif_tx_fill_drb(dcb, q_id, skb);
+		if (ret < 0) {
+			skb_queue_head(&vq->list, skb);
+			break;
+		}
+		drb_available_cnt -= skb_drb_cnt;
+		dcb->traffic_stats.tx_sw_packets[q_id]++;
+	}
+
+	return ret;
+}
+
+static struct dpmaif_vq *mtk_dpmaif_srv_select_vq(struct dpmaif_tx_srv *tx_srv)
+{
+	struct dpmaif_vq *vq;
+	int i;
+
+	/* Round robin select tx vqs. */
+	for (i = 0; i < tx_srv->vq_cnt; i++) {
+		tx_srv->cur_vq_id = tx_srv->cur_vq_id % tx_srv->vq_cnt;
+		vq = tx_srv->vq[tx_srv->cur_vq_id];
+		tx_srv->cur_vq_id++;
+		if (!skb_queue_empty(&vq->list))
+			return vq;
+	}
+
+	return NULL;
+}
+
+static void mtk_dpmaif_tx(struct dpmaif_tx_srv *tx_srv)
+{
+	struct mtk_dpmaif_ctlb *dcb = tx_srv->dcb;
+	struct dpmaif_txq *txq;
+	struct dpmaif_vq *vq;
+	int ret;
+
+	do {
+		vq = mtk_dpmaif_srv_select_vq(tx_srv);
+		if (!vq)
+			break;
+
+		ret = mtk_dpmaif_tx_update_ring(dcb, tx_srv, vq);
+		if (unlikely(ret < 0)) {
+			if (ret == -DATA_LOW_MEM_DRB &&
+			    mtk_dpmaif_all_txqs_drb_lack(tx_srv)) {
+				usleep_range(50, 100);
+			}
+		}
+
+		/* Kick off tx doorbell workqueue. */
+		txq = &dcb->txqs[vq->q_id];
+		if (atomic_read(&txq->to_submit_cnt) > 0) {
+			queue_delayed_work(dcb->tx_doorbell_wq, &txq->doorbell_work,
+					   msecs_to_jiffies(txq->doorbell_delay));
+		}
+
+		if (need_resched())
+			cond_resched();
+	} while (!kthread_should_stop() && (dcb->dpmaif_state == DPMAIF_STATE_PWRON));
+}
+
+static int mtk_dpmaif_tx_thread(void *arg)
+{
+	struct dpmaif_tx_srv *tx_srv = arg;
+	struct mtk_dpmaif_ctlb *dcb;
+	int ret;
+
+	dcb = tx_srv->dcb;
+	set_user_nice(current, tx_srv->prio);
+	while (!kthread_should_stop()) {
+		if (mtk_dpmaif_all_vqs_empty(tx_srv) ||
+		    dcb->dpmaif_state != DPMAIF_STATE_PWRON) {
+			ret = wait_event_interruptible(tx_srv->wait,
+						       (!mtk_dpmaif_all_vqs_empty(tx_srv) &&
+						       (dcb->dpmaif_state == DPMAIF_STATE_PWRON)) ||
+						       kthread_should_stop());
+			if (ret == -ERESTARTSYS)
+				continue;
+		}
+
+		if (kthread_should_stop())
+			break;
+
+		/* Send packets of all tx virtual queues belong to the tx service. */
+		mtk_dpmaif_tx(tx_srv);
+	}
+
+	return 0;
+}
+
+static int mtk_dpmaif_tx_srvs_start(struct mtk_dpmaif_ctlb *dcb)
+{
+	unsigned char srvs_cnt = dcb->res_cfg->tx_srv_cnt;
+	struct dpmaif_tx_srv *tx_srv;
+	int i, j, ret;
+
+	for (i = 0; i < srvs_cnt; i++) {
+		tx_srv = &dcb->tx_srvs[i];
+		tx_srv->cur_vq_id = 0;
+		tx_srv->txq_drb_lack_sta = 0;
+		if (tx_srv->srv) {
+			dev_err(DCB_TO_DEV(dcb), "The tx_srv:%d existed\n", i);
+			continue;
+		}
+		tx_srv->srv = kthread_run(mtk_dpmaif_tx_thread,
+					  tx_srv, "dpmaif_tx_srv%u_%s",
+					  tx_srv->id, DCB_TO_DEV_STR(dcb));
+		if (IS_ERR(tx_srv->srv)) {
+			dev_err(DCB_TO_DEV(dcb), "Failed to alloc dpmaif tx_srv%u\n", tx_srv->id);
+			ret = PTR_ERR(tx_srv->srv);
+			goto err_init_tx_srvs;
+		}
+	}
+
+	return 0;
+
+err_init_tx_srvs:
+	for (j = i - 1; j >= 0; j--) {
+		if (tx_srv->srv)
+			kthread_stop(tx_srv->srv);
+		tx_srv->srv = NULL;
+	}
+
+	return ret;
+}
+
+static void mtk_dpmaif_tx_srvs_stop(struct mtk_dpmaif_ctlb *dcb)
+{
+	unsigned char srvs_cnt = dcb->res_cfg->tx_srv_cnt;
+	struct dpmaif_tx_srv *tx_srv;
+	int i;
+
+	for (i = 0; i < srvs_cnt; i++) {
+		tx_srv = &dcb->tx_srvs[i];
+		if (tx_srv->srv)
+			kthread_stop(tx_srv->srv);
+
+		tx_srv->srv = NULL;
+	}
+}
+
+static int mtk_dpmaif_tx_srvs_init(struct mtk_dpmaif_ctlb *dcb)
+{
+	unsigned char srvs_cnt = dcb->res_cfg->tx_srv_cnt;
+	unsigned char vqs_cnt = dcb->res_cfg->tx_vq_cnt;
+	struct dpmaif_tx_srv *tx_srv;
+	struct dpmaif_vq *tx_vq;
+	int i, j, vq_id;
+	int ret;
+
+	/* Initialize all data packet tx vitrual queue. */
+	dcb->tx_vqs = devm_kcalloc(DCB_TO_DEV(dcb), vqs_cnt, sizeof(*dcb->tx_vqs), GFP_KERNEL);
+	if (!dcb->tx_vqs)
+		return -ENOMEM;
+
+	for (i = 0; i < vqs_cnt; i++) {
+		tx_vq = &dcb->tx_vqs[i];
+		tx_vq->q_id = i;
+		tx_vq->max_len = DEFAULT_TX_QUEUE_LEN;
+		skb_queue_head_init(&tx_vq->list);
+	}
+
+	/* Initialize all data packet tx services. */
+	dcb->tx_srvs = devm_kcalloc(DCB_TO_DEV(dcb), srvs_cnt, sizeof(*dcb->tx_srvs), GFP_KERNEL);
+	if (!dcb->tx_srvs) {
+		ret = -ENOMEM;
+		goto err_alloc_tx_srvs;
+	}
+
+	for (i = 0; i < srvs_cnt; i++) {
+		tx_srv = &dcb->tx_srvs[i];
+		tx_srv->dcb = dcb;
+		tx_srv->id = i;
+		tx_srv->prio = dcb->res_cfg->srv_prio_tbl[i];
+		tx_srv->cur_vq_id = 0;
+		tx_srv->txq_drb_lack_sta = 0;
+		init_waitqueue_head(&tx_srv->wait);
+
+		/* Set virtual queues and tx service mapping. */
+		vq_id = 0;
+		for (j = 0; j < vqs_cnt; j++) {
+			if (tx_srv->id == dcb->res_cfg->tx_vq_srv_map[j]) {
+				tx_srv->vq[vq_id] = &dcb->tx_vqs[j];
+				vq_id++;
+			}
+		}
+
+		tx_srv->vq_cnt = vq_id;
+		if (tx_srv->vq_cnt == 0)
+			dev_err(DCB_TO_DEV(dcb),
+				"Invalid vq_cnt of tx_srv%u\n", tx_srv->id);
+	}
+
+	return 0;
+
+err_alloc_tx_srvs:
+	devm_kfree(DCB_TO_DEV(dcb), dcb->tx_vqs);
+	dcb->tx_vqs = NULL;
+
+	return ret;
+}
+
+static void mtk_dpmaif_tx_vqs_reset(struct mtk_dpmaif_ctlb *dcb)
+{
+	unsigned char vqs_cnt = dcb->res_cfg->tx_vq_cnt;
+	struct dpmaif_vq *tx_vq;
+	int i;
+
+	/* Drop all packet in tx virtual queues. */
+	for (i = 0; i < vqs_cnt; i++) {
+		tx_vq = &dcb->tx_vqs[i];
+		if (tx_vq)
+			skb_queue_purge(&tx_vq->list);
+	}
+}
+
+static void mtk_dpmaif_tx_srvs_exit(struct mtk_dpmaif_ctlb *dcb)
+{
+	mtk_dpmaif_tx_srvs_stop(dcb);
+
+	devm_kfree(DCB_TO_DEV(dcb), dcb->tx_srvs);
+	dcb->tx_srvs = NULL;
+
+	/* Drop all packet in tx virtual queues. */
+	mtk_dpmaif_tx_vqs_reset(dcb);
+
+	devm_kfree(DCB_TO_DEV(dcb), dcb->tx_vqs);
+	dcb->tx_vqs = NULL;
+}
+
+static void mtk_dpmaif_trans_enable(struct mtk_dpmaif_ctlb *dcb)
+{
+	mtk_dpmaif_sw_start_rx(dcb);
+	mtk_dpmaif_enable_irq(dcb);
+	if (!mtk_hw_mmio_check(DCB_TO_MDEV(dcb))) {
+		if (mtk_dpmaif_drv_start_queue(dcb->drv_info, DPMAIF_RX) < 0) {
+			dev_err(DCB_TO_DEV(dcb), "Failed to start dpmaif hw rx\n");
+			mtk_dpmaif_common_err_handle(dcb, true);
+			return;
+		}
+
+		if (mtk_dpmaif_drv_start_queue(dcb->drv_info, DPMAIF_TX) < 0) {
+			dev_err(DCB_TO_DEV(dcb), "Failed to start dpmaif hw tx\n");
+			mtk_dpmaif_common_err_handle(dcb, true);
+			return;
+		}
+	}
+}
+
+static void mtk_dpmaif_trans_disable(struct mtk_dpmaif_ctlb *dcb)
+{
+	bool io_err = false;
+
+	/* Wait tx doorbell and tx done work complete */
+	mtk_dpmaif_sw_wait_tx_stop(dcb);
+
+	/* Stop dpmaif hw tx and rx. */
+	if (!mtk_hw_mmio_check(DCB_TO_MDEV(dcb))) {
+		if (mtk_dpmaif_drv_stop_queue(dcb->drv_info, DPMAIF_TX) < 0) {
+			io_err = true;
+			dev_err(DCB_TO_DEV(dcb), "Failed to stop dpmaif hw tx\n");
+		}
+
+		if (mtk_dpmaif_drv_stop_queue(dcb->drv_info, DPMAIF_RX) < 0) {
+			io_err = true;
+			dev_err(DCB_TO_DEV(dcb), "Failed to stop dpmaif hw rx\n");
+		}
+
+		if (io_err)
+			mtk_dpmaif_common_err_handle(dcb, true);
+	}
+
+	/* Disable all dpmaif L1 interrupt. */
+	mtk_dpmaif_disable_irq(dcb);
+
+	/* Stop and wait rx handle done  */
+	mtk_dpmaif_sw_stop_rx(dcb);
+
+	/* Wait bat reload work done */
+	flush_workqueue(dcb->bat_info.reload_wq);
+}
+
+static void mtk_dpmaif_trans_ctl(struct mtk_dpmaif_ctlb *dcb, bool enable)
+{
+	mutex_lock(&dcb->trans_ctl_lock);
+
+	if (enable) {
+		if (!dcb->trans_enabled) {
+			if (dcb->dpmaif_state == DPMAIF_STATE_PWRON &&
+			    dcb->dpmaif_user_ready) {
+				mtk_dpmaif_trans_enable(dcb);
+				dcb->trans_enabled = true;
+			}
+		}
+	} else {
+		if (dcb->trans_enabled) {
+			if (!(dcb->dpmaif_state == DPMAIF_STATE_PWRON) ||
+			    !dcb->dpmaif_user_ready) {
+				mtk_dpmaif_trans_disable(dcb);
+				dcb->trans_enabled = false;
+			}
+		}
+	}
+	mutex_unlock(&dcb->trans_ctl_lock);
+}
+
+static void mtk_dpmaif_cmd_trans_ctl(struct mtk_dpmaif_ctlb *dcb, void *data)
+{
+	struct mtk_data_trans_ctl *trans_ctl = data;
+
+	dcb->dpmaif_user_ready = trans_ctl->enable;
+
+	/* Try best to drop all tx vq packets when disable trans */
+	if (!trans_ctl->enable)
+		mtk_dpmaif_tx_vqs_reset(dcb);
+
+	mtk_dpmaif_trans_ctl(dcb, trans_ctl->enable);
+}
+
+static void mtk_dpmaif_cmd_intr_coalesce_write(struct mtk_dpmaif_ctlb *dcb,
+					       unsigned int qid, enum dpmaif_drv_dir dir)
+{
+	struct dpmaif_drv_intr drv_intr;
+
+	if (dir == DPMAIF_TX) {
+		drv_intr.pkt_threshold = dcb->txqs[qid].intr_coalesce_frame;
+		drv_intr.time_threshold = dcb->intr_coalesce.tx_coalesce_usecs;
+	} else {
+		drv_intr.pkt_threshold = dcb->rxqs[qid].intr_coalesce_frame;
+		drv_intr.time_threshold = dcb->intr_coalesce.rx_coalesce_usecs;
+	}
+
+	drv_intr.dir = dir;
+	drv_intr.q_mask = BIT(qid);
+
+	drv_intr.mode = 0;
+	if (drv_intr.pkt_threshold)
+		drv_intr.mode |= DPMAIF_INTR_EN_PKT;
+	if (drv_intr.time_threshold)
+		drv_intr.mode |= DPMAIF_INTR_EN_TIME;
+	dcb->drv_info->drv_ops->feature_cmd(dcb->drv_info, DATA_HW_INTR_COALESCE_SET, &drv_intr);
+}
+
+static int mtk_dpmaif_cmd_intr_coalesce_set(struct mtk_dpmaif_ctlb *dcb, void *data)
+{
+	struct mtk_data_intr_coalesce *dpmaif_intr_cfg = &dcb->intr_coalesce;
+	struct mtk_data_intr_coalesce *user_intr_cfg = data;
+	int i;
+
+	memcpy(dpmaif_intr_cfg, data, sizeof(*dpmaif_intr_cfg));
+
+	for (i = 0; i < dcb->res_cfg->rxq_cnt; i++) {
+		dcb->rxqs[i].intr_coalesce_frame = user_intr_cfg->rx_coalesced_frames;
+		mtk_dpmaif_cmd_intr_coalesce_write(dcb, i, DPMAIF_RX);
+	}
+
+	for (i = 0; i < dcb->res_cfg->txq_cnt; i++) {
+		dcb->txqs[i].intr_coalesce_frame = user_intr_cfg->tx_coalesced_frames;
+		mtk_dpmaif_cmd_intr_coalesce_write(dcb, i, DPMAIF_TX);
+	}
+
+	return 0;
+}
+
+static int mtk_dpmaif_cmd_intr_coalesce_get(struct mtk_dpmaif_ctlb *dcb, void *data)
+{
+	struct mtk_data_intr_coalesce *dpmaif_intr_cfg = &dcb->intr_coalesce;
+
+	memcpy(data, dpmaif_intr_cfg, sizeof(*dpmaif_intr_cfg));
+
+	return 0;
+}
+
+static int mtk_dpmaif_cmd_rxfh_set(struct mtk_dpmaif_ctlb *dcb, void *data)
+{
+	struct mtk_data_rxfh *indir_rxfh = data;
+	int ret;
+
+	if (indir_rxfh->key) {
+		ret = mtk_dpmaif_drv_feature_cmd(dcb->drv_info, DATA_HW_HASH_SET, indir_rxfh->key);
+		if (ret < 0) {
+			dev_err(DCB_TO_DEV(dcb), "Failed to set hash key\n");
+			return ret;
+		}
+	}
+
+	if (indir_rxfh->indir) {
+		ret = mtk_dpmaif_drv_feature_cmd(dcb->drv_info, DATA_HW_INDIR_SET,
+						 indir_rxfh->indir);
+		if (ret < 0) {
+			dev_err(DCB_TO_DEV(dcb), "Failed to set indirection table\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int mtk_dpmaif_cmd_rxfh_get(struct mtk_dpmaif_ctlb *dcb, void *data)
+{
+	struct mtk_data_rxfh *indir_rxfh = data;
+	int ret;
+
+	if (indir_rxfh->key) {
+		ret = mtk_dpmaif_drv_feature_cmd(dcb->drv_info, DATA_HW_HASH_GET, indir_rxfh->key);
+		if (ret < 0) {
+			dev_err(DCB_TO_DEV(dcb), "Failed to get hash key\n");
+			return ret;
+		}
+	}
+
+	if (indir_rxfh->indir) {
+		ret = mtk_dpmaif_drv_feature_cmd(dcb->drv_info, DATA_HW_INDIR_GET,
+						 indir_rxfh->indir);
+		if (ret < 0) {
+			dev_err(DCB_TO_DEV(dcb), "Failed to get indirection table\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void mtk_dpmaif_cmd_rxq_num_get(struct mtk_dpmaif_ctlb *dcb, void *data)
+{
+	*(unsigned int *)data = dcb->res_cfg->rxq_cnt;
+}
+
+#define DATA_TRANS_STRING_LEN 32
+
+static const char dpmaif_tx_stats[][DATA_TRANS_STRING_LEN] = {
+	"txq%u.tx_sw_packets", "txq%u.tx_hw_packets", "txq%u.tx_done_last_time",
+	"txq%u.tx_done_last_cnt", "txq%u.irq_evt.ul_done", "txq%u.irq_evt.ul_drb_empty",
+};
+
+static const char dpmaif_rx_stats[][DATA_TRANS_STRING_LEN] = {
+	"rxq%u.rx_packets", "rxq%u.rx_errors", "rxq%u.rx_dropped",
+	"rxq%u.rx_hw_ind_dropped", "rxq%u.rx_done_last_time",
+	"rxq%u.rx_done_last_cnt", "rxq%u.irq_evt.dl_done",
+	"rxq%u.irq_evt.pit_len_err",
+};
+
+static const char dpmaif_irq_stats[][DATA_TRANS_STRING_LEN] = {
+	"irq%u.irq_total_cnt", "irq%u.irq_last_time",
+};
+
+static const char dpmaif_misc_stats[][DATA_TRANS_STRING_LEN] = {
+	"ul_md_notready", "ul_md_pwr_notready", "ul_len_err", "dl_skb_len_err",
+	"dl_bat_cnt_len_err", "dl_pkt_empty", "dl_frag_empty",
+	"dl_mtu_err", "dl_frag_cnt_len_err", "hpc_ent_type_err",
+};
+
+#define DATA_TX_STATS_LEN	ARRAY_SIZE(dpmaif_tx_stats)
+#define DATA_RX_STATS_LEN	ARRAY_SIZE(dpmaif_rx_stats)
+#define DATA_IRQ_STATS_LEN	ARRAY_SIZE(dpmaif_irq_stats)
+#define DATA_MISC_STATS_LEN	ARRAY_SIZE(dpmaif_misc_stats)
+
+static unsigned int mtk_dpmaif_describe_stats(struct mtk_dpmaif_ctlb *dcb, u8 *strings)
+{
+	unsigned int i, j, n_stats = 0;
+
+	for (i = 0; i < dcb->res_cfg->txq_cnt; i++) {
+		n_stats += DATA_TX_STATS_LEN;
+		if (strings) {
+			for (j = 0; j < DATA_TX_STATS_LEN; j++) {
+				snprintf(strings, DATA_TRANS_STRING_LEN, dpmaif_tx_stats[j], i);
+				strings += DATA_TRANS_STRING_LEN;
+			}
+		}
+	}
+
+	for (i = 0; i < dcb->res_cfg->rxq_cnt; i++) {
+		n_stats += DATA_RX_STATS_LEN;
+		if (strings) {
+			for (j = 0; j < DATA_RX_STATS_LEN; j++) {
+				snprintf(strings, DATA_TRANS_STRING_LEN, dpmaif_rx_stats[j], i);
+				strings += DATA_TRANS_STRING_LEN;
+			}
+		}
+	}
+
+	for (i = 0; i < dcb->res_cfg->irq_cnt; i++) {
+		n_stats += DATA_IRQ_STATS_LEN;
+		if (strings) {
+			for (j = 0; j < DATA_IRQ_STATS_LEN; j++) {
+				snprintf(strings, DATA_TRANS_STRING_LEN, dpmaif_irq_stats[j], i);
+				strings += DATA_TRANS_STRING_LEN;
+			}
+		}
+	}
+
+	n_stats += DATA_MISC_STATS_LEN;
+	if (strings)
+		memcpy(strings, *dpmaif_misc_stats, sizeof(dpmaif_misc_stats));
+
+	return n_stats;
+}
+
+static void mtk_dpmaif_read_stats(struct mtk_dpmaif_ctlb *dcb, u64 *data)
+{
+	unsigned int i, j = 0;
+
+	for (i = 0; i < dcb->res_cfg->txq_cnt; i++) {
+		data[j++] = dcb->traffic_stats.tx_sw_packets[i];
+		data[j++] = dcb->traffic_stats.tx_hw_packets[i];
+		data[j++] = dcb->traffic_stats.tx_done_last_time[i];
+		data[j++] = dcb->traffic_stats.tx_done_last_cnt[i];
+		data[j++] = dcb->traffic_stats.irq_tx_evt[i].ul_done;
+		data[j++] = dcb->traffic_stats.irq_tx_evt[i].ul_drb_empty;
+	}
+
+	for (i = 0; i < dcb->res_cfg->rxq_cnt; i++) {
+		data[j++] = dcb->traffic_stats.rx_packets[i];
+		data[j++] = dcb->traffic_stats.rx_errors[i];
+		data[j++] = dcb->traffic_stats.rx_dropped[i];
+		data[j++] = dcb->traffic_stats.rx_hw_ind_dropped[i];
+		data[j++] = dcb->traffic_stats.rx_done_last_time[i];
+		data[j++] = dcb->traffic_stats.rx_done_last_cnt[i];
+		data[j++] = dcb->traffic_stats.irq_rx_evt[i].dl_done;
+		data[j++] = dcb->traffic_stats.irq_rx_evt[i].pit_len_err;
+	}
+
+	for (i = 0; i < dcb->res_cfg->irq_cnt; i++) {
+		data[j++] = dcb->traffic_stats.irq_total_cnt[i];
+		data[j++] = dcb->traffic_stats.irq_last_time[i];
+	}
+
+	data[j++] = dcb->traffic_stats.irq_other_evt.ul_md_notready;
+	data[j++] = dcb->traffic_stats.irq_other_evt.ul_md_pwr_notready;
+	data[j++] = dcb->traffic_stats.irq_other_evt.ul_len_err;
+	data[j++] = dcb->traffic_stats.irq_other_evt.dl_skb_len_err;
+	data[j++] = dcb->traffic_stats.irq_other_evt.dl_bat_cnt_len_err;
+	data[j++] = dcb->traffic_stats.irq_other_evt.dl_pkt_empty;
+	data[j++] = dcb->traffic_stats.irq_other_evt.dl_frag_empty;
+	data[j++] = dcb->traffic_stats.irq_other_evt.dl_mtu_err;
+	data[j++] = dcb->traffic_stats.irq_other_evt.dl_frag_cnt_len_err;
+	data[j++] = dcb->traffic_stats.irq_other_evt.hpc_ent_type_err;
+}
+
+static void mtk_dpmaif_cmd_string_cnt_get(struct mtk_dpmaif_ctlb *dcb, void *data)
+{
+	*(unsigned int *)data = mtk_dpmaif_describe_stats(dcb, NULL);
+}
+
+static void mtk_dpmaif_cmd_handle(struct dpmaif_cmd_srv *srv)
+{
+	struct mtk_dpmaif_ctlb *dcb = srv->dcb;
+	struct dpmaif_vq *cmd_vq = srv->vq;
+	struct mtk_data_cmd *cmd_info;
+	struct sk_buff *skb;
+	int ret;
+
+	while ((skb = skb_dequeue(&cmd_vq->list))) {
+		ret = 0;
+		cmd_info = SKB_TO_CMD(skb);
+		if (dcb->dpmaif_state == DPMAIF_STATE_PWRON) {
+			switch (cmd_info->cmd) {
+			case DATA_CMD_TRANS_CTL:
+				mtk_dpmaif_cmd_trans_ctl(dcb, CMD_TO_DATA(cmd_info));
+				break;
+			case DATA_CMD_INTR_COALESCE_GET:
+				ret = mtk_dpmaif_cmd_intr_coalesce_get(dcb,
+								       CMD_TO_DATA(cmd_info));
+				break;
+			case DATA_CMD_INTR_COALESCE_SET:
+				ret = mtk_dpmaif_cmd_intr_coalesce_set(dcb,
+								       CMD_TO_DATA(cmd_info));
+				break;
+			case DATA_CMD_RXFH_GET:
+				ret = mtk_dpmaif_cmd_rxfh_get(dcb,
+							      CMD_TO_DATA(cmd_info));
+				break;
+			case DATA_CMD_RXFH_SET:
+				ret = mtk_dpmaif_cmd_rxfh_set(dcb,
+							      CMD_TO_DATA(cmd_info));
+				break;
+			case DATA_CMD_INDIR_SIZE_GET:
+				ret = mtk_dpmaif_drv_feature_cmd(dcb->drv_info,
+								 DATA_HW_INDIR_SIZE_GET,
+								 CMD_TO_DATA(cmd_info));
+				break;
+			case DATA_CMD_HKEY_SIZE_GET:
+				ret = mtk_dpmaif_drv_feature_cmd(dcb->drv_info,
+								 DATA_HW_HASH_KEY_SIZE_GET,
+								 CMD_TO_DATA(cmd_info));
+				break;
+			case DATA_CMD_RXQ_NUM_GET:
+				mtk_dpmaif_cmd_rxq_num_get(dcb, CMD_TO_DATA(cmd_info));
+				break;
+			case DATA_CMD_STRING_CNT_GET:
+				mtk_dpmaif_cmd_string_cnt_get(dcb, CMD_TO_DATA(cmd_info));
+				break;
+			case DATA_CMD_STRING_GET:
+				mtk_dpmaif_describe_stats(dcb, (u8 *)CMD_TO_DATA(cmd_info));
+				break;
+			case DATA_CMD_TRANS_DUMP:
+				mtk_dpmaif_read_stats(dcb, (u64 *)CMD_TO_DATA(cmd_info));
+				break;
+			default:
+				ret = -EOPNOTSUPP;
+				break;
+			}
+		}
+		cmd_info->ret = ret;
+		if (cmd_info->data_complete)
+			cmd_info->data_complete(skb);
+	}
+}
+
+static void mtk_dpmaif_cmd_srv(struct work_struct *work)
+{
+	struct dpmaif_cmd_srv *srv = container_of(work, struct dpmaif_cmd_srv, work);
+
+	mtk_dpmaif_cmd_handle(srv);
+}
+
+static int mtk_dpmaif_cmd_srvs_init(struct mtk_dpmaif_ctlb *dcb)
+{
+	struct dpmaif_cmd_srv *cmd_srv = &dcb->cmd_srv;
+	struct dpmaif_vq *cmd_vq = &dcb->cmd_vq;
+
+	cmd_vq->max_len = DEFAULT_TX_QUEUE_LEN;
+	skb_queue_head_init(&cmd_vq->list);
+
+	cmd_srv->dcb = dcb;
+	cmd_srv->vq = cmd_vq;
+
+	/* The cmd handle work will be scheduled by schedule_work(), use system workqueue. */
+	INIT_WORK(&cmd_srv->work, mtk_dpmaif_cmd_srv);
+
+	return 0;
+}
+
+static void mtk_dpmaif_cmd_srvs_exit(struct mtk_dpmaif_ctlb *dcb)
+{
+	flush_work(&dcb->cmd_srv.work);
+	skb_queue_purge(&dcb->cmd_vq.list);
+}
+
+static int mtk_dpmaif_drv_res_init(struct mtk_dpmaif_ctlb *dcb)
+{
+	int ret = 0;
+
+	dcb->drv_info = devm_kzalloc(DCB_TO_DEV(dcb), sizeof(*dcb->drv_info), GFP_KERNEL);
+	if (!dcb->drv_info)
+		return -ENOMEM;
+
+	dcb->drv_info->mdev = DCB_TO_MDEV(dcb);
+
+	if (DPMAIF_GET_HW_VER(dcb) == 0x0800) {
+		dcb->drv_info->drv_ops = &dpmaif_drv_ops_t800;
+	} else {
+		devm_kfree(DCB_TO_DEV(dcb), dcb->drv_info);
+		dev_err(DCB_TO_DEV(dcb), "Unsupported mdev, hw_ver=0x%x\n", DPMAIF_GET_HW_VER(dcb));
+		ret = -EFAULT;
+	}
+
+	return ret;
+}
+
+static void mtk_dpmaif_drv_res_exit(struct mtk_dpmaif_ctlb *dcb)
+{
+	devm_kfree(DCB_TO_DEV(dcb), dcb->drv_info);
+	dcb->drv_info = NULL;
+}
+
+static void mtk_dpmaif_irq_tx_done(struct mtk_dpmaif_ctlb *dcb, unsigned int q_mask)
+{
+	unsigned int ulq_done;
+	int i;
+
+	/* All txq done share one interrupt, and then,
+	 * one interrupt will check all ulq done status and schedule corresponding bottom half.
+	 */
+	for (i = 0; i < dcb->res_cfg->txq_cnt; i++) {
+		ulq_done = q_mask & (1 << i);
+		if (ulq_done) {
+			queue_delayed_work(dcb->tx_done_wq,
+					   &dcb->txqs[i].tx_done_work,
+					msecs_to_jiffies(0));
+
+			dcb->traffic_stats.irq_tx_evt[i].ul_done++;
+		}
+	}
+}
+
+static void mtk_dpmaif_irq_rx_done(struct mtk_dpmaif_ctlb *dcb, unsigned int q_mask)
+{
+	struct dpmaif_rxq *rxq;
+	unsigned int dlq_done;
+	int i;
+
+	/* RSS: one dlq done belongs to one interrupt, and then,
+	 * one interrupt will only check one dlq done status and schedule bottom half.
+	 */
+	for (i = 0; i < dcb->res_cfg->rxq_cnt; i++) {
+		dlq_done = q_mask & (1 << i);
+		if (dlq_done) {
+			dcb->traffic_stats.rx_done_last_time[i] = local_clock();
+			rxq = &dcb->rxqs[i];
+			dcb->traffic_stats.rx_done_last_cnt[i] = 0;
+			napi_schedule(&rxq->napi);
+			dcb->traffic_stats.irq_rx_evt[i].dl_done++;
+			break;
+		}
+	}
+}
+
+static void mtk_dpmaif_irq_pit_len_err(struct mtk_dpmaif_ctlb *dcb, unsigned int q_mask)
+{
+	unsigned int pit_len_err;
+	int i;
+
+	for (i = 0; i < dcb->res_cfg->rxq_cnt; i++) {
+		pit_len_err = q_mask & (1 << i);
+		if (pit_len_err)
+			break;
+	}
+
+	dcb->traffic_stats.irq_rx_evt[i].pit_len_err++;
+	dcb->rxqs[i].pit_cnt_err_intr_set = true;
+}
+
+static int mtk_dpmaif_irq_handle(int irq_id, void *data)
+{
+	struct dpmaif_drv_intr_info intr_info;
+	struct dpmaif_irq_param *irq_param;
+	struct dpmaif_bat_ring *bat_ring;
+	struct mtk_dpmaif_ctlb *dcb;
+	int ret;
+	int i;
+
+	irq_param = data;
+	dcb = irq_param->dcb;
+	dcb->traffic_stats.irq_last_time[irq_param->idx] = local_clock();
+	dcb->traffic_stats.irq_total_cnt[irq_param->idx]++;
+
+	if (unlikely(dcb->dpmaif_state != DPMAIF_STATE_PWRON))
+		goto out;
+
+	memset(&intr_info, 0x00, sizeof(struct dpmaif_drv_intr_info));
+	ret = mtk_dpmaif_drv_intr_handle(dcb->drv_info, &intr_info, irq_param->dpmaif_irq_src);
+	if (ret < 0) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to get dpmaif drv irq info\n");
+		goto err_get_drv_irq_info;
+	}
+
+	for (i = 0; i < intr_info.intr_cnt; i++) {
+		switch (intr_info.intr_types[i]) {
+		case DPMAIF_INTR_UL_DONE:
+			mtk_dpmaif_irq_tx_done(dcb, intr_info.intr_queues[i]);
+			break;
+		case DPMAIF_INTR_DL_BATCNT_LEN_ERR:
+			dcb->traffic_stats.irq_other_evt.dl_bat_cnt_len_err++;
+			bat_ring = &dcb->bat_info.normal_bat_ring;
+			bat_ring->bat_cnt_err_intr_set = true;
+			queue_work(dcb->bat_info.reload_wq, &bat_ring->reload_work);
+			break;
+		case DPMAIF_INTR_DL_FRGCNT_LEN_ERR:
+			dcb->traffic_stats.irq_other_evt.dl_frag_cnt_len_err++;
+			bat_ring = &dcb->bat_info.frag_bat_ring;
+			bat_ring->bat_cnt_err_intr_set = true;
+			if (dcb->bat_info.frag_bat_enabled)
+				queue_work(dcb->bat_info.reload_wq, &bat_ring->reload_work);
+			break;
+		case DPMAIF_INTR_DL_PITCNT_LEN_ERR:
+			mtk_dpmaif_irq_pit_len_err(dcb, intr_info.intr_queues[i]);
+			break;
+		case DPMAIF_INTR_DL_DONE:
+			mtk_dpmaif_irq_rx_done(dcb, intr_info.intr_queues[i]);
+			break;
+		default:
+			break;
+		}
+	}
+
+err_get_drv_irq_info:
+	mtk_hw_clear_irq(DCB_TO_MDEV(dcb), irq_param->dev_irq_id);
+	mtk_hw_unmask_irq(DCB_TO_MDEV(dcb), irq_param->dev_irq_id);
+out:
+	return IRQ_HANDLED;
+}
+
+static int mtk_dpmaif_irq_init(struct mtk_dpmaif_ctlb *dcb)
+{
+	unsigned char irq_cnt = dcb->res_cfg->irq_cnt;
+	struct dpmaif_irq_param *irq_param;
+	enum mtk_irq_src irq_src;
+	int ret = 0;
+	int i, j;
+
+	dcb->irq_params = devm_kcalloc(DCB_TO_DEV(dcb), irq_cnt, sizeof(*irq_param), GFP_KERNEL);
+	if (!dcb->irq_params)
+		return -ENOMEM;
+
+	for (i = 0; i < irq_cnt; i++) {
+		irq_param = &dcb->irq_params[i];
+		irq_param->idx = i;
+		irq_param->dcb = dcb;
+		irq_src = dcb->res_cfg->irq_src[i];
+		irq_param->dpmaif_irq_src = irq_src;
+		irq_param->dev_irq_id = mtk_hw_get_irq_id(DCB_TO_MDEV(dcb), irq_src);
+		if (irq_param->dev_irq_id < 0) {
+			dev_err(DCB_TO_DEV(dcb), "Failed to allocate irq id, irq_src=%d\n",
+				irq_src);
+			ret = -EINVAL;
+			goto err_reg_irq;
+		}
+
+		ret = mtk_hw_register_irq(DCB_TO_MDEV(dcb), irq_param->dev_irq_id,
+					  mtk_dpmaif_irq_handle, irq_param);
+		if (ret < 0) {
+			dev_err(DCB_TO_DEV(dcb), "Failed to register irq, irq_src=%d\n", irq_src);
+			goto err_reg_irq;
+		}
+	}
+
+	/* HW layer default mask dpmaif interrupt. */
+	dcb->irq_enabled = false;
+
+	return 0;
+err_reg_irq:
+	for (j = i - 1; j >= 0; j--) {
+		irq_param = &dcb->irq_params[j];
+		mtk_hw_unregister_irq(DCB_TO_MDEV(dcb), irq_param->dev_irq_id);
+	}
+
+	devm_kfree(DCB_TO_DEV(dcb), dcb->irq_params);
+	dcb->irq_params = NULL;
+
+	return ret;
+}
+
+static int mtk_dpmaif_irq_exit(struct mtk_dpmaif_ctlb *dcb)
+{
+	unsigned char irq_cnt = dcb->res_cfg->irq_cnt;
+	struct dpmaif_irq_param *irq_param;
+	int i;
+
+	for (i = 0; i < irq_cnt; i++) {
+		irq_param = &dcb->irq_params[i];
+		mtk_hw_unregister_irq(DCB_TO_MDEV(dcb), irq_param->dev_irq_id);
+	}
+
+	devm_kfree(DCB_TO_DEV(dcb), dcb->irq_params);
+	dcb->irq_params = NULL;
+
+	return 0;
+}
+
+static int mtk_dpmaif_hw_init(struct mtk_dpmaif_ctlb *dcb)
+{
+	struct dpmaif_bat_ring *bat_ring;
+	struct dpmaif_drv_cfg drv_cfg;
+	struct dpmaif_rxq *rxq;
+	struct dpmaif_txq *txq;
+	int ret;
+	int i;
+
+	memset(&drv_cfg, 0x00, sizeof(struct dpmaif_drv_cfg));
+
+	bat_ring = &dcb->bat_info.normal_bat_ring;
+	drv_cfg.normal_bat_base = bat_ring->bat_dma_addr;
+	drv_cfg.normal_bat_cnt = bat_ring->bat_cnt;
+	drv_cfg.normal_bat_buf_size = bat_ring->buf_size;
+
+	if (dcb->bat_info.frag_bat_enabled) {
+		drv_cfg.features |= DATA_HW_F_FRAG;
+		bat_ring = &dcb->bat_info.frag_bat_ring;
+		drv_cfg.frag_bat_base = bat_ring->bat_dma_addr;
+		drv_cfg.frag_bat_cnt = bat_ring->bat_cnt;
+		drv_cfg.frag_bat_buf_size = bat_ring->buf_size;
+	}
+
+	if (dcb->res_cfg->cap & DATA_HW_F_LRO && dpmaif_lro_enable)
+		drv_cfg.features |= DATA_HW_F_LRO;
+
+	drv_cfg.max_mtu = dcb->bat_info.max_mtu;
+
+	for (i = 0; i < dcb->res_cfg->rxq_cnt; i++) {
+		rxq = &dcb->rxqs[i];
+		drv_cfg.pit_base[i] = rxq->pit_dma_addr;
+		drv_cfg.pit_cnt[i] = rxq->pit_cnt;
+	}
+
+	for (i = 0; i < dcb->res_cfg->txq_cnt; i++) {
+		txq = &dcb->txqs[i];
+		drv_cfg.drb_base[i] = txq->drb_dma_addr;
+		drv_cfg.drb_cnt[i] = txq->drb_cnt;
+	}
+
+	ret = mtk_dpmaif_drv_init(dcb->drv_info, &drv_cfg);
+	if (ret < 0)
+		dev_err(DCB_TO_DEV(dcb), "Failed to initialize dpmaif hw\n");
+
+	return ret;
+}
+
+static int mtk_dpmaif_start(struct mtk_dpmaif_ctlb *dcb)
+{
+	struct dpmaif_bat_ring *bat_ring;
+	unsigned int normal_buf_cnt;
+	unsigned int frag_buf_cnt;
+	int ret;
+
+	if (dcb->dpmaif_state == DPMAIF_STATE_PWRON) {
+		dev_err(DCB_TO_DEV(dcb), "Invalid parameters, dpmaif_state in PWRON\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Reload all buffer around normal bat. */
+	bat_ring = &dcb->bat_info.normal_bat_ring;
+	normal_buf_cnt = bat_ring->bat_cnt - 1;
+	ret = mtk_dpmaif_reload_rx_buf(dcb, bat_ring, normal_buf_cnt, false);
+	if (ret < 0) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to reload normal bat buffer\n");
+		goto out;
+	}
+
+	/* Reload all buffer around normal bat. */
+	if (dcb->bat_info.frag_bat_enabled) {
+		bat_ring = &dcb->bat_info.frag_bat_ring;
+		frag_buf_cnt = bat_ring->bat_cnt - 1;
+		ret = mtk_dpmaif_reload_rx_buf(dcb, bat_ring, frag_buf_cnt, false);
+		if (ret < 0) {
+			dev_err(DCB_TO_DEV(dcb), "Failed to reload frag bat buffer\n");
+			goto out;
+		}
+	}
+
+	/* Initialize dpmaif hw. */
+	ret = mtk_dpmaif_hw_init(dcb);
+	if (ret < 0) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to initialize dpmaif hw\n");
+		goto out;
+	}
+
+	/* Send doorbell to dpmaif HW about normal bat buffer count. */
+	ret = mtk_dpmaif_drv_send_doorbell(dcb->drv_info, DPMAIF_BAT, 0, normal_buf_cnt);
+	if (unlikely(ret < 0)) {
+		dev_err(DCB_TO_DEV(dcb),
+			"Failed to send normal bat buffer count doorbell\n");
+		mtk_dpmaif_common_err_handle(dcb, true);
+		goto out;
+	}
+
+	/* Send doorbell to dpmaif HW about frag bat buffer count. */
+	if (dcb->bat_info.frag_bat_enabled) {
+		ret = mtk_dpmaif_drv_send_doorbell(dcb->drv_info, DPMAIF_FRAG, 0, frag_buf_cnt);
+		if (unlikely(ret < 0)) {
+			dev_err(DCB_TO_DEV(dcb),
+				"Failed to send frag bat buffer count doorbell\n");
+			mtk_dpmaif_common_err_handle(dcb, true);
+			goto out;
+		}
+	}
+
+	/* Initialize and run all tx services. */
+	ret = mtk_dpmaif_tx_srvs_start(dcb);
+	if (ret < 0) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to start all tx srvs\n");
+		goto out;
+	}
+
+	dcb->dpmaif_state = DPMAIF_STATE_PWRON;
+	mtk_dpmaif_disable_irq(dcb);
+
+	return 0;
+out:
+	return ret;
+}
+
+static void mtk_dpmaif_sw_reset(struct mtk_dpmaif_ctlb *dcb)
+{
+	mtk_dpmaif_tx_res_reset(dcb);
+	mtk_dpmaif_rx_res_reset(dcb);
+	mtk_dpmaif_bat_res_reset(&dcb->bat_info);
+	mtk_dpmaif_tx_vqs_reset(dcb);
+	skb_queue_purge(&dcb->cmd_vq.list);
+	memset(&dcb->traffic_stats, 0x00, sizeof(struct dpmaif_traffic_stats));
+	dcb->dpmaif_user_ready = false;
+	dcb->trans_enabled = false;
+}
+
+static int mtk_dpmaif_stop(struct mtk_dpmaif_ctlb *dcb)
+{
+	if (dcb->dpmaif_state == DPMAIF_STATE_PWROFF)
+		goto out;
+
+	/* The flow of trans control as follow depends on dpmaif state,
+	 * so change state firstly.
+	 */
+	dcb->dpmaif_state = DPMAIF_STATE_PWROFF;
+
+	/* Stop all tx service. */
+	mtk_dpmaif_tx_srvs_stop(dcb);
+
+	/* Stop dpmaif tx/rx handle. */
+	mtk_dpmaif_trans_ctl(dcb, false);
+out:
+	return 0;
+}
+
+static void mtk_dpmaif_fsm_callback(struct mtk_fsm_param *fsm_param, void *data)
+{
+	struct mtk_dpmaif_ctlb *dcb = data;
+
+	if (!dcb || !fsm_param) {
+		pr_warn("Invalid fsm parameter\n");
+		return;
+	}
+
+	switch (fsm_param->to) {
+	case FSM_STATE_OFF:
+		mtk_dpmaif_stop(dcb);
+
+		/* Flush all cmd process. */
+		flush_work(&dcb->cmd_srv.work);
+
+		/* clear data structure */
+		mtk_dpmaif_sw_reset(dcb);
+		break;
+	case FSM_STATE_BOOTUP:
+		if (fsm_param->fsm_flag == FSM_F_MD_HS_START)
+			mtk_dpmaif_start(dcb);
+		break;
+	case FSM_STATE_READY:
+		break;
+	case FSM_STATE_MDEE:
+		if (fsm_param->fsm_flag == FSM_F_MDEE_INIT)
+			mtk_dpmaif_stop(dcb);
+		break;
+	default:
+		break;
+	}
+}
+
+static int mtk_dpmaif_fsm_init(struct mtk_dpmaif_ctlb *dcb)
+{
+	int ret;
+
+	ret = mtk_fsm_notifier_register(DCB_TO_MDEV(dcb), MTK_USER_DPMAIF,
+					mtk_dpmaif_fsm_callback, dcb, FSM_PRIO_1, false);
+	if (ret < 0)
+		dev_err(DCB_TO_DEV(dcb), "Failed to register dpmaif fsm notifier\n");
+
+	return ret;
+}
+
+static int mtk_dpmaif_fsm_exit(struct mtk_dpmaif_ctlb *dcb)
+{
+	int ret;
+
+	ret = mtk_fsm_notifier_unregister(DCB_TO_MDEV(dcb), MTK_USER_DPMAIF);
+	if (ret < 0)
+		dev_err(DCB_TO_DEV(dcb), "Failed to unregister dpmaif fsm notifier\n");
+
+	return ret;
+}
+
+static int mtk_dpmaif_sw_init(struct mtk_data_blk *data_blk, const struct dpmaif_res_cfg *res_cfg)
+{
+	struct mtk_dpmaif_ctlb *dcb;
+	int ret;
+
+	dcb = devm_kzalloc(data_blk->mdev->dev, sizeof(*dcb), GFP_KERNEL);
+	if (!dcb)
+		return -ENOMEM;
+
+	data_blk->dcb = dcb;
+	dcb->data_blk = data_blk;
+	dcb->dpmaif_state = DPMAIF_STATE_PWROFF;
+	dcb->dpmaif_user_ready = false;
+	dcb->trans_enabled = false;
+	mutex_init(&dcb->trans_ctl_lock);
+	dcb->res_cfg = res_cfg;
+
+	/* interrupt coalesce init */
+	dcb->intr_coalesce.rx_coalesced_frames = DPMAIF_DFLT_INTR_RX_COA_FRAMES;
+	dcb->intr_coalesce.tx_coalesced_frames = DPMAIF_DFLT_INTR_TX_COA_FRAMES;
+	dcb->intr_coalesce.rx_coalesce_usecs = DPMAIF_DFLT_INTR_RX_COA_USECS;
+	dcb->intr_coalesce.tx_coalesce_usecs = DPMAIF_DFLT_INTR_TX_COA_USECS;
+
+	/* Check and set normal and frag bat buffer size. */
+	mtk_dpmaif_set_bat_buf_size(dcb, DPMAIF_DFLT_MTU);
+
+	ret = mtk_dpmaif_sw_res_init(dcb);
+	if (ret < 0) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to initialize dpmaif sw res, ret=%d\n", ret);
+		goto err_init_sw_res;
+	}
+
+	ret = mtk_dpmaif_tx_srvs_init(dcb);
+	if (ret < 0) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to initialize dpmaif tx res, ret=%d\n", ret);
+		goto err_init_tx_res;
+	}
+
+	ret = mtk_dpmaif_cmd_srvs_init(dcb);
+	if (ret < 0) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to initialize dpmaif tx cmd res, ret=%d\n", ret);
+		goto err_init_ctl_res;
+	}
+
+	ret = mtk_dpmaif_drv_res_init(dcb);
+	if (ret < 0) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to initialize dpmaif drv res, ret=%d\n", ret);
+		goto err_init_drv_res;
+	}
+
+	ret = mtk_dpmaif_fsm_init(dcb);
+	if (ret < 0) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to initialize dpmaif fsm, ret=%d\n", ret);
+		goto err_init_fsm;
+	}
+
+	ret = mtk_dpmaif_irq_init(dcb);
+	if (ret < 0) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to initialize dpmaif int, ret=%d\n", ret);
+		goto err_init_irq;
+	}
+
+	return 0;
+
+err_init_irq:
+	mtk_dpmaif_fsm_exit(dcb);
+err_init_fsm:
+	mtk_dpmaif_drv_res_exit(dcb);
+err_init_drv_res:
+	mtk_dpmaif_cmd_srvs_exit(dcb);
+err_init_ctl_res:
+	mtk_dpmaif_tx_srvs_exit(dcb);
+err_init_tx_res:
+	mtk_dpmaif_sw_res_exit(dcb);
+err_init_sw_res:
+
+	devm_kfree(DCB_TO_DEV(dcb), dcb);
+	data_blk->dcb = NULL;
+
+	return ret;
+}
+
+static int mtk_dpmaif_sw_exit(struct mtk_data_blk *data_blk)
+{
+	struct mtk_dpmaif_ctlb *dcb = data_blk->dcb;
+	int ret = 0;
+
+	if (!data_blk->dcb) {
+		pr_err("Invalid parameter\n");
+		return -EINVAL;
+	}
+
+	mtk_dpmaif_irq_exit(dcb);
+	mtk_dpmaif_fsm_exit(dcb);
+	mtk_dpmaif_drv_res_exit(dcb);
+	mtk_dpmaif_cmd_srvs_exit(dcb);
+	mtk_dpmaif_tx_srvs_exit(dcb);
+	mtk_dpmaif_sw_res_exit(dcb);
+
+	devm_kfree(DCB_TO_DEV(dcb), dcb);
+
+	return ret;
+}
+
+static int mtk_dpmaif_poll_rx_pit(struct dpmaif_rxq *rxq)
+{
+	struct mtk_dpmaif_ctlb *dcb = rxq->dcb;
+	unsigned int sw_rd_idx, hw_wr_idx;
+	unsigned int pit_cnt;
+	int ret;
+
+	sw_rd_idx = rxq->pit_rd_idx;
+	ret = mtk_dpmaif_drv_get_ring_idx(dcb->drv_info, DPMAIF_PIT_WIDX, rxq->id);
+	if (unlikely(ret < 0)) {
+		dev_err(DCB_TO_DEV(dcb),
+			"Failed to read rxq%u hw pit_wr_idx, ret=%d\n", rxq->id, ret);
+		mtk_dpmaif_common_err_handle(dcb, true);
+		goto out;
+	}
+
+	hw_wr_idx = ret;
+	pit_cnt = mtk_dpmaif_ring_buf_readable(rxq->pit_cnt, sw_rd_idx, hw_wr_idx);
+	rxq->pit_wr_idx = hw_wr_idx;
+
+	return pit_cnt;
+
+out:
+	return ret;
+}
+
+#define DPMAIF_POLL_STEP 20
+#define DPMAIF_POLL_PIT_CNT_MAX 100
+#define DPMAIF_PIT_SEQ_CHECK_FAIL_CNT 2500
+
+static int mtk_dpmaif_check_pit_seq(struct dpmaif_rxq *rxq, struct dpmaif_pd_pit *pit)
+{
+	unsigned int expect_pit_seq, cur_pit_seq;
+	unsigned int count = 0;
+	int ret;
+
+	expect_pit_seq = rxq->pit_seq_expect;
+	/* The longest check time is 2ms, step is 20us */
+	do {
+		cur_pit_seq = FIELD_GET(PIT_PD_SEQ, le32_to_cpu(pit->pd_footer));
+		if (cur_pit_seq > DPMAIF_PIT_SEQ_MAX) {
+			dev_err(DCB_TO_DEV(rxq->dcb),
+				"Invalid rxq%u pit sequence number, cur_seq(%u) > max_seq(%u)\n",
+				rxq->id, cur_pit_seq, DPMAIF_PIT_SEQ_MAX);
+			break;
+		}
+
+		if (cur_pit_seq == expect_pit_seq) {
+			rxq->pit_seq_expect++;
+			if (rxq->pit_seq_expect >= DPMAIF_PIT_SEQ_MAX)
+				rxq->pit_seq_expect = 0;
+
+			rxq->pit_seq_fail_cnt = 0;
+			ret = 0;
+
+			goto out;
+		} else {
+			count++;
+		}
+
+		udelay(DPMAIF_POLL_STEP);
+	} while (count <= DPMAIF_POLL_PIT_CNT_MAX);
+
+	/* If pit sequence doesn't pass in 5 seconds. */
+	ret = -DATA_PIT_SEQ_CHK_FAIL;
+	rxq->pit_seq_fail_cnt++;
+	if (rxq->pit_seq_fail_cnt >= DPMAIF_PIT_SEQ_CHECK_FAIL_CNT) {
+		mtk_dpmaif_common_err_handle(rxq->dcb, true);
+		rxq->pit_seq_fail_cnt = 0;
+	}
+
+out:
+	return ret;
+}
+
+static void mtk_dpmaif_rx_msg_pit(struct dpmaif_rxq *rxq, struct dpmaif_msg_pit *msg_pit,
+				  struct dpmaif_rx_record *rx_record)
+{
+	rx_record->cur_ch_id = FIELD_GET(PIT_MSG_CHNL_ID, le32_to_cpu(msg_pit->dword1));
+	rx_record->checksum = FIELD_GET(PIT_MSG_CHECKSUM, le32_to_cpu(msg_pit->dword1));
+	rx_record->pit_dp = FIELD_GET(PIT_MSG_DP, le32_to_cpu(msg_pit->dword1));
+	rx_record->hash = FIELD_GET(PIT_MSG_HASH, le32_to_cpu(msg_pit->dword3));
+}
+
+static int mtk_dpmaif_pit_bid_check(struct dpmaif_rxq *rxq, unsigned int cur_bid)
+{
+	union dpmaif_bat_record *cur_bat_record;
+	struct mtk_dpmaif_ctlb *dcb = rxq->dcb;
+	struct dpmaif_bat_ring *bat_ring;
+	int ret = 0;
+
+	bat_ring = &rxq->dcb->bat_info.normal_bat_ring;
+	cur_bat_record = bat_ring->sw_record_base + cur_bid;
+
+	if (unlikely(!cur_bat_record->normal.skb || cur_bid >= bat_ring->bat_cnt)) {
+		dev_err(DCB_TO_DEV(dcb),
+			"Invalid parameter rxq%u bat%d, bid=%u, bat_cnt=%u\n",
+			rxq->id, bat_ring->type, cur_bid, bat_ring->bat_cnt);
+		ret = -DATA_FLOW_CHK_ERR;
+	}
+
+	return ret;
+}
+
+static int mtk_dpmaif_rx_set_data_to_skb(struct dpmaif_rxq *rxq, struct dpmaif_pd_pit *pit_info,
+					 struct dpmaif_rx_record *rx_record)
+{
+	struct dpmaif_bat_ring *bat_ring = &rxq->dcb->bat_info.normal_bat_ring;
+	unsigned long long data_dma_addr, data_dma_base_addr;
+	struct mtk_dpmaif_ctlb *dcb = rxq->dcb;
+	union dpmaif_bat_record *bat_record;
+	struct sk_buff *new_skb;
+	unsigned int *tmp_u32;
+	unsigned int data_len;
+	int data_offset;
+
+	bat_record = bat_ring->sw_record_base + mtk_dpmaif_pit_bid(pit_info);
+	new_skb = bat_record->normal.skb;
+	data_dma_base_addr = (unsigned long long)bat_record->normal.data_dma_addr;
+
+	dma_unmap_single(dcb->data_blk->mdev->dev, bat_record->normal.data_dma_addr,
+			 bat_record->normal.data_len, DMA_FROM_DEVICE);
+
+	/* Calculate data address and data length. */
+	data_dma_addr = le32_to_cpu(pit_info->addr_high);
+	data_dma_addr = (data_dma_addr << 32) + le32_to_cpu(pit_info->addr_low);
+	data_offset = (int)(data_dma_addr - data_dma_base_addr);
+	data_len = FIELD_GET(PIT_PD_DATA_LEN, le32_to_cpu(pit_info->pd_header));
+
+	/* Only the header_offset of the first packet of lro skb is zero,
+	 * and other packet's header_offset is not zero.
+	 * The data_len is the packet len that has subtracted the packet header length.
+	 */
+	if (FIELD_GET(PIT_PD_HD_OFFSET, le32_to_cpu(pit_info->pd_footer)) != 0)
+		data_len += (FIELD_GET(PIT_PD_HD_OFFSET, le32_to_cpu(pit_info->pd_footer)) * 4);
+
+	/* Check and rebuild skb. */
+	new_skb->len = 0;
+	skb_reset_tail_pointer(new_skb);
+	skb_reserve(new_skb, data_offset);
+	if (unlikely((new_skb->tail + data_len) > new_skb->end)) {
+		dev_err(DCB_TO_DEV(dcb),
+			"pkt(%u/%u):len=%u, offset=0x%llx-0x%llx\n",
+			rxq->pit_rd_idx, mtk_dpmaif_pit_bid(pit_info), data_len,
+			data_dma_addr, data_dma_base_addr);
+
+		if (rxq->pit_rd_idx > 2) {
+			tmp_u32 = (unsigned int *)(rxq->pit_base + rxq->pit_rd_idx - 2);
+			dev_err(DCB_TO_DEV(dcb),
+				"pit(%u): 0x%08x, 0x%08x, 0x%08x,0x%08x\n"
+				"0x%08x, 0x%08x, 0x%08x, 0x%08x, 0x%08x\n",
+				rxq->pit_rd_idx - 2, tmp_u32[0], tmp_u32[1],
+				tmp_u32[2], tmp_u32[3], tmp_u32[4],
+				tmp_u32[5], tmp_u32[6],
+				tmp_u32[7], tmp_u32[8]);
+		}
+
+		return -DATA_FLOW_CHK_ERR;
+	}
+
+	skb_put(new_skb, data_len);
+
+	/* None first aggregated packet should reduce IP and Protocol header part. */
+	if (FIELD_GET(PIT_PD_HD_OFFSET, le32_to_cpu(pit_info->pd_footer)) != 0)
+		skb_pull(new_skb,
+			 FIELD_GET(PIT_PD_HD_OFFSET, le32_to_cpu(pit_info->pd_footer)) * 4);
+
+	rx_record->cur_skb = new_skb;
+	bat_record->normal.skb = NULL;
+
+	return 0;
+}
+
+static int mtk_dpmaif_bat_ring_set_mask(struct mtk_dpmaif_ctlb *dcb, enum dpmaif_bat_type type,
+					unsigned int bat_idx)
+{
+	struct dpmaif_bat_ring *bat_ring;
+	int ret = 0;
+
+	if (type == NORMAL_BAT)
+		bat_ring = &dcb->bat_info.normal_bat_ring;
+	else
+		bat_ring = &dcb->bat_info.frag_bat_ring;
+
+	if (likely(bat_ring->mask_tbl[bat_idx] == 0)) {
+		bat_ring->mask_tbl[bat_idx] = 1;
+	} else {
+		dev_err(DCB_TO_DEV(dcb), "Invalid bat%u mask_table[%u] value\n", type, bat_idx);
+		ret = -DATA_FLOW_CHK_ERR;
+	}
+
+	return ret;
+}
+
+static void mtk_dpmaif_lro_add_skb(struct mtk_dpmaif_ctlb *dcb, struct dpmaif_rx_record *rx_record)
+{
+	struct sk_buff *parent = rx_record->lro_parent;
+	struct sk_buff *last = rx_record->lro_last_skb;
+	struct sk_buff *cur_skb = rx_record->cur_skb;
+
+	if (!cur_skb) {
+		dev_err(DCB_TO_DEV(dcb), "Invalid cur_skb\n");
+		return;
+	}
+
+	if (parent) {
+		/* Update the len, data_len, truesize of the lro skb. */
+		parent->len += cur_skb->len;
+		parent->data_len += cur_skb->len;
+		parent->truesize += cur_skb->truesize;
+		if (last)
+			last->next = cur_skb;
+		else
+			skb_shinfo(parent)->frag_list = cur_skb;
+
+		last = cur_skb;
+		rx_record->lro_last_skb = last;
+	} else {
+		parent = cur_skb;
+		rx_record->lro_parent = parent;
+	}
+
+	rx_record->lro_pkt_cnt++;
+}
+
+static int mtk_dpmaif_get_rx_pkt(struct dpmaif_rxq *rxq, struct dpmaif_pd_pit *pit_info,
+				 struct dpmaif_rx_record *rx_record)
+{
+	struct mtk_dpmaif_ctlb *dcb = rxq->dcb;
+	unsigned int cur_bid;
+	int ret;
+
+	cur_bid = mtk_dpmaif_pit_bid(pit_info);
+
+	/* Check the bid in pit information, don't exceed bat size. */
+	ret = mtk_dpmaif_pit_bid_check(rxq, cur_bid);
+	if (unlikely(ret < 0)) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to check rxq%u pit normal bid\n", rxq->id);
+		goto out;
+	}
+
+	/* Receive data from bat and save to rx_record. */
+	ret = mtk_dpmaif_rx_set_data_to_skb(rxq, pit_info, rx_record);
+	if (unlikely(ret < 0)) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to set rxq%u data to skb\n", rxq->id);
+		goto out;
+	}
+
+	/* Set bat mask that have been received. */
+	ret = mtk_dpmaif_bat_ring_set_mask(dcb, NORMAL_BAT, cur_bid);
+	if (unlikely(ret < 0)) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to rxq%u set bat mask\n", rxq->id);
+		goto out;
+	}
+
+	/* Set current skb to lro skb. */
+	mtk_dpmaif_lro_add_skb(dcb, rx_record);
+
+	return 0;
+
+out:
+	return ret;
+}
+
+static int mtk_dpmaif_pit_bid_frag_check(struct dpmaif_rxq *rxq, unsigned int cur_bid)
+{
+	union dpmaif_bat_record *cur_bat_record;
+	struct mtk_dpmaif_ctlb *dcb = rxq->dcb;
+	struct dpmaif_bat_ring *bat_ring;
+	int ret = 0;
+
+	bat_ring = &rxq->dcb->bat_info.frag_bat_ring;
+	cur_bat_record = bat_ring->sw_record_base + cur_bid;
+
+	if (unlikely(!cur_bat_record->frag.page || cur_bid >= bat_ring->bat_cnt)) {
+		dev_err(DCB_TO_DEV(dcb),
+			"Invalid parameter rxq%u bat%d, bid=%u, bat_cnt=%u\n",
+			rxq->id, bat_ring->type, cur_bid, bat_ring->bat_cnt);
+		ret = -DATA_FLOW_CHK_ERR;
+	}
+
+	return ret;
+}
+
+static void mtk_dpmaif_lro_add_frag(struct dpmaif_rx_record *rx_record, unsigned int frags_len)
+{
+	struct sk_buff *frags_base_skb = rx_record->cur_skb;
+	struct sk_buff *parent = rx_record->lro_parent;
+
+	/* The frags item do not belong to the lro parent skb,
+	 * it belongs to the lro frags skb, so, must update the lro parent skb data.
+	 */
+	if (parent != frags_base_skb) {
+		/* Non-linear zone data length(frags[] and frag_list). */
+		parent->data_len += frags_len;
+		/* Non-linear zone data length + linear zone data length. */
+		parent->len += frags_len;
+		/* The all data length. */
+		parent->truesize += frags_len;
+	}
+}
+
+static int mtk_dpmaif_rx_set_frag_to_skb(struct dpmaif_rxq *rxq, struct dpmaif_pd_pit *pit_info,
+					 struct dpmaif_rx_record *rx_record)
+{
+	struct dpmaif_bat_ring *bat_ring = &rxq->dcb->bat_info.frag_bat_ring;
+	unsigned long long data_dma_addr, data_dma_base_addr;
+	struct sk_buff *base_skb = rx_record->cur_skb;
+	struct mtk_dpmaif_ctlb *dcb = rxq->dcb;
+	union dpmaif_bat_record *bat_record;
+	struct page_mapped_t *cur_frag;
+	unsigned int page_offset;
+	unsigned int data_len;
+	struct page *page;
+	int data_offset;
+
+	bat_record = bat_ring->sw_record_base + mtk_dpmaif_pit_bid(pit_info);
+	cur_frag = &bat_record->frag;
+	page = cur_frag->page;
+	page_offset = cur_frag->offset;
+	data_dma_base_addr = (unsigned long long)cur_frag->data_dma_addr;
+
+	dma_unmap_page(DCB_TO_DEV(dcb), cur_frag->data_dma_addr,
+		       cur_frag->data_len, DMA_FROM_DEVICE);
+
+	/* Calculate data address and data length. */
+	data_dma_addr = le32_to_cpu(pit_info->addr_high);
+	data_dma_addr = (data_dma_addr << 32) + le32_to_cpu(pit_info->addr_low);
+	data_offset = (int)(data_dma_addr - data_dma_base_addr);
+	data_len = FIELD_GET(PIT_PD_DATA_LEN, le32_to_cpu(pit_info->pd_header));
+
+	/* Add fragment data to cur_skb->frags[]. */
+	skb_add_rx_frag(base_skb, skb_shinfo(base_skb)->nr_frags, page,
+			page_offset + data_offset, data_len, cur_frag->data_len);
+
+	/* Record data length to lro parent. */
+	mtk_dpmaif_lro_add_frag(rx_record, data_len);
+
+	cur_frag->page = NULL;
+
+	return 0;
+}
+
+static int mtk_dpmaif_get_rx_frag(struct dpmaif_rxq *rxq, struct dpmaif_pd_pit *pit_info,
+				  struct dpmaif_rx_record *rx_record)
+{
+	struct mtk_dpmaif_ctlb *dcb = rxq->dcb;
+	unsigned int cur_bid;
+	int ret;
+
+	cur_bid = mtk_dpmaif_pit_bid(pit_info);
+
+	/* Check the bid in pit information, don't exceed frag bat size. */
+	ret = mtk_dpmaif_pit_bid_frag_check(rxq, cur_bid);
+	if (unlikely(ret < 0)) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to check rxq%u pit frag bid\n", rxq->id);
+		goto out;
+	}
+
+	/* Receive data from frag bat and save to currunt skb. */
+	ret = mtk_dpmaif_rx_set_frag_to_skb(rxq, pit_info, rx_record);
+	if (unlikely(ret < 0)) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to set rxq%u frag to skb\n", rxq->id);
+		goto out;
+	}
+
+	/* Set bat mask that have been received. */
+	ret = mtk_dpmaif_bat_ring_set_mask(dcb, FRAG_BAT, cur_bid);
+	if (unlikely(ret < 0)) {
+		dev_err(DCB_TO_DEV(dcb), "Failed to rxq%u set frag bat mask\n", rxq->id);
+		goto out;
+	}
+
+	return 0;
+out:
+	return ret;
+}
+
+static void mtk_dpmaif_set_rcsum(struct sk_buff *skb, unsigned int hw_checksum_state)
+{
+	if (hw_checksum_state == CS_RESULT_PASS)
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+	else
+		skb->ip_summed = CHECKSUM_NONE;
+}
+
+static void mtk_dpmaif_set_rxhash(struct sk_buff *skb, u32 hw_hash)
+{
+	skb_set_hash(skb, hw_hash, PKT_HASH_TYPE_L4);
+}
+
+static int mtk_dpmaif_rx_skb(struct dpmaif_rxq *rxq, struct dpmaif_rx_record *rx_record)
+{
+	struct sk_buff *new_skb = rx_record->lro_parent;
+	struct mtk_dpmaif_ctlb *dcb = rxq->dcb;
+	int ret = 0;
+
+	if (unlikely(rx_record->pit_dp)) {
+		dcb->traffic_stats.rx_hw_ind_dropped[rxq->id]++;
+		dev_kfree_skb_any(new_skb);
+		goto out;
+	}
+
+	/* Check HW rx checksum offload status. */
+	mtk_dpmaif_set_rcsum(new_skb, rx_record->checksum);
+
+	/* Set skb hash from HW. */
+	mtk_dpmaif_set_rxhash(new_skb, rx_record->hash);
+
+	skb_record_rx_queue(new_skb, rxq->id);
+
+	dcb->traffic_stats.rx_packets[rxq->id]++;
+out:
+	rx_record->lro_parent = NULL;
+	return ret;
+}
+
+static int mtk_dpmaif_recycle_pit_internal(struct dpmaif_rxq *rxq, unsigned short pit_rel_cnt)
+{
+	unsigned short old_sw_rel_idx, new_sw_rel_idx, old_hw_wr_idx;
+	struct mtk_dpmaif_ctlb *dcb = rxq->dcb;
+	int ret = 0;
+
+	old_sw_rel_idx = rxq->pit_rel_rd_idx;
+	new_sw_rel_idx = old_sw_rel_idx + pit_rel_cnt;
+	old_hw_wr_idx = rxq->pit_wr_idx;
+
+	/* Queue is empty and no need to release. */
+	if (old_hw_wr_idx == old_sw_rel_idx)
+		dev_err(DCB_TO_DEV(dcb), "old_hw_wr_idx == old_sw_rel_idx\n");
+
+	/* pit_rel_rd_idx should not exceed pit_wr_idx. */
+	if (old_hw_wr_idx > old_sw_rel_idx) {
+		if (new_sw_rel_idx > old_hw_wr_idx)
+			dev_err(DCB_TO_DEV(dcb), "new_rel_idx > old_hw_wr_idx\n");
+	} else if (old_hw_wr_idx < old_sw_rel_idx) {
+		if (new_sw_rel_idx >= rxq->pit_cnt) {
+			new_sw_rel_idx = new_sw_rel_idx - rxq->pit_cnt;
+			if (new_sw_rel_idx > old_hw_wr_idx)
+				dev_err(DCB_TO_DEV(dcb), "new_rel_idx > old_wr_idx\n");
+		}
+	}
+
+	/* Notify the available pit count to HW. */
+	ret = mtk_dpmaif_drv_send_doorbell(dcb->drv_info, DPMAIF_PIT, rxq->id, pit_rel_cnt);
+	if (unlikely(ret < 0)) {
+		dev_err(DCB_TO_DEV(dcb),
+			"Failed to send pit doorbell,pit-r/w/rel-%u,%u,%u, rel_pit_cnt=%u, ret=%d\n",
+			rxq->pit_rd_idx, rxq->pit_wr_idx,
+			rxq->pit_rel_rd_idx, pit_rel_cnt, ret);
+		mtk_dpmaif_common_err_handle(dcb, true);
+	}
+
+	rxq->pit_rel_rd_idx = new_sw_rel_idx;
+
+	return ret;
+}
+
+static int mtk_dpmaif_recycle_rx_ring(struct dpmaif_rxq *rxq)
+{
+	int ret = 0;
+
+	/* burst recycle check */
+	if (rxq->pit_rel_cnt < rxq->pit_burst_rel_cnt)
+		return 0;
+
+	if (unlikely(rxq->pit_rel_cnt > rxq->pit_cnt)) {
+		dev_err(DCB_TO_DEV(rxq->dcb), "Invalid rxq%u pit release count, %u>%u\n",
+			rxq->id, rxq->pit_rel_cnt, rxq->pit_cnt);
+		ret = -DATA_FLOW_CHK_ERR;
+		goto out;
+	}
+
+	ret = mtk_dpmaif_recycle_pit_internal(rxq, rxq->pit_rel_cnt);
+	if (unlikely(ret < 0)) {
+		dev_err(DCB_TO_DEV(rxq->dcb), "Failed to rxq%u recycle pit, ret=%d\n",
+			rxq->id, ret);
+	}
+
+	rxq->pit_rel_cnt = 0;
+
+	mtk_dpmaif_queue_bat_reload_work(rxq->dcb);
+
+	if (rxq->pit_cnt_err_intr_set) {
+		rxq->pit_cnt_err_intr_set = false;
+		mtk_dpmaif_drv_intr_complete(rxq->dcb->drv_info,
+					     DPMAIF_INTR_DL_PITCNT_LEN_ERR, rxq->id, 0);
+	}
+
+out:
+	return ret;
+}
+
+static int mtk_dpmaif_rx_data_collect_internal(struct dpmaif_rxq *rxq, int pit_cnt, int budget,
+					       unsigned int *pkt_cnt)
+{
+	struct dpmaif_rx_record *rx_record = &rxq->rx_record;
+	struct mtk_dpmaif_ctlb *dcb = rxq->dcb;
+	struct dpmaif_pd_pit *pit_info;
+	unsigned int recv_pkt_cnt = 0;
+	unsigned int rx_cnt, cur_pit;
+	int ret;
+
+	cur_pit = rxq->pit_rd_idx;
+	for (rx_cnt = 0; rx_cnt < pit_cnt; rx_cnt++) {
+		/* Check if reach rx packet budget. */
+		if (!rx_record->msg_pit_recv) {
+			if (recv_pkt_cnt >= budget)
+				break;
+		}
+
+		/* Pit sequence check. */
+		pit_info = rxq->pit_base + cur_pit;
+		ret = mtk_dpmaif_check_pit_seq(rxq, pit_info);
+		if (unlikely(ret < 0))
+			break;
+
+		/* Parse message pit. */
+		if (FIELD_GET(PIT_PD_PKT_TYPE, le32_to_cpu(pit_info->pd_header)) == MSG_PIT) {
+			if (unlikely(rx_record->msg_pit_recv)) {
+				if (rx_record->lro_parent) {
+					dcb->traffic_stats.rx_errors[rxq->id]++;
+					dcb->traffic_stats.rx_dropped[rxq->id]++;
+					dev_kfree_skb_any(rx_record->lro_parent);
+				}
+
+				memset(&rxq->rx_record, 0x00, sizeof(rxq->rx_record));
+			}
+
+			rx_record->msg_pit_recv = true;
+			mtk_dpmaif_rx_msg_pit(rxq, (struct dpmaif_msg_pit *)pit_info, rx_record);
+		} else {
+			/* Parse normal pit or frag pit. */
+			if (FIELD_GET(PIT_PD_BUF_TYPE, le32_to_cpu(pit_info->pd_header)) !=
+			    FRAG_BAT) {
+				ret = mtk_dpmaif_get_rx_pkt(rxq, pit_info, rx_record);
+			} else {
+				/* Pit sequence: normal pit + frag pit. */
+				if (likely(rx_record->cur_skb))
+					ret = mtk_dpmaif_get_rx_frag(rxq, pit_info, rx_record);
+				else
+					/* Unexpected pit sequence: message pit + frag pit. */
+					ret = -DATA_FLOW_CHK_ERR;
+			}
+
+			if (unlikely(ret < 0)) {
+				/* Move on pit index to skip error data. */
+				rx_record->err_payload = 1;
+				mtk_dpmaif_common_err_handle(dcb, true);
+			}
+
+			/* Last one pit of a packet. */
+			if (FIELD_GET(PIT_PD_CONT, le32_to_cpu(pit_info->pd_header)) ==
+			    DPMAIF_PIT_LASTONE) {
+				if (likely(rx_record->err_payload == 0)) {
+					mtk_dpmaif_rx_skb(rxq, rx_record);
+				} else {
+					if (rx_record->cur_skb) {
+						dcb->traffic_stats.rx_errors[rxq->id]++;
+						dcb->traffic_stats.rx_dropped[rxq->id]++;
+						dev_kfree_skb_any(rx_record->lro_parent);
+						rx_record->lro_parent = NULL;
+					}
+				}
+				memset(&rxq->rx_record, 0x00, sizeof(rxq->rx_record));
+				recv_pkt_cnt++;
+			}
+		}
+
+		cur_pit = mtk_dpmaif_ring_buf_get_next_idx(rxq->pit_cnt, cur_pit);
+		rxq->pit_rd_idx = cur_pit;
+
+		rxq->pit_rel_cnt++;
+	}
+
+	*pkt_cnt = recv_pkt_cnt;
+
+	/* Recycle pit and reload bat in batches. */
+	ret = mtk_dpmaif_recycle_rx_ring(rxq);
+	if (unlikely(ret < 0))
+		dev_err(DCB_TO_DEV(dcb), "Failed to recycle rxq%u pit\n", rxq->id);
+
+	return ret;
+}
+
+static int mtk_dpmaif_rx_data_collect(struct dpmaif_rxq *rxq, int budget, unsigned int *pkt_cnt)
+{
+	struct mtk_dpmaif_ctlb *dcb = rxq->dcb;
+	unsigned int pit_cnt;
+	int ret;
+
+	/* Get pit count that will be collected and update pit_wr_idx from hardware. */
+	ret = mtk_dpmaif_poll_rx_pit(rxq);
+	if (unlikely(ret < 0))
+		goto out;
+
+	pit_cnt = ret;
+	if (likely(pit_cnt > 0)) {
+		ret = mtk_dpmaif_rx_data_collect_internal(rxq, pit_cnt, budget, pkt_cnt);
+		if (ret <= -DATA_DL_ONCE_MORE) {
+			ret = -DATA_DL_ONCE_MORE;
+		} else if (ret <= -DATA_ERR_STOP_MAX) {
+			ret = -DATA_ERR_STOP_MAX;
+			mtk_dpmaif_common_err_handle(dcb, true);
+		} else {
+			ret = 0;
+		}
+	}
+
+out:
+	return ret;
+}
+
+static int mtk_dpmaif_rx_data_collect_more(struct dpmaif_rxq *rxq, int budget, int *work_done)
+{
+	unsigned int total_pkt_cnt = 0, pkt_cnt;
+	int each_budget;
+	int ret = 0;
+
+	do {
+		each_budget = budget - total_pkt_cnt;
+		pkt_cnt = 0;
+		ret = mtk_dpmaif_rx_data_collect(rxq, each_budget, &pkt_cnt);
+		total_pkt_cnt += pkt_cnt;
+		if (ret < 0)
+			break;
+	} while (total_pkt_cnt < budget && pkt_cnt > 0 && rxq->started);
+
+	*work_done = total_pkt_cnt;
+
+	return ret;
+}
+
+static int mtk_dpmaif_rx_napi_poll(struct napi_struct *napi, int budget)
+{
+	struct dpmaif_rxq *rxq = container_of(napi, struct dpmaif_rxq, napi);
+	struct dpmaif_traffic_stats *stats = &rxq->dcb->traffic_stats;
+	struct mtk_dpmaif_ctlb *dcb = rxq->dcb;
+	int work_done = 0;
+	int ret;
+
+	if (likely(rxq->started)) {
+		ret = mtk_dpmaif_rx_data_collect_more(rxq, budget, &work_done);
+		stats->rx_done_last_cnt[rxq->id] += work_done;
+		if (ret == -DATA_DL_ONCE_MORE) {
+			napi_gro_flush(napi, false);
+			work_done = budget;
+		}
+	}
+
+	if (work_done < budget) {
+		napi_complete_done(napi, work_done);
+		mtk_dpmaif_drv_clear_ip_busy(dcb->drv_info);
+		mtk_dpmaif_drv_intr_complete(dcb->drv_info, DPMAIF_INTR_DL_DONE, rxq->id, 0);
+	}
+
+	return work_done;
+}
+
+enum dpmaif_pkt_type {
+	PKT_UNKNOWN,
+	PKT_EMPTY_ACK,
+	PKT_ECHO
+};
+
+static enum dpmaif_pkt_type mtk_dpmaif_check_skb_type(struct sk_buff *skb, enum mtk_pkt_type type)
+{
+	int ret = PKT_UNKNOWN;
+	struct tcphdr *tcph;
+	int inner_offset;
+	__be16 frag_off;
+	u32 total_len;
+	u32 pkt_type;
+	u8 nexthdr;
+
+	union {
+		struct iphdr *v4;
+		struct ipv6hdr *v6;
+		unsigned char *hdr;
+	} ip;
+	union {
+		struct icmphdr *v4;
+		struct icmp6hdr *v6;
+		unsigned char *hdr;
+	} icmp;
+
+	pkt_type = skb->data[0] & 0xF0;
+	if (pkt_type == IPV4_VERSION) {
+		ip.v4 = (struct iphdr *)(skb->data);
+		if (ip.v4->protocol == IPPROTO_ICMP) {
+			icmp.v4 = (struct icmphdr *)(skb->data + (ip.v4->ihl << 2));
+			if (icmp.v4->type == ICMP_ECHO)
+				ret = PKT_ECHO;
+		} else if (ip.v4->protocol == IPPROTO_TCP) {
+			tcph = (struct tcphdr *)(skb->data + (ip.v4->ihl << 2));
+			if (((ip.v4->ihl << 2) + (tcph->doff << 2)) == (ntohs(ip.v4->tot_len)) &&
+			    !tcph->syn && !tcph->fin && !tcph->rst)
+				ret = PKT_EMPTY_ACK;
+		}
+	} else if (pkt_type == IPV6_VERSION) {
+		ip.v6 = (struct ipv6hdr *)skb->data;
+		nexthdr = ip.v6->nexthdr;
+		if (ipv6_ext_hdr(nexthdr)) {
+			/* Now skip over extension headers. */
+			inner_offset = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr),
+							&nexthdr, &frag_off);
+			if (inner_offset < 0)
+				goto out;
+		} else {
+			inner_offset = sizeof(struct ipv6hdr);
+		}
+
+		if (nexthdr == IPPROTO_ICMPV6) {
+			icmp.v6 = (struct icmp6hdr *)(skb->data + inner_offset);
+			if (icmp.v6->icmp6_type == ICMPV6_ECHO_REQUEST)
+				ret = PKT_ECHO;
+		} else if (nexthdr == IPPROTO_TCP) {
+			total_len = sizeof(struct ipv6hdr) + ntohs(ip.v6->payload_len);
+			tcph = (struct tcphdr *)(skb->data + inner_offset);
+			if (((total_len - inner_offset) == (tcph->doff << 2)) &&
+			    !tcph->syn && !tcph->fin && !tcph->rst)
+				ret = PKT_EMPTY_ACK;
+		}
+	}
+
+out:
+	return ret;
+}
+
+static int mtk_dpmaif_select_txq_800(struct sk_buff *skb, enum mtk_pkt_type type)
+{
+	enum dpmaif_pkt_type pkt_type;
+	__u32 skb_hash;
+	int q_id;
+
+	if (unlikely(!skb)) {
+		pr_warn("Invalid parameter\n");
+		return -EINVAL;
+	}
+
+	pkt_type = mtk_dpmaif_check_skb_type(skb, type);
+	if (pkt_type == PKT_EMPTY_ACK) {
+		q_id = 1;
+	} else if (pkt_type == PKT_ECHO) {
+		q_id = 2;
+	} else {
+		skb_hash = skb_get_hash(skb);
+		q_id = (skb_hash & 0x01) ? 0 : 4;
+	}
+
+	return q_id;
+}
+
+static void mtk_dpmaif_wake_up_tx_srv(struct dpmaif_tx_srv *tx_srv)
+{
+	wake_up(&tx_srv->wait);
+}
+
+static int mtk_dpmaif_send_pkt(struct mtk_dpmaif_ctlb *dcb, struct sk_buff *skb,
+			       unsigned char intf_id)
+{
+	unsigned char vq_id = skb_get_queue_mapping(skb);
+	struct dpmaif_pkt_info *pkt_info;
+	unsigned char srv_id;
+	struct dpmaif_vq *vq;
+	int ret = 0;
+
+	pkt_info = DPMAIF_SKB_CB(skb);
+	pkt_info->intf_id = intf_id;
+	pkt_info->drb_cnt = DPMAIF_GET_DRB_CNT(skb);
+
+	vq = &dcb->tx_vqs[vq_id];
+	srv_id = dcb->res_cfg->tx_vq_srv_map[vq_id];
+	if (likely(skb_queue_len(&vq->list) < vq->max_len))
+		skb_queue_tail(&vq->list, skb);
+	else
+		ret = -EBUSY;
+
+	mtk_dpmaif_wake_up_tx_srv(&dcb->tx_srvs[srv_id]);
+
+	return ret;
+}
+
+static int mtk_dpmaif_send_cmd(struct mtk_dpmaif_ctlb *dcb, struct sk_buff *skb)
+{
+	struct dpmaif_vq *vq = &dcb->cmd_vq;
+	int ret = 0;
+
+	if (likely(skb_queue_len(&vq->list) < vq->max_len))
+		skb_queue_tail(&vq->list, skb);
+	else
+		ret = -EBUSY;
+
+	schedule_work(&dcb->cmd_srv.work);
+
+	return ret;
+}
+
+static int mtk_dpmaif_send(struct mtk_data_blk *data_blk, enum mtk_data_type type,
+			   struct sk_buff *skb, u64 data)
+{
+	int ret;
+
+	if (unlikely(!data_blk || !skb || !data_blk->dcb)) {
+		pr_warn("Invalid parameter\n");
+		return -EINVAL;
+	}
+
+	if (likely(type == DATA_PKT))
+		ret = mtk_dpmaif_send_pkt(data_blk->dcb, skb, data);
+	else
+		ret = mtk_dpmaif_send_cmd(data_blk->dcb, skb);
+
+	return ret;
+}
+
+struct mtk_data_trans_ops data_trans_ops = {
+	.poll = mtk_dpmaif_rx_napi_poll,
+	.send = mtk_dpmaif_send,
+};
+
+/**
+ * mtk_data_init() - Initialize data path
+ * @mdev: pointer to mtk_md_dev
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
+int mtk_data_init(struct mtk_md_dev *mdev)
+{
+	const struct dpmaif_res_cfg *res_cfg;
+	struct mtk_data_blk *data_blk;
+	int ret;
+
+	if (!mdev) {
+		pr_err("Invalid parameter\n");
+		return -ENODEV;
+	}
+
+	data_blk = devm_kzalloc(mdev->dev, sizeof(*data_blk), GFP_KERNEL);
+	if (!data_blk)
+		return -ENOMEM;
+
+	data_blk->mdev = mdev;
+	mdev->data_blk = data_blk;
+
+	if (mdev->hw_ver == 0x0800) {
+		res_cfg = &res_cfg_t800;
+		data_trans_ops.select_txq = mtk_dpmaif_select_txq_800;
+	} else {
+		dev_err(mdev->dev, "Unsupported mdev, hw_ver=0x%x\n", mdev->hw_ver);
+		ret = -ENODEV;
+		goto err_get_hw_ver;
+	}
+
+	ret = mtk_dpmaif_sw_init(data_blk, res_cfg);
+	if (ret < 0) {
+		dev_err(mdev->dev, "Failed to initialize data trans, ret=%d\n", ret);
+		goto err_get_hw_ver;
+	}
+
+	return 0;
+
+err_get_hw_ver:
+	devm_kfree(mdev->dev, data_blk);
+	mdev->data_blk = NULL;
+
+	return ret;
+}
+
+/**
+ * mtk_data_exit() - Deinitialize data path
+ * @mdev: pointer to mtk_md_dev
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
+int mtk_data_exit(struct mtk_md_dev *mdev)
+{
+	int ret;
+
+	if (!mdev || !mdev->data_blk) {
+		pr_err("Invalid parameter\n");
+		return -EINVAL;
+	}
+
+	ret = mtk_dpmaif_sw_exit(mdev->data_blk);
+	if (ret < 0)
+		dev_err(mdev->dev, "Failed to exit data trans, ret=%d\n", ret);
+
+	devm_kfree(mdev->dev, mdev->data_blk);
+	mdev->data_blk = NULL;
+
+	return ret;
+}
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_pci.c b/drivers/net/wwan/mediatek/pcie/mtk_pci.c
index 5b91da25eb08..3669e5523d12 100644
--- a/drivers/net/wwan/mediatek/pcie/mtk_pci.c
+++ b/drivers/net/wwan/mediatek/pcie/mtk_pci.c
@@ -573,6 +573,11 @@ static bool mtk_pci_link_check(struct mtk_md_dev *mdev)
 	return !pci_device_is_present(to_pci_dev(mdev->dev));
 }
 
+static bool mtk_pci_mmio_check(struct mtk_md_dev *mdev)
+{
+	return mtk_pci_mac_read32(mdev->hw_priv, REG_ATR_PCIE_WIN0_T0_SRC_ADDR_LSB) == (u32)-1;
+}
+
 static int mtk_pci_get_hp_status(struct mtk_md_dev *mdev)
 {
 	struct mtk_pci_priv *priv = mdev->hw_priv;
@@ -611,6 +616,7 @@ static const struct mtk_hw_ops mtk_pci_ops = {
 	.get_ext_evt_status    = mtk_mhccif_get_evt_status,
 	.reset                 = mtk_pci_reset,
 	.reinit                = mtk_pci_reinit,
+	.mmio_check            = mtk_pci_mmio_check,
 	.get_hp_status         = mtk_pci_get_hp_status,
 };
 
-- 
2.32.0

