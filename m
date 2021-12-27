Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C71480461
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 20:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhL0TSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 14:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbhL0TSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 14:18:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B2BC06173E;
        Mon, 27 Dec 2021 11:18:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 859FD6112D;
        Mon, 27 Dec 2021 19:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B2CC36AEA;
        Mon, 27 Dec 2021 19:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640632688;
        bh=n5gKVOMAx5d3Lm9+UJVfBhmS+gppM0kjtgJrzvZySQo=;
        h=From:To:Cc:Subject:Date:From;
        b=OTn+aDN93CQcpoBpQH7fKL7Vmm2o6JTMsGal7zmx0Cqd5+RTzsx3or0rwT81VTax7
         gNXTetjD0PhVDRZ8HgczJElJfhJ9udTr1WZT85l9KtbUlsY10MCuWFQx/hi6qzps3d
         nOKQ1R792h/KbDpgxpasvUR8uCVR88hWpp9WQ/HBbJb+ChtYWIm0CerPv02cQBST8K
         ITORhEg5MnPFq6w8mp8jFji6v8BGr9tKqERDtjh+6GPlpuyEDsYiHyvgp+DEr/3zf+
         Fl1j/n7teqF2tWXjl8tBiHwUmlcReQz7v1KvkabTwOn0iE5dKBmurJi2uNWzqLWSoV
         uBgljiECpFiZg==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Luca Coelho <luciano.coelho@intel.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] iwlwifi: mvm: Use div_s64 instead of do_div in iwl_mvm_ftm_rtt_smoothing()
Date:   Mon, 27 Dec 2021 12:17:57 -0700
Message-Id: <20211227191757.2354329-1-nathan@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building ARCH=arm allmodconfig:

drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c: In function ‘iwl_mvm_ftm_rtt_smoothing’:
./include/asm-generic/div64.h:222:35: error: comparison of distinct pointer types lacks a cast [-Werror]
  222 |         (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
      |                                   ^~
drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c:1070:9: note: in expansion of macro ‘do_div’
 1070 |         do_div(rtt_avg, 100);
      |         ^~~~~~

do_div() has to be used with an unsigned 64-bit integer dividend but
rtt_avg is a signed 64-bit integer.

div_s64() expects a signed 64-bit integer dividend and signed 32-bit
divisor, which fits this scenario, so use that function here to fix the
warning.

Fixes: 8b0f92549f2c ("iwlwifi: mvm: fix 32-bit build in FTM")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index 9449d1af3c11..628aee634b2a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -1066,8 +1066,7 @@ static void iwl_mvm_ftm_rtt_smoothing(struct iwl_mvm *mvm,
 	overshoot = IWL_MVM_FTM_INITIATOR_SMOOTH_OVERSHOOT;
 	alpha = IWL_MVM_FTM_INITIATOR_SMOOTH_ALPHA;
 
-	rtt_avg = alpha * rtt + (100 - alpha) * resp->rtt_avg;
-	do_div(rtt_avg, 100);
+	rtt_avg = div_s64(alpha * rtt + (100 - alpha) * resp->rtt_avg, 100);
 
 	IWL_DEBUG_INFO(mvm,
 		       "%pM: prev rtt_avg=%lld, new rtt_avg=%lld, rtt=%lld\n",

base-commit: bcbddc4f9d020a4a0b881cc065729c3aaeb28098
-- 
2.34.1

