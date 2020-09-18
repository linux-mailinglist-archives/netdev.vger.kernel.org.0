Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F89526F2AE
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730489AbgIRDBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 23:01:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726812AbgIRCF0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:05:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B109A2376F;
        Fri, 18 Sep 2020 02:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394725;
        bh=4aJ98UjtJt7kaQkL7jPD6T/htJNsIC50/6P6Y5BPc+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bMNFlgtD90B2gjNKS2bGsLGn6y9ExK/hlnIIks07vZQm8Cotnnw2zzZX5vwBTzTyB
         WuwzKXMhgP8gEPl1fh9V1+33kytE6VXKattDCGXfXrSqqb1gSrbsi6LsxW1c6p5aIt
         M+m/2DN3ish6yJDlTwhI1AHPOJ8EZJMEbmH3r7IE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Raveendran Somu <raveendran.somu@cypress.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 208/330] brcmfmac: Fix double freeing in the fmac usb data path
Date:   Thu, 17 Sep 2020 21:59:08 -0400
Message-Id: <20200918020110.2063155-208-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raveendran Somu <raveendran.somu@cypress.com>

[ Upstream commit 78179869dc3f5c0059bbf5d931a2717f1ad97ecd ]

When the brcmf_fws_process_skb() fails to get hanger slot for
queuing the skb, it tries to free the skb.
But the caller brcmf_netdev_start_xmit() of that funciton frees
the packet on error return value.
This causes the double freeing and which caused the kernel crash.

Signed-off-by: Raveendran Somu <raveendran.somu@cypress.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1585124429-97371-3-git-send-email-chi-hsien.lin@cypress.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index eadc64454839d..3d36b6ee158bb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -2149,8 +2149,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 		brcmf_fws_enq(fws, BRCMF_FWS_SKBSTATE_DELAYED, fifo, skb);
 		brcmf_fws_schedule_deq(fws);
 	} else {
-		bphy_err(drvr, "drop skb: no hanger slot\n");
-		brcmf_txfinalize(ifp, skb, false);
+		bphy_err(drvr, "no hanger slot available\n");
 		rc = -ENOMEM;
 	}
 	brcmf_fws_unlock(fws);
-- 
2.25.1

