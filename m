Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F6055E9EB
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238541AbiF1Qfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236832AbiF1Qeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:34:46 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E89F3207A
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:31:52 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id lw20so26938298ejb.4
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lfqn0geMWlo2m+epnZ6MFo0Gce8D/c5YwbUMrCOB20U=;
        b=hdJIVy+sH8SAoKYHCd0pK6GgiKA/ahM/vAB/B8teozlaamYqheunsZs7xFoeexFBo5
         Q//2O2BW0K1zPYL27x7Xos72HdJS1VSW9cS0bDlSRac6Qx88hlTzme38l0Mgdb7RFMK2
         oQs8Xx3Lioqg8OxdDWfNnFITPUgQBVb0ZoOSY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lfqn0geMWlo2m+epnZ6MFo0Gce8D/c5YwbUMrCOB20U=;
        b=yXH/2OLhEao1bEEFvK7+5bH/UUp9CTbHY5PtNKAynJHZQcKBj04yHEmp6r/fmLOjAW
         OYdjwlmiDBUMWBIUF46U95p5/KhhETQyXb/bHBY0pWxhX4R9EcYkV2mdy/A91dgbqWbq
         F3OaWMrFFFvOc7V0Y3ufMPx1bx1kKB4/LxlRA42a9Gzb4RhaZm+ZdVKgbPks3+b/o38D
         FlyRnm3k1dNTBJcKqJsW4MhaXcZ/ujFHfcgqh0kx2ygOsIt+YN/e3wXmbGO5y1QlK5T/
         5H2YUFgCl/ecQoa/xvvM6E7JmEVKOy/v3Y8G2y+7sAj4NvGHIEE7XEDWbejjmjaser5x
         efbw==
X-Gm-Message-State: AJIora/ZLqg0IIyMCNF3JYP1NTmlrKTUfjKLGjaJYm5JvCnBgI1MXxeY
        OjU7fgrBI+sxD0nu8cmfJynyxg==
X-Google-Smtp-Source: AGRyM1va/ANdVjEy/roqJmN6w30prNjI7JbBTV/MjmBAoyOEiqjmkf272znx6kVqX5sIAKnC+tiOkg==
X-Received: by 2002:a17:907:948a:b0:726:f3d7:c7d6 with SMTP id dm10-20020a170907948a00b00726f3d7c7d6mr1288628ejc.2.1656433912584;
        Tue, 28 Jun 2022 09:31:52 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id b20-20020a0564021f1400b0042e15364d14sm9916952edb.8.2022.06.28.09.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 09:31:51 -0700 (PDT)
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
Subject: [PATCH v5 03/12] can: slcan: use the alloc_can_skb() helper
Date:   Tue, 28 Jun 2022 18:31:27 +0200
Message-Id: <20220628163137.413025-4-dario.binacchi@amarulasolutions.com>
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

It is used successfully by most (if not all) CAN device drivers. It
allows to remove replicated code.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

(no changes since v3)

Changes in v3:
- Increment the error counter in case of decoding failure.

Changes in v2:
- Put the data into the allocated skb directly instead of first
  filling the "cf" on the stack and then doing a memcpy().

 drivers/net/can/slcan.c | 70 +++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 37 deletions(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 6162a9c21672..c39580b142e0 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -54,6 +54,7 @@
 #include <linux/kernel.h>
 #include <linux/workqueue.h>
 #include <linux/can.h>
+#include <linux/can/dev.h>
 #include <linux/can/skb.h>
 #include <linux/can/can-ml.h>
 
@@ -143,85 +144,80 @@ static struct net_device **slcan_devs;
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
+	sl->dev->stats.rx_errors++;
+	dev_kfree_skb(skb);
 }
 
 /* parse tty input stream */
-- 
2.32.0

