Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C037652BA5C
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236570AbiERM3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236855AbiERM3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:29:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D76B190D26;
        Wed, 18 May 2022 05:28:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04B12B81FBD;
        Wed, 18 May 2022 12:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72645C385AA;
        Wed, 18 May 2022 12:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876881;
        bh=NOcKAOcWqu9x5L2iNzWHO089IBLx44Kt1k0BYvn8aJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ILaBd4MWRmgFmrBNX4hE+eb+ySZur0xDGSVEgj4b8SfVELviQfOP/qMOibjma9cC9
         +kWxyN4BO/EIYqx4zN+2cG8aH3nqOWZqSEW9nziruqIHoR/Sgem7+/wW3x5mjMIg75
         ZP0IiEZsAdhaiYtu3gipV/jBRoM3YaPVA7ziHm/fCZXEatiooWRry0uylQqowuSJJS
         lZz4c0qisTq7b8c4Bh6tMJOIk0Ai0d76tPrTcVRCD1Tc1aMBcT/dJnM8vmE8mi9D3g
         oDj3HUU2bwvczcZX8kcKsovPo0VNvQzROxBeSKz0MrXCtV5amW4XrmowHPTHF1wmZ9
         2Sb7TCx/rMhHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kieran Frewen <kieran.frewen@morsemicro.com>,
        Bassem Dawood <bassem@morsemicro.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 04/17] nl80211: validate S1G channel width
Date:   Wed, 18 May 2022 08:27:38 -0400
Message-Id: <20220518122753.342758-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122753.342758-1-sashal@kernel.org>
References: <20220518122753.342758-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kieran Frewen <kieran.frewen@morsemicro.com>

[ Upstream commit 5d087aa759eb82b8208411913f6c2158bd85abc0 ]

Validate the S1G channel width input by user to ensure it matches
that of the requested channel

Signed-off-by: Kieran Frewen <kieran.frewen@morsemicro.com>
Signed-off-by: Bassem Dawood <bassem@morsemicro.com>
Link: https://lore.kernel.org/r/20220420041321.3788789-2-kieran.frewen@morsemicro.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fe9cade6b4fb..9fae09e860e1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3080,6 +3080,15 @@ int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 	} else if (attrs[NL80211_ATTR_CHANNEL_WIDTH]) {
 		chandef->width =
 			nla_get_u32(attrs[NL80211_ATTR_CHANNEL_WIDTH]);
+		if (chandef->chan->band == NL80211_BAND_S1GHZ) {
+			/* User input error for channel width doesn't match channel  */
+			if (chandef->width != ieee80211_s1g_channel_width(chandef->chan)) {
+				NL_SET_ERR_MSG_ATTR(extack,
+						    attrs[NL80211_ATTR_CHANNEL_WIDTH],
+						    "bad channel width");
+				return -EINVAL;
+			}
+		}
 		if (attrs[NL80211_ATTR_CENTER_FREQ1]) {
 			chandef->center_freq1 =
 				nla_get_u32(attrs[NL80211_ATTR_CENTER_FREQ1]);
-- 
2.35.1

