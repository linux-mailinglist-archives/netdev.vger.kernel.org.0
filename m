Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8FB246114
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgHQIqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728239AbgHQIqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:46:46 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96ED1C061388;
        Mon, 17 Aug 2020 01:46:46 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id r11so7873312pfl.11;
        Mon, 17 Aug 2020 01:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nH6C6M25+CzKqxxJmBz37cFUdmu+SJpjvhFKePru7gE=;
        b=OQV3wEUWhtMgiS/DMS1Gy3zAYDUvH3Hpm6bEgFlbXoP1jEqgeGCEEeewKOTaUPg62u
         iK8lLhkQQhh5rE8LqAlkv+ufGPL3V45wQfxi527NBy3QLQH81eD4aILrnTtZsH4tRBMV
         gbaog46WOaLnV5cq5lUXtXHzKgkAAPmVx/YB4L2/aogCJdpmvo+dBdwcXMkiz7ZhyeeH
         kLAR39ByGDxmYcWWL0qWKd1Er1eBh4sBbfsKjHqpZCA8oCxI5ZlF1DAPcRT3bsdj2C5z
         yCR1ElXbaVEIb6W3bdF+d808GOJTHRpOERQ8jgAO/68DEuhExdgmQCQk+YkKWJLRDk8W
         vRuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nH6C6M25+CzKqxxJmBz37cFUdmu+SJpjvhFKePru7gE=;
        b=nXRKwxwK9HZ9CmJaZ7J8UtoIBuEntZHdvIF77mkyaVbyLInGdI79fjifi8lzOgZgmA
         IGPtRlGKhMWZvoQt2zzWfAuuaL57greb0CiqqzDnz6/xIIVM7rivmWemszTNqPm9grdg
         cvB0sy4P3MwmCYd8yE0dlYjgv99Ebfs1hUPD68L5TQhrqlJ0JOb8pyj5Hd1HnvP2mFyX
         RniErMs9QwndZ2w0sFJE+t1LgBkXj8Wg6X0f3oQKfRBXTRph1HCzNr6hrkiQht7R0ws5
         HrrbLgXVVvo4zlxM43n8NBXheXU6FgyBsWNFvvnfbd5r0lM11OlSKn6BZvgcThg7Ns59
         65AQ==
X-Gm-Message-State: AOAM532hhEE8/co8V+bXEntRCnGbbPWeaCX0chzwXNUT22qK9xb8s3Y4
        AUOq9YhbgXk+sXgAYnSb9sM=
X-Google-Smtp-Source: ABdhPJxnMU+Sz3Hxc2sacSZWKZ9Fo0PiAn5zYAAZRee+NBlJvdEuE0loVsvM1vjUdGFpohrXvp2ytQ==
X-Received: by 2002:a65:6087:: with SMTP id t7mr9665677pgu.453.1597654006001;
        Mon, 17 Aug 2020 01:46:46 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id ml18sm16418443pjb.43.2020.08.17.01.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:46:45 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     m.grzeschik@pengutronix.de, davem@davemloft.net, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com, petkan@nucleusys.com
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 2/2] net: caif: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:16:06 +0530
Message-Id: <20200817084614.24263-5-allen.cryptic@gmail.com>
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
 drivers/net/caif/caif_virtio.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index 80ea2e913c2b..23c2eb8ceeec 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -598,9 +598,9 @@ static netdev_tx_t cfv_netdev_tx(struct sk_buff *skb, struct net_device *netdev)
 	return NETDEV_TX_OK;
 }
 
-static void cfv_tx_release_tasklet(unsigned long drv)
+static void cfv_tx_release_tasklet(struct tasklet_struct *t)
 {
-	struct cfv_info *cfv = (struct cfv_info *)drv;
+	struct cfv_info *cfv = from_tasklet(cfv, t, tx_release_tasklet);
 	cfv_release_used_buf(cfv->vq_tx);
 }
 
@@ -716,9 +716,7 @@ static int cfv_probe(struct virtio_device *vdev)
 	cfv->ctx.head = USHRT_MAX;
 	netif_napi_add(netdev, &cfv->napi, cfv_rx_poll, CFV_DEFAULT_QUOTA);
 
-	tasklet_init(&cfv->tx_release_tasklet,
-		     cfv_tx_release_tasklet,
-		     (unsigned long)cfv);
+	tasklet_setup(&cfv->tx_release_tasklet, cfv_tx_release_tasklet);
 
 	/* Carrier is off until netdevice is opened */
 	netif_carrier_off(netdev);
-- 
2.17.1

