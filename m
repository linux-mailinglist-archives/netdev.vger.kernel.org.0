Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A467C53FA35
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 11:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240053AbiFGJsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 05:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240028AbiFGJsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 05:48:25 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AB2D02B6
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 02:48:23 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id q26so12976504wra.1
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 02:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=onYK8jf0XQfJNXTnZtrlaJoF/ojpUqhJIjTYy4RWPWI=;
        b=cRCWGgSNpt2XHDnQgz+KAWufJT5/RKaxCaOCt/Pk3UnqNXK6FJK5dHhsPcDWYOb6aK
         qyiDAujXzXpICWyNMxy8P6LfD6gMTuv9agCd8AA+B/zKcQ5Oal1TZqRiFhuQ0SXcGhdN
         LfJlg2lz03oo9CZgNa3SLw70CuWz3vNYOSJMk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=onYK8jf0XQfJNXTnZtrlaJoF/ojpUqhJIjTYy4RWPWI=;
        b=1nH+bz+hSunWvIJ1wK4meDu1pwOvFNqAkqUoHah1+IZXoSM21p2MNRQ655Z1HJoLFK
         YyKrLZocplivkOJUZgVBHxULN2yp8weYIMRdMJN33tkloTuH8sWrRY7RR2Z+24WwCdKf
         vFJpYWWbQqrwlXZkMjiFxPbw3+5KApQgVobgBDEQutv5L4bO2GEUmqvj5RDesGc6hGkm
         5ywsLIC3GzRttlggtPARf4V6f4WDeKnjYz2VDDm4N3aH75L4LvKgvJq/Ga7RxGFHghQ0
         G9TpoSN/oqPHDj87LxmjF4Mx3ZJ3CRH/UjUmi/5I0CFKgGWbSiEugN1qaG2UTalODnAQ
         rBuQ==
X-Gm-Message-State: AOAM531u+j37O4haxI7x8oxcGaOpmHTSIoCnOTqZ105ojUi44wCCwOi8
        tl7e9X5DIvUtTcWg7KtxJuG3TQ==
X-Google-Smtp-Source: ABdhPJxIChpp14XTvdyXsK+FVN+YIV91/EqReU6KUu7uJ5RbsKEAF1QtA6YosUz9J32Mpe0mDLOLnw==
X-Received: by 2002:a5d:4649:0:b0:218:4d6c:3f3f with SMTP id j9-20020a5d4649000000b002184d6c3f3fmr3510839wrs.148.1654595303518;
        Tue, 07 Jun 2022 02:48:23 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.pdxnet.pdxeng.ch (mob-5-90-137-51.net.vodafone.it. [5.90.137.51])
        by smtp.gmail.com with ESMTPSA id o4-20020a05600c510400b0039748be12dbsm23200547wms.47.2022.06.07.02.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 02:48:23 -0700 (PDT)
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
Subject: [RFC PATCH 07/13] can: slcan: set bitrate by CAN device driver API
Date:   Tue,  7 Jun 2022 11:47:46 +0200
Message-Id: <20220607094752.1029295-8-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

The struct can_bittiming_const and struct can_priv::clock.freq has been
set with empirical values ​​that allow you to get a correct bit timing, so
that the slc_do_set_bittiming() can be called.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---
DTS properties could be used to set the can.clock.freq and the
can.bittiming_const variables. This way the parameters could be changed
based on the type of the adapter.

 drivers/net/can/slcan.c | 54 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index dbd4ebdfa024..f1bf32b70c4d 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -105,6 +105,18 @@ struct slcan {
 static struct net_device **slcan_devs;
 static DEFINE_SPINLOCK(slcan_lock);
 
+static const struct can_bittiming_const slcan_bittiming_const = {
+	.name = KBUILD_MODNAME,
+	.tseg1_min = 2,
+	.tseg1_max = 256,
+	.tseg2_min = 1,
+	.tseg2_max = 128,
+	.sjw_max = 128,
+	.brp_min = 1,
+	.brp_max = 256,
+	.brp_inc = 1,
+};
+
  /************************************************************************
   *			SLCAN ENCAPSULATION FORMAT			 *
   ************************************************************************/
@@ -435,6 +447,7 @@ static int slc_close(struct net_device *dev)
 	netif_stop_queue(dev);
 	close_candev(dev);
 	sl->can.state = CAN_STATE_STOPPED;
+	sl->can.bittiming.bitrate = 0;
 	sl->rcount   = 0;
 	sl->xleft    = 0;
 	spin_unlock_bh(&sl->lock);
@@ -456,7 +469,9 @@ static int slc_open(struct net_device *dev)
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
@@ -554,6 +569,40 @@ static void slc_sync(void)
 	}
 }
 
+static int slc_do_set_bittiming(struct net_device *dev)
+{
+	struct slcan *sl = netdev_priv(dev);
+	unsigned char cmd[SLC_MTU];
+	int i, s = -1, err;
+	unsigned int bitrates[] = {
+		10000, 20000, 50000, 100000,
+		125000, 250000, 500000, 800000,
+		1000000,
+	};
+
+	for (i = 0; i < ARRAY_SIZE(bitrates); i++) {
+		if (sl->can.bittiming.bitrate == bitrates[i]) {
+			s = i;
+			break;
+		}
+	}
+
+	if (s < 0) {
+		netdev_err(dev, "invalid bitrate\n");
+		return -EINVAL;
+	}
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
@@ -583,6 +632,9 @@ static struct slcan *slc_alloc(void)
 	/* Initialize channel control data */
 	sl->magic = SLCAN_MAGIC;
 	sl->dev	= dev;
+	sl->can.clock.freq = 24 * 1000 * 1000;
+	sl->can.bittiming_const = &slcan_bittiming_const;
+	sl->can.do_set_bittiming = slc_do_set_bittiming;
 	spin_lock_init(&sl->lock);
 	INIT_WORK(&sl->tx_work, slcan_transmit);
 	init_waitqueue_head(&sl->xcmd_wait);
-- 
2.32.0

