Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3A55903F4
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238098AbiHKQZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238003AbiHKQYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:24:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D871A833;
        Thu, 11 Aug 2022 09:05:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D4BCB821AD;
        Thu, 11 Aug 2022 16:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C798EC433D6;
        Thu, 11 Aug 2022 16:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233944;
        bh=y2IrkiMugo1Km5Q7lyHBt53yMDZvh7y5Xn/R7V2EW3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SgKO+TLpXvawc8P6w/uLWu6WX8GKBQQ6ZEnw0D+Uwm/dpHBRCaw096lOQosXdomKG
         bZ7n5f3yuVgehTI/X+nmkbxE3mKCJfpE2kBsBeIVh+M0Jp77+l4kDECoX+b0rbY648
         ZAtu6tqvVgKRTTKgCjuH9iZbmi75wb62lvn9v15E0j06ASkRmWXQfgpSRUkMMSvo7H
         VZn6MRv2VZl0KfsvhBz/sZMo5c9cy2RpUeErzh6zEUVOwMuNhCkbBqnCAA5pqhq1j1
         gBMwak0Pap+BRl4bwhra4ei/NOU51FQ0/9waW1KG6fp6Tnr+JLxctRdr9CINPqbYE/
         XcTgxT+VsInFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Machata <petrm@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        danieller@nvidia.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 15/46] selftests: mlxsw: resource_scale: Allow skipping a test
Date:   Thu, 11 Aug 2022 12:03:39 -0400
Message-Id: <20220811160421.1539956-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160421.1539956-1-sashal@kernel.org>
References: <20220811160421.1539956-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 8cad339db339a39cb82b1188e4be4070a433abac ]

The scale tests are currently testing two things: that some number of
instances of a given resource can actually be created; and that when an
attempt is made to create more than the supported amount, the failures are
noted and handled gracefully.

Sometimes the scale test depends on more than one resource. In particular,
a following patch will add a RIF counter scale test, which depends on the
number of RIF counters that can be bound, and also on the number of RIFs
that can be created.

When the test is limited by the auxiliary resource and not by the primary
one, there's no point trying to run the overflow test, because it would be
testing exhaustion of the wrong resource.

To support this use case, when the $test_get_target yields 0, skip the test
instead.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh | 5 +++++
 .../selftests/drivers/net/mlxsw/spectrum/resource_scale.sh   | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
index d7cf33a3f18d..ce2b4074ea77 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
@@ -38,6 +38,11 @@ for current_test in ${TESTS:-$ALL_TESTS}; do
 	for should_fail in 0 1; do
 		RET=0
 		target=$(${current_test}_get_target "$should_fail")
+		if ((target == 0)); then
+			log_test_skip "'$current_test' should_fail=$should_fail test"
+			continue
+		fi
+
 		${current_test}_setup_prepare
 		setup_wait $num_netifs
 		${current_test}_test "$target" "$should_fail"
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
index 43f662401bc3..23438d527f6f 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
@@ -40,6 +40,10 @@ for current_test in ${TESTS:-$ALL_TESTS}; do
 		for should_fail in 0 1; do
 			RET=0
 			target=$(${current_test}_get_target "$should_fail")
+			if ((target == 0)); then
+				log_test_skip "'$current_test' [$profile] should_fail=$should_fail test"
+				continue
+			fi
 			${current_test}_setup_prepare
 			setup_wait $num_netifs
 			${current_test}_test "$target" "$should_fail"
-- 
2.35.1

