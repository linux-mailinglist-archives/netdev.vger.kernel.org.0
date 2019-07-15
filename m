Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 312CC69268
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732274AbfGOOgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:36:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731009AbfGOOgf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:36:35 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B215F217D8;
        Mon, 15 Jul 2019 14:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563201395;
        bh=Ye6y2k07ohqpMfkv2gPc4/NQDp7dZIEQ3bvaamJwXdE=;
        h=From:To:Cc:Subject:Date:From;
        b=wEulihC1b7izoPyd6N5CZp2S4xHqTYxbDJIsQ+Aalj9zSf2K3QcjhfVzPd9NKWSSr
         bAFontdj0azjOBE4ut8euO35H1e1o/xCvoJYjdN55T+kbX68XPKjfaY6M4sCCm6WE2
         z/S/X+Es6qVoGLIhzNS15BSVTR2fA85m4W0D/p74=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Surabhi Vishnoi <svishnoi@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 01/73] ath10k: Do not send probe response template for mesh
Date:   Mon, 15 Jul 2019 10:35:17 -0400
Message-Id: <20190715143629.10893-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Surabhi Vishnoi <svishnoi@codeaurora.org>

[ Upstream commit 97354f2c432788e3163134df6bb144f4b6289d87 ]

Currently mac80211 do not support probe response template for
mesh point. When WMI_SERVICE_BEACON_OFFLOAD is enabled, host
driver tries to configure probe response template for mesh, but
it fails because the interface type is not NL80211_IFTYPE_AP but
NL80211_IFTYPE_MESH_POINT.

To avoid this failure, skip sending probe response template to
firmware for mesh point.

Tested HW: WCN3990/QCA6174/QCA9984

Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index fb632a454fc2..1588fe8110d0 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1596,6 +1596,10 @@ static int ath10k_mac_setup_prb_tmpl(struct ath10k_vif *arvif)
 	if (arvif->vdev_type != WMI_VDEV_TYPE_AP)
 		return 0;
 
+	 /* For mesh, probe response and beacon share the same template */
+	if (ieee80211_vif_is_mesh(vif))
+		return 0;
+
 	prb = ieee80211_proberesp_get(hw, vif);
 	if (!prb) {
 		ath10k_warn(ar, "failed to get probe resp template from mac80211\n");
-- 
2.20.1

