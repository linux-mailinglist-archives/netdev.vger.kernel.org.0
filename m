Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9DB333C65
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhCJMQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbhCJMPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:15:37 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F33DC061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:37 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id b13so27755499edx.1
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=52lAask9jmGX6Fmh4VSr56m4xK8gi0rFlYMvzfcNqo4=;
        b=dy7NgJMedCFnxzY23treeKMinjF3TNnUhL4OXF2PkoIWvnlFywejwxH2VB53S0YH5H
         zefIJx57SgBOXHbai7hyT0kWTiVa6UeklE933DsWjGo6USrRl5P78AKhmPgHJ4ChE0sG
         RofeAFA8nQJSmTFARGoTmP17FfaiSjK8RnTJwr2Gx0AFXZ17beKN5vb1q1UzouSncKld
         fL9lpR/eCWPcoTipdpdo+vFpknS2Z4/jy5h5QjdfPhlYRRbVOwozwG759rKoCe7DWPa/
         xGB3GgQkdiYf/PH6w3mDUC82JA6Y9t0NP+7dw3SFk5OWnXZQpAB/IIkrSdGSQ7NkHPSM
         Wobg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=52lAask9jmGX6Fmh4VSr56m4xK8gi0rFlYMvzfcNqo4=;
        b=Hk/NUiVyVkSEVHd3pqRH6EjcsXWbShWRmfz+nWmlaUPorMVPPGR8bNRFXa+xdSt9Lx
         D5iCgEDe5cyu0D/pQn8ycueWMbH3wOgtFC78AT/4j5XPYsvDX0hkS3seOpEsDfiUJlIj
         iDEO0ON/MVLJrZ4hSnOhALmOsYqOt3ioXMsujbT5gZYcu2OCk4Q3LxeerfOWGxQyWqxA
         /cOLAp+ZAgJ+P+VHFSigJISTY18/rydpK3XA/byxs8+6nkTzfWsbBC2b9I/eoOvFofhR
         mYitwZW41F4ANco70UBNyGqjEI84M1m8gqXCnxcCMVo1vKZfxGXx068pQPRIR+g/QgY3
         LVGg==
X-Gm-Message-State: AOAM533vLyaU1IkzghpS3al+1LvAJ1LJotco5oHFd5arVllHXJhQTkBb
        FvRwuB8zUoSrIXC9fd65mI0=
X-Google-Smtp-Source: ABdhPJx38cVKh/dihjUUWJu4UwAeXXbAgNPyXshk6x3JhHNcEo970zG8rACJwPu+pJC+IROJm9DE3Q==
X-Received: by 2002:aa7:d316:: with SMTP id p22mr2811505edq.107.1615378535898;
        Wed, 10 Mar 2021 04:15:35 -0800 (PST)
Received: from yoga-910.localhost ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id v15sm4865527edw.28.2021.03.10.04.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:15:35 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 06/15] staging: dpaa2-switch: setup dpio
Date:   Wed, 10 Mar 2021 14:14:43 +0200
Message-Id: <20210310121452.552070-7-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210310121452.552070-1-ciorneiioana@gmail.com>
References: <20210310121452.552070-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Setup interrupts on the control interface queues. We do not force an
exact affinity between the interrupts received from a specific queue and
a cpu.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h | 15 +++++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.c     | 33 +++++++++++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.h     | 23 ++++++++
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c    | 65 ++++++++++++++++++++++
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h    |  1 +
 5 files changed, 137 insertions(+)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
index d76f80d1bd8b..d451e1e7f0a3 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
@@ -76,6 +76,7 @@
 
 #define DPSW_CMDID_CTRL_IF_GET_ATTR         DPSW_CMD_ID(0x0A0)
 #define DPSW_CMDID_CTRL_IF_SET_POOLS        DPSW_CMD_ID(0x0A1)
+#define DPSW_CMDID_CTRL_IF_SET_QUEUE        DPSW_CMD_ID(0x0A6)
 
 /* Macros for accessing command fields smaller than 1byte */
 #define DPSW_MASK(field)        \
@@ -368,6 +369,20 @@ struct dpsw_cmd_ctrl_if_set_pools {
 	__le16 buffer_size[DPSW_MAX_DPBP];
 };
 
+#define DPSW_DEST_TYPE_SHIFT	0
+#define DPSW_DEST_TYPE_SIZE	4
+
+struct dpsw_cmd_ctrl_if_set_queue {
+	__le32 dest_id;
+	u8 dest_priority;
+	u8 pad;
+	/* from LSB: dest_type:4 */
+	u8 dest_type;
+	u8 qtype;
+	__le64 user_ctx;
+	__le32 options;
+};
+
 struct dpsw_rsp_get_api_version {
 	__le16 version_major;
 	__le16 version_minor;
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
index a560270b2466..4bc5791c0fa1 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
@@ -1151,6 +1151,39 @@ int dpsw_ctrl_if_set_pools(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 	return mc_send_command(mc_io, &cmd);
 }
 
+/**
+ * dpsw_ctrl_if_set_queue() - Set Rx queue configuration
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of dpsw object
+ * @qtype:	dpsw_queue_type of the targeted queue
+ * @cfg:	Rx queue configuration
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpsw_ctrl_if_set_queue(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			   enum dpsw_queue_type qtype,
+			   const struct dpsw_ctrl_if_queue_cfg *cfg)
+{
+	struct dpsw_cmd_ctrl_if_set_queue *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_CTRL_IF_SET_QUEUE,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpsw_cmd_ctrl_if_set_queue *)cmd.params;
+	cmd_params->dest_id = cpu_to_le32(cfg->dest_cfg.dest_id);
+	cmd_params->dest_priority = cfg->dest_cfg.priority;
+	cmd_params->qtype = qtype;
+	cmd_params->user_ctx = cpu_to_le64(cfg->user_ctx);
+	cmd_params->options = cpu_to_le32(cfg->options);
+	dpsw_set_field(cmd_params->dest_type,
+		       DEST_TYPE,
+		       cfg->dest_cfg.dest_type);
+
+	return mc_send_command(mc_io, &cmd);
+}
+
 /**
  * dpsw_get_api_version() - Get Data Path Switch API version
  * @mc_io:	Pointer to MC portal's I/O object
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
index b14ec3e10b85..f888778b70a1 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
@@ -222,6 +222,29 @@ struct dpsw_ctrl_if_pools_cfg {
 int dpsw_ctrl_if_set_pools(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 			   const struct dpsw_ctrl_if_pools_cfg *cfg);
 
+#define DPSW_CTRL_IF_QUEUE_OPT_USER_CTX		0x00000001
+#define DPSW_CTRL_IF_QUEUE_OPT_DEST		0x00000002
+
+enum dpsw_ctrl_if_dest {
+	DPSW_CTRL_IF_DEST_NONE = 0,
+	DPSW_CTRL_IF_DEST_DPIO = 1,
+};
+
+struct dpsw_ctrl_if_dest_cfg {
+	enum dpsw_ctrl_if_dest dest_type;
+	int dest_id;
+	u8 priority;
+};
+
+struct dpsw_ctrl_if_queue_cfg {
+	u32 options;
+	u64 user_ctx;
+	struct dpsw_ctrl_if_dest_cfg dest_cfg;
+};
+
+int dpsw_ctrl_if_set_queue(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			   enum dpsw_queue_type qtype,
+			   const struct dpsw_ctrl_if_queue_cfg *cfg);
 /**
  * enum dpsw_action - Action selection for special/control frames
  * @DPSW_ACTION_DROP: Drop frame
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index 06998578355c..5e2d441cbc38 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -1463,6 +1463,64 @@ static void dpaa2_switch_destroy_rings(struct ethsw_core *ethsw)
 		dpaa2_io_store_destroy(ethsw->fq[i].store);
 }
 
+static int dpaa2_switch_setup_dpio(struct ethsw_core *ethsw)
+{
+	struct dpsw_ctrl_if_queue_cfg queue_cfg;
+	struct dpaa2_io_notification_ctx *nctx;
+	int err, i, j;
+
+	for (i = 0; i < DPAA2_SWITCH_RX_NUM_FQS; i++) {
+		nctx = &ethsw->fq[i].nctx;
+
+		/* Register a new software context for the FQID.
+		 * By using NULL as the first parameter, we specify that we do
+		 * not care on which cpu are interrupts received for this queue
+		 */
+		nctx->is_cdan = 0;
+		nctx->id = ethsw->fq[i].fqid;
+		nctx->desired_cpu = DPAA2_IO_ANY_CPU;
+		err = dpaa2_io_service_register(NULL, nctx, ethsw->dev);
+		if (err) {
+			err = -EPROBE_DEFER;
+			goto err_register;
+		}
+
+		queue_cfg.options = DPSW_CTRL_IF_QUEUE_OPT_DEST |
+				    DPSW_CTRL_IF_QUEUE_OPT_USER_CTX;
+		queue_cfg.dest_cfg.dest_type = DPSW_CTRL_IF_DEST_DPIO;
+		queue_cfg.dest_cfg.dest_id = nctx->dpio_id;
+		queue_cfg.dest_cfg.priority = 0;
+		queue_cfg.user_ctx = nctx->qman64;
+
+		err = dpsw_ctrl_if_set_queue(ethsw->mc_io, 0,
+					     ethsw->dpsw_handle,
+					     ethsw->fq[i].type,
+					     &queue_cfg);
+		if (err)
+			goto err_set_queue;
+	}
+
+	return 0;
+
+err_set_queue:
+	dpaa2_io_service_deregister(NULL, nctx, ethsw->dev);
+err_register:
+	for (j = 0; j < i; j++)
+		dpaa2_io_service_deregister(NULL, &ethsw->fq[j].nctx,
+					    ethsw->dev);
+
+	return err;
+}
+
+static void dpaa2_switch_free_dpio(struct ethsw_core *ethsw)
+{
+	int i;
+
+	for (i = 0; i < DPAA2_SWITCH_RX_NUM_FQS; i++)
+		dpaa2_io_service_deregister(NULL, &ethsw->fq[i].nctx,
+					    ethsw->dev);
+}
+
 static int dpaa2_switch_ctrl_if_setup(struct ethsw_core *ethsw)
 {
 	int err;
@@ -1481,8 +1539,14 @@ static int dpaa2_switch_ctrl_if_setup(struct ethsw_core *ethsw)
 	if (err)
 		goto err_free_dpbp;
 
+	err = dpaa2_switch_setup_dpio(ethsw);
+	if (err)
+		goto err_destroy_rings;
+
 	return 0;
 
+err_destroy_rings:
+	dpaa2_switch_destroy_rings(ethsw);
 err_free_dpbp:
 	dpaa2_switch_free_dpbp(ethsw);
 
@@ -1683,6 +1747,7 @@ static void dpaa2_switch_takedown(struct fsl_mc_device *sw_dev)
 
 static void dpaa2_switch_ctrl_if_teardown(struct ethsw_core *ethsw)
 {
+	dpaa2_switch_free_dpio(ethsw);
 	dpaa2_switch_destroy_rings(ethsw);
 	dpaa2_switch_free_dpbp(ethsw);
 }
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
index f5bd2cd3d140..50dd529e2a79 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
@@ -61,6 +61,7 @@ struct dpaa2_switch_fq {
 	struct ethsw_core *ethsw;
 	enum dpsw_queue_type type;
 	struct dpaa2_io_store *store;
+	struct dpaa2_io_notification_ctx nctx;
 	u32 fqid;
 };
 
-- 
2.30.0

