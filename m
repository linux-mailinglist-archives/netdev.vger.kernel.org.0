Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613BF547C9B
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 23:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236859AbiFLVkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 17:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237048AbiFLVkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 17:40:19 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6122A70E
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 14:40:07 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id kq6so7662572ejb.11
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 14:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+67b1tOoWpv+tJyn4Sl0UQj6SwsqWBdWszhIl7nE8ec=;
        b=ekzn2Eu7W1AGKvZCpWrysDJbHOiJnbUo5R4jIEGo8okB8OGLKdr/rfRpdjnuWmK+ka
         YiTgErfTCPlZsW+I5ikMnhUtnvq0/m3pAZBJtOlPonAyNOitvDOYkoQUg9/7qskgVXLn
         6gVg9KMBgvg65rnqlaTiqb9xP/PA+V64FdQos=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+67b1tOoWpv+tJyn4Sl0UQj6SwsqWBdWszhIl7nE8ec=;
        b=AHp8fC4u9tdMF2Em7fcC39vQYXHI4w0lTxcaLozpupwPadxlUnoGFv16R+c8vibHbr
         Z5+6fiaJWzTOUtaPDST4JYG0oF1kE6fChFKZZSkTTZg+dsvZ9Y8qakvjC6aFsTwGfz2v
         zCk8q3pZ0WDqvnAjqwgH9thK7LJ7hB2kfC74zIZ2XPbxVoEd4jPqgb9dCZ+NIARKlcSH
         rLUl6IbtYuUunwRkqz3EJexwwQaf5sTh3Dds2jaIouJW4b+4hR7Lzbn8dnyETa3rmN+B
         fyZXulZaI5gw83Vi57+W3RBPMSa+xIqfGx34gl1g5Lc4uAZTZcJL4mwLpBNSmnemDjrq
         IChg==
X-Gm-Message-State: AOAM530jk94+zZAtXCsJDXR61C6pfgLgQ9u5CZxSsIYdqglIaZP7EHqs
        XhiDjsZjqTdXrY+nC1vlVUT9Fg==
X-Google-Smtp-Source: ABdhPJx8A99lmpCxYG4hTnXx0Y2AcGM4m1iilOJ4B+3Xq/1ru2ssjotUbF7W+fslGMlGKgRxvp4d4w==
X-Received: by 2002:a17:907:8a1d:b0:711:d86e:cc5 with SMTP id sc29-20020a1709078a1d00b00711d86e0cc5mr31921307ejc.237.1655070006888;
        Sun, 12 Jun 2022 14:40:06 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id u10-20020a1709061daa00b00711d546f8a8sm2909398ejh.139.2022.06.12.14.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jun 2022 14:40:06 -0700 (PDT)
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
Subject: [PATCH v3 07/13] can: slcan: set bitrate by CAN device driver API
Date:   Sun, 12 Jun 2022 23:39:21 +0200
Message-Id: <20220612213927.3004444-8-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220612213927.3004444-1-dario.binacchi@amarulasolutions.com>
References: <20220612213927.3004444-1-dario.binacchi@amarulasolutions.com>
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

Changes in v3:
- Remove the slc_do_set_bittiming().
- Set the bitrate in the ndo_open().
- Replace -1UL with -1U in setting a fake value for the bitrate.

Changes in v2:
- Use the CAN framework support for setting fixed bit rates.

 drivers/net/can/slcan.c | 39 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 4639a63c3af8..be3f7e5c685b 100644
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
@@ -440,6 +445,7 @@ static int slc_close(struct net_device *dev)
 	netif_stop_queue(dev);
 	close_candev(dev);
 	sl->can.state = CAN_STATE_STOPPED;
+	sl->can.bittiming.bitrate = 0;
 	sl->rcount   = 0;
 	sl->xleft    = 0;
 	spin_unlock_bh(&sl->lock);
@@ -451,7 +457,8 @@ static int slc_close(struct net_device *dev)
 static int slc_open(struct net_device *dev)
 {
 	struct slcan *sl = netdev_priv(dev);
-	int err;
+	unsigned char cmd[SLC_MTU];
+	int err, s;
 
 	if (sl->tty == NULL)
 		return -ENODEV;
@@ -461,15 +468,39 @@ static int slc_open(struct net_device *dev)
 	 * can.bittiming.bitrate is 0, causing open_candev() to fail.
 	 * So let's set to a fake value.
 	 */
-	sl->can.bittiming.bitrate = -1;
+	if (sl->can.bittiming.bitrate == 0)
+		sl->can.bittiming.bitrate = -1U;
+
 	err = open_candev(dev);
 	if (err) {
 		netdev_err(dev, "failed to open can device\n");
 		return err;
 	}
 
-	sl->can.state = CAN_STATE_ERROR_ACTIVE;
 	sl->flags &= BIT(SLF_INUSE);
+
+	if (sl->can.bittiming.bitrate != -1U) {
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
@@ -583,6 +614,8 @@ static struct slcan *slc_alloc(void)
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

