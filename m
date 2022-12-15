Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A81164D526
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 03:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiLOCBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 21:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiLOCBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 21:01:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBBF2ED5E
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 18:01:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94A7BB81AD6
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 02:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA8BC43396;
        Thu, 15 Dec 2022 02:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671069669;
        bh=H/7J6sFY4CUZF9uGTq//ihOKZh+CnyTrtf6kDADZHUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TsWIyhpRo068bDwK47zTCZ0a/+uiW4M0AJm1uPgOlKieMMfQPHFuubrZr+yYUT/6l
         npCQ2/QwOezxIgzV2U7JvZHeZXee1uJ1EZouh0P6P8a0pP9l49o2e7hV5DNe/9c6d3
         fdSOI3FIhX4H0jBVrbomm8N29rr+SGcfNfy4tOJOlXxNF+i0Uyfi6uStSPenXtolJ7
         1FO/gvZFWuaHuDKhjhkt2kcJpLvLsn4njdF/RX+dqiVIuwoMbFAqEi3T0y0n+IPfca
         0sSwRLoi3yRTuSq1UyObcFWJTZd506iydJIHHjjlGS0O/65Xg8xFmRxXRlb1HxySIA
         pYc9OLdQS/yoQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, jacob.e.keller@intel.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 3/3] selftests: devlink: add a warning for interfaces coming up
Date:   Wed, 14 Dec 2022 18:01:02 -0800
Message-Id: <20221215020102.1619685-4-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221215020102.1619685-1-kuba@kernel.org>
References: <20221215020102.1619685-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NetworkManager (and other daemons) may bring the interface up
and cause failures in quiescence checks. Print a helpful warning,
and take the interface down again.

I seem to forget about this every time I run these tests on a new VM.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../selftests/drivers/net/netdevsim/devlink_trap.sh | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
index 109900c817be..b64d98ca0df7 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
@@ -47,6 +47,17 @@ if [ -d "${NETDEVSIM_PATH}/devices/netdevsim${DEV_ADDR}" ]; then
 	exit 1
 fi
 
+check_netdev_down()
+{
+	state=$(cat /sys/class/net/${NETDEV}/flags)
+
+	if [ $((state & 1)) -ne 0 ]; then
+		echo "WARNING: unexpected interface UP, disable NetworkManager?"
+
+		ip link set dev $NETDEV down
+	fi
+}
+
 init_test()
 {
 	RET=0
@@ -151,6 +162,7 @@ trap_stats_test()
 
 	RET=0
 
+	check_netdev_down
 	for trap_name in $(devlink_traps_get); do
 		devlink_trap_stats_idle_test $trap_name
 		check_err $? "Stats of trap $trap_name not idle when netdev down"
@@ -254,6 +266,7 @@ trap_group_stats_test()
 
 	RET=0
 
+	check_netdev_down
 	for group_name in $(devlink_trap_groups_get); do
 		devlink_trap_group_stats_idle_test $group_name
 		check_err $? "Stats of trap group $group_name not idle when netdev down"
-- 
2.38.1

