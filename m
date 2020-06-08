Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F831F28A0
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387673AbgFHXys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:54:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728395AbgFHXYK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:24:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C805C208B8;
        Mon,  8 Jun 2020 23:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658649;
        bh=CarzX7jrFj2dLReUZB4e6YJK8BhpEudbGb6UOINdud4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q+5u8ZQwS9KVrYiPOHdPlUdipcFzyvdxwqN4wTFXqbTinoqUBnK2dwfD5vZ0lDoUP
         VpHf2CENNqz9dRXSQED1WNfcUjtv3zi1yREnhO2GuLsLE9oJWT4eyDKQXSXgaSAoix
         3uO6mP9rQygM3E05RAF3nyYST3NerT/UrnuZJO9M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 069/106] wcn36xx: Fix error handling path in 'wcn36xx_probe()'
Date:   Mon,  8 Jun 2020 19:22:01 -0400
Message-Id: <20200608232238.3368589-69-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232238.3368589-1-sashal@kernel.org>
References: <20200608232238.3368589-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a86308fc534edeceaf64670c691e17485436a4f4 ]

In case of error, 'qcom_wcnss_open_channel()' must be undone by a call to
'rpmsg_destroy_ept()', as already done in the remove function.

Fixes: 5052de8deff5 ("soc: qcom: smd: Transition client drivers from smd to rpmsg")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200507043619.200051-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 79998a3ddb7a..ad051f34e65b 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1341,7 +1341,7 @@ static int wcn36xx_probe(struct platform_device *pdev)
 	if (addr && ret != ETH_ALEN) {
 		wcn36xx_err("invalid local-mac-address\n");
 		ret = -EINVAL;
-		goto out_wq;
+		goto out_destroy_ept;
 	} else if (addr) {
 		wcn36xx_info("mac address: %pM\n", addr);
 		SET_IEEE80211_PERM_ADDR(wcn->hw, addr);
@@ -1349,7 +1349,7 @@ static int wcn36xx_probe(struct platform_device *pdev)
 
 	ret = wcn36xx_platform_get_resources(wcn, pdev);
 	if (ret)
-		goto out_wq;
+		goto out_destroy_ept;
 
 	wcn36xx_init_ieee80211(wcn);
 	ret = ieee80211_register_hw(wcn->hw);
@@ -1361,6 +1361,8 @@ static int wcn36xx_probe(struct platform_device *pdev)
 out_unmap:
 	iounmap(wcn->ccu_base);
 	iounmap(wcn->dxe_base);
+out_destroy_ept:
+	rpmsg_destroy_ept(wcn->smd_channel);
 out_wq:
 	ieee80211_free_hw(hw);
 out_err:
-- 
2.25.1

