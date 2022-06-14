Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD42854B0D4
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243705AbiFNM3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243597AbiFNM2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:28:38 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DC840E64
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:28:34 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id y19so16841586ejq.6
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J7cAHYzHeqO4eieQ7T7B38pR/xwLeH3ndQgGNnjLG/E=;
        b=XSAUyZOWy5q2GWu3PLxoxE10G+1JlvepEjzvUqXBzxdLsTBIVBjyFLiLgEWy3AefaL
         qIDG5NM9+f+kytLuYuLs2tW2EsI8Oe9XkNrIgacbkXTyJzOsoPt9CE7Hzq9eDs+tiR0P
         oI4PRPXqGRbSBWCCi3Piai0AvOjG7IYUYM9KM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J7cAHYzHeqO4eieQ7T7B38pR/xwLeH3ndQgGNnjLG/E=;
        b=ZBxlD2QUUbsiQOo1kiI9PynkuZOhQiHRLwoy1mUzoosauQmDDOKXfBbhOEA80FBH92
         DXTdgT9eIeM2QWRMyK+dNajmJdHmMEPo1nAIczDPz1M3qdP1wK4xgIaPzG4M6iMte28u
         xk+rzC5lx8Rmu5HUb7/1aGaJSzpjNHkWj3RnRcI7t5Qn9ZEi+zM8z2EKOoH76YebgX5N
         3mviMyU7nRyOGoIOhDSYaY5j0dhG9ZmDpWLSg/YKf/nQwsBwlt2CU048CG3yT5Ls8u7F
         2pGgWrok9TWksvj6H3N6hGOCfNbm4bcDBnKwOHDBQ9YGIG/Kih10AGFLr28XKztQw5Wt
         TINw==
X-Gm-Message-State: AOAM5314ivQnUhK0EbmV+ZR7JYeChRkUHM8Q1drK9jvwZNcwhaADe1JA
        NCQCemAmHzoh8GxETTXDFebfbw==
X-Google-Smtp-Source: ABdhPJw+07ZbLCl5Rx7GRphIBbK0PZ/uFC+9XZdj48PviEiLyXqTg7Fiq5dkX25nYqp4N27s+Jy1Ng==
X-Received: by 2002:a17:906:7254:b0:6fe:5637:cbe6 with SMTP id n20-20020a170906725400b006fe5637cbe6mr4030190ejk.612.1655209714188;
        Tue, 14 Jun 2022 05:28:34 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.amarulasolutions.com (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id z22-20020a17090655d600b006f3ef214e2csm5087043ejp.146.2022.06.14.05.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:28:33 -0700 (PDT)
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
Subject: [PATCH v4 06/12] can: slcan: allow to send commands to the adapter
Date:   Tue, 14 Jun 2022 14:28:15 +0200
Message-Id: <20220614122821.3646071-7-dario.binacchi@amarulasolutions.com>
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

This is a preparation patch for the upcoming support to change the
bitrate via ip tool, reset the adapter error states via the ethtool API
and, more generally, send commands to the adapter.

Since the close command (i. e. "C\r") will be sent in the ndo_stop()
where netif_running() returns false, a new flag bit (i. e. SLF_XCMD) for
serial transmission has to be added.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

Changes in v4:
- Replace `sl->tty == NULL' with `!sl->tty'.

Changes in v3:
- Update the commit description.

 drivers/net/can/slcan.c | 46 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index c7ff11dd2278..2afddaf62586 100644
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
@@ -315,12 +318,22 @@ static void slcan_transmit(struct work_struct *work)
 
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
@@ -384,6 +397,36 @@ static netdev_tx_t slc_xmit(struct sk_buff *skb, struct net_device *dev)
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
@@ -541,6 +584,7 @@ static struct slcan *slc_alloc(void)
 	sl->dev	= dev;
 	spin_lock_init(&sl->lock);
 	INIT_WORK(&sl->tx_work, slcan_transmit);
+	init_waitqueue_head(&sl->xcmd_wait);
 	slcan_devs[i] = dev;
 
 	return sl;
-- 
2.32.0

