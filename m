Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B744F09AA
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358666AbiDCNK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358681AbiDCNK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:29 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E71F68
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:29 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n63-20020a1c2742000000b0038d0c31db6eso4097198wmn.1
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zMAqAkJjLHteJHC+8R6JZHKtOKmA+0ISlxrtx+knh+U=;
        b=Vl3eTujJ3Cm6qQ924Yg6Z7yFygWMi6uozeKs1qVM5XtTR4YLYSpSTHEQ+SsoW5Ig6r
         DjdBlonHCs93ohwFZ/7GibdEX6/O8FFMPiDfgu70TSr8CS7cEE42kENDQLfZdU3yIGDw
         WowNwk1okbPBIEWNEOvdBWCRiPvwRi8n40ykcHqjIfhyc0TxHBz6C3/HTKM5mBY0nJX9
         0OlOgYLGKynkPSIuBM5enbzJKilgh6M9/u+ZGJ3lqoLCnps6ToK0ylgtXHVnDABwOZj5
         WhYXCvntcQDH1CpMHSJIE+Sq80piDuwtBllm+uG+n1CqDANFXjw0lIrNulb0K2T8Smot
         pHqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zMAqAkJjLHteJHC+8R6JZHKtOKmA+0ISlxrtx+knh+U=;
        b=yP5IzDKvdRPRGEizb9MTNciqSN6WUT476Hqgw8yBH1gvnTql21gp1uPRP+A+au9evb
         gltmkdnwQDPRByvoq506ZUiKITk4unK905RZZXZOrNNDdUPhb6cVAYjmPx+zmeWAStWq
         KuyedqsiqjLh2+BUGTB8fd8EmeEbXDlpU+HGR9YoaRPvGelFjNRwvscw3JhOgjKh6ULv
         Ss9GKduL1l9aEHcmPDOcHf096CG89Sxl1aTSetvijam+cLVr3oymaxORCWFq65KDVVYc
         2oAhgvxdRrdKQ8UfgYLQV7a5TwbzaccWQhXYZ7FAZWgT4Bkv1jJbcVAPpea8HUo3glRJ
         0+bw==
X-Gm-Message-State: AOAM530GFDWUNDabYE9zu63sVutwTBpRxDNYB7tyZnSmFbg7wVZbXbgk
        WDjsqWMy6dxO2e/ar3LvAlS2YN7fTvA=
X-Google-Smtp-Source: ABdhPJyAHQu8S8Yp9iV/YArIKcWkrDisznt/wYpcIAK0W7tDUV07QgZJKSu4/0ioKMtBuLgu73yyfg==
X-Received: by 2002:a7b:ce8e:0:b0:38e:70fb:9778 with SMTP id q14-20020a7bce8e000000b0038e70fb9778mr844746wmj.65.1648991308247;
        Sun, 03 Apr 2022 06:08:28 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 15/27] net: inline dev_queue_xmit()
Date:   Sun,  3 Apr 2022 14:06:27 +0100
Message-Id: <aad78b4885b5c5c7aeded24f7e0c2cc5e108e696.1648981571.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
References: <cover.1648981570.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Inline dev_queue_xmit() and dev_queue_xmit_accel(), they both are small
proxy functions doing nothing but redirecting the control flow to
__dev_queue_xmit().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/netdevice.h | 14 ++++++++++++--
 net/core/dev.c            | 15 ++-------------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a4e41f7edc47..6aca1f3b21ff 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2932,10 +2932,20 @@ u16 dev_pick_tx_zero(struct net_device *dev, struct sk_buff *skb,
 u16 dev_pick_tx_cpu_id(struct net_device *dev, struct sk_buff *skb,
 		       struct net_device *sb_dev);
 
-int dev_queue_xmit(struct sk_buff *skb);
-int dev_queue_xmit_accel(struct sk_buff *skb, struct net_device *sb_dev);
+int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev);
 int __dev_direct_xmit(struct sk_buff *skb, u16 queue_id);
 
+static inline int dev_queue_xmit(struct sk_buff *skb)
+{
+	return __dev_queue_xmit(skb, NULL);
+}
+
+static inline int dev_queue_xmit_accel(struct sk_buff *skb,
+				       struct net_device *sb_dev)
+{
+	return __dev_queue_xmit(skb, sb_dev);
+}
+
 static inline int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
 {
 	int ret;
diff --git a/net/core/dev.c b/net/core/dev.c
index 6044b6124edc..ed5459552117 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4084,7 +4084,7 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
  *      the BH enable code must have IRQs enabled so that it will not deadlock.
  *          --BLG
  */
-static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
+int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 {
 	struct net_device *dev = skb->dev;
 	struct netdev_queue *txq;
@@ -4200,18 +4200,7 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	rcu_read_unlock_bh();
 	return rc;
 }
-
-int dev_queue_xmit(struct sk_buff *skb)
-{
-	return __dev_queue_xmit(skb, NULL);
-}
-EXPORT_SYMBOL(dev_queue_xmit);
-
-int dev_queue_xmit_accel(struct sk_buff *skb, struct net_device *sb_dev)
-{
-	return __dev_queue_xmit(skb, sb_dev);
-}
-EXPORT_SYMBOL(dev_queue_xmit_accel);
+EXPORT_SYMBOL(__dev_queue_xmit);
 
 int __dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
 {
-- 
2.35.1

