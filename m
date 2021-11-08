Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6673644A123
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240132AbhKIBHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:07:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:33368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239285AbhKIBFu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:05:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00E7161215;
        Tue,  9 Nov 2021 01:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419744;
        bh=qmmu+Z7ueqUZf2mPkdOMLMF8XFdHvd5LVBYbVFORez4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=STG5/kz9rHpukcs86Jq1iOo4S59iQ6cIxSb6S7oyYz+fng2trpGcWLme2dJJm8PQO
         SBmiwsz4q031KZxYl49PX/ahNiJdLHMbhwHnWGaoCTAy1xCAr7safF/Kl60oogsWKt
         5ozdd27b+31K4QoaM4c6ysUca14G8XCQA9P7xEYbu3kgsd5JwcBkUmjKCTiUOogyHn
         qCRFsAwCTHbYEBkDeJZb9Aocen5zENryOL5ZPs0qmcyQM4lqcf9zczqbnu1w0xWN/f
         X6fhtucXnqWSOg2al1REwBn8oRhbm2CkUi/YbElN5XkzMNyKN6Roke8AhivCB7m0F7
         Kt8tseyHjUXpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 023/138] mwifiex: Properly initialize private structure on interface type changes
Date:   Mon,  8 Nov 2021 12:44:49 -0500
Message-Id: <20211108174644.1187889-23-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonas Dreßler <verdre@v0yd.nl>

[ Upstream commit c606008b70627a2fc485732a53cc22f0f66d0981 ]

When creating a new virtual interface in mwifiex_add_virtual_intf(), we
update our internal driver states like bss_type, bss_priority, bss_role
and bss_mode to reflect the mode the firmware will be set to.

When switching virtual interface mode using
mwifiex_init_new_priv_params() though, we currently only update bss_mode
and bss_role. In order for the interface mode switch to actually work,
we also need to update bss_type to its proper value, so do that.

This fixes a crash of the firmware (because the driver tries to execute
commands that are invalid in AP mode) when switching from station mode
to AP mode.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210914195909.36035-9-verdre@v0yd.nl
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 93eb5f109949f..97f0f39364d67 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -908,16 +908,20 @@ mwifiex_init_new_priv_params(struct mwifiex_private *priv,
 	switch (type) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
-		priv->bss_role =  MWIFIEX_BSS_ROLE_STA;
+		priv->bss_role = MWIFIEX_BSS_ROLE_STA;
+		priv->bss_type = MWIFIEX_BSS_TYPE_STA;
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
-		priv->bss_role =  MWIFIEX_BSS_ROLE_STA;
+		priv->bss_role = MWIFIEX_BSS_ROLE_STA;
+		priv->bss_type = MWIFIEX_BSS_TYPE_P2P;
 		break;
 	case NL80211_IFTYPE_P2P_GO:
-		priv->bss_role =  MWIFIEX_BSS_ROLE_UAP;
+		priv->bss_role = MWIFIEX_BSS_ROLE_UAP;
+		priv->bss_type = MWIFIEX_BSS_TYPE_P2P;
 		break;
 	case NL80211_IFTYPE_AP:
 		priv->bss_role = MWIFIEX_BSS_ROLE_UAP;
+		priv->bss_type = MWIFIEX_BSS_TYPE_UAP;
 		break;
 	default:
 		mwifiex_dbg(adapter, ERROR,
-- 
2.33.0

