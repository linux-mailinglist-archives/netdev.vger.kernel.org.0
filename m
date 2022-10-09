Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43AE95F8F97
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbiJIWKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbiJIWJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:09:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F6327FEF;
        Sun,  9 Oct 2022 15:08:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BD3BB80D33;
        Sun,  9 Oct 2022 22:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFF2C433C1;
        Sun,  9 Oct 2022 22:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353319;
        bh=Xim9L/6MPKHhWk02mKah4Xtxj3kEHWu7BLH/sjQAW/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AyZwzTtXeVbSt0tb/dX6tm+j68cgOwdH6ze06O3Skk0rwvqlyIjBRKmJtlknLzCk/
         yKIF54sX7fLHffEobcRjtTBzRtAij9L9kKOl1ui80xyY886zOh0lQIeYcD7UZaM1us
         7nAG68tTKms9nMTT+THZ4kOQWlNnEGCpRZJqAiK+aiApetrX7ZsXSBDxtuwCO6NDbr
         pYbPMOswqhIF3+HP2+gBXazzYzaeL8TLLgF/abdCQ7r2FfNfdvH7WiwSvOKEBzcQSu
         63MGIceyaCMZb997j96+ap75TB9eIUwI3PO90aW/B3wZgtd6yFZ0HSoxqZkqNWFZkd
         lv575a5TgHFkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 16/77] wifi: mac80211: fix control port frame addressing
Date:   Sun,  9 Oct 2022 18:06:53 -0400
Message-Id: <20221009220754.1214186-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a6ba64d0b187109dc252969c1fc9e2525868bd49 ]

For an AP interface, when userspace specifieds the link ID to
transmit the control port frame on (in particular for the
initial 4-way-HS), due to the logic in ieee80211_build_hdr()
for a frame transmitted from/to an MLD, we currently build a
header with

 A1 = DA = MLD address of the peer MLD
 A2 = local link address (!)
 A3 = SA = local MLD address

This clearly makes no sense, and leads to two problems:
 - if the frame were encrypted (not true for the initial
   4-way-HS) the AAD would be calculated incorrectly
 - if iTXQs are used, the frame is dropped by logic in
   ieee80211_tx_dequeue()

Fix the addressing, which fixes the first bullet, and the
second bullet for peer MLDs, I'll fix the second one for
non-MLD peers separately.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 13249e97a069..af7286617e46 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2640,7 +2640,8 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 				goto free;
 			}
 			memcpy(hdr.addr2, link->conf->addr, ETH_ALEN);
-		} else if (link_id == IEEE80211_LINK_UNSPECIFIED) {
+		} else if (link_id == IEEE80211_LINK_UNSPECIFIED ||
+			   (sta && sta->sta.mlo)) {
 			memcpy(hdr.addr2, sdata->vif.addr, ETH_ALEN);
 		} else {
 			struct ieee80211_bss_conf *conf;
-- 
2.35.1

