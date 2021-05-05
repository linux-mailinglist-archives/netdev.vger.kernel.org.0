Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E8837413C
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbhEEQgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:36:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234439AbhEEQeq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:34:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B05E613F9;
        Wed,  5 May 2021 16:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232367;
        bh=Lg8lKjSCJjYMIeB/wHTWH+FcGtxaZ7xHRqQ8l346B6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YFCkDYhf/3WVYUjJQtfyZgORE2RKWe7l4g82NsBB38K4+kmhPwIddDqZZ91eOzPgi
         GPAL+r3+b9JF5akleg9bj7yBqHvxRHXoKzvIrjRusmcA23esSt/LzU71yLS3mPKQC3
         LmTjSj5bBjyhvWH5Igi/tyeVXgk32EhX+KkmzKgb7Nig6bDebFxm1q4ByLkMK3xhQD
         CxExOsSTqcQZNdNgud1IEBjCD3MUkxBDQgUMTNYotpu+gw4jzdK9GuPgeWdaBD/vhB
         O5RZi1XLGrnWfoI45F0O0jqe6ghnhNtKFuk8ux7oC1LaqBVL0Y10YBEVY3LWHSoWZU
         DNNRD9lKRL2YQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 059/116] mt76: connac: always check return value from mt76_connac_mcu_alloc_wtbl_req
Date:   Wed,  5 May 2021 12:30:27 -0400
Message-Id: <20210505163125.3460440-59-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit baa3afb39e94965f4ca5b5d3d274379504b8fa24 ]

Even if this is not a real bug since mt76_connac_mcu_alloc_wtbl_req routine
can fails just if nskb is NULL , always check return value from
mt76_connac_mcu_alloc_wtbl_req in order to avoid possible future
mistake.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c      | 3 +++
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 631596fc2f36..4ecbd5406e2a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -1040,6 +1040,9 @@ mt7615_mcu_sta_ba(struct mt7615_dev *dev,
 
 	wtbl_hdr = mt76_connac_mcu_alloc_wtbl_req(&dev->mt76, &msta->wcid,
 						  WTBL_SET, sta_wtbl, &skb);
+	if (IS_ERR(wtbl_hdr))
+		return PTR_ERR(wtbl_hdr);
+
 	mt76_connac_mcu_wtbl_ba_tlv(&dev->mt76, skb, params, enable, tx,
 				    sta_wtbl, wtbl_hdr);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 6cbccfb05f8b..cd92ff915da5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -833,6 +833,9 @@ int mt76_connac_mcu_add_sta_cmd(struct mt76_phy *phy,
 	wtbl_hdr = mt76_connac_mcu_alloc_wtbl_req(dev, wcid,
 						  WTBL_RESET_AND_SET,
 						  sta_wtbl, &skb);
+	if (IS_ERR(wtbl_hdr))
+		return PTR_ERR(wtbl_hdr);
+
 	if (enable) {
 		mt76_connac_mcu_wtbl_generic_tlv(dev, skb, vif, sta, sta_wtbl,
 						 wtbl_hdr);
-- 
2.30.2

