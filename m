Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF16E32E53E
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhCEJtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:49:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229669AbhCEJsx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 04:48:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CDC064ECF;
        Fri,  5 Mar 2021 09:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614937733;
        bh=PPSrmURA609muaJephVoMm0YZbJ0gmnU87bIHWpeduE=;
        h=Date:From:To:Cc:Subject:From;
        b=YNJOU7LAxyTmdN+z6jhZM3JLeP9qa3ZfZ5ELb4o6PYd0xy0qkoA4QjqigNJhLAL50
         oIN8qnFApMSQsAqHlTJt4gyhqRNwvBa6t/9McFRk6Q2NWRhDzz3K41a0BFOCJ4nDaQ
         RL70mOFW/0YiI7c+JFreT1TFSwX8Y127zqZTmqVz7YYbbeSNLOzc3YytW9LBkKtgsh
         dDysvnxpUpjzmeP9jlKtXXBjHfx6b8gF+micLHx12Stw1p9v6414pt/RPFxrXNVwRM
         wwRX5MaYeQejo6POvRJp9yV++A5GYYN2NFqAaG+w1pxbIbtVwH8+ly8lV+BsA+rYZl
         Uh+WKTFH5f0bw==
Date:   Fri, 5 Mar 2021 03:48:50 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] rtl8xxxu: Fix fall-through warnings for Clang
Message-ID: <20210305094850.GA141221@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

