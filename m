Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEBFF4943
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390340AbfKHLnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:43:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390304AbfKHLnC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:43:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7291C222C4;
        Fri,  8 Nov 2019 11:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213382;
        bh=mreQAMbZ+CpRVpcttSNGFJi8T0eMst7r9ESpUc40GFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ImhFU1t4pptf21yrOE8oX5int5JugckN4gBTiOb5fjQFwxIIUHVTsqRHPGWd7Cdgx
         HYUAkqAYal8+IgWmHHl1lv/LX/RcME9hEmcaUAdjQwhc8uqIG1ItNt5AfbPsC1dtKD
         pyNRIYJsKPzBjJd5IKcLhsXe4ghjwXufeAW1KAnY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 205/205] ath9k: Fix a locking bug in ath9k_add_interface()
Date:   Fri,  8 Nov 2019 06:37:52 -0500
Message-Id: <20191108113752.12502-205-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 461cf036057477805a8a391e5fd0f5264a5e56a8 ]

We tried to revert commit d9c52fd17cb4 ("ath9k: fix tx99 with monitor
mode interface") but accidentally missed part of the locking change.

The lock has to be held earlier so that we're holding it when we do
"sc->tx99_vif = vif;" and also there in the current code there is a
stray unlock before we have taken the lock.

Fixes: 6df0580be8bc ("ath9k: add back support for using active monitor interfaces for tx99")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c85f613e8ceb5..74f98bbaea889 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1251,6 +1251,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	struct ath_node *an = &avp->mcast_node;
 
+	mutex_lock(&sc->mutex);
 	if (IS_ENABLED(CONFIG_ATH9K_TX99)) {
 		if (sc->cur_chan->nvifs >= 1) {
 			mutex_unlock(&sc->mutex);
@@ -1259,8 +1260,6 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		sc->tx99_vif = vif;
 	}
 
-	mutex_lock(&sc->mutex);
-
 	ath_dbg(common, CONFIG, "Attach a VIF of type: %d\n", vif->type);
 	sc->cur_chan->nvifs++;
 
-- 
2.20.1

