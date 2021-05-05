Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944D8374287
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbhEEQrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:47:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235713AbhEEQow (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:44:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B45BF6142D;
        Wed,  5 May 2021 16:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232530;
        bh=IPp4mfL+XvNC0dERM3oeP/v+YbaufMNi1bDToE++chk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2SRv6zqImbPwY6NnWiKxMUvQp7iBp7zuNepg/nMRODq0ZjY8yMAWC1xpN6Vy0m3N
         HAu9foF9HYHsnQg+7p9xdhMui+hLaqtUgxBGUyWqOBEhSz04AaOXrlmqQ1fB1K7YMW
         2sVUbDJc2Gee28vXQmX9iY3L+r+KYRPAbpa4RmdkSmhsRPjxvyFHKUIa1qPb+sCtZ+
         bNwpTly0IB6+MlUY0A/eO4Q7qNvVJI+J2ntlDfihdgw5oqa+n3Ziwsashtv1yOQ+3m
         eTPk8P5FigBgcn1AiayHskRHez2MrKAzKdqX/dEVnX1tUNNi7q7V3Ixv1CHnIOTn69
         Qt43Z0bt8YtXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Bauer <mail@david-bauer.net>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 053/104] mt76: mt76x0: disable GTK offloading
Date:   Wed,  5 May 2021 12:33:22 -0400
Message-Id: <20210505163413.3461611-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Bauer <mail@david-bauer.net>

[ Upstream commit 4b36cc6b390f18dbc59a45fb4141f90d7dfe2b23 ]

When operating two VAP on a MT7610 with encryption (PSK2, SAE, OWE),
only the first one to be created will transmit properly encrypteded
frames.

All subsequently created VAPs will sent out frames with the payload left
unencrypted, breaking multicast traffic (ICMP6 NDP) and potentially
disclosing information to a third party.

Disable GTK offloading and encrypt these frames in software to
circumvent this issue. THis only seems to be necessary on MT7610 chips,
as MT7612 is not affected from our testing.

Signed-off-by: David Bauer <mail@david-bauer.net>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 7ac20d3c16d7..aaa597b941cd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -447,6 +447,10 @@ int mt76x02_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
 		return -EOPNOTSUPP;
 
+	/* MT76x0 GTK offloading does not work with more than one VIF */
+	if (is_mt76x0(dev) && !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		return -EOPNOTSUPP;
+
 	msta = sta ? (struct mt76x02_sta *)sta->drv_priv : NULL;
 	wcid = msta ? &msta->wcid : &mvif->group_wcid;
 
-- 
2.30.2

