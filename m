Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6B5333C68
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhCJMQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbhCJMPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:15:40 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73E4C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:39 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id b7so27722648edz.8
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/APYNru4eX9Ib7zln+ftgnU0+6CWKUaeWlq/n9g7fNE=;
        b=eilO/EjHkINUh7MJwwQkEE7lW0zUMZafiI+ljE53+0EHwtcBf6d0pvUXWzwECctEOv
         jkHAkaaRg2f/XlkuZqkwzOgUEDY5/9JuPPnx8FNNWykyc8W1wGP9cpl3oHVZp26hw90z
         RugZsVnpa03IBbxy1beifZGMTL3kUy3u86evAVMWZTFsa9HLzE2u4llitDZWD2cRymTE
         yUoQKljt6pOKKRi3lR8yYYM8RbwhGkDMemvhhQNeecXD1XUu/lFiN49atWX4gNOOLFMl
         FOhR9XFFJ6r77n+9IK6hPlwvLB9Ie+syYz+Ga7/R90f4ekjBAFNHLPWebOZuEwYPY1PW
         wDbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/APYNru4eX9Ib7zln+ftgnU0+6CWKUaeWlq/n9g7fNE=;
        b=T6dXrkXX6Zp8namWS1w1dZMaKrSidYJsWKFEJw+8PgQJTOzLVGL+IVFNtL3vuksi+G
         ZbfNrlcukpjN1wA31yU2V1fOpQ4RP2NeeISXQgQjcKEhYXB+ZHDym5uoMqJxOiyo+hZ+
         +rNiYpl/wLGii4pFo7gKU670ZYx9XYBbZ/VKxLi4ETLb1pxgMtFBmjYQddwjvxjzBD72
         /gz9JJ5ulfc0POd28jdug5151WEF5bDRruRN/6iePdRyTWhNq4XnyVCgvn/7DEaaCpex
         sOlYQm0gBBU4CO7/BT372sqUL65NPkU0ZQ/RQ5NGJKtpcGM6nXMBJGyNaX+NglRcETYM
         RXmg==
X-Gm-Message-State: AOAM533DnzEsyRIsdX91Qcvi/Y3/iPsNazDtH4JXba7cUo8gnQ0jid43
        fGxdTgpgLj/Zku+4sf2Pjf4=
X-Google-Smtp-Source: ABdhPJydVUp/pltZEfzaN+Kawh5xQYIdjLIlqtOdAxuxMIAcJLhUFNw9WApEEc00kH6FwStAFUEzcQ==
X-Received: by 2002:a50:f391:: with SMTP id g17mr2930319edm.26.1615378538644;
        Wed, 10 Mar 2021 04:15:38 -0800 (PST)
Received: from yoga-910.localhost ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id v15sm4865527edw.28.2021.03.10.04.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:15:38 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 08/15] staging: dpaa2-switch: add .ndo_start_xmit() callback
Date:   Wed, 10 Mar 2021 14:14:45 +0200
Message-Id: <20210310121452.552070-9-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210310121452.552070-1-ciorneiioana@gmail.com>
References: <20210310121452.552070-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Implement the .ndo_start_xmit() callback for the switch port interfaces.
For each of the switch ports, gather the corresponding queue
destination ID (QDID) necessary for Tx enqueueing.

We'll reserve 64 bytes for software annotations, where we keep a skb
backpointer used on the Tx confirmation side for releasing the allocated
memory. At the moment, we only support linear skbs.

Also, add support for the Tx confirmation path which for the most part
shares the code path with the normal Rx queue.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h |  24 ++++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.c     |  41 ++++++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.h     |  28 ++++
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c    | 154 ++++++++++++++++++---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h    |  14 ++
 5 files changed, 245 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
index d451e1e7f0a3..4aa83d41d762 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
@@ -47,6 +47,8 @@
 #define DPSW_CMDID_IF_ENABLE                DPSW_CMD_ID(0x03D)
 #define DPSW_CMDID_IF_DISABLE               DPSW_CMD_ID(0x03E)
 
+#define DPSW_CMDID_IF_GET_ATTR              DPSW_CMD_ID(0x042)
+
 #define DPSW_CMDID_IF_SET_MAX_FRAME_LENGTH  DPSW_CMD_ID(0x044)
 
 #define DPSW_CMDID_IF_GET_LINK_STATE        DPSW_CMD_ID(0x046)
@@ -246,6 +248,28 @@ struct dpsw_cmd_if {
 	__le16 if_id;
 };
 
+#define DPSW_ADMIT_UNTAGGED_SHIFT	0
+#define DPSW_ADMIT_UNTAGGED_SIZE	4
+#define DPSW_ENABLED_SHIFT		5
+#define DPSW_ENABLED_SIZE		1
+#define DPSW_ACCEPT_ALL_VLAN_SHIFT	6
+#define DPSW_ACCEPT_ALL_VLAN_SIZE	1
+
+struct dpsw_rsp_if_get_attr {
+	/* cmd word 0 */
+	/* from LSB: admit_untagged:4 enabled:1 accept_all_vlan:1 */
+	u8 conf;
+	u8 pad1;
+	u8 num_tcs;
+	u8 pad2;
+	__le16 qdid;
+	/* cmd word 1 */
+	__le32 options;
+	__le32 pad3;
+	/* cmd word 2 */
+	__le32 rate;
+};
+
 struct dpsw_cmd_if_set_max_frame_length {
 	__le16 if_id;
 	__le16 frame_length;
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
index 4bc5791c0fa1..bd482a9b1930 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
@@ -642,6 +642,47 @@ int dpsw_if_disable(struct fsl_mc_io *mc_io,
 	return mc_send_command(mc_io, &cmd);
 }
 
+/**
+ * dpsw_if_get_attributes() - Function obtains attributes of interface
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ * @if_id:	Interface Identifier
+ * @attr:	Returned interface attributes
+ *
+ * Return:	Completion status. '0' on Success; Error code otherwise.
+ */
+int dpsw_if_get_attributes(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			   u16 if_id, struct dpsw_if_attr *attr)
+{
+	struct dpsw_rsp_if_get_attr *rsp_params;
+	struct fsl_mc_command cmd = { 0 };
+	struct dpsw_cmd_if *cmd_params;
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_IF_GET_ATTR, cmd_flags,
+					  token);
+	cmd_params = (struct dpsw_cmd_if *)cmd.params;
+	cmd_params->if_id = cpu_to_le16(if_id);
+
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	rsp_params = (struct dpsw_rsp_if_get_attr *)cmd.params;
+	attr->num_tcs = rsp_params->num_tcs;
+	attr->rate = le32_to_cpu(rsp_params->rate);
+	attr->options = le32_to_cpu(rsp_params->options);
+	attr->qdid = le16_to_cpu(rsp_params->qdid);
+	attr->enabled = dpsw_get_field(rsp_params->conf, ENABLED);
+	attr->accept_all_vlan = dpsw_get_field(rsp_params->conf,
+					       ACCEPT_ALL_VLAN);
+	attr->admit_untagged = dpsw_get_field(rsp_params->conf,
+					      ADMIT_UNTAGGED);
+
+	return 0;
+}
+
 /**
  * dpsw_if_set_max_frame_length() - Set Maximum Receive frame length.
  * @mc_io:		Pointer to MC portal's I/O object
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
index f888778b70a1..e741e91e485a 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
@@ -430,6 +430,34 @@ int dpsw_if_disable(struct fsl_mc_io *mc_io,
 		    u16 token,
 		    u16 if_id);
 
+/**
+ * struct dpsw_if_attr - Structure representing DPSW interface attributes
+ * @num_tcs: Number of traffic classes
+ * @rate: Transmit rate in bits per second
+ * @options: Interface configuration options (bitmap)
+ * @enabled: Indicates if interface is enabled
+ * @accept_all_vlan: The device discards/accepts incoming frames
+ *		for VLANs that do not include this interface
+ * @admit_untagged: When set to 'DPSW_ADMIT_ONLY_VLAN_TAGGED', the device
+ *		discards untagged frames or priority-tagged frames received on
+ *		this interface;
+ *		When set to 'DPSW_ADMIT_ALL', untagged frames or priority-
+ *		tagged frames received on this interface are accepted
+ * @qdid: control frames transmit qdid
+ */
+struct dpsw_if_attr {
+	u8 num_tcs;
+	u32 rate;
+	u32 options;
+	int enabled;
+	int accept_all_vlan;
+	enum dpsw_accepted_frames admit_untagged;
+	u16 qdid;
+};
+
+int dpsw_if_get_attributes(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			   u16 if_id, struct dpsw_if_attr *attr);
+
 int dpsw_if_set_max_frame_length(struct fsl_mc_io *mc_io,
 				 u32 cmd_flags,
 				 u16 token,
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index 54cf87a66ab0..102221263062 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -434,10 +434,13 @@ static int dpaa2_switch_port_carrier_state_sync(struct net_device *netdev)
 	WARN_ONCE(state.up > 1, "Garbage read into link_state");
 
 	if (state.up != port_priv->link_state) {
-		if (state.up)
+		if (state.up) {
 			netif_carrier_on(netdev);
-		else
+			netif_tx_start_all_queues(netdev);
+		} else {
 			netif_carrier_off(netdev);
+			netif_tx_stop_all_queues(netdev);
+		}
 		port_priv->link_state = state.up;
 	}
 
@@ -491,9 +494,6 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	int err;
 
-	/* No need to allow Tx as control interface is disabled */
-	netif_tx_stop_all_queues(netdev);
-
 	/* Explicitly set carrier off, otherwise
 	 * netif_carrier_ok() will return true and cause 'ip link show'
 	 * to report the LOWER_UP flag, even though the link
@@ -547,15 +547,6 @@ static int dpaa2_switch_port_stop(struct net_device *netdev)
 	return 0;
 }
 
-static netdev_tx_t dpaa2_switch_port_dropframe(struct sk_buff *skb,
-					       struct net_device *netdev)
-{
-	/* we don't support I/O for now, drop the frame */
-	dev_kfree_skb_any(skb);
-
-	return NETDEV_TX_OK;
-}
-
 static int dpaa2_switch_port_parent_id(struct net_device *dev,
 				       struct netdev_phys_item_id *ppid)
 {
@@ -772,6 +763,115 @@ static void dpaa2_switch_free_fd(const struct ethsw_core *ethsw,
 	dev_kfree_skb(skb);
 }
 
+static int dpaa2_switch_build_single_fd(struct ethsw_core *ethsw,
+					struct sk_buff *skb,
+					struct dpaa2_fd *fd)
+{
+	struct device *dev = ethsw->dev;
+	struct sk_buff **skbh;
+	dma_addr_t addr;
+	u8 *buff_start;
+	void *hwa;
+
+	buff_start = PTR_ALIGN(skb->data - DPAA2_SWITCH_TX_DATA_OFFSET -
+			       DPAA2_SWITCH_TX_BUF_ALIGN,
+			       DPAA2_SWITCH_TX_BUF_ALIGN);
+
+	/* Clear FAS to have consistent values for TX confirmation. It is
+	 * located in the first 8 bytes of the buffer's hardware annotation
+	 * area
+	 */
+	hwa = buff_start + DPAA2_SWITCH_SWA_SIZE;
+	memset(hwa, 0, 8);
+
+	/* Store a backpointer to the skb at the beginning of the buffer
+	 * (in the private data area) such that we can release it
+	 * on Tx confirm
+	 */
+	skbh = (struct sk_buff **)buff_start;
+	*skbh = skb;
+
+	addr = dma_map_single(dev, buff_start,
+			      skb_tail_pointer(skb) - buff_start,
+			      DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, addr)))
+		return -ENOMEM;
+
+	/* Setup the FD fields */
+	memset(fd, 0, sizeof(*fd));
+
+	dpaa2_fd_set_addr(fd, addr);
+	dpaa2_fd_set_offset(fd, (u16)(skb->data - buff_start));
+	dpaa2_fd_set_len(fd, skb->len);
+	dpaa2_fd_set_format(fd, dpaa2_fd_single);
+
+	return 0;
+}
+
+static netdev_tx_t dpaa2_switch_port_tx(struct sk_buff *skb,
+					struct net_device *net_dev)
+{
+	struct ethsw_port_priv *port_priv = netdev_priv(net_dev);
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
+	int retries = DPAA2_SWITCH_SWP_BUSY_RETRIES;
+	struct dpaa2_fd fd;
+	int err;
+
+	if (unlikely(skb_headroom(skb) < DPAA2_SWITCH_NEEDED_HEADROOM)) {
+		struct sk_buff *ns;
+
+		ns = skb_realloc_headroom(skb, DPAA2_SWITCH_NEEDED_HEADROOM);
+		if (unlikely(!ns)) {
+			net_err_ratelimited("%s: Error reallocating skb headroom\n", net_dev->name);
+			goto err_free_skb;
+		}
+		dev_consume_skb_any(skb);
+		skb = ns;
+	}
+
+	/* We'll be holding a back-reference to the skb until Tx confirmation */
+	skb = skb_unshare(skb, GFP_ATOMIC);
+	if (unlikely(!skb)) {
+		/* skb_unshare() has already freed the skb */
+		net_err_ratelimited("%s: Error copying the socket buffer\n", net_dev->name);
+		goto err_exit;
+	}
+
+	/* At this stage, we do not support non-linear skbs so just try to
+	 * linearize the skb and if that's not working, just drop the packet.
+	 */
+	err = skb_linearize(skb);
+	if (err) {
+		net_err_ratelimited("%s: skb_linearize error (%d)!\n", net_dev->name, err);
+		goto err_free_skb;
+	}
+
+	err = dpaa2_switch_build_single_fd(ethsw, skb, &fd);
+	if (unlikely(err)) {
+		net_err_ratelimited("%s: ethsw_build_*_fd() %d\n", net_dev->name, err);
+		goto err_free_skb;
+	}
+
+	do {
+		err = dpaa2_io_service_enqueue_qd(NULL,
+						  port_priv->tx_qdid,
+						  8, 0, &fd);
+		retries--;
+	} while (err == -EBUSY && retries);
+
+	if (unlikely(err < 0)) {
+		dpaa2_switch_free_fd(ethsw, &fd);
+		goto err_exit;
+	}
+
+	return NETDEV_TX_OK;
+
+err_free_skb:
+	dev_kfree_skb(skb);
+err_exit:
+	return NETDEV_TX_OK;
+}
+
 static const struct net_device_ops dpaa2_switch_port_ops = {
 	.ndo_open		= dpaa2_switch_port_open,
 	.ndo_stop		= dpaa2_switch_port_stop,
@@ -783,7 +883,7 @@ static const struct net_device_ops dpaa2_switch_port_ops = {
 	.ndo_get_offload_stats	= dpaa2_switch_port_get_offload_stats,
 	.ndo_fdb_dump		= dpaa2_switch_port_fdb_dump,
 
-	.ndo_start_xmit		= dpaa2_switch_port_dropframe,
+	.ndo_start_xmit		= dpaa2_switch_port_tx,
 	.ndo_get_port_parent_id	= dpaa2_switch_port_parent_id,
 	.ndo_get_phys_port_name = dpaa2_switch_port_get_phys_name,
 };
@@ -1436,6 +1536,12 @@ static struct sk_buff *dpaa2_switch_build_linear_skb(struct ethsw_core *ethsw,
 	return skb;
 }
 
+static void dpaa2_switch_tx_conf(struct dpaa2_switch_fq *fq,
+				 const struct dpaa2_fd *fd)
+{
+	dpaa2_switch_free_fd(fq->ethsw, fd);
+}
+
 static void dpaa2_switch_rx(struct dpaa2_switch_fq *fq,
 			    const struct dpaa2_fd *fd)
 {
@@ -1813,7 +1919,10 @@ static int dpaa2_switch_store_consume(struct dpaa2_switch_fq *fq)
 			continue;
 		}
 
-		dpaa2_switch_rx(fq, dpaa2_dq_fd(dq));
+		if (fq->type == DPSW_QUEUE_RX)
+			dpaa2_switch_rx(fq, dpaa2_dq_fd(dq));
+		else
+			dpaa2_switch_tx_conf(fq, dpaa2_dq_fd(dq));
 		cleaned++;
 
 	} while (!is_last);
@@ -2111,8 +2220,19 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 		.flags = BRIDGE_VLAN_INFO_UNTAGGED | BRIDGE_VLAN_INFO_PVID,
 	};
 	struct net_device *netdev = port_priv->netdev;
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
+	struct dpsw_if_attr dpsw_if_attr;
 	int err;
 
+	/* Get the Tx queue for this specific port */
+	err = dpsw_if_get_attributes(ethsw->mc_io, 0, ethsw->dpsw_handle,
+				     port_priv->idx, &dpsw_if_attr);
+	if (err) {
+		netdev_err(netdev, "dpsw_if_get_attributes err %d\n", err);
+		return err;
+	}
+	port_priv->tx_qdid = dpsw_if_attr.qdid;
+
 	/* We need to add VLAN 1 as the PVID on this port until it is under a
 	 * bridge since the DPAA2 switch is not able to handle the traffic in a
 	 * VLAN unaware fashion
@@ -2230,6 +2350,8 @@ static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
 	port_netdev->netdev_ops = &dpaa2_switch_port_ops;
 	port_netdev->ethtool_ops = &dpaa2_switch_port_ethtool_ops;
 
+	port_netdev->needed_headroom = DPAA2_SWITCH_NEEDED_HEADROOM;
+
 	/* Set MTU limits */
 	port_netdev->min_mtu = ETH_MIN_MTU;
 	port_netdev->max_mtu = ETHSW_MAX_FRAME_LENGTH;
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
index 238f16561979..ab3b75a62f01 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
@@ -66,6 +66,19 @@
  */
 #define DPAA2_SWITCH_SWP_BUSY_RETRIES		1000
 
+/* Hardware annotation buffer size */
+#define DPAA2_SWITCH_HWA_SIZE			64
+/* Software annotation buffer size */
+#define DPAA2_SWITCH_SWA_SIZE			64
+
+#define DPAA2_SWITCH_TX_BUF_ALIGN		64
+
+#define DPAA2_SWITCH_TX_DATA_OFFSET \
+	(DPAA2_SWITCH_HWA_SIZE + DPAA2_SWITCH_SWA_SIZE)
+
+#define DPAA2_SWITCH_NEEDED_HEADROOM \
+	(DPAA2_SWITCH_TX_DATA_OFFSET + DPAA2_SWITCH_TX_BUF_ALIGN)
+
 extern const struct ethtool_ops dpaa2_switch_port_ethtool_ops;
 
 struct ethsw_core;
@@ -91,6 +104,7 @@ struct ethsw_port_priv {
 	u8			vlans[VLAN_VID_MASK + 1];
 	u16			pvid;
 	struct net_device	*bridge_dev;
+	u16			tx_qdid;
 };
 
 /* Switch data */
-- 
2.30.0

