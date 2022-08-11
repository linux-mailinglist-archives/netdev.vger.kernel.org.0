Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530C45902D4
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbiHKQQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237738AbiHKQQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:16:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543ACA9279;
        Thu, 11 Aug 2022 08:59:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E28DB82176;
        Thu, 11 Aug 2022 15:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A068C433C1;
        Thu, 11 Aug 2022 15:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233553;
        bh=2IiCj9loBdPxItUWBTy7ake8Mzudtca41aWcUxZnxsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lrJUfna0FjCgs9YEHfLd+F4GJvYGnCJF/2i4DIdQQri7Wz4N4dcSMea0KbmM10xeE
         4Nb52764jnMo5NdbBA5eYLc0LN4dDzRZ/fsCVCW0lmFWSeD2QRDBL2q57xQv/ePMoX
         5xD3aeVNzKrPsrR6ioEhmNb1Bi8QE3DlLMrJ1YH/vPgyhHKn48X5n/TsUyLPk2wDXU
         9W2lYap1c83HiX+ZnlAPAqK/1K2tDlp3jhUs+aLyiHWYL/ljL3aRc8jl9KfMioTjQo
         ag0nhj16T1x0EuO6tV0s00PCFTDNYXvToPJXBPxbN2YSEwEOS+x9fzt1wvCJdfKRCM
         4nHCEsnT3NQDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Machata <petrm@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        danieller@nvidia.com, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 22/69] selftests: mlxsw: resource_scale: Allow skipping a test
Date:   Thu, 11 Aug 2022 11:55:31 -0400
Message-Id: <20220811155632.1536867-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811155632.1536867-1-sashal@kernel.org>
References: <20220811155632.1536867-1-sashal@kernel.org>
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
index 50654f8a8c37..14b7a080312b 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
@@ -39,6 +39,11 @@ for current_test in ${TESTS:-$ALL_TESTS}; do
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
index b9b8274643de..4dafd86eb417 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
@@ -41,6 +41,10 @@ for current_test in ${TESTS:-$ALL_TESTS}; do
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

