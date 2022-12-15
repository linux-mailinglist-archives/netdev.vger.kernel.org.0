Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B3364D523
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 03:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiLOCBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 21:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiLOCBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 21:01:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2AD2ED55
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 18:01:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B38DB81ABA
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 02:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E469C433F0;
        Thu, 15 Dec 2022 02:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671069668;
        bh=8h/9PS91fuqk9zlgw3gWJW81/bugpI9+OtnI9xk8F9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UiMIk4E/VwBPBgcWbeOGAlgS1rClDQF4wZRzqUPcaXOyZbYVv7s0/tvNeKqDN55KM
         U7B18/Gs9O6RbQATqcpxcQkr1ud6oxA8MATS7i2+xIZHRYMYz5oiKa8UTi4SOhMCky
         X4sQN8K0ysLUnyGKln41biUOV2+bgQef/lE+dLPFcMZFIuVY4U0onhYvr81ywhboA1
         rL3edmp6MRYtBwT9OperCEW7IpqeLpPtJlbhRrAOyGLOGpfZm31mYVSzElK2/X+l/J
         uo3EKzqXi+qDG75khmncznDID6dEh0M6l3ENf1CNzGK8pHQyFe7qu5o1tdvwj9qKbT
         OFvtLtpOboEXg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, jacob.e.keller@intel.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 2/3] selftests: devlink: fix the fd redirect in dummy_reporter_test
Date:   Wed, 14 Dec 2022 18:01:01 -0800
Message-Id: <20221215020102.1619685-3-kuba@kernel.org>
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

$number + > bash means redirect FD $number, e.g. commonly
used 2> redirects stderr (fd 2). The test uses 8192> to
write the number 8192 to a file, this results in:

  ./devlink.sh: line 499: 8192: Bad file descriptor

Oddly the test also papers over this issue by checking
for failure (expecting an error rather than success)
so it passes, anyway.

Fixes: ff18176ad806 ("selftests: Add a test of large binary to devlink health test")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/drivers/net/netdevsim/devlink.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 9de1d123f4f5..a08c02abde12 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -496,8 +496,8 @@ dummy_reporter_test()
 
 	check_reporter_info dummy healthy 3 3 10 true
 
-	echo 8192> $DEBUGFS_DIR/health/binary_len
-	check_fail $? "Failed set dummy reporter binary len to 8192"
+	echo 8192 > $DEBUGFS_DIR/health/binary_len
+	check_err $? "Failed set dummy reporter binary len to 8192"
 
 	local dump=$(devlink health dump show $DL_HANDLE reporter dummy -j)
 	check_err $? "Failed show dump of dummy reporter"
-- 
2.38.1

