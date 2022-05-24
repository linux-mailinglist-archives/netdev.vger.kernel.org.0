Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A655A532CB3
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 16:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238548AbiEXO5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 10:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238486AbiEXO5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 10:57:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22ADD35267;
        Tue, 24 May 2022 07:57:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBF5DB81722;
        Tue, 24 May 2022 14:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E2BC34115;
        Tue, 24 May 2022 14:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653404233;
        bh=2G1lM3nsXXMS5iC7eM087INlpVeFdluiJ6CvAOU9jHw=;
        h=From:To:Cc:Subject:Date:From;
        b=YXsiqX/+AX/XlBuPt9GAU9pCz1kG63CcwGFug978oLdsFtACwbENY3K9acdYI49jf
         ksoY6+QsxIAt2lyVmCmv0rEAqS94zM8Ltm3jPwMLjlvulwZ/8YvgXNV+dEmy18GQsG
         T8lS1d2ePq7wu10PhVGcowDPjBmgPybWGIaqyFfoBR6PTgI9mcgarJPdntIa3R1hGa
         n+trNYOLcsNh8ec5PF+MGq26jsNpzEHhHnuMg7x3PAVFvM5AonLo+NWvpLVxtBivdz
         pl3IxkfswYul0nH9Uki/0iNjRZ0ThEcEeD54fCNUF1AJvDIDeQmq0uqefCbduNSGKd
         IkWiUshJO+Vrg==
From:   Nathan Chancellor <nathan@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        "kernelci.org bot" <bot@kernelci.org>
Subject: [PATCH] ath6kl: Use cc-disable-warning to disable -Wdangling-pointer
Date:   Tue, 24 May 2022 07:56:55 -0700
Message-Id: <20220524145655.869822-1-nathan@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang does not support this option so the build fails:

  error: unknown warning option '-Wno-dangling-pointer' [-Werror,-Wunknown-warning-option]

Use cc-disable-warning so that the option is only added when it is
supported.

Fixes: bd1d129daa3e ("wifi: ath6k: silence false positive -Wno-dangling-pointer warning on GCC 12")
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/Makefile b/drivers/net/wireless/ath/ath6kl/Makefile
index 01cc0d50fee6..a75bfa9fd1cf 100644
--- a/drivers/net/wireless/ath/ath6kl/Makefile
+++ b/drivers/net/wireless/ath/ath6kl/Makefile
@@ -38,7 +38,7 @@ ath6kl_core-y += recovery.o
 
 # FIXME: temporarily silence -Wdangling-pointer on non W=1+ builds
 ifndef KBUILD_EXTRA_WARN
-CFLAGS_htc_mbox.o += -Wno-dangling-pointer
+CFLAGS_htc_mbox.o += $(call cc-disable-warning, dangling-pointer)
 endif
 
 ath6kl_core-$(CONFIG_NL80211_TESTMODE) += testmode.o

base-commit: 677fb7525331375ba2f90f4bc94a80b9b6e697a3
-- 
2.36.1

