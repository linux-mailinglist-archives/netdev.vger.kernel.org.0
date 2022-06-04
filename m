Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337AF53D7DC
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 18:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238910AbiFDQdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 12:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238833AbiFDQd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 12:33:26 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E743B3C8;
        Sat,  4 Jun 2022 09:33:04 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id t2so8994795pld.4;
        Sat, 04 Jun 2022 09:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wPNc3YvhAKuZLbvOFj+YsMRBSINjKQKB6Tw7aOecxnY=;
        b=bQYjQLTuCYJKhpCbJ5T/6FqYDtp9ytwgZ8GjD77Izl1pWHbfrq1t0TIOUuOcMTbQfC
         kZhO6u2/8M74+EDu7hTumtCIUT6MFeYzRwOtdN/9fDsFz7fjdF5YRkpDsDF2Ky8/I6VF
         YdRfETt8XCvyeVaPkJ9hjCRik6toadMEuKTQVS9KJrccA6HJWdpUR0Si0MXp/LgksUpa
         OF8DEpBNp3JDp3RxVRuDIZOkvLokZR8esKhUOcR5W9bpzfXN2VF/1ca+PnurVfGTOe/f
         pK+o5YUZ11qbbZDgQZl8sjZ7ZZ4Igva9IwS+ndpPmbR+KpyLOdec7/HbAVXM02OkZC8y
         rzUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=wPNc3YvhAKuZLbvOFj+YsMRBSINjKQKB6Tw7aOecxnY=;
        b=xkx3aoSm9FbftmqHJejXs71WDY0R8HDtEy5OvQB8MDSZPoJW08EMsP4DKhlpQQlMOa
         25PCfMMjijzi8sQA91466psbECvuAn49bdeYD2j3hBvhHA9mSNEGxJDYz5K+5OHJkm1P
         C6fEuYwj0tsJRYweeRTKzBMasy/sSI5aQNjUHJ0jrQZjYuL6DVOthQprUAwx78TCKQzE
         YqltWFYwVOu98PQzv8X4S1mZW4W3euTQx/EhvEGM2rqkWrZoQuCehe+E7e1K0E5O9Atz
         AAfStjXXpiXkxhpw43uCM5zhdeS+ioNZOumLY1eVTZZD7Q+agqQWeCgAHWlTF9MLy67/
         yIIA==
X-Gm-Message-State: AOAM533ee6Y9ZD8Dsfxz3m0P1oWwZ4rXCCDOwv8ZXY4VmAEYHK53ubWe
        frxBiwArjXXna1yqYUYCGFA=
X-Google-Smtp-Source: ABdhPJwuG7ubgnGbDsxUh+u5eJBPGs3nl1VlPuP1FfhFtzokvX7WVAYT3KXphfY7egXNVX/o4trgqw==
X-Received: by 2002:a17:902:a706:b0:163:f77b:10e0 with SMTP id w6-20020a170902a70600b00163f77b10e0mr15923266plq.96.1654360383634;
        Sat, 04 Jun 2022 09:33:03 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id t8-20020a17090a3b4800b001e34b5ed5a7sm8424874pjf.35.2022.06.04.09.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 09:33:03 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 7/7] can: skb: drop tx skb if in listen only mode
Date:   Sun,  5 Jun 2022 01:30:00 +0900
Message-Id: <20220604163000.211077-8-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frames can be directly injected to a can driver via the packet
socket. By doing so, it is possible to reach the
net_device_ops::ndo_start_xmit function even if the driver is
configured in listen only mode.

Add a check in can_dropped_invalid_skb() to discard the skb if
CAN_CTRLMODE_LISTENONLY is set.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/dev/skb.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index dc9da76c0470..8bb62dd864c8 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/can/dev.h>
+#include <linux/can/netlink.h>
 #include <linux/module.h>
 
 #define MOD_DESC "CAN device driver interface"
@@ -293,6 +294,7 @@ static bool can_skb_headroom_valid(struct net_device *dev, struct sk_buff *skb)
 bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
 {
 	const struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
+	struct can_priv *priv = netdev_priv(dev);
 
 	if (skb->protocol == htons(ETH_P_CAN)) {
 		if (unlikely(skb->len != CAN_MTU ||
@@ -306,8 +308,13 @@ bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
 		goto inval_skb;
 	}
 
-	if (!can_skb_headroom_valid(dev, skb))
+	if (!can_skb_headroom_valid(dev, skb)) {
+		goto inval_skb;
+	} else if (priv->ctrlmode & CAN_CTRLMODE_LISTENONLY) {
+		netdev_info_once(dev,
+				 "interface in listen only mode, dropping skb\n");
 		goto inval_skb;
+	}
 
 	return false;
 
-- 
2.35.1

