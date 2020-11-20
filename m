Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059142BB3DA
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731385AbgKTSiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:38:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:57000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730382AbgKTSix (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:38:53 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDE4F2242B;
        Fri, 20 Nov 2020 18:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897532;
        bh=PPSrmURA609muaJephVoMm0YZbJ0gmnU87bIHWpeduE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ifQuROBobj3rDbFlXDEYdF/LfNP1aCyj4kb0NHLI/UhRkjstWUGjIt5UNFpYlgGmU
         8Y75xGMLGA8cInDgyObcrS8WBROJT0pv9yhQeEhD5ou8KNc+CudUXqZx+7DGvLncxw
         fl4qhgUaH9sCgG16bNK/Xes8QhyDrDBmXFvteWh8=
Date:   Fri, 20 Nov 2020 12:38:58 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 117/141] rtl8xxxu: Fix fall-through warnings for Clang
Message-ID: <d522f387b2d0dde774785c7169c1f25aa529989d.1605896060.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix
multiple warnings by replacing /* fall through */ comments with
the new pseudo-keyword macro fallthrough; instead of letting the
code fall through to the next case.

Notice that Clang doesn't recognize /* fall through */ comments as
implicit fall-through markings.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 5cd7ef3625c5..afc97958fa4d 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1145,7 +1145,7 @@ void rtl8xxxu_gen1_config_channel(struct ieee80211_hw *hw)
 	switch (hw->conf.chandef.width) {
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		ht = false;
-		/* fall through */
+		fallthrough;
 	case NL80211_CHAN_WIDTH_20:
 		opmode |= BW_OPMODE_20MHZ;
 		rtl8xxxu_write8(priv, REG_BW_OPMODE, opmode);
@@ -1272,7 +1272,7 @@ void rtl8xxxu_gen2_config_channel(struct ieee80211_hw *hw)
 	switch (hw->conf.chandef.width) {
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		ht = false;
-		/* fall through */
+		fallthrough;
 	case NL80211_CHAN_WIDTH_20:
 		rf_mode_bw |= WMAC_TRXPTCL_CTL_BW_20;
 		subchannel = 0;
@@ -1741,11 +1741,11 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 		case 3:
 			priv->ep_tx_low_queue = 1;
 			priv->ep_tx_count++;
-			/* fall through */
+			fallthrough;
 		case 2:
 			priv->ep_tx_normal_queue = 1;
 			priv->ep_tx_count++;
-			/* fall through */
+			fallthrough;
 		case 1:
 			priv->ep_tx_high_queue = 1;
 			priv->ep_tx_count++;
-- 
2.27.0

