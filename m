Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EC439ED4D
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 06:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhFHEFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 00:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhFHEFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 00:05:09 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E232C061795;
        Mon,  7 Jun 2021 21:03:00 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id w33so29887881lfu.7;
        Mon, 07 Jun 2021 21:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zdX62WlQ3p8rs50GDVVp4jfIL+laVX6G6USVtA2GR9M=;
        b=g5pN/FchaU0RenbJFPXPQr4TpJMqLe+hFbEu9qXh/uAt5e+kClyVNjTVjWREYIPNTW
         baPT1dcPq35GRbilSK+H0KT2JmNhDlJAwMrvDgUOJJKWC/ekJv0poNO411+jmOInCjsX
         ZB6trJXyXofMmSqysjx7z6rtJUFukIu9f7LV7Zk8cqUw59+Yu870Dkc6D78/tBjozX6B
         LUfPRt6Ue/Wf8jjTTjTX7w8236nLrAlfwsDvyvwQLwzmG1GY2fskV5lhDZuNMApRPOnR
         L5HN2itKxwXgHjrMrbsmuh8xUbH8yS98FKjo0K/bQdWwHaCoZmFAcbxfzzNHPGqRvaVn
         3y+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zdX62WlQ3p8rs50GDVVp4jfIL+laVX6G6USVtA2GR9M=;
        b=ASErEg5s4z5q3WOCzufrR6d0vSnPfJpY0srHjc1i/R0xVhIzHJtTcJumEfQOT0ihux
         FaBDuYvQLWkaXyiAWEPa72l9qTtJXQSnS8vPzugpGChTqv2gWnhrUfCVbOi/Z7TnTsRV
         C7/luTcoVaU0Kdf6760zzgxuCR6U7K+FtHZQQ7+N6IcWr+pPvDu0nXYEbZ7/XLkhLloL
         zLZNPytD2nQcJQWZ+IkO6DfBEbIpWUphTO+sSbfTAhQkEbwbWfhIpd7D1oZaqwJSc9LU
         mPF3B5WmBENK4sXApuWVfQ5YkaNqnzB817Koax4Bag2FCUfqqTAMMQYB0xFRBcdUOJcO
         AJqA==
X-Gm-Message-State: AOAM531eH0UuIPj01N9OcZiqzmJFIkYBVIFKpSbk0jRQpiobSZ3kfMYh
        ep7IM4UoQy6l8lPOfQZceh8=
X-Google-Smtp-Source: ABdhPJw6NARPj59vStBB/DjqY4pVBcOetCaXqKqJozj4vaPv9wTVOhKCG9WnSAWBL4PXtRp00klsjg==
X-Received: by 2002:a19:7909:: with SMTP id u9mr9815144lfc.13.1623124978631;
        Mon, 07 Jun 2021 21:02:58 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id l23sm1729096lfj.26.2021.06.07.21.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 21:02:58 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 10/10] net: wwan: core: purge rx queue on port close
Date:   Tue,  8 Jun 2021 07:02:41 +0300
Message-Id: <20210608040241.10658-11-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
References: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Purge the rx queue as soon as a user closes the port, just after the
port stop callback invocation. This is to prevent feeding a user that
will open the port next time with outdated and possibly unrelated
data.

While at it also remove the odd skb_queue_purge() call in the port
device destroy callback. The queue will be purged just before the
callback is ivoncated in the wwan_remove_port() function.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/wwan_core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 38da3124d81e..45a41aee8958 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -240,7 +240,6 @@ static void wwan_port_destroy(struct device *dev)
 
 	ida_free(&minors, MINOR(port->dev.devt));
 	mutex_destroy(&port->data_lock);
-	skb_queue_purge(&port->rxq);
 	mutex_destroy(&port->ops_lock);
 	kfree(port);
 }
@@ -462,8 +461,11 @@ static void wwan_port_op_stop(struct wwan_port *port)
 {
 	mutex_lock(&port->ops_lock);
 	port->start_count--;
-	if (port->ops && !port->start_count)
-		port->ops->stop(port);
+	if (!port->start_count) {
+		if (port->ops)
+			port->ops->stop(port);
+		skb_queue_purge(&port->rxq);
+	}
 	mutex_unlock(&port->ops_lock);
 }
 
-- 
2.26.3

