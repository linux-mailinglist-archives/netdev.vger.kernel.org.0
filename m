Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6822579374
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 08:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbiGSGtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 02:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237018AbiGSGtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 02:49:04 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929E126AF4
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:49:03 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id g1so18259360edb.12
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W1em1UsDSNiiY5DyxbaeQFiQpiJNREA+hWWhMiis8Oc=;
        b=VFAat8VfSAFTsYdpoNwRPkzN5COwo5Sjj3oxjuUTpxvO1QsOZdYj/V+lMaeKxggErw
         O3FnhFBQG+NRVxScFLmIlWJWC9Eyd/CHivUFVirw0ALZQyc2RaQDY94qMufIfEo4aV+z
         oTpuZWc1SyXQiZOZFsJ2UbgX62qiR1gabBLRwH+MmG9ok1p7lV2XYMufB6u0i2M7aOtl
         kJxZGC5lUNeG6USqJXppPRFZ3dzuB4PJfJUSpdmocfHCmOJc1qgnhfQOpGMd8JYFkhJ2
         7IKSGkVGhoqSemyB30+7ZhN9+Y62ZYb28oT3kBKiHdJbljIDdV0qk4aW70/AkIHMrqnz
         J7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W1em1UsDSNiiY5DyxbaeQFiQpiJNREA+hWWhMiis8Oc=;
        b=bcTKtzwSH4K3bMOHMpYri8I19kjkIjvSshsXb+pFb5YTWb2JQ1Hlli8WboqiFLLJXw
         sOR+tzVuA6sEeiVRCZ6jl4cLBQIthDIxdWhA643O8lmgYyJXVpKkjlu1ctk5rmKHH73p
         mB4VeHyY94L+Iqcen1JnmK00kypfCbo+38RUjvkPVnk/5/cgU5jYUk1Q9FKg653tSiGP
         N24h25RB0kru8lFD2FBjvvkP8Five8fL/ZZ1cWzIVsSTautrAC3TfcDC5kSfVsgOSwDL
         ZmRdO6z20gRiDVrocQLu2oMV1GORTikxftbexXeQO9+ko9SwZzMOVpnL41Vex97nHCA0
         hzMg==
X-Gm-Message-State: AJIora9nhGftj9FcrdaAUa97tm+MRa/6Kz8LmpQwgdT4JAQxr43TvqXP
        M55Nm4b3PYu4PLU2/NdgNC00zBjJCM7zolf2zyI=
X-Google-Smtp-Source: AGRyM1uZbLYr0K8hhFjcXEeB+vTM1IuZfdw57OfCiY5VVXLPWVyIplK0ovRd9yyw3ptm4wvMCUNi+Q==
X-Received: by 2002:a05:6402:48:b0:43a:caa8:756b with SMTP id f8-20020a056402004800b0043acaa8756bmr41630202edu.112.1658213342116;
        Mon, 18 Jul 2022 23:49:02 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id q18-20020a056402033200b0043ab866b9e1sm9916685edw.65.2022.07.18.23.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 23:49:01 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v2 09/12] mlxsw: core_linecards: Expose device PSID over device info
Date:   Tue, 19 Jul 2022 08:48:44 +0200
Message-Id: <20220719064847.3688226-10-jiri@resnulli.us>
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

Used tunneled MGIR to obtain PSID of line card device and extend
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

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
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
index bd8f43e21212..471f07bc5c2f 100644
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
 	if (linecard->ready) {
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

