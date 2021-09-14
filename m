Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9C640B81E
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 21:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbhINTe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 15:34:57 -0400
Received: from mail.aperture-lab.de ([116.203.183.178]:44902 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbhINTey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 15:34:54 -0400
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Sep 2021 15:34:53 EDT
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 173B841012;
        Tue, 14 Sep 2021 21:25:33 +0200 (CEST)
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
Subject: [PATCH 2/3] ath9k: Fix potential interrupt storm on queue reset
Date:   Tue, 14 Sep 2021 21:25:14 +0200
Message-Id: <20210914192515.9273-3-linus.luessing@c0d3.blue>
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

In tests with two Lima boards from 8devices (QCA4531 based) on OpenWrt
19.07 we could force a silent restart of a device with no serial
output when we were sending a high amount of UDP traffic (iperf3 at 80
MBit/s in both directions from external hosts, saturating the wifi and
causing a load of about 4.5 to 6) and were then triggering an
ath9k_queue_reset().

Further debugging showed that the restart was caused by the ath79
watchdog. With disabled watchdog we could observe that the device was
constantly going into ath_isr() interrupt handler and was returning
early after the ATH_OP_HW_RESET flag test, without clearing any
interrupts. Even though ath9k_queue_reset() calls
ath9k_hw_kill_interrupts().

With JTAG we could observe the following race condition:

1) ath9k_queue_reset()
   ...
   -> ath9k_hw_kill_interrupts()
   -> set_bit(ATH_OP_HW_RESET, &common->op_flags);
   ...
   <- returns

      2) ath9k_tasklet()
         ...
         -> ath9k_hw_resume_interrupts()
         ...
         <- returns

                 3) loops around:
                    ...
                    handle_int()
                    -> ath_isr()
                       ...
                       -> if (test_bit(ATH_OP_HW_RESET,
                                       &common->op_flags))
                            return IRQ_HANDLED;

                    x) ath_reset_internal():
                       => never reached <=

And in ath_isr() we would typically see the following interrupts /
interrupt causes:

* status: 0x00111030 or 0x00110030
* async_cause: 2 (AR_INTR_MAC_IPQ)
* sync_cause: 0

So the ath9k_tasklet() reenables the ath9k interrupts
through ath9k_hw_resume_interrupts() which ath9k_queue_reset() had just
disabled. And ath_isr() then keeps firing because it returns IRQ_HANDLED
without actually clearing the interrupt.

To fix this IRQ storm also clear/disable the interrupts again when we
are in reset state.

Cc: Sven Eckelmann <sven@narfation.org>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Linus Lüssing <linus.luessing@c0d3.blue>
Fixes: 872b5d814f99 ("ath9k: do not access hardware on IRQs during reset")
Signed-off-by: Linus Lüssing <ll@simonwunderlich.de>
---
 drivers/net/wireless/ath/ath9k/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 139831539da3..98090e40e1cf 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -533,8 +533,10 @@ irqreturn_t ath_isr(int irq, void *dev)
 	ath9k_debug_sync_cause(sc, sync_cause);
 	status &= ah->imask;	/* discard unasked-for bits */
 
-	if (test_bit(ATH_OP_HW_RESET, &common->op_flags))
+	if (test_bit(ATH_OP_HW_RESET, &common->op_flags)) {
+		ath9k_hw_kill_interrupts(sc->sc_ah);
 		return IRQ_HANDLED;
+	}
 
 	/*
 	 * If there are no status bits set, then this interrupt was not
-- 
2.31.0

