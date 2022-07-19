Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E688B57936B
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 08:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236271AbiGSGtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 02:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbiGSGtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 02:49:02 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D5B2A403
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:49:00 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id va17so25439227ejb.0
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QbAUtySQT8gbI2UbvTAQbxVI+gD8nKYyKm+QLNLaDME=;
        b=QHG+R23Z1Q1pXQ89YjrB/rGMHN9yoGznDCB45fFvvdwun/eQ8g0iWvRiFVdNssys9s
         zCZr8UehHXOkGSFA9PfMvX6vWwU8t1Otv9CDITatjAmJdRyhmCNjmZhAucszd8WDzrwD
         wv0OJTZCcumRdFQ9EzsWYwCpk/MTk4HsSn9toL/bc1w2rDGEtfm0RTVl5aqCUU02aMk3
         G7IIRQKZgJfqDpx0KIF7yayTeZi4uSEUIudhe9G64YmaMGBZgiBKsNo5Qx5WXMVjsaPx
         JsMSGyODzCUfZN2/k2LlOcTCYVS/gghlaODvFocCgFgwajQoNGFXHquZlFuVpkXvaGUM
         tdDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QbAUtySQT8gbI2UbvTAQbxVI+gD8nKYyKm+QLNLaDME=;
        b=Zsf7b7lOj9TnsZCxqGmZn2gZ+SEKgntPl+ZUnhqaWjO6q8XAqVkxGkXIKLfQuMRORN
         qVfIEjOKUq6zTXBnYRByiVO6/tKQbi/UUCRw9Jbgixn5neRZbK+X8vHcQn4n+XwScb+f
         JKvtx4X0qVKFpbE6cNAnccdmXmKP4Tm9BIDcVcwpyqpD5uxyiFnlqR+apGPtAYDnI83G
         qbu1cRJbbeHrlnGLpvvvdH03FHp1QE6FkADq9yschsyRSa5uMu1A0KZQFRLnE03a2RjL
         vz4dqCJqgY/5iGMxsHXwPVxIT9Y+YJBhTYEOwrKWF9C8QgeQnOl/LRVY4CA20ifm13C2
         FmUw==
X-Gm-Message-State: AJIora9/jbud8CuELeY7HDzSBazvH95zBXS29XUYrXydEoLouPPL453Q
        zwQugvGUssMXftA0ra4iKB+7F1GWaXP5cE/sRLw=
X-Google-Smtp-Source: AGRyM1sbYxTfq9Xpjdp7v2aXlO4POaZoSE1PQn3deDPc33M2KSFliMvW20X9ZsroWw7S5UOgK7p/ig==
X-Received: by 2002:a17:907:948e:b0:72d:3fd2:5da0 with SMTP id dm14-20020a170907948e00b0072d3fd25da0mr27499405ejc.225.1658213338976;
        Mon, 18 Jul 2022 23:48:58 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id co28-20020a0564020c1c00b0043a84dfbf06sm10064505edb.15.2022.07.18.23.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 23:48:58 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v2 07/12] mlxsw: core_linecards: Probe provisioned line cards for devices and expose FW version
Date:   Tue, 19 Jul 2022 08:48:42 +0200
Message-Id: <20220719064847.3688226-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220719064847.3688226-1-jiri@resnulli.us>
References: <20220719064847.3688226-1-jiri@resnulli.us>
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

In case the line card is provisioned, go over all possible existing
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
index c427e07b25dd..bd8f43e21212 100644
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
 
+	if (linecard->ready) {
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

