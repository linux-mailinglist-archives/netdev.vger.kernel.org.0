Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29996BF937
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 10:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCRJ0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 05:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjCRJ0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 05:26:09 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD496A64;
        Sat, 18 Mar 2023 02:26:07 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id eg48so28896677edb.13;
        Sat, 18 Mar 2023 02:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679131566;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tdMMiIkP0lyseh6vtywDFhyO8m69k1VlrdTiLhNzm4U=;
        b=VwDy5bfT7RmUhazDHzWYdV+oe6pMKzPF8C/D9UCvA66JK7CixE20HRw1+eh5KgRsh0
         ICUei7A5QkE93D+YpqxU38Qkus2iU9DMA+lC2jRjm9ftnzeEXn+ZGtZRCsaJwyfZwlFk
         AZl5CEl99kMlhv0ozBg87AxlEWhk0oEmAILTX2q+j0WiVuSmfLl48u44YJy/6I65tkFD
         z272e72TsR7b89WYuTJGB8u1AqLaqF2WWaRA0PWmrxGEb7efy9ummgYl0qerc7BImpwL
         C6o6uGZRCM+UjEyhk5L+v5/ZX5D/UY52CivT78QoWWWTtixZ/3bvDQVzcuFQA6yX0skK
         /qbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679131566;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tdMMiIkP0lyseh6vtywDFhyO8m69k1VlrdTiLhNzm4U=;
        b=B+moqCC1yEZl8Hhbkx0tDLSyuup5fnJ5Y8nw+SPTURfqrNE+LYwFCUpk5tzR+KyJvq
         dOcknyQkMjKFE5ntQ7IPnrYYQAHw8vr036qMsoetT9CcMdRz7A6gQegtfwR4SqIAadMS
         Oau5cJJrER+WlFVsSaAzywAryn2bSix9MwZKt4IB3IO17hz7Oyy8aWnItDaVbcOIXb0I
         XTKUjkM1Vpl3ALBfxh2rbLkARBQnO7fYupyR8+ZT1wm1E5q0pj3oKUQfXCFzqoK97IMq
         BBAF0czZZESLYiOOjNjPf79Fukp0WMjxC3yfRnGqWMkfTYbblft0byqBw7s05pZpJNiF
         EaTQ==
X-Gm-Message-State: AO0yUKWwZZiOW8HIgx2xcpM15QgEOt6/B5AvgWgCFfWu1gOXifLYUqWv
        7NmkGuZ7jg0+9rDPylacteRwcsk0x/pzxA==
X-Google-Smtp-Source: AK7set+OjN2BAFW2aH/J5J5bydqcNtmjtkMCKLQFry6lNKvTeygQSbzluQYu68Mx6AlMm+W5BE5tvQ==
X-Received: by 2002:a17:906:4909:b0:925:a734:a012 with SMTP id b9-20020a170906490900b00925a734a012mr2107913ejq.12.1679131566295;
        Sat, 18 Mar 2023 02:26:06 -0700 (PDT)
Received: from localhost.localdomain (077222238142.warszawa.vectranet.pl. [77.222.238.142])
        by smtp.googlemail.com with ESMTPSA id la18-20020a170907781200b00914001c91fcsm1953000ejc.86.2023.03.18.02.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 02:26:05 -0700 (PDT)
From:   Szymon Heidrich <szymon.heidrich@gmail.com>
To:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com
Cc:     pabeni@redhat.com, szymon.heidrich@gmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] net: usb: lan78xx: Limit packet length to skb->len
Date:   Sat, 18 Mar 2023 10:25:52 +0100
Message-Id: <20230318092552.93145-1-szymon.heidrich@gmail.com>
X-Mailer: git-send-email 2.40.0
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

Packet length retrieved from descriptor may be larger than
the actual socket buffer length. In such case the cloned
skb passed up the network stack will leak kernel memory contents.

Additionally prevent integer underflow when size is less than
ETH_FCS_LEN.

Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
---
V1 -> V2: Fix ISO C90 forbids mixed declarations and code
V2 -> V3: Removed the Reported-by tag

 drivers/net/usb/lan78xx.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 068488890..c458c030f 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3579,13 +3579,29 @@ static int lan78xx_rx(struct lan78xx_net *dev, struct sk_buff *skb,
 		size = (rx_cmd_a & RX_CMD_A_LEN_MASK_);
 		align_count = (4 - ((size + RXW_PADDING) % 4)) % 4;
 
+		if (unlikely(size > skb->len)) {
+			netif_dbg(dev, rx_err, dev->net,
+				  "size err rx_cmd_a=0x%08x\n",
+				  rx_cmd_a);
+			return 0;
+		}
+
 		if (unlikely(rx_cmd_a & RX_CMD_A_RED_)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "Error rx_cmd_a=0x%08x", rx_cmd_a);
 		} else {
-			u32 frame_len = size - ETH_FCS_LEN;
+			u32 frame_len;
 			struct sk_buff *skb2;
 
+			if (unlikely(size < ETH_FCS_LEN)) {
+				netif_dbg(dev, rx_err, dev->net,
+					  "size err rx_cmd_a=0x%08x\n",
+					  rx_cmd_a);
+				return 0;
+			}
+
+			frame_len = size - ETH_FCS_LEN;
+
 			skb2 = napi_alloc_skb(&dev->napi, frame_len);
 			if (!skb2)
 				return 0;
-- 
2.40.0

