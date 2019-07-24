Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB82D7314B
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 16:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387414AbfGXOMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 10:12:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58270 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725870AbfGXOMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 10:12:41 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8C038DD57E4095B86D96;
        Wed, 24 Jul 2019 22:12:34 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Wed, 24 Jul 2019
 22:12:25 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <kvalo@codeaurora.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] brcmfmac: remove set but not used variable 'dtim_period'
Date:   Wed, 24 Jul 2019 22:12:01 +0800
Message-ID: <20190724141201.59640-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c: In function brcmf_update_bss_info:
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:2962:5: warning: variable dtim_period set but not used [-Wunused-but-set-variable]
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c: In function brcmf_update_bss_info:
drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:2961:6: warning: variable beacon_interval set but not used [-Wunused-but-set-variable]

They are never used so can be removed.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index b6d0df3..ec17f7f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2958,8 +2958,6 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg,
 	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_bss_info_le *bi;
 	const struct brcmf_tlv *tim;
-	u16 beacon_interval;
-	u8 dtim_period;
 	size_t ie_len;
 	u8 *ie;
 	s32 err = 0;
@@ -2983,12 +2981,9 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg,
 
 	ie = ((u8 *)bi) + le16_to_cpu(bi->ie_offset);
 	ie_len = le32_to_cpu(bi->ie_length);
-	beacon_interval = le16_to_cpu(bi->beacon_period);
 
 	tim = brcmf_parse_tlvs(ie, ie_len, WLAN_EID_TIM);
-	if (tim)
-		dtim_period = tim->data[1];
-	else {
+	if (!tim) {
 		/*
 		* active scan was done so we could not get dtim
 		* information out of probe response.
@@ -3000,7 +2995,6 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg,
 			bphy_err(drvr, "wl dtim_assoc failed (%d)\n", err);
 			goto update_bss_info_out;
 		}
-		dtim_period = (u8)var;
 	}
 
 update_bss_info_out:
-- 
2.7.4


