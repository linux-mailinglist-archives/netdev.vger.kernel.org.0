Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD22374424
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235899AbhEEQzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:55:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235600AbhEEQvm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:51:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 081506197B;
        Wed,  5 May 2021 16:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232671;
        bh=7/yiiwyr0m7qxRY/F3kNmtS+61oV1lKmu4wBeIw884Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6qWMCUziKQ5VGff7bVj4cZF/fHv64LIozMgBADs6a4vhp+n8J2Gzm2cxuPdCCnQn
         nOfHHgc8hxUtMVZZViB+0BrOBDsx/x5qXBdBwBcwKihMXYYlekXh2uSADNzmLqZbbd
         N56I86DQ15kdjgVp9WQxMxIBsLALZQ735s2Uohnbq95K3r4jm9bh5JuxR5XarZZ8rM
         Gcyk28OnUkw1Xnr/hnhKk8OIPntiTDkZma0b3he4AQpkeVsY+YVppJ3unnNVFICGSU
         04JneMX1ki94Kspf/T8gk1e86Jx6OmAhF7RlBK61yV8VPsnfyNgNHqVvcfcx+xBHdE
         DDYS7seiu80lA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Bauer <mail@david-bauer.net>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 42/85] mt76: mt76x0: disable GTK offloading
Date:   Wed,  5 May 2021 12:36:05 -0400
Message-Id: <20210505163648.3462507-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
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
index 11b769af2f8f..0f191bd28417 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -446,6 +446,10 @@ int mt76x02_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
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

