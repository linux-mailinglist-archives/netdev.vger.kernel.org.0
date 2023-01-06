Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A1B65FF2B
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 11:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbjAFKu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 05:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbjAFKuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 05:50:22 -0500
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868BD6DB8D;
        Fri,  6 Jan 2023 02:50:20 -0800 (PST)
Received: by mail-pj1-f52.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so1296991pjj.4;
        Fri, 06 Jan 2023 02:50:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lRAlJPnsHvwo9+KYVt93sJxqGpThqmJEXZYgKf4vous=;
        b=J5XLk1J7zJg+ZFA5q239CwxTwUVQ346vk6vQCPwoTay7Rf46O+9wgmoA6JIBoQ5aBD
         zLn/w8caWm+C8pHli3V3KW2xRQbnBrc1JMPPG4CF3kE+FZOEZ3nkjIv0S0XKecxXh+vl
         IOOBz+iGiL3tpwKMAMQ4Z2g6jaHYLJliK1mi6hvzFZLFwyfg8So9U+9Im2GO4VkEnuvW
         22/ElRSHryi8SVZutRfo9yCemVS/9kyBMB43xWQiQwzHlqZshrhkck8gufhioEfMC32p
         JkQG5XEUrw67VkxIExIQue6V7pyAN8+JrSgnOQF7ts+EBVkJv6n8iYXFV6dxP+v8v8gB
         l+Ew==
X-Gm-Message-State: AFqh2krKklZ4WbkbKYLlOveyvaLmTmm46TjjfBrOcafSDAjSbkf1rqOy
        +srkHAI4kl/SU1Qh3FeVno4=
X-Google-Smtp-Source: AMrXdXtUXYhEuTaGeA1+kPaRkyzwam/EhnGFQrOYqs3mfWmn9ZEjmO8GRSINAUVXTUyz1tzWTcpd8A==
X-Received: by 2002:a17:902:d386:b0:192:68e8:c60c with SMTP id e6-20020a170902d38600b0019268e8c60cmr47799898pld.31.1673002220070;
        Fri, 06 Jan 2023 02:50:20 -0800 (PST)
Received: from milyway.. ([125.191.247.116])
        by smtp.googlemail.com with ESMTPSA id e5-20020a17090301c500b00188fadb71ecsm732486plh.16.2023.01.06.02.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 02:50:19 -0800 (PST)
From:   Leesoo Ahn <lsahn@ooseel.net>
To:     lsahn@ooseel.net
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4] usbnet: optimize usbnet_bh() to reduce CPU load
Date:   Fri,  6 Jan 2023 19:49:49 +0900
Message-Id: <20230106104950.22741-1-lsahn@ooseel.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current source pushes skb into dev-done queue by calling
skb_dequeue_tail() and then pop it by skb_dequeue() to branch to
rx_cleanup state for freeing urb/skb in usbnet_bh(). It takes extra CPU
load, 2.21% (skb_queue_tail) as follows,

-   11.58%     0.26%  swapper          [k] usbnet_bh
   - 11.32% usbnet_bh
      - 6.43% skb_dequeue
           6.34% _raw_spin_unlock_irqrestore
      - 2.21% skb_queue_tail
           2.19% _raw_spin_unlock_irqrestore
      - 1.68% consume_skb
         - 0.97% kfree_skbmem
              0.80% kmem_cache_free
           0.53% skb_release_data

To reduce the extra CPU load use return values to call helper function
usb_free_skb() to free the resources instead of calling skb_queue_tail()
and skb_dequeue() for push and pop respectively.

-    7.87%     0.25%  swapper          [k] usbnet_bh
   - 7.62% usbnet_bh
      - 4.81% skb_dequeue
           4.74% _raw_spin_unlock_irqrestore
      - 1.75% consume_skb
         - 0.98% kfree_skbmem
              0.78% kmem_cache_free
           0.58% skb_release_data
        0.53% smsc95xx_rx_fixup

Signed-off-by: Leesoo Ahn <lsahn@ooseel.net>
---
v4:
  - Use usb_free_skb() helper function instead of goto label

v3:
  - Replace return values with proper -ERR values in rx_process()
  https://lore.kernel.org/netdev/20221221075924.1141346-1-lsahn@ooseel.net/

v2:
  - Replace goto label with return statement to reduce goto entropy
  - Add CPU load information by perf in commit message
  https://lore.kernel.org/netdev/20221221044230.1012787-1-lsahn@ooseel.net/

v1 at:
  https://lore.kernel.org/netdev/20221217161851.829497-1-lsahn@ooseel.net/

---
 drivers/net/usb/usbnet.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index e4fbb4d86606..fc12b5c4241b 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -556,32 +556,30 @@ static int rx_submit (struct usbnet *dev, struct urb *urb, gfp_t flags)
 
 /*-------------------------------------------------------------------------*/
 
-static inline void rx_process (struct usbnet *dev, struct sk_buff *skb)
+static inline int rx_process(struct usbnet *dev, struct sk_buff *skb)
 {
 	if (dev->driver_info->rx_fixup &&
 	    !dev->driver_info->rx_fixup (dev, skb)) {
 		/* With RX_ASSEMBLE, rx_fixup() must update counters */
 		if (!(dev->driver_info->flags & FLAG_RX_ASSEMBLE))
 			dev->net->stats.rx_errors++;
-		goto done;
+		return -EPROTO;
 	}
 	// else network stack removes extra byte if we forced a short packet
 
 	/* all data was already cloned from skb inside the driver */
 	if (dev->driver_info->flags & FLAG_MULTI_PACKET)
-		goto done;
+		return -EALREADY;
 
 	if (skb->len < ETH_HLEN) {
 		dev->net->stats.rx_errors++;
 		dev->net->stats.rx_length_errors++;
 		netif_dbg(dev, rx_err, dev->net, "rx length %d\n", skb->len);
-	} else {
-		usbnet_skb_return(dev, skb);
-		return;
+		return -EPROTO;
 	}
 
-done:
-	skb_queue_tail(&dev->done, skb);
+	usbnet_skb_return(dev, skb);
+	return 0;
 }
 
 /*-------------------------------------------------------------------------*/
@@ -1515,6 +1513,14 @@ static int rx_alloc_submit(struct usbnet *dev, gfp_t flags)
 	return ret;
 }
 
+static inline void usb_free_skb(struct sk_buff *skb)
+{
+	struct skb_data *entry = (struct skb_data *)skb->cb;
+
+	usb_free_urb(entry->urb);
+	dev_kfree_skb(skb);
+}
+
 /*-------------------------------------------------------------------------*/
 
 // tasklet (work deferred from completions, in_irq) or timer
@@ -1529,15 +1535,14 @@ static void usbnet_bh (struct timer_list *t)
 		entry = (struct skb_data *) skb->cb;
 		switch (entry->state) {
 		case rx_done:
-			entry->state = rx_cleanup;
-			rx_process (dev, skb);
+			if (rx_process(dev, skb))
+				usb_free_skb(skb);
 			continue;
 		case tx_done:
 			kfree(entry->urb->sg);
 			fallthrough;
 		case rx_cleanup:
-			usb_free_urb (entry->urb);
-			dev_kfree_skb (skb);
+			usb_free_skb(skb);
 			continue;
 		default:
 			netdev_dbg(dev->net, "bogus skb state %d\n", entry->state);
-- 
2.34.1

