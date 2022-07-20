Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4286257B94C
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 17:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241294AbiGTPNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 11:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241178AbiGTPNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 11:13:02 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0CC5A444
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:12:54 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id e15so21321920wro.5
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7L4Ha1oBjbQvumuTEWh/rgUg6HLMfB7bm1xwqVywznA=;
        b=yD4XcgPqiQZ7QByC+uYHhWdwI8MuVOKtBAW6Zt0LRtLnWlzeV1iXocVnebKJOsOO9r
         GaEzguKR/lqQYe8uuempY6bZ8snOu33W7g6gmhRWBXty3KgZiSTDj1EwyrL0iHVLjqOI
         p6ki3fynE5nYF5JinmHq7fWvE+Tpu9Sjs55fm6F4N7ITVPgt4v6vAcu37to1FrANX43v
         EXciHSGYLD8ooCACMeFMm7gJLWZX4rq9RuF3tb53/RHDkNq9PeuE1kffV+Rw3moTb7ON
         8m8/Ypi5IfBieRUptMehzP0u65QZFl+XjTwr1c7pznSaOpwX+Wmwj4oScr9fA4MJvpEU
         9xkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7L4Ha1oBjbQvumuTEWh/rgUg6HLMfB7bm1xwqVywznA=;
        b=yjfYpNwQGrE0/he9eelFqfIEsDInxshPnkz52H4PCi9UWHJgdsjQ20jLRqh8xX3m5S
         x2sU2VeSUwfVcQhSifbysNU3wTeGwbdQ5mgZRME/DFOAcgIpg3UiBOSgT1LKj6JCryMc
         R+JWkGTTpmK6FFr72ApFdbYbA3Rcydufuy/1kraY+EiVsdtnvW9aYEbf6WatIyrApKXN
         JtvIHslaR3E6QRcjvnomSYZUK1FjOrdSFveEPwd69Fdlz3nmfrOQlNwr5vq2kocqOjc5
         xL1SDypEXCBI/JSklYBtrCxXQUd1dhG1xqii1vFPRV4nVF8aHt4uRXXrv+iFkRXMN+L7
         EBKA==
X-Gm-Message-State: AJIora/2qxQ7/v4hbzB9G/LYyOSdOkVFyOFHwLH7xd11KF93vgKinynE
        5XfTCT/1H6f7B+WnZubx4TulrGTwYU58i9WfZPw=
X-Google-Smtp-Source: AGRyM1uLl/bMZsnSrcg52UG9t8NshoI0hAVfciwRDSvrkSfESbZRcUtioBzdZugvjqmg+SzsC5/tMw==
X-Received: by 2002:a05:6000:1ac5:b0:21d:beaf:c2c3 with SMTP id i5-20020a0560001ac500b0021dbeafc2c3mr29394301wry.609.1658329973918;
        Wed, 20 Jul 2022 08:12:53 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id n12-20020a05600c3b8c00b003a2ed2a40e4sm3380954wms.17.2022.07.20.08.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 08:12:53 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v3 11/11] selftests: mlxsw: Check line card info on activated line card
Date:   Wed, 20 Jul 2022 17:12:34 +0200
Message-Id: <20220720151234.3873008-12-jiri@resnulli.us>
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

Once line card is activated, check the FW version and PSID are exposed.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../drivers/net/mlxsw/devlink_linecard.sh     | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
index ca4e9b08a105..224ca3695c89 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
@@ -250,12 +250,32 @@ interface_check()
 	setup_wait
 }
 
+lc_dev_info_active_check()
+{
+	local lc=$1
+	local nested_devlink_dev=$2
+	local fixed_device_fw_psid
+	local running_device_fw
+
+	fixed_device_fw_psid=$(devlink dev info $nested_devlink_dev -j | \
+			       jq -e -r ".[][].versions.fixed" | \
+			       jq -e -r '."fw.psid"')
+	check_err $? "Failed to get linecard $lc fixed fw PSID"
+	log_info "Linecard $lc fixed.fw.psid: \"$fixed_device_fw_psid\""
+
+	running_device_fw=$(devlink dev info $nested_devlink_dev -j | \
+			    jq -e -r ".[][].versions.running.fw")
+	check_err $? "Failed to get linecard $lc running.fw.version"
+	log_info "Linecard $lc running.fw: \"$running_device_fw\""
+}
+
 activation_16x100G_test()
 {
 	RET=0
 	local lc
 	local type
 	local state
+	local nested_devlink_dev
 
 	lc=$LC_SLOT
 	type=$LC_16X100G_TYPE
@@ -268,6 +288,10 @@ activation_16x100G_test()
 
 	interface_check
 
+	nested_devlink_dev=$(lc_nested_devlink_dev_get $lc)
+	check_err $? "Failed to get nested devlink handle of linecard $lc"
+	lc_dev_info_active_check $lc $nested_devlink_dev
+
 	log_test "Activation 16x100G"
 }
 
-- 
2.35.3

