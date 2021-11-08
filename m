Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5AC044A210
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243442AbhKIBQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:16:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:39718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242614AbhKIBNz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:13:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B334761ABF;
        Tue,  9 Nov 2021 01:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419941;
        bh=yJpfEgi86xUwzEv0QSvB5hQZIBPmSZ3laHF0izDcRlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eJVfruL7tT6TsepsVSioicYK+2SjfZt7u+vkgKOINPzONfAWGo5hy4XyU/q4FA6zm
         1EZV5KFGWvrrGueDaHRCi7fd2LZ2M/DWGuh2Wi+JtyG5r3mSXKrBVXH2+DxheFXyc9
         KyCeXh2wcuHzH+LxkbCHGWU+sOaZYMP9XWP1stYnUAM79f47SUfzbFqWudZMJT6H9G
         NUNs9VKW+1RmqgXlPLdWhSFJhDkpoOelLF60Ec1uxwh3+AAlLAcrPosrbOa/m/DwT0
         HDAen9imThb6sONVkvXUwgGXgkvU56dLtxtGz0IxadSUi087uVQ2B/+YQKZsk0fP9U
         0oDvxS0pzHgkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/47] mwifiex: Properly initialize private structure on interface type changes
Date:   Mon,  8 Nov 2021 12:49:57 -0500
Message-Id: <20211108175031.1190422-13-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
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
index becde7c254de2..892247145f428 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -912,16 +912,20 @@ mwifiex_init_new_priv_params(struct mwifiex_private *priv,
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

