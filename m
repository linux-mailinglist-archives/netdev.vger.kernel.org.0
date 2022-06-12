Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18C2547C9D
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 23:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237213AbiFLVko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 17:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236939AbiFLVkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 17:40:07 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8390C1B798
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 14:40:04 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id kq6so7662738ejb.11
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 14:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UpyKa7+uiIpxrunvBDbFWo+0Nybf0w4Bu0XA6EFem0M=;
        b=iySTg+7gykUlkXqKRP10EZo85LR74jsimSuc1hHYsMrI13hjxriR+gxuAxDgBePdWb
         Y/UERRrLDFDVhPQ+6SR2AyT6FZf1PvKc+Lk7FGtv7UonIY3bmiskc3mTK9OjiV3UCFrT
         Rq2w9y44CkwA0+txIQ2GcR3k107yest0i6P28=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UpyKa7+uiIpxrunvBDbFWo+0Nybf0w4Bu0XA6EFem0M=;
        b=m5Vzb+GUCx3RLIUXsw3IuYSOGqVPdh/rCsri0aPjzwMH8/BvkXLhJtOrfPEuVzKyLD
         nP5yy4SDEETsUKvFzyjc0T8g5e7xyQu9oqNvm50nd/CkhseQcGdrmaPWD1FzJxUblcXj
         Ur7imza4krRLnxiCJOfAWVvD5zjjEq/Gc2eQQ0X4DLJmbgmsiS5kgMLXd1hqnjDlwq/X
         jF6/aneKNPnUe2WKcwY2hkhFjGG7MYDIOTJgnqxnaPDwM9HhZ5BEuB00ve7es80sST9x
         ySkR+VxOFaZVZYtY5DRn7nTy7+vno4xObDE/DAqJA5aXlMCxC63w9//G4SVXsHcHWStk
         QB/w==
X-Gm-Message-State: AOAM533rPrSi89DV1VJb6H0x0Jp3bcpFSOsrLv/LR+HZcTn/PNKiLwQO
        mDe4Vl7yqXjjn9zGHHrk00OuSw==
X-Google-Smtp-Source: ABdhPJwkbgu45AOp+OWXYw1HCPQPTrM3sdPLIkp/zMVu125wAREIqo2pzDiUbJbnyvGQXMB2zPhRqQ==
X-Received: by 2002:a17:907:8195:b0:710:b40:95d2 with SMTP id iy21-20020a170907819500b007100b4095d2mr41307282ejc.604.1655070002462;
        Sun, 12 Jun 2022 14:40:02 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id u10-20020a1709061daa00b00711d546f8a8sm2909398ejh.139.2022.06.12.14.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jun 2022 14:40:02 -0700 (PDT)
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
Subject: [PATCH v3 06/13] can: slcan: allow to send commands to the adapter
Date:   Sun, 12 Jun 2022 23:39:20 +0200
Message-Id: <20220612213927.3004444-7-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220612213927.3004444-1-dario.binacchi@amarulasolutions.com>
References: <20220612213927.3004444-1-dario.binacchi@amarulasolutions.com>
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

This is a preparation patch for the upcoming support to change the
bitrate via ip tool, reset the adapter error states via the ethtool API
and, more generally, send commands to the adapter.

Since the close command (i. e. "C\r") will be sent in the ndo_stop()
where netif_running() returns false, a new flag bit (i. e. SLF_XCMD) for
serial transmission has to be added.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

Changes in v3:
- Update the commit description.

 drivers/net/can/slcan.c | 46 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index a70f930b7c3a..4639a63c3af8 100644
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
+	if (sl->tty == NULL) {
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
@@ -542,6 +585,7 @@ static struct slcan *slc_alloc(void)
 	sl->dev	= dev;
 	spin_lock_init(&sl->lock);
 	INIT_WORK(&sl->tx_work, slcan_transmit);
+	init_waitqueue_head(&sl->xcmd_wait);
 	slcan_devs[i] = dev;
 
 	return sl;
-- 
2.32.0

