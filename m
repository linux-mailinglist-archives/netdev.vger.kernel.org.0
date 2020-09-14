Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB71F26861D
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgINHd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbgINHbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:31:51 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73AC2C061788;
        Mon, 14 Sep 2020 00:31:50 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id b124so11835803pfg.13;
        Mon, 14 Sep 2020 00:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5qy3qYBgQmVFP6Fnj6Ev/w5c8PK7dcFkRXw7SXFpot8=;
        b=jsGB4evR9SXWXf1aaoA3dDmLPhgHJuigBwqPHjew2meI6+BdmXqQqU0Oe1pJkMQ+1D
         rbcc/uVNs0H5XOj4gVtyh9gv/7VHVmABTxQAnJFn03Qtl6kV0QzWbrDFHak+K+/fFjrH
         imPA9hFGBjLYkqcH//hvnR/USFMvEcttBHHNPP/bEOj9Y3Xw7hoYuZX1SXeIH8yTk56q
         bnjlCMWF3XDeGKxlO8wVjpPNJhe+h7Y95/oRGN6B7OudA0KpTVGkEL3hnSx31YxZsRMv
         T7oObB3MG2CY0wAazwSlsqrjh3YjgIV4nkhayYNXQvNKulHCaOiDxnesJysdrDaWXsKO
         XVew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5qy3qYBgQmVFP6Fnj6Ev/w5c8PK7dcFkRXw7SXFpot8=;
        b=e5RF+tN4ZhR3kPuwi3Ai9i9GQlNHiCzjbiQfC2My1s2s/BUTfOkb8WMXPcPE3ytGaj
         6xYqTTCrHHxJ6dKnF5mFOLo/UCI4TbPYBXyc1lq57EGO05FrxMy4O/jXyl2EdZtaX9NY
         tHDekZvS8KDRC/ZLRg/K8Vk7xsgNXhFcjoMbMQUyAQThpPp4Uw5z/KMvbEmfGfBlq0Yr
         Cg4Z2KxBzO+e4QSYnpT/fsH+LcLCDiePC7iM//6LdqXj+NTG1bXhYJKtXvns6vlYGNKt
         zR9+X1v7nxUM+E4gUvmuCtZnXAlvDhF1f4OtbHXkRN+LZKt17DVlIwpqMZi1KsTUdY1c
         WqQw==
X-Gm-Message-State: AOAM5329CCVGMjFLMRzb9RoTa/rRt5leRzWJPB+PYptYQDfoUOU0T3Gz
        +Ogn90Ode7CNvz6ipxYxPCI=
X-Google-Smtp-Source: ABdhPJzXGO1egFidctuNwYUiqKWrwPKAhY7P1+XJ3OYrJYb/VII4ZQBvsxmpihyPMwzmSApbLyqo4g==
X-Received: by 2002:a63:f606:: with SMTP id m6mr10016873pgh.193.1600068710095;
        Mon, 14 Sep 2020 00:31:50 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id o1sm9128626pfg.83.2020.09.14.00.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:31:49 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND net-next v2 02/12] net: arcnet: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 13:01:21 +0530
Message-Id: <20200914073131.803374-3-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914073131.803374-1-allen.lkml@gmail.com>
References: <20200914073131.803374-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
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
2.25.1

