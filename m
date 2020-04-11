Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1951A5485
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgDKXF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:05:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727960AbgDKXF1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:05:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6FB621775;
        Sat, 11 Apr 2020 23:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646327;
        bh=F3GZCkfuTpePzhtk5oZ3eLfLVs1Pby/rMwXEm7QXV5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yx9ZoW5XKlp3kQ9dr73o/7Zb1u7Cfv7k1X37Q0S86qAo1/r+El0RRmOknokJ151IR
         v23xtAI8jBmNbhV2fCfo+3BJTSuKV29HX9B3SNMrmx/mKkCVauWxnmeGjdkvkPylxs
         /eOqSzuY4c3BlfUUUOcHuIOZ84JjK4d15DsVWwbE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Kepplinger <martin.kepplinger@puri.sm>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 080/149] rsi: fix null pointer dereference during rsi_shutdown()
Date:   Sat, 11 Apr 2020 19:02:37 -0400
Message-Id: <20200411230347.22371-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Kepplinger <martin.kepplinger@puri.sm>

[ Upstream commit 16bbc3eb83728c03138191a5d23d84d38175fa26 ]

Appearently the hw pointer can be NULL while the module is loaded and
in that case rsi_shutdown() crashes due to the unconditional dereference.

Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 1bebba4e85273..5d6143a551877 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1468,12 +1468,15 @@ static void rsi_shutdown(struct device *dev)
 	struct rsi_91x_sdiodev *sdev =
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
 	struct ieee80211_hw *hw = adapter->hw;
-	struct cfg80211_wowlan *wowlan = hw->wiphy->wowlan_config;
 
 	rsi_dbg(ERR_ZONE, "SDIO Bus shutdown =====>\n");
 
-	if (rsi_config_wowlan(adapter, wowlan))
-		rsi_dbg(ERR_ZONE, "Failed to configure WoWLAN\n");
+	if (hw) {
+		struct cfg80211_wowlan *wowlan = hw->wiphy->wowlan_config;
+
+		if (rsi_config_wowlan(adapter, wowlan))
+			rsi_dbg(ERR_ZONE, "Failed to configure WoWLAN\n");
+	}
 
 	if (IS_ENABLED(CONFIG_RSI_COEX) && adapter->priv->coex_mode > 1 &&
 	    adapter->priv->bt_adapter) {
-- 
2.20.1

