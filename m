Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B87055EA01
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239485AbiF1QgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236805AbiF1Qe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:34:58 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC9234679
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:31:59 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id g26so26899660ejb.5
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D6vzlwH+mLCbP3Rml9p5rdZQNkA778tyhjsV5pComus=;
        b=pmy2+RhTplY12KneO0Nn181HDQOT2OjS9wITVZRegWS0DqXCXMNLMylgs6h32PJoa9
         TOzLqN0VpBkWGrITjxu4CKnKUbuNnenFJarLVORbntyuhLDbQllF4DhRioGbWUtIrCuB
         4N0mE+8EXh4/vIGozPw04brqhCU9XgN8aJDVU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D6vzlwH+mLCbP3Rml9p5rdZQNkA778tyhjsV5pComus=;
        b=EtyhrdU2aRcUkfc2tkc8+3x/YOwYY1binfGcIt1I1UlpwAkdyUwONo6bVEC2M0/z5H
         RjkM+sZWAXXYfh+1m4UHEEO04X3UROb8I4a+9XXrNRKIWXH+/CuoW5pt94DdLI/Vz5/n
         6o0Zs9XAlxmUgMv0vVD30PqXgWi8FEX2PWcwD1nflWEusABumHwPPdj93cSfclnc3gJR
         zPYXn8zz5MywusmwMKsePZB9UQA6mEkY66A6ODi6HYc9QLvDPqN75FptKpFlp1b27bGy
         a8E6x9IESHl2IRyzNL/ThQaH/NmuLiaAV3fm8LsFp1qkoeGNQVpwYr7XUDclJ09mAaqr
         9tpQ==
X-Gm-Message-State: AJIora/im4KwWopA2WhAEIQ5ur9xWSbbBDh0KdeY06wuHJDRSj2y1HWh
        /OTn44PoGAU/8nNOKGYP0ybJDQ==
X-Google-Smtp-Source: AGRyM1tOReslV7cyI8mM9pR5XlUqudHGEV7zWPHJ1JyHiT6dKaD4e2FrrhtiXiJOlcVbv4iYgeuheQ==
X-Received: by 2002:a17:907:1c1a:b0:726:2ce1:955e with SMTP id nc26-20020a1709071c1a00b007262ce1955emr17792937ejc.566.1656433918441;
        Tue, 28 Jun 2022 09:31:58 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id b20-20020a0564021f1400b0042e15364d14sm9916952edb.8.2022.06.28.09.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 09:31:58 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v5 07/12] can: slcan: set bitrate by CAN device driver API
Date:   Tue, 28 Jun 2022 18:31:31 +0200
Message-Id: <20220628163137.413025-8-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220628163137.413025-1-dario.binacchi@amarulasolutions.com>
References: <20220628163137.413025-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It allows to set the bitrate via ip tool, as it happens for the other
CAN device drivers. It still remains possible to set the bitrate via
slcand or slcan_attach utilities. In case the ip tool is used, the
driver will send the serial command to the adapter.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

(no changes since v4)

Changes in v4:
- Use CAN_BITRATE_UNSET (0) and CAN_BITRATE_UNKNOWN (-1U) macros.
- Don't reset the bitrate in ndo_stop() if it has been configured.

Changes in v3:
- Remove the slc_do_set_bittiming().
- Set the bitrate in the ndo_open().
- Replace -1UL with -1U in setting a fake value for the bitrate.

Changes in v2:
- Use the CAN framework support for setting fixed bit rates.

 drivers/net/can/slcan.c | 41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index dfccf8d6c9a5..74033e2d7097 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -104,6 +104,11 @@ struct slcan {
 
 static struct net_device **slcan_devs;
 
+static const u32 slcan_bitrate_const[] = {
+	10000, 20000, 50000, 100000, 125000,
+	250000, 500000, 800000, 1000000
+};
+
  /************************************************************************
   *			SLCAN ENCAPSULATION FORMAT			 *
   ************************************************************************/
@@ -439,6 +444,9 @@ static int slc_close(struct net_device *dev)
 	netif_stop_queue(dev);
 	close_candev(dev);
 	sl->can.state = CAN_STATE_STOPPED;
+	if (sl->can.bittiming.bitrate == CAN_BITRATE_UNKNOWN)
+		sl->can.bittiming.bitrate = CAN_BITRATE_UNSET;
+
 	sl->rcount   = 0;
 	sl->xleft    = 0;
 	spin_unlock_bh(&sl->lock);
@@ -450,7 +458,8 @@ static int slc_close(struct net_device *dev)
 static int slc_open(struct net_device *dev)
 {
 	struct slcan *sl = netdev_priv(dev);
-	int err;
+	unsigned char cmd[SLC_MTU];
+	int err, s;
 
 	if (sl->tty == NULL)
 		return -ENODEV;
@@ -460,15 +469,39 @@ static int slc_open(struct net_device *dev)
 	 * can.bittiming.bitrate is CAN_BITRATE_UNSET (0), causing
 	 * open_candev() to fail. So let's set to a fake value.
 	 */
-	sl->can.bittiming.bitrate = CAN_BITRATE_UNKNOWN;
+	if (sl->can.bittiming.bitrate == CAN_BITRATE_UNSET)
+		sl->can.bittiming.bitrate = CAN_BITRATE_UNKNOWN;
+
 	err = open_candev(dev);
 	if (err) {
 		netdev_err(dev, "failed to open can device\n");
 		return err;
 	}
 
-	sl->can.state = CAN_STATE_ERROR_ACTIVE;
 	sl->flags &= BIT(SLF_INUSE);
+
+	if (sl->can.bittiming.bitrate != CAN_BITRATE_UNKNOWN) {
+		for (s = 0; s < ARRAY_SIZE(slcan_bitrate_const); s++) {
+			if (sl->can.bittiming.bitrate == slcan_bitrate_const[s])
+				break;
+		}
+
+		/* The CAN framework has already validate the bitrate value,
+		 * so we can avoid to check if `s' has been properly set.
+		 */
+
+		snprintf(cmd, sizeof(cmd), "C\rS%d\r", s);
+		err = slcan_transmit_cmd(sl, cmd);
+		if (err) {
+			netdev_err(dev,
+				   "failed to send bitrate command 'C\\rS%d\\r'\n",
+				   s);
+			close_candev(dev);
+			return err;
+		}
+	}
+
+	sl->can.state = CAN_STATE_ERROR_ACTIVE;
 	netif_start_queue(dev);
 	return 0;
 }
@@ -581,6 +614,8 @@ static struct slcan *slc_alloc(void)
 	/* Initialize channel control data */
 	sl->magic = SLCAN_MAGIC;
 	sl->dev	= dev;
+	sl->can.bitrate_const = slcan_bitrate_const;
+	sl->can.bitrate_const_cnt = ARRAY_SIZE(slcan_bitrate_const);
 	spin_lock_init(&sl->lock);
 	INIT_WORK(&sl->tx_work, slcan_transmit);
 	init_waitqueue_head(&sl->xcmd_wait);
-- 
2.32.0

