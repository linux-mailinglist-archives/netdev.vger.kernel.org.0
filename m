Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4B96BED12
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbjCQPd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjCQPd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:33:56 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88F5C6DAA;
        Fri, 17 Mar 2023 08:33:24 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id x3so21876417edb.10;
        Fri, 17 Mar 2023 08:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679067203;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=27qzIXnG5Q0jlHks1WKj+gQu5XLTMem69qV8hoKqr4o=;
        b=Q3Qs7w86vWTu0qFSZmy7ISmo7+EQIE7FBiOa9alFZ4lDoKdZCggHwEW462NmlunnA5
         J4dY0zcttWSNQBOaytcF8OkvjdWEiiLjPPU7ObttshBG11d0n6s+l76xKLNJIDRvNh5+
         1XQFJ7+PZfD+/2EQ+1gGwAue6GUjScfHUclSkZqCOCa7gyGjuuKmKna/msNLfC/iuwWQ
         US2GKy3wm3jRXIWDEhdWCNz0MtJ8qod7dyL2OHkwrLnIh2jAt0eSg6V8vzxxVcnZZxc9
         RRHKCThHgUTN0PT4rgKp6GFl/0J01BJibJz74j8tbulqCwW9RFD23p1yRjkmLfNSWOQV
         x2EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679067203;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=27qzIXnG5Q0jlHks1WKj+gQu5XLTMem69qV8hoKqr4o=;
        b=lKq3DGmeJxDn5TVHO1Vf/qgq2UhJ/p2VRyDZ+U8Sy5QQaPXiDBnYF+8l1CbuQKImnr
         0frZbXSoxQCMdrcnOZDmsxeK6/XWwnYoB6VCTEEk4cFCIcvqAsCIrHli/Ud6c48hX0K+
         kX5FgCEo05M7Es/3WAwbtFj6YGAhmge5AnARXI87A9+9SdZa+7spRGN45jKaqEryY3kd
         CAg6BZV7K1Q06WcZPxkPViSDRu38/jGutig3XWiFrMXRMoDTeKKIBhBqtxEIuSwZndAP
         Q80nkGV/ubTaeoq7WZI81l5exQyuhc8JdH070a4cRGV1UciOmLVWJP8OEF2cJbHcMjp5
         GWfA==
X-Gm-Message-State: AO0yUKVIsVUTHLmLb29DlBhjkW/FXDzmN74rKVYPNwz0fGsaVLIrwwzC
        a333YDxbApmxwbJMoqfU3kc=
X-Google-Smtp-Source: AK7set+vuy4s6wk17ZUKz4gBWr6CjZTRLrcpNGZj9AnMZ0q96JjcBRbiZUCXF352NzJbQKu4Ff9+AA==
X-Received: by 2002:a17:906:a0e:b0:91e:acf4:b009 with SMTP id w14-20020a1709060a0e00b0091eacf4b009mr15142786ejf.22.1679067202968;
        Fri, 17 Mar 2023 08:33:22 -0700 (PDT)
Received: from localhost.localdomain (077222238142.warszawa.vectranet.pl. [77.222.238.142])
        by smtp.googlemail.com with ESMTPSA id b7-20020a1709064d4700b0092be5f60dd5sm1081845ejv.150.2023.03.17.08.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 08:33:20 -0700 (PDT)
From:   Szymon Heidrich <szymon.heidrich@gmail.com>
To:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com
Cc:     pabeni@redhat.com, szymon.heidrich@gmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: usb: lan78xx: Limit packet length to skb->len
Date:   Fri, 17 Mar 2023 16:32:17 +0100
Message-Id: <20230317153217.90145-1-szymon.heidrich@gmail.com>
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
 drivers/net/usb/lan78xx.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 068488890..e7d27be84 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3579,10 +3579,24 @@ static int lan78xx_rx(struct lan78xx_net *dev, struct sk_buff *skb,
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
+			if (unlikely(size < ETH_FCS_LEN)) {
+				netif_dbg(dev, rx_err, dev->net,
+					  "size err rx_cmd_a=0x%08x\n",
+					  rx_cmd_a);
+				return 0;
+			}
+
 			u32 frame_len = size - ETH_FCS_LEN;
 			struct sk_buff *skb2;
 
-- 
2.40.0

