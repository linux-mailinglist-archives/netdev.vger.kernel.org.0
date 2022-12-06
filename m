Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834816440CD
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbiLFJzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235420AbiLFJyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:54:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0DA6BC17;
        Tue,  6 Dec 2022 01:51:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5180DB818E6;
        Tue,  6 Dec 2022 09:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4C2C433C1;
        Tue,  6 Dec 2022 09:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320300;
        bh=by8EIrRFiCA2mRPRK7UEG8OQ6u8OKYhIvmx0lZbHBzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nq0GoAcJ4q4YmM/TSX2n2K9NbdpK2LEt0PQyzltcwDIDwYqv9SpCP8vSZHC6HWfSu
         CdXBvT2HF+ORNxH34pX22fH/OMns1jiJoiKGcmRw0d8YoUKmrDbqNNQN57v76oY/2o
         HdOBWnCVazV+KPzhKTY0ObzXxD6Qe4wO6kgnxNjcsyQuPzLgF1daLoKrgCUy/gNSxw
         0VVQPSoBlwHtXMAsLSsq8u3jMl7eWezUkqRTuq6V1nM/L/zsZYOa7DMQEbX1ojxjGg
         3cWTqHUkcd/edzsGtl+Gb/G3HHF9DaoNTNMYeUceMY+3S3QbyQ28L44OYPB0TYBhpM
         pY86GolrKDJIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yasushi SHOJI <yasushi.shoji@gmail.com>,
        Yasushi SHOJI <yashi@spacecubics.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, wg@grandegger.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mailhol.vincent@wanadoo.fr,
        stefan.maetje@esd.eu, socketcan@hartkopp.net, hbh25y@gmail.com,
        paskripkin@gmail.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 3/4] can: mcba_usb: Fix termination command argument
Date:   Tue,  6 Dec 2022 04:51:27 -0500
Message-Id: <20221206095128.987873-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221206095128.987873-1-sashal@kernel.org>
References: <20221206095128.987873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yasushi SHOJI <yasushi.shoji@gmail.com>

[ Upstream commit 1a8e3bd25f1e789c8154e11ea24dc3ec5a4c1da0 ]

Microchip USB Analyzer can activate the internal termination resistors
by setting the "termination" option ON, or OFF to to deactivate them.
As I've observed, both with my oscilloscope and captured USB packets
below, you must send "0" to turn it ON, and "1" to turn it OFF.

From the schematics in the user's guide, I can confirm that you must
drive the CAN_RES signal LOW "0" to activate the resistors.

Reverse the argument value of usb_msg.termination to fix this.

These are the two commands sequence, ON then OFF.

> No.     Time           Source                Destination           Protocol Length Info
>       1 0.000000       host                  1.3.1                 USB      46     URB_BULK out
>
> Frame 1: 46 bytes on wire (368 bits), 46 bytes captured (368 bits)
> USB URB
> Leftover Capture Data: a80000000000000000000000000000000000a8
>
> No.     Time           Source                Destination           Protocol Length Info
>       2 4.372547       host                  1.3.1                 USB      46     URB_BULK out
>
> Frame 2: 46 bytes on wire (368 bits), 46 bytes captured (368 bits)
> USB URB
> Leftover Capture Data: a80100000000000000000000000000000000a9

Signed-off-by: Yasushi SHOJI <yashi@spacecubics.com>
Link: https://lore.kernel.org/all/20221124152504.125994-1-yashi@spacecubics.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/mcba_usb.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index f7c3fc3dabfe..01ef5cabdc11 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -58,6 +58,10 @@
 #define MCBA_VER_REQ_USB 1
 #define MCBA_VER_REQ_CAN 2
 
+/* Drive the CAN_RES signal LOW "0" to activate R24 and R25 */
+#define MCBA_VER_TERMINATION_ON 0
+#define MCBA_VER_TERMINATION_OFF 1
+
 #define MCBA_SIDL_EXID_MASK 0x8
 #define MCBA_DLC_MASK 0xf
 #define MCBA_DLC_RTR_MASK 0x40
@@ -480,7 +484,7 @@ static void mcba_usb_process_ka_usb(struct mcba_priv *priv,
 		priv->usb_ka_first_pass = false;
 	}
 
-	if (msg->termination_state)
+	if (msg->termination_state == MCBA_VER_TERMINATION_ON)
 		priv->can.termination = MCBA_TERMINATION_ENABLED;
 	else
 		priv->can.termination = MCBA_TERMINATION_DISABLED;
@@ -800,9 +804,9 @@ static int mcba_set_termination(struct net_device *netdev, u16 term)
 	};
 
 	if (term == MCBA_TERMINATION_ENABLED)
-		usb_msg.termination = 1;
+		usb_msg.termination = MCBA_VER_TERMINATION_ON;
 	else
-		usb_msg.termination = 0;
+		usb_msg.termination = MCBA_VER_TERMINATION_OFF;
 
 	mcba_usb_xmit_cmd(priv, (struct mcba_usb_msg *)&usb_msg);
 
-- 
2.35.1

