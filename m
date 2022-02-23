Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFDE4C094B
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237656AbiBWCjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237726AbiBWCh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:37:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EE45D640;
        Tue, 22 Feb 2022 18:32:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99C33B81E0F;
        Wed, 23 Feb 2022 02:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3182EC340E8;
        Wed, 23 Feb 2022 02:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583556;
        bh=wT/OAu37EqYZIJyAlH+JSI0vsA40Aomyp+lsmvaj4WE=;
        h=From:To:Cc:Subject:Date:From;
        b=MglWc/Qcltxs/kDg6q69JZYfRgh4H5VpcjPNmpcd3LNwM0m359C2EG4e/KrZlezw3
         2Xpdgj3WSjKBcMbDeueMuS9/DZc5dxa/qf6atBaJL8JAsbV8EtemVbfnjWc/YRUNll
         GuiqkCqWKwevVOO7VTRbnR8NHQ2pMnlaUlHJ0iZMkyem69DE+88WWUqv2Rsovbhv50
         QIHWUeiPKmWG8sPDnNpdZfqZksD/zM8IHJb6bNDihIkUi9YHJp15r18/lnX/Dyq7RB
         Z7Osd/oYLMoLDzt+nQZflztpXDsjtPDTFSSykUk83y+ZUR8XyBwmWujuI5onIFxhFU
         cmE/mRA+lEqRQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Beichler <benjamin.beichler@uni-rostock.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/10] mac80211_hwsim: report NOACK frames in tx_status
Date:   Tue, 22 Feb 2022 21:32:24 -0500
Message-Id: <20220223023233.242468-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
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

From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>

[ Upstream commit 42a79960ffa50bfe9e0bf5d6280be89bf563a5dd ]

Add IEEE80211_TX_STAT_NOACK_TRANSMITTED to tx_status flags to have proper
statistics for non-acked frames.

Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Link: https://lore.kernel.org/r/20220111221327.1499881-1-benjamin.beichler@uni-rostock.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index a8ec5b2c5abb3..b19d19c4be272 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2983,6 +2983,10 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 		}
 		txi->flags |= IEEE80211_TX_STAT_ACK;
 	}
+
+	if (hwsim_flags & HWSIM_TX_CTL_NO_ACK)
+		txi->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
+
 	ieee80211_tx_status_irqsafe(data2->hw, skb);
 	return 0;
 out:
-- 
2.34.1

