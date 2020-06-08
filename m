Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733041F24FA
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731615AbgFHXYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:24:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729292AbgFHXYT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:24:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E6712089D;
        Mon,  8 Jun 2020 23:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658659;
        bh=Te9F/yrPuD9RjkO3+zwkcMIepHyknzxLlgjxALhWRIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w3xfyooWSQ2V0worS9/cdvnmvl+79vXG4+739rxs030gKvmI70CC+3fkoyhEeTNVk
         JXeGbTPwTfRewvpWBbaNBdJrZIGmn8OWyOavSZmyS8t2FlmIv/hYdzs0AOsRLNhYx/
         2XGB0kkDHXGu+BDk0tlYZza42pw+6vGBZMQf/LFw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 076/106] rtlwifi: Fix a double free in _rtl_usb_tx_urb_setup()
Date:   Mon,  8 Jun 2020 19:22:08 -0400
Message-Id: <20200608232238.3368589-76-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232238.3368589-1-sashal@kernel.org>
References: <20200608232238.3368589-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit beb12813bc75d4a23de43b85ad1c7cb28d27631e ]

Seven years ago we tried to fix a leak but actually introduced a double
free instead.  It was an understandable mistake because the code was a
bit confusing and the free was done in the wrong place.  The "skb"
pointer is freed in both _rtl_usb_tx_urb_setup() and _rtl_usb_transmit().
The free belongs _rtl_usb_transmit() instead of _rtl_usb_tx_urb_setup()
and I've cleaned the code up a bit to hopefully make it more clear.

Fixes: 36ef0b473fbf ("rtlwifi: usb: add missing freeing of skbuff")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200513093951.GD347693@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 1181b725f503..1893640555c1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -910,10 +910,8 @@ static struct urb *_rtl_usb_tx_urb_setup(struct ieee80211_hw *hw,
 
 	WARN_ON(NULL == skb);
 	_urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!_urb) {
-		kfree_skb(skb);
+	if (!_urb)
 		return NULL;
-	}
 	_rtl_install_trx_info(rtlusb, skb, ep_num);
 	usb_fill_bulk_urb(_urb, rtlusb->udev, usb_sndbulkpipe(rtlusb->udev,
 			  ep_num), skb->data, skb->len, _rtl_tx_complete, skb);
@@ -927,7 +925,6 @@ static void _rtl_usb_transmit(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 	u32 ep_num;
 	struct urb *_urb = NULL;
-	struct sk_buff *_skb = NULL;
 
 	WARN_ON(NULL == rtlusb->usb_tx_aggregate_hdl);
 	if (unlikely(IS_USB_STOP(rtlusb))) {
@@ -936,8 +933,7 @@ static void _rtl_usb_transmit(struct ieee80211_hw *hw, struct sk_buff *skb,
 		return;
 	}
 	ep_num = rtlusb->ep_map.ep_mapping[qnum];
-	_skb = skb;
-	_urb = _rtl_usb_tx_urb_setup(hw, _skb, ep_num);
+	_urb = _rtl_usb_tx_urb_setup(hw, skb, ep_num);
 	if (unlikely(!_urb)) {
 		pr_err("Can't allocate urb. Drop skb!\n");
 		kfree_skb(skb);
-- 
2.25.1

