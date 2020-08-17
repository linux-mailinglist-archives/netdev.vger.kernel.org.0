Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9662460FF
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgHQIri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728016AbgHQIrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:47:25 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68210C061388;
        Mon, 17 Aug 2020 01:47:25 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k18so7883461pfp.7;
        Mon, 17 Aug 2020 01:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=I9FCZOgIDuZqeurOHDh0nbpiKmkOvQNtsIsTlWYfc1Y=;
        b=HFtOQ5AlNWLobweJbdYclZKpNoCZYZSSQ7FjqaOzxn3bUNoTtUgUfNeCT1A+UbLXVY
         FdbbVnKnsy4hXPSbY7m6m3Kc3GKYQl4Z1tcriXuMcZsULljml7W3WoY09rp+AwjybdST
         Kr4G7JrhHKO5p9ek0hpCjB+kbOPzmhUHuoHueGU8tP+Y4xZ+j/+Ea7Y7QRhBfpX2IT10
         FISBVOF4394pHGIexQJUSskOjPhebxVO1hh1EuCIoIulAHsTKN2Z/o/U423Xu3a/c94g
         HIK/XiVoaTPKB1ItLx53sa3m+W9acLIHG0HijwffrWelWvi0TwouPy03yuV1LSMCgQB0
         YUxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=I9FCZOgIDuZqeurOHDh0nbpiKmkOvQNtsIsTlWYfc1Y=;
        b=YMWcXzdPWpr631LG0jrgLUjt8GkUYTjMp88IOjDcrJjyFD4+tPDZNypMbTAHy3pv9v
         6rfWT8sCFxORfoahxMSe7NTkzSEKvhQZgxTz5x4/IJ8DMjFn+NLb95NC2qpWPb1jiyi2
         6kzD/ZvvpWKaANQWvEVsgUyAnkTr3guc+q+XmlpLhl6eMv+9nHr5z2YpVka+5MuYkcTH
         7DMeT+JbW7CiwjMcKUBblzQYo5GVFJz3oglLhVlFpvK7nD+tg2L9tIZC37u1e0jHyrBL
         YmFQ5ZpOHo3xB+rjY8+bJiKCKWqsjR4WfwvaopcPvzFGnrX9eqkN9hgZv3KUtu5ENya4
         NpqQ==
X-Gm-Message-State: AOAM533LcKEMrj2nwu3Atgzz2QdjBi8qLHXh6ch+6j/Mldn7Ws4KDxW7
        EjArTVfg2VVJCE88HrTr+GU=
X-Google-Smtp-Source: ABdhPJwTnBvHFCwyjA7hh+z6WJdIOftS4ISK9d7eBdKss0Xek7P60Pw9LQNtFXEqQ85qo+gOEiLD1Q==
X-Received: by 2002:aa7:9564:: with SMTP id x4mr10453280pfq.29.1597654044966;
        Mon, 17 Aug 2020 01:47:24 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id ml18sm16418443pjb.43.2020.08.17.01.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:47:24 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     m.grzeschik@pengutronix.de, davem@davemloft.net, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com, petkan@nucleusys.com
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 9/9] net: usbnet: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:16:14 +0530
Message-Id: <20200817084614.24263-13-allen.cryptic@gmail.com>
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
and from_tasklet() to pass the tasklet pointer explicitly
and remove the .data field.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/usb/usbnet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index e45935a5856a..45bf0814939d 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1708,8 +1708,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	skb_queue_head_init (&dev->txq);
 	skb_queue_head_init (&dev->done);
 	skb_queue_head_init(&dev->rxq_pause);
-	dev->bh.func = usbnet_bh_tasklet;
-	dev->bh.data = (unsigned long)&dev->delay;
+	dev->bh.func = (void(*) (unsigned long))usbnet_bh_tasklet;
 	INIT_WORK (&dev->kevent, usbnet_deferred_kevent);
 	init_usb_anchor(&dev->deferred);
 	timer_setup(&dev->delay, usbnet_bh, 0);
-- 
2.17.1

