Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1AAC54685F
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 16:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349554AbiFJObd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 10:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349310AbiFJOaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 10:30:55 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B97110D915;
        Fri, 10 Jun 2022 07:30:54 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id f65so14737470pgc.7;
        Fri, 10 Jun 2022 07:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=43CpBkkYSkHeDwLmKH9bOCSJPMjYFpVfIO7393yp+kk=;
        b=Enfd+ABX+s9yGl+exkjto2PH9ZaFm1UL0xW05IEb1taBAslH9zxWWwvsdJB6WIm8Gm
         wQSix0IGjF3iOTkrcPy504jmORlCYcafqWJgfp7nURNQsNW6EdJFLLLr1hJHWbY18ZIi
         AJ2z+bhggT6cuPH+FfsXrE8xSpf94ubFZAcRn5huGhoT41/xBrdTtFxtGPeG/BDCRjV2
         bNHLToxagwCRcSnfYxcn/NTMySW8NcherhqZPeLUj26ERZZV1GOKpAMXVOF6IatObiJ0
         O1lTgQd4T52cyGpxjSydFZxeAo+wDeCELiGx3x2VEcPNOYPOFqHNrGxAAONBiArff64K
         va7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=43CpBkkYSkHeDwLmKH9bOCSJPMjYFpVfIO7393yp+kk=;
        b=zha40Bn77rv5YxzAY7ELNFTbimzFU2z1ju6ydXcd6wDcFCy4XcgJkS892++YNDS6Wv
         aBd4Bitxuywlpysj4kTUT7N3enwCr09FMfJ4LFY+jcaN0Apj0C9Yw6SmUriJqukIxCU+
         BCBalPutRiwAz20x1cBtgb+Nw51SkLQ8Y+PZs7N6ZDFnlV6+km2Jd5Xvsxk4TpzlJCst
         9MYm2YqZI6R/msL3eSacHRl9U3AoWA7HRC1IIz520z/Pe+hpJSnwKvEN2M4hFX/d+p/V
         ICxac7lNii3nsyyi3r7OFdRD7g6ghjF7td3qUrDSFsFCTSQ1PFPX2DGcP0lTzfKmlBjA
         Uvvg==
X-Gm-Message-State: AOAM533GENeFdiijUVYSwLCQ75VAS9O4UVGB+T/p/USMIOaFUWETYuwM
        E0zJzIStr/PMkbtuVLpMqIg=
X-Google-Smtp-Source: ABdhPJyLlLZIqAtvm8EyCwoFtcTrx0cLUEaBeiR8lD2OrqjG5jHfggug6BnpC9NvaIPjtKTAqemiSw==
X-Received: by 2002:a63:6c44:0:b0:3fa:ec6b:33e7 with SMTP id h65-20020a636c44000000b003faec6b33e7mr39210126pgc.435.1654871453608;
        Fri, 10 Jun 2022 07:30:53 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id s6-20020a170902ea0600b0016232dbd01fsm18851339plg.292.2022.06.10.07.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 07:30:53 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v6 6/7] can: skb: move can_dropped_invalid_skb() and can_skb_headroom_valid() to skb.c
Date:   Fri, 10 Jun 2022 23:30:08 +0900
Message-Id: <20220610143009.323579-7-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220610143009.323579-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220610143009.323579-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The functions can_dropped_invalid_skb() and can_skb_headroom_valid()
grew a lot over the years to a point which it does not make much sense
to have them defined as static inline in header files. Move those two
functions to the .c counterpart of skb.h.

can_skb_headroom_valid()'s only caller being
can_dropped_invalid_skb(), the declaration is removed from the
header. Only can_dropped_invalid_skb() gets its symbol exported.

While doing so, do a small cleanup: add brackets around the else block
in can_dropped_invalid_skb().

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/dev/skb.c | 58 ++++++++++++++++++++++++++++++++++++++
 include/linux/can/skb.h   | 59 +--------------------------------------
 2 files changed, 59 insertions(+), 58 deletions(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index a4208f125b76..dc9da76c0470 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -259,3 +259,61 @@ struct sk_buff *alloc_can_err_skb(struct net_device *dev, struct can_frame **cf)
 	return skb;
 }
 EXPORT_SYMBOL_GPL(alloc_can_err_skb);
+
+/* Check for outgoing skbs that have not been created by the CAN subsystem */
+static bool can_skb_headroom_valid(struct net_device *dev, struct sk_buff *skb)
+{
+	/* af_packet creates a headroom of HH_DATA_MOD bytes which is fine */
+	if (WARN_ON_ONCE(skb_headroom(skb) < sizeof(struct can_skb_priv)))
+		return false;
+
+	/* af_packet does not apply CAN skb specific settings */
+	if (skb->ip_summed == CHECKSUM_NONE) {
+		/* init headroom */
+		can_skb_prv(skb)->ifindex = dev->ifindex;
+		can_skb_prv(skb)->skbcnt = 0;
+
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+		/* perform proper loopback on capable devices */
+		if (dev->flags & IFF_ECHO)
+			skb->pkt_type = PACKET_LOOPBACK;
+		else
+			skb->pkt_type = PACKET_HOST;
+
+		skb_reset_mac_header(skb);
+		skb_reset_network_header(skb);
+		skb_reset_transport_header(skb);
+	}
+
+	return true;
+}
+
+/* Drop a given socketbuffer if it does not contain a valid CAN frame. */
+bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
+{
+	const struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
+
+	if (skb->protocol == htons(ETH_P_CAN)) {
+		if (unlikely(skb->len != CAN_MTU ||
+			     cfd->len > CAN_MAX_DLEN))
+			goto inval_skb;
+	} else if (skb->protocol == htons(ETH_P_CANFD)) {
+		if (unlikely(skb->len != CANFD_MTU ||
+			     cfd->len > CANFD_MAX_DLEN))
+			goto inval_skb;
+	} else {
+		goto inval_skb;
+	}
+
+	if (!can_skb_headroom_valid(dev, skb))
+		goto inval_skb;
+
+	return false;
+
+inval_skb:
+	kfree_skb(skb);
+	dev->stats.tx_dropped++;
+	return true;
+}
+EXPORT_SYMBOL_GPL(can_dropped_invalid_skb);
diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index fdb22b00674a..182749e858b3 100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -31,6 +31,7 @@ struct sk_buff *alloc_canfd_skb(struct net_device *dev,
 				struct canfd_frame **cfd);
 struct sk_buff *alloc_can_err_skb(struct net_device *dev,
 				  struct can_frame **cf);
+bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb);
 
 /*
  * The struct can_skb_priv is used to transport additional information along
@@ -96,64 +97,6 @@ static inline struct sk_buff *can_create_echo_skb(struct sk_buff *skb)
 	return nskb;
 }
 
-/* Check for outgoing skbs that have not been created by the CAN subsystem */
-static inline bool can_skb_headroom_valid(struct net_device *dev,
-					  struct sk_buff *skb)
-{
-	/* af_packet creates a headroom of HH_DATA_MOD bytes which is fine */
-	if (WARN_ON_ONCE(skb_headroom(skb) < sizeof(struct can_skb_priv)))
-		return false;
-
-	/* af_packet does not apply CAN skb specific settings */
-	if (skb->ip_summed == CHECKSUM_NONE) {
-		/* init headroom */
-		can_skb_prv(skb)->ifindex = dev->ifindex;
-		can_skb_prv(skb)->skbcnt = 0;
-
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
-
-		/* perform proper loopback on capable devices */
-		if (dev->flags & IFF_ECHO)
-			skb->pkt_type = PACKET_LOOPBACK;
-		else
-			skb->pkt_type = PACKET_HOST;
-
-		skb_reset_mac_header(skb);
-		skb_reset_network_header(skb);
-		skb_reset_transport_header(skb);
-	}
-
-	return true;
-}
-
-/* Drop a given socketbuffer if it does not contain a valid CAN frame. */
-static inline bool can_dropped_invalid_skb(struct net_device *dev,
-					  struct sk_buff *skb)
-{
-	const struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
-
-	if (skb->protocol == htons(ETH_P_CAN)) {
-		if (unlikely(skb->len != CAN_MTU ||
-			     cfd->len > CAN_MAX_DLEN))
-			goto inval_skb;
-	} else if (skb->protocol == htons(ETH_P_CANFD)) {
-		if (unlikely(skb->len != CANFD_MTU ||
-			     cfd->len > CANFD_MAX_DLEN))
-			goto inval_skb;
-	} else
-		goto inval_skb;
-
-	if (!can_skb_headroom_valid(dev, skb))
-		goto inval_skb;
-
-	return false;
-
-inval_skb:
-	kfree_skb(skb);
-	dev->stats.tx_dropped++;
-	return true;
-}
-
 static inline bool can_is_canfd_skb(const struct sk_buff *skb)
 {
 	/* the CAN specific type of skb is identified by its data length */
-- 
2.35.1

