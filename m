Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD675183BBB
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 22:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgCLVud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 17:50:33 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34562 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgCLVub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 17:50:31 -0400
Received: by mail-pg1-f194.google.com with SMTP id t3so3738137pgn.1
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 14:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CjLHdiigT+dY4nI+BffDj7ZEu+9tEft0aQo1byukjwg=;
        b=v9iFFMDA7c4qgS1K4lC2u7cPuDWPdx4oX9uOtBoocOhmdnVpUGPR0F2xGyJ1WXU1H2
         uELnMpKzGGJ+0Ed9C1wJtHofjv0m36XBM0VDYLssWYvhOirT1xOCnLyERpxopojML6OJ
         qCeLcQ32lmPA19PWZU7A+YhikC57JCTY5iLgKM59KVL2xq1/A0Ov7kqBJYz77fGfK7f7
         05VjOR0CHIfXHykTMtGJAM2PpQy8ewz1oxZFp8MGowyqGMydKGRETctCvfWfrm7UNVTT
         GsZUYA9DpI2Hgt3FnPlKzNGI0680kb6Y3xafN79HHmwKvE8VnOP2f6ALbW0UNUowumqS
         wC/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CjLHdiigT+dY4nI+BffDj7ZEu+9tEft0aQo1byukjwg=;
        b=XqM6IXQQ+V9PFbH/ciD8bhiD+T7xiyBYGny42brf8psjjhkWMVlPvljZ7gnJl2MKvC
         hNGWNmL3xNsuXL1A7q4zyerVxCaz6tvCZDeCMqXHTn3ZU9lCr3G2hUt8cS7CbR4PjqVr
         HMYt8LnZKbVZ5bvCy/TeAIuMeLVxIQnkuxoI1gpQWv6G34TiFiGRx/xUyD+Rf95zjWaL
         oIY6l3dxL8SDtQa9/OpEg9jvM+0OZzUpWHgdUqMZAvCw/oI76UF0LarDZ9REdAbVOxyY
         /hajesHNTX8euBuOidywdWITUE4hbSB2jKNibt7Kx9qkFVDlvKgme6tCtxc8afinK7lr
         Eq/g==
X-Gm-Message-State: ANhLgQ3KL4qUH4nyPPWMjC8dKQIidz3OVnRGCwUNxahfolN6vs3Go1Lw
        WiUYTU41gTb184I1xHnzJ8BSf5H3VQU=
X-Google-Smtp-Source: ADFU+vvY8QV7rO55+RWmC0cZZdJJYz7IhQ2UPDaMZqLSdY9sVviTJQx/1Qynwlih4+Vj1guLy8GFlg==
X-Received: by 2002:a63:1a53:: with SMTP id a19mr9882453pgm.227.1584049830274;
        Thu, 12 Mar 2020 14:50:30 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p2sm38281203pfb.41.2020.03.12.14.50.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Mar 2020 14:50:29 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/7] ionic: ignore eexist on rx filter add
Date:   Thu, 12 Mar 2020 14:50:11 -0700
Message-Id: <20200312215015.69547-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200312215015.69547-1-snelson@pensando.io>
References: <20200312215015.69547-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't worry if the rx filter add firmware request fails on
EEXIST, at least we know the filter is there.  Same for
the delete request, at least we know it isn't there.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 682f4b5af704..eb1e885a2f70 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -849,7 +849,7 @@ static int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
 
 	memcpy(ctx.cmd.rx_filter_add.mac.addr, addr, ETH_ALEN);
 	err = ionic_adminq_post_wait(lif, &ctx);
-	if (err)
+	if (err && err != -EEXIST)
 		return err;
 
 	return ionic_rx_filter_save(lif, 0, IONIC_RXQ_INDEX_ANY, 0, &ctx);
@@ -879,7 +879,7 @@ static int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr)
 	spin_unlock_bh(&lif->rx_filters.lock);
 
 	err = ionic_adminq_post_wait(lif, &ctx);
-	if (err)
+	if (err && err != -EEXIST)
 		return err;
 
 	netdev_dbg(lif->netdev, "rx_filter del ADDR %pM (id %d)\n", addr,
-- 
2.17.1

