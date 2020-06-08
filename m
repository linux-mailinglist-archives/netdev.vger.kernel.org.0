Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CBB1F2A91
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388015AbgFIAJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:09:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730953AbgFHXUU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:20:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BC062074B;
        Mon,  8 Jun 2020 23:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658420;
        bh=Tzw3Gzlm+3BA/nlhX9g2BWNAa7mep+kD4+xGWxixxX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQQR6V5o88+gj2b+3x1TR+eGiSUCRbsLTxBrwGQIXzuw1VCWWslsyiBC1X4xDnbLp
         FGZOUkQe0O1HFqJHXrfau9jfKyBh7jyl8BEaDiUY7ajUYqLsWB4T6Hpvs7x4EunmTX
         slJm6eV0PluPP9kxc+F4+8aZfPUgE4vxkqoBvtwA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaehoon Chung <jh80.chung@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 067/175] brcmfmac: fix wrong location to get firmware feature
Date:   Mon,  8 Jun 2020 19:17:00 -0400
Message-Id: <20200608231848.3366970-67-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
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
index 2c3526aeca6f..545015610cf8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -283,13 +283,14 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
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

