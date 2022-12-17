Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9481A64FAFB
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 17:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiLQQTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 11:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiLQQTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 11:19:18 -0500
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FB3FAF6;
        Sat, 17 Dec 2022 08:19:16 -0800 (PST)
Received: by mail-pl1-f172.google.com with SMTP id d15so5153601pls.6;
        Sat, 17 Dec 2022 08:19:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YSNNqpsp+6ju7vLQLBaXrvpbttZ9LPvs/Uw4aW9SDeo=;
        b=yKnJ1awjgn7KUqULVHjdOMU61aIfBRb4WGdZjTCdxp8ck8rSBZIF81dAfhjoTW7A3K
         xqXyVGXC0IN67kU6PMbPUrk8bnDj6Rb0qhjgrjh/thPCDsnoUYEslDM/kzJlWo88+E5O
         zZD2VkDT8B5Rz+BDM0p8xNqfB5Yxy6twIAhBxkhzx5Q9OeSE/1Eh6FzY/YdFISwQW3Eb
         tSOefy5DuDFhn+T51XaeKaEVO993aanRWeDj/MxVlvzva+cJOfvunPZzGzF5lEjRVV3P
         PBbgynTgf0y0RA29Zl6CHQ54yVJjqZFItxK+sz1Xspl4Rguq1sP9yTBaBd2HFp2LyRBZ
         2P5w==
X-Gm-Message-State: ANoB5pnJeE7kVWxBIaNd3QiRXX1k1ioYNDUoJtbYBPrb9kWVXK3v/Z6R
        nLS6iLtUga5X5wAs5vSP4nQ=
X-Google-Smtp-Source: AA0mqf6YsrJm/7RjWbwCC3qNvpn+nHnKEMHx5bQ2ETaghl7OzUYaqU1qcV9uyxtABLtljZj/UM5Jog==
X-Received: by 2002:a05:6a20:662f:b0:a4:cb41:298f with SMTP id n47-20020a056a20662f00b000a4cb41298fmr32354466pzh.6.1671293956208;
        Sat, 17 Dec 2022 08:19:16 -0800 (PST)
Received: from localhost.localdomain ([14.4.134.166])
        by smtp.gmail.com with ESMTPSA id w9-20020a62c709000000b005745635c5b5sm3310513pfg.183.2022.12.17.08.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 08:19:15 -0800 (PST)
From:   Leesoo Ahn <lsahn@ooseel.net>
To:     lsahn@ooseel.net
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usbnet: jump to rx_cleanup case instead of calling skb_queue_tail
Date:   Sun, 18 Dec 2022 01:18:51 +0900
Message-Id: <20221217161851.829497-1-lsahn@ooseel.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current source pushes skb into dev->done queue by calling
skb_queue_tail() and then, call skb_dequeue() to pop for rx_cleanup state
to free urb and skb next in usbnet_bh().
It wastes CPU resource with extra instructions. Instead, use return values
jumping to rx_cleanup case directly to free them. Therefore calling
skb_queue_tail() and skb_dequeue() is not necessary.

The follows are just showing difference between calling skb_queue_tail()
and using return values jumping to rx_cleanup state directly in usbnet_bh()
in Arm64 instructions with perf tool.

----------- calling skb_queue_tail() -----------
       │     if (!(dev->driver_info->flags & FLAG_RX_ASSEMBLE))
  7.58 │248:   ldr     x0, [x20, #16]
  2.46 │24c:   ldr     w0, [x0, #8]
  1.64 │250: ↑ tbnz    w0, #14, 16c
       │     dev->net->stats.rx_errors++;
  0.57 │254:   ldr     x1, [x20, #184]
  1.64 │258:   ldr     x0, [x1, #336]
  2.65 │25c:   add     x0, x0, #0x1
       │260:   str     x0, [x1, #336]
       │     skb_queue_tail(&dev->done, skb);
  0.38 │264:   mov     x1, x19
       │268:   mov     x0, x21
  2.27 │26c: → bl      skb_queue_tail
  0.57 │270: ↑ b       44    // branch to call skb_dequeue()

----------- jumping to rx_cleanup state -----------
       │     if (!(dev->driver_info->flags & FLAG_RX_ASSEMBLE))
  1.69 │25c:   ldr     x0, [x21, #16]
  4.78 │260:   ldr     w0, [x0, #8]
  3.28 │264: ↑ tbnz    w0, #14, e4    // jump to 'rx_cleanup' state
       │     dev->net->stats.rx_errors++;
  0.09 │268:   ldr     x1, [x21, #184]
  2.72 │26c:   ldr     x0, [x1, #336]
  3.37 │270:   add     x0, x0, #0x1
  0.09 │274:   str     x0, [x1, #336]
  0.66 │278: ↑ b       e4    // branch to 'rx_cleanup' state

Signed-off-by: Leesoo Ahn <lsahn@ooseel.net>
---
 drivers/net/usb/usbnet.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 64a9a80b2309..924392a37297 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -555,7 +555,7 @@ static int rx_submit (struct usbnet *dev, struct urb *urb, gfp_t flags)
 
 /*-------------------------------------------------------------------------*/
 
-static inline void rx_process (struct usbnet *dev, struct sk_buff *skb)
+static inline int rx_process(struct usbnet *dev, struct sk_buff *skb)
 {
 	if (dev->driver_info->rx_fixup &&
 	    !dev->driver_info->rx_fixup (dev, skb)) {
@@ -576,11 +576,11 @@ static inline void rx_process (struct usbnet *dev, struct sk_buff *skb)
 		netif_dbg(dev, rx_err, dev->net, "rx length %d\n", skb->len);
 	} else {
 		usbnet_skb_return(dev, skb);
-		return;
+		return 0;
 	}
 
 done:
-	skb_queue_tail(&dev->done, skb);
+	return -1;
 }
 
 /*-------------------------------------------------------------------------*/
@@ -1528,13 +1528,14 @@ static void usbnet_bh (struct timer_list *t)
 		entry = (struct skb_data *) skb->cb;
 		switch (entry->state) {
 		case rx_done:
-			entry->state = rx_cleanup;
-			rx_process (dev, skb);
+			if (rx_process(dev, skb))
+				goto cleanup;
 			continue;
 		case tx_done:
 			kfree(entry->urb->sg);
 			fallthrough;
 		case rx_cleanup:
+cleanup:
 			usb_free_urb (entry->urb);
 			dev_kfree_skb (skb);
 			continue;
-- 
2.34.1

