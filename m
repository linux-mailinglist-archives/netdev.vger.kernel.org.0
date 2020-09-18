Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0528F26F418
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbgIRDLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 23:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgIRCCV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:02:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 866A3235FD;
        Fri, 18 Sep 2020 02:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394540;
        bh=JABLUdjNq2imK1wjeCunrhCzek4I+Lgbd0ewlVoivLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KH9k5XVOfAQpnXr8hpao/KyqO8RSUO8JZhFP8zojlpHBinJS7/5xaK8BrFOBYKjXl
         rP4WkIPtKrtl+vMnZRPDVvq77/VqeOO/nltI1fh8UUK2D3jImolZDjIYbz38ypXBN4
         HouTW19P9zfVGwrG2y85v7bH/eWRd68p147z1KVI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 058/330] mt76: do not use devm API for led classdev
Date:   Thu, 17 Sep 2020 21:56:38 -0400
Message-Id: <20200918020110.2063155-58-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 36f7e2b2bb1de86f0072cd49ca93d82b9e8fd894 ]

With the devm API, the unregister happens after the device cleanup is done,
after which the struct mt76_dev which contains the led_cdev has already been
freed. This leads to a use-after-free bug that can crash the system.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 1a2c143b34d01..7be5806a1c398 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -105,7 +105,15 @@ static int mt76_led_init(struct mt76_dev *dev)
 		dev->led_al = of_property_read_bool(np, "led-active-low");
 	}
 
-	return devm_led_classdev_register(dev->dev, &dev->led_cdev);
+	return led_classdev_register(dev->dev, &dev->led_cdev);
+}
+
+static void mt76_led_cleanup(struct mt76_dev *dev)
+{
+	if (!dev->led_cdev.brightness_set && !dev->led_cdev.blink_set)
+		return;
+
+	led_classdev_unregister(&dev->led_cdev);
 }
 
 static void mt76_init_stream_cap(struct mt76_dev *dev,
@@ -360,6 +368,7 @@ void mt76_unregister_device(struct mt76_dev *dev)
 {
 	struct ieee80211_hw *hw = dev->hw;
 
+	mt76_led_cleanup(dev);
 	mt76_tx_status_check(dev, NULL, true);
 	ieee80211_unregister_hw(hw);
 }
-- 
2.25.1

