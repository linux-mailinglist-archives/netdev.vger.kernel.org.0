Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8E157FB57
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbiGYI3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233895AbiGYI3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:29:38 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A933413FB0
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:36 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id bp15so19222396ejb.6
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n9yNlMPJVHYRJqagoIFBonJiLzu3CLHq76DcFGCkXqM=;
        b=ykqTrlh52WgqdqXl51fTQnWMLZmFQgI7eQrcEUPeBiPEV2tE+SJSvgy/29qo9P10rd
         YWdPoopq5iE9vtkJH1GQnqs3FlTC7w6N2u1VXZt98FIjOvYfwwc6YhYREsApg9PmgIV/
         OitmrhGQ6vHAuwr/9SYTSaFveJq2BbwCq//MUqkfFI24J2u7t44dtbfRLOHJv81lht4g
         qteYf7QRC4eVQXL1mP3lHp2BRakOakzUhCCDqEIVB7SjddZcNPXAqZHXwCbj19VSEbW1
         TcY5zav0kpaVmGPgyi+cHWI5sM9UXvauSGw/B6vix2g0MFnFn3qwNNf+syeQv/hor2gv
         PNyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n9yNlMPJVHYRJqagoIFBonJiLzu3CLHq76DcFGCkXqM=;
        b=JqyIH6XqR5beolTugVuJcOS6wVObXBBSoEbCsNqLvorEqhvKtjrle6Z9mdnaWLWxFR
         I+S0R1Q4NMAlAAM2MgYO3Plde3/+prvPU7XoGtVIzV5SowS+8K32MkHaLxzfDCQDC86P
         enIaXG7MAAegwpz7M5wgQc7EVDzL6BpXK6Ggb3SJ5umAKCsuyQH/Jz2aNr5XT3tcCsbS
         LB6mSu2d8S0RKATDp0PwbVec7W9Pr4zKbAb3OEwSDmv7wj5RGqTjiOqB7+BKUya+ta1q
         4Ol+ibaezrJ+2uPShyDX0ZuTbJJgrmFKdnDEuTY6irB6fRj36Suxndy2bCBdNuG6vee9
         GNXQ==
X-Gm-Message-State: AJIora/LLx+yO8Cb+slgoQDBx+yv1lz1HpIDxLVZBWHyfcRvv2wCR4I2
        wl+6Gsr9e5Dw0eM0LII3Dp8Bz9GA+VDhmYRv9iI=
X-Google-Smtp-Source: AGRyM1txGgsNjDwA0/UOh7xcrGAVaZFWwOHZ7yTr7e2LZro2BaSzgnG80ol1M5YKWFIWqKudVxs8YQ==
X-Received: by 2002:a17:906:5d08:b0:6ff:8ed:db63 with SMTP id g8-20020a1709065d0800b006ff08eddb63mr9296035ejt.408.1658737774982;
        Mon, 25 Jul 2022 01:29:34 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id es21-20020a056402381500b0042de3d661d2sm6706395edb.1.2022.07.25.01.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 01:29:34 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v4 05/12] mlxsw: core_linecards: Expose HW revision and INI version
Date:   Mon, 25 Jul 2022 10:29:18 +0200
Message-Id: <20220725082925.366455-6-jiri@resnulli.us>
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
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
v3->v4:
- added Ido's RVB tag
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

