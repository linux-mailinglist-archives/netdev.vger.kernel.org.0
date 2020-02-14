Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6612515F49A
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbgBNPtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:49:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:52410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729953AbgBNPt3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:49:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBF0224687;
        Fri, 14 Feb 2020 15:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695368;
        bh=iuyIbYzgZDi9u7sIMIx8Fd9TnuJLfU1RqCaPaTF+SmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ORHK1QJVabjLDsbGFSl0uk+bWOwMCMruSJIX23aDOoRrh0Os4DQss7KiLSqGPP8MB
         kbLCa3zbfeDDXOEVWkdr3hpYd3m+VW5FoMclQV2Wrhb7vcy5Tzdql0HN85gPjhho4r
         A0R77pDk3Gk8IEHtcO2O3Bf3+CiA3fm9LyzHgoRI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 026/542] brcmfmac: Fix memory leak in brcmf_p2p_create_p2pdev()
Date:   Fri, 14 Feb 2020 10:40:18 -0500
Message-Id: <20200214154854.6746-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 5cc509aa83c6acd2c5cd94f99065c39d2bd0a490 ]

In the implementation of brcmf_p2p_create_p2pdev() the allocated memory
for p2p_vif is leaked when the mac address is the same as primary
interface. To fix this, go to error path to release p2p_vif via
brcmf_free_vif().

Fixes: cb746e47837a ("brcmfmac: check p2pdev mac address uniqueness")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 7ba9f6a686459..1f5deea5a288e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -2092,7 +2092,8 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 	/* firmware requires unique mac address for p2pdev interface */
 	if (addr && ether_addr_equal(addr, pri_ifp->mac_addr)) {
 		bphy_err(drvr, "discovery vif must be different from primary interface\n");
-		return ERR_PTR(-EINVAL);
+		err = -EINVAL;
+		goto fail;
 	}
 
 	brcmf_p2p_generate_bss_mac(p2p, addr);
-- 
2.20.1

