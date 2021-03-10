Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E89D333C67
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbhCJMQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbhCJMPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:15:41 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFF6C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:41 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id w9so27602410edt.13
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wtSC3LU6tno9Cg43kF76Z1P7VMM0YS3BDBmflXNU7Dc=;
        b=k2dJOcp0z4OqofgfavYzOX1rBJTISpxf/Rs7qkdFfJulnekPkUTLX6oywxYTBtkKiV
         tqJQzhLYBQhJx0iBc3ArC9TocD2j6p3ucjLH00nODta6QcgFK5TzqJEOrnR74goQAiMX
         ELFOBiABxkp6tV01DY4NlXTB5fq/vIK4Io5lBIOPCVOSQgreQ5KUxXuSMyBNZ/LrBcNY
         yai8i4FjtAeQgyxi68HEkyOqOkztYuAmR9qOU9uGkkrBeXAL7o28T/VIbinvJUW0lAti
         tGgRyvKB5YGMGhhvUgJHYamAzaNH8WKv63vUCIhQOgtHa1uRZvcLiPap8gjU2TBJGj+c
         vjyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wtSC3LU6tno9Cg43kF76Z1P7VMM0YS3BDBmflXNU7Dc=;
        b=FRCZw67Ptb446zF7bDrsg329FLVwIm0tubCLk18ryhcdoM1R545MPvIvKfBwT6xPnw
         81Q1LyVT3HA4FAfoMSgqISdlTKVB/VobGqJYEaqv+cXRi1UJssCnEbhhT5lWGHwaG42S
         OUL+LnDxGvBDOrHc1RIY19O/nkaKbOC8fd6CfwpTomyw+mV6oMfg/mHcSTKERGnzaMzb
         fsno6TecuaEdZCD0IiwpGuhvJseTA5RfGgPkQlwpS+tOMeuG3xRhR+nTzLS8MpP2MvW2
         3m95HhmsJTCjiUJRh/OvvBXg4xbYF4RCwwGVBYCpsJZriYQSbJSZq4ARXkAtTZnn/qzZ
         HPrA==
X-Gm-Message-State: AOAM532xZnovuLQWSHvzv7hKV2zpKwWP1PCVAdFyw5nbIlBdzwGUBwIJ
        WB3x22oYRjTqqM1BkQzgi+g=
X-Google-Smtp-Source: ABdhPJwiP7WmuTtsIoQ/eI4d5iiAO7wJcAjW2xIcfnwWPSG0N7IAGff1oD29YVhWYqQZBPWoHaDuQw==
X-Received: by 2002:aa7:cf95:: with SMTP id z21mr2882810edx.76.1615378539877;
        Wed, 10 Mar 2021 04:15:39 -0800 (PST)
Received: from yoga-910.localhost ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id v15sm4865527edw.28.2021.03.10.04.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:15:39 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 09/15] staging: dpaa2-switch: enable the control interface
Date:   Wed, 10 Mar 2021 14:14:46 +0200
Message-Id: <20210310121452.552070-10-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210310121452.552070-1-ciorneiioana@gmail.com>
References: <20210310121452.552070-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Enable the CTRL_IF of the switch object, now that all the pieces are in
place (buffer and queue management, interrupts, NAPI instances etc).

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h |  2 ++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.c     | 37 ++++++++++++++++++++++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.h     |  5 +++
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c    |  9 ++++++
 4 files changed, 53 insertions(+)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
index 4aa83d41d762..6f1b9d16a09f 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
@@ -78,6 +78,8 @@
 
 #define DPSW_CMDID_CTRL_IF_GET_ATTR         DPSW_CMD_ID(0x0A0)
 #define DPSW_CMDID_CTRL_IF_SET_POOLS        DPSW_CMD_ID(0x0A1)
+#define DPSW_CMDID_CTRL_IF_ENABLE           DPSW_CMD_ID(0x0A2)
+#define DPSW_CMDID_CTRL_IF_DISABLE          DPSW_CMD_ID(0x0A3)
 #define DPSW_CMDID_CTRL_IF_SET_QUEUE        DPSW_CMD_ID(0x0A6)
 
 /* Macros for accessing command fields smaller than 1byte */
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
index bd482a9b1930..edc7559b7b1e 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
@@ -1363,3 +1363,40 @@ int dpsw_if_set_primary_mac_addr(struct fsl_mc_io *mc_io, u32 cmd_flags,
 	/* send command to mc*/
 	return mc_send_command(mc_io, &cmd);
 }
+
+/**
+ * dpsw_ctrl_if_enable() - Enable control interface
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpsw_ctrl_if_enable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token)
+{
+	struct fsl_mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_CTRL_IF_ENABLE, cmd_flags,
+					  token);
+
+	return mc_send_command(mc_io, &cmd);
+}
+
+/**
+ * dpsw_ctrl_if_disable() - Function disables control interface
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpsw_ctrl_if_disable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token)
+{
+	struct fsl_mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_CTRL_IF_DISABLE,
+					  cmd_flags,
+					  token);
+
+	return mc_send_command(mc_io, &cmd);
+}
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
index e741e91e485a..954aa4401cd9 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
@@ -245,6 +245,11 @@ struct dpsw_ctrl_if_queue_cfg {
 int dpsw_ctrl_if_set_queue(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 			   enum dpsw_queue_type qtype,
 			   const struct dpsw_ctrl_if_queue_cfg *cfg);
+
+int dpsw_ctrl_if_enable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token);
+
+int dpsw_ctrl_if_disable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token);
+
 /**
  * enum dpsw_action - Action selection for special/control frames
  * @DPSW_ACTION_DROP: Drop frame
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index 102221263062..41860187cba5 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -2066,8 +2066,16 @@ static int dpaa2_switch_ctrl_if_setup(struct ethsw_core *ethsw)
 	if (err)
 		goto err_destroy_rings;
 
+	err = dpsw_ctrl_if_enable(ethsw->mc_io, 0, ethsw->dpsw_handle);
+	if (err) {
+		dev_err(ethsw->dev, "dpsw_ctrl_if_enable err %d\n", err);
+		goto err_deregister_dpio;
+	}
+
 	return 0;
 
+err_deregister_dpio:
+	dpaa2_switch_free_dpio(ethsw);
 err_destroy_rings:
 	dpaa2_switch_destroy_rings(ethsw);
 err_drain_dpbp:
@@ -2283,6 +2291,7 @@ static void dpaa2_switch_takedown(struct fsl_mc_device *sw_dev)
 
 static void dpaa2_switch_ctrl_if_teardown(struct ethsw_core *ethsw)
 {
+	dpsw_ctrl_if_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);
 	dpaa2_switch_free_dpio(ethsw);
 	dpaa2_switch_destroy_rings(ethsw);
 	dpaa2_switch_drain_bp(ethsw);
-- 
2.30.0

