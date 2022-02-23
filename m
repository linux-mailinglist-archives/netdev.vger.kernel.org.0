Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CE64C0843
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237109AbiBWCbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236987AbiBWCaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:30:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACF33DDF7;
        Tue, 22 Feb 2022 18:29:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 626D361526;
        Wed, 23 Feb 2022 02:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA59C340E8;
        Wed, 23 Feb 2022 02:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583372;
        bh=OKUJ1VFByJYAVz6NAr0y42oP8C8o9h3GY4OVSvu1guQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ichZU6j43LatyNWYKTD0ONUyZ3+kAxYDHFCHMlDP3zi+UjUlfEamt31oC9qBV4U5F
         6QxlPyqfC+u837bM+q3KHCLILLEMSaBLsQRfQnQct2h/OtA64cVL75yO80sfvCPsOo
         AbcDkfW6OZygexTObOmgb2LQdu8dEhzNPWgCDoKCV1+hj/7rHm12YKAoxrXck0Bdfj
         FsU1J63WjTHqwmK0UM2qDwNyJpPd/k58UFZ/J5xV9zJPn2QU0AwdB4rICyXZxRAO/O
         wlHTTuBrAEzj4XG5zP/G8Gkut+CgbEd9i4vFI8GBEN1I3C/A/1QcVVfWuNKQdV13x0
         cZT9piP26dfug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Beichler <benjamin.beichler@uni-rostock.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 01/28] mac80211_hwsim: report NOACK frames in tx_status
Date:   Tue, 22 Feb 2022 21:29:02 -0500
Message-Id: <20220223022929.241127-1-sashal@kernel.org>
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
index 0adae76eb8df1..52f13afb7cba2 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3641,6 +3641,10 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
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

