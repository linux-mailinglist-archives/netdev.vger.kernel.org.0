Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B1454B156
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241959AbiFNMhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235928AbiFNMgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:36:00 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DAD94AE21
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:39 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id v25so11417201eda.6
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=05qY+DmcIHPzbsRImfHr5c+h2b5Sg85tsWKbYqH/CmE=;
        b=G3A9wRnI4bbfiMdCg2IK0U7Kgj46dLQj+nfdnhIzpU32y9cKkyKs8hnwzzwgjTp6rQ
         pNVvulKaO8747VSR6vdmzybuS7uWqVxdpoLH9mfQrne4Xzu2xR/TLjNkiPXSgFkVfP9K
         +bDVPjv9ZDaMqdj1sW0TWtbn7v/tLOsIHdO4SH2y4u1tLvAJdBuJ4baBMqJGvOWGSbgS
         Xb371uFqvrj4R3EwMLU2MK/sOFEVcqQVpPb3AuS7yYkhXMst5b4nxOSZ9w7knKqKNWRY
         JX/a+BKvKjOT64xcsT9gXpHu5DTKhN8GXN/abfAMjktfAXK0b2hkImXDrYZWti3fd6tU
         S9uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=05qY+DmcIHPzbsRImfHr5c+h2b5Sg85tsWKbYqH/CmE=;
        b=u8azv5nXBgwQdGcjPGIDCKJxhkY6KZZIbhvU5/USOc1WmM1/wve8a5oA+FIePyplJQ
         rXkVmcqC9rrsCB/1y1C5blrCkbn5NhJFG+R7jtH7Tr0fv91QJcr9KO4tD9ix904rS6dY
         xLla8H8BIM3cck24IcaeQx2jc0MZKqgpilP/wKTRLH3iN4qi4wAKKkZ4Kl9E69WOD0sY
         okVLwD5F6J2kpB7D5+o1/P2WXEWE8aFc0CF/JK1Sl/7VpSw6zecsU7l1GAETn3JkqqCt
         ySA4EzMFcDdNlR5ihOXswyEuO9GImSoWMuVyv3VzctuHKsHp8zoJ4PpwkfZrsOm6Kfkr
         OSUQ==
X-Gm-Message-State: AOAM5303N+xNiSHqUIkCAf/zd3Dv7MzkwzKh07VsN0p6DPRPtpTaeTZX
        /PEX0Wn1caw1UfR8IW8Fz/Q0pUvLhSxh+TlVV1k=
X-Google-Smtp-Source: ABdhPJxCjM5huTsZYZbmMr/NYtve8axNeNnMAIzG61BLy7pyXO/M+XmTYSiogsa7fE0gcryGg0zDRQ==
X-Received: by 2002:a05:6402:2788:b0:431:3f86:1d4e with SMTP id b8-20020a056402278800b004313f861d4emr5884722ede.238.1655210018794;
        Tue, 14 Jun 2022 05:33:38 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id h12-20020a1709063b4c00b0070c1c494f73sm5004382ejf.90.2022.06.14.05.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:33:38 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: [patch net-next 08/11] mlxsw: core_linecards: Expose device PSID over device info
Date:   Tue, 14 Jun 2022 14:33:23 +0200
Message-Id: <20220614123326.69745-9-jiri@resnulli.us>
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
index edb0e1307d20..6b8bafc66090 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -574,6 +574,7 @@ struct mlxsw_linecard_device_info {
 	u16 fw_major;
 	u16 fw_minor;
 	u16 fw_sub_minor;
+	char psid[MLXSW_REG_MGIR_FW_INFO_PSID_SIZE];
 };
 
 struct mlxsw_linecard {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index 0f494ea755a9..fe3154c4f92f 100644
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

