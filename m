Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C178581B87
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 23:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239841AbiGZVDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 17:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240012AbiGZVDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 17:03:43 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D5439B8E
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 14:03:36 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id tk8so28264007ejc.7
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 14:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jASsf99AUDo012UYQLBftY2iklAzdZ3iQKBsZI8nWRw=;
        b=fFao0muvy5QdgYg2Xl4vi/T9jeqH7SOrTIxhQRBV6TBIhv2e5u5iHwIGeBQW5FehkN
         bHX2gaBSUbyvLJfrK62fogqDN5/24OX+y5z7tuDud1MBHRmmcQ6KtyuV+MrKnyfLMU6P
         A3Jbj+SGoZ4n3gIrkxAQheWadstjKMwp22abo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jASsf99AUDo012UYQLBftY2iklAzdZ3iQKBsZI8nWRw=;
        b=PsEdJaJPSjV7VDsCNBLoy2hbyrCjhLXWFYUZ9YGqmEm91jiZqTLOBrF4aSz9rCMB1W
         hiSy+k/82BrUkb8XfFQHz/eCiWlD1+222Df13Fv3lRoV0gk5XmF8hN24/gnfD6pknWib
         Sator23iZeS+pBtOlT2WJJJJp3B9uuP55gRJYUvrbeIwt2HJi/hQ6zmg0UQY9yfhG/GH
         sV9ipPnSP2Nzk6cW+/PWQsM2MN9GZje+z4fQJNI7/RToILEv5vjEAblQ/JmH7dCgU9Lo
         OwgoXwJT3k3hEDBhEd+q33X4qvfgotSXtyZIZisxslk4AUjRm0j36fwMgn480yYzJWJj
         cYrg==
X-Gm-Message-State: AJIora+9Rvne7x2FkO+xHC4uuS89Glmy/+IgKnDItn3/hanTgiX3gssH
        wmjCs0RhGdSemefg9TaoZkC9bQ==
X-Google-Smtp-Source: AGRyM1vxj2Lnu57kJqfODxkF6lW3UPBMzQBcfExdggbA6yqhN8Sp5EQ+53bfqWmRfjV8BjKKss1MCw==
X-Received: by 2002:a17:906:4fc4:b0:6da:b4c6:fadb with SMTP id i4-20020a1709064fc400b006dab4c6fadbmr15668908ejw.282.1658869415190;
        Tue, 26 Jul 2022 14:03:35 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-87-14-98-67.retail.telecomitalia.it. [87.14.98.67])
        by smtp.gmail.com with ESMTPSA id y19-20020aa7d513000000b0043a7293a03dsm9092849edq.7.2022.07.26.14.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 14:03:34 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Subject: [RFC PATCH v3 8/9] can: slcan: add support to set bit time register (btr)
Date:   Tue, 26 Jul 2022 23:02:16 +0200
Message-Id: <20220726210217.3368497-9-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
References: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It allows to set the bit time register with tunable values.
The setting can only be changed if the interface is down:

ip link set dev can0 down
ethtool --set-tunable can0 can-btr 0x31c
ip link set dev can0 up

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
---

(no changes since v1)

 drivers/net/can/slcan/slcan-core.c    | 58 ++++++++++++++++++++-------
 drivers/net/can/slcan/slcan-ethtool.c | 13 ++++++
 drivers/net/can/slcan/slcan.h         |  1 +
 3 files changed, 58 insertions(+), 14 deletions(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 45e521910236..3905f21e7788 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -99,6 +99,7 @@ struct slcan {
 #define CF_ERR_RST		0               /* Reset errors on open      */
 	wait_queue_head_t       xcmd_wait;      /* Wait queue for commands   */
 						/* transmission              */
+	u32 btr;				/* bit timing register       */
 };
 
 static const u32 slcan_bitrate_const[] = {
@@ -128,6 +129,17 @@ int slcan_enable_err_rst_on_open(struct net_device *ndev, bool on)
 	return 0;
 }
 
+int slcan_set_btr(struct net_device *ndev, u32 btr)
+{
+	struct slcan *sl = netdev_priv(ndev);
+
+	if (netif_running(ndev))
+		return -EBUSY;
+
+	sl->btr = btr;
+	return 0;
+}
+
 /*************************************************************************
  *			SLCAN ENCAPSULATION FORMAT			 *
  *************************************************************************/
@@ -699,22 +711,40 @@ static int slcan_netdev_open(struct net_device *dev)
 		return err;
 	}
 
-	if (sl->can.bittiming.bitrate != CAN_BITRATE_UNKNOWN) {
-		for (s = 0; s < ARRAY_SIZE(slcan_bitrate_const); s++) {
-			if (sl->can.bittiming.bitrate == slcan_bitrate_const[s])
-				break;
+	if (sl->can.bittiming.bitrate != CAN_BITRATE_UNKNOWN || sl->btr) {
+		if (sl->can.bittiming.bitrate != CAN_BITRATE_UNKNOWN) {
+			for (s = 0; s < ARRAY_SIZE(slcan_bitrate_const); s++) {
+				if (sl->can.bittiming.bitrate ==
+				    slcan_bitrate_const[s])
+					break;
+			}
+
+			/* The CAN framework has already validate the bitrate
+			 * value, so we can avoid to check if `s' has been
+			 * properly set.
+			 */
+			snprintf(cmd, sizeof(cmd), "C\rS%d\r", s);
+			err = slcan_transmit_cmd(sl, cmd);
+			if (err) {
+				netdev_err(dev,
+					   "failed to send bitrate command 'C\\rS%d\\r'\n",
+					   s);
+				goto cmd_transmit_failed;
+			}
 		}
 
-		/* The CAN framework has already validate the bitrate value,
-		 * so we can avoid to check if `s' has been properly set.
-		 */
-		snprintf(cmd, sizeof(cmd), "C\rS%d\r", s);
-		err = slcan_transmit_cmd(sl, cmd);
-		if (err) {
-			netdev_err(dev,
-				   "failed to send bitrate command 'C\\rS%d\\r'\n",
-				   s);
-			goto cmd_transmit_failed;
+		if (sl->btr) {
+			u32 btr = sl->btr & GENMASK(15, 0);
+
+			snprintf(cmd, sizeof(cmd), "C\rs%04x\r", btr);
+			err = slcan_transmit_cmd(sl, cmd);
+			if (err) {
+				netdev_err(dev,
+					   "failed to send bit timing command 'C\\rs%04x\\r'\n",
+					   btr);
+				goto cmd_transmit_failed;
+			}
+
 		}
 
 		if (test_bit(CF_ERR_RST, &sl->cmd_flags)) {
diff --git a/drivers/net/can/slcan/slcan-ethtool.c b/drivers/net/can/slcan/slcan-ethtool.c
index bf0afdc4e49d..8e2e77bbffda 100644
--- a/drivers/net/can/slcan/slcan-ethtool.c
+++ b/drivers/net/can/slcan/slcan-ethtool.c
@@ -52,11 +52,24 @@ static int slcan_get_sset_count(struct net_device *netdev, int sset)
 	}
 }
 
+static int slcan_set_tunable(struct net_device *netdev,
+			     const struct ethtool_tunable *tuna,
+			     const void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_CAN_BTR:
+		return slcan_set_btr(netdev, *(u32 *)data);
+	default:
+		return -EINVAL;
+	}
+}
+
 static const struct ethtool_ops slcan_ethtool_ops = {
 	.get_strings = slcan_get_strings,
 	.get_priv_flags = slcan_get_priv_flags,
 	.set_priv_flags = slcan_set_priv_flags,
 	.get_sset_count = slcan_get_sset_count,
+	.set_tunable = slcan_set_tunable,
 };
 
 void slcan_set_ethtool_ops(struct net_device *netdev)
diff --git a/drivers/net/can/slcan/slcan.h b/drivers/net/can/slcan/slcan.h
index d463c8d99e22..1ac412fe8c95 100644
--- a/drivers/net/can/slcan/slcan.h
+++ b/drivers/net/can/slcan/slcan.h
@@ -13,6 +13,7 @@
 
 bool slcan_err_rst_on_open(struct net_device *ndev);
 int slcan_enable_err_rst_on_open(struct net_device *ndev, bool on);
+int slcan_set_btr(struct net_device *ndev, u32 btr);
 void slcan_set_ethtool_ops(struct net_device *ndev);
 
 #endif /* _SLCAN_H */
-- 
2.32.0

