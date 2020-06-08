Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0B21F2F7A
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbgFIAug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:50:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728649AbgFHXK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:10:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36954208FE;
        Mon,  8 Jun 2020 23:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657827;
        bh=RErxoPQL57Pp8qE20X8tNu1DhNmZrHDXsOBxyT30KC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hqXphQ5lg5hMJQ1SXB3cDmkqGOz9lsSunvgbshaIpZ6XSOfsJg2TzMqzWUJqES51v
         sy3jrJZQ7c6HuhAGJDqSvk5Qdk9gOm1u0KD7KoHCnMZjYqXmVvovxavkSsB6suAKBe
         kTDTdXQLrXsgSEKe6tTG0a0bKX6qBAptXhKUKULc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 198/274] brcmfmac: fix WPA/WPA2-PSK 4-way handshake offload and SAE offload failures
Date:   Mon,  8 Jun 2020 19:04:51 -0400
Message-Id: <20200608230607.3361041-198-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chung-Hsien Hsu <stanley.hsu@cypress.com>

[ Upstream commit b2fe11f0777311a764e47e2f9437809b4673b7b1 ]

An incorrect value of use_fwsup is set for 4-way handshake offload for
WPA//WPA2-PSK, caused by commit 3b1e0a7bdfee ("brcmfmac: add support for
SAE authentication offload"). It results in missing bit
BRCMF_VIF_STATUS_EAP_SUCCESS set in brcmf_is_linkup() and causes the
failure. This patch correct the value for the case.

Also setting bit BRCMF_VIF_STATUS_EAP_SUCCESS for SAE offload case in
brcmf_is_linkup() to fix SAE offload failure.

Fixes: 3b1e0a7bdfee ("brcmfmac: add support for SAE authentication offload")
Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1589277788-119966-1-git-send-email-chi-hsien.lin@cypress.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c  | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 2ba165330038..bacd762cdf3e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1819,6 +1819,10 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 		switch (sme->crypto.akm_suites[0]) {
 		case WLAN_AKM_SUITE_SAE:
 			val = WPA3_AUTH_SAE_PSK;
+			if (sme->crypto.sae_pwd) {
+				brcmf_dbg(INFO, "using SAE offload\n");
+				profile->use_fwsup = BRCMF_PROFILE_FWSUP_SAE;
+			}
 			break;
 		default:
 			bphy_err(drvr, "invalid cipher group (%d)\n",
@@ -2104,11 +2108,6 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		goto done;
 	}
 
-	if (sme->crypto.sae_pwd) {
-		brcmf_dbg(INFO, "using SAE offload\n");
-		profile->use_fwsup = BRCMF_PROFILE_FWSUP_SAE;
-	}
-
 	if (sme->crypto.psk &&
 	    profile->use_fwsup != BRCMF_PROFILE_FWSUP_SAE) {
 		if (WARN_ON(profile->use_fwsup != BRCMF_PROFILE_FWSUP_NONE)) {
@@ -5495,7 +5494,8 @@ static bool brcmf_is_linkup(struct brcmf_cfg80211_vif *vif,
 	u32 event = e->event_code;
 	u32 status = e->status;
 
-	if (vif->profile.use_fwsup == BRCMF_PROFILE_FWSUP_PSK &&
+	if ((vif->profile.use_fwsup == BRCMF_PROFILE_FWSUP_PSK ||
+	     vif->profile.use_fwsup == BRCMF_PROFILE_FWSUP_SAE) &&
 	    event == BRCMF_E_PSK_SUP &&
 	    status == BRCMF_E_STATUS_FWSUP_COMPLETED)
 		set_bit(BRCMF_VIF_STATUS_EAP_SUCCESS, &vif->sme_state);
-- 
2.25.1

