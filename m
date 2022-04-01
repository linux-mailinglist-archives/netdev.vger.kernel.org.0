Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66E34EF3B3
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244504AbiDAOwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349443AbiDAOp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:45:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B719729B7F1;
        Fri,  1 Apr 2022 07:36:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28F88B82518;
        Fri,  1 Apr 2022 14:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673F9C2BBE4;
        Fri,  1 Apr 2022 14:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823726;
        bh=4e8UqcVtt2bDl/TcYTWbp0P7wBjX17psqcDRy4Jt0OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVXh5rLA34WHCJFd72sEetXfE+zOwa2ROZa7dRvbXcsiqXLvyU2mxAwkm4mBrAWTQ
         PsWIWWfpcsB46NBgjezTDv5bs+DL0LQfMXCeQvXpgvdS9GW3/TU8Ho8OSG9X7iuXlU
         PG2VnNrKFBIWdDjqFeyS5Juc26RIfxXRd0sP0FgCk1WaNZdj0gHFQMps5dwV6ucgxR
         CbLjYnIN3GLhzLktd3NA/4xvpNnVENzexkMoA54ihQ3FllJ7wNi9pAk3Jv5CmmZRiS
         ggyEPwhe82qEURl5uDX7UnryQbsw0v3S+MHqFg40oB8G3nOG6EUUg1mkJce9syf8Qv
         jYw5w8qpIX76A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        johannes.berg@intel.com, ayala.beker@intel.com,
        avraham.stern@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 053/109] iwlwifi: mvm: Correctly set fragmented EBS
Date:   Fri,  1 Apr 2022 10:32:00 -0400
Message-Id: <20220401143256.1950537-53-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
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
index 960b21719b80..e3eefc55beaf 100644
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

