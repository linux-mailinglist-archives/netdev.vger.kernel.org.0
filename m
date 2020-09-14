Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B619B2685FE
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgINHcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgINHbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:31:55 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA907C06178A;
        Mon, 14 Sep 2020 00:31:54 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t7so5020567pjd.3;
        Mon, 14 Sep 2020 00:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QQFvp8Edv/y/HZpPKpnNtxdlqhbDSOrOHXrl3FWP7BI=;
        b=HwuzsdhRwvEpO4aDSoTuFpD76h76C1V9vAr6lL5tPqRpCDkb6sHIP8m267Ea3r9F9a
         GyEUMML3FRK1a1wEB+fJXZSA+4xr1miON6pW6p4K95sZ+Y3pH1b0ggG6Lt80EKmY8mIh
         qZHIC+htH/GWHNca0btVJhrBaErFJ+u9upqT+CO+2JiHET+TPyPNDgxwueEHhUjXf+Cw
         kLhAZ9bYYS223U9rqaBFUBr8hJD+UrxYOYyYsu+XxX/RUT/Yk0oCg/MUUWPU3CdC1u0Z
         hRN8qZAGnGfcxQe+fFVF7ZkNtEyOlk7Lutphv2iy/lsUVLblZhsnOVHg7OZgCRYce3cI
         5FEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QQFvp8Edv/y/HZpPKpnNtxdlqhbDSOrOHXrl3FWP7BI=;
        b=c5mrkRRQyP6dd8vvFgtGajRHLv3djx8Fi0+gvWN+2zTW7joeQqgVWBZK+JHjJttdiR
         tiL3WXcTKjhB4Nm21Ex0tcYQnfNdotUGpyaidvOgWolWMmyU3V2Iip55OHB+2u7z6nlQ
         IPCykwYOfvQYTQM8xMkyIWFhq3Tzy2xwZjwpRvCgk6WbYiU8ZVra69/Ck6fgHqXh9FOk
         1kCt5GrV2irW5YpAO1nwGAhKttBU4tn49qgEbtdnrgm+A4av7KwpAGFrGD3zZW7GZlbP
         f8RSyUh0x2+1iQWe6RojNJ40fq7xfuXRiBXuKtUGeQYcmQAKSsVvWjj8PbpIJQu7Gh3v
         4btA==
X-Gm-Message-State: AOAM530gzvODVaO86NrUofVN8b4n+KLpFrmstII9N9Zxmepvq+F0LqN3
        SoqiNrnK8pNd3RwPbUcLlic=
X-Google-Smtp-Source: ABdhPJzfk51W7Kyf3r/72U8HClhG5IpEb76/if4PggSMiK7es/xFg5EU6ZvVJP4YLfRWKYt2MXt+RA==
X-Received: by 2002:a17:90b:104f:: with SMTP id gq15mr12444742pjb.215.1600068714436;
        Mon, 14 Sep 2020 00:31:54 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id o1sm9128626pfg.83.2020.09.14.00.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:31:53 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND net-next v2 03/12] net: caif: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 13:01:22 +0530
Message-Id: <20200914073131.803374-4-allen.lkml@gmail.com>
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
2.25.1

