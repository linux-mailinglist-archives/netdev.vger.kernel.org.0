Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184395439C4
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240750AbiFHQzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243660AbiFHQx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:53:26 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F25E3C6D95
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:51:29 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id bg6so22807970ejb.0
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 09:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I5VTRziMnkGl4xU+BjwtCkmgql6hb+Z7QIN+Rj1ilOY=;
        b=GL2/5+TAp2pCEdHfQjTf3qp6TnHIgDKiGZCM9GYA8KeppoGt7LaELuW2XfFj50OSGV
         +ms6qSWcZgedGSWQOsfL6aFERIBd8eSMCSsty6uIUF0t/ZMQtv+mfrB5sRhpMXrq+Se7
         t375ns2CbOCjT/WTu6fER4CUTRIteo+P7v+KA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I5VTRziMnkGl4xU+BjwtCkmgql6hb+Z7QIN+Rj1ilOY=;
        b=nXVG2HYiwuf2j4aVgku9y767ASncJx69i7RLiYuKnCqI6W7Veylgb9R59cKLlp/a0+
         4/wPVhuBL22qWScbv0chILGCdvvWvxiHALohwTixoY+N3E38oZCPkj6h3d87CUmiMeFS
         DzRbzO6ZK5EY1xQ74JNFkeH2AC941VXqNzQ6vVPpFIPgVAP06fY2km5pyHVVNksUDNhL
         Px8MnIVqq54LkI28/LjKzgYZ0VJmnGSXn6pcTOmBKj9IZln9MgrIqxmydUUGJbftM1h7
         3vRhyP3jC0HRFzxdH8ViVo3LTjZyTjh4Qdb/g8b9CF3Q1cWMzcxQZYvv7W6R0P9Wdcqz
         3z0g==
X-Gm-Message-State: AOAM531joMLqbPbBfD2ifl0ducWpLo16Wc9XEuOvV6Yq239Bldf6yQJ7
        VE5bD+230ZSyPBq6MldWiaTdlA==
X-Google-Smtp-Source: ABdhPJyZoLJRVZQupGQWtXsIWh3QTK3xk6DJUkI7csBK98pda16YzwvC04ry6ZVCTx7GS1yDfbvy3g==
X-Received: by 2002:a17:906:9f1c:b0:711:cdda:a01f with SMTP id fy28-20020a1709069f1c00b00711cddaa01fmr16104703ejc.372.1654707087890;
        Wed, 08 Jun 2022 09:51:27 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id c22-20020a17090654d600b0070587f81bcfsm9569071ejp.19.2022.06.08.09.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:51:27 -0700 (PDT)
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
Subject: [PATCH v2 03/13] can: slcan: use the alloc_can_skb() helper
Date:   Wed,  8 Jun 2022 18:51:06 +0200
Message-Id: <20220608165116.1575390-4-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220608165116.1575390-1-dario.binacchi@amarulasolutions.com>
References: <20220608165116.1575390-1-dario.binacchi@amarulasolutions.com>
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

It is used successfully by most (if not all) CAN device drivers. It
allows to remove replicated code.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

Changes in v2:
- Put the data into the allocated skb directly instead of first
  filling the "cf" on the stack and then doing a memcpy().

 drivers/net/can/slcan.c | 69 +++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 37 deletions(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 6162a9c21672..5d87e25e2285 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -54,6 +54,7 @@
 #include <linux/kernel.h>
 #include <linux/workqueue.h>
 #include <linux/can.h>
+#include <linux/can/dev.h>
 #include <linux/can/skb.h>
 #include <linux/can/can-ml.h>
 
@@ -143,85 +144,79 @@ static struct net_device **slcan_devs;
 static void slc_bump(struct slcan *sl)
 {
 	struct sk_buff *skb;
-	struct can_frame cf;
+	struct can_frame *cf;
 	int i, tmp;
 	u32 tmpid;
 	char *cmd = sl->rbuff;
 
-	memset(&cf, 0, sizeof(cf));
+	skb = alloc_can_skb(sl->dev, &cf);
+	if (unlikely(!skb)) {
+		sl->dev->stats.rx_dropped++;
+		return;
+	}
 
 	switch (*cmd) {
 	case 'r':
-		cf.can_id = CAN_RTR_FLAG;
+		cf->can_id = CAN_RTR_FLAG;
 		fallthrough;
 	case 't':
 		/* store dlc ASCII value and terminate SFF CAN ID string */
-		cf.len = sl->rbuff[SLC_CMD_LEN + SLC_SFF_ID_LEN];
+		cf->len = sl->rbuff[SLC_CMD_LEN + SLC_SFF_ID_LEN];
 		sl->rbuff[SLC_CMD_LEN + SLC_SFF_ID_LEN] = 0;
 		/* point to payload data behind the dlc */
 		cmd += SLC_CMD_LEN + SLC_SFF_ID_LEN + 1;
 		break;
 	case 'R':
-		cf.can_id = CAN_RTR_FLAG;
+		cf->can_id = CAN_RTR_FLAG;
 		fallthrough;
 	case 'T':
-		cf.can_id |= CAN_EFF_FLAG;
+		cf->can_id |= CAN_EFF_FLAG;
 		/* store dlc ASCII value and terminate EFF CAN ID string */
-		cf.len = sl->rbuff[SLC_CMD_LEN + SLC_EFF_ID_LEN];
+		cf->len = sl->rbuff[SLC_CMD_LEN + SLC_EFF_ID_LEN];
 		sl->rbuff[SLC_CMD_LEN + SLC_EFF_ID_LEN] = 0;
 		/* point to payload data behind the dlc */
 		cmd += SLC_CMD_LEN + SLC_EFF_ID_LEN + 1;
 		break;
 	default:
-		return;
+		goto decode_failed;
 	}
 
 	if (kstrtou32(sl->rbuff + SLC_CMD_LEN, 16, &tmpid))
-		return;
+		goto decode_failed;
 
-	cf.can_id |= tmpid;
+	cf->can_id |= tmpid;
 
 	/* get len from sanitized ASCII value */
-	if (cf.len >= '0' && cf.len < '9')
-		cf.len -= '0';
+	if (cf->len >= '0' && cf->len < '9')
+		cf->len -= '0';
 	else
-		return;
+		goto decode_failed;
 
 	/* RTR frames may have a dlc > 0 but they never have any data bytes */
-	if (!(cf.can_id & CAN_RTR_FLAG)) {
-		for (i = 0; i < cf.len; i++) {
+	if (!(cf->can_id & CAN_RTR_FLAG)) {
+		for (i = 0; i < cf->len; i++) {
 			tmp = hex_to_bin(*cmd++);
 			if (tmp < 0)
-				return;
-			cf.data[i] = (tmp << 4);
+				goto decode_failed;
+
+			cf->data[i] = (tmp << 4);
 			tmp = hex_to_bin(*cmd++);
 			if (tmp < 0)
-				return;
-			cf.data[i] |= tmp;
+				goto decode_failed;
+
+			cf->data[i] |= tmp;
 		}
 	}
 
-	skb = dev_alloc_skb(sizeof(struct can_frame) +
-			    sizeof(struct can_skb_priv));
-	if (!skb)
-		return;
-
-	skb->dev = sl->dev;
-	skb->protocol = htons(ETH_P_CAN);
-	skb->pkt_type = PACKET_BROADCAST;
-	skb->ip_summed = CHECKSUM_UNNECESSARY;
-
-	can_skb_reserve(skb);
-	can_skb_prv(skb)->ifindex = sl->dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
-
-	skb_put_data(skb, &cf, sizeof(struct can_frame));
-
 	sl->dev->stats.rx_packets++;
-	if (!(cf.can_id & CAN_RTR_FLAG))
-		sl->dev->stats.rx_bytes += cf.len;
+	if (!(cf->can_id & CAN_RTR_FLAG))
+		sl->dev->stats.rx_bytes += cf->len;
 
 	netif_rx(skb);
+	return;
+
+decode_failed:
+	dev_kfree_skb(skb);
 }
 
 /* parse tty input stream */
-- 
2.32.0

