Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2242C6CF12E
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 19:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjC2RdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 13:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjC2RdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 13:33:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BEB40CF;
        Wed, 29 Mar 2023 10:33:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6537161DD4;
        Wed, 29 Mar 2023 17:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF137C433EF;
        Wed, 29 Mar 2023 17:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680111183;
        bh=dGO1QsqKzA7RrfDy8jeeAVnzJLU5EFbv7b204Ar3GqQ=;
        h=From:Date:Subject:To:Cc:From;
        b=pwLCQO0LH3nNYFshACHhDINzKxitxH5vlG6RvwUHdzq2tNpXnYTkipD4D/mRtrRla
         Ow+ckyKq5D8uxk4xVYGhJqVOyoX0pOH8TKm6KLgdfHKU8Zf+F+J9UhmDSqzAVt39Nh
         wXMxsRI9hzn7V2J5a2xaA5d0Q3z2O7DVL+e6XISex9vP4xZMOK6WT5Et8iatpFwbV/
         nHsLK+8lf4/dmC3iJldI57HTMHyVysdnBNX/MtYorPTKpvEzTrMrz3I8Owqv4QGbz1
         +vK6QTnNPRNLu+yQenO7P7K5nwFp1vMHGKuoUgzWU+SM+OXMD+YoNi0Y2KfFI3v3RI
         ZKACZa75WDHiw==
From:   Nathan Chancellor <nathan@kernel.org>
Date:   Wed, 29 Mar 2023 10:32:46 -0700
Subject: [PATCH wireless-next v2] wifi: iwlwifi: mvm: Use 64-bit division
 helper in iwl_mvm_get_crosstimestamp_fw()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230329-iwlwifi-ptp-avoid-64-bit-div-v2-1-22b988eb009b@kernel.org>
X-B4-Tracking: v=1; b=H4sIAD12JGQC/42OQQ6CMBBFr2Jm7RhbCKAr72FYtHSQidiSaVM0h
 rsLnMDly/v5/38hkjBFuB6+IJQ5cvAr6OMBusH4ByG7lUGfdXEu9AV5HmfuGac0ocmBHVYlWk7
 oOKPqylrVfV30jYG1wppIaMX4bthKXiYmkk1MQj2/9907zCw0Uozo6Z2gXfXAMQX57K+y2kP/H
 cgKFRrXONu4qrKdvj1JPI2nIA9ol2X5AechHhrxAAAA
To:     gregory.greenman@intel.com, kvalo@kernel.org
Cc:     nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com,
        johannes.berg@intel.com, avraham.stern@intel.com,
        krishnanand.prabhu@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        Arnd Bergmann <arnd@arndb.de>,
        "kernelci.org bot" <bot@kernelci.org>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2181; i=nathan@kernel.org;
 h=from:subject:message-id; bh=dGO1QsqKzA7RrfDy8jeeAVnzJLU5EFbv7b204Ar3GqQ=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCkqZX6GWvNryxRsv37yCpW033bgF/ON20wbTN6YnOvZ9
 +/etSdGHaUsDGIcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAi0esY/ofca3FqLzue47pj
 dtf+nncl540/TJ1qrL2KnTV3k7Wzkisjw7rHPCdOGcvlnCvj+KF6+DOD43Fp45WSOrH2ZXtZVfy
 8eAE=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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

Use the 64-bit division helper div_u64(), which takes a u64 dividend and
u32 divisor, which matches this situation and prevents the emission of a
libcall for the division.

Fixes: 21fb8da6ebe4 ("wifi: iwlwifi: mvm: read synced time from firmware if supported")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Link: https://github.com/ClangBuiltLinux/linux/issues/1826
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Link: https://lore.kernel.org/6423173a.620a0220.3d5cc.6358@mx.google.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Changes in v2:
- Use division helper div_u64() instead of truncating dividend before
  division (Johannes).
- Link to v1: https://lore.kernel.org/r/20230329-iwlwifi-ptp-avoid-64-bit-div-v1-1-ad8db8d66bc2@kernel.org
---
 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
index 5c2bfc8ed88d..e89259de6f4c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
@@ -116,7 +116,7 @@ iwl_mvm_get_crosstimestamp_fw(struct iwl_mvm *mvm, u32 *gp2, u64 *sys_time)
 
 	gp2_10ns = (u64)le32_to_cpu(resp->gp2_timestamp_hi) << 32 |
 		le32_to_cpu(resp->gp2_timestamp_lo);
-	*gp2 = gp2_10ns / 100;
+	*gp2 = div_u64(gp2_10ns, 100);
 
 	*sys_time = (u64)le32_to_cpu(resp->platform_timestamp_hi) << 32 |
 		le32_to_cpu(resp->platform_timestamp_lo);

---
base-commit: 2af3b2a631b194a43551ce119cb71559d8f6b54b
change-id: 20230329-iwlwifi-ptp-avoid-64-bit-div-1c4717f73f8a

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

