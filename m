Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B56575271D9
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 16:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbiENOSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 10:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbiENOR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 10:17:56 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37E0DFE9;
        Sat, 14 May 2022 07:17:42 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id b12so1138365pju.3;
        Sat, 14 May 2022 07:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZEhSGoMoojYAD36SANNLcism31dWp4f4Nf5+aItJuTY=;
        b=jbklFPhslW+4+HkKyrtVXePxSFmMiySYB9NlkM82qwUxV8msgdLqyTMXdM5J1D4Sj3
         ee47pqFiYwtIU5YThhtubn4Xepiuv3+7H1I83C3XZV6H1nFWvUm3RnPZ5TNjUj+hfoq9
         G4W+V62LmFEBFcc8Qkn2M8/ai4vSycDl7R/rfvkYvg359NOM7aUrW7kYA6QVM8vebaH8
         0c2kVrNGpB5WMhFGulffw2N8wwhSTwgZpJYTsgVVKocnLBinHyXR4PLcc1lc6rvbY+gp
         kc9tWTnBCojyNcT41fq6r6eRMfexRZ9Bqf+WdfcICVefWdyxaVwJNOis3qhjbbxMltva
         BN2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=ZEhSGoMoojYAD36SANNLcism31dWp4f4Nf5+aItJuTY=;
        b=PRZAyr4lvlZ9TTPN6qoNbCAL0dz9enMw0R7T9V2qzBi1ZVZJJDglZkBBaJKmz4KMQ7
         fclA4oEbIAI/qfQ3E/CrE76TgazbaP7DbbXT649b5El/QaFXJ334S4ET1psw+EvkbKiv
         ujSR6mTykx55WoPCCQxnpLddK4NiZ+vvvssX9OrVyjkhbMsr/FijPAxRyZVP/prVZ38d
         Q4r6Z+gTSjZ7aiEWxqMjcRPAJyF5NXaBVtVsWpm4UxfcKPRbMxBbbRn3OUgfBcsMvMK/
         G9YPtNZfVhUUXAI/HmcrF6JdWmJyNdJoNk0MRwfvfgGgrleDXZ1HWiSc7NRLqmCSctrR
         GmQQ==
X-Gm-Message-State: AOAM531NPEa234VDX+YOWkNWHZbeOlGUHYYHm/vxFaMJKmiAVB2dEaO7
        1KIfwNactg+GYttW5om0lGE=
X-Google-Smtp-Source: ABdhPJzUSRBGx8S6BfJhi0bU2llugcyFbguZzUWUlbDGCnMW6DC9OHT0oX2pZFcdesE+mCKW/C6CxA==
X-Received: by 2002:a17:90b:4a4a:b0:1dc:4731:31a4 with SMTP id lb10-20020a17090b4a4a00b001dc473131a4mr10171413pjb.19.1652537862493;
        Sat, 14 May 2022 07:17:42 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id x8-20020a17090a530800b001cd4989feccsm5298541pjh.24.2022.05.14.07.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 07:17:42 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 4/4] can: dev: drop tx skb if in listen only mode
Date:   Sat, 14 May 2022 23:16:50 +0900
Message-Id: <20220514141650.1109542-5-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr>
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
socket. By doing that, it is possible to reach the
net_device_ops::ndo_start_xmit function even if the driver is
configured in listen only mode.

Add a check in can_dropped_invalid_skb() to discard the skb if
CAN_CTRLMODE_LISTENONLY is set.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/dev/skb.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 8b1991130de5..f7420fc43b99 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/can/dev.h>
+#include <linux/can/netlink.h>
 
 /* Local echo of CAN messages
  *
@@ -286,6 +287,7 @@ static bool can_skb_headroom_valid(struct net_device *dev, struct sk_buff *skb)
 bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
 {
 	const struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
+	struct can_priv *priv = netdev_priv(dev);
 
 	if (skb->protocol == htons(ETH_P_CAN)) {
 		if (unlikely(skb->len != CAN_MTU ||
@@ -299,8 +301,13 @@ bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb)
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

