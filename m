Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72573E1D47
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 22:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240906AbhHEUUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 16:20:33 -0400
Received: from smtp-32-i2.italiaonline.it ([213.209.12.32]:41649 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237843AbhHEUUb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 16:20:31 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([82.60.87.158])
        by smtp-32.iol.local with ESMTPA
        id BjpbmFmMJPvRTBjpjmCR70; Thu, 05 Aug 2021 22:19:16 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1628194756; bh=qcQQKkpQcTduRVA/CnmRQITGUWlSeT/brnZTnXQ+50c=;
        h=From;
        b=GzAQNqli3bWtvD9DgV9xTgjc1bJTbClacwkB4m9tRjibPiGMdLbDsvsOENrHkg0Ia
         4jZFdjUGVeqzGWAJo1kynFjmIF25HWstM50KRI7kIsOionZjJp25TpwKDx7HZ9DzfV
         RAelh/+3jWR9tTuWzmg9xGS1/TCKFTgmJR3kGgQeQDO5PnMRKrOtdyvU81rVMK9TkD
         bKTBFN5g/b9Z4dzxH5ivhuq2+PRuslTpvesDlSEaxzlgf6DTw24SZ86vqNUHl5QTHG
         ja6rMYNldMRHuZoe6xoE5M9N5Uhml5UHHWbupkJwVBnBP26ucnmCRkLdGQG1Y1gk3C
         iSXus3fn+loqg==
X-CNFS-Analysis: v=2.4 cv=NqgUz+RJ c=1 sm=1 tr=0 ts=610c47c4 cx=a_exe
 a=Hc/BMeSBGyun2kpB8NmEvQ==:117 a=Hc/BMeSBGyun2kpB8NmEvQ==:17
 a=0RFnQWo-as75lT-uasUA:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Gianluca Falavigna <gianluca.falavigna@inwind.it>,
        Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 2/4] can: c_can: exit c_can_do_tx() early if no frames have been sent
Date:   Thu,  5 Aug 2021 22:18:58 +0200
Message-Id: <20210805201900.23146-3-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210805201900.23146-1-dariobin@libero.it>
References: <20210805201900.23146-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfAY5jB3WrvVVZB1Q1PG+JkDdpY8NeAdm9vIJRrvNabX/L2fFK8vmpvxXwQKDqMo/dqtvo1TkLW41Yukm3C6wzcGccb56RW8qbQuDQ/zXY27Wqc7MeZcL
 Dwdl7VzqbT09bAJ7gw/8Z9K/uTZlKq6NnteKkWNonWpgaPianhqloNqA/QjWcmSQSemjcrGcYpec/Y0wttt2CUZpmtEm9qN78Tz7OKyhnFe8rxxe66I/t4E6
 ahBD6xnu4ERp/4b1mBGQ8dYnRN/TmghFLG0QER43gehXB9CuCfRBBPzvRrt0g3GoH5dEEv4465OBrCi2CJ2Opp7CgfvKzembAuykdyw2CF3JILJrkCnXZqRY
 uSdHhBs2PfzoJhp9uenOmwz2iUekYsdOlzhYKaDdt/vHzqbNEddHgHjdF7hh43eMz/Gr+phW+ZuiaTyEshar5fiBoxls8KkQFluyKvhurRgcri1W7M6iEbV5
 54W4PhUgcxLX1ptSicmUHqF2c/NM3xh57kLiKwELJnE87bGLa7KWC9fzX87DREuMNphytXXyOBhGG7FDfJhYWxHm8haEYMSqAlAX2g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The c_can_poll() handles RX/TX events unconditionally. It may therefore
happen that c_can_do_tx() is called unnecessarily because the interrupt
was triggered by the reception of a frame. In these cases, we avoid to
execute unnecessary statements and exit immediately.

Signed-off-by: Dario Binacchi <dariobin@libero.it>
---

(no changes since v1)

 drivers/net/can/c_can/c_can_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
index 7588f70ca0fe..fec0e3416970 100644
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -720,17 +720,18 @@ static void c_can_do_tx(struct net_device *dev)
 		pkts++;
 	}
 
+	if (!pkts)
+		return;
+
 	/* Clear the bits in the tx_active mask */
 	atomic_sub(clr, &priv->tx_active);
 
 	if (clr & BIT(priv->msg_obj_tx_num - 1))
 		netif_wake_queue(dev);
 
-	if (pkts) {
-		stats->tx_bytes += bytes;
-		stats->tx_packets += pkts;
-		can_led_event(dev, CAN_LED_EVENT_TX);
-	}
+	stats->tx_bytes += bytes;
+	stats->tx_packets += pkts;
+	can_led_event(dev, CAN_LED_EVENT_TX);
 }
 
 /* If we have a gap in the pending bits, that means we either
-- 
2.17.1

