Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208EF57FB60
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbiGYIaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234001AbiGYI3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:29:51 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BDB14037
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:45 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z22so12914842edd.6
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uBiHGApY9AeZlxNFdVrppuoURWMXeJrxh0IUdxyISek=;
        b=MdY6oHqQtxL8m3/qgW8zdpAA7SbQtCkJ6J0O+m6aBRhV1aY4Uy5U5C4GGFFijrGlqP
         lnVxJh79ZTddSXWHbr1f3e9jHWTt4cxpKcY0ETqCokAN4zgwK3+Cge/yyfxl+TQmyOsU
         fZRNJB6BrYIuVvDrjjueIUHIUzXTGmT/C6ppp01gXc8g3+vL051UzlUu6tA38AI/7emM
         xN/I3lB7wteV1/jX71I69HeTvdAspmHhw+b8GLu7Ps0fLv4S07EVkB8dF06XDT6H7AS5
         zxPao0lmvVSsl1ucUAVJjGAVMx5goTxls1+7sGtF8/DKeCQANLnLhz9GhjzmPi9aMJzI
         BCoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uBiHGApY9AeZlxNFdVrppuoURWMXeJrxh0IUdxyISek=;
        b=YszFtJqnrS+kfh4qW0z4BSwU1s1N5IWAbg/tm1E7z4Q+1tTxtdYNGxI8lywi+95ZGa
         N54+pi79/XY8kwzuemQxmo6pJ6veSfJ0xrbKblzlmx0hyiRcq4wOjF8IexaPFElcjbXj
         MVSNF1lDCIZg0ub/2sfA0Im8ouGlOFQpMwRpHHVXVLLDk3Jd+IAPkm7UvIqzxX5VRDgk
         ggBG4E0/omOhbrOxgPqPaYOBaTDE7ouYAO4PgsVHa6/Zu3B5RPyG9n+MPVpCwwyR6b53
         AGf5ceWiuOW63PFNLceR92wtKCVtub2flD0SIN5W24H+Otzwqe9qKVEvce/l71HXdhin
         Em6A==
X-Gm-Message-State: AJIora+E0g+/qV+HRrt2nhLmTQJYuf8UpJBPywA1mennpPcgqO5qJD4r
        1FBrKHP7hWORybzArHcjQFXQDr4ysZWwQqmCabs=
X-Google-Smtp-Source: AGRyM1sceT10kYT1Ps9xXf1IfiR4/6RX/qvhKpvEaS/40InPNSmN6VglPEd6NgHxgS9rkTntRaeaqQ==
X-Received: by 2002:a05:6402:524f:b0:43b:ff9b:2cc0 with SMTP id t15-20020a056402524f00b0043bff9b2cc0mr3948737edd.398.1658737783711;
        Mon, 25 Jul 2022 01:29:43 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id i12-20020a170906a28c00b00722e771007fsm5181601ejz.37.2022.07.25.01.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 01:29:43 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v4 11/12] selftests: mlxsw: Check line card info on provisioned line card
Date:   Mon, 25 Jul 2022 10:29:24 +0200
Message-Id: <20220725082925.366455-12-jiri@resnulli.us>
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

Once line card is provisioned, check if HW revision and INI version
are exposed on associated nested auxiliary device.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../drivers/net/mlxsw/devlink_linecard.sh     | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
index 08a922d8b86a..ca4e9b08a105 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
@@ -84,6 +84,13 @@ lc_wait_until_port_count_is()
 	busywait "$timeout" until_lc_port_count_is "$port_count" lc_port_count_get "$lc"
 }
 
+lc_nested_devlink_dev_get()
+{
+	local lc=$1
+
+	devlink lc show $DEVLINK_DEV lc $lc -j | jq -e -r ".[][][].nested_devlink"
+}
+
 PROV_UNPROV_TIMEOUT=8000 # ms
 POST_PROV_ACT_TIMEOUT=2000 # ms
 PROV_PORTS_INSTANTIATION_TIMEOUT=15000 # ms
@@ -191,12 +198,30 @@ ports_check()
 	check_err $? "Unexpected port count linecard $lc (got $port_count, expected $expected_port_count)"
 }
 
+lc_dev_info_provisioned_check()
+{
+	local lc=$1
+	local nested_devlink_dev=$2
+	local fixed_hw_revision
+	local running_ini_version
+
+	fixed_hw_revision=$(devlink dev info $nested_devlink_dev -j | \
+			    jq -e -r '.[][].versions.fixed."hw.revision"')
+	check_err $? "Failed to get linecard $lc fixed.hw.revision"
+	log_info "Linecard $lc fixed.hw.revision: \"$fixed_hw_revision\""
+	running_ini_version=$(devlink dev info $nested_devlink_dev -j | \
+			      jq -e -r '.[][].versions.running."ini.version"')
+	check_err $? "Failed to get linecard $lc running.ini.version"
+	log_info "Linecard $lc running.ini.version: \"$running_ini_version\""
+}
+
 provision_test()
 {
 	RET=0
 	local lc
 	local type
 	local state
+	local nested_devlink_dev
 
 	lc=$LC_SLOT
 	supported_types_check $lc
@@ -207,6 +232,11 @@ provision_test()
 	fi
 	provision_one $lc $LC_16X100G_TYPE
 	ports_check $lc $LC_16X100G_PORT_COUNT
+
+	nested_devlink_dev=$(lc_nested_devlink_dev_get $lc)
+	check_err $? "Failed to get nested devlink handle of linecard $lc"
+	lc_dev_info_provisioned_check $lc $nested_devlink_dev
+
 	log_test "Provision"
 }
 
-- 
2.35.3

