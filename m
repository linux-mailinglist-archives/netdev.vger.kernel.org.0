Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF78757B951
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 17:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241198AbiGTPNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 11:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbiGTPMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 11:12:52 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB82599DE
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:12:45 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id z13so6995413wro.13
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UNWtqS9oy8XZF0BXyHi+af1fwYYqh7pnIvuOqnzJYGE=;
        b=lEcRJxZNfNzwobyMBSJCzx1WvMlyJ/C1dDKmK9hoWN1ZwcJfLxW3vcRCv3mebSQltO
         zIdtgamWWLIgeETmOkMtSx6U9PgNiqi2U6UMYmTjAsid3niB8Z47/5qb1h59qpM3Kp+w
         MwRq/rFcwlYcishWVsEPGmB1A69adZYStUxiXmmPvEncFd2sZwLIKdcDzkrzmQDPb7PC
         3kEtTZ/oFHuJAt7oRiWqNe44SMB9qB+dZ52O+pxvIApVUl/uBbvGHaC7F8nYk/VwBmnL
         cbDjPV4sfs7vIBEkekZbdSuyvUEmpA3zuj9MoO9DIRuAvNhf16mDfHLs5pbWcBeDnqkh
         rVxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UNWtqS9oy8XZF0BXyHi+af1fwYYqh7pnIvuOqnzJYGE=;
        b=4OsU4mabog6ukkFKdR+jOV9qfywQDxcUe815o7eWA/fsvyumLvPSWHzmwPLdYFExdP
         7Dyja3ulu32WMoOosBGCbibLykzsKqQdpJgSEbUh+eU2KqS8SLvz5B7tFX+mQI7ldiEl
         AMkR+ij8/4paIfzWBYr8NYaCkNp8LKCmHsi+Ksp3lFGiR1RRBiISfBtyijLbKH1qWl1E
         nUfXpdqGWQlrwefkLPyKm+3MXYILQRMTnqR3xiu7DivdkWiltvSMTGSWz/IQ53KEaKi0
         R7Re93e0p20FgeSKpZrkEnmxkIIeNDuaO8Jus9OZciYhschoEbDUDAgZlZTW/Ke5180H
         OD0Q==
X-Gm-Message-State: AJIora9hlEY1n029NPdgXUqzTU081kLK4WJ79WVW/250BvK2kuKWKNxC
        pMwqcKFnAKUXhqHZdXnKBYLIs+ue4E5EQinlSuc=
X-Google-Smtp-Source: AGRyM1u5r8+FNDZ/85jZX9MEUyg9vNUCJk96ssUN1nzXF4NbkZi43K5GUyZXuLaM8o6bVAZzLd35Lw==
X-Received: by 2002:a5d:6b50:0:b0:21e:298c:caad with SMTP id x16-20020a5d6b50000000b0021e298ccaadmr8548042wrw.509.1658329964116;
        Wed, 20 Jul 2022 08:12:44 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id m184-20020a1c26c1000000b003a04722d745sm2739819wmm.23.2022.07.20.08.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 08:12:43 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v3 04/11] mlxsw: core_linecards: Expose HW revision and INI version
Date:   Wed, 20 Jul 2022 17:12:27 +0200
Message-Id: <20220720151234.3873008-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220720151234.3873008-1-jiri@resnulli.us>
References: <20220720151234.3873008-1-jiri@resnulli.us>
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

Implement info_get() to expose HW revision of a linecard and loaded INI
version.

Example:

$ devlink dev info auxiliary/mlxsw_core.lc.0
auxiliary/mlxsw_core.lc.0:
  versions:
      fixed:
        hw.revision 0
      running:
        ini.version 4

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v2->v3:
- changed return value of mlxsw_linecard_devlink_info_get() is linecard
  is not provisioned to -EOPNOTSUPP
---
 Documentation/networking/devlink/mlxsw.rst    | 18 ++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  4 +++
 .../mellanox/mlxsw/core_linecard_dev.c        | 11 ++++++++
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 28 +++++++++++++++++++
 4 files changed, 61 insertions(+)

diff --git a/Documentation/networking/devlink/mlxsw.rst b/Documentation/networking/devlink/mlxsw.rst
index cf857cb4ba8f..aededcf68df4 100644
--- a/Documentation/networking/devlink/mlxsw.rst
+++ b/Documentation/networking/devlink/mlxsw.rst
@@ -58,6 +58,24 @@ The ``mlxsw`` driver reports the following versions
      - running
      - Three digit firmware version
 
+Line card auxiliary device info versions
+========================================
+
+The ``mlxsw`` driver reports the following versions for line card auxiliary device
+
+.. list-table:: devlink info versions implemented
+   :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``hw.revision``
+     - fixed
+     - The hardware revision for this line card
+   * - ``ini.version``
+     - running
+     - Version of line card INI loaded
+
 Driver-specific Traps
 =====================
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index b22db13fa547..87c58b512536 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -599,6 +599,10 @@ mlxsw_linecard_get(struct mlxsw_linecards *linecards, u8 slot_index)
 	return &linecards->linecards[slot_index - 1];
 }
 
+int mlxsw_linecard_devlink_info_get(struct mlxsw_linecard *linecard,
+				    struct devlink_info_req *req,
+				    struct netlink_ext_ack *extack);
+
 int mlxsw_linecards_init(struct mlxsw_core *mlxsw_core,
 			 const struct mlxsw_bus_info *bus_info);
 void mlxsw_linecards_fini(struct mlxsw_core *mlxsw_core);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
index b1fa9f681003..13c20b83b190 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
@@ -98,7 +98,18 @@ void mlxsw_linecard_bdev_del(struct mlxsw_linecard *linecard)
 	linecard->bdev = NULL;
 }
 
+static int mlxsw_linecard_dev_devlink_info_get(struct devlink *devlink,
+					       struct devlink_info_req *req,
+					       struct netlink_ext_ack *extack)
+{
+	struct mlxsw_linecard_dev *linecard_dev = devlink_priv(devlink);
+	struct mlxsw_linecard *linecard = linecard_dev->linecard;
+
+	return mlxsw_linecard_devlink_info_get(linecard, req, extack);
+}
+
 static const struct devlink_ops mlxsw_linecard_dev_devlink_ops = {
+	.info_get			= mlxsw_linecard_dev_devlink_info_get,
 };
 
 static int mlxsw_linecard_bdev_probe(struct auxiliary_device *adev,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index 43696d8badca..ee986dd2c486 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -226,6 +226,34 @@ void mlxsw_linecards_event_ops_unregister(struct mlxsw_core *mlxsw_core,
 }
 EXPORT_SYMBOL(mlxsw_linecards_event_ops_unregister);
 
+int mlxsw_linecard_devlink_info_get(struct mlxsw_linecard *linecard,
+				    struct devlink_info_req *req,
+				    struct netlink_ext_ack *extack)
+{
+	char buf[32];
+	int err;
+
+	mutex_lock(&linecard->lock);
+	if (WARN_ON(!linecard->provisioned)) {
+		err = -EOPNOTSUPP;
+		goto unlock;
+	}
+
+	sprintf(buf, "%d", linecard->hw_revision);
+	err = devlink_info_version_fixed_put(req, "hw.revision", buf);
+	if (err)
+		goto unlock;
+
+	sprintf(buf, "%d", linecard->ini_version);
+	err = devlink_info_version_running_put(req, "ini.version", buf);
+	if (err)
+		goto unlock;
+
+unlock:
+	mutex_unlock(&linecard->lock);
+	return err;
+}
+
 static int
 mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
 			     u16 hw_revision, u16 ini_version)
-- 
2.35.3

