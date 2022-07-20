Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332C457B957
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 17:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241219AbiGTPNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 11:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241182AbiGTPMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 11:12:55 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B8B57261
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:12:47 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id bk26so26557632wrb.11
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PLu1nLUIxPNjaqKsAj5r5LxaGVehewJRk/FtjgG+dB8=;
        b=JladEbdLzbk74S9QoZGt3FlRaj/IPavlMBROstiwocHOoslyCSiDKDixwuuRF/vJrQ
         xK4N67jtmiCfbSRCuUjbTa7/mV7JzXKK/L4K/hoHk6g7DFxbtkvi2OMfy3GKOh67Etf3
         ZjaNQ0tDr/47Qr17fKsCFpg203iu3hhB/D9BQ1ai5Oxri6lBl8Lp8vEIg+/EFqsXcDfD
         EU21dKLxD+R3ngTjvq5N50odzY+yCBZl0AcSjBqT74icHokb4unlEK3MiGnC7O7nabJz
         7yZ+YWDJX/dTNUc7CVwjZwaTejlb73rPl1KnVm5IQ3V+yIU+iwKZfN9yVonWa/fKgZDt
         arIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PLu1nLUIxPNjaqKsAj5r5LxaGVehewJRk/FtjgG+dB8=;
        b=gj5tGGSefZVEIoX1ViXTY3+azBYWmCNEEvQAcj9LTNSiuuIa9LkG6xRy1DL7Cmwz0m
         biRW9b+p1t32qwRkycSv/pSyqQf7iFNKh0JSb4SjGUqnF1D7dhqXKRW2vXpesOQydWtN
         yWjPBBZ0Tb78+RBm7kcjnUjZ8EDMmWpfCI2d7WR7C/kcu6WbwKWZ0rAisLPw7m5SN/cz
         QfTrGtRwhZYBypz2jOGvfkFKyHaGswpsAtIboac+2idHwxFU7PYQ/ZwRG59kUOVHDegX
         frP7o9Oe2ytarFcsDZWHfnwlllCtthUXbu9ARNjKY+Ym8BeyvzmAflxApZt1wwKlRFdq
         agHw==
X-Gm-Message-State: AJIora/q3V7w4BIfm/MyCJ9+/acY/gjFwanKYFvddHWVkcltESJdItKo
        w23E+esCG4UQXeBteBN/nH6xvjWaNohgqHYYfLQ=
X-Google-Smtp-Source: AGRyM1tVmS29M5bhRxHgBWWgoi94E40XW14qdot/FSinyGp0K7YJbefrn+71VQIx67EcGZprNtmrkw==
X-Received: by 2002:adf:d1c9:0:b0:20f:c3dc:e980 with SMTP id b9-20020adfd1c9000000b0020fc3dce980mr30396119wrd.552.1658329967012;
        Wed, 20 Jul 2022 08:12:47 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h15-20020a05600c414f00b003a3253b705dsm2794083wmm.35.2022.07.20.08.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 08:12:46 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v3 06/11] mlxsw: core_linecards: Probe provisioned line cards for devices and expose FW version
Date:   Wed, 20 Jul 2022 17:12:29 +0200
Message-Id: <20220720151234.3873008-7-jiri@resnulli.us>
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

