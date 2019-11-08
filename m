Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBCFCF4AAC
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387473AbfKHLj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:39:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:52384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387396AbfKHLj0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:39:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A599D21D7E;
        Fri,  8 Nov 2019 11:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213165;
        bh=ZPSKGSZEulSokc6OQ6g3QxfBYvIV5a0XHwF8ROZCzws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G76pBEJH3zlNtGtfwcBqJRch4iVm00H2UX5TxEHvmswglGUXVMItC00zT+Qfslf7k
         XPwJcXHS5Yqou9YeKtzZasfUa0IBR+oKd3/8UzMZ5OoJWWHx9GJuhcGw6K3+tlyk0n
         uwt2QOQp8XafnZ7gxHa1rLZX+qqYPcs4Lq0RMbM0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 068/205] mt76: Fix comparisons with invalid hardware key index
Date:   Fri,  8 Nov 2019 06:35:35 -0500
Message-Id: <20191108113752.12502-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 81c8eccc2404d06082025b773f1d90e8c861bc6a ]

With gcc 4.1.2:

    drivers/net/wireless/mediatek/mt76/mt76x0/tx.c: In function ‘mt76x0_tx’:
    drivers/net/wireless/mediatek/mt76/mt76x0/tx.c:169: warning: comparison is always true due to limited range of data type
    drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c: In function ‘mt76x2_tx’:
    drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c:35: warning: comparison is always true due to limited range of data type

While assigning -1 to a u8 works fine, comparing with -1 does not work
as expected.

Fix this by comparing with 0xff, like is already done in some other
places.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c        | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index 751b49c28ae53..c45d05d5aab1d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -166,7 +166,7 @@ void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	if (sta) {
 		msta = (struct mt76_sta *) sta->drv_priv;
 		wcid = &msta->wcid;
-	} else if (vif && (!info->control.hw_key && wcid->hw_key_idx != -1)) {
+	} else if (vif && (!info->control.hw_key && wcid->hw_key_idx != 0xff)) {
 		struct mt76_vif *mvif = (struct mt76_vif *)vif->drv_priv;
 
 		wcid = &mvif->group_wcid;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
index 36afb166fa3ff..c0ca0df84ed8b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
@@ -32,7 +32,7 @@ void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		msta = (struct mt76x2_sta *)control->sta->drv_priv;
 		wcid = &msta->wcid;
 		/* sw encrypted frames */
-		if (!info->control.hw_key && wcid->hw_key_idx != -1)
+		if (!info->control.hw_key && wcid->hw_key_idx != 0xff)
 			control->sta = NULL;
 	}
 
-- 
2.20.1

