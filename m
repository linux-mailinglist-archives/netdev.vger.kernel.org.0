Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B07F354B149
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244101AbiFNM3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243864AbiFNM2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:28:39 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC9B22B01
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:28:38 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id y19so16842608ejq.6
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4Ikx/I3Y696YQQvJOfJvkR+b8+rk3mrxAawgjIDEUZ0=;
        b=fcozqSg6IKoKg9kPzNk4vgpeYJBfA6sRK6QUNqlE5NGhEPGgKBho033KaqjRspCizB
         SqJWccoggeLwKFyCo25eeFXDvXO1lQoxQGi/uhEkA0etpMW/1iDdWvYlaWea8rr6SYjB
         ASpWjX2+Vw4TGE6xjCOUb4HdAumC/gkcubYVs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4Ikx/I3Y696YQQvJOfJvkR+b8+rk3mrxAawgjIDEUZ0=;
        b=4y+bfcAyi1gcVHcibvhtKJ4ai+rcJkNArr+AD8Db6oN3I0RuS8euuLvIOufueTT0QI
         YKpvjhlix4qPB17UmTNZ08I16hwMVEUW4b3T6BI+tTL4KmBzqisNgo8PkIUlTiS2o3aO
         Gu91v6doJSeSBupw0ZnyalUoWZOD78ftMeaNCQSImbWrUC5BilD6bR09W9z5tWjNQU0P
         MK19DjFdkyDLM7w3vEGVCdOnwOLL1a5yREKUdqq6Sv9uqp0OQNIY13QLx9os6lbrVqaz
         kFZ7T1E72C3JtNbAYgmcmj7pZ0a099WqDiaJfqIk9M6GedKqgvSUX3HJDWxexlEVAnIS
         Gzxw==
X-Gm-Message-State: AOAM530VMBESBRKDFm/S/UhbHygCjLhUO9ZSdA4HcMCr+iGWiJmxK+ZC
        T9l4dyzuMXAkMOiOf6EtCcNCqw==
X-Google-Smtp-Source: AGRyM1uelCB/Qv4o1YlAs/EirN062K8SD18mCxEGk2AXw8TotOBNzQGInbqvWk0FaZZYTQfuTN2XLA==
X-Received: by 2002:a17:906:73d4:b0:715:701c:ae96 with SMTP id n20-20020a17090673d400b00715701cae96mr4033479ejl.50.1655209716999;
        Tue, 14 Jun 2022 05:28:36 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.amarulasolutions.com (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id z22-20020a17090655d600b006f3ef214e2csm5087043ejp.146.2022.06.14.05.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:28:36 -0700 (PDT)
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
Subject: [PATCH v4 08/12] can: slcan: send the open/close commands to the adapter
Date:   Tue, 14 Jun 2022 14:28:17 +0200
Message-Id: <20220614122821.3646071-9-dario.binacchi@amarulasolutions.com>
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

In case the bitrate has been set via ip tool, this patch changes the
driver to send the open ("O\r") and close ("C\r) commands to the
adapter.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

Changes in v4:
- Squashed to the patch [v3,09/13] can: slcan: send the close command to the adapter.
- Use the CAN_BITRATE_UNKNOWN macro.

Changes in v2:
- Improve the commit message.

 drivers/net/can/slcan.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index bd3cf53246c7..b08e63f59b8e 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -436,9 +436,20 @@ static int slcan_transmit_cmd(struct slcan *sl, const unsigned char *cmd)
 static int slc_close(struct net_device *dev)
 {
 	struct slcan *sl = netdev_priv(dev);
+	int err;
 
 	spin_lock_bh(&sl->lock);
 	if (sl->tty) {
+		if (sl->can.bittiming.bitrate &&
+		    sl->can.bittiming.bitrate != CAN_BITRATE_UNKNOWN) {
+			spin_unlock_bh(&sl->lock);
+			err = slcan_transmit_cmd(sl, "C\r");
+			spin_lock_bh(&sl->lock);
+			if (err)
+				netdev_warn(dev,
+					    "failed to send close command 'C\\r'\n");
+		}
+
 		/* TTY discipline is running. */
 		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
 	}
@@ -497,14 +508,23 @@ static int slc_open(struct net_device *dev)
 			netdev_err(dev,
 				   "failed to send bitrate command 'C\\rS%d\\r'\n",
 				   s);
-			close_candev(dev);
-			return err;
+			goto cmd_transmit_failed;
+		}
+
+		err = slcan_transmit_cmd(sl, "O\r");
+		if (err) {
+			netdev_err(dev, "failed to send open command 'O\\r'\n");
+			goto cmd_transmit_failed;
 		}
 	}
 
 	sl->can.state = CAN_STATE_ERROR_ACTIVE;
 	netif_start_queue(dev);
 	return 0;
+
+cmd_transmit_failed:
+	close_candev(dev);
+	return err;
 }
 
 static void slc_dealloc(struct slcan *sl)
-- 
2.32.0

