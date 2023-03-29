Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18EA6CF01D
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 19:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbjC2RF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 13:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjC2RF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 13:05:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33701449A;
        Wed, 29 Mar 2023 10:05:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE28E61DC6;
        Wed, 29 Mar 2023 17:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF38C433D2;
        Wed, 29 Mar 2023 17:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680109556;
        bh=T8fWhplWPwZ4OAqvqYb8gn/VvxXqZQz97l6qax8Uj7g=;
        h=From:Date:Subject:To:Cc:From;
        b=hmanBQH2TMYgNyzPakCCdf9Vpmc2yZbH/90wWZQ+yRhqDxy8ni75gnIbnheY+EJef
         Q7TV1K1uGDRUKacpZMlbtIZ3XCMgZYAKJ+wvBTIz9irP1HXsG3w32RxqlucQy7/t+l
         lin6oHBx62zHTxjoOC7F1MyAW/AJP7Fdddf6vbUYD4X3SonPCKR/HXCMuAk+n6KXF4
         KrozPxbuiiKMa6YngzOO0Qyc1jnxjpVjoaOZ4AGp/0Ut7Paca3EZpvwZFxInuW7SRk
         xKWE3QvW+Dw/7+a+ldHPVNLUQAnAfeVUEdGsZzox2BJKR+h+0sQOnLO+k1pjk5chRY
         TKN66xj6UQj6g==
From:   Nathan Chancellor <nathan@kernel.org>
Date:   Wed, 29 Mar 2023 10:05:44 -0700
Subject: [PATCH wireless-next] wifi: iwlwifi: mvm: Avoid 64-bit division in
 iwl_mvm_get_crosstimestamp_fw()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230329-iwlwifi-ptp-avoid-64-bit-div-v1-1-ad8db8d66bc2@kernel.org>
X-B4-Tracking: v=1; b=H4sIAOdvJGQC/x2NQQqDMBAAvyJ77oIaadp+pXiIcVMXbAzZkAji3
 xt7HAZmDhCKTAKv5oBImYU3X6G7NWAX4z+EPFeGvu1Vq/onclkLO8aQApq88Yz3ASdOOHPGzg6
 6004r9zBQE5MRwikab5cr8jWSKF4iRHK8/79vKBxpJRH0tCcYz/MHJo1DDpYAAAA=
To:     gregory.greenman@intel.com, kvalo@kernel.org
Cc:     nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com,
        johannes.berg@intel.com, avraham.stern@intel.com,
        krishnanand.prabhu@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        Arnd Bergmann <arnd@arndb.de>,
        "kernelci.org bot" <bot@kernelci.org>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2173; i=nathan@kernel.org;
 h=from:subject:message-id; bh=T8fWhplWPwZ4OAqvqYb8gn/VvxXqZQz97l6qax8Uj7g=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCkq+Z8LY5R4Zhl+kzx7097ULsrCx6khcu6LA/Vai7dn2
 LgXrZ7VUcrCIMbBICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACbyaS/D/6S05Gc5R7PWHD4n
 /c76AfsNz7VqB5O8q4vO5k2Z0HT42HFGhp5iLfktC3dI9rBknItMn/AzbZOpCmOLzyKG7zWyfcV
 yvAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a 64-bit division in iwl_mvm_get_crosstimestamp_fw(), which
results in a link failure when building 32-bit architectures with clang:

  ld.lld: error: undefined symbol: __udivdi3
  >>> referenced by ptp.c
  >>>               drivers/net/wireless/intel/iwlwifi/mvm/ptp.o:(iwl_mvm_phc_get_crosstimestamp) in archive vmlinux.a

GCC has optimizations for division by a constant that clang does not
implement, so this issue is not visible when building with GCC.

Using div_u64() would resolve this issue, but Arnd points out that this
can be quite expensive and the timestamp is being read at nanosecond
granularity. Nick pointed out that the result of this division is being
stored to a 32-bit type anyways, so truncate gp2_10ns first then do the
division, which elides the need for libcalls.

Fixes: 21fb8da6ebe4 ("wifi: iwlwifi: mvm: read synced time from firmware if supported")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Link: https://github.com/ClangBuiltLinux/linux/issues/1826
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Link: https://lore.kernel.org/6423173a.620a0220.3d5cc.6358@mx.google.com/
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
index 5c2bfc8ed88d..cdd6d69c5b68 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
@@ -116,7 +116,7 @@ iwl_mvm_get_crosstimestamp_fw(struct iwl_mvm *mvm, u32 *gp2, u64 *sys_time)
 
 	gp2_10ns = (u64)le32_to_cpu(resp->gp2_timestamp_hi) << 32 |
 		le32_to_cpu(resp->gp2_timestamp_lo);
-	*gp2 = gp2_10ns / 100;
+	*gp2 = (u32)gp2_10ns / 100;
 
 	*sys_time = (u64)le32_to_cpu(resp->platform_timestamp_hi) << 32 |
 		le32_to_cpu(resp->platform_timestamp_lo);

---
base-commit: 2af3b2a631b194a43551ce119cb71559d8f6b54b
change-id: 20230329-iwlwifi-ptp-avoid-64-bit-div-1c4717f73f8a

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

