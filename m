Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C25BC69CC04
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 14:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbjBTNYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 08:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbjBTNXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 08:23:43 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A13B1A941
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 05:23:40 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id o4so1197560wrs.4
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 05:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=144qxu++siL9l6DQXXh9/0gOUbLXJw/9OVqAAlK5ryo=;
        b=j3tLwgvFOzxvVdx5SRyI8CWAsIX4u95SjaLte0MCDHmt6sX0l35vbUf7F4oIFzTE4b
         nGMb2Tevp22HMbw3vR5AGA+ZSxbFshg9q1eB7nV9nNPwhyqtoCua9vpdIjiCAeAUoxz5
         1poKWJQpTsPMea47wveFgm5ePWCBL0am1trW/ygGYC8dHuNLPIQEYMk5Mbn+R/vyUZJH
         fs1calVdMxn36oHShsuljxqNYYOW/R05xQkzPRrKigz9qbohje+pmE8JVNESLLwAJZ4G
         BMD9rnwKxYvsp93f6YLiMgnLTn65v8dlXZxOWC0jfKoEW0hnuWr1v0DYIxMHMyjiLd4/
         3DMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=144qxu++siL9l6DQXXh9/0gOUbLXJw/9OVqAAlK5ryo=;
        b=ayXgr2qqGFu8do1BCOf5oRvv5xM+e+LedsnQig3Xh1+o9M6DXuemt9caRhHPbRUUXg
         36x86ZsveM3lWRp3WdBvhBXi2ifge7zwidH+D490fPgNuYrFeey/MJg5dXECuRGsoNFY
         1OxQ31w/RmLwxKPg3/WKuv7DY0J9pAoQwJQvLUIgyAlLEq8zFweu9bSaUmnx3Ybwy5cS
         VWAHNNf/iP5g1liteTDyvsmFCRw2BDPTJNBWyktWBJgYjIID/uZekQh9qtYtCUIoL7Ib
         6A3JaEbiudSlT8eUFxEfaHJxnIv/Ax/RjbFms55XiglF2WYeEvFbe1rPY3DqQvbC1WaX
         Co3g==
X-Gm-Message-State: AO0yUKVaqB3d4qGDS+ZhJp7z9ZZa1IoJTUkvSJPr6Gt1YIMF/NJhk8Jz
        OL/sOENc5gJzSPDGphYrATpiUbYqgP9orldIJH1ofw==
X-Google-Smtp-Source: AK7set+miZCTdPsqEhcGWaaK035y9eZ+hrvl6q8Yf7y0oxOp8EkxYMrUdqaPAWhdph34OUgEQL4Yew==
X-Received: by 2002:a5d:4cc1:0:b0:2c5:a19e:6d12 with SMTP id c1-20020a5d4cc1000000b002c5a19e6d12mr1972893wrt.10.1676899418577;
        Mon, 20 Feb 2023 05:23:38 -0800 (PST)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id u11-20020adfdb8b000000b002c54fb024b2sm4953907wri.61.2023.02.20.05.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 05:23:37 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org, shuah@kernel.org,
        amirtz@nvidia.com
Subject: [patch net] sefltests: netdevsim: wait for devlink instance after netns removal
Date:   Mon, 20 Feb 2023 14:23:36 +0100
Message-Id: <20230220132336.198597-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
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

When devlink instance is put into network namespace and that network
namespace gets deleted, devlink instance is moved back into init_ns.
This is done as a part of cleanup_net() routine. Since cleanup_net()
is called asynchronously from workqueue, there is no guarantee that
the devlink instance move is done after "ip netns del" returns.

So fix this race by making sure that the devlink instance is present
before any other operation.

Reported-by: Amir Tzin <amirtz@nvidia.com>
Fixes: b74c37fd35a2 ("selftests: netdevsim: add tests for devlink reload with resources")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../selftests/drivers/net/netdevsim/devlink.sh | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index a08c02abde12..7f7d20f22207 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -17,6 +17,18 @@ SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV_NAME/net/
 DEBUGFS_DIR=/sys/kernel/debug/netdevsim/$DEV_NAME/
 DL_HANDLE=netdevsim/$DEV_NAME
 
+wait_for_devlink()
+{
+	"$@" | grep -q $DL_HANDLE
+}
+
+devlink_wait()
+{
+	local timeout=$1
+
+	busywait "$timeout" wait_for_devlink devlink dev
+}
+
 fw_flash_test()
 {
 	RET=0
@@ -256,6 +268,9 @@ netns_reload_test()
 	ip netns del testns2
 	ip netns del testns1
 
+	# Wait until netns async cleanup is done.
+	devlink_wait 2000
+
 	log_test "netns reload test"
 }
 
@@ -348,6 +363,9 @@ resource_test()
 	ip netns del testns2
 	ip netns del testns1
 
+	# Wait until netns async cleanup is done.
+	devlink_wait 2000
+
 	log_test "resource test"
 }
 
-- 
2.39.0

