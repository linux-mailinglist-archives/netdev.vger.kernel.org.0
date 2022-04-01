Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818114EF2FC
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349247AbiDAOxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352003AbiDAOtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:49:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0E92921D8;
        Fri,  1 Apr 2022 07:40:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6EC160F45;
        Fri,  1 Apr 2022 14:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0067C340EE;
        Fri,  1 Apr 2022 14:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823993;
        bh=ShIbz5D6etsQykHUhqT6fpOp603dfdsMYZIsh77iAQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HzBKUc0Wr4AUlE4hJ9o6SsGkd9Rz3/1AOeyank+bCoXuhNMZBv2QoY8wL42p8Onr2
         jwXq38VHt4zJGTV+XX2iBvHzm/acm5KL/dSWJTkZsCg8W39nt+dzcOr5hjg3QQGWYV
         Xfp+AMPKimfFCwm6X268TVCMdRzorTdR0Y06SiBXhcmBnVzHMUr+KxEec74KK9gcbj
         SJuLIbQXYwKAgQYHWwzMa6j+uwJXzsSodJbf1+yT1G7RV2mQgexI97bzBcbwQddmBR
         kIi38V6IxmYT/kX31+nq0aiK94qOlmIAcNVa2D/kebMKsDkUjvQ9oSoTojOhlcCPgQ
         L9MrTkPtqes6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        johannes.berg@intel.com, ayala.beker@intel.com,
        avraham.stern@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 44/98] iwlwifi: mvm: Correctly set fragmented EBS
Date:   Fri,  1 Apr 2022 10:36:48 -0400
Message-Id: <20220401143742.1952163-44-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit d8d4dd26b9e0469baf5017f0544d852fd4e3fb6d ]

Currently, fragmented EBS was set for a channel only if the 'hb_type'
was set to fragmented or balanced scan. However, 'hb_type' is set only
in case of CDB, and thus fragmented EBS is never set for a channel for
non-CDB devices. Fix it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20220204122220.a6165ac9b9d5.I654eafa62fd647030ae6d4f07f32c96c3171decb@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 5461bf399959..65e382756de6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1890,7 +1890,10 @@ static u8 iwl_mvm_scan_umac_chan_flags_v2(struct iwl_mvm *mvm,
 			IWL_SCAN_CHANNEL_FLAG_CACHE_ADD;
 
 	/* set fragmented ebs for fragmented scan on HB channels */
-	if (iwl_mvm_is_scan_fragmented(params->hb_type))
+	if ((!iwl_mvm_is_cdb_supported(mvm) &&
+	     iwl_mvm_is_scan_fragmented(params->type)) ||
+	    (iwl_mvm_is_cdb_supported(mvm) &&
+	     iwl_mvm_is_scan_fragmented(params->hb_type)))
 		flags |= IWL_SCAN_CHANNEL_FLAG_EBS_FRAG;
 
 	return flags;
-- 
2.34.1

