Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19DE845E5AD
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357779AbhKZCoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:44:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:49808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358325AbhKZClg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:41:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 919016125F;
        Fri, 26 Nov 2021 02:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894093;
        bh=8n2IBl+k1S/Bq+MjR5lhlxC6Vz+D8xdsiTdby2ApKEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bt4+np51pe+p07qFgTRmCmrgZgXpZlcsRuZvHwUnb/Cc+n1YL5KduUgA1RiTY3Ej6
         NztwP+pfJw023+3fFE7Vmo72VlBpOFWOnDeOCVN6zPyHONSnjcdqd7JNBVuC1IHnj/
         8uy+j/KEEezU7uXvd4xWACHoy6fqE6KtZnKblfSObt7qUvTxXeatJ+PJR/McZle8Yd
         MnAUy79pa4zSnTFSOfZhUVLilbEMjoIbUC5KIm/nMq7YyWL2YJ3CrfJaoK5aZk2xdl
         TQHfPn+jYeqcPq85+k4irHh1EffK698u7vS8n4XBUYWeK0lEzaRKa9hizPfqJbjGJz
         WD7LG11Cz4d+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xing Song <xing.song@mediatek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 03/19] mac80211: do not access the IV when it was stripped
Date:   Thu, 25 Nov 2021 21:34:32 -0500
Message-Id: <20211126023448.442529-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023448.442529-1-sashal@kernel.org>
References: <20211126023448.442529-1-sashal@kernel.org>
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
index c7e6bf7c22c78..282bf336b15a4 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1918,7 +1918,8 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		int keyid = rx->sta->ptk_idx;
 		sta_ptk = rcu_dereference(rx->sta->ptk[keyid]);
 
-		if (ieee80211_has_protected(fc)) {
+		if (ieee80211_has_protected(fc) &&
+		    !(status->flag & RX_FLAG_IV_STRIPPED)) {
 			cs = rx->sta->cipher_scheme;
 			keyid = ieee80211_get_keyid(rx->skb, cs);
 
-- 
2.33.0

