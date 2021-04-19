Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6233643FA
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 15:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241650AbhDSNXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 09:23:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59920 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240580AbhDSNVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 09:21:11 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lYTpI-0003Uj-N6; Mon, 19 Apr 2021 13:20:32 +0000
From:   Colin King <colin.king@canonical.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] mt76: mt7615: Fix a dereference of pointer sta before it is null checked
Date:   Mon, 19 Apr 2021 14:20:32 +0100
Message-Id: <20210419132032.177788-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the assignment of idx dereferences pointer sta before
sta is null checked, leading to a potential null pointer dereference.
Fix this by assigning idx when it is required after the null check on
pointer sta.

Addresses-Coverity: ("Dereference before null check")
Fixes: a4a5a430b076 ("mt76: mt7615: fix TSF configuration")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c b/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
index 4a370b9f7a17..f8d3673c2cae 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
@@ -67,7 +67,7 @@ static int mt7663_usb_sdio_set_rates(struct mt7615_dev *dev,
 	struct mt7615_rate_desc *rate = &wrd->rate;
 	struct mt7615_sta *sta = wrd->sta;
 	u32 w5, w27, addr, val;
-	u16 idx = sta->vif->mt76.omac_idx;
+	u16 idx;
 
 	lockdep_assert_held(&dev->mt76.mutex);
 
@@ -119,6 +119,7 @@ static int mt7663_usb_sdio_set_rates(struct mt7615_dev *dev,
 
 	sta->rate_probe = sta->rateset[rate->rateset].probe_rate.idx != -1;
 
+	idx = sta->vif->mt76.omac_idx;
 	idx = idx > HW_BSSID_MAX ? HW_BSSID_0 : idx;
 	addr = idx > 1 ? MT_LPON_TCR2(idx): MT_LPON_TCR0(idx);
 
-- 
2.30.2

