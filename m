Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9069026F1B8
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgIRCxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:53:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728009AbgIRCHx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28697238E3;
        Fri, 18 Sep 2020 02:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394873;
        bh=gpve+ix1TNFA73P/2Os4vBWUlyekpeWuT9lTKuaZeNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TXCyT0ldKmK4JesZf39P1yxMpT5fZLUYqb4OO4jw8/al0uMttGe2TeP3BfqPMjV+a
         +BNoip66qIcuNB+pfQ3Nl4qqrCFDFIr/0HzCB6JOOSse5kavivrGf2RLe9GQ+X9YZT
         gdbm2HVkrX4r7eKzvtN8T2/FRsI0C34EFLDTGjMk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Felix Fietkau <nbd@nbd.name>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 324/330] mt76: fix LED link time failure
Date:   Thu, 17 Sep 2020 22:01:04 -0400
Message-Id: <20200918020110.2063155-324-sashal@kernel.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d68f4e43a46ff1f772ff73085f96d44eb4163e9d ]

The mt76_led_cleanup() function is called unconditionally, which
leads to a link error when CONFIG_LEDS is a loadable module or
disabled but mt76 is built-in:

drivers/net/wireless/mediatek/mt76/mac80211.o: In function `mt76_unregister_device':
mac80211.c:(.text+0x2ac): undefined reference to `led_classdev_unregister'

Use the same trick that is guarding the registration, using an
IS_ENABLED() check for the CONFIG_MT76_LEDS symbol that indicates
whether LEDs can be used or not.

Fixes: 36f7e2b2bb1d ("mt76: do not use devm API for led classdev")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 7be5806a1c398..8bd191347b9fb 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -368,7 +368,8 @@ void mt76_unregister_device(struct mt76_dev *dev)
 {
 	struct ieee80211_hw *hw = dev->hw;
 
-	mt76_led_cleanup(dev);
+	if (IS_ENABLED(CONFIG_MT76_LEDS))
+		mt76_led_cleanup(dev);
 	mt76_tx_status_check(dev, NULL, true);
 	ieee80211_unregister_hw(hw);
 }
-- 
2.25.1

