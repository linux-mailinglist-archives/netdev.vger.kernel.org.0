Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9B53E3576
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 15:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbhHGNJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 09:09:28 -0400
Received: from smtp-32.italiaonline.it ([213.209.10.32]:44067 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232226AbhHGNJZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 09:09:25 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([82.60.87.158])
        by smtp-32.iol.local with ESMTPA
        id CM3WmQm3XPvRTCM3cmIfZ4; Sat, 07 Aug 2021 15:08:08 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1628341688; bh=qcQQKkpQcTduRVA/CnmRQITGUWlSeT/brnZTnXQ+50c=;
        h=From;
        b=gNXMP5g8mcUSeTr+UsiRu0FcPlG8lvMhLc0HivVzUtgdjJnMjCu4FdIHqXnSoXjEO
         /9RPyLU6Pkcpcl8HVre90o9A3yDkjxGYqOdby9OClniPRYvJj2zgFGBi7kHFHgY4SB
         LTeoRuCdpeNJwsth9cKDAc9JITooyUOoB/huDjK9PRuuRpz2mpfaSz4Iu4Gfo4fKyE
         RmqMFY0Oy7i+Tc39BmJcBGOCjdEWc1SeKZdFuDKG1782SrW2M0JwQo2NFYFFlzAJOP
         sTnZXyE07cfEBM16eSkNAs9spuxTB+CMGMDjIM+3o1kV1oySKbb7ZYTCatB+g6wAt+
         9UcRdy6U70uvw==
X-CNFS-Analysis: v=2.4 cv=NqgUz+RJ c=1 sm=1 tr=0 ts=610e85b8 cx=a_exe
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
Subject: [PATCH v3 2/4] can: c_can: exit c_can_do_tx() early if no frames have been sent
Date:   Sat,  7 Aug 2021 15:07:58 +0200
Message-Id: <20210807130800.5246-3-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210807130800.5246-1-dariobin@libero.it>
References: <20210807130800.5246-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfFXjyjkSSREEemsSXHD6ghKK6Ear5v3Gm1j9QSAtbp+ZLi0S+dxRbwa1ixcbKnNpPW9G15s+HZxGOUSaQCbbhZ2TQURMi8QBGm6Z54yoHyPdL3QXcVNP
 BMiNJz8LTXzQtOjmHx2DGyNucM60bl0VQXUxG+aANmgHbpd+u8SoVLDRdxIRLejPEEAuQ6Dvesb6kPHJXQ1G62S0+DikujHvIa9JIBJp/au1CHnHj0GaTiYk
 u3awC2snpN5WVznLBOIl2MtJsoXQTlWmSO21ILaZAZIG5STGS9UynV5JU2q36XwSkwxDzksuO5lljJSLcZMaKaZbpGCMivkE53WDJv6aWD3LtEyIMHJ0uTHm
 wm5LnBnqugQ84EiBwQMO+9Orm7GNuv9d9G8t+xFWuDmhvBKlaXnp5oXhBiRrbwbaQrPuIEkVD2+h+DYNdOKsqVSyu7W/w1I2OEdZ8qhlIEvfRHuaqf3eddtR
 /iVFbBCI4vTJxx4+OERoF/OmDUMV+C+iFNWC0LDzARgSe0gVeQV3VthKNrjPtuP4+d8nDd+r7Jub3F14t/Ep2kD8M6A8Po8oWjNxhg==
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

