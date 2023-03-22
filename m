Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4616C55CA
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbjCVUA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbjCVT74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:59:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318385BC94;
        Wed, 22 Mar 2023 12:58:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E30B622B0;
        Wed, 22 Mar 2023 19:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B28C433AE;
        Wed, 22 Mar 2023 19:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515103;
        bh=isO0RvN70ZcuYch9J00VGEUvSaWqdMj2Ho5yc7Tft/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bgYai6hcrUYfZN91+8xcVhVqmmHFuSprVQDyfcSvuSncqHIdQeCaIz9WPqDI93peX
         BDivFBwRnC/Spv4VM6S/lAi73tyiVZKYeyhRIaTdwCNF/ggT6KSqJMc3W0d5apH4r5
         x5ByLbfqBs1eVf1BEBznO5746cT6jDDSRiYejzpXBQ08m4ZZr0dgvaHedXDaToGqsX
         pQDSx//wegPu9HE5AZV3r0QgHsDqOpvbyh8gX784TswEsDPBVr8z0RxBQnpguGbvyV
         wmLp3mymoRHBndk0eavpOJz8Bf1IHQSvbHkLnSScc2nuNKs0E3KqUKW4s7jsc2bdHv
         m6cVmCYCdr8yw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 21/45] wifi: mac80211: check basic rates validity
Date:   Wed, 22 Mar 2023 15:56:15 -0400
Message-Id: <20230322195639.1995821-21-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit ce04abc3fcc62cd5640af981ebfd7c4dc3bded28 ]

When userspace sets basic rates, it might send us some rates
list that's empty or consists of invalid values only. We're
currently ignoring invalid values and then may end up with a
rates bitmap that's empty, which later results in a warning.

Reject the call if there were no valid rates.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d611e15301839..e24d2d5b04ad0 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2576,6 +2576,17 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 	if (!sband)
 		return -EINVAL;
 
+	if (params->basic_rates) {
+		if (!ieee80211_parse_bitrates(link->conf->chandef.width,
+					      wiphy->bands[sband->band],
+					      params->basic_rates,
+					      params->basic_rates_len,
+					      &link->conf->basic_rates))
+			return -EINVAL;
+		changed |= BSS_CHANGED_BASIC_RATES;
+		ieee80211_check_rate_mask(link);
+	}
+
 	if (params->use_cts_prot >= 0) {
 		link->conf->use_cts_prot = params->use_cts_prot;
 		changed |= BSS_CHANGED_ERP_CTS_PROT;
@@ -2597,16 +2608,6 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 		changed |= BSS_CHANGED_ERP_SLOT;
 	}
 
-	if (params->basic_rates) {
-		ieee80211_parse_bitrates(link->conf->chandef.width,
-					 wiphy->bands[sband->band],
-					 params->basic_rates,
-					 params->basic_rates_len,
-					 &link->conf->basic_rates);
-		changed |= BSS_CHANGED_BASIC_RATES;
-		ieee80211_check_rate_mask(link);
-	}
-
 	if (params->ap_isolate >= 0) {
 		if (params->ap_isolate)
 			sdata->flags |= IEEE80211_SDATA_DONT_BRIDGE_PACKETS;
-- 
2.39.2

