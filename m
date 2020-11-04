Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B122A6B31
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731542AbgKDQ5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:57:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731341AbgKDQ5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 11:57:32 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4113CC0613D3;
        Wed,  4 Nov 2020 08:57:32 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id o18so23222678edq.4;
        Wed, 04 Nov 2020 08:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1nNBwUfUFAQ1bIBA8E/6Tf1c9Py6NpoAMvknpGcmmcQ=;
        b=rjha0/KYKXjUqCiWK2s85jRvS2jETsjsMCh18WdNx8MG1QTcg3s1uck2DSuRGEM/fa
         xc14x4HC0KjUZTPu/RLNnCuuw4B0QMuRCMC3rH7qCmY8s+palhkMLyOHUNEcgMRAPQFg
         3S6SlwGIqIE5tBuBOvvpUzz5nTd6Z5Ajo4uxQ8IoM3XPd0BFG4gXD36kcG6vQWY2C/2v
         cSQaxbQbUAf+K8P2BsBiubIIfsXJiSGmP9sJoUIONUfmunx2w1uVeWm6xq+n6W6ugkLg
         LlRxkj2zGeqKt7ZGa+XaGW19fgnmC+9ZZ7UUfvmxelI6DjF8KjtgK4SvN2CcJx/6InPk
         BNJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1nNBwUfUFAQ1bIBA8E/6Tf1c9Py6NpoAMvknpGcmmcQ=;
        b=PF3xNtWaxMOX0dZFnr2mZc5EPNut5zQ0cowQkuZQ7Lym6QDf27tM2QSvuYjy0C/4tX
         gsbsSU2DwzDPuzCchD5QW2p9Jv9DL4V2DLwoGYiwTBbqa3P2S/DBqbEVzcIJt7dWYU3c
         TXf2Hsdstazx6RNy2A9ldcd01DhCZd0NqaFyEh6oyG6cCgPbfrGhLlLa/LNZGRpd7tcV
         ejZixodlZ3KZcvwn7/k4Z8fa0aOsCbIJWgUVK3L3d8waNktYvjodlEkOtj879rN1Tgga
         +06uu7quMzrldRrc9Cg32okan+1qsA1M4GvRjsoHa5k5Ipl1gXU4/JBynVXjBzh/R8UJ
         awDA==
X-Gm-Message-State: AOAM5306qydthICUIyQnRusiHVqXrj+UgEMVG87D3nlpTBbgXo1rJLR9
        KV5Z5xFFLZviXc5aYk86Y84=
X-Google-Smtp-Source: ABdhPJzN/oEPO5lIbYCtTZb1zu00AA5hTPg3I4vraBHFAUXCxKcGWJfML0e5q478zeIIHR0TwYl0Nw==
X-Received: by 2002:aa7:d783:: with SMTP id s3mr28467613edq.214.1604509050947;
        Wed, 04 Nov 2020 08:57:30 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id l12sm1354748edt.46.2020.11.04.08.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 08:57:30 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [RFC 2/9] staging: dpaa2-switch: setup buffer pool for control traffic
Date:   Wed,  4 Nov 2020 18:57:13 +0200
Message-Id: <20201104165720.2566399-3-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201104165720.2566399-1-ciorneiioana@gmail.com>
References: <20201104165720.2566399-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Allocate and setup a buffer pool, needed on the Rx path of the control
interface. Also, define the Rx buffer size seen by the WRIOP from the
PAGE_SIZE buffers seeded.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h | 12 +++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.c     | 31 ++++++++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.h     | 26 +++++++
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c    | 90 ++++++++++++++++++++++
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h    | 10 +++
 5 files changed, 169 insertions(+)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
index 24c902eb63e3..e27e86d5d4fb 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
@@ -8,6 +8,8 @@
 #ifndef __FSL_DPSW_CMD_H
 #define __FSL_DPSW_CMD_H
 
+#include "dpsw.h"
+
 /* DPSW Version */
 #define DPSW_VER_MAJOR		8
 #define DPSW_VER_MINOR		1
@@ -74,6 +76,7 @@
 #define DPSW_CMDID_IF_SET_PRIMARY_MAC_ADDR  DPSW_CMD_ID(0x0A9)
 
 #define DPSW_CMDID_CTRL_IF_GET_ATTR         DPSW_CMD_ID(0x0A0)
+#define DPSW_CMDID_CTRL_IF_SET_POOLS        DPSW_CMD_ID(0x0A1)
 
 /* Macros for accessing command fields smaller than 1byte */
 #define DPSW_MASK(field)        \
@@ -377,6 +380,15 @@ struct dpsw_rsp_ctrl_if_get_attr {
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
index 996f13abfb1b..01ebdb12adec 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
@@ -1213,6 +1213,37 @@ int dpsw_ctrl_if_get_attributes(struct fsl_mc_io *mc_io, u32 cmd_flags,
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
index fcc07991119d..5ad7c0634992 100644
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
index c22b9ad558c8..21d3ff6b9f55 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -1503,6 +1503,83 @@ static int dpaa2_switch_setup_fqs(struct ethsw_core *ethsw)
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
 static int dpaa2_switch_ctrl_if_setup(struct ethsw_core *ethsw)
 {
 	int err;
@@ -1512,6 +1589,11 @@ static int dpaa2_switch_ctrl_if_setup(struct ethsw_core *ethsw)
 	if (err)
 		return err;
 
+	/* setup the buffer poll needed on the Rx path */
+	err = dpaa2_switch_setup_dpbp(ethsw);
+	if (err)
+		return err;
+
 	return 0;
 }
 
@@ -1693,6 +1775,11 @@ static void dpaa2_switch_takedown(struct fsl_mc_device *sw_dev)
 		dev_warn(dev, "dpsw_close err %d\n", err);
 }
 
+static void dpaa2_switch_ctrl_if_teardown(struct ethsw_core *ethsw)
+{
+	dpaa2_switch_free_dpbp(ethsw);
+}
+
 static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 {
 	struct ethsw_port_priv *port_priv;
@@ -1703,6 +1790,9 @@ static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 	dev = &sw_dev->dev;
 	ethsw = dev_get_drvdata(dev);
 
+	if (dpaa2_switch_has_ctrl_if(ethsw))
+		dpaa2_switch_ctrl_if_teardown(ethsw);
+
 	dpaa2_switch_teardown_irqs(sw_dev);
 
 	dpsw_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
index 3189dd72a51b..84130134aa67 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
@@ -17,6 +17,7 @@
 #include <uapi/linux/if_bridge.h>
 #include <net/switchdev.h>
 #include <linux/if_bridge.h>
+#include <linux/fsl/mc.h>
 
 #include "dpsw.h"
 
@@ -42,6 +43,13 @@
 /* Number of receive queues (one RX and one TX_CONF) */
 #define DPAA2_SWITCH_RX_NUM_FQS	2
 
+/* Hardware requires alignment for ingress/egress buffer addresses */
+#define DPAA2_SWITCH_RX_BUF_RAW_SIZE	PAGE_SIZE
+#define DPAA2_SWITCH_RX_BUF_TAILROOM \
+	SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
+#define DPAA2_SWITCH_RX_BUF_SIZE \
+	(DPAA2_SWITCH_RX_BUF_RAW_SIZE - DPAA2_SWITCH_RX_BUF_TAILROOM)
+
 extern const struct ethtool_ops dpaa2_switch_port_ethtool_ops;
 
 struct ethsw_core;
@@ -86,6 +94,8 @@ struct ethsw_core {
 	struct workqueue_struct		*workqueue;
 
 	struct dpaa2_switch_fq		fq[DPAA2_SWITCH_RX_NUM_FQS];
+	struct fsl_mc_device		*dpbp_dev;
+	u16				bpid;
 };
 
 static inline bool dpaa2_switch_has_ctrl_if(struct ethsw_core *ethsw)
-- 
2.28.0

