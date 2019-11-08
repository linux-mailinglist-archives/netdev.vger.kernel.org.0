Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17503F45E7
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 12:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732545AbfKHLiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:38:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732499AbfKHLiW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 647EA222C2;
        Fri,  8 Nov 2019 11:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213101;
        bh=DWeebrJx8H6xViZvK61SrP4XsgVD2r/OoVtegmbXWEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahVc+eFTfO4RMuAXD4vSR7UF9Bcd+9f3PeU188QHveSo0YyNMQuD437kUtnjm0BwE
         T3O4hwDzv3mqTjTVPuX4jkxrL4UgToOAuCgR+xfaJOmT5hS1KTH9uMXyhgYkCMBHHV
         6ILnSSYV08NRAPS50tvKtO3PIjATdstHRFzO5XZ0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dedy Lansky <dlansky@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 025/205] wil6210: drop Rx multicast packets that are looped-back to STA
Date:   Fri,  8 Nov 2019 06:34:52 -0500
Message-Id: <20191108113752.12502-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

[ Upstream commit 9a65064abdf82934e0ed4744125f9f466f421f57 ]

Delivering a looped-back multicast packet to network stack can cause
higher layer protocols to fail like for example IPv6 DAD.
In STA mode, upon receiving Rx multicast packet, check if the source
MAC address is equal to our own MAC address and if so drop the packet.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 1b1b58e0129a3..25a65ca424c84 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -766,7 +766,14 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 		return;
 	}
 
-	if (wdev->iftype == NL80211_IFTYPE_AP && !vif->ap_isolate) {
+	if (wdev->iftype == NL80211_IFTYPE_STATION) {
+		if (mcast && ether_addr_equal(eth->h_source, ndev->dev_addr)) {
+			/* mcast packet looped back to us */
+			rc = GRO_DROP;
+			dev_kfree_skb(skb);
+			goto stats;
+		}
+	} else if (wdev->iftype == NL80211_IFTYPE_AP && !vif->ap_isolate) {
 		if (mcast) {
 			/* send multicast frames both to higher layers in
 			 * local net stack and back to the wireless medium
-- 
2.20.1

