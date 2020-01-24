Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD2D414879F
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392439AbgAXOYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:24:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392315AbgAXOWP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:22:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D385F21734;
        Fri, 24 Jan 2020 14:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875734;
        bh=mHQFP/vtoC7Zz+C7h04SYqUhhYKg5fKVuKYZAuh6FrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFV7JeKyrtU2z4HnwrMjO8aQNHACLJOh2IpEEiz2GK8WgbdNDRHfFXieRZe4vKyxm
         pr6C/DpwXttR+C5v9zH3y0Ep2eX5ewRSQkIWFAAXIFuKL66wARTS2Sk6scrWHxRrx2
         jz6IOMHmxQzBpXOcU+T8qR7tOxTmWqB66MtXhSb8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Cathy Luo <xiaohua.luo@nxp.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 13/18] wireless: fix enabling channel 12 for custom regulatory domain
Date:   Fri, 24 Jan 2020 09:21:52 -0500
Message-Id: <20200124142157.30931-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142157.30931-1-sashal@kernel.org>
References: <20200124142157.30931-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ganapathi Bhat <ganapathi.bhat@nxp.com>

[ Upstream commit c4b9d655e445a8be0bff624aedea190606b5ebbc ]

Commit e33e2241e272 ("Revert "cfg80211: Use 5MHz bandwidth by
default when checking usable channels"") fixed a broken
regulatory (leaving channel 12 open for AP where not permitted).
Apply a similar fix to custom regulatory domain processing.

Signed-off-by: Cathy Luo <xiaohua.luo@nxp.com>
Signed-off-by: Ganapathi Bhat <ganapathi.bhat@nxp.com>
Link: https://lore.kernel.org/r/1576836859-8945-1-git-send-email-ganapathi.bhat@nxp.com
[reword commit message, fix coding style, add a comment]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index dde741f298de7..0e66768427ba7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1715,14 +1715,15 @@ static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
 
 static void handle_channel_custom(struct wiphy *wiphy,
 				  struct ieee80211_channel *chan,
-				  const struct ieee80211_regdomain *regd)
+				  const struct ieee80211_regdomain *regd,
+				  u32 min_bw)
 {
 	u32 bw_flags = 0;
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
 	u32 bw;
 
-	for (bw = MHZ_TO_KHZ(20); bw >= MHZ_TO_KHZ(5); bw = bw / 2) {
+	for (bw = MHZ_TO_KHZ(20); bw >= min_bw; bw = bw / 2) {
 		reg_rule = freq_reg_info_regd(MHZ_TO_KHZ(chan->center_freq),
 					      regd, bw);
 		if (!IS_ERR(reg_rule))
@@ -1778,8 +1779,14 @@ static void handle_band_custom(struct wiphy *wiphy,
 	if (!sband)
 		return;
 
+	/*
+	 * We currently assume that you always want at least 20 MHz,
+	 * otherwise channel 12 might get enabled if this rule is
+	 * compatible to US, which permits 2402 - 2472 MHz.
+	 */
 	for (i = 0; i < sband->n_channels; i++)
-		handle_channel_custom(wiphy, &sband->channels[i], regd);
+		handle_channel_custom(wiphy, &sband->channels[i], regd,
+				      MHZ_TO_KHZ(20));
 }
 
 /* Used by drivers prior to wiphy registration */
-- 
2.20.1

