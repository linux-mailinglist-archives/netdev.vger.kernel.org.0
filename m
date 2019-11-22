Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92C72106224
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbfKVGBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:01:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729119AbfKVGBp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 01:01:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99FE82068E;
        Fri, 22 Nov 2019 06:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402504;
        bh=bj6XBP8ylTa1ul4GAmiTOHUvhP1gVcBdVe0nXVxbj4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hmwZ6CSSZc4fyQujx401ytqLaMJklRvXk1TDo6mpMwiXo3aLLdSkp6+qIAVJC9GuV
         D29wc0qMzuKpVKUIElHeKXtUWPIeYaGzf8vOJYpoPr7xMnECXlDzDMVckByjkayAbS
         dSw/kj2frskpctdS88FJpfwlbgWch2NNbLgSyyeE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Bian <bianpan2016@163.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 14/91] rtl818x: fix potential use after free
Date:   Fri, 22 Nov 2019 01:00:12 -0500
Message-Id: <20191122060129.4239-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit afbb1947db94eacc5a13302eee88a9772fb78935 ]

entry is released via usb_put_urb just after calling usb_submit_urb.
However, entry is used if the submission fails, resulting in a use after
free bug. The patch fixes this.

Signed-off-by: Pan Bian <bianpan2016@163.com>
ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
index 6113624ccec39..17e3d5e830626 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
@@ -446,12 +446,13 @@ static int rtl8187_init_urbs(struct ieee80211_hw *dev)
 		skb_queue_tail(&priv->rx_queue, skb);
 		usb_anchor_urb(entry, &priv->anchored);
 		ret = usb_submit_urb(entry, GFP_KERNEL);
-		usb_put_urb(entry);
 		if (ret) {
 			skb_unlink(skb, &priv->rx_queue);
 			usb_unanchor_urb(entry);
+			usb_put_urb(entry);
 			goto err;
 		}
+		usb_put_urb(entry);
 	}
 	return ret;
 
-- 
2.20.1

