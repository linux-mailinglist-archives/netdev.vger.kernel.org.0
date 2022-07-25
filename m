Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40FB057FB5C
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbiGYI3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbiGYI3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:29:46 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA6713FB7
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:41 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z22so12914677edd.6
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z1Hg7HjmZ6euqMW03mV+nrZ2JPFeZgjBpGopdXphPeA=;
        b=o2E38hyMc0CPfjH6nqoUKBdtdVR2gjTj/OvyiGncVMSg0f/VywZ9+aPJuc2n3lqaOQ
         moN7RQqSK737GsxPOfuvuA9oDptDaj+MpBs5Jnsb9LGAItmfBMkhhosKz8Nw4VT3PtL1
         3hFgo3rNjspix7xDkX91HN3M5cXNcXQ7QOJ+hNXBa9JrUq1n0JQ8GBdzLcmeFD0mhJWM
         BXW8hqLY7vVx9o218ksSTHKGOBAa8Ei8aXVs41XX3IifTDAgPSBfyJmng+sxbY4q/BQQ
         RyzT72ULNi2+/Lm151Ze5VXWCoYXer9pnNi/3qyvCwxjaG0BQtmENk73YSB1RGF7pqn6
         Rf2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z1Hg7HjmZ6euqMW03mV+nrZ2JPFeZgjBpGopdXphPeA=;
        b=ObrpyA/N4NTkm1LiZt5WZg/vim/2+NScR+7cyDGpHLqCCltQnBNJJil1/snj8MAlVg
         J9GXuLfUPZHumfnmAvw5D+GBsRfWD0WtOqMoKSSmbATbT4vALnmCMiidRlsHQSi6ILUA
         pS4dG+IrXWYTMhQjguCap20WSIBW1IcRPb5X67PJztvnzqdTEhAJm0eWHjBCwF2ViB7p
         NRUNDLBlNZoQ82VrpObWQkvPV/GfE8Zktb5YWcfNQMTKHCTiHaPG1LnXol0OM/bW8VBD
         +r5ymS3KyIfb+RLBzT8UcJxcJy8non3861R8Hlx7GrYHC52AtQVDhv/cRbtySbNqCjQ7
         93tA==
X-Gm-Message-State: AJIora84Sji94ep5jWFQw/0WRXzULK19hORGnWac2Q36vErMNZscIo5D
        tUMagHdtIdBPJsIXGXX//MwTiu5U4MJxeJKd4eY=
X-Google-Smtp-Source: AGRyM1t62X8x9NETZyssXe9uQnc9mPW6INOQI+YgTXCIq/Labz6xXJpCdfiKQ7hIjtRhI2m3aa3r2g==
X-Received: by 2002:a05:6402:370:b0:43b:bb2e:a0c6 with SMTP id s16-20020a056402037000b0043bbb2ea0c6mr12077610edw.378.1658737780742;
        Mon, 25 Jul 2022 01:29:40 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u23-20020a1709060b1700b007263481a43fsm5015089ejg.81.2022.07.25.01.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 01:29:40 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v4 09/12] mlxsw: core_linecards: Expose device PSID over device info
Date:   Mon, 25 Jul 2022 10:29:22 +0200
Message-Id: <20220725082925.366455-10-jiri@resnulli.us>
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

Use tunneled MGIR to obtain PSID of line card device and extend
device_info_get() op to fill up the info with that.

Example:

$ devlink dev info auxiliary/mlxsw_core.lc.0
auxiliary/mlxsw_core.lc.0:
  versions:
      fixed:
        hw.revision 0
        fw.psid MT_0000000749
      running:
        ini.version 4
        fw 19.2010.1312

Signed-off-by: Jiri Pirko <jiri@nvidia.com>---
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
v3->v4:
- added Ido's RVB tag
v2->v3:
- fixed s/Used/Use/ typo in patch description
---
 Documentation/networking/devlink/mlxsw.rst    |  3 ++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  1 +
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 31 +++++++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/Documentation/networking/devlink/mlxsw.rst b/Documentation/networking/devlink/mlxsw.rst
index 65ceed98f94d..433962225bd4 100644
--- a/Documentation/networking/devlink/mlxsw.rst
+++ b/Documentation/networking/devlink/mlxsw.rst
@@ -75,6 +75,9 @@ The ``mlxsw`` driver reports the following versions for line card auxiliary devi
    * - ``ini.version``
      - running
      - Version of line card INI loaded
+   * - ``fw.psid``
+     - fixed
+     - Line card device PSID
    * - ``fw.version``
      - running
      - Three digit firmware version of line card device
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index e19860c05e75..a3246082219d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -568,6 +568,7 @@ struct mlxsw_linecard_device_info {
 	u16 fw_major;
 	u16 fw_minor;
 	u16 fw_sub_minor;
+	char psid[MLXSW_REG_MGIR_FW_INFO_PSID_SIZE];
 };
 
 struct mlxsw_linecard {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index a9568d72ba1b..771a3e43b8bb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -87,6 +87,27 @@ static const char *mlxsw_linecard_type_name(struct mlxsw_linecard *linecard)
 	return linecard->name;
 }
 
+static int mlxsw_linecard_device_psid_get(struct mlxsw_linecard *linecard,
+					  u8 device_index, char *psid)
+{
+	struct mlxsw_core *mlxsw_core = linecard->linecards->mlxsw_core;
+	char mddt_pl[MLXSW_REG_MDDT_LEN];
+	char *mgir_pl;
+	int err;
+
+	mlxsw_reg_mddt_pack(mddt_pl, linecard->slot_index, device_index,
+			    MLXSW_REG_MDDT_METHOD_QUERY,
+			    MLXSW_REG(mgir), &mgir_pl);
+
+	mlxsw_reg_mgir_pack(mgir_pl);
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mddt), mddt_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mgir_fw_info_psid_memcpy_from(mgir_pl, psid);
+	return 0;
+}
+
 static int mlxsw_linecard_device_info_update(struct mlxsw_linecard *linecard)
 {
 	struct mlxsw_core *mlxsw_core = linecard->linecards->mlxsw_core;
@@ -121,6 +142,12 @@ static int mlxsw_linecard_device_info_update(struct mlxsw_linecard *linecard)
 				      linecard->slot_index);
 			return 0;
 		}
+
+		err = mlxsw_linecard_device_psid_get(linecard, device_index,
+						     info.psid);
+		if (err)
+			return err;
+
 		linecard->device.info = info;
 		flashable_found = true;
 	} while (msg_seq);
@@ -293,6 +320,10 @@ int mlxsw_linecard_devlink_info_get(struct mlxsw_linecard *linecard,
 	if (linecard->active) {
 		struct mlxsw_linecard_device_info *info = &linecard->device.info;
 
+		err = devlink_info_version_fixed_put(req,
+						     DEVLINK_INFO_VERSION_GENERIC_FW_PSID,
+						     info->psid);
+
 		sprintf(buf, "%u.%u.%u", info->fw_major, info->fw_minor,
 			info->fw_sub_minor);
 		err = devlink_info_version_running_put(req,
-- 
2.35.3

