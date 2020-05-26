Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C816C1CE9E0
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 02:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgELA7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgELA7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:59:51 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22881C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:59:51 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id s20so4656231plp.6
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ivktc0GcVz9wzbx3WuBZhlZJUULl8NiPtxKwnq473dU=;
        b=e0zFsCuuLRtY7SRFU+roqdzja1zANnmy3m/+EMXi+r6PknLxAZLv+oqUoIGt/1143X
         TKGN4n4QpUVjIvalrMWhPwauJgQW5WNHU8NWGzXSrIFm7Z0znGOHrMT09TQE7rbyvF27
         AXtXbkvfY8uX7OVGbN7BlLW4uR3i2aZq8QGrhsQODYvS9ablKVesGNyrbn5wgQx51mmB
         rRg1KBZ1psw+dVOcKEhz4xBaXLP0FCNf++EYiaPkbdyoViRm2Etuwcyt0etPEawhEDFb
         ANjGfFraHIFZG0/+Xzq38Q+j23jxepOCnChEhezjk7DmAPywVcI5wobRBY8N0iFwDh2+
         1jJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ivktc0GcVz9wzbx3WuBZhlZJUULl8NiPtxKwnq473dU=;
        b=ABm+Oepxis94jIKVM8mt2BYxF4O6rVp9Yw1ci/f2ROJGOn62lijbJyaWcAeGTOMudA
         LN7HjyV8jkNvffBxYFZFksk8ZNMYr5MboodeyfH7MMn5ZQWPR3xF9ntCQWaO/OqEj/NX
         ohzRXzOpDTcMWIM4R81o2ybbdAAGFTM9lrenslekYPtEbYvO3JeCpQsr8M8bByuc8Gxp
         SCIqTQ+bPONYHahjh55OgCJp1ZidhUFMgkYq8fVGcts0SClT13HA6WnC/3KJPSoQ07Jv
         bNfZLLoQGI6lJ+N8z0CnMx2XMjuGZwHHoiemqdUA0D/DObIHVdb0UJPWWtR3H1HhkDOE
         hLfQ==
X-Gm-Message-State: AGi0PubffhkepFdG+QQ5OGZ9ungEIk3Si03yrHpFVHiTjEpgdvp9tQig
        Ol5IdJk3hdqxTYUpNDwbkEXa5kBf+Js=
X-Google-Smtp-Source: APiQypK68aFSVyI+gx0Vcqfs361ThSBAcyLfbz3wNSLtFHTqyMvaKcG+gc6BtooqLuQQ0B8YVTS3hQ==
X-Received: by 2002:a17:90a:f98b:: with SMTP id cq11mr25084016pjb.193.1589245189801;
        Mon, 11 May 2020 17:59:49 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h17sm10171477pfk.13.2020.05.11.17.59.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 17:59:49 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 01/10] ionic: support longer tx sg lists
Date:   Mon, 11 May 2020 17:59:27 -0700
Message-Id: <20200512005936.14490-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512005936.14490-1-snelson@pensando.io>
References: <20200512005936.14490-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The version 1 Tx queues can use longer SG lists than the
original version 0 queues, but we need to check to see if the
firmware supports the v1 Tx queues.  This implements the queue
type query for all queue types, and uses the information to
set up for using the longer Tx SG lists.

Because the Tx SG list can be longer, we need to limit the
max ring length to be sure we stay inside the boundaries of a
DMA allocation max size, so we lower the max Tx ring size.

The driver sets its highest known version in the Q_IDENTITY
command, and the FW returns the highest version that it knows,
bounded by the driver's version.  The negotiated version number
is later used in the Q_INIT commands.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  14 +++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   7 +-
 .../ethernet/pensando/ionic/ionic_ethtool.c   |   4 +-
 .../net/ethernet/pensando/ionic/ionic_if.h    | 112 ++++++++++++++---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 114 +++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  13 ++
 .../net/ethernet/pensando/ionic/ionic_main.c  |   2 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  27 +++--
 8 files changed, 263 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index f4ae40ae1e53..d83eff0ae0ac 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -388,6 +388,19 @@ int ionic_set_vf_config(struct ionic *ionic, int vf, u8 attr, u8 *data)
 }
 
 /* LIF commands */
+void ionic_dev_cmd_queue_identify(struct ionic_dev *idev,
+				  u16 lif_type, u8 qtype, u8 qver)
+{
+	union ionic_dev_cmd cmd = {
+		.q_identify.opcode = IONIC_CMD_Q_IDENTIFY,
+		.q_identify.lif_type = lif_type,
+		.q_identify.type = qtype,
+		.q_identify.ver = qver,
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
 void ionic_dev_cmd_lif_identify(struct ionic_dev *idev, u8 type, u8 ver)
 {
 	union ionic_dev_cmd cmd = {
@@ -431,6 +444,7 @@ void ionic_dev_cmd_adminq_init(struct ionic_dev *idev, struct ionic_qcq *qcq,
 		.q_init.opcode = IONIC_CMD_Q_INIT,
 		.q_init.lif_index = cpu_to_le16(lif_index),
 		.q_init.type = q->type,
+		.q_init.ver = qcq->q.lif->qtype_info[q->type].version,
 		.q_init.index = cpu_to_le32(q->index),
 		.q_init.flags = cpu_to_le16(IONIC_QINIT_F_IRQ |
 					    IONIC_QINIT_F_ENA),
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 587398b01997..33519a8765eb 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -12,7 +12,8 @@
 
 #define IONIC_MIN_MTU			ETH_MIN_MTU
 #define IONIC_MAX_MTU			9194
-#define IONIC_MAX_TXRX_DESC		16384
+#define IONIC_MAX_TX_DESC		8192
+#define IONIC_MAX_RX_DESC		16384
 #define IONIC_MIN_TXRX_DESC		16
 #define IONIC_DEF_TXRX_DESC		4096
 #define IONIC_LIFS_MAX			1024
@@ -83,6 +84,8 @@ static_assert(sizeof(struct ionic_q_init_cmd) == 64);
 static_assert(sizeof(struct ionic_q_init_comp) == 16);
 static_assert(sizeof(struct ionic_q_control_cmd) == 64);
 static_assert(sizeof(ionic_q_control_comp) == 16);
+static_assert(sizeof(struct ionic_q_identify_cmd) == 64);
+static_assert(sizeof(struct ionic_q_identify_comp) == 16);
 
 static_assert(sizeof(struct ionic_rx_mode_set_cmd) == 64);
 static_assert(sizeof(ionic_rx_mode_set_comp) == 16);
@@ -283,6 +286,8 @@ void ionic_dev_cmd_port_fec(struct ionic_dev *idev, u8 fec_type);
 void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type);
 
 int ionic_set_vf_config(struct ionic *ionic, int vf, u8 attr, u8 *data);
+void ionic_dev_cmd_queue_identify(struct ionic_dev *idev,
+				  u16 lif_type, u8 qtype, u8 qver);
 void ionic_dev_cmd_lif_identify(struct ionic_dev *idev, u8 type, u8 ver);
 void ionic_dev_cmd_lif_init(struct ionic_dev *idev, u16 lif_index,
 			    dma_addr_t addr);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 6996229facfd..3f9a73aaef61 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -458,9 +458,9 @@ static void ionic_get_ringparam(struct net_device *netdev,
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 
-	ring->tx_max_pending = IONIC_MAX_TXRX_DESC;
+	ring->tx_max_pending = IONIC_MAX_TX_DESC;
 	ring->tx_pending = lif->ntxq_descs;
-	ring->rx_max_pending = IONIC_MAX_TXRX_DESC;
+	ring->rx_max_pending = IONIC_MAX_RX_DESC;
 	ring->rx_pending = lif->nrxq_descs;
 }
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index ceeb7629e7a0..799f3ea599e9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -40,6 +40,7 @@ enum ionic_cmd_opcode {
 	IONIC_CMD_RX_FILTER_DEL			= 32,
 
 	/* Queue commands */
+	IONIC_CMD_Q_IDENTIFY			= 39,
 	IONIC_CMD_Q_INIT			= 40,
 	IONIC_CMD_Q_CONTROL			= 41,
 
@@ -469,6 +470,66 @@ struct ionic_lif_init_comp {
 	u8 rsvd2[12];
 };
 
+ /**
+  * struct ionic_q_identify_cmd - queue identify command
+  * @opcode:     opcode
+  * @lif_type:   LIF type (enum ionic_lif_type)
+  * @type:       Logical queue type (enum ionic_logical_qtype)
+  * @ver:        Highest queue type version that the driver supports
+  */
+struct ionic_q_identify_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 lif_type;
+	u8     type;
+	u8     ver;
+	u8     rsvd2[58];
+};
+
+/**
+ * struct ionic_q_identify_comp - queue identify command completion
+ * @status:     Status of the command (enum ionic_status_code)
+ * @comp_index: Index in the descriptor ring for which this is the completion
+ * @ver:        Queue type version that can be used with FW
+ */
+struct ionic_q_identify_comp {
+	u8     status;
+	u8     rsvd;
+	__le16 comp_index;
+	u8     ver;
+	u8     rsvd2[11];
+};
+
+/**
+ * union ionic_q_identity - queue identity information
+ *     @version:        Queue type version that can be used with FW
+ *     @supported:      Bitfield of queue versions, first bit = ver 0
+ *     @features:       Queue features
+ *     @desc_sz:        Descriptor size
+ *     @comp_sz:        Completion descriptor size
+ *     @sg_desc_sz:     Scatter/Gather descriptor size
+ *     @max_sg_elems:   Maximum number of Scatter/Gather elements
+ *     @sg_desc_stride: Number of Scatter/Gather elements per descriptor
+ */
+union ionic_q_identity {
+	struct {
+		u8      version;
+		u8      supported;
+		u8      rsvd[6];
+#define IONIC_QIDENT_F_CQ	0x01	/* queue has completion ring */
+#define IONIC_QIDENT_F_SG	0x02	/* queue has scatter/gather ring */
+#define IONIC_QIDENT_F_EQ	0x04	/* queue can use event queue */
+#define IONIC_QIDENT_F_CMB	0x08	/* queue is in cmb bar */
+		__le64  features;
+		__le16  desc_sz;
+		__le16  comp_sz;
+		__le16  sg_desc_sz;
+		__le16  max_sg_elems;
+		__le16  sg_desc_stride;
+	};
+	__le32 words[478];
+};
+
 /**
  * struct ionic_q_init_cmd - Queue init command
  * @opcode:       opcode
@@ -733,20 +794,31 @@ static inline void decode_txq_desc_cmd(u64 cmd, u8 *opcode, u8 *flags,
 	*addr = (cmd >> IONIC_TXQ_DESC_ADDR_SHIFT) & IONIC_TXQ_DESC_ADDR_MASK;
 };
 
-#define IONIC_TX_MAX_SG_ELEMS	8
-#define IONIC_RX_MAX_SG_ELEMS	8
-
 /**
- * struct ionic_txq_sg_desc - Transmit scatter-gather (SG) list
+ * struct ionic_txq_sg_elem - Transmit scatter-gather (SG) descriptor element
  * @addr:      DMA address of SG element data buffer
  * @len:       Length of SG element data buffer, in bytes
  */
+struct ionic_txq_sg_elem {
+	__le64 addr;
+	__le16 len;
+	__le16 rsvd[3];
+};
+
+/**
+ * struct ionic_txq_sg_desc - Transmit scatter-gather (SG) list
+ * @elems:     Scatter-gather elements
+ */
 struct ionic_txq_sg_desc {
-	struct ionic_txq_sg_elem {
-		__le64 addr;
-		__le16 len;
-		__le16 rsvd[3];
-	} elems[IONIC_TX_MAX_SG_ELEMS];
+#define IONIC_TX_MAX_SG_ELEMS		8
+#define IONIC_TX_SG_DESC_STRIDE		8
+	struct ionic_txq_sg_elem elems[IONIC_TX_MAX_SG_ELEMS];
+};
+
+struct ionic_txq_sg_desc_v1 {
+#define IONIC_TX_MAX_SG_ELEMS_V1		15
+#define IONIC_TX_SG_DESC_STRIDE_V1		16
+	struct ionic_txq_sg_elem elems[IONIC_TX_SG_DESC_STRIDE_V1];
 };
 
 /**
@@ -791,16 +863,24 @@ struct ionic_rxq_desc {
 };
 
 /**
- * struct ionic_rxq_sg_desc - Receive scatter-gather (SG) list
+ * struct ionic_rxq_sg_desc - Receive scatter-gather (SG) descriptor element
  * @addr:      DMA address of SG element data buffer
  * @len:       Length of SG element data buffer, in bytes
  */
+struct ionic_rxq_sg_elem {
+	__le64 addr;
+	__le16 len;
+	__le16 rsvd[3];
+};
+
+/**
+ * struct ionic_rxq_sg_desc - Receive scatter-gather (SG) list
+ * @elems:     Scatter-gather elements
+ */
 struct ionic_rxq_sg_desc {
-	struct ionic_rxq_sg_elem {
-		__le64 addr;
-		__le16 len;
-		__le16 rsvd[3];
-	} elems[IONIC_RX_MAX_SG_ELEMS];
+#define IONIC_RX_MAX_SG_ELEMS		8
+#define IONIC_RX_SG_DESC_STRIDE		8
+	struct ionic_rxq_sg_elem elems[IONIC_RX_SG_DESC_STRIDE];
 };
 
 /**
@@ -2389,6 +2469,7 @@ union ionic_dev_cmd {
 	struct ionic_qos_init_cmd qos_init;
 	struct ionic_qos_reset_cmd qos_reset;
 
+	struct ionic_q_identify_cmd q_identify;
 	struct ionic_q_init_cmd q_init;
 };
 
@@ -2421,6 +2502,7 @@ union ionic_dev_cmd_comp {
 	ionic_qos_init_comp qos_init;
 	ionic_qos_reset_comp qos_reset;
 
+	struct ionic_q_identify_comp q_identify;
 	struct ionic_q_init_comp q_init;
 };
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index d5293bfded29..0049f537ee40 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -17,6 +17,16 @@
 #include "ionic_ethtool.h"
 #include "ionic_debugfs.h"
 
+/* queuetype support level */
+static const u8 ionic_qtype_versions[IONIC_QTYPE_MAX] = {
+	[IONIC_QTYPE_ADMINQ]  = 0,   /* 0 = Base version with CQ support */
+	[IONIC_QTYPE_NOTIFYQ] = 0,   /* 0 = Base version */
+	[IONIC_QTYPE_RXQ]     = 0,   /* 0 = Base version with CQ+SG support */
+	[IONIC_QTYPE_TXQ]     = 1,   /* 0 = Base version with CQ+SG support
+				      * 1 =   ... with Tx SG version 1
+				      */
+};
+
 static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode);
 static int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr);
 static int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr);
@@ -27,6 +37,7 @@ static void ionic_lif_set_netdev_info(struct ionic_lif *lif);
 
 static int ionic_start_queues(struct ionic_lif *lif);
 static void ionic_stop_queues(struct ionic_lif *lif);
+static void ionic_lif_queue_identify(struct ionic_lif *lif);
 
 static void ionic_lif_deferred_work(struct work_struct *work)
 {
@@ -597,6 +608,7 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 			.opcode = IONIC_CMD_Q_INIT,
 			.lif_index = cpu_to_le16(lif->index),
 			.type = q->type,
+			.ver = lif->qtype_info[q->type].version,
 			.index = cpu_to_le32(q->index),
 			.flags = cpu_to_le16(IONIC_QINIT_F_IRQ |
 					     IONIC_QINIT_F_SG),
@@ -614,6 +626,8 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "txq_init.index %d\n", ctx.cmd.q_init.index);
 	dev_dbg(dev, "txq_init.ring_base 0x%llx\n", ctx.cmd.q_init.ring_base);
 	dev_dbg(dev, "txq_init.ring_size %d\n", ctx.cmd.q_init.ring_size);
+	dev_dbg(dev, "txq_init.flags 0x%x\n", ctx.cmd.q_init.flags);
+	dev_dbg(dev, "txq_init.ver %d\n", ctx.cmd.q_init.ver);
 
 	q->tail = q->info;
 	q->head = q->tail;
@@ -646,6 +660,7 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 			.opcode = IONIC_CMD_Q_INIT,
 			.lif_index = cpu_to_le16(lif->index),
 			.type = q->type,
+			.ver = lif->qtype_info[q->type].version,
 			.index = cpu_to_le32(q->index),
 			.flags = cpu_to_le16(IONIC_QINIT_F_IRQ |
 					     IONIC_QINIT_F_SG),
@@ -663,6 +678,8 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "rxq_init.index %d\n", ctx.cmd.q_init.index);
 	dev_dbg(dev, "rxq_init.ring_base 0x%llx\n", ctx.cmd.q_init.ring_base);
 	dev_dbg(dev, "rxq_init.ring_size %d\n", ctx.cmd.q_init.ring_size);
+	dev_dbg(dev, "rxq_init.flags 0x%x\n", ctx.cmd.q_init.flags);
+	dev_dbg(dev, "rxq_init.ver %d\n", ctx.cmd.q_init.ver);
 
 	q->tail = q->info;
 	q->head = q->tail;
@@ -726,7 +743,7 @@ static bool ionic_notifyq_service(struct ionic_cq *cq,
 		}
 		break;
 	default:
-		netdev_warn(netdev, "Notifyq unknown event ecode=%d eid=%lld\n",
+		netdev_warn(netdev, "Notifyq event ecode=%d eid=%lld\n",
 			    comp->event.ecode, eid);
 		break;
 	}
@@ -1509,17 +1526,25 @@ static void ionic_txrx_free(struct ionic_lif *lif)
 
 static int ionic_txrx_alloc(struct ionic_lif *lif)
 {
+	unsigned int sg_desc_sz;
 	unsigned int flags;
 	unsigned int i;
 	int err = 0;
 
+	if (lif->qtype_info[IONIC_QTYPE_TXQ].version >= 1 &&
+	    lif->qtype_info[IONIC_QTYPE_TXQ].sg_desc_sz ==
+					  sizeof(struct ionic_txq_sg_desc_v1))
+		sg_desc_sz = sizeof(struct ionic_txq_sg_desc_v1);
+	else
+		sg_desc_sz = sizeof(struct ionic_txq_sg_desc);
+
 	flags = IONIC_QCQ_F_TX_STATS | IONIC_QCQ_F_SG;
 	for (i = 0; i < lif->nxqs; i++) {
 		err = ionic_qcq_alloc(lif, IONIC_QTYPE_TXQ, i, "tx", flags,
 				      lif->ntxq_descs,
 				      sizeof(struct ionic_txq_desc),
 				      sizeof(struct ionic_txq_comp),
-				      sizeof(struct ionic_txq_sg_desc),
+				      sg_desc_sz,
 				      lif->kern_pid, &lif->txqcqs[i].qcq);
 		if (err)
 			goto err_out;
@@ -2065,9 +2090,17 @@ int ionic_lifs_alloc(struct ionic *ionic)
 
 	/* only build the first lif, others are for later features */
 	set_bit(0, ionic->lifbits);
+
 	lif = ionic_lif_alloc(ionic, 0);
+	if (IS_ERR_OR_NULL(lif)) {
+		clear_bit(0, ionic->lifbits);
+		return -ENOMEM;
+	}
+
+	lif->lif_type = IONIC_LIF_TYPE_CLASSIC;
+	ionic_lif_queue_identify(lif);
 
-	return PTR_ERR_OR_ZERO(lif);
+	return 0;
 }
 
 static void ionic_lif_reset(struct ionic_lif *lif)
@@ -2291,6 +2324,7 @@ static int ionic_lif_notifyq_init(struct ionic_lif *lif)
 			.opcode = IONIC_CMD_Q_INIT,
 			.lif_index = cpu_to_le16(lif->index),
 			.type = q->type,
+			.ver = lif->qtype_info[q->type].version,
 			.index = cpu_to_le32(q->index),
 			.flags = cpu_to_le16(IONIC_QINIT_F_IRQ |
 					     IONIC_QINIT_F_ENA),
@@ -2573,6 +2607,80 @@ void ionic_lifs_unregister(struct ionic *ionic)
 		unregister_netdev(ionic->master_lif->netdev);
 }
 
+static void ionic_lif_queue_identify(struct ionic_lif *lif)
+{
+	struct ionic *ionic = lif->ionic;
+	union ionic_q_identity *q_ident;
+	struct ionic_dev *idev;
+	int qtype;
+	int err;
+
+	idev = &lif->ionic->idev;
+	q_ident = (union ionic_q_identity *)&idev->dev_cmd_regs->data;
+
+	for (qtype = 0; qtype < ARRAY_SIZE(ionic_qtype_versions); qtype++) {
+		struct ionic_qtype_info *qti = &lif->qtype_info[qtype];
+
+		/* filter out the ones we know about */
+		switch (qtype) {
+		case IONIC_QTYPE_ADMINQ:
+		case IONIC_QTYPE_NOTIFYQ:
+		case IONIC_QTYPE_RXQ:
+		case IONIC_QTYPE_TXQ:
+			break;
+		default:
+			continue;
+		}
+
+		memset(qti, 0, sizeof(*qti));
+
+		mutex_lock(&ionic->dev_cmd_lock);
+		ionic_dev_cmd_queue_identify(idev, lif->lif_type, qtype,
+					     ionic_qtype_versions[qtype]);
+		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+		if (!err) {
+			qti->version   = q_ident->version;
+			qti->supported = q_ident->supported;
+			qti->features  = le64_to_cpu(q_ident->features);
+			qti->desc_sz   = le16_to_cpu(q_ident->desc_sz);
+			qti->comp_sz   = le16_to_cpu(q_ident->comp_sz);
+			qti->sg_desc_sz   = le16_to_cpu(q_ident->sg_desc_sz);
+			qti->max_sg_elems = le16_to_cpu(q_ident->max_sg_elems);
+			qti->sg_desc_stride = le16_to_cpu(q_ident->sg_desc_stride);
+		}
+		mutex_unlock(&ionic->dev_cmd_lock);
+
+		if (err == -EINVAL) {
+			dev_err(ionic->dev, "qtype %d not supported\n", qtype);
+			continue;
+		} else if (err == -EIO) {
+			dev_err(ionic->dev, "q_ident failed, not supported on older FW\n");
+			return;
+		} else if (err) {
+			dev_err(ionic->dev, "q_ident failed, qtype %d: %d\n",
+				qtype, err);
+			return;
+		}
+
+		dev_dbg(ionic->dev, " qtype[%d].version = %d\n",
+			qtype, qti->version);
+		dev_dbg(ionic->dev, " qtype[%d].supported = 0x%02x\n",
+			qtype, qti->supported);
+		dev_dbg(ionic->dev, " qtype[%d].features = 0x%04llx\n",
+			qtype, qti->features);
+		dev_dbg(ionic->dev, " qtype[%d].desc_sz = %d\n",
+			qtype, qti->desc_sz);
+		dev_dbg(ionic->dev, " qtype[%d].comp_sz = %d\n",
+			qtype, qti->comp_sz);
+		dev_dbg(ionic->dev, " qtype[%d].sg_desc_sz = %d\n",
+			qtype, qti->sg_desc_sz);
+		dev_dbg(ionic->dev, " qtype[%d].max_sg_elems = %d\n",
+			qtype, qti->max_sg_elems);
+		dev_dbg(ionic->dev, " qtype[%d].sg_desc_stride = %d\n",
+			qtype, qti->sg_desc_stride);
+	}
+}
+
 int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
 		       union ionic_lif_identity *lid)
 {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 5d4ffda5c05f..1a30f0fb20b9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -133,6 +133,17 @@ enum ionic_lif_state_flags {
 	IONIC_LIF_F_STATE_SIZE
 };
 
+struct ionic_qtype_info {
+	u8  version;
+	u8  supported;
+	u64 features;
+	u16 desc_sz;
+	u16 comp_sz;
+	u16 sg_desc_sz;
+	u16 max_sg_elems;
+	u16 sg_desc_stride;
+};
+
 #define IONIC_LIF_NAME_MAX_SZ		32
 struct ionic_lif {
 	char name[IONIC_LIF_NAME_MAX_SZ];
@@ -161,11 +172,13 @@ struct ionic_lif {
 	bool mc_overflow;
 	unsigned int nmcast;
 	bool uc_overflow;
+	u16 lif_type;
 	unsigned int nucast;
 
 	struct ionic_lif_info *info;
 	dma_addr_t info_pa;
 	u32 info_sz;
+	struct ionic_qtype_info qtype_info[IONIC_QTYPE_MAX];
 
 	u16 rss_types;
 	u8 rss_hash_key[IONIC_RSS_HASH_KEY_SIZE];
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 3ed150512091..8e2436d14621 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -152,6 +152,8 @@ static const char *ionic_opcode_to_str(enum ionic_cmd_opcode opcode)
 		return "IONIC_CMD_RX_FILTER_ADD";
 	case IONIC_CMD_RX_FILTER_DEL:
 		return "IONIC_CMD_RX_FILTER_DEL";
+	case IONIC_CMD_Q_IDENTIFY:
+		return "IONIC_CMD_Q_IDENTIFY";
 	case IONIC_CMD_Q_INIT:
 		return "IONIC_CMD_Q_INIT";
 	case IONIC_CMD_Q_CONTROL:
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index d233b6e77b1e..6b14e55a6780 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -10,8 +10,10 @@
 #include "ionic_lif.h"
 #include "ionic_txrx.h"
 
-static void ionic_rx_clean(struct ionic_queue *q, struct ionic_desc_info *desc_info,
-			   struct ionic_cq_info *cq_info, void *cb_arg);
+static void ionic_rx_clean(struct ionic_queue *q,
+			   struct ionic_desc_info *desc_info,
+			   struct ionic_cq_info *cq_info,
+			   void *cb_arg);
 
 static inline void ionic_txq_post(struct ionic_queue *q, bool ring_dbell,
 				  ionic_desc_cb cb_func, void *cb_arg)
@@ -140,8 +142,10 @@ static struct sk_buff *ionic_rx_copybreak(struct ionic_queue *q,
 	return skb;
 }
 
-static void ionic_rx_clean(struct ionic_queue *q, struct ionic_desc_info *desc_info,
-			   struct ionic_cq_info *cq_info, void *cb_arg)
+static void ionic_rx_clean(struct ionic_queue *q,
+			   struct ionic_desc_info *desc_info,
+			   struct ionic_cq_info *cq_info,
+			   void *cb_arg)
 {
 	struct ionic_rxq_comp *comp = cq_info->cq_desc;
 	struct ionic_qcq *qcq = q_to_qcq(q);
@@ -475,7 +479,8 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-static dma_addr_t ionic_tx_map_single(struct ionic_queue *q, void *data, size_t len)
+static dma_addr_t ionic_tx_map_single(struct ionic_queue *q,
+				      void *data, size_t len)
 {
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
 	struct device *dev = q->lif->ionic->dev;
@@ -491,7 +496,8 @@ static dma_addr_t ionic_tx_map_single(struct ionic_queue *q, void *data, size_t
 	return dma_addr;
 }
 
-static dma_addr_t ionic_tx_map_frag(struct ionic_queue *q, const skb_frag_t *frag,
+static dma_addr_t ionic_tx_map_frag(struct ionic_queue *q,
+				    const skb_frag_t *frag,
 				    size_t offset, size_t len)
 {
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
@@ -507,8 +513,10 @@ static dma_addr_t ionic_tx_map_frag(struct ionic_queue *q, const skb_frag_t *fra
 	return dma_addr;
 }
 
-static void ionic_tx_clean(struct ionic_queue *q, struct ionic_desc_info *desc_info,
-			   struct ionic_cq_info *cq_info, void *cb_arg)
+static void ionic_tx_clean(struct ionic_queue *q,
+			   struct ionic_desc_info *desc_info,
+			   struct ionic_cq_info *cq_info,
+			   void *cb_arg)
 {
 	struct ionic_txq_sg_desc *sg_desc = desc_info->sg_desc;
 	struct ionic_txq_sg_elem *elem = sg_desc->elems;
@@ -989,6 +997,7 @@ static int ionic_tx(struct ionic_queue *q, struct sk_buff *skb)
 
 static int ionic_tx_descs_needed(struct ionic_queue *q, struct sk_buff *skb)
 {
+	int sg_elems = q->lif->qtype_info[IONIC_QTYPE_TXQ].max_sg_elems;
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
 	int err;
 
@@ -997,7 +1006,7 @@ static int ionic_tx_descs_needed(struct ionic_queue *q, struct sk_buff *skb)
 		return (skb->len / skb_shinfo(skb)->gso_size) + 1;
 
 	/* If non-TSO, just need 1 desc and nr_frags sg elems */
-	if (skb_shinfo(skb)->nr_frags <= IONIC_TX_MAX_SG_ELEMS)
+	if (skb_shinfo(skb)->nr_frags <= sg_elems)
 		return 1;
 
 	/* Too many frags, so linearize */
-- 
2.17.1

