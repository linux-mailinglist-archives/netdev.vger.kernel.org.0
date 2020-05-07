Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220441C811A
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 06:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgEGEgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 00:36:36 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:18665 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725809AbgEGEgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 00:36:35 -0400
Received: from localhost.localdomain ([93.23.14.107])
        by mwinf5d73 with ME
        id bgcQ220042JbCfx03gcRXK; Thu, 07 May 2020 06:36:32 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 07 May 2020 06:36:32 +0200
X-ME-IP: 93.23.14.107
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kvalo@codeaurora.org, davem@davemloft.net,
        bjorn.andersson@linaro.org, marcel@holtmann.org,
        andy.gross@linaro.org
Cc:     wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] wcn36xx: Fix error handling path in 'wcn36xx_probe()'
Date:   Thu,  7 May 2020 06:36:19 +0200
Message-Id: <20200507043619.200051-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of error, 'qcom_wcnss_open_channel()' must be undone by a call to
'rpmsg_destroy_ept()', as already done in the remove function.

Fixes: 5052de8deff5 ("soc: qcom: smd: Transition client drivers from smd to rpmsg")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Not 100% sure of the commit for Fixes, but it is consistent with the
analysis in efad8396e906 where the same call has been added in the remove
function.
---
 drivers/net/wireless/ath/wcn36xx/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index e49c306e0eef..1acdc13a74fc 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1339,7 +1339,7 @@ static int wcn36xx_probe(struct platform_device *pdev)
 	if (addr && ret != ETH_ALEN) {
 		wcn36xx_err("invalid local-mac-address\n");
 		ret = -EINVAL;
-		goto out_wq;
+		goto out_channel;
 	} else if (addr) {
 		wcn36xx_info("mac address: %pM\n", addr);
 		SET_IEEE80211_PERM_ADDR(wcn->hw, addr);
@@ -1347,7 +1347,7 @@ static int wcn36xx_probe(struct platform_device *pdev)
 
 	ret = wcn36xx_platform_get_resources(wcn, pdev);
 	if (ret)
-		goto out_wq;
+		goto out_channel;
 
 	wcn36xx_init_ieee80211(wcn);
 	ret = ieee80211_register_hw(wcn->hw);
@@ -1359,6 +1359,8 @@ static int wcn36xx_probe(struct platform_device *pdev)
 out_unmap:
 	iounmap(wcn->ccu_base);
 	iounmap(wcn->dxe_base);
+out_channel:
+	rpmsg_destroy_ept(wcn->smd_channel);
 out_wq:
 	ieee80211_free_hw(hw);
 out_err:
-- 
2.25.1

