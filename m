Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C581560D8C5
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 03:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbiJZBQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 21:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiJZBP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 21:15:59 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DDCBC7A8;
        Tue, 25 Oct 2022 18:15:53 -0700 (PDT)
X-UUID: e2f45432e6954cda92ac2fe6f8fc4e37-20221026
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=23YfaR65q/OD+yKYJnQt9nKcHgK+E1JZtbLIaB9+hd8=;
        b=H2D3m6I+9B8LZ3GKYjd+eq37tP8ilWSs1v9JNjTyNIe+c1z7+AU6NfXwb2ZWudfDnVB7fYsbKGdsQ/njEw7V5UGCyN95oLna46jggTDd/v/zqWE3sH5FIgv//E8O5k5LMszCxqgFFt+F/FWCmSe1e5gnPykcrUPy3P2ub57A3sQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:d1deb060-ed61-421d-8db9-884ba8a52ef9,IP:0,U
        RL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:20
X-CID-META: VersionHash:62cd327,CLOUDID:23c8a9e4-e572-4957-be22-d8f73f3158f9,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:5,IP:nil,UR
        L:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: e2f45432e6954cda92ac2fe6f8fc4e37-20221026
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
        (envelope-from <haozhe.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 489359374; Wed, 26 Oct 2022 09:15:48 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 26 Oct 2022 09:15:46 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 26 Oct 2022 09:15:45 +0800
From:   <haozhe.chang@mediatek.com>
To:     <chandrashekar.devegowda@intel.com>, <linuxwwan@intel.com>,
        <chiranjeevi.rapolu@linux.intel.com>, <haijun.liu@mediatek.com>,
        <m.chetan.kumar@linux.intel.com>,
        <ricardo.martinez@linux.intel.com>, <loic.poulain@linaro.org>,
        <ryazanov.s.a@gmail.com>, <johannes@sipsolutions.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <lambert.wang@mediatek.com>, <xiayu.zhang@mediatek.com>,
        haozhe chang <haozhe.chang@mediatek.com>
Subject: [PATCH] wwan: core: Support slicing in port TX flow of WWAN subsystem
Date:   Wed, 26 Oct 2022 09:15:40 +0800
Message-ID: <20221026011540.8499-1-haozhe.chang@mediatek.com>
X-Mailer: git-send-email 2.17.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SPF_TEMPERROR,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: haozhe chang <haozhe.chang@mediatek.com>

wwan_port_fops_write inputs the SKB parameter to the TX callback of
the WWAN device driver. However, the WWAN device (e.g., t7xx) may
have an MTU less than the size of SKB, causing the TX buffer to be
sliced and copied once more in the WWAN device driver.

This patch implements the slicing in the WWAN subsystem and gives
the WWAN devices driver the option to slice(by chunk) or not. By
doing so, the additional memory copy is reduced.

Meanwhile, this patch gives WWAN devices driver the option to reserve
headroom in SKB for the device-specific metadata.

Signed-off-by: haozhe chang <haozhe.chang@mediatek.com>
---
 drivers/net/wwan/t7xx/t7xx_port_wwan.c | 41 ++++++++++++-----------
 drivers/net/wwan/wwan_core.c           | 45 ++++++++++++++++++--------
 include/linux/wwan.h                   |  5 ++-
 3 files changed, 56 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_port_wwan.c b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
index 33931bfd78fd..5e8589582121 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_wwan.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_wwan.c
@@ -54,13 +54,12 @@ static void t7xx_port_ctrl_stop(struct wwan_port *port)
 static int t7xx_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
 {
 	struct t7xx_port *port_private = wwan_port_get_drvdata(port);
-	size_t len, offset, chunk_len = 0, txq_mtu = CLDMA_MTU;
 	const struct t7xx_port_conf *port_conf;
 	struct t7xx_fsm_ctl *ctl;
 	enum md_state md_state;
+	int ret;
 
-	len = skb->len;
-	if (!len || !port_private->chan_enable)
+	if (!port_private->chan_enable)
 		return -EINVAL;
 
 	port_conf = port_private->port_conf;
@@ -72,33 +71,33 @@ static int t7xx_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
 		return -ENODEV;
 	}
 
-	for (offset = 0; offset < len; offset += chunk_len) {
-		struct sk_buff *skb_ccci;
-		int ret;
-
-		chunk_len = min(len - offset, txq_mtu - sizeof(struct ccci_header));
-		skb_ccci = t7xx_port_alloc_skb(chunk_len);
-		if (!skb_ccci)
-			return -ENOMEM;
-
-		skb_put_data(skb_ccci, skb->data + offset, chunk_len);
-		ret = t7xx_port_send_skb(port_private, skb_ccci, 0, 0);
-		if (ret) {
-			dev_kfree_skb_any(skb_ccci);
-			dev_err(port_private->dev, "Write error on %s port, %d\n",
-				port_conf->name, ret);
-			return ret;
-		}
+	ret = t7xx_port_send_skb(port_private, skb, 0, 0);
+	if (ret) {
+		dev_err(port_private->dev, "Write error on %s port, %d\n",
+			port_conf->name, ret);
+		return ret;
 	}
-
 	dev_kfree_skb(skb);
+
 	return 0;
 }
 
+static size_t t7xx_port_get_tx_rsvd_headroom(struct wwan_port *port)
+{
+	return sizeof(struct ccci_header);
+}
+
+static size_t t7xx_port_get_tx_chunk_len(struct wwan_port *port)
+{
+	return CLDMA_MTU - sizeof(struct ccci_header);
+}
+
 static const struct wwan_port_ops wwan_ops = {
 	.start = t7xx_port_ctrl_start,
 	.stop = t7xx_port_ctrl_stop,
 	.tx = t7xx_port_ctrl_tx,
+	.get_tx_rsvd_headroom = t7xx_port_get_tx_rsvd_headroom,
+	.get_tx_chunk_len = t7xx_port_get_tx_chunk_len,
 };
 
 static int t7xx_port_wwan_init(struct t7xx_port *port)
diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 62e9f7d6c9fe..366d324f7132 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -20,7 +20,7 @@
 #include <uapi/linux/wwan.h>
 
 /* Maximum number of minors in use */
-#define WWAN_MAX_MINORS		(1 << MINORBITS)
+#define WWAN_MAX_MINORS		BIT(MINORBITS)
 
 static DEFINE_MUTEX(wwan_register_lock); /* WWAN device create|remove lock */
 static DEFINE_IDA(minors); /* minors for WWAN port chardevs */
@@ -67,6 +67,8 @@ struct wwan_device {
  * @rxq: Buffer inbound queue
  * @waitqueue: The waitqueue for port fops (read/write/poll)
  * @data_lock: Port specific data access serialization
+ * @rsvd_headroom_len: SKB reserved headroom size
+ * @chunk_len: Chunk len to split packet
  * @at_data: AT port specific data
  */
 struct wwan_port {
@@ -79,6 +81,8 @@ struct wwan_port {
 	struct sk_buff_head rxq;
 	wait_queue_head_t waitqueue;
 	struct mutex data_lock;	/* Port specific data access serialization */
+	size_t rsvd_headroom_len;
+	size_t chunk_len;
 	union {
 		struct {
 			struct ktermios termios;
@@ -550,8 +554,13 @@ static int wwan_port_op_start(struct wwan_port *port)
 	}
 
 	/* If port is already started, don't start again */
-	if (!port->start_count)
+	if (!port->start_count) {
 		ret = port->ops->start(port);
+		if (port->ops->get_tx_chunk_len)
+			port->chunk_len = port->ops->get_tx_chunk_len(port);
+		if (port->ops->get_tx_rsvd_headroom)
+			port->rsvd_headroom_len = port->ops->get_tx_rsvd_headroom(port);
+	}
 
 	if (!ret)
 		port->start_count++;
@@ -698,6 +707,7 @@ static ssize_t wwan_port_fops_read(struct file *filp, char __user *buf,
 static ssize_t wwan_port_fops_write(struct file *filp, const char __user *buf,
 				    size_t count, loff_t *offp)
 {
+	size_t len, chunk_len, offset, allowed_chunk_len;
 	struct wwan_port *port = filp->private_data;
 	struct sk_buff *skb;
 	int ret;
@@ -706,19 +716,28 @@ static ssize_t wwan_port_fops_write(struct file *filp, const char __user *buf,
 	if (ret)
 		return ret;
 
-	skb = alloc_skb(count, GFP_KERNEL);
-	if (!skb)
-		return -ENOMEM;
-
-	if (copy_from_user(skb_put(skb, count), buf, count)) {
-		kfree_skb(skb);
-		return -EFAULT;
-	}
+	allowed_chunk_len = port->chunk_len ? port->chunk_len : count;
+	for (offset = 0; offset < count; offset += chunk_len) {
+		chunk_len = min(count - offset, allowed_chunk_len);
+		len = chunk_len + port->rsvd_headroom_len;
+		skb = alloc_skb(len, GFP_KERNEL);
+		if (!skb)
+			return offset ? offset : -ENOMEM;
+
+		skb_reserve(skb, port->rsvd_headroom_len);
+		if (copy_from_user(skb_put(skb, chunk_len), buf + offset, chunk_len)) {
+			kfree_skb(skb);
+			return offset ? offset : -EFAULT;
+		}
 
-	ret = wwan_port_op_tx(port, skb, !!(filp->f_flags & O_NONBLOCK));
-	if (ret) {
+		ret = wwan_port_op_tx(port, skb, !!(filp->f_flags & O_NONBLOCK));
+		if (!ret)
+			continue;
 		kfree_skb(skb);
-		return ret;
+		if (ret < 0)
+			return offset ? offset : ret;
+		if (ret > 0 && ret != chunk_len)
+			return offset + ret;
 	}
 
 	return count;
diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index 5ce2acf444fb..cf58b3479cb2 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -46,6 +46,8 @@ struct wwan_port;
  * @tx: Non-blocking routine that sends WWAN port protocol data to the device.
  * @tx_blocking: Optional blocking routine that sends WWAN port protocol data
  *               to the device.
+ * @get_tx_rsvd_headroom: Optional routine that sets reserve headroom of skb.
+ * @get_tx_chunk_len: Optional routine that sets chunk len to split.
  * @tx_poll: Optional routine that sets additional TX poll flags.
  *
  * The wwan_port_ops structure contains a list of low-level operations
@@ -58,6 +60,8 @@ struct wwan_port_ops {
 
 	/* Optional operations */
 	int (*tx_blocking)(struct wwan_port *port, struct sk_buff *skb);
+	size_t (*get_tx_rsvd_headroom)(struct wwan_port *port);
+	size_t (*get_tx_chunk_len)(struct wwan_port *port);
 	__poll_t (*tx_poll)(struct wwan_port *port, struct file *filp,
 			    poll_table *wait);
 };
@@ -112,7 +116,6 @@ void wwan_port_rx(struct wwan_port *port, struct sk_buff *skb);
  */
 void wwan_port_txoff(struct wwan_port *port);
 
-
 /**
  * wwan_port_txon - Restart TX on WWAN port
  * @port: WWAN port for which TX must be restarted
-- 
2.17.0

