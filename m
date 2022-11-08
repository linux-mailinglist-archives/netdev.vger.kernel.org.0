Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E108621855
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 16:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbiKHPd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 10:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234023AbiKHPdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 10:33:54 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335CF56578;
        Tue,  8 Nov 2022 07:33:54 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id l2so14469187pld.13;
        Tue, 08 Nov 2022 07:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=balnWw6j8XIOsjYhADDTptPmlmur+Nmblh0EeRIfPLU=;
        b=FqiSR1brEjxr5GsK3i9vK66YbGkQ3VlVoGwNzHNVWFDCdgSb79zWmvfTHuZ2pKKHjJ
         /qbOiaF0tx9voPiG8AnhkqztcyrD954yDPlu3LbQoWU4STK0zdNyL4QHuvGWVvHTh5qF
         Cusm0K5qk070jbAIhxQIryAbrSgY/4pPuNtvlQ5vADFXtBC+u07Ilac4o7j9rvtxH8ND
         irLDwfWgYWHX19f3Kd0jhbXOHDFh2DL97hw379nbeufD2YIPQuUsYSuRmxp1mKR+VUOz
         LH8yZqRvTCO6sbhCKqbQTaTnMva+1VHY2uppOeoXe+fgYIGo552U12zwrT7iDgj8Mwtg
         d4cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=balnWw6j8XIOsjYhADDTptPmlmur+Nmblh0EeRIfPLU=;
        b=yc9qZALrwFh9JqRTvpGb6bqH6Huk8e75gHhWhuYNgHVzsGzc116RKYlALy2BqfXifA
         k5a6dRhh/+/bgZnf3W7O84nmBoxHM+EpybYE/sWDhCit8JCxvETRL/cRWXLe5Dslb8Lu
         3htgvovL2w+NJjckYiOoPDUtxdgRaGCoXE5vRkojoKXCZGZEYvLSTq6Zn9uMa607tIrh
         oHbmID9MyQRwiWLat4ACBFS0iT4m4+Qbni92z43AnRQJIyi/3u6ImA6SqcWSX1zNi49X
         5E7V4EYhSDMnnHyEPJaX7l7bsdNviq0LOKrwM632w+IwIAvguo0W+42FevuqFeFbvvTc
         26mg==
X-Gm-Message-State: ACrzQf0F9EvZqWdRhvJexOfzK5zoje9CJn2AeL5wc8pSUNC5B/gSTJpa
        aruv2vrEa9GEzrpCva4uzQw=
X-Google-Smtp-Source: AMsMyM5wMYSGCbq1Ws2hgxjqjqlhg3j1d3c+Q62U84eb9ZxgBZ/UvT7yyBllCjwIJIw4beDc2MkiOA==
X-Received: by 2002:a17:902:d1d3:b0:187:3d23:3490 with SMTP id g19-20020a170902d1d300b001873d233490mr38066113plb.149.1667921633724;
        Tue, 08 Nov 2022 07:33:53 -0800 (PST)
Received: from localhost.localdomain ([203.158.52.158])
        by smtp.gmail.com with ESMTPSA id w10-20020a17090a460a00b00213202d77d9sm6243412pjg.43.2022.11.08.07.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 07:33:53 -0800 (PST)
From:   Albert Zhou <albert.zhou.50@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, nic_swsd@realtek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH net-next RFC 1/5] net: move back netif_set_gso_max helpers
Date:   Wed,  9 Nov 2022 02:33:38 +1100
Message-Id: <20221108153342.18979-2-albert.zhou.50@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221108153342.18979-1-albert.zhou.50@gmail.com>
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reverse commit 744d49daf8bd ("net: move netif_set_gso_max helpers") by
moving the functions netif_set_gso_max* back to netdevice.h so that the
updated R8152 v2 driver can use them.

Signed-off-by: Albert Zhou <albert.zhou.50@gmail.com>
---
 include/linux/netdevice.h | 21 +++++++++++++++++++++
 net/core/dev.h            | 21 ---------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eddf8ee270e7..8fa98c67a466 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4952,6 +4952,27 @@ static inline bool netif_needs_gso(struct sk_buff *skb,
 			 (skb->ip_summed != CHECKSUM_UNNECESSARY)));
 }
 
+static inline void netif_set_gso_max_size(struct net_device *dev,
+					  unsigned int size)
+{
+	/* dev->gso_max_size is read locklessly from sk_setup_caps() */
+	WRITE_ONCE(dev->gso_max_size, size);
+}
+
+static inline void netif_set_gso_max_segs(struct net_device *dev,
+					  unsigned int segs)
+{
+	/* dev->gso_max_segs is read locklessly from sk_setup_caps() */
+	WRITE_ONCE(dev->gso_max_segs, segs);
+}
+
+static inline void netif_set_gro_max_size(struct net_device *dev,
+					  unsigned int size)
+{
+	/* This pairs with the READ_ONCE() in skb_gro_receive() */
+	WRITE_ONCE(dev->gro_max_size, size);
+}
+
 void netif_set_tso_max_size(struct net_device *dev, unsigned int size);
 void netif_set_tso_max_segs(struct net_device *dev, unsigned int segs);
 void netif_inherit_tso_max(struct net_device *to,
diff --git a/net/core/dev.h b/net/core/dev.h
index cbb8a925175a..c3a4dc66e4b3 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -88,25 +88,4 @@ int dev_change_carrier(struct net_device *dev, bool new_carrier);
 
 void __dev_set_rx_mode(struct net_device *dev);
 
-static inline void netif_set_gso_max_size(struct net_device *dev,
-					  unsigned int size)
-{
-	/* dev->gso_max_size is read locklessly from sk_setup_caps() */
-	WRITE_ONCE(dev->gso_max_size, size);
-}
-
-static inline void netif_set_gso_max_segs(struct net_device *dev,
-					  unsigned int segs)
-{
-	/* dev->gso_max_segs is read locklessly from sk_setup_caps() */
-	WRITE_ONCE(dev->gso_max_segs, segs);
-}
-
-static inline void netif_set_gro_max_size(struct net_device *dev,
-					  unsigned int size)
-{
-	/* This pairs with the READ_ONCE() in skb_gro_receive() */
-	WRITE_ONCE(dev->gro_max_size, size);
-}
-
 #endif
-- 
2.34.1

