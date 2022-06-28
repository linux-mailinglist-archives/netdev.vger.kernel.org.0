Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9549555E9EE
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238031AbiF1Qfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238179AbiF1Qer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:34:47 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD9F326EC
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:31:57 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id pk21so26957917ejb.2
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zyw3StTTBZQE50VIbm/+yoJ4bqV04RBr+wi4S3Ganwc=;
        b=S41zUjUKFlhBCYHOrerU5Xli96L0AvUDZCtir9tl9KKhDeC8JN0+3ZNV+HKTkyOqCy
         h3eg+RxMKxD5a3XHNmdMZaq8L7ZqxdgDedkPkKoUBvQabLUnKEwbbvKjK2MSudgj7GP+
         GftuGtwXXeo/ZzamCA1zlRh+75OmhWbo//6JY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zyw3StTTBZQE50VIbm/+yoJ4bqV04RBr+wi4S3Ganwc=;
        b=VWxpEPU49IeT09wzyOvvzpllfTen/3Nxikjo1slQIYJcRmAJg/7WdixJ/YvpJdpqnu
         HAWnkuxFlsunlRzZoZ+5VTe3no7DsGjGeUzJrr8NF8Uf4gvIb0uuTzthL+zl58388/SG
         uoWxZBflpc2Stg7JeobvzOgvj8dO8WYIXm/cjaYayRR2VGOKz5xl6xM3CFLhTKmhfLOX
         5Catzt3Nu2QndEzD1yAEk8bco0Jeo4tnzP/4H555rruzVJ7gDPK/1Ff7MP+v/opw2j7z
         aDIfF7lgU1u3UdseA9JiGf3VjJFiPrV/QDCKrlY/kFeaTaOvgDE+NqvbfsiIxEZr23S7
         hayA==
X-Gm-Message-State: AJIora95bHd140gIyA045HGPfDJIHU9AseTjF+AJidAV5BzNvFhvrN8G
        i13QN2yf7dBrUXdNnuxmM7nAtg==
X-Google-Smtp-Source: AGRyM1vBk2wMNW/HbxmnPsFpzK+heKZBIMg8aMv9NVyx6WCQ/nsUdgJrApjNpv2e8d6nEmWoA1gitA==
X-Received: by 2002:a17:907:72c7:b0:722:f046:c9d9 with SMTP id du7-20020a17090772c700b00722f046c9d9mr18152763ejc.409.1656433916978;
        Tue, 28 Jun 2022 09:31:56 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id b20-20020a0564021f1400b0042e15364d14sm9916952edb.8.2022.06.28.09.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 09:31:56 -0700 (PDT)
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
Subject: [PATCH v5 06/12] can: slcan: allow to send commands to the adapter
Date:   Tue, 28 Jun 2022 18:31:30 +0200
Message-Id: <20220628163137.413025-7-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220628163137.413025-1-dario.binacchi@amarulasolutions.com>
References: <20220628163137.413025-1-dario.binacchi@amarulasolutions.com>
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

This is a preparation patch for the upcoming support to change the
bitrate via ip tool, reset the adapter error states via the ethtool API
and, more generally, send commands to the adapter.

Since the close command (i. e. "C\r") will be sent in the ndo_stop()
where netif_running() returns false, a new flag bit (i. e. SLF_XCMD) for
serial transmission has to be added.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

(no changes since v4)

Changes in v4:
- Replace `sl->tty == NULL' with `!sl->tty'.

Changes in v3:
- Update the commit description.

 drivers/net/can/slcan.c | 46 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index bf84698f1a81..dfccf8d6c9a5 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -97,6 +97,9 @@ struct slcan {
 	unsigned long		flags;		/* Flag values/ mode etc     */
 #define SLF_INUSE		0		/* Channel in use            */
 #define SLF_ERROR		1               /* Parity, etc. error        */
+#define SLF_XCMD		2               /* Command transmission      */
+	wait_queue_head_t       xcmd_wait;      /* Wait queue for commands   */
+						/* transmission              */
 };
 
 static struct net_device **slcan_devs;
@@ -314,12 +317,22 @@ static void slcan_transmit(struct work_struct *work)
 
 	spin_lock_bh(&sl->lock);
 	/* First make sure we're connected. */
-	if (!sl->tty || sl->magic != SLCAN_MAGIC || !netif_running(sl->dev)) {
+	if (!sl->tty || sl->magic != SLCAN_MAGIC ||
+	    (unlikely(!netif_running(sl->dev)) &&
+	     likely(!test_bit(SLF_XCMD, &sl->flags)))) {
 		spin_unlock_bh(&sl->lock);
 		return;
 	}
 
 	if (sl->xleft <= 0)  {
+		if (unlikely(test_bit(SLF_XCMD, &sl->flags))) {
+			clear_bit(SLF_XCMD, &sl->flags);
+			clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
+			spin_unlock_bh(&sl->lock);
+			wake_up(&sl->xcmd_wait);
+			return;
+		}
+
 		/* Now serial buffer is almost free & we can start
 		 * transmission of another packet */
 		sl->dev->stats.tx_packets++;
@@ -383,6 +396,36 @@ static netdev_tx_t slc_xmit(struct sk_buff *skb, struct net_device *dev)
  *   Routines looking at netdevice side.
  ******************************************/
 
+static int slcan_transmit_cmd(struct slcan *sl, const unsigned char *cmd)
+{
+	int ret, actual, n;
+
+	spin_lock(&sl->lock);
+	if (!sl->tty) {
+		spin_unlock(&sl->lock);
+		return -ENODEV;
+	}
+
+	n = snprintf(sl->xbuff, sizeof(sl->xbuff), "%s", cmd);
+	set_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
+	actual = sl->tty->ops->write(sl->tty, sl->xbuff, n);
+	sl->xleft = n - actual;
+	sl->xhead = sl->xbuff + actual;
+	set_bit(SLF_XCMD, &sl->flags);
+	spin_unlock(&sl->lock);
+	ret = wait_event_interruptible_timeout(sl->xcmd_wait,
+					       !test_bit(SLF_XCMD, &sl->flags),
+					       HZ);
+	clear_bit(SLF_XCMD, &sl->flags);
+	if (ret == -ERESTARTSYS)
+		return ret;
+
+	if (ret == 0)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
 /* Netdevice UP -> DOWN routine */
 static int slc_close(struct net_device *dev)
 {
@@ -540,6 +583,7 @@ static struct slcan *slc_alloc(void)
 	sl->dev	= dev;
 	spin_lock_init(&sl->lock);
 	INIT_WORK(&sl->tx_work, slcan_transmit);
+	init_waitqueue_head(&sl->xcmd_wait);
 	slcan_devs[i] = dev;
 
 	return sl;
-- 
2.32.0

