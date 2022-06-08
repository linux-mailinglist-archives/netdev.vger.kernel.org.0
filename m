Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCBD5439CB
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242827AbiFHQz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343755AbiFHQxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:53:49 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C253C7E7F
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:51:35 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id v1so31943269ejg.13
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 09:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5gQL+PBjKdFRbWGXqCko2W4l6SNrb34I5/OqJqVjfAw=;
        b=orhsCgXR3r1BmMaiVIHHK+Nuz2maix0QOkibEQtFMj7JRULKjQ2TmKUbzmsWiWQ11f
         21BhhDfSH1+my9PR/jKLCnwF+cYEaKsxeuQPyHr8hcVFqIz/2yMZeN3Es3ervF0Xs9D8
         1LHxBlsXpg62lhf6PtkztHFd5z6kFnbmH94kM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5gQL+PBjKdFRbWGXqCko2W4l6SNrb34I5/OqJqVjfAw=;
        b=HuzLX7MQEbreZ1SFBvN8xeo2McUfRR3mXa1SBOGDWBY6tp2d43Ght+xRWPJ1b16WWh
         90vGB1nxHoX++MndyAolF1ZaxowmOSek74dPWt/sDJQgzmCrBkxaRVXYGcIpwuteozxf
         1xHFkJrB0e7WsKfKQLdtPobqx9zTN73LtQbmCjG8yB4WA4qWZhEPturQFTMELhturdoO
         fchdlD8dgiqGLsj/rE8Nx0mMRb/pXOJUydhug6XoJ11wYhMcF27VKH/K3mfREl/V7R87
         2Pz8tCJeP6To1ZtKJxCHRQB5qFoiMVOP4/n5h2IOgqtMUWkULy8ub43ULutoyst7w3fy
         6c4Q==
X-Gm-Message-State: AOAM533r0R6E2t7wOyjbkfE56BWnLni4pCbNP5AsYnV3xlUzkMWiYWkY
        WhuV15g4ViAeBVdokBR3vC5wCQ==
X-Google-Smtp-Source: ABdhPJwEWkc0e/hCdf76+OadjT0fOD3L09SgEiHoy/8QJAHWuIGxJFru4kyaMAMn9hO2kGZVrovw3Q==
X-Received: by 2002:a17:907:6d9b:b0:711:d26b:f5ba with SMTP id sb27-20020a1709076d9b00b00711d26bf5bamr13923231ejc.135.1654707093625;
        Wed, 08 Jun 2022 09:51:33 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id c22-20020a17090654d600b0070587f81bcfsm9569071ejp.19.2022.06.08.09.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:51:33 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 07/13] can: slcan: set bitrate by CAN device driver API
Date:   Wed,  8 Jun 2022 18:51:10 +0200
Message-Id: <20220608165116.1575390-8-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220608165116.1575390-1-dario.binacchi@amarulasolutions.com>
References: <20220608165116.1575390-1-dario.binacchi@amarulasolutions.com>
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

Changes in v2:
- Use the CAN framework support for setting fixed bit rates.

 drivers/net/can/slcan.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index cab0a2a8c84c..8561bcee81ba 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -439,6 +439,7 @@ static int slc_close(struct net_device *dev)
 	netif_stop_queue(dev);
 	close_candev(dev);
 	sl->can.state = CAN_STATE_STOPPED;
+	sl->can.bittiming.bitrate = 0;
 	sl->rcount   = 0;
 	sl->xleft    = 0;
 	spin_unlock_bh(&sl->lock);
@@ -460,7 +461,9 @@ static int slc_open(struct net_device *dev)
 	 * can.bittiming.bitrate is 0, causing open_candev() to fail.
 	 * So let's set to a fake value.
 	 */
-	sl->can.bittiming.bitrate = -1;
+	if (sl->can.bittiming.bitrate == 0)
+		sl->can.bittiming.bitrate = -1UL;
+
 	err = open_candev(dev);
 	if (err) {
 		netdev_err(dev, "failed to open can device\n");
@@ -558,6 +561,37 @@ static void slc_sync(void)
 	}
 }
 
+static const u32 slcan_bitrate_const[] = {
+	10000, 20000, 50000, 100000, 125000,
+	250000, 500000, 800000, 1000000
+};
+
+static int slc_do_set_bittiming(struct net_device *dev)
+{
+	struct slcan *sl = netdev_priv(dev);
+	unsigned char cmd[SLC_MTU];
+	int s, err;
+
+	for (s = 0; s < ARRAY_SIZE(slcan_bitrate_const); s++) {
+		if (sl->can.bittiming.bitrate == slcan_bitrate_const[s])
+			break;
+	}
+
+	/* The CAN framework has already validate the bitrate value,
+	 * so we can avoid to check if `s' has been properly set.
+	 */
+
+	snprintf(cmd, sizeof(cmd), "C\rS%d\r", s);
+	err = slcan_transmit_cmd(sl, cmd);
+	if (err) {
+		sl->can.bittiming.bitrate = 0;
+		netdev_err(sl->dev,
+			   "failed to send bitrate command 'C\\rS%d\\r'\n", s);
+	}
+
+	return err;
+}
+
 /* Find a free SLCAN channel, and link in this `tty' line. */
 static struct slcan *slc_alloc(void)
 {
@@ -587,6 +621,9 @@ static struct slcan *slc_alloc(void)
 	/* Initialize channel control data */
 	sl->magic = SLCAN_MAGIC;
 	sl->dev	= dev;
+	sl->can.bitrate_const = slcan_bitrate_const;
+	sl->can.bitrate_const_cnt = ARRAY_SIZE(slcan_bitrate_const);
+	sl->can.do_set_bittiming = slc_do_set_bittiming;
 	spin_lock_init(&sl->lock);
 	INIT_WORK(&sl->tx_work, slcan_transmit);
 	init_waitqueue_head(&sl->xcmd_wait);
-- 
2.32.0

