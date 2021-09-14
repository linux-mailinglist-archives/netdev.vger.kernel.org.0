Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696E640B828
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 21:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbhINTfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 15:35:00 -0400
Received: from mail.aperture-lab.de ([116.203.183.178]:44930 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbhINTey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 15:34:54 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id D4D2641015;
        Tue, 14 Sep 2021 21:25:34 +0200 (CEST)
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@nbd.name>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        ath9k-devel@qca.qualcomm.com
Cc:     linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W . Linville" <linville@tuxdriver.com>,
        Felix Fietkau <nbd@openwrt.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <ll@simonwunderlich.de>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: [PATCH 3/3] ath9k: Fix potential hw interrupt resume during reset
Date:   Tue, 14 Sep 2021 21:25:15 +0200
Message-Id: <20210914192515.9273-4-linus.luessing@c0d3.blue>
In-Reply-To: <20210914192515.9273-1-linus.luessing@c0d3.blue>
References: <20210914192515.9273-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Lüssing <ll@simonwunderlich.de>

There is a small risk of the ath9k hw interrupts being reenabled in the
following way:

1) ath_reset_internal()
   ...
   -> disable_irq()
      ...
      <- returns

                      2) ath9k_tasklet()
                         ...
                         -> ath9k_hw_resume_interrupts()
                         ...

1) ath_reset_internal() continued:
   -> tasklet_disable(&sc->intr_tq); (= ath9k_tasklet() off)

By first disabling the ath9k interrupt there is a small window
afterwards which allows ath9k hw interrupts being reenabled through
the ath9k_tasklet() before we disable this tasklet in
ath_reset_internal(). Leading to having the ath9k hw interrupts enabled
during the reset, which we should avoid.

Fixing this by first disabling all ath9k tasklets. And only after
they are not running anymore also disabling the overall ath9k interrupt.

Either ath9k_queue_reset()->ath9k_kill_hw_interrupts() or
ath_reset_internal()->disable_irq()->ath_isr()->ath9k_kill_hw_interrupts()
should then have ensured that no ath9k hw interrupts are running during
the actual ath9k reset.

We could reproduce this issue with two Lima boards from 8devices
(QCA4531) on OpenWrt 19.07 while sending UDP traffic between the two and
triggering an ath9k_queue_reset() and with added msleep()s between
disable_irq() and tasklet_disable() in ath_reset_internal().

Cc: Sven Eckelmann <sven@narfation.org>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Linus Lüssing <linus.luessing@c0d3.blue>
Fixes: e3f31175a3ee ("ath9k: fix race condition in irq processing during hardware reset")
Signed-off-by: Linus Lüssing <ll@simonwunderlich.de>
---
 drivers/net/wireless/ath/ath9k/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 98090e40e1cf..b9f9a8ae3b56 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -292,9 +292,9 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
 
 	__ath_cancel_work(sc);
 
-	disable_irq(sc->irq);
 	tasklet_disable(&sc->intr_tq);
 	tasklet_disable(&sc->bcon_tasklet);
+	disable_irq(sc->irq);
 	spin_lock_bh(&sc->sc_pcu_lock);
 
 	if (!sc->cur_chan->offchannel) {
-- 
2.31.0

