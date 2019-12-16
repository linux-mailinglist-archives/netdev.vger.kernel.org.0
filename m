Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 448891206F3
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 14:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbfLPNTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 08:19:35 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:36633 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727653AbfLPNTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 08:19:35 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1Myb8N-1hmQPH0w85-00yyN5; Mon, 16 Dec 2019 14:19:06 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Ryder Lee <ryder.lee@mediatek.com>,
        Roy Luo <royluo@google.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt76: fix LED link time failure
Date:   Mon, 16 Dec 2019 14:18:42 +0100
Message-Id: <20191216131902.3251040-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:FfIXsVXcNeBt8DM3/oD14gV9AaEg1kuMd8THyqz4/RSYXt8bzol
 VT4nBhvNIR65oxPVAJBoQCx0Mg5xsmZZG4yY3iGDfIiztAFr9RRwyuwPZKCC1hP2Ebc2X1g
 FX+vENnYZfUQsOedDzvoVbIxv6rRVM10x3+jQQ75bdj2i/k+bC7y4tgiHPKrg398sgXI1Hk
 CLe6qn9H88bpgLmlWv4pw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:iAZnidCZDMU=:WDeq3eS82GM9y63nrZiRmo
 3JUG+UEbatz6cBmivM2B7+tBfsLXMZPjHyLnrYgr8AQyO4VWAWkAXvdINXftuV1yV9kOT2rJu
 rFD+Nb3NkNJP8T0W6aM3QVe+3hkwqidu4Qhbd7gcSGqEBJEJ1wEmoI5q3AWpjo4SVRh8BY/n8
 1+v+yWdQEGSsYoAMpz0Q1pIWrsWpqQH59RXvBqCkFqpBg55DuFUvLAKZEnScfkj0zIDN9Sgh9
 y8edPkXPZocBM/alaots63k5Bc2TPiRiRqRs+U63biMkj68b47s3D6euxclI+ZalStQg9kw+t
 ltbSCk2Y5gaZ0nKKOX9lNNTof0DsU+auYJNy6RLT9k0pOwQ4VA2fXM1jzReLUS0jM/krpArf8
 uWGrdBr2/oEAAhhmoD7+dtqG+po7AwkTWOJYCDELxbGHPkKCDKPL7nOScNrIVqIO9hJA3XFwx
 OwY458CCIgKVJrBZKeI4EqLCmBs0J33fFkJcFCHjT1OWO8EBfmbv4nij7kY56kIynKxQRLJi6
 EbqKgPjtXCx92W+gDjbgHclBHuonNeSJXn1wm1FG2xglOPqs3qH5324sYq6NlZeehhTGpudYM
 gyV9UmJ+mEXBCI2NyjMtMLnyfRn72odkyFt6/CC82Lz4MCI3EKl8sWGx1y8G9G41Vj2GPmPUN
 pNjMciMVw6LVfiIKdJFboThBK+H2qcvbEszQ69sDfbLW3KUmmjMRmksX3R5XlgWcO/1lWCQnk
 h7NruKmPzsF471JVvfDsgChsoHsHBMUZQN3WT7y3wNhZtPFNmNa7aQovOOtyklkh7XhJHfyaJ
 nFkOl56Fng8tuNQkCDI+XFmo/EQGsS8UfUm8JRGCi1clYe0Kv1fT8B8zoCvK+9Wy7uvds+1QB
 fTcUteDG3KZFdJlzhPOw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index b9f2a401041a..96018fd65779 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -378,7 +378,8 @@ void mt76_unregister_device(struct mt76_dev *dev)
 {
 	struct ieee80211_hw *hw = dev->hw;
 
-	mt76_led_cleanup(dev);
+	if (IS_ENABLED(CONFIG_MT76_LEDS))
+		mt76_led_cleanup(dev);
 	mt76_tx_status_check(dev, NULL, true);
 	ieee80211_unregister_hw(hw);
 }
-- 
2.20.0

