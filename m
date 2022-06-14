Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3936254B151
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241611AbiFNMh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243265AbiFNMgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:36:00 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952994EA27
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:41 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id n10so16876096ejk.5
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uBiHGApY9AeZlxNFdVrppuoURWMXeJrxh0IUdxyISek=;
        b=HFKtlvNcEVIBgjGwOXV1p77u0MbGeHHXszWfQUKV29bMRA9TM/1iNjppmMwCBup/Y7
         cz3kYFFKdaoFEmtswdliuUqPZH4y1dw5N49gB+ksMzSl0psm5tdH2Fi5IUQOBZwVEtam
         JY1LCp+FQAFYL6nZ3/LKc5nOdltbudWl575ebHtdtIUnOEYZaeeS1QgrVKL2+hsjGKSe
         6EM6Yg90AA1CCp+SvZQC46NeZueioFIqWiW4mmShPHfp36I55YVAQt6fbTvNhD7RBMRq
         z7WOiR/z3VeLJHjMEayTEhipwR+zlqkJkIxF/GO2+r3svbMBm+xxRToLXIMsL7p51NW8
         xZrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uBiHGApY9AeZlxNFdVrppuoURWMXeJrxh0IUdxyISek=;
        b=hJtqodI2oInbQnhHS/mgf+KD6rneA51IQTq30GbyJsHseI/h5OhQeqZlh9nVvtczM3
         nuvgKCf2+akwxCKS4Lq8wp4vPQe+bqxkoG8W2gDKWHy67X41HnH5V6JzM5d29hTFMbuy
         9Fb3Ko7FFYPrjtob1+/TxGczEfiVRparVM2yz+g44XJx8rOF/LJqKFr6kKR05HfC1Aob
         s6htkw+BISKeWjbVDquV74qO1xP1QLgBshS8nlwypVcGty02KqjrIQIBGXnUmJBewTSq
         xLnv9/bH/qotIClQ303fPBzc31JSISib0OOBG8ZTROqn6L9vT7wctfGRsJjFiqqPXT4W
         BQLw==
X-Gm-Message-State: AOAM5324QYL/WjMbP2lWuby8Xp6NJY/Ky4WXAFlEv6FPloFdH/zfl7ay
        pwEQ0CIGCfLHJZQvsSyIHif0QeJgw/EpAJ680/o=
X-Google-Smtp-Source: AGRyM1ukEXpPphMZo//Ert55L20pZYbRKB7cXwvKaqJB8K07I0N76EiWPsnPWIge4tDbv8q+M1xBqg==
X-Received: by 2002:a17:906:73d4:b0:715:701c:ae96 with SMTP id n20-20020a17090673d400b00715701cae96mr4052731ejl.50.1655210021185;
        Tue, 14 Jun 2022 05:33:41 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id l9-20020a170906414900b006ffa19b7782sm4983382ejk.74.2022.06.14.05.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:33:40 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: [patch net-next 10/11] selftests: mlxsw: Check line card info on provisioned line card
Date:   Tue, 14 Jun 2022 14:33:25 +0200
Message-Id: <20220614123326.69745-11-jiri@resnulli.us>
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

