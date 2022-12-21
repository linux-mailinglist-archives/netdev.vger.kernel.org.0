Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C03652DA0
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 09:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbiLUID7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 03:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234497AbiLUIDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 03:03:38 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB4B21820;
        Wed, 21 Dec 2022 00:03:36 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id n65-20020a17090a2cc700b0021bc5ef7a14so1374435pjd.0;
        Wed, 21 Dec 2022 00:03:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S6bhRp4WBLcDJ1rkcGiP9uV5hcS5HELckUtTTBKpWiU=;
        b=6lliVL6QuqH4pO49pyVHCzWsbXccNXEOwyliTXa1PBNwA/iOl9I1ZggUkyHFq/Uchq
         vJAbhCUOTorcoaN1L+hZfb+X4I+tJ+vv7c3wuvJ3DLpnRbS2n5/l3p2MsRs4iBcRvLCP
         30sZg1tNxmqkdWclKkcLuZN8Ee7lQ9R5GSQM4JUtgS1jGTizWP801PzwgvEPY4z2ebk2
         5BWwTaVogKezDGaiAGWWgjlJ+Np+i6WQSmzxAYVTyy1twF3MVj0z3OudsycFZ3hVoIPC
         JsKi3+KFENHim6DQOsiAeK43werV3k3VKR4sAxp0pw2ZzOMy3fwRXjKF2PuYLkVB4aPW
         ZFQg==
X-Gm-Message-State: AFqh2kri6HseVcaBI4vvNuLkA9I/DlYd7onzTrDr1FxqLf6XeaT8jzdx
        pUDDYUBIGsPVqoDdPFaN9GYLvz575u6f1VN2
X-Google-Smtp-Source: AMrXdXuj5drmDHM+tFwCEcvwZ5ELz7h0tr8ghqlRvLfBKTWalhuqXi6TQyxyaZfuS2+fyW7y7/dsBw==
X-Received: by 2002:a05:6a20:a690:b0:a5:418:8341 with SMTP id ba16-20020a056a20a69000b000a504188341mr1703217pzb.28.1671609815650;
        Wed, 21 Dec 2022 00:03:35 -0800 (PST)
Received: from localhost.localdomain ([14.4.134.166])
        by smtp.gmail.com with ESMTPSA id q9-20020aa78429000000b0057716769289sm9890776pfn.196.2022.12.21.00.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 00:03:35 -0800 (PST)
From:   Leesoo Ahn <lsahn@ooseel.net>
To:     lsahn@ooseel.net
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Greg KH <greg@kroah.com>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] usbnet: optimize usbnet_bh() to reduce CPU load
Date:   Wed, 21 Dec 2022 16:59:24 +0900
Message-Id: <20221221075924.1141346-1-lsahn@ooseel.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current source pushes skb into dev->done queue by calling
skb_queue_tail() and then pop it by calling skb_dequeue() to branch to
rx_cleanup state for freeing urb/skb in usbnet_bh(). It takes extra CPU
load, 2.21% (skb_queue_tail) as follows.

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

To reduce the extra CPU load use return values jumping to rx_cleanup
state directly to free them instead of calling skb_queue_tail() and
skb_dequeue() for push/pop respectively.

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
v3:
  - Replace return values with proper -ERR values in rx_process()

v2:
  - Replace goto label with return statement to reduce goto entropy
  - Add CPU load information by perf in commit message

v1 at:
  https://patchwork.kernel.org/project/netdevbpf/patch/20221217161851.829497-1-lsahn@ooseel.net/

---
 drivers/net/usb/usbnet.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 64a9a80b2309..98d594210df4 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -555,32 +555,30 @@ static int rx_submit (struct usbnet *dev, struct urb *urb, gfp_t flags)
 
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
@@ -1528,13 +1526,14 @@ static void usbnet_bh (struct timer_list *t)
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

