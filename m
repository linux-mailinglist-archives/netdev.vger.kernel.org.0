Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFB73FA63D
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbfKMC1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 21:27:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:37832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727515AbfKMBut (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:50:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E9AB22459;
        Wed, 13 Nov 2019 01:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609849;
        bh=IWdzDFSf/TRr9ci4D2Ci/WM12+j7L/sItckgGxtTqy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2EGJ3IgeNfif66fLmlCCb7QOhlMizbXYgtBBsjaZT01ggxyoOgP/yQ2ERsNy13YH9
         ILmAjG0W3ZanCb25diiDPOmx9okWGx/goj7rG5GYa1r4Ef6jTS9QGtrniUeAEoNs8g
         /NkA686EtOpkqeUHvo2YLkCYoXcKTFIIRFiD9rJM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 020/209] mt76: fix handling ps-poll frames
Date:   Tue, 12 Nov 2019 20:47:16 -0500
Message-Id: <20191113015025.9685-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 36d910960fae3f9e74bedf3e0ef39ee26bdaa51f ]

Hardware station lookup for pspoll frames can fail, which makes the driver
ignore ps-poll frames. Fix the resulting powersave issues by looking up
the station for pspoll frames in software

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index ade4a2029a24a..1b5abd4816ed7 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -548,6 +548,12 @@ mt76_check_ps(struct mt76_dev *dev, struct sk_buff *skb)
 	struct mt76_wcid *wcid = status->wcid;
 	bool ps;
 
+	if (ieee80211_is_pspoll(hdr->frame_control) && !wcid) {
+		sta = ieee80211_find_sta_by_ifaddr(dev->hw, hdr->addr2, NULL);
+		if (sta)
+			wcid = status->wcid = (struct mt76_wcid *) sta->drv_priv;
+	}
+
 	if (!wcid || !wcid->sta)
 		return;
 
-- 
2.20.1

