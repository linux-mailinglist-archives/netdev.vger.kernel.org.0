Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02E15F2627
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 00:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiJBWus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 18:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiJBWuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 18:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF7E12AA9;
        Sun,  2 Oct 2022 15:49:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8257DB80C81;
        Sun,  2 Oct 2022 22:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1294C433D6;
        Sun,  2 Oct 2022 22:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664750990;
        bh=gpOnnvA5lUNI+eY1xaaT6VEeXv2MgeShuAunf5+0rGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qewm4/xqfEPtYHsGxPusWl6UpxkBCarRDCbyjPSr3IREhY3GnhoSCabYets85fkeS
         halHqrygkAtqYagTY/CryDm5kbHi0FMj2lRRO1APMQy5dyEb1t8A0NdWpNBJ+V/hoD
         d2MqgCEzzngc8oAtlpya2uYlf+M12E4ZtEuPupEVKPpmupnxNxTl0/jkwuG/lcAz5M
         PLz31NORZCvwzxu+Ozv5vB9+RsTFedZ5T2Jenn7+70BcpseMlXpFRMeNmXu8hSjqsB
         rbJUb9DgA2Vwmby+v6o5G2HZe1Lep7K2Wg+IjixfFbP20FOdmeYcLjDvwLShh0rcjW
         r7RdaRxh5fHcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        gregory.greenman@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        luciano.coelho@intel.com, emmanuel.grumbach@intel.com,
        miriam.rachel.korenblit@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 09/29] wifi: iwlwifi: don't spam logs with NSS>2 messages
Date:   Sun,  2 Oct 2022 18:49:02 -0400
Message-Id: <20221002224922.238837-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002224922.238837-1-sashal@kernel.org>
References: <20221002224922.238837-1-sashal@kernel.org>
MIME-Version: 1.0
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 4d8421f2dd88583cc7a4d6c2a5532c35e816a52a ]

I get a log line like this every 4 seconds when connected to my AP:

[15650.221468] iwlwifi 0000:09:00.0: Got NSS = 4 - trimming to 2

Looking at the code, this seems to be related to a hardware limitation,
and there's nothing to be done. In an effort to keep my dmesg
manageable, downgrade this error to "debug" rather than "info".

Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220905172246.105383-1-Jason@zx2c4.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index c5626ff83805..640e3786c244 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1833,8 +1833,8 @@ static void iwl_mvm_parse_ppe(struct iwl_mvm *mvm,
 	* If nss < MAX: we can set zeros in other streams
 	*/
 	if (nss > MAX_HE_SUPP_NSS) {
-		IWL_INFO(mvm, "Got NSS = %d - trimming to %d\n", nss,
-			 MAX_HE_SUPP_NSS);
+		IWL_DEBUG_INFO(mvm, "Got NSS = %d - trimming to %d\n", nss,
+			       MAX_HE_SUPP_NSS);
 		nss = MAX_HE_SUPP_NSS;
 	}
 
-- 
2.35.1

