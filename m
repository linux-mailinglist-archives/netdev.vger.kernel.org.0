Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4892D1A581F
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729904AbgDKXLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:11:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729882AbgDKXLX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:11:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DEF120708;
        Sat, 11 Apr 2020 23:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646683;
        bh=Sc9PaM8KG2j2M4LGfGMIyubp9wA2UO0p2iGeSHmlML0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEQOiXTe+ScAHlodTO3N9AIlA5b87anXfjkQV7y0wTbboAvulLLcO9LGfcuCdZE22
         nMcg91nrruUiKP9+golgMSYrCgcFZz2kekfw4JHzBc0fbH3J2tqRdedhURanRbbjW5
         t/PBvPZcHK/pyEjeQ0FFUuVI8ayzM5EkFEiqItMM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Raveendran Somu <raveendran.somu@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 079/108] brcmfmac: fix the incorrect return value in brcmf_inform_single_bss().
Date:   Sat, 11 Apr 2020 19:09:14 -0400
Message-Id: <20200411230943.24951-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raveendran Somu <raveendran.somu@cypress.com>

[ Upstream commit bd9944918ceb28ede97f715d209e220db5e92c09 ]

The function brcmf_inform_single_bss returns the value as success,
even when the length exceeds the maximum value.
The fix is to send appropriate code on this error.
This issue is observed when Cypress test group reported random fmac
crashes when running their tests and the path was identified from the
crash logs. With this fix the random failure issue in Cypress test group
was resolved.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Raveendran Somu <raveendran.somu@cypress.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1585124429-97371-4-git-send-email-chi-hsien.lin@cypress.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index e3ebb7abbdaed..28e08de04986f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2812,7 +2812,7 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 
 	if (le32_to_cpu(bi->length) > WL_BSS_INFO_MAX) {
 		bphy_err(drvr, "Bss info is larger than buffer. Discarding\n");
-		return 0;
+		return -EINVAL;
 	}
 
 	if (!bi->ctl_ch) {
-- 
2.20.1

