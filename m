Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D186A52B9F1
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236943AbiERMcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237012AbiERMbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:31:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4983819C743;
        Wed, 18 May 2022 05:28:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A4C2616A4;
        Wed, 18 May 2022 12:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104B4C36AE5;
        Wed, 18 May 2022 12:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876936;
        bh=/r6wJWqx/YH3mr4hvjPSEsqqM3Us8PleY8Agi7vVwo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVlLSEO7rtorsI/xkdLaZpesdEqOxeN4+e+VoqcO3FQgpY2jBdGaiO2ntHVdbll89
         DHPfJ3M9DKpakAsWvJ3Aq7UUaMIpFfidsJURVy39pgWcoFJkrEtKmkMUJJNtY8Ugl4
         xOfRr7t/BSjIkMEKCcQxdH62jjUu4mhLV1ZDKPxVzJ1k9paDZoycyO9UGjjW0eSZK+
         fapT4RM7VOEqCitZf2aB9V6nFabn7xDcDuydRcIdZsrVas585lbLek9KRM4WMjc6SD
         3PBAkteNFKP6SugoxDh4sG7YTXbwScuP37LElSo12TsH/d1ba9sNyeN6gFoZ8m8w5+
         g3bGXgVOhqfDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kieran Frewen <kieran.frewen@morsemicro.com>,
        Bassem Dawood <bassem@morsemicro.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/13] nl80211: validate S1G channel width
Date:   Wed, 18 May 2022 08:28:34 -0400
Message-Id: <20220518122844.343220-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122844.343220-1-sashal@kernel.org>
References: <20220518122844.343220-1-sashal@kernel.org>
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
index 12f44ad4e0d8..283447df5fc6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2955,6 +2955,15 @@ int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
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

