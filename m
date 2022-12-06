Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE5A644080
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235552AbiLFJwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235428AbiLFJv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:51:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632F723BDF;
        Tue,  6 Dec 2022 01:51:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A0B6B818E5;
        Tue,  6 Dec 2022 09:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD5AC43153;
        Tue,  6 Dec 2022 09:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320269;
        bh=Lt44xPPov+RSM3DNnOcCu/JmyRt0sMPqxhJUI7WPPuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KqTEhPmKaazqPG+wBFarjZvnv0FWTkZ63ntWsHMxspV9ZfoKAjG2jyzckvgmY3aH+
         bRqWUz37aq6+rnoM14+aOxDDcYFZv+t8cSWHB3bgfTckwAwHT2f3wjOzU9Fyf1Lmj9
         EEALWsezEPYE8iTWuT74JQYf7Bc4ahKrsDVhY8X22ZrZxRjvfibMxG4+XE+JPTR3e7
         TKZ71p0g7bxLFmd12CPrBjGP89m3co1u/FQuQSRF3cQsnqwJZbSH9UIy9ibtY81wcf
         sIAYs2r8HcxfamzValA2Tb2YFTeh5cOzvdC/MfPBv1kfJbgnf+TASDtfcCUB9FS+2d
         HJCt+ardsfn+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yasushi SHOJI <yasushi.shoji@gmail.com>,
        Yasushi SHOJI <yashi@spacecubics.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, wg@grandegger.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, stefan.maetje@esd.eu, paskripkin@gmail.com,
        hbh25y@gmail.com, linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 4/5] can: mcba_usb: Fix termination command argument
Date:   Tue,  6 Dec 2022 04:50:54 -0500
Message-Id: <20221206095055.987728-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221206095055.987728-1-sashal@kernel.org>
References: <20221206095055.987728-1-sashal@kernel.org>
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
index 957e51a77d4d..16fb4fc26518 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -47,6 +47,10 @@
 #define MCBA_VER_REQ_USB 1
 #define MCBA_VER_REQ_CAN 2
 
+/* Drive the CAN_RES signal LOW "0" to activate R24 and R25 */
+#define MCBA_VER_TERMINATION_ON 0
+#define MCBA_VER_TERMINATION_OFF 1
+
 #define MCBA_SIDL_EXID_MASK 0x8
 #define MCBA_DLC_MASK 0xf
 #define MCBA_DLC_RTR_MASK 0x40
@@ -469,7 +473,7 @@ static void mcba_usb_process_ka_usb(struct mcba_priv *priv,
 		priv->usb_ka_first_pass = false;
 	}
 
-	if (msg->termination_state)
+	if (msg->termination_state == MCBA_VER_TERMINATION_ON)
 		priv->can.termination = MCBA_TERMINATION_ENABLED;
 	else
 		priv->can.termination = MCBA_TERMINATION_DISABLED;
@@ -789,9 +793,9 @@ static int mcba_set_termination(struct net_device *netdev, u16 term)
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

