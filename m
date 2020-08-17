Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD47246110
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbgHQIsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbgHQIrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:47:00 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5733DC061388;
        Mon, 17 Aug 2020 01:47:00 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id q19so7173010pll.0;
        Mon, 17 Aug 2020 01:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4TxG6+J4B/o5uSMqtKNoCn/oi2hrZhvhcZ6aqvQF8Ek=;
        b=OdXiaKjLj6swXp8EzhhhqBW2gdWFZDSDNffoJWy1fhZn7qDQy6s+zOtPuhe3g1G8jU
         YGNNUjquAo8NKVx4by3/4Bdv+kjhfXSd2ma46VSnnBlKuCxAd7cOwghp8ffBPq9hErI+
         gPkuxXhgsIGOFJTAir23hvv2wcwkqQOlnY8N8Qk+/ip35DW5ERH/wBobzvUjJil2GBC7
         PuqUsdt81xF9JuZjp7mkZ9y/a91CK2ZBlyxFjPas6xj79vSa/RZk+fPvq+kaC5KL6vM4
         5Zy21BidyF6CxrvxlkTFLWVn0b+gOsrodeFk5FvoKNRrngoWclla85dvNKA2NsexXilU
         /MdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4TxG6+J4B/o5uSMqtKNoCn/oi2hrZhvhcZ6aqvQF8Ek=;
        b=t0A6blW4JchfbemmPfpwU8tntT8uiaQoMo3b+8Eg43cU9ooQd3z1yUBedEdGxRNROT
         IpS/q+9PwsoiVY7eL4chMsh36PqkU3pNJgoxpbt630t+xbkDbhn52Cn5V50KQ1I100Dl
         RTXGjZk1jkuj3ZLx1NEv8S6Fp/ZDv9mBTChPrugnZHY42Go8b6XzBgvYIqb+55lt4Q5G
         G07r/Ok7UD4SM8bXAQrrXNDzgnJvq7QgPbcuT1YTL1cQC3YyllcaMSpxs5CzL6sJwPXm
         GYa5jSv7SO41u1U2ld+zQUsOqg7CbcVeJb4D6u82d9SuHlFWOK6VA6rpcwWjvQFyrM4c
         1YCg==
X-Gm-Message-State: AOAM530BlofIitS8HjPugQorCSVdRO1Z8BgMBnECM34bC2O5jJM/Mxau
        +hxvVmWIkO3IekAVwzN4WjvrQbbGRo4OEA==
X-Google-Smtp-Source: ABdhPJzEs6e7wO/WADFWSaj9sezCrs7Z0iJjmWIs3AcMsJ/DSkokg382ikDsGXCnOjQv0XnvCsG6Sg==
X-Received: by 2002:a17:902:9b86:: with SMTP id y6mr10707980plp.127.1597654019873;
        Mon, 17 Aug 2020 01:46:59 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id ml18sm16418443pjb.43.2020.08.17.01.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:46:59 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     m.grzeschik@pengutronix.de, davem@davemloft.net, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com, petkan@nucleusys.com
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 4/9] net: hso: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:16:09 +0530
Message-Id: <20200817084614.24263-8-allen.cryptic@gmail.com>
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
 drivers/net/usb/hso.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 2bb28db89432..56b3b6395831 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1213,9 +1213,10 @@ static void hso_std_serial_read_bulk_callback(struct urb *urb)
  * This needs to be a tasklet otherwise we will
  * end up recursively calling this function.
  */
-static void hso_unthrottle_tasklet(unsigned long data)
+static void hso_unthrottle_tasklet(struct tasklet_struct *t)
 {
-	struct hso_serial *serial = (struct hso_serial *)data;
+	struct hso_serial *serial = from_tasklet(serial, t,
+						 unthrottle_tasklet);
 	unsigned long flags;
 
 	spin_lock_irqsave(&serial->serial_lock, flags);
@@ -1264,9 +1265,8 @@ static int hso_serial_open(struct tty_struct *tty, struct file *filp)
 		serial->rx_state = RX_IDLE;
 		/* Force default termio settings */
 		_hso_serial_set_termios(tty, NULL);
-		tasklet_init(&serial->unthrottle_tasklet,
-			     hso_unthrottle_tasklet,
-			     (unsigned long)serial);
+		tasklet_setup(&serial->unthrottle_tasklet,
+			     hso_unthrottle_tasklet);
 		result = hso_start_serial_device(serial->parent, GFP_KERNEL);
 		if (result) {
 			hso_stop_serial_device(serial->parent);
-- 
2.17.1

