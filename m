Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC29F55E9F3
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238864AbiF1Qf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236390AbiF1Qe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:34:58 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF7434BA4
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:32:00 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id u15so26878340ejc.10
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nio9Io5wePvGAcDSc6srKQ98uT3KtiBcW8y7c2FhYMU=;
        b=X7YljmFoA+Pbjbkk0RPtWOXAsrWDlX5lLpo+NIfWZSQ9xz6s63CHPPpeQUX3Dd+edg
         chqkljTxiAo6Tx5D2zlMCdqzpo//BQaRaPEvuQhdKRjeeSYYdfq/WpA0vX2BTKzDzuKx
         xkyxpx3F1ORYnqinncEaJI4/p4xAOTQ6QzcXY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nio9Io5wePvGAcDSc6srKQ98uT3KtiBcW8y7c2FhYMU=;
        b=xkWXuNgJr8gozPOUX/I7BL2Arr94KKMwmJMU/cAwMJmOmwXAnXU48q1TvhzglXSErm
         4KVzJxrJyiC6CGoMkuwUowO6mheQfEfqlt4oq/kOK+xR6SDziqi/KDYCAmJ1sG76kBSV
         qeX1/dezb7Mdm5qGHd1U2J8DsF4/hbXkAOoGln7uTNI2OOUpBtwgwa1g6sn8ids87yJO
         2Owu05q9P60Y/S4RRfOOGlSKKgFEdSjg9SzXNJi1fWeiY7slxZ0nTsJ6YzVuWYF6T4w3
         UUehDx1Y0T9KOpRemjgj0I+cA35qhenmHWlHoQdgSBA3w47RHCL4lfmjR1rR7jpIUYhX
         H63Q==
X-Gm-Message-State: AJIora/4s9k+FPl2b42A02i0QjDm1NejPMhg5hhFjv57khonFi7p8KSu
        nSdpu0HgPU+Ri117Vl5myxFeag==
X-Google-Smtp-Source: AGRyM1si4nXdxEjqIXU5aRmZJLvPy2mhhad41u83reYLiAJ+SArzkZQjW+uWGFMwkZ7tUzGqmCXQBw==
X-Received: by 2002:a17:907:7fa4:b0:726:b83d:6cbc with SMTP id qk36-20020a1709077fa400b00726b83d6cbcmr8359371ejc.49.1656433919982;
        Tue, 28 Jun 2022 09:31:59 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id b20-20020a0564021f1400b0042e15364d14sm9916952edb.8.2022.06.28.09.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 09:31:59 -0700 (PDT)
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
Subject: [PATCH v5 08/12] can: slcan: send the open/close commands to the adapter
Date:   Tue, 28 Jun 2022 18:31:32 +0200
Message-Id: <20220628163137.413025-9-dario.binacchi@amarulasolutions.com>
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

In case the bitrate has been set via ip tool, this patch changes the
driver to send the open ("O\r") and close ("C\r) commands to the
adapter.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

(no changes since v4)

Changes in v4:
- Squashed to the patch [v3,09/13] can: slcan: send the close command to the adapter.
- Use the CAN_BITRATE_UNKNOWN macro.

Changes in v2:
- Improve the commit message.

 drivers/net/can/slcan.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 74033e2d7097..249b5ade06fc 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -435,9 +435,20 @@ static int slcan_transmit_cmd(struct slcan *sl, const unsigned char *cmd)
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
@@ -496,14 +507,23 @@ static int slc_open(struct net_device *dev)
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

