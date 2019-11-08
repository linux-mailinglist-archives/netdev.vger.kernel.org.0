Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7F1F4848
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 12:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403777AbfKHLpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:45:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391164AbfKHLpl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:45:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EFBE222CE;
        Fri,  8 Nov 2019 11:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213541;
        bh=pfDF5o5Sf/FZB9G8qxf3rgn8Br81z+BJhC63kU1YSUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/2QZ7ZbAbUydp58vca/fHD3MBvVKw41NWzCPoT9hBEx+6OkddhXkW+tKlUktsz+l
         00k0Jc0XuxFLwZryE7vpeLnwJQeR8Fzn1QLsRrCKsEeyVIt1wZcQjXSIebfVb5vzeE
         QvD8ZfY/JPFJpVf83EHAf18OY8tSD9cHs2IY2uP4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 103/103] ath9k: Fix a locking bug in ath9k_add_interface()
Date:   Fri,  8 Nov 2019 06:43:08 -0500
Message-Id: <20191108114310.14363-103-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
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
index 3589f1f3e744d..72ad84fde5c18 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1250,6 +1250,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	struct ath_node *an = &avp->mcast_node;
 
+	mutex_lock(&sc->mutex);
 	if (IS_ENABLED(CONFIG_ATH9K_TX99)) {
 		if (sc->cur_chan->nvifs >= 1) {
 			mutex_unlock(&sc->mutex);
@@ -1258,8 +1259,6 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		sc->tx99_vif = vif;
 	}
 
-	mutex_lock(&sc->mutex);
-
 	ath_dbg(common, CONFIG, "Attach a VIF of type: %d\n", vif->type);
 	sc->cur_chan->nvifs++;
 
-- 
2.20.1

