Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F77333C64
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbhCJMQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbhCJMPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:15:36 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131B5C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:36 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id dm26so27619991edb.12
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nf+fPfmcsZomK1JhatkWR5wa+0OaZUG5Ra45aFkxr7Y=;
        b=IE61NHehJceXSwBf0IDwrevoY4KIJrOwYO+RblIeF2N9/+Y6NbiSIVLmjKAxEorhfQ
         R9iDDXGpq2rNlNM0ipJPZFMVugkb1Sw5TPQzpniBv/SezBFxoQdCPAqvSzmLYheKmlrs
         GxHBIlSHX6drDd1toP7g3qdELMoE6c5Xz0Cpe75Pyue1vTmT1BGufqQS9kajisjqeLbd
         6z90ipmzfsa9wBh+nsY6CUScDxtgHivepTrB8Sdy/LSTiK7IWw2srylUr7YVBN9QroPD
         zaUKQ+foMywv8bedAuwENxP7CPrrrDgHEDgMsGQ3/lmvBKoOT0PcFNgXXbfU6ZbkTydE
         OQjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nf+fPfmcsZomK1JhatkWR5wa+0OaZUG5Ra45aFkxr7Y=;
        b=DrzoftfbxUuj7LnG6b9Ha6F+dkW45S6Mp9usCYx/liiLOibZ3I9h7mMNppxI40uDON
         AR/futQe1136wISYpJMvWEkhF+1AsHYs7Ii4NV4t5qO8fuR8facH34ltrbG+/UlaM8Rz
         vhxU+F/BHLj1Z3UJCIf34GG/WP6EAQZwIZceHD+ye2aO3hIIOm0jkMIBoQvKhLVMb2nQ
         ho9BWDD3T6f7B7mSy8Tbw9KpTE9SwkZf+QQxtLqQOMAJhjX+N/vWoJpVwwC9al0WA5I2
         W6ecweUg5YELBlVyffXk0fv/QKZ7ZgTS42QpHImMKdi8dn9aGuuPat75vQZEArJeCpbH
         GSIA==
X-Gm-Message-State: AOAM531dug6ZDi8Z7Oo9LIUPKr4qL0UhRCGC74+HqxptAKwTiD1JQG3P
        Faz90YBSY87Y2ZGAMoEZmx0=
X-Google-Smtp-Source: ABdhPJwv3BoXj28YiorMYzyQn6NDpwu4CGJRBIyqUFLPk06ko3kc4UWBXPfr++FJErBYQEoCq2ZLjQ==
X-Received: by 2002:a05:6402:3486:: with SMTP id v6mr2895224edc.109.1615378534806;
        Wed, 10 Mar 2021 04:15:34 -0800 (PST)
Received: from yoga-910.localhost ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id v15sm4865527edw.28.2021.03.10.04.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:15:34 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 05/15] staging: dpaa2-switch: setup buffer pool and RX path rings
Date:   Wed, 10 Mar 2021 14:14:42 +0200
Message-Id: <20210310121452.552070-6-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210310121452.552070-1-ciorneiioana@gmail.com>
References: <20210310121452.552070-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Allocate and setup a buffer pool, needed on the Rx path of the control
interface. Also, define the Rx buffer size seen by the WRIOP from the
PAGE_SIZE buffers seeded.

Also, create the needed Rx rings for both frame queues used on the
control interface.  On the Rx path, when a pull-dequeue operation is
performed on a software portal, available frame descriptors are put in a
ring - a DMA memory storage - for further usage.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h |  12 ++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.c     |  31 +++++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.h     |  26 +++++
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c    | 126 +++++++++++++++++++++
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h    |  14 +++
 5 files changed, 209 insertions(+)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
index fc1ba45f8a3f..d76f80d1bd8b 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
@@ -8,6 +8,8 @@
 #ifndef __FSL_DPSW_CMD_H
 #define __FSL_DPSW_CMD_H
 
+#include "dpsw.h"
+
 /* DPSW Version */
 #define DPSW_VER_MAJOR		8
 #define DPSW_VER_MINOR		9
@@ -73,6 +75,7 @@
 #define DPSW_CMDID_IF_SET_PRIMARY_MAC_ADDR  DPSW_CMD_ID(0x0A9)
 
 #define DPSW_CMDID_CTRL_IF_GET_ATTR         DPSW_CMD_ID(0x0A0)
+#define DPSW_CMDID_CTRL_IF_SET_POOLS        DPSW_CMD_ID(0x0A1)
 
 /* Macros for accessing command fields smaller than 1byte */
 #define DPSW_MASK(field)        \
@@ -356,6 +359,15 @@ struct dpsw_rsp_ctrl_if_get_attr {
 	__le32 tx_err_conf_fqid;
 };
 
+#define DPSW_BACKUP_POOL(val, order)	(((val) & 0x1) << (order))
+struct dpsw_cmd_ctrl_if_set_pools {
+	u8 num_dpbp;
+	u8 backup_pool_mask;
+	__le16 pad;
+	__le32 dpbp_id[DPSW_MAX_DPBP];
+	__le16 buffer_size[DPSW_MAX_DPBP];
+};
+
 struct dpsw_rsp_get_api_version {
 	__le16 version_major;
 	__le16 version_minor;
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
index a7794f012e78..a560270b2466 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
@@ -1120,6 +1120,37 @@ int dpsw_ctrl_if_get_attributes(struct fsl_mc_io *mc_io, u32 cmd_flags,
 	return 0;
 }
 
+/**
+ * dpsw_ctrl_if_set_pools() - Set control interface buffer pools
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ * @cfg:	Buffer pools configuration
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpsw_ctrl_if_set_pools(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			   const struct dpsw_ctrl_if_pools_cfg *cfg)
+{
+	struct dpsw_cmd_ctrl_if_set_pools *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+	int i;
+
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_CTRL_IF_SET_POOLS,
+					  cmd_flags, token);
+	cmd_params = (struct dpsw_cmd_ctrl_if_set_pools *)cmd.params;
+	cmd_params->num_dpbp = cfg->num_dpbp;
+	for (i = 0; i < DPSW_MAX_DPBP; i++) {
+		cmd_params->dpbp_id[i] = cpu_to_le32(cfg->pools[i].dpbp_id);
+		cmd_params->buffer_size[i] =
+			cpu_to_le16(cfg->pools[i].buffer_size);
+		cmd_params->backup_pool_mask |=
+			DPSW_BACKUP_POOL(cfg->pools[i].backup_pool, i);
+	}
+
+	return mc_send_command(mc_io, &cmd);
+}
+
 /**
  * dpsw_get_api_version() - Get Data Path Switch API version
  * @mc_io:	Pointer to MC portal's I/O object
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
index 8c8cc9600e8d..b14ec3e10b85 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
@@ -196,6 +196,32 @@ enum dpsw_queue_type {
 	DPSW_QUEUE_RX_ERR,
 };
 
+/**
+ * Maximum number of DPBP
+ */
+#define DPSW_MAX_DPBP     8
+
+/**
+ * struct dpsw_ctrl_if_pools_cfg - Control interface buffer pools configuration
+ * @num_dpbp: Number of DPBPs
+ * @pools: Array of buffer pools parameters; The number of valid entries
+ *	must match 'num_dpbp' value
+ * @pools.dpbp_id: DPBP object ID
+ * @pools.buffer_size: Buffer size
+ * @pools.backup_pool: Backup pool
+ */
+struct dpsw_ctrl_if_pools_cfg {
+	u8 num_dpbp;
+	struct {
+		int dpbp_id;
+		u16 buffer_size;
+		int backup_pool;
+	} pools[DPSW_MAX_DPBP];
+};
+
+int dpsw_ctrl_if_set_pools(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			   const struct dpsw_ctrl_if_pools_cfg *cfg);
+
 /**
  * enum dpsw_action - Action selection for special/control frames
  * @DPSW_ACTION_DROP: Drop frame
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index b03211fb6fc9..06998578355c 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -1359,6 +1359,110 @@ static int dpaa2_switch_setup_fqs(struct ethsw_core *ethsw)
 	return 0;
 }
 
+static int dpaa2_switch_setup_dpbp(struct ethsw_core *ethsw)
+{
+	struct dpsw_ctrl_if_pools_cfg dpsw_ctrl_if_pools_cfg = { 0 };
+	struct device *dev = ethsw->dev;
+	struct fsl_mc_device *dpbp_dev;
+	struct dpbp_attr dpbp_attrs;
+	int err;
+
+	err = fsl_mc_object_allocate(to_fsl_mc_device(dev), FSL_MC_POOL_DPBP,
+				     &dpbp_dev);
+	if (err) {
+		if (err == -ENXIO)
+			err = -EPROBE_DEFER;
+		else
+			dev_err(dev, "DPBP device allocation failed\n");
+		return err;
+	}
+	ethsw->dpbp_dev = dpbp_dev;
+
+	err = dpbp_open(ethsw->mc_io, 0, dpbp_dev->obj_desc.id,
+			&dpbp_dev->mc_handle);
+	if (err) {
+		dev_err(dev, "dpbp_open() failed\n");
+		goto err_open;
+	}
+
+	err = dpbp_reset(ethsw->mc_io, 0, dpbp_dev->mc_handle);
+	if (err) {
+		dev_err(dev, "dpbp_reset() failed\n");
+		goto err_reset;
+	}
+
+	err = dpbp_enable(ethsw->mc_io, 0, dpbp_dev->mc_handle);
+	if (err) {
+		dev_err(dev, "dpbp_enable() failed\n");
+		goto err_enable;
+	}
+
+	err = dpbp_get_attributes(ethsw->mc_io, 0, dpbp_dev->mc_handle,
+				  &dpbp_attrs);
+	if (err) {
+		dev_err(dev, "dpbp_get_attributes() failed\n");
+		goto err_get_attr;
+	}
+
+	dpsw_ctrl_if_pools_cfg.num_dpbp = 1;
+	dpsw_ctrl_if_pools_cfg.pools[0].dpbp_id = dpbp_attrs.id;
+	dpsw_ctrl_if_pools_cfg.pools[0].buffer_size = DPAA2_SWITCH_RX_BUF_SIZE;
+	dpsw_ctrl_if_pools_cfg.pools[0].backup_pool = 0;
+
+	err = dpsw_ctrl_if_set_pools(ethsw->mc_io, 0, ethsw->dpsw_handle,
+				     &dpsw_ctrl_if_pools_cfg);
+	if (err) {
+		dev_err(dev, "dpsw_ctrl_if_set_pools() failed\n");
+		goto err_get_attr;
+	}
+	ethsw->bpid = dpbp_attrs.id;
+
+	return 0;
+
+err_get_attr:
+	dpbp_disable(ethsw->mc_io, 0, dpbp_dev->mc_handle);
+err_enable:
+err_reset:
+	dpbp_close(ethsw->mc_io, 0, dpbp_dev->mc_handle);
+err_open:
+	fsl_mc_object_free(dpbp_dev);
+	return err;
+}
+
+static void dpaa2_switch_free_dpbp(struct ethsw_core *ethsw)
+{
+	dpbp_disable(ethsw->mc_io, 0, ethsw->dpbp_dev->mc_handle);
+	dpbp_close(ethsw->mc_io, 0, ethsw->dpbp_dev->mc_handle);
+	fsl_mc_object_free(ethsw->dpbp_dev);
+}
+
+static int dpaa2_switch_alloc_rings(struct ethsw_core *ethsw)
+{
+	int i;
+
+	for (i = 0; i < DPAA2_SWITCH_RX_NUM_FQS; i++) {
+		ethsw->fq[i].store =
+			dpaa2_io_store_create(DPAA2_SWITCH_STORE_SIZE,
+					      ethsw->dev);
+		if (!ethsw->fq[i].store) {
+			dev_err(ethsw->dev, "dpaa2_io_store_create failed\n");
+			while (--i >= 0)
+				dpaa2_io_store_destroy(ethsw->fq[i].store);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+static void dpaa2_switch_destroy_rings(struct ethsw_core *ethsw)
+{
+	int i;
+
+	for (i = 0; i < DPAA2_SWITCH_RX_NUM_FQS; i++)
+		dpaa2_io_store_destroy(ethsw->fq[i].store);
+}
+
 static int dpaa2_switch_ctrl_if_setup(struct ethsw_core *ethsw)
 {
 	int err;
@@ -1368,7 +1472,21 @@ static int dpaa2_switch_ctrl_if_setup(struct ethsw_core *ethsw)
 	if (err)
 		return err;
 
+	/* setup the buffer pool needed on the Rx path */
+	err = dpaa2_switch_setup_dpbp(ethsw);
+	if (err)
+		return err;
+
+	err = dpaa2_switch_alloc_rings(ethsw);
+	if (err)
+		goto err_free_dpbp;
+
 	return 0;
+
+err_free_dpbp:
+	dpaa2_switch_free_dpbp(ethsw);
+
+	return err;
 }
 
 static int dpaa2_switch_init(struct fsl_mc_device *sw_dev)
@@ -1563,6 +1681,12 @@ static void dpaa2_switch_takedown(struct fsl_mc_device *sw_dev)
 		dev_warn(dev, "dpsw_close err %d\n", err);
 }
 
+static void dpaa2_switch_ctrl_if_teardown(struct ethsw_core *ethsw)
+{
+	dpaa2_switch_destroy_rings(ethsw);
+	dpaa2_switch_free_dpbp(ethsw);
+}
+
 static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 {
 	struct ethsw_port_priv *port_priv;
@@ -1573,6 +1697,8 @@ static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 	dev = &sw_dev->dev;
 	ethsw = dev_get_drvdata(dev);
 
+	dpaa2_switch_ctrl_if_teardown(ethsw);
+
 	dpaa2_switch_teardown_irqs(sw_dev);
 
 	dpsw_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
index 24a203c42f5f..f5bd2cd3d140 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
@@ -17,6 +17,8 @@
 #include <uapi/linux/if_bridge.h>
 #include <net/switchdev.h>
 #include <linux/if_bridge.h>
+#include <linux/fsl/mc.h>
+#include <soc/fsl/dpaa2-io.h>
 
 #include "dpsw.h"
 
@@ -42,6 +44,15 @@
 /* Number of receive queues (one RX and one TX_CONF) */
 #define DPAA2_SWITCH_RX_NUM_FQS	2
 
+/* Hardware requires alignment for ingress/egress buffer addresses */
+#define DPAA2_SWITCH_RX_BUF_RAW_SIZE	PAGE_SIZE
+#define DPAA2_SWITCH_RX_BUF_TAILROOM \
+	SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
+#define DPAA2_SWITCH_RX_BUF_SIZE \
+	(DPAA2_SWITCH_RX_BUF_RAW_SIZE - DPAA2_SWITCH_RX_BUF_TAILROOM)
+
+#define DPAA2_SWITCH_STORE_SIZE 16
+
 extern const struct ethtool_ops dpaa2_switch_port_ethtool_ops;
 
 struct ethsw_core;
@@ -49,6 +60,7 @@ struct ethsw_core;
 struct dpaa2_switch_fq {
 	struct ethsw_core *ethsw;
 	enum dpsw_queue_type type;
+	struct dpaa2_io_store *store;
 	u32 fqid;
 };
 
@@ -85,6 +97,8 @@ struct ethsw_core {
 	struct workqueue_struct		*workqueue;
 
 	struct dpaa2_switch_fq		fq[DPAA2_SWITCH_RX_NUM_FQS];
+	struct fsl_mc_device		*dpbp_dev;
+	u16				bpid;
 };
 
 static inline bool dpaa2_switch_supports_cpu_traffic(struct ethsw_core *ethsw)
-- 
2.30.0

