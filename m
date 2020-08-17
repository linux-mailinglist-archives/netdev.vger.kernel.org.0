Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9494F24611A
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgHQIqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgHQIqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:46:31 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F4BC061388;
        Mon, 17 Aug 2020 01:46:31 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u128so7893136pfb.6;
        Mon, 17 Aug 2020 01:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oOS0K7GpZh3afeLowZj9j+pfivOZXdIMkfXAqq7ezS4=;
        b=PrJCulEMFWaOo7xub/+9dBNahALBAPr/4S4y20wEeAsKG0UrGrab/hidB4hZNIRnVC
         GclZLvhXdFGymrldekzcy0L27DUH/kCotdFe/Rplksaq37A5RNRtWX3rZZhOZw+6xfGT
         SWSB4LR/zq80Som+PPs8VSZGPRI2vWbZVHVymWZtjUjCkNpwmLW3rTNjLdaMOtRj7G2y
         ia4xLZl6gdFuM5halTAeEh5tt3hvxRIzUZYL8elWrQrNhRcNLu/KSKC1KbmzY5gUTFOH
         xEhbGVHDNNG2xv+gPy4CsCgcpM2K3hj7EOJ8B3PCk011ridU/09Th7D6YQJJs7XTmgx2
         qYUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oOS0K7GpZh3afeLowZj9j+pfivOZXdIMkfXAqq7ezS4=;
        b=DIAMW7M3ZHHntMNL3j32nVW5IBO09IikLdpKqsNdI3HfIEJVyjrlYKppnAd1u0AV+j
         /Z3pSw6BJwgIdj0kzI0RkNaDvIaRWuuQ0o4ht8swFgnV5b/kFB64JuItZCoaT924wStO
         GF/TU+9gfdyKxsIf5q0PEPqGMr2fdRCTY29coiu8TLnG8ctvQVKDHa8tOd9DqCqSMqDK
         0xplDcO9lejSCiph6T9l4WFW11m/GGQpwabcmOSb1e2/GXkP0tPd0wMFTuLv9tIdkshz
         jNdDTVjM89IG5qnrsDwgBVOADjE0Wi7FslAmJ7DXGycb1nqxoECcxxbt2RLT9YAOV85D
         eboA==
X-Gm-Message-State: AOAM532OjGift0Hs43Sg5wBtwSHFWu8scRK3CxrZVuIzNfrFN4wmKxeZ
        DsHLwJiTkDy4324UFl7E4gM=
X-Google-Smtp-Source: ABdhPJxmlbSQXHs5X6UryDjN8bLcMP74h5+MW6N14AQyhNfmQHYv67bLXb2OZQROMb3BiWc3yE5UPw==
X-Received: by 2002:a63:4c01:: with SMTP id z1mr9221997pga.280.1597653990907;
        Mon, 17 Aug 2020 01:46:30 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id ml18sm16418443pjb.43.2020.08.17.01.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:46:30 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     m.grzeschik@pengutronix.de, davem@davemloft.net, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com, petkan@nucleusys.com
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 1/2] net: arcnet: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:16:03 +0530
Message-Id: <20200817084614.24263-2-allen.cryptic@gmail.com>
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
 drivers/net/arcnet/arcnet.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
index e04efc0a5c97..69d8920e394b 100644
--- a/drivers/net/arcnet/arcnet.c
+++ b/drivers/net/arcnet/arcnet.c
@@ -393,9 +393,9 @@ static void arcnet_timer(struct timer_list *t)
 	}
 }
 
-static void arcnet_reply_tasklet(unsigned long data)
+static void arcnet_reply_tasklet(struct tasklet_struct *t)
 {
-	struct arcnet_local *lp = (struct arcnet_local *)data;
+	struct arcnet_local *lp = from_tasklet(lp, t, reply_tasklet);
 
 	struct sk_buff *ackskb, *skb;
 	struct sock_exterr_skb *serr;
@@ -483,8 +483,7 @@ int arcnet_open(struct net_device *dev)
 		arc_cont(D_PROTO, "\n");
 	}
 
-	tasklet_init(&lp->reply_tasklet, arcnet_reply_tasklet,
-		     (unsigned long)lp);
+	tasklet_setup(&lp->reply_tasklet, arcnet_reply_tasklet);
 
 	arc_printk(D_INIT, dev, "arcnet_open: resetting card.\n");
 
-- 
2.17.1

