Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2CC22845D5
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgJFGM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgJFGM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:12:26 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D16C0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:12:26 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id o8so699368pll.4
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PBZ7XCCPYxTfU/knzfg4kBS9oODa0+K0405tO+rt+gA=;
        b=sqcsSbFduH5gRSicAKhviLuWtHTBV8dRYx/Xx3Qz+WVH5s/7JFgZC8lvEfqAQTVazY
         Pc7KWjUmJA3wAVtYO/Mrbt5r3gL/NQJ5dwPs/3bYo3/OyHwC6t3gC9KZ6RjbV+5IMQP8
         fa3dRRoKrjYgQTM9DA1LYoglCrj2n+TMS3NQASxxAJLPioXBk1vMQTzVl2cdsS+utyh1
         7Lmn6OnZhM5WGQZlmgKDTFswEpPii8KbpD574SjzitFeT6IyuI51J9dsq8Qa3xsGj/bW
         J1PcZrZ2fs8ZsD0dx7yHo7o71RYwTob4rhFhXuv5AGWPEH/io1qve54KCNIB95XKQ3Tw
         VKeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PBZ7XCCPYxTfU/knzfg4kBS9oODa0+K0405tO+rt+gA=;
        b=RCTMqKCTKp/o+AcrSny/z7qASRKdpJB81iat1kGcP4AuuNVP97ZYNQmAdbJIWnMvxG
         j3IZVJFcC+LsDPWKUqTzQIYTekDhyVEnSAZuT58XjlkqI+mp8KCB7f+YbbZQqT9UxNRA
         wikfstr7VbGTsxc+Cl6e+1dFS0Yj2frxOCBKj6ptJlAkuZN4NNoJ1yF5DQXquo+0dGNR
         euFOdk1NJZHhhNqfQ2fDcsZ45r0LpUV3f3yB3c+6DAFeTbTfktzHEks4njXAcyfkDXNn
         FCKZlYI9APeccmLxOoGJtiOsD7jGiOQyHwGhlhsbxwO0whr1HkaGojGBrr3PkDktuEUP
         +jXA==
X-Gm-Message-State: AOAM5331Hvf4Zxu4hbWpueNDqT98N818HrxrhvlSFruFqpiWqavR7QWv
        PRyOw0/gctUkAI2jlhMsxtU=
X-Google-Smtp-Source: ABdhPJwiB7PlFebTEgmw1V+FSkUiqIvzPMGa4l5JMvP3gt4ySyEutBzK8QAcJ82hbSsPuHvpsZumHg==
X-Received: by 2002:a17:902:6545:b029:d3:d370:2882 with SMTP id d5-20020a1709026545b02900d3d3702882mr1931962pln.44.1601964745936;
        Mon, 05 Oct 2020 23:12:25 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id c12sm2046410pfj.164.2020.10.05.23.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:12:25 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [next-next v3 03/10] net: ifb: convert tasklets to use new tasklet_setup() API
Date:   Tue,  6 Oct 2020 11:41:52 +0530
Message-Id: <20201006061159.292340-4-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201006061159.292340-1-allen.lkml@gmail.com>
References: <20201006061159.292340-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 drivers/net/ifb.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 7fe306e76..a2d602736 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -59,9 +59,9 @@ static netdev_tx_t ifb_xmit(struct sk_buff *skb, struct net_device *dev);
 static int ifb_open(struct net_device *dev);
 static int ifb_close(struct net_device *dev);
 
-static void ifb_ri_tasklet(unsigned long _txp)
+static void ifb_ri_tasklet(struct tasklet_struct *t)
 {
-	struct ifb_q_private *txp = (struct ifb_q_private *)_txp;
+	struct ifb_q_private *txp = from_tasklet(txp, t, ifb_tasklet);
 	struct netdev_queue *txq;
 	struct sk_buff *skb;
 
@@ -170,8 +170,7 @@ static int ifb_dev_init(struct net_device *dev)
 		__skb_queue_head_init(&txp->tq);
 		u64_stats_init(&txp->rsync);
 		u64_stats_init(&txp->tsync);
-		tasklet_init(&txp->ifb_tasklet, ifb_ri_tasklet,
-			     (unsigned long)txp);
+		tasklet_setup(&txp->ifb_tasklet, ifb_ri_tasklet);
 		netif_tx_start_queue(netdev_get_tx_queue(dev, i));
 	}
 	return 0;
-- 
2.25.1

