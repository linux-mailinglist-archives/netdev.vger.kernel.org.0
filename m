Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7431A54B0D3
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243392AbiFNMgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242992AbiFNMgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:36:01 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9EC3DDD7
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:42 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id o7so16895466eja.1
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7L4Ha1oBjbQvumuTEWh/rgUg6HLMfB7bm1xwqVywznA=;
        b=q5d3gQXWKf6AEXhSIAGX7mqkJ3jobMwHOwL8QUpAVh9tlmGBec67y7L3FsKWFJu2Fm
         5DmKbueXZeU2v2o/glaBzTDsVMaqCSkV/4rZ9qh9ZTpxCni8BmP/iMwy1jksPEVqLPS0
         Lrq1jCbvfzx4+JWy8eKo23qXAT6tNOiVyz5UNtdqGGtU/CfzkYkEDF/4d245aVnxskdS
         bmG1+LTPdkEgBFc+m0ZixkgVKclSrHUge5oQ+jHc7l67YxWswPqxTcgpGifZhKpZE8A3
         XuYA30wv6PHUPq73mhzMk0dQ5yfOVrmPlPioqMF8z2ch6zTQvutz/oAIL+nxXWrrZ4JI
         oEDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7L4Ha1oBjbQvumuTEWh/rgUg6HLMfB7bm1xwqVywznA=;
        b=xQyuL43NW1E0gdRYFZRvS/YqjgUDMn3WbGDz2cBz2TsIhUadB41VXyp+U0nOGoKwtw
         uYd6ZqMQFvGF4rUoPtwN/zkwsMEI3pr8meGZDO/JczCFu1SF0fikU7LDnj2JP7zaCocP
         pK+2NifYzlU0j6OT0pbittiOGNmORIsKSjmL1fntWD/rBrVQ1tRzk7/UB4//kMEKNPn7
         wS1RhkJ5vYr3cQKXNpiS1/zPxFVFi4OpnbMwh9H+UvW1uKT4svrBp7lkgAxjDhqx80TL
         aHH1SYlhEbbLsUtM7BSCR+Xa1DFe7dFVV7Q71hh+2gR3ZLzooemZzFjvIR28m5OjhIy3
         QoWg==
X-Gm-Message-State: AOAM530KHxDOw2Umy7/BpBYmGQS0pRBpgTmakbQVOl0FEsmn5XHs334r
        I+kp98o/4/ZUSLvg4RY7NJxV9nMwa2eQFO1kodg=
X-Google-Smtp-Source: ABdhPJwu9l3kjIjZYfU7gKdXsbvlL6EAf7ey9qt1x/mARKGgvAvkwtL4mc/SeobsM/9ieNjFicxh+Q==
X-Received: by 2002:a17:906:77de:b0:712:1130:eb7b with SMTP id m30-20020a17090677de00b007121130eb7bmr4010396ejn.106.1655210022517;
        Tue, 14 Jun 2022 05:33:42 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id w17-20020a056402269100b0042de3d661d2sm7228050edd.1.2022.06.14.05.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:33:41 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: [patch net-next 11/11] selftests: mlxsw: Check line card info on activated line card
Date:   Tue, 14 Jun 2022 14:33:26 +0200
Message-Id: <20220614123326.69745-12-jiri@resnulli.us>
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

