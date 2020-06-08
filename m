Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F451F293F
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732662AbgFHX5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:57:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731483AbgFHXXZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:23:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23DA12086A;
        Mon,  8 Jun 2020 23:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658605;
        bh=g9sba+yzpgOCEImmoDFkSzf4VSNXTjLj0CJFw4IJPQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ule2KxGFL350TuMRji+nKW25GhR5KHsrnbYRnF+CXPuWJh7Ax0LCIXtk0Hy14Bgms
         99I5/QVJ/MHy5NYrzw7y4D/WwJUE/w4rPh0HF1VnT5+LNxRxOX7g9mRF58Ep95PubX
         0NZpeHyEwDydO0Gwq0+ZlK9KYXSGqLLqSZ4EJ2Z8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaehoon Chung <jh80.chung@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 033/106] brcmfmac: fix wrong location to get firmware feature
Date:   Mon,  8 Jun 2020 19:21:25 -0400
Message-Id: <20200608232238.3368589-33-sashal@kernel.org>
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

From: Jaehoon Chung <jh80.chung@samsung.com>

[ Upstream commit c57673852062428cdeabdd6501ac8b8e4c302067 ]

sup_wpa feature is getting after setting feature_disable flag.
If firmware is supported sup_wpa feature,  it's always enabled
regardless of feature_disable flag.

Fixes: b8a64f0e96c2 ("brcmfmac: support 4-way handshake offloading for WPA/WPA2-PSK")
Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200330052528.10503-1-jh80.chung@samsung.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 4c5a3995dc35..d7f41caa0b0b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -281,13 +281,14 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 	if (!err)
 		ifp->drvr->feat_flags |= BIT(BRCMF_FEAT_SCAN_RANDOM_MAC);
 
+	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_FWSUP, "sup_wpa");
+
 	if (drvr->settings->feature_disable) {
 		brcmf_dbg(INFO, "Features: 0x%02x, disable: 0x%02x\n",
 			  ifp->drvr->feat_flags,
 			  drvr->settings->feature_disable);
 		ifp->drvr->feat_flags &= ~drvr->settings->feature_disable;
 	}
-	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_FWSUP, "sup_wpa");
 
 	brcmf_feat_firmware_overrides(drvr);
 
-- 
2.25.1

