Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C2853C8C5
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 12:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243737AbiFCKat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 06:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243703AbiFCKaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 06:30:07 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3283B3F8;
        Fri,  3 Jun 2022 03:30:06 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id g184so6924325pgc.1;
        Fri, 03 Jun 2022 03:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wPNc3YvhAKuZLbvOFj+YsMRBSINjKQKB6Tw7aOecxnY=;
        b=fjr/YLTf3JpqKnGPXEQKWeEulEUL8Cbj+DXC0/q/+SmEvIEwQN+MSO/KtRcHNn0rJk
         eUSFlvhs5UgDYRyVN6rLyBer6rEPqmDE2tWw0YhIlwI3hJF5s4IjVSjWuKp1DyE6Qz5B
         y3VUQgTdrgZeU1+9bWiD3+4oWVieffOuFQe3azHhxy7kbM/UeatWVzSobWW8fspD4xSE
         lipg7a4myWbMi/MShhgm8UgYmzPZs3TZkXW9bsqyygYlEkwQlOkjUejz/VhjO+8eJ3ET
         7WHn+dgANiC/saQ2YKliXM6bmBHpSH16MpatSgt4+vh+jwuZyRyekz6kP5htvHuvbj6x
         fSIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=wPNc3YvhAKuZLbvOFj+YsMRBSINjKQKB6Tw7aOecxnY=;
        b=BuKQltO/EsD8CWvtXvzwTcvPBYGMR7UO9NhLVYbIZ7rCDSw1B1fgFl68KVyzLnujvL
         wRUWJQ4pgaD6NartZWr5S7UuqpvSBTVG6g6tExGW5L5NFCiSXzO3v7UbgOsLpkgEJg7U
         x9WxEs4T49FPEZv+E+9g7o4jeefjBIDz5lBciCcOgFUr7StTDbQHHQxXNOSuE5A69CAy
         UJd5eIK5cmAYejQX1X4n6EIkPtYN/5vPtGu5ukYmzahI3SZNbCfTtiMAkSOYgvNnQ8+C
         yXx8h4J9UPWM7x7R2sa49JXKT3X2htvrck16yQ/d5jlpswwILb6Z+6xiSqvGYgCmHCct
         zpwA==
X-Gm-Message-State: AOAM530XAQGGCw1laRJLv/7Y+fL3K/DET3rneZVGyNTbVckUJtrFEy/E
        DeKLwM3htbCBZb0GS/7IZoQ=
X-Google-Smtp-Source: ABdhPJxRZSY2Y41lUKakBuNRWE1suXBEeYOsiKYabI9XVLbzYny3MxFQlKEPpazCvwmDmlnK5iF7ZA==
X-Received: by 2002:a05:6a00:1c4e:b0:51b:ebf1:53c4 with SMTP id s14-20020a056a001c4e00b0051bebf153c4mr492238pfw.49.1654252205674;
        Fri, 03 Jun 2022 03:30:05 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id b22-20020a056a0002d600b0050dc7628182sm3041676pft.92.2022.06.03.03.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 03:30:05 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v4 7/7] can: skb: drop tx skb if in listen only mode
Date:   Fri,  3 Jun 2022 19:28:48 +0900
Message-Id: <20220603102848.17907-8-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
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

