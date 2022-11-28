Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287D763AF54
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 18:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbiK1Rkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 12:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233232AbiK1RkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 12:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B5529821;
        Mon, 28 Nov 2022 09:39:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91A8AB80E97;
        Mon, 28 Nov 2022 17:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0D6C43146;
        Mon, 28 Nov 2022 17:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657147;
        bh=wFJv/SIyttPLTWrKzL8P4VDK1X+3bsfYI2ibgv1F07I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iRywopb5iLgWmKM8X+Qof8N9lJga6mCW00b6QImfss65agDRC429RliWj4ctcYThu
         xoVrgC86vxHlSfVEzaY9DgES7vdwB5SkpQQnPh9GcMDerU64hd7aFTd76+I5jEbuvv
         /lpjn7fw/lGbIAkuo4x05ELrzL1PlguiIO1amZkTwxvR8btO0DVZHVhvfz+kebgz8t
         +5A4GMIQ7uWiciES4lwtGSFwL20DhVfzCYJNL5cx4Q7HBumLp5MHbHAe5AL/Em7hbS
         9b0TO3peZ8b4yqR7DRWCPTDXxci7zIovuhKnB0w6iwNDTUqTN1FxfmQXiwEakZ94y1
         cUytOMUyO3O1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 27/39] selftests/net: Find nettest in current directory
Date:   Mon, 28 Nov 2022 12:36:07 -0500
Message-Id: <20221128173642.1441232-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128173642.1441232-1-sashal@kernel.org>
References: <20221128173642.1441232-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Díaz <daniel.diaz@linaro.org>

[ Upstream commit bd5e1e42826f18147afb0ba07e6a815f52cf8bcb ]

The `nettest` binary, built from `selftests/net/nettest.c`,
was expected to be found in the path during test execution of
`fcnal-test.sh` and `pmtu.sh`, leading to tests getting
skipped when the binary is not installed in the system, as can
be seen in these logs found in the wild [1]:

  # TEST: vti4: PMTU exceptions                                         [SKIP]
  [  350.600250] IPv6: ADDRCONF(NETDEV_CHANGE): veth_b: link becomes ready
  [  350.607421] IPv6: ADDRCONF(NETDEV_CHANGE): veth_a: link becomes ready
  # 'nettest' command not found; skipping tests
  #   xfrm6udp not supported
  # TEST: vti6: PMTU exceptions (ESP-in-UDP)                            [SKIP]
  [  351.605102] IPv6: ADDRCONF(NETDEV_CHANGE): veth_b: link becomes ready
  [  351.612243] IPv6: ADDRCONF(NETDEV_CHANGE): veth_a: link becomes ready
  # 'nettest' command not found; skipping tests
  #   xfrm4udp not supported

The `unicast_extensions.sh` tests also rely on `nettest`, but
it runs fine there because it looks for the binary in the
current working directory [2]:

The same mechanism that works for the Unicast extensions tests
is here copied over to the PMTU and functional tests.

[1] https://lkft.validation.linaro.org/scheduler/job/5839508#L6221
[2] https://lkft.validation.linaro.org/scheduler/job/5839508#L7958

Signed-off-by: Daniel Díaz <daniel.diaz@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 11 +++++++----
 tools/testing/selftests/net/pmtu.sh       | 10 ++++++----
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 31c3b6ebd388..21ca91473c09 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -4196,10 +4196,13 @@ elif [ "$TESTS" = "ipv6" ]; then
 	TESTS="$TESTS_IPV6"
 fi
 
-which nettest >/dev/null
-if [ $? -ne 0 ]; then
-	echo "'nettest' command not found; skipping tests"
-	exit $ksft_skip
+# nettest can be run from PATH or from same directory as this selftest
+if ! which nettest >/dev/null; then
+	PATH=$PWD:$PATH
+	if ! which nettest >/dev/null; then
+		echo "'nettest' command not found; skipping tests"
+		exit $ksft_skip
+	fi
 fi
 
 declare -i nfail=0
diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 736e358dc549..dfe3d287f01d 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -686,10 +686,12 @@ setup_xfrm() {
 }
 
 setup_nettest_xfrm() {
-	which nettest >/dev/null
-	if [ $? -ne 0 ]; then
-		echo "'nettest' command not found; skipping tests"
-	        return 1
+	if ! which nettest >/dev/null; then
+		PATH=$PWD:$PATH
+		if ! which nettest >/dev/null; then
+			echo "'nettest' command not found; skipping tests"
+			return 1
+		fi
 	fi
 
 	[ ${1} -eq 6 ] && proto="-6" || proto=""
-- 
2.35.1

