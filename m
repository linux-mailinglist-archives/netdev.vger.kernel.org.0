Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A0054B150
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243884AbiFNMh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241708AbiFNMft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:35:49 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11ED4EA0C
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:37 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id v25so11417201eda.6
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f+hrYCMPtJsL6NW0+fjUmODY+GTSljaGOwwT1r84FI4=;
        b=UnqRFyezHBQDYZPm7Ffe5Za0xUFx3UKqkZLRLBce69SbJZvHewLHX8aNiNEGZ65PC+
         LswA0h7Sl6gFjKq40/0AXCYoEBiPpqi0QW6maD37DPTgRDemXioFOV3IBjL7N9/tccuQ
         35161b0MYjnCOM2WptrHK5gk+IGslstb+1mm5xTE9PB6SsKqq8y+qYla41y6vv9hK2yu
         t+/1l9ji4+4IqvK/mXuvWsYd8lEOqQdGdcF/kn1PaTKm7jT1TlcGodshbukEFhanj/vz
         1/cJKCTK+sBOVrPcFPFO4NuVGAV8bBkD2ocw+XVz7/0flqDz27LMg7sj9XjCZFweFvUV
         akxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f+hrYCMPtJsL6NW0+fjUmODY+GTSljaGOwwT1r84FI4=;
        b=SSh73M3qBgvc7bcHoZD8T2nHF4KFlplYH4Hc2pDH7hIgSEoOt1lItH0ynuS3UfwV3H
         s314j3VFMQow3mbmnD793a+RvZ039jea6dVn5RcffMsJUBNOfmakpof8354Cj2WV4wLD
         0KNNR6UBIZAlFMZaZM9vJeYsIg5yPn3FIaf4Mtj3z9tE92dDVfkQi6d8a6IUc7xBreI9
         UWXNHB4xJkGkFdAuVfSJrv0jsAGeVY2gIAddscmneS0kws6thuT2XW4mh4aa2JTmfRwc
         0Tj8jR92Sq1F1+4+28v24p6qT8tOXG4cXp8RHORalIvKUICtkIJ2soCUuT9syeEHYtt5
         oYMQ==
X-Gm-Message-State: AJIora8lqczqqNnLwTE8ACBj2sruO6Y1hntIUZi87FuypDJmrKkxf7s1
        ELbMkcy5ovH186rFvjWggeIMwA4c7eMifyzmXCY=
X-Google-Smtp-Source: ABdhPJxyLJm2mM353k0CsYtGgL0l6Vni1EqUn2OvJTEyzNjCnJ590yxL7FaMzVr8b4nCk2wQrjnOPg==
X-Received: by 2002:a05:6402:540c:b0:434:d965:f8a with SMTP id ev12-20020a056402540c00b00434d9650f8amr5862062edb.30.1655210016170;
        Tue, 14 Jun 2022 05:33:36 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id s22-20020a1709064d9600b00705cd37fd5asm4988985eju.72.2022.06.14.05.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:33:35 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: [patch net-next 06/11] mlxsw: core_linecards: Probe provisioned line cards for devices and expose FW version
Date:   Tue, 14 Jun 2022 14:33:21 +0200
Message-Id: <20220614123326.69745-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220614123326.69745-1-jiri@resnulli.us>
References: <20220614123326.69745-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index ea56bcc0a399..edb0e1307d20 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -570,6 +570,12 @@ enum mlxsw_linecard_status_event_type {
 
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
@@ -585,6 +591,9 @@ struct mlxsw_linecard {
 	u16 hw_revision;
 	u16 ini_version;
 	struct mlxsw_linecard_bdev *bdev;
+	struct {
+		struct mlxsw_linecard_device_info info;
+	} device;
 };
 
 struct mlxsw_linecard_types_info;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index c11d22708bba..0f494ea755a9 100644
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

