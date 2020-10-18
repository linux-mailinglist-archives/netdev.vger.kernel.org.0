Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA5A291AF1
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732220AbgJRT2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:28:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732201AbgJRT2A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:28:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30B7A22274;
        Sun, 18 Oct 2020 19:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049279;
        bh=I9abcd9KWuhpipgU+LGs2WDKTi0MFSc+wWieyXzN8Dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bj0egLy5XoUdxNtd7O3cXFjrawInVD9iPufhvupcTjuxbnPtxToDsm6WyYL9kn79w
         Vxbbny300XqKgwFr7UeO/rt8qofVeEueuz1zSgKyio8GeyPsjlW9BBNpR1vpgsGBwe
         ugm5g6xTwnJXixX6qJZzpXCzprWQ3wl67t58Xo3Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Chiu <chiu@endlessm.com>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 26/33] rtl8xxxu: prevent potential memory leak
Date:   Sun, 18 Oct 2020 15:27:21 -0400
Message-Id: <20201018192728.4056577-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192728.4056577-1-sashal@kernel.org>
References: <20201018192728.4056577-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Chiu <chiu@endlessm.com>

[ Upstream commit 86279456a4d47782398d3cb8193f78f672e36cac ]

Free the skb if usb_submit_urb fails on rx_urb. And free the urb
no matter usb_submit_urb succeeds or not in rtl8xxxu_submit_int_urb.

Signed-off-by: Chris Chiu <chiu@endlessm.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200906040424.22022-1-chiu@endlessm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 8254d4b22c50b..b8d387edde65c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5135,7 +5135,6 @@ static int rtl8xxxu_submit_int_urb(struct ieee80211_hw *hw)
 	ret = usb_submit_urb(urb, GFP_KERNEL);
 	if (ret) {
 		usb_unanchor_urb(urb);
-		usb_free_urb(urb);
 		goto error;
 	}
 
@@ -5144,6 +5143,7 @@ static int rtl8xxxu_submit_int_urb(struct ieee80211_hw *hw)
 	rtl8xxxu_write32(priv, REG_USB_HIMR, val32);
 
 error:
+	usb_free_urb(urb);
 	return ret;
 }
 
@@ -5424,6 +5424,7 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct rtl8xxxu_rx_urb *rx_urb;
 	struct rtl8xxxu_tx_urb *tx_urb;
+	struct sk_buff *skb;
 	unsigned long flags;
 	int ret, i;
 
@@ -5472,6 +5473,13 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 		rx_urb->hw = hw;
 
 		ret = rtl8xxxu_submit_rx_urb(priv, rx_urb);
+		if (ret) {
+			if (ret != -ENOMEM) {
+				skb = (struct sk_buff *)rx_urb->urb.context;
+				dev_kfree_skb(skb);
+			}
+			rtl8xxxu_queue_rx_urb(priv, rx_urb);
+		}
 	}
 exit:
 	/*
-- 
2.25.1

