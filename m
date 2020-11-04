Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DE02A6B32
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731725AbgKDQ5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731619AbgKDQ5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 11:57:37 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AF3C0613D4;
        Wed,  4 Nov 2020 08:57:37 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id o20so5077876eds.3;
        Wed, 04 Nov 2020 08:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xdbs/utMxlYWSDn4luGomZ8YgspbSA2hgOF0Xj6UKtQ=;
        b=GQ94Ckrf6QB2xdZ3p5rsOmJvrL0Nty2yY/8q1iBgd4DVZ34bW8rXANhT8csdp7TgQM
         wOUIyZAkaNgRoR+34NAsppiBPz4T2guBBhErdzumm0KnCql46UvE4BS5kAebAr6HC9s6
         aYpP6c6eQ3O/PxI9nr0tIAkjsH3pMcQA/+H+ALu4Kze6YMvIDi0dlqHDi6PLV6bbsWLk
         1+th645ltUMZ+kXD5DJXlTkZ2uVBDlWRpjBNMzRnKh8DFsuvPMttpdkIla6F50KC7bwp
         xwgDm5YzNC7b9FPAiOcPI/o13rR/+OCAS46Taj0VOEbGs9oyQn5qoy3PJgUtPxt4TRPC
         6U6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xdbs/utMxlYWSDn4luGomZ8YgspbSA2hgOF0Xj6UKtQ=;
        b=goa6brLuQZYx0eDt/Tm1YmlXneon6OqCsTY4L0F5JJ60mN2KytbtREycgZWRdklJZo
         rh61svDctnhxhzofBz/kbj941Kr+PASegLa1zQEKpxVx10Q+VhY12zwlRCFju4l5jh62
         HfEG6E6B9bn7XwlnSerANq2uPmpvrolVZJSjTB17iayaRf+cYE3zLJAECLNdm2EmMjUp
         B7iJPLxdkeNuXXyJu9CBWuon4V8g78HuyTYCXL7Fw5NnpJdPZU4pn0oyrRZOjHTq2Nt0
         LtqTCfAQZn/4HOPBViYea4lz2MWss73Mewyq06VqTelKQJJvnZrYPA236N0T1vQIkRrj
         F8DA==
X-Gm-Message-State: AOAM532YSb7tuorfaE8z8sMexk4MKPDatgxtjCE3+YQTqLIoaSbIvS3b
        wxc/zmoEbDkAbY49XFhhDAI=
X-Google-Smtp-Source: ABdhPJwQvsa+um/VmlvXh3Nu9Veu/vDydLxr0o5bySHveXw7e+1U8ryryBVgQ0jbreFLpIMbz9imWQ==
X-Received: by 2002:a50:a683:: with SMTP id e3mr28057095edc.33.1604509055813;
        Wed, 04 Nov 2020 08:57:35 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id l12sm1354748edt.46.2020.11.04.08.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 08:57:35 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [RFC 6/9] staging: dpaa2-switch: add .ndo_start_xmit() callback
Date:   Wed,  4 Nov 2020 18:57:17 +0200
Message-Id: <20201104165720.2566399-7-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201104165720.2566399-1-ciorneiioana@gmail.com>
References: <20201104165720.2566399-1-ciorneiioana@gmail.com>
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

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h |  24 ++++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.c     |  41 ++++++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.h     |  28 ++++
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c    | 146 ++++++++++++++++++---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h    |  14 ++
 5 files changed, 238 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
index 9caff864ae3e..e239747f8a54 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
@@ -45,6 +45,8 @@
 #define DPSW_CMDID_IF_ENABLE                DPSW_CMD_ID(0x03D)
 #define DPSW_CMDID_IF_DISABLE               DPSW_CMD_ID(0x03E)
 
+#define DPSW_CMDID_IF_GET_ATTR              DPSW_CMD_ID(0x042)
+
 #define DPSW_CMDID_IF_SET_MAX_FRAME_LENGTH  DPSW_CMD_ID(0x044)
 
 #define DPSW_CMDID_IF_GET_LINK_STATE        DPSW_CMD_ID(0x046)
@@ -258,6 +260,28 @@ struct dpsw_cmd_if {
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
index 785140d4652c..2a1967754913 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
@@ -704,6 +704,47 @@ int dpsw_if_disable(struct fsl_mc_io *mc_io,
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
index 718242ea7d87..a6ed6860946c 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
@@ -440,6 +440,34 @@ int dpsw_if_disable(struct fsl_mc_io *mc_io,
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
index d09aa4a5126a..7805f0e58ec2 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -477,6 +477,7 @@ static int dpaa2_switch_port_change_mtu(struct net_device *netdev, int mtu)
 static int dpaa2_switch_port_carrier_state_sync(struct net_device *netdev)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	struct dpsw_link_state state;
 	int err;
 
@@ -497,10 +498,15 @@ static int dpaa2_switch_port_carrier_state_sync(struct net_device *netdev)
 	WARN_ONCE(state.up > 1, "Garbage read into link_state");
 
 	if (state.up != port_priv->link_state) {
-		if (state.up)
+		if (state.up) {
 			netif_carrier_on(netdev);
-		else
+			if (dpaa2_switch_has_ctrl_if(ethsw))
+				netif_tx_start_all_queues(netdev);
+		} else {
 			netif_carrier_off(netdev);
+			if (dpaa2_switch_has_ctrl_if(ethsw))
+				netif_tx_stop_all_queues(netdev);
+		}
 		port_priv->link_state = state.up;
 	}
 
@@ -554,8 +560,10 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	int err;
 
-	/* No need to allow Tx as control interface is disabled */
-	netif_tx_stop_all_queues(netdev);
+	if (!dpaa2_switch_has_ctrl_if(port_priv->ethsw_data)) {
+		/* No need to allow Tx as control interface is disabled */
+		netif_tx_stop_all_queues(netdev);
+	}
 
 	/* Explicitly set carrier off, otherwise
 	 * netif_carrier_ok() will return true and cause 'ip link show'
@@ -610,15 +618,6 @@ static int dpaa2_switch_port_stop(struct net_device *netdev)
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
@@ -835,6 +834,114 @@ static void dpaa2_switch_free_fd(const struct ethsw_core *ethsw,
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
+	if (!dpaa2_switch_has_ctrl_if(ethsw))
+		goto err_free_skb;
+
+	if (unlikely(skb_headroom(skb) < DPAA2_SWITCH_NEEDED_HEADROOM)) {
+		struct sk_buff *ns;
+
+		ns = skb_realloc_headroom(skb, DPAA2_SWITCH_NEEDED_HEADROOM);
+		if (unlikely(!ns)) {
+			netdev_err(net_dev, "Error reallocating skb headroom\n");
+			goto err_free_skb;
+		}
+		dev_kfree_skb(skb);
+		skb = ns;
+	}
+
+	/* We'll be holding a back-reference to the skb until Tx confirmation */
+	skb = skb_unshare(skb, GFP_ATOMIC);
+	if (unlikely(!skb)) {
+		/* skb_unshare() has already freed the skb */
+		netdev_err(net_dev, "Error copying the socket buffer\n");
+		goto err_exit;
+	}
+
+	if (skb_is_nonlinear(skb)) {
+		netdev_err(net_dev, "No support for non-linear SKBs!\n");
+		goto err_free_skb;
+	}
+
+	err = dpaa2_switch_build_single_fd(ethsw, skb, &fd);
+	if (unlikely(err)) {
+		netdev_err(net_dev, "ethsw_build_*_fd() %d\n", err);
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
@@ -848,7 +955,7 @@ static const struct net_device_ops dpaa2_switch_port_ops = {
 	.ndo_fdb_del		= dpaa2_switch_port_fdb_del,
 	.ndo_fdb_dump		= dpaa2_switch_port_fdb_dump,
 
-	.ndo_start_xmit		= dpaa2_switch_port_dropframe,
+	.ndo_start_xmit		= dpaa2_switch_port_tx,
 	.ndo_get_port_parent_id	= dpaa2_switch_port_parent_id,
 	.ndo_get_phys_port_name = dpaa2_switch_port_get_phys_name,
 };
@@ -2237,6 +2344,7 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 {
 	struct net_device *netdev = port_priv->netdev;
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
+	struct dpsw_if_attr dpsw_if_attr;
 	struct dpsw_vlan_if_cfg vcfg;
 	int err;
 
@@ -2263,7 +2371,15 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 	if (err)
 		netdev_err(netdev, "dpsw_vlan_remove_if err %d\n", err);
 
-	return err;
+	err = dpsw_if_get_attributes(ethsw->mc_io, 0, ethsw->dpsw_handle,
+				     port_priv->idx, &dpsw_if_attr);
+	if (err) {
+		netdev_err(netdev, "dpsw_if_get_attributes err %d\n", err);
+		return err;
+	}
+	port_priv->tx_qdid = dpsw_if_attr.qdid;
+
+	return 0;
 }
 
 static void dpaa2_switch_unregister_notifier(struct device *dev)
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
index bd24be2c6308..b267c04e2008 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
@@ -66,6 +66,19 @@
  */
 #define DPAA2_SWITCH_SWP_BUSY_RETRIES		1000
 
+/* Hardware annotation buffer size */
+#define DPAA2_SWITCH_HWA_SIZE		64
+/* Software annotation buffer size */
+#define DPAA2_SWITCH_SWA_SIZE		64
+
+#define DPAA2_SWITCH_TX_BUF_ALIGN	64
+
+#define DPAA2_SWITCH_TX_DATA_OFFSET \
+	(DPAA2_SWITCH_HWA_SIZE + DPAA2_SWITCH_SWA_SIZE)
+
+#define DPAA2_SWITCH_NEEDED_HEADROOM \
+	(DPAA2_SWITCH_TX_DATA_OFFSET + DPAA2_SWITCH_TX_BUF_ALIGN)
+
 extern const struct ethtool_ops dpaa2_switch_port_ethtool_ops;
 
 struct ethsw_core;
@@ -92,6 +105,7 @@ struct ethsw_port_priv {
 	u8			vlans[VLAN_VID_MASK + 1];
 	u16			pvid;
 	struct net_device	*bridge_dev;
+	u16			tx_qdid;
 };
 
 /* Switch data */
-- 
2.28.0

