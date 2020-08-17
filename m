Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC9E2460F4
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgHQIrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728404AbgHQIrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:47:05 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FCFC061388;
        Mon, 17 Aug 2020 01:47:05 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y6so7169994plt.3;
        Mon, 17 Aug 2020 01:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XzAA7QZ/JwcFzI2XScQHE0IAe+dKTNTeiH53oeNSRfg=;
        b=PUJ1wLCxWrpKBcdLb6Jc/e4ZqPX7SEPaggXzj9jp+/F16n/S3bnRJUytGqH6lbhkKi
         4n9SEUEEjYiVNi4rZWGRjio8H1gVKsR83S8duAYNUVAut1ukyhrIsHBDgHSaJFbVCp1j
         WCdd02yB7zx04gQlhsOLEAqHcKBT+pwxiWe0kDc1qsD1HdV1FpZBO7lepcK4nJGT/I0v
         wxFeMGPvQBOwvrbMrK6X79sAhoylApFewxMl0JOaULSPpb9eAxl9HH4DB7Bf6xc1xWoq
         bWsSpZldh3wyc/jg/gOEAh0vJhbvhXOOAypSuK+0ZJw60D3WkfY4/COfr6tNwnMoIZ76
         7/3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XzAA7QZ/JwcFzI2XScQHE0IAe+dKTNTeiH53oeNSRfg=;
        b=JRJiVjqnAkaiLcLlJ4kE2utP1Pd1zUwG03Y6jn7k20u1bdEPDzvj0SCeAm0k2pPnf1
         XJOTzpn4VDDVJPNCf5wkr0eElvNOoNuwsCAMOTLg264F7ykBq6Qqny5lmQPwN3MDOBGJ
         MBWAunfNwtwnD7jH9ZbzUDDs/EBIABejfwGiiB/nOE5mYm+S3OJLZNxTG3MaEjgn6UFW
         U+myXjbFtTv5EYnZnmPdJYQul3uoWaWXRfNmkGFUYY5fw+/z7j5DvfhYTsTSzdVWw+WF
         OwNM7XrLoPqHdP8sR2lRWoU/7ciCaeHLZqo88uYcxChcXHBJNpC8an4aOUU8nJ2t3G0q
         3P8g==
X-Gm-Message-State: AOAM533m6YahuR7Bqdu4Fdu570UIS9LCe82O7+elx3snCJcaPNdX71A+
        o+QY7kVqWwMIx/vgFxfqG+8=
X-Google-Smtp-Source: ABdhPJzdKnoWl9RVy3K1G6BUrlM3wOchRsvYl2AOsspQKQL0EzzBUBSgvSm96fUrUjfFaqAYkWe+cw==
X-Received: by 2002:a17:90a:3948:: with SMTP id n8mr8712576pjf.156.1597654024645;
        Mon, 17 Aug 2020 01:47:04 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id ml18sm16418443pjb.43.2020.08.17.01.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:47:04 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     m.grzeschik@pengutronix.de, davem@davemloft.net, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com, petkan@nucleusys.com
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 5/9] net: lan78xx: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:16:10 +0530
Message-Id: <20200817084614.24263-9-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817084614.24263-1-allen.cryptic@gmail.com>
References: <20200817084614.24263-1-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/usb/lan78xx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 442507f25aad..557999a94ef9 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3386,9 +3386,9 @@ static void lan78xx_rx_bh(struct lan78xx_net *dev)
 		netif_wake_queue(dev->net);
 }
 
-static void lan78xx_bh(unsigned long param)
+static void lan78xx_bh(struct tasklet_struct *t)
 {
-	struct lan78xx_net *dev = (struct lan78xx_net *)param;
+	struct lan78xx_net *dev = from_tasklet(dev, t, bh);
 	struct sk_buff *skb;
 	struct skb_data *entry;
 
@@ -3666,7 +3666,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 	skb_queue_head_init(&dev->txq_pend);
 	mutex_init(&dev->phy_mutex);
 
-	tasklet_init(&dev->bh, lan78xx_bh, (unsigned long)dev);
+	tasklet_setup(&dev->bh, lan78xx_bh);
 	INIT_DELAYED_WORK(&dev->wq, lan78xx_delayedwork);
 	init_usb_anchor(&dev->deferred);
 
-- 
2.17.1

