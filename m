Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DADA54B0F4
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243391AbiFNMhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbiFNMfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:35:47 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B1D4AE03
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:34 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id n10so16876096ejk.5
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hiZiTgbZsVTwSQPSdiwn3XkqgCWRIt4d80/GBgSQ58I=;
        b=PZ+g75MR8gG1WBhpV2TPcKYD9Ah2TnuY6AH5z1BzOLjA04LklDie9dlTH9DQgYnoqD
         uxKYSsXOYQPo31Sut6fHvB8SofsNauqAguJFxgM9xITb0wCWnNgf03uh5TIz5UIvyAXR
         SDUqWKuLl5ABX7Km22flWY0CyfR4bQtQvD8bSexAfKiVjVRnjWy4xFIoDY536LGAcjVd
         PveODJJrmoWjkS/Ev1ALCXQ7jlZS1rLD7vrokUenaloaGe9ZPXoaCwayI8tKczEHH5pP
         cRFpCwdJvlDan2D8TKlfOcrYdnOf8JHeb+4WrMhvmdnbeKUo4CNRmoxMWWRhEijJH9tr
         /8Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hiZiTgbZsVTwSQPSdiwn3XkqgCWRIt4d80/GBgSQ58I=;
        b=vJOuGYjHsr4xpcXdFKi0MASn0Lhk67/9JnoZ+JMf+nTAAG77NP/OavPswdGRNAGw0f
         iMorVHDZ/uh67uLyrJDm7ZT39JgwpfpMci4TXYmDmSCp7OXGlW0Nee8lxCXfs1v8uqiR
         BAuEVrWWbfnyY+nphT3kXNZB8bou6KHc5t+OWEXaMZRiR/B/JbQrDZjDjI2I7NrewVcp
         55tS8Tla8h2h4up+265pOXuFdea83JDyqZ118Ig/lhr+5U4Atzy4GsGqiusnGctd8/vO
         9HyqfOLr/l6aefolk4ahelplRDVP759a0qvwE6MWLCA7PLTEoF4/l9BWVbi3ucU1+NKG
         ZtEg==
X-Gm-Message-State: AOAM532w74STi2w1+kYQEKVYal8XwIpO2NFW3Bb9GttUDNAcidDDOX9h
        mR6sUqpv0GhoUUUDJx/vWbexNeAK89wJcCQnIPE=
X-Google-Smtp-Source: ABdhPJxyRw/1Oor6rgATtLrqG99rJbejn7LqZ4EOhWp1y4AGNqanShOplb/MOO5Lb4dHnLje8VeKGA==
X-Received: by 2002:a17:907:94c8:b0:711:d864:fd84 with SMTP id dn8-20020a17090794c800b00711d864fd84mr4053613ejc.18.1655210013476;
        Tue, 14 Jun 2022 05:33:33 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id m23-20020a170906161700b0071216de7710sm4974627ejd.153.2022.06.14.05.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:33:33 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: [patch net-next 04/11] mlxsw: core_linecards: Expose HW revision and INI version
Date:   Tue, 14 Jun 2022 14:33:19 +0200
Message-Id: <20220614123326.69745-5-jiri@resnulli.us>
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
index cda20a4fcbdb..ea56bcc0a399 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -605,6 +605,10 @@ mlxsw_linecard_get(struct mlxsw_linecards *linecards, u8 slot_index)
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
index d12abd935ded..30659f8be41c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
@@ -94,7 +94,18 @@ void mlxsw_linecard_bdev_del(struct mlxsw_linecard *linecard)
 	auxiliary_device_uninit(&linecard_bdev->adev);
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
index ae51944cde0c..c11d22708bba 100644
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
+		err = 0;
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

