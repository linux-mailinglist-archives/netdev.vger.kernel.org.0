Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821094EF633
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244776AbiDAPbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 11:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349367AbiDAOzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:55:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EA0218D;
        Fri,  1 Apr 2022 07:43:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1082D60A53;
        Fri,  1 Apr 2022 14:43:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB5FC34111;
        Fri,  1 Apr 2022 14:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824208;
        bh=YN8rVKoHJkwn//O4wWKc+RyuqsBXXq+JWURZufff5jU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIpYNBflJ+e+bQoLN/uCLUCbIJwgqWRmrlg2iSkIVKw/x9jSgVOeTjzpHsWbFR8U/
         xPujiQjUANMt4CywhikSG6p1j3VbYCAOfLtyw6VY+/zTd2mn0yxzLeEANDAA19kIDr
         XYAmQIlCeDoLZyqdZ6qAP+DSSLYYvo5L4CKujiyruhwgVhFX40x5HkOBHuTM05nboW
         zT+HVMfk7h15wwmg+ZPclESEDt00HJ4B51PaAENxaqPUYKstod9oKB7xRZeNDvv8i9
         ++fsPCoCezKSj6L8mpOvsLsuCWYD1U2KNoBrl3hfiOqpyIvvOZFYsBBEuIKd+vJOJk
         vT4/G5Z9CCxgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        johannes.berg@intel.com, avraham.stern@intel.com,
        ayala.beker@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 28/65] iwlwifi: mvm: Correctly set fragmented EBS
Date:   Fri,  1 Apr 2022 10:41:29 -0400
Message-Id: <20220401144206.1953700-28-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144206.1953700-1-sashal@kernel.org>
References: <20220401144206.1953700-1-sashal@kernel.org>
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
index 46255d2c555b..17b992526694 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1706,7 +1706,10 @@ static u8 iwl_mvm_scan_umac_chan_flags_v2(struct iwl_mvm *mvm,
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

