Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1054860CADB
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbiJYLYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbiJYLYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:24:40 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3793311DAB2
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:24:39 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id v13-20020a17090a6b0d00b0021332e5388fso2858682pjj.1
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Oj659AYhc6HIR61s8FmziJL1yQbf574idqGOpkhuuQ0=;
        b=ISbImws30GnFewAgf0jeCNv3LraaF59sQL/XCmIagHCgJyfD12YMdvmsLceKmtGboD
         Kxmar6bhIUU82Idgo8cCQIuhM7tgR6ga7yV6Z8yLijcvJzqMKnu5Vqb32YxUWx2GdK0g
         G3AGKIEb+8b+GNDY9MaNwMkKJedgLP3szcfhr80oJDLImZNP15viSxXIDF2HdS3PPaoN
         jlrRJQg8maF5vLNXKef76yRHK5tYGlZhsIsFaJa2Ih4tXipFW39mfpJCvHOdem+WRGgj
         vuPj6h0V5cRrDFiJ7+Ooip7ndK3YW1njmtELv7HBkZi1spZ2iVwQae0RJVwnA4YhLbhp
         gg5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oj659AYhc6HIR61s8FmziJL1yQbf574idqGOpkhuuQ0=;
        b=uFoO/b5yewvZHAL3J522NntFgeRoGJr4NHkbBj1bZ/uMD3cPJ+wYKXDz2HAxwJmTNL
         7bgEoRv7a5AVCAgoiWnwVOdogyCDqouTBZLi19TzDxKbhBBVCROkyJcaXfN/BNGYZMkv
         oaHb1wrzBKg0oT5twjLgDJJJ94vSbY5wjk1nLyaXSKTkIY1t9VUpvX3Gql4SVmJ3E97T
         E9Ob/ubRllKe2V5E50JvH31xaOevKceY48FgQqik68S8YgVGDJvmfHGuEdqJIkSYC+uC
         TVIyQ3dbh0hcdgyRyAsdJcDjIxEO7mfGbAyBSRoWsUT/JcVngTvSlauCxilcnB+/XfCR
         ArPQ==
X-Gm-Message-State: ACrzQf173bD2G9nOIv58YK1pVlyttKVWFHEKSJDjd3dJysM0sX6XWsRm
        g0ltoQ2iJ5cjIqbd3s+7sHDT/g==
X-Google-Smtp-Source: AMsMyM7FPoZqRQXilITeq/R0f7g8YcQkx+G8Po7EcDCvh7wprOk+gPJm/sGCf4GUSwuejaZg1HGYHw==
X-Received: by 2002:a17:902:ebc5:b0:186:b848:c6a with SMTP id p5-20020a170902ebc500b00186b8480c6amr5874388plg.46.1666697078680;
        Tue, 25 Oct 2022 04:24:38 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id w20-20020a1709029a9400b00185507b5ef8sm1073425plp.50.2022.10.25.04.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 04:24:37 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        leon@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 3/5] ionic: new ionic device identity level and VF start control
Date:   Tue, 25 Oct 2022 04:24:24 -0700
Message-Id: <20221025112426.8954-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221025112426.8954-1-snelson@pensando.io>
References: <20221025112426.8954-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new ionic dev_cmd is added to the interface in ionic_if.h,
with a new capabilities field in the ionic device identity to
signal its availability in the FW.  The identity level code is
incremented to '2' to show support for this new capabilities
bitfield.

If the driver has indicated with the new identity level that
it has the VF_CTRL command, newer FW will wait for the start
command before starting the VFs after a FW update or crash
recovery.

This patch updates the driver to make use of the new VF start
control in fw_up path to be sure that the PF has set the user
attributes on the VF before the FW allows the VFs to restart.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 14 +++++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  3 ++
 .../net/ethernet/pensando/ionic/ionic_if.h    | 41 +++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  2 +
 .../net/ethernet/pensando/ionic/ionic_main.c  |  2 +-
 5 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 9d0514cfeb5c..626b9113e7c4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -481,6 +481,20 @@ int ionic_dev_cmd_vf_getattr(struct ionic *ionic, int vf, u8 attr,
 	return err;
 }
 
+void ionic_vf_start(struct ionic *ionic)
+{
+	union ionic_dev_cmd cmd = {
+		.vf_ctrl.opcode = IONIC_CMD_VF_CTRL,
+		.vf_ctrl.ctrl_opcode = IONIC_VF_CTRL_START_ALL,
+	};
+
+	if (!(ionic->ident.dev.capabilities & cpu_to_le64(IONIC_DEV_CAP_VF_CTRL)))
+		return;
+
+	ionic_dev_cmd_go(&ionic->idev, &cmd);
+	ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+}
+
 /* LIF commands */
 void ionic_dev_cmd_queue_identify(struct ionic_dev *idev,
 				  u16 lif_type, u8 qtype, u8 qver)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 563c302eb033..2a1d7b9c07e7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -124,6 +124,8 @@ static_assert(sizeof(struct ionic_vf_setattr_cmd) == 64);
 static_assert(sizeof(struct ionic_vf_setattr_comp) == 16);
 static_assert(sizeof(struct ionic_vf_getattr_cmd) == 64);
 static_assert(sizeof(struct ionic_vf_getattr_comp) == 16);
+static_assert(sizeof(struct ionic_vf_ctrl_cmd) == 64);
+static_assert(sizeof(struct ionic_vf_ctrl_comp) == 16);
 #endif /* __CHECKER__ */
 
 struct ionic_devinfo {
@@ -324,6 +326,7 @@ int ionic_dev_cmd_vf_getattr(struct ionic *ionic, int vf, u8 attr,
 			     struct ionic_vf_getattr_comp *comp);
 void ionic_dev_cmd_queue_identify(struct ionic_dev *idev,
 				  u16 lif_type, u8 qtype, u8 qver);
+void ionic_vf_start(struct ionic *ionic);
 void ionic_dev_cmd_lif_identify(struct ionic_dev *idev, u8 type, u8 ver);
 void ionic_dev_cmd_lif_init(struct ionic_dev *idev, u16 lif_index,
 			    dma_addr_t addr);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index 4a90f611c611..aaa88f3272e7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -54,6 +54,7 @@ enum ionic_cmd_opcode {
 	/* SR/IOV commands */
 	IONIC_CMD_VF_GETATTR			= 60,
 	IONIC_CMD_VF_SETATTR			= 61,
+	IONIC_CMD_VF_CTRL			= 62,
 
 	/* QoS commands */
 	IONIC_CMD_QOS_CLASS_IDENTIFY		= 240,
@@ -200,6 +201,7 @@ struct ionic_dev_reset_comp {
 };
 
 #define IONIC_IDENTITY_VERSION_1	1
+#define IONIC_DEV_IDENTITY_VERSION_2	2
 
 /**
  * struct ionic_dev_identify_cmd - Driver/device identify command
@@ -253,6 +255,14 @@ union ionic_drv_identity {
 	__le32 words[478];
 };
 
+/**
+ * enum ionic_dev_capability - Device capabilities
+ * @IONIC_DEV_CAP_VF_CTRL:     Device supports VF ctrl operations
+ */
+enum ionic_dev_capability {
+	IONIC_DEV_CAP_VF_CTRL        = BIT(0),
+};
+
 /**
  * union ionic_dev_identity - device identity information
  * @version:          Version of device identify
@@ -273,6 +283,7 @@ union ionic_drv_identity {
  * @hwstamp_mask:     Bitmask for subtraction of hardware tick values.
  * @hwstamp_mult:     Hardware tick to nanosecond multiplier.
  * @hwstamp_shift:    Hardware tick to nanosecond divisor (power of two).
+ * @capabilities:     Device capabilities
  */
 union ionic_dev_identity {
 	struct {
@@ -290,6 +301,7 @@ union ionic_dev_identity {
 		__le64 hwstamp_mask;
 		__le32 hwstamp_mult;
 		__le32 hwstamp_shift;
+		__le64 capabilities;
 	};
 	__le32 words[478];
 };
@@ -2044,6 +2056,33 @@ struct ionic_vf_getattr_comp {
 	u8     color;
 };
 
+enum ionic_vf_ctrl_opcode {
+	IONIC_VF_CTRL_START_ALL	= 0,
+	IONIC_VF_CTRL_START	= 1,
+};
+
+/**
+ * struct ionic_vf_ctrl_cmd - VF control command
+ * @opcode:         Opcode for the command
+ * @vf_index:       VF Index. It is unused if op START_ALL is used.
+ * @ctrl_opcode:    VF control operation type
+ */
+struct ionic_vf_ctrl_cmd {
+	u8	opcode;
+	u8	ctrl_opcode;
+	__le16	vf_index;
+	u8	rsvd1[60];
+};
+
+/**
+ * struct ionic_vf_ctrl_comp - VF_CTRL command completion.
+ * @status:     Status of the command (enum ionic_status_code)
+ */
+struct ionic_vf_ctrl_comp {
+	u8	status;
+	u8      rsvd[15];
+};
+
 /**
  * struct ionic_qos_identify_cmd - QoS identify command
  * @opcode:  opcode
@@ -2865,6 +2904,7 @@ union ionic_dev_cmd {
 
 	struct ionic_vf_setattr_cmd vf_setattr;
 	struct ionic_vf_getattr_cmd vf_getattr;
+	struct ionic_vf_ctrl_cmd vf_ctrl;
 
 	struct ionic_lif_identify_cmd lif_identify;
 	struct ionic_lif_init_cmd lif_init;
@@ -2903,6 +2943,7 @@ union ionic_dev_cmd_comp {
 
 	struct ionic_vf_setattr_comp vf_setattr;
 	struct ionic_vf_getattr_comp vf_getattr;
+	struct ionic_vf_ctrl_comp vf_ctrl;
 
 	struct ionic_lif_identify_comp lif_identify;
 	struct ionic_lif_init_comp lif_init;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index a06b2da1e0c4..f5d39594ef54 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2629,6 +2629,8 @@ static void ionic_vf_attr_replay(struct ionic_lif *lif)
 	}
 
 	up_read(&ionic->vf_op_lock);
+
+	ionic_vf_start(ionic);
 }
 
 static const struct net_device_ops ionic_netdev_ops = {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 56f93b030551..ed9d8c995236 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -533,7 +533,7 @@ int ionic_identify(struct ionic *ionic)
 	sz = min(sizeof(ident->drv), sizeof(idev->dev_cmd_regs->data));
 	memcpy_toio(&idev->dev_cmd_regs->data, &ident->drv, sz);
 
-	ionic_dev_cmd_identify(idev, IONIC_IDENTITY_VERSION_1);
+	ionic_dev_cmd_identify(idev, IONIC_DEV_IDENTITY_VERSION_2);
 	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
 	if (!err) {
 		sz = min(sizeof(ident->dev), sizeof(idev->dev_cmd_regs->data));
-- 
2.17.1

