Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84F945E4D7
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 03:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358017AbhKZChX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:37:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351850AbhKZCfV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:35:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4863E61185;
        Fri, 26 Nov 2021 02:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893928;
        bh=Ngs82xBj1LLbXSDmWF4eJlRbBj4Kc8mqIGfH7kS/xA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4VPe/AxYLPuaLDpoCQRggx+OkU3EiOEYzfQ9bk08gmkMLeD+P0Q69IjZw077Aqbq
         xdOhuICtVvayIci/usScI3RxgL0jLqrB6yUkvLiCfXd196XVZw0SRbj47/MnqpsXpl
         IBuBHlTB8PYmXo35xr0yCyGkewYH/wjgFP7t4IgBtSUd+aCBWHX1vbHbiwNMczcvLT
         Yyxr2XAY5XUp09J/lvwdTx14o5RJdvJi/C+HHg7Kilhn4BlC118k+bvcu/MUBQ/sXs
         ebjVS0xjQP/EW6yo0yjsOGCJw3LbQxVi5QH9ltMUuzMkz7S+axZAa+94VsDcirrY9m
         W4U+qOCMBrCYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xing Song <xing.song@mediatek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 06/39] mac80211: do not access the IV when it was stripped
Date:   Thu, 25 Nov 2021 21:31:23 -0500
Message-Id: <20211126023156.441292-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xing Song <xing.song@mediatek.com>

[ Upstream commit 77dfc2bc0bb4b8376ecd7a430f27a4a8fff6a5a0 ]

ieee80211_get_keyid() will return false value if IV has been stripped,
such as return 0 for IP/ARP frames due to LLC header, and return -EINVAL
for disassociation frames due to its length... etc. Don't try to access
it if it's not present.

Signed-off-by: Xing Song <xing.song@mediatek.com>
Link: https://lore.kernel.org/r/20211101024657.143026-1-xing.song@mediatek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c4071b015c188..ba3b82a72a604 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1952,7 +1952,8 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		int keyid = rx->sta->ptk_idx;
 		sta_ptk = rcu_dereference(rx->sta->ptk[keyid]);
 
-		if (ieee80211_has_protected(fc)) {
+		if (ieee80211_has_protected(fc) &&
+		    !(status->flag & RX_FLAG_IV_STRIPPED)) {
 			cs = rx->sta->cipher_scheme;
 			keyid = ieee80211_get_keyid(rx->skb, cs);
 
-- 
2.33.0

