Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1E25131EE
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345341AbiD1LEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345261AbiD1LD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:03:29 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158D79E9EB;
        Thu, 28 Apr 2022 03:59:35 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id n126-20020a1c2784000000b0038e8af3e788so2804186wmn.1;
        Thu, 28 Apr 2022 03:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2Zk8fXv1n2ViDSF6OIwgY/sl4ulWkkPTpvp0fu2VISY=;
        b=VnasJm98PgyBQzES3DFfd3IaxA6YTjNH/hj/4pevOxmkcfpxvQvn+zizcOxRCiDcrb
         8lG5JjR3z13nNihnpZZcxyjRjsVk3X4achKutQBvZkbTAM/oHyXs/E346wGGQJXXvqU6
         7Kkl9RQKhbpknyl1QwmimrUjpLOib/Te3Bkxck5FZRJ/ayU+pTzo7mls9L0gx2MwklSE
         Siik09sFZLNSuFTjQA77VeH5h+DVDelOf1RAdoRJTGzDpzouAwHj21WIOOCLEEmm1XZ/
         GK53MhW/AijDH92KndyLFOCzxaFSRhu4K5adisuntYOgxlWbK04U+UD8ZZYfFHMoTYcE
         9O8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Zk8fXv1n2ViDSF6OIwgY/sl4ulWkkPTpvp0fu2VISY=;
        b=rwlPIc2S1eXcIe+mrOkAqMY2i7BTG10xWMmb2am/H7hoRureTs/qOnsY+Ue6JW6oqZ
         71JxsxcVbprAYOLSqZki3Oirw055l6UZoI3RFixpHMwoPpQ+34mt2y1BjTrOFqaTnGWE
         wGOcMXsQI+A5rDu5sQ3EiloXeZyHtO+xQk0CdeNpwXLLJk6h3bqNgunp8TLsvR76F+qy
         T/wbaqe3V30P5JKTcWKxVjEVGczDxUcQ7WvMtSVAJNRKEkwEjiXQKok42TzOLjGaHpOY
         O+0yrwcq0SOiDYLtTa/gyEf7yWPw1yOfGZU+2dThNRoBd0dnHxlQtlFxmlsxIhnovtLi
         qNnQ==
X-Gm-Message-State: AOAM53264tznohGeE6xnchs4lRQFy4xZKujOxCUQaG4af9RYyccW+BX/
        bXzW77DqFUQYQhnlge1kA4Ahax6Md/Q=
X-Google-Smtp-Source: ABdhPJwn3driW1HdF2RV7PlkZKel27bOnEq7CWM9SilzkhhHdIwXbpfiXcoSL76OG75gTrq14j6Zxg==
X-Received: by 2002:a1c:f315:0:b0:381:1f6d:6ca6 with SMTP id q21-20020a1cf315000000b003811f6d6ca6mr40066156wmq.25.1651143574157;
        Thu, 28 Apr 2022 03:59:34 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id n10-20020a5d588a000000b002052e4aaf89sm16028895wrf.80.2022.04.28.03.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:59:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 3/5] net: inline dev_queue_xmit()
Date:   Thu, 28 Apr 2022 11:58:46 +0100
Message-Id: <99bf2b824f3a4e0428a8be81c8685afe78ffa207.1651141755.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1651141755.git.asml.silence@gmail.com>
References: <cover.1651141755.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 7dccbfd1bf56..3c3bd3381d38 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2940,10 +2940,20 @@ u16 dev_pick_tx_zero(struct net_device *dev, struct sk_buff *skb,
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
index 4a77ebda4fb1..d160c35858df 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4111,7 +4111,7 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
  *      the BH enable code must have IRQs enabled so that it will not deadlock.
  *          --BLG
  */
-static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
+int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 {
 	struct net_device *dev = skb->dev;
 	struct netdev_queue *txq = NULL;
@@ -4235,18 +4235,7 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
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
2.36.0

