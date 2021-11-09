Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9724644A28F
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243015AbhKIBTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:19:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242396AbhKIBRX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:17:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A6A261AFB;
        Tue,  9 Nov 2021 01:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420028;
        bh=fUGXu9XiCLQlNUs3S91utdZvZpz/jZEZ4cd17L50V2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+fEtnJuRH1O1LPW65X8z60v5gFR4RtZZk7x9c26lScZqm4fZMJKXwpvAO1XRsRIm
         UnIrCBE9gIQc9YVD82uJ7O6gffoMgnYF+dQoDrvnOJIMXCGJ3HnWky3RhI/rcnQsf4
         EvPclwmQNYyj83R4GhZrKB+yI6XtLO1e7MhD91v8aTgjRru9n7JUqNUPzHzSt1FXhE
         3kcqS8gWZ1TFjTHSc3pkz2UsTxkTyWoiKaj+uhlpWJl4MFVmg+VsnxTCrciCivlUFb
         4MsL5a1REI7uIG8zBSznX++Nw/BQ+Es86/FYZeB7UgoPPGzEGfdbdZIVJMKOBQngg8
         kOdK1CnGteHQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 10/39] mwifiex: Run SET_BSS_MODE when changing from P2P to STATION vif-type
Date:   Mon,  8 Nov 2021 20:06:20 -0500
Message-Id: <20211109010649.1191041-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010649.1191041-1-sashal@kernel.org>
References: <20211109010649.1191041-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonas Dreßler <verdre@v0yd.nl>

[ Upstream commit c2e9666cdffd347460a2b17988db4cfaf2a68fb9 ]

We currently handle changing from the P2P to the STATION virtual
interface type slightly different than changing from P2P to ADHOC: When
changing to STATION, we don't send the SET_BSS_MODE command. We do send
that command on all other type-changes though, and it probably makes
sense to send the command since after all we just changed our BSS_MODE.
Looking at prior changes to this part of the code, it seems that this is
simply a leftover from old refactorings.

Since sending the SET_BSS_MODE command is the only difference between
mwifiex_change_vif_to_sta_adhoc() and the current code, we can now use
mwifiex_change_vif_to_sta_adhoc() for both switching to ADHOC and
STATION interface type.

This does not fix any particular bug and just "looked right", so there's
a small chance it might be a regression.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210914195909.36035-4-verdre@v0yd.nl
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/marvell/mwifiex/cfg80211.c   | 22 ++++---------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 79c50aebffc4b..7bdcbe79d963d 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1217,29 +1217,15 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
+		if (mwifiex_cfg80211_deinit_p2p(priv))
+			return -EFAULT;
+
 		switch (type) {
-		case NL80211_IFTYPE_STATION:
-			if (mwifiex_cfg80211_deinit_p2p(priv))
-				return -EFAULT;
-			priv->adapter->curr_iface_comb.p2p_intf--;
-			priv->adapter->curr_iface_comb.sta_intf++;
-			dev->ieee80211_ptr->iftype = type;
-			if (mwifiex_deinit_priv_params(priv))
-				return -1;
-			if (mwifiex_init_new_priv_params(priv, dev, type))
-				return -1;
-			if (mwifiex_sta_init_cmd(priv, false, false))
-				return -1;
-			break;
 		case NL80211_IFTYPE_ADHOC:
-			if (mwifiex_cfg80211_deinit_p2p(priv))
-				return -EFAULT;
+		case NL80211_IFTYPE_STATION:
 			return mwifiex_change_vif_to_sta_adhoc(dev, curr_iftype,
 							       type, params);
-			break;
 		case NL80211_IFTYPE_AP:
-			if (mwifiex_cfg80211_deinit_p2p(priv))
-				return -EFAULT;
 			return mwifiex_change_vif_to_ap(dev, curr_iftype, type,
 							params);
 		case NL80211_IFTYPE_UNSPECIFIED:
-- 
2.33.0

