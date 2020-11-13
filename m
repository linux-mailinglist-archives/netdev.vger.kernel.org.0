Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253F32B15D3
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 07:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgKMG0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 01:26:36 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7495 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgKMG0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 01:26:36 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CXT4y1Y3Tzhj8g;
        Fri, 13 Nov 2020 14:26:26 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 13 Nov 2020 14:26:30 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <stanley.hsu@cypress.com>
CC:     <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] brcmfmac: fix error return code in brcmf_cfg80211_connect()
Date:   Fri, 13 Nov 2020 14:28:16 +0800
Message-ID: <1605248896-16812-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 3b1e0a7bdfee ("brcmfmac: add support for SAE authentication offload")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index a2dbbb9..0ee421f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2137,7 +2137,8 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 				    BRCMF_WSEC_MAX_PSK_LEN);
 	else if (profile->use_fwsup == BRCMF_PROFILE_FWSUP_SAE) {
 		/* clean up user-space RSNE */
-		if (brcmf_fil_iovar_data_set(ifp, "wpaie", NULL, 0)) {
+		err = brcmf_fil_iovar_data_set(ifp, "wpaie", NULL, 0);
+		if (err) {
 			bphy_err(drvr, "failed to clean up user-space RSNE\n");
 			goto done;
 		}
-- 
2.9.5

