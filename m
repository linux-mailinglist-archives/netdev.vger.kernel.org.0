Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D43F4C0829
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237051AbiBWCbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237037AbiBWCab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:30:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049DE57B35;
        Tue, 22 Feb 2022 18:29:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA9F2B81E15;
        Wed, 23 Feb 2022 02:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587DAC340EB;
        Wed, 23 Feb 2022 02:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583374;
        bh=S7UFBE1M6W1pYJfWfX3QTKA9zcn2mP6wX1gDD703PA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQUflzN9/UgZOJ4rrXkEtnBn0sM55SZ+SmScRSufJrl0YD+NoXuqV9UJXWqXR3t5N
         Eagzkq45DdCRBwMep2sTvNBq61lV3+MdwjW73guSNfs2VQ/hfy9yosBmChrFJ7YK4M
         yYJsZZQtuWdC8cUR6XeTdiOOfI1Eg8Fr5VkllHR6ajPqich0rlXh7FlI+GRssYPqTb
         ByfhI2GwQDHoGreoF0CNRiij8QRXzxVFhjsWpISQlGGRBLV4P1VnYSjAGmlfl+BTVp
         xhzNLBjh+AfajQH0tBTZQ2mdX2fiqDzlSYhEhp6oHLv6Zq4fnQr39TOxM/vekmVKPk
         ffVDtJU9ABFTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     JaeMan Park <jaeman@google.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 02/28] mac80211_hwsim: initialize ieee80211_tx_info at hw_scan_work
Date:   Tue, 22 Feb 2022 21:29:03 -0500
Message-Id: <20220223022929.241127-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022929.241127-1-sashal@kernel.org>
References: <20220223022929.241127-1-sashal@kernel.org>
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
index 52f13afb7cba2..0aeb1e1ec93ff 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2336,6 +2336,15 @@ static void hw_scan_work(struct work_struct *work)
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

