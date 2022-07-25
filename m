Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0130D57FB5B
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbiGYI3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbiGYI3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:29:42 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5E21400B
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:39 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id f15so4449394edc.4
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ivRSD0yaN+b7bjrQswkjv2qNq1KdIrxrr4Phxp/aci8=;
        b=LsH1Hk/5XOFWURObrFgkMJrR4/w9Q9l9SmYQeozgGykmeHU2X5zAUAV3MWYT2YUtq1
         SZ8a3ikbkVTgx6F4YoOwMvnniCZ9i+d8VEVv4d3cqxP0cwfBWApsSSOOAYZWmaikpZMn
         mckaTXyUBAiGc74PdHO9Nx9pj03Y5IkTvAGsbpIG6i7/in9rANvtO21qIPwztBSpjjwc
         20GrEKeSd7McMTROpvS2g0bHZWyu1t+UTbfmr40ly0+uAEmiBUPn8Ob0u4VCa+K9k18t
         kN6jvLU0LlNhL5C/+iCbgSDygehoK3bg/yIhyjf7J9j9HRgjiI93GQEXvm9rriUwYHUc
         UtCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ivRSD0yaN+b7bjrQswkjv2qNq1KdIrxrr4Phxp/aci8=;
        b=6WxDqkkH6BIffipGPrW8vV9TrWiXySp5ypa7Gq9Sk+7Geo0YQxgJKMeQQpb8T4xpvt
         LWfK1PKz4M99OzPN+g7Wf/pWwDklWBTDm1n7FdNM29/zyFb/zhUTl+rObZU/SGigOgJ+
         zYF2skqMgbkdg1Vi1SIipNe5E6kok0x99WFTbxr4rNa2LDsIFVGkuSi6hIYiVHwxj1e/
         zAu2/EqYQ1Kw0tdWzggESAikrkA/0f7txTk+YtXe6/+32jnSmP5QCPO1VVCKnCvcKkAu
         XhmAhNkMoyCKzXz0kcKJnmkmdgvFr2EotX+K5zVSugIMtIs6IpYTXj4gCNAKl9IEnK/s
         XkwQ==
X-Gm-Message-State: AJIora+tkwcnk1IYLSl0oh8FKERt4Zcz84MAAOnmr8alxZnbotbDDVnp
        Rty373EVN0uKgnDnhSUy8YIHWAqOU5CPVfPFuV4=
X-Google-Smtp-Source: AGRyM1tYAoxkyupMCW2R1IeLJZzP3QiZbe2knwfztY5mWCs1Ekh6IwX+zZ9uUlqVtYB8n4LX7Mqs2A==
X-Received: by 2002:a05:6402:1c19:b0:43b:e2c2:15b0 with SMTP id ck25-20020a0564021c1900b0043be2c215b0mr8682207edb.6.1658737777875;
        Mon, 25 Jul 2022 01:29:37 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id y10-20020a056402358a00b0043a8f5ad272sm6839660edc.49.2022.07.25.01.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 01:29:37 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v4 07/12] mlxsw: core_linecards: Probe active line cards for devices and expose FW version
Date:   Mon, 25 Jul 2022 10:29:20 +0200
Message-Id: <20220725082925.366455-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220725082925.366455-1-jiri@resnulli.us>
References: <20220725082925.366455-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

In case the line card is active, go over all possible existing
devices (gearboxes) on it and expose FW version of the flashable one.

Example:

$ devlink dev info auxiliary/mlxsw_core.lc.0
auxiliary/mlxsw_core.lc.0:
  versions:
      fixed:
        hw.revision 0
      running:
        ini.version 4
        fw 19.2010.1312

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
v3->v4:
- changes "provisioned" to "active" in patch subject and description
- added Ido's RVB tag
v2->v3:
- changed the check in mlxsw_linecard_devlink_info_get() to ->active
---
 Documentation/networking/devlink/mlxsw.rst    |  3 +
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  9 +++
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 57 +++++++++++++++++++
 3 files changed, 69 insertions(+)

diff --git a/Documentation/networking/devlink/mlxsw.rst b/Documentation/networking/devlink/mlxsw.rst
index aededcf68df4..65ceed98f94d 100644
--- a/Documentation/networking/devlink/mlxsw.rst
+++ b/Documentation/networking/devlink/mlxsw.rst
@@ -75,6 +75,9 @@ The ``mlxsw`` driver reports the following versions for line card auxiliary devi
    * - ``ini.version``
      - running
      - Version of line card INI loaded
+   * - ``fw.version``
+     - running
+     - Three digit firmware version of line card device
 
 Driver-specific Traps
 =====================
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 87c58b512536..e19860c05e75 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -564,6 +564,12 @@ enum mlxsw_linecard_status_event_type {
 
 struct mlxsw_linecard_bdev;
 
+struct mlxsw_linecard_device_info {
+	u16 fw_major;
+	u16 fw_minor;
+	u16 fw_sub_minor;
+};
+
 struct mlxsw_linecard {
 	u8 slot_index;
 	struct mlxsw_linecards *linecards;
@@ -579,6 +585,9 @@ struct mlxsw_linecard {
 	u16 hw_revision;
 	u16 ini_version;
 	struct mlxsw_linecard_bdev *bdev;
+	struct {
+		struct mlxsw_linecard_device_info info;
+	} device;
 };
 
 struct mlxsw_linecard_types_info;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index ee986dd2c486..a9568d72ba1b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -87,6 +87,47 @@ static const char *mlxsw_linecard_type_name(struct mlxsw_linecard *linecard)
 	return linecard->name;
 }
 
+static int mlxsw_linecard_device_info_update(struct mlxsw_linecard *linecard)
+{
+	struct mlxsw_core *mlxsw_core = linecard->linecards->mlxsw_core;
+	bool flashable_found = false;
+	u8 msg_seq = 0;
+
+	do {
+		struct mlxsw_linecard_device_info info;
+		char mddq_pl[MLXSW_REG_MDDQ_LEN];
+		bool flash_owner;
+		bool data_valid;
+		u8 device_index;
+		int err;
+
+		mlxsw_reg_mddq_device_info_pack(mddq_pl, linecard->slot_index,
+						msg_seq);
+		err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mddq), mddq_pl);
+		if (err)
+			return err;
+		mlxsw_reg_mddq_device_info_unpack(mddq_pl, &msg_seq,
+						  &data_valid, &flash_owner,
+						  &device_index,
+						  &info.fw_major,
+						  &info.fw_minor,
+						  &info.fw_sub_minor);
+		if (!data_valid)
+			break;
+		if (!flash_owner) /* We care only about flashable ones. */
+			continue;
+		if (flashable_found) {
+			dev_warn_once(linecard->linecards->bus_info->dev, "linecard %u: More flashable devices present, exposing only the first one\n",
+				      linecard->slot_index);
+			return 0;
+		}
+		linecard->device.info = info;
+		flashable_found = true;
+	} while (msg_seq);
+
+	return 0;
+}
+
 static void mlxsw_linecard_provision_fail(struct mlxsw_linecard *linecard)
 {
 	linecard->provisioned = false;
@@ -249,6 +290,18 @@ int mlxsw_linecard_devlink_info_get(struct mlxsw_linecard *linecard,
 	if (err)
 		goto unlock;
 
+	if (linecard->active) {
+		struct mlxsw_linecard_device_info *info = &linecard->device.info;
+
+		sprintf(buf, "%u.%u.%u", info->fw_major, info->fw_minor,
+			info->fw_sub_minor);
+		err = devlink_info_version_running_put(req,
+						       DEVLINK_INFO_VERSION_GENERIC_FW,
+						       buf);
+		if (err)
+			goto unlock;
+	}
+
 unlock:
 	mutex_unlock(&linecard->lock);
 	return err;
@@ -308,6 +361,10 @@ static int mlxsw_linecard_ready_set(struct mlxsw_linecard *linecard)
 	char mddc_pl[MLXSW_REG_MDDC_LEN];
 	int err;
 
+	err = mlxsw_linecard_device_info_update(linecard);
+	if (err)
+		return err;
+
 	mlxsw_reg_mddc_pack(mddc_pl, linecard->slot_index, false, true);
 	err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(mddc), mddc_pl);
 	if (err)
-- 
2.35.3

