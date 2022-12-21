Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27DA8652C25
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 05:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbiLUEnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 23:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiLUEnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 23:43:02 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E049818377;
        Tue, 20 Dec 2022 20:43:00 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id d15so14403107pls.6;
        Tue, 20 Dec 2022 20:43:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GWX6ezao04Awur4XebBcbzgdL1TSR5w6fZheybAPgFI=;
        b=upz2i6Tr9zB+x+wrCGeS9Pm1KlTAuY9CeS3RvYfYJ+tAxHLYZBTt/ZbQKTsWPtUmP+
         0S8dcPg79PT/LMtNU8Tdl8ytgmowme7SHPYKynzM46QYHjheUj/ziBdqtT+QIWtyNOKI
         6jCaQ+5GSvAgZTyuVMTpXGLxQr3Sf0cGhmS/YRyTdG8IurfGO1wyEJ/2+r9JJZB9cR+n
         ynrbddADyayYucyUOBX8u/1xPvWIPr5ELJHHMfmZQUnfrDixip+JzoFerYu4h/GA/QfU
         Mk/VZ4YSaw8TU8i8sb1FWhZrYoz1+72jplZkJn83bevmjE6rKWwSR50do01dZ5h1rPJe
         GOZQ==
X-Gm-Message-State: AFqh2kpB/CWHXL+4NFbYvkVDg95i9r4pMODI/x5H4LpXVdn5xxShkKh8
        xeR5Qds3uFmHPFPDktpHp7M=
X-Google-Smtp-Source: AMrXdXuhyJ8IKOgh9gs3aeAJN84oGf5dcWiporDykv5SuLdJB/vtF3wVfmXs+vjcOgT5h0+3kiFmTA==
X-Received: by 2002:a05:6a21:6da5:b0:a4:414c:84c5 with SMTP id wl37-20020a056a216da500b000a4414c84c5mr1350832pzb.12.1671597780216;
        Tue, 20 Dec 2022 20:43:00 -0800 (PST)
Received: from localhost.localdomain ([14.4.134.166])
        by smtp.gmail.com with ESMTPSA id e13-20020a6558cd000000b004768ce9e4fasm9072136pgu.59.2022.12.20.20.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 20:42:59 -0800 (PST)
From:   Leesoo Ahn <lsahn@ooseel.net>
To:     lsahn@ooseel.net
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Greg KH <greg@kroah.com>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] usbnet: optimize usbnet_bh() to reduce CPU load
Date:   Wed, 21 Dec 2022 13:42:30 +0900
Message-Id: <20221221044230.1012787-1-lsahn@ooseel.net>
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
v2:
  - Replace goto label with return statement to reduce goto entropy
  - Add CPU load information by perf in commit message

v1 at:
  https://patchwork.kernel.org/project/netdevbpf/patch/20221217161851.829497-1-lsahn@ooseel.net/
---
 drivers/net/usb/usbnet.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 64a9a80b2309..6e82fef90dd9 100644
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
+		return 1;
 	}
 	// else network stack removes extra byte if we forced a short packet
 
 	/* all data was already cloned from skb inside the driver */
 	if (dev->driver_info->flags & FLAG_MULTI_PACKET)
-		goto done;
+		return 1;
 
 	if (skb->len < ETH_HLEN) {
 		dev->net->stats.rx_errors++;
 		dev->net->stats.rx_length_errors++;
 		netif_dbg(dev, rx_err, dev->net, "rx length %d\n", skb->len);
-	} else {
-		usbnet_skb_return(dev, skb);
-		return;
+		return 1;
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

