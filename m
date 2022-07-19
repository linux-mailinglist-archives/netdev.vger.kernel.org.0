Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894CF57936D
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 08:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbiGSGtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 02:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237027AbiGSGtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 02:49:07 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8323C2611E
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:49:06 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id m8so4840764edd.9
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uBiHGApY9AeZlxNFdVrppuoURWMXeJrxh0IUdxyISek=;
        b=jQIdA6GKSW6otfEybK/rS7+k/Q7Lw6X8kUacKdamu8PHON8e1Rx9Bj4gKSnJMdZAqQ
         mvyaRIettOmIRY0aBb50yzYYw3+TamPefRfZdGdIYL7cXOu4T+uQRse+ZW5qM9x2gXJ+
         ITCi9wGn3u5xCTet24deEMRgLeO9usnprX1e0qvaZZQDPUe94C5YKPr2X+CZ4kWps7Du
         Dx7dW0BlrG347kMnQype7xjdfYRKNL/4/w5NETF7p3VouI1llIkC7oSZlJ/HXqVZ0xj+
         wsT5glAXg27XCpZML1tO6nJbKsOuuqBOBi5M2wa/9B6G4kYNKNI53ozJ1SqObEVpswoR
         CHxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uBiHGApY9AeZlxNFdVrppuoURWMXeJrxh0IUdxyISek=;
        b=SeaUgiWWp3JeUZ+VIw+i/MH/JOwEOezP6f9Z2Rl4a22DLb+h6tpswMe2f+exhK6wpJ
         opdmpiclZCPglEZu+Bd8lcnL/XxfcShdVQsRksRJ5kH9m4VOFZnO6DDU9dcjaJVQOU8Q
         PnpcNZeJfyAuhEG9hd0qrijwPH7jEXscu0Z1wJxtttqL9ttKG4a7D4YQcNE9iqkG8MWS
         nYWmtsdGJiqSy1SLO01HNBs7uL6OMW4b76hbc2uO0yWUUJMowJYvjiXr2poogumNu8NH
         a+JStnNTudzFWsk1mCYBITPodO36bjjAJ2Orsf8QT7HXrD25Vsr20rd8VfdJgTRMkoRJ
         +hig==
X-Gm-Message-State: AJIora9ckBiKyp7Rrhqji4ug/Qj6OngNGjpnEMNFRsas+w/cDAv0mUPr
        zqyoYIDhCvmQ2IphP4a/erhifnoH8ItvWdNx/Zc=
X-Google-Smtp-Source: AGRyM1uk21RZGrROUBTM/e+DLxXyrBG6Wqmeqxw7r3PsMDA1lW9HBGuNRACjGJ6mGlLndgN5YIKLVA==
X-Received: by 2002:aa7:d053:0:b0:43a:a164:2c3 with SMTP id n19-20020aa7d053000000b0043aa16402c3mr41730215edo.333.1658213345069;
        Mon, 18 Jul 2022 23:49:05 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id cw21-20020a170906c79500b00722fc0779e3sm6345151ejb.85.2022.07.18.23.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 23:49:04 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v2 11/12] selftests: mlxsw: Check line card info on provisioned line card
Date:   Tue, 19 Jul 2022 08:48:46 +0200
Message-Id: <20220719064847.3688226-12-jiri@resnulli.us>
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

