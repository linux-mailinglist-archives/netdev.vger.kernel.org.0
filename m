Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BC44C0958
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237703AbiBWCjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237607AbiBWChQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:37:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF10D5FF3E;
        Tue, 22 Feb 2022 18:32:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2762D61516;
        Wed, 23 Feb 2022 02:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7ABC340F8;
        Wed, 23 Feb 2022 02:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583517;
        bh=i5VHI7JTDFpPs3+CFF91y+xv8PC264aoBXGF5EYIqL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XeP2148SqWlbTeDBYMrPb4Mg6SfyCWcSKzH0klsyqls8cAbCS3AQrOrpju+dmF77O
         QyKhzoLUI1qT8k2TiM76MoengcXyu5PwUZ1B67nXjwmoa2frPJftWgdT3iJv4AwAvZ
         VAxNuQ4fJtORTAaD/NlniFvLLGKfAU1A7rHLZfPmCCNFJyUSVLmKx/sYyclxJv9kx1
         upQutZXOhKTI5f9WoGTf/kt8cyfOsTbBtBFoOc+daqoBN+JhRPlAv0nIIy81zVIs9p
         5iBycSipUscCkFvzqBeUJayMj15YwRkxa+1fpYhKt3fuCofIErSiTvTOJklnhhml3U
         3KFgNwIio0WIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     JaeMan Park <jaeman@google.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/13] mac80211_hwsim: initialize ieee80211_tx_info at hw_scan_work
Date:   Tue, 22 Feb 2022 21:31:41 -0500
Message-Id: <20220223023152.242065-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223023152.242065-1-sashal@kernel.org>
References: <20220223023152.242065-1-sashal@kernel.org>
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

From: JaeMan Park <jaeman@google.com>

[ Upstream commit cacfddf82baf1470e5741edeecb187260868f195 ]

In mac80211_hwsim, the probe_req frame is created and sent while
scanning. It is sent with ieee80211_tx_info which is not initialized.
Uninitialized ieee80211_tx_info can cause problems when using
mac80211_hwsim with wmediumd. wmediumd checks the tx_rates field of
ieee80211_tx_info and doesn't relay probe_req frame to other clients
even if it is a broadcasting message.

Call ieee80211_tx_prepare_skb() to initialize ieee80211_tx_info for
the probe_req that is created by hw_scan_work in mac80211_hwsim.

Signed-off-by: JaeMan Park <jaeman@google.com>
Link: https://lore.kernel.org/r/20220113060235.546107-1-jaeman@google.com
[fix memory leak]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 6cd9a8b610107..c84ee5ba53812 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2082,6 +2082,15 @@ static void hw_scan_work(struct work_struct *work)
 			if (req->ie_len)
 				skb_put_data(probe, req->ie, req->ie_len);
 
+			if (!ieee80211_tx_prepare_skb(hwsim->hw,
+						      hwsim->hw_scan_vif,
+						      probe,
+						      hwsim->tmp_chan->band,
+						      NULL)) {
+				kfree_skb(probe);
+				continue;
+			}
+
 			local_bh_disable();
 			mac80211_hwsim_tx_frame(hwsim->hw, probe,
 						hwsim->tmp_chan);
-- 
2.34.1

