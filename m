Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8634F2FA5F7
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406613AbhARQVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406307AbhARQTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 11:19:17 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E0FC061793
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:17:57 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id g12so24460724ejf.8
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4TqlY3v8vEmT6h+/7pcpyeqPNHkaARMY3+DMnw0nKPY=;
        b=rB3heaTmORLLFnJLl1RlsuQCJgUqlNPY5OMvsqbOHTYernFWnNfOrN2fpVSe9W3mBF
         zCHb1tHEhL3BraJlarz6uIcwK7g8n3/7H3zPM3lM+cSpKlhzmPIsHAVWcAn4WfJMfUln
         DfEhYf/eWKLEdVsPc0BBf89sDDksDouKgdeJtoZ5y7kAazA9DEGwWB5k41+HBMd/R4Gc
         m7S3kUqrHoRtDaYe5mlXT3U/ESD4c8XTMGQPv9/QVQ6HXJkpeDN7jMuhA2K35Ni465lz
         Ih5DSGmG7LaB+jyrtxiyTMzqUx7vUSELvx9IG3gd+9oB5Xz8CkZMgxpb7S4fIwWfQwXl
         Ucqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4TqlY3v8vEmT6h+/7pcpyeqPNHkaARMY3+DMnw0nKPY=;
        b=B/GycjLUF2hhzzYdb2I1LkhQZl52O/4J5O1TVe1gxlcClfU5ZZw7qnVqfsx/UaHWJY
         UaomMXyqvmtTZIl0s3Tvi2ca40jpTGAMSEAWcSLQYKY6JEqOIta8UmdZLVCTH/uOcf+Z
         O5gnJPhOAhsBNOvQusGucFHBL6exCK9bjxrWRhjiScYBTdLuVMVOq0YKvdCINw4V2ghM
         U7fQQFaixxnlv2w+JQHv0tPs8EqZWGXDHSjcz5x8F8iuEgqKvlErPwofUo2+bXiunVIC
         At3his/VokxStOGTpQEwVfx1VNNDdu0+mXgWXzRSW1nrvsDYFYXRUu+7/W6LKqxheDVV
         y9ZA==
X-Gm-Message-State: AOAM532NuaGquWsGGv8TgJoOtgcOmLEyYyDqgYC0i1fcCs51xllvTE7T
        kD+AQrCLfHmIceC8pSYEGCQ=
X-Google-Smtp-Source: ABdhPJxBN8oPk+fqlMnmRzb9tNqsR3u+V3AVme+K0aVhdy57ESjywfOuQ5D1qlGFq1+OQFwt2Dc3Ww==
X-Received: by 2002:a17:906:478a:: with SMTP id cw10mr268151ejc.533.1610986675837;
        Mon, 18 Jan 2021 08:17:55 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u23sm6093781edt.78.2021.01.18.08.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 08:17:55 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 10/15] net: mscc: ocelot: refactor ocelot_port_inject_frame out of ocelot_port_xmit
Date:   Mon, 18 Jan 2021 18:17:26 +0200
Message-Id: <20210118161731.2837700-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118161731.2837700-1-olteanv@gmail.com>
References: <20210118161731.2837700-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The felix DSA driver will inject some frames through register MMIO, same
as ocelot switchdev currently does. So we need to be able to reuse the
common code.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot.c     | 78 +++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.h     |  4 ++
 drivers/net/ethernet/mscc/ocelot_net.c | 81 +++-----------------------
 3 files changed, 89 insertions(+), 74 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 895df050abba..7aba384fe6bf 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -561,6 +561,84 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 }
 EXPORT_SYMBOL(ocelot_get_txtstamp);
 
+/* Generate the IFH for frame injection
+ *
+ * The IFH is a 128bit-value
+ * bit 127: bypass the analyzer processing
+ * bit 56-67: destination mask
+ * bit 28-29: pop_cnt: 3 disables all rewriting of the frame
+ * bit 20-27: cpu extraction queue mask
+ * bit 16: tag type 0: C-tag, 1: S-tag
+ * bit 0-11: VID
+ */
+static int ocelot_gen_ifh(u32 *ifh, struct frame_info *info)
+{
+	ifh[0] = IFH_INJ_BYPASS | ((0x1ff & info->rew_op) << 21);
+	ifh[1] = (0xf00 & info->port) >> 8;
+	ifh[2] = (0xff & info->port) << 24;
+	ifh[3] = (info->tag_type << 16) | info->vid;
+
+	return 0;
+}
+
+bool ocelot_can_inject(struct ocelot *ocelot, int grp)
+{
+	u32 val = ocelot_read(ocelot, QS_INJ_STATUS);
+
+	if (!(val & QS_INJ_STATUS_FIFO_RDY(BIT(grp))))
+		return false;
+	if (val & QS_INJ_STATUS_WMARK_REACHED(BIT(grp)))
+		return false;
+
+	return true;
+}
+
+void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
+			      u32 rew_op, struct sk_buff *skb)
+{
+	struct frame_info info = {};
+	u32 ifh[OCELOT_TAG_LEN / 4];
+	unsigned int i, count, last;
+
+	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
+			 QS_INJ_CTRL_SOF, QS_INJ_CTRL, grp);
+
+	info.port = BIT(port);
+	info.tag_type = IFH_TAG_TYPE_C;
+	info.vid = skb_vlan_tag_get(skb);
+	info.rew_op = rew_op;
+
+	ocelot_gen_ifh(ifh, &info);
+
+	for (i = 0; i < OCELOT_TAG_LEN / 4; i++)
+		ocelot_write_rix(ocelot, (__force u32)cpu_to_be32(ifh[i]),
+				 QS_INJ_WR, grp);
+
+	count = DIV_ROUND_UP(skb->len, 4);
+	last = skb->len % 4;
+	for (i = 0; i < count; i++)
+		ocelot_write_rix(ocelot, ((u32 *)skb->data)[i], QS_INJ_WR, grp);
+
+	/* Add padding */
+	while (i < (OCELOT_BUFFER_CELL_SZ / 4)) {
+		ocelot_write_rix(ocelot, 0, QS_INJ_WR, grp);
+		i++;
+	}
+
+	/* Indicate EOF and valid bytes in last word */
+	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
+			 QS_INJ_CTRL_VLD_BYTES(skb->len < OCELOT_BUFFER_CELL_SZ ? 0 : last) |
+			 QS_INJ_CTRL_EOF,
+			 QS_INJ_CTRL, grp);
+
+	/* Add dummy CRC */
+	ocelot_write_rix(ocelot, 0, QS_INJ_WR, grp);
+	skb_tx_timestamp(skb);
+
+	skb->dev->stats.tx_packets++;
+	skb->dev->stats.tx_bytes += skb->len;
+}
+
 int ocelot_fdb_add(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid)
 {
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index e8621dbc14f7..cf6493e55eab 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -127,6 +127,10 @@ int ocelot_port_devlink_init(struct ocelot *ocelot, int port,
 			     enum devlink_port_flavour flavour);
 void ocelot_port_devlink_teardown(struct ocelot *ocelot, int port);
 
+bool ocelot_can_inject(struct ocelot *ocelot, int grp);
+void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
+			      u32 rew_op, struct sk_buff *skb);
+
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
 extern struct notifier_block ocelot_switchdev_blocking_nb;
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 55847d2a83e1..9a29d7d3b0e2 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -488,53 +488,20 @@ static int ocelot_port_stop(struct net_device *dev)
 	return 0;
 }
 
-/* Generate the IFH for frame injection
- *
- * The IFH is a 128bit-value
- * bit 127: bypass the analyzer processing
- * bit 56-67: destination mask
- * bit 28-29: pop_cnt: 3 disables all rewriting of the frame
- * bit 20-27: cpu extraction queue mask
- * bit 16: tag type 0: C-tag, 1: S-tag
- * bit 0-11: VID
- */
-static int ocelot_gen_ifh(u32 *ifh, struct frame_info *info)
-{
-	ifh[0] = IFH_INJ_BYPASS | ((0x1ff & info->rew_op) << 21);
-	ifh[1] = (0xf00 & info->port) >> 8;
-	ifh[2] = (0xff & info->port) << 24;
-	ifh[3] = (info->tag_type << 16) | info->vid;
-
-	return 0;
-}
-
-static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
-	u32 val, ifh[OCELOT_TAG_LEN / 4];
-	struct frame_info info = {};
-	u8 grp = 0; /* Send everything on CPU group 0 */
-	unsigned int i, count, last;
 	int port = priv->chip_port;
+	u32 rew_op = 0;
 
-	val = ocelot_read(ocelot, QS_INJ_STATUS);
-	if (!(val & QS_INJ_STATUS_FIFO_RDY(BIT(grp))) ||
-	    (val & QS_INJ_STATUS_WMARK_REACHED(BIT(grp))))
+	if (!ocelot_can_inject(ocelot, 0))
 		return NETDEV_TX_BUSY;
 
-	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
-			 QS_INJ_CTRL_SOF, QS_INJ_CTRL, grp);
-
-	info.port = BIT(port);
-	info.tag_type = IFH_TAG_TYPE_C;
-	info.vid = skb_vlan_tag_get(skb);
-
 	/* Check if timestamping is needed */
-	if (ocelot->ptp && (shinfo->tx_flags & SKBTX_HW_TSTAMP)) {
-		info.rew_op = ocelot_port->ptp_cmd;
+	if (ocelot->ptp && (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
+		rew_op = ocelot_port->ptp_cmd;
 
 		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
 			struct sk_buff *clone;
@@ -547,45 +514,11 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 
 			ocelot_port_add_txtstamp_skb(ocelot, port, clone);
 
-			info.rew_op |= clone->cb[0] << 3;
+			rew_op |= clone->cb[0] << 3;
 		}
 	}
 
-	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP) {
-		info.rew_op = ocelot_port->ptp_cmd;
-		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
-			info.rew_op |= skb->cb[0] << 3;
-	}
-
-	ocelot_gen_ifh(ifh, &info);
-
-	for (i = 0; i < OCELOT_TAG_LEN / 4; i++)
-		ocelot_write_rix(ocelot, (__force u32)cpu_to_be32(ifh[i]),
-				 QS_INJ_WR, grp);
-
-	count = DIV_ROUND_UP(skb->len, 4);
-	last = skb->len % 4;
-	for (i = 0; i < count; i++)
-		ocelot_write_rix(ocelot, ((u32 *)skb->data)[i], QS_INJ_WR, grp);
-
-	/* Add padding */
-	while (i < (OCELOT_BUFFER_CELL_SZ / 4)) {
-		ocelot_write_rix(ocelot, 0, QS_INJ_WR, grp);
-		i++;
-	}
-
-	/* Indicate EOF and valid bytes in last word */
-	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
-			 QS_INJ_CTRL_VLD_BYTES(skb->len < OCELOT_BUFFER_CELL_SZ ? 0 : last) |
-			 QS_INJ_CTRL_EOF,
-			 QS_INJ_CTRL, grp);
-
-	/* Add dummy CRC */
-	ocelot_write_rix(ocelot, 0, QS_INJ_WR, grp);
-	skb_tx_timestamp(skb);
-
-	dev->stats.tx_packets++;
-	dev->stats.tx_bytes += skb->len;
+	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
 
 	kfree_skb(skb);
 
-- 
2.25.1

