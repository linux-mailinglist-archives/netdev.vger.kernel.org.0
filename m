Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4EA54B104
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244178AbiFNM3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243619AbiFNM2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:28:39 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A1E26AF0
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:28:36 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z7so11366638edm.13
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AbbDKExzTnDRI7gbQZlSxolycHVQn9x05Wxw1nhoVAE=;
        b=Z/JIYpotFnOQ5zmb9SqzHVEaaztD0jqPK321kGQhBwM1TdUYaoJdCTkGfdGSfFJYZa
         frDZL3JcKyG8xgmE9rhb9P8I4rS5WPXeob6WzBVImIZ+gJyTtsCdBFxHgw6dJJo9fNTF
         qXCjtV+3R/aeZlAviiKig+1e0QRoK6hBQOzyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AbbDKExzTnDRI7gbQZlSxolycHVQn9x05Wxw1nhoVAE=;
        b=vq4kT4MHAFtkprGMvkXPDndpx3UzVeFx7T3dZ3I5XcIMSCUdPmrioJvacpndGBeUhZ
         CMJ+AS0rWAWvy9ilXmIrTo6KcA7aEZcRNrEJHlJkyUABGw0IbJLIxOAfyJmCfktcz8mC
         HV/cX8p9duEkF20VB7r7ovT81xlDVnxYCZt53+lrzkEiO1LqJJqxjXDmwgty2oMdyDdx
         6i2DGN/zNwMdoYvNyLacGl7h0f8Y/sFbF431E5b8MgB3lJ5hEYjbHVOxIjZ7/WqWUKF8
         GjPJmzlRnuIUgey88vKQpSHfFAuic4LcMIvUxvBUvJkQgsP49kprOffO18CnuB2i3lww
         Od/w==
X-Gm-Message-State: AOAM530C0MyT3TGpyoPQAWhm1qPU9O6b82V3AeQQGPFs2T5WJRkJ4QJ6
        K0eyXFdfpbXwZ/ACwqsomvobtg==
X-Google-Smtp-Source: ABdhPJxWvv0UQGxo34L3K2DH3j2O0BoFNUhfPAMIIvrjLqObNb1fAAR6lM6qKR/AyYgwDmpo7SnhnQ==
X-Received: by 2002:a05:6402:5193:b0:42e:2569:652c with SMTP id q19-20020a056402519300b0042e2569652cmr5733602edd.73.1655209715758;
        Tue, 14 Jun 2022 05:28:35 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.amarulasolutions.com (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id z22-20020a17090655d600b006f3ef214e2csm5087043ejp.146.2022.06.14.05.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:28:35 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 07/12] can: slcan: set bitrate by CAN device driver API
Date:   Tue, 14 Jun 2022 14:28:16 +0200
Message-Id: <20220614122821.3646071-8-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220614122821.3646071-1-dario.binacchi@amarulasolutions.com>
References: <20220614122821.3646071-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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
index 2afddaf62586..bd3cf53246c7 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -105,6 +105,11 @@ struct slcan {
 static struct net_device **slcan_devs;
 static DEFINE_SPINLOCK(slcan_lock);
 
+static const u32 slcan_bitrate_const[] = {
+	10000, 20000, 50000, 100000, 125000,
+	250000, 500000, 800000, 1000000
+};
+
  /************************************************************************
   *			SLCAN ENCAPSULATION FORMAT			 *
   ************************************************************************/
@@ -440,6 +445,9 @@ static int slc_close(struct net_device *dev)
 	netif_stop_queue(dev);
 	close_candev(dev);
 	sl->can.state = CAN_STATE_STOPPED;
+	if (sl->can.bittiming.bitrate == CAN_BITRATE_UNKNOWN)
+		sl->can.bittiming.bitrate = CAN_BITRATE_UNSET;
+
 	sl->rcount   = 0;
 	sl->xleft    = 0;
 	spin_unlock_bh(&sl->lock);
@@ -451,7 +459,8 @@ static int slc_close(struct net_device *dev)
 static int slc_open(struct net_device *dev)
 {
 	struct slcan *sl = netdev_priv(dev);
-	int err;
+	unsigned char cmd[SLC_MTU];
+	int err, s;
 
 	if (sl->tty == NULL)
 		return -ENODEV;
@@ -461,15 +470,39 @@ static int slc_open(struct net_device *dev)
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
@@ -582,6 +615,8 @@ static struct slcan *slc_alloc(void)
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

