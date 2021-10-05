Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1175942301E
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 20:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbhJESjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 14:39:49 -0400
Received: from ch3vs03.rockwellcollins.com ([205.175.226.47]:37686 "EHLO
        ch3vs03.rockwellcollins.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhJESjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 14:39:48 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Oct 2021 14:39:48 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=rockwellcollins.com; s=hrcrc2020;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KnwWS8FxXuoDgDDRlM7P5scofOq7+jfHg9Cs3y6jq5E=;
  b=rBTp802gP1HQZIHecSVzcp8H0WNOmElvKX9j5ygPUJL82c6wRNk4Udh1
   givVUvZjay8v4+WwSuhXG1efnjcUcnmKoO+K8DscjHZFN5cR39VNj4bEy
   eP7SqS1xwYsscWd8wQ9bOQsBIW/YRNPCCK30EiqpVamgqz3RRe3PDyOSA
   dacsOYKjQDsAmZ5yI6czaSTyu8gM+XrIbUgQ6NAVquPeYjOpvustvdnIa
   qUaoE4LwdOeD9UCxETh9msEkjn6KLxB6KJyMJYzaREHycYxwmSIC4rBpO
   7wOHAsNmAmMlHnuoFsuOr+/O8mBf8sOEftj0Riuc4PBOo1UclUCc1Terg
   w==;
IronPort-SDR: rkO7ETqPYBTFbL3KKFATaFVfS96dZm5FYwzuP2qG5qayGYRh/rCwTExBt5v7lcwAGZ4fEacaEs
 6pfzbCZ9bMBk4DuAXlk6C+kgAMx/rFIwwOcPI6U0ZK00ZEjrvhN8MeNRMBWvCoDkFX1lKQ49Ro
 pNROYUmlIF53zNy3yjz450idAgvvN+ld/rYYYDCYaPAjyUYAYZ4AW0Hlg+un7eORHf/aGOoISG
 VnnTpqYCMjcFd4IYpR2WKyrjf8SuLtGxj2nEJb3gYVFBBpIY0f+3IX7PCGu8fNUmzrSSVH1mza
 N6Y=
Received: from ofwch3n02.rockwellcollins.com (HELO crulimr01.rockwellcollins.com) ([205.175.226.14])
  by ch3vs03.rockwellcollins.com with ESMTP; 05 Oct 2021 13:30:49 -0500
X-Received: from righttwix.rockwellcollins.com (righttwix.rockwellcollins.com [192.168.141.218])
        by crulimr01.rockwellcollins.com (Postfix) with ESMTP id 5ED8B6038E;
        Tue,  5 Oct 2021 13:30:48 -0500 (CDT)
From:   Brandon Maier <brandon.maier@rockwellcollins.com>
Cc:     Brandon Maier <brandon.maier@rockwellcollins.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        linux-can@vger.kernel.org (open list:CAN NETWORK DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Microchip
        (AT91) SoC support), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] can: at91_can: fix passive-state AERR flooding
Date:   Tue,  5 Oct 2021 13:30:23 -0500
Message-Id: <20211005183023.109328-1-brandon.maier@rockwellcollins.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the at91_can is a single node on the bus and a user attempts to
transmit, the can state machine will report ack errors and increment the
transmit error count until it reaches the passive-state. Per the
specification, it will then transmit with a passive error, but will stop
incrementing the transmit error count. This results in the host machine
being flooded with the AERR interrupt forever, or until another node
rejoins the bus.

To prevent the AERR flooding, disable the AERR interrupt when we are in
passive mode.

Signed-off-by: Brandon Maier <brandon.maier@rockwellcollins.com>
---
 drivers/net/can/at91_can.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index b06af90a9964..2a8831127bd0 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -804,8 +804,13 @@ static int at91_poll(struct napi_struct *napi, int quota)
 		work_done += at91_poll_err(dev, quota - work_done, reg_sr);
 
 	if (work_done < quota) {
-		/* enable IRQs for frame errors and all mailboxes >= rx_next */
+		/* enable IRQs for frame errors and all mailboxes >= rx_next,
+		 * disable the ack error in passive mode to avoid flooding
+		 * ourselves with interrupts
+		 */
 		u32 reg_ier = AT91_IRQ_ERR_FRAME;
+		if (priv->can.state == CAN_STATE_ERROR_PASSIVE)
+			reg_ier &= ~AT91_IRQ_AERR;
 
 		reg_ier |= get_irq_mb_rx(priv) & ~AT91_MB_MASK(priv->rx_next);
 
-- 
2.30.2

