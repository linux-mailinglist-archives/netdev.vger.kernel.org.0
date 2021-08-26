Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E423C3F7FCF
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 03:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbhHZBZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 21:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235803AbhHZBZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 21:25:55 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E39C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 18:25:08 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id m17so724737plc.6
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 18:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kgiIB0ARnDUkIeMA09I7zb92UyvjTQhcCE2HklM1ZQc=;
        b=mJc5OnsBN/1hWPPTYOgqpcUfnv1uDTw9m6PT+gA74omQc3MH4JVcwPE8Jcs6YChPf3
         QMyT2Fkr92eYMFIsQW5pNJXSXra3d+Dg5aQ6fsAOeVTe5QkVzIfplOGExX/W4A3jy0nd
         ezKLSi2zBaF3gu3A8k6v44X07PQivWt0JuRMFYWcQu/+PiAE0XuwidOMRTZL2ehq0L71
         aR4wtTzXVHZnl/GI9oRxdGoMiv452TzfyQpEjBBMGccVzUpTSiJQxBMNPJy9sapD8Rsb
         xcqtjccf3Qd80uRgtQylOCznBFjYYTDzvZxFI/T1Xk+ZbWv+wqXezI0e0JheOC9ZKiCF
         1ZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kgiIB0ARnDUkIeMA09I7zb92UyvjTQhcCE2HklM1ZQc=;
        b=iQLuH2PDcjNWtno5Q7bI34Jza76uy2vVm33uDXUGNbYOjOGfJR3YZnisTJWD4SiD3i
         itw3vqFfn0aVEln6U4nhIFPb+rrYcf+d5StA0eGX7XeTm/p8YqfWrYfV78FoZUP+VsDJ
         DFhUUr/zKhboNTLUJKs+w7xKg7jxMlECh05E4Q7/rZEkrDVSK0r0eFzdylaI3QGPsLAJ
         cvfck8iAplksRdcUwVZ67+7BmoG1sTOwKlftbN6yoX1TkMv3FLeweiFRwll7m9H+G8RB
         ynaELHVHdQWD80j4ag+ICaDhhD0/l0LfkCKUMVsesIqYfuaTa/UmbjHKFygUEJoS27AG
         k3+A==
X-Gm-Message-State: AOAM533ecg7wSDCY+Mt/ZEsNWbUifEn3ZxbOUpdGHvUkWMr60VmzEd1L
        fXhQ4PN2aMiPgo10gdzjMZL7KQ==
X-Google-Smtp-Source: ABdhPJwzRUOsi2K6TQBbHsSwf1oYFAotwFXpzPHwq8kByQ6IxrAf7Jpk/adMV4Y34wcwKjqNsP/OGQ==
X-Received: by 2002:a17:902:650b:b0:137:3940:ec24 with SMTP id b11-20020a170902650b00b001373940ec24mr1097690plk.36.1629941108376;
        Wed, 25 Aug 2021 18:25:08 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h13sm1113458pgh.93.2021.08.25.18.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 18:25:07 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/5] ionic: flatten calls to set-rx-mode
Date:   Wed, 25 Aug 2021 18:24:47 -0700
Message-Id: <20210826012451.54456-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210826012451.54456-1-snelson@pensando.io>
References: <20210826012451.54456-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since only two functions call through ionic_set_rx_mode(), one
that can sleep and one that can't, we can split the function
and put the bits of code into the callers.  This removes an
unnecessary calling layer.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 27 +++++++------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 1940052acc77..60bc1251d995 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1444,28 +1444,19 @@ static void ionic_lif_rx_mode(struct ionic_lif *lif)
 	mutex_unlock(&lif->config_lock);
 }
 
-static void ionic_set_rx_mode(struct net_device *netdev, bool can_sleep)
+static void ionic_ndo_set_rx_mode(struct net_device *netdev)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic_deferred_work *work;
 
-	if (!can_sleep) {
-		work = kzalloc(sizeof(*work), GFP_ATOMIC);
-		if (!work) {
-			netdev_err(lif->netdev, "rxmode change dropped\n");
-			return;
-		}
-		work->type = IONIC_DW_TYPE_RX_MODE;
-		netdev_dbg(lif->netdev, "deferred: rx_mode\n");
-		ionic_lif_deferred_enqueue(&lif->deferred, work);
-	} else {
-		ionic_lif_rx_mode(lif);
+	work = kzalloc(sizeof(*work), GFP_ATOMIC);
+	if (!work) {
+		netdev_err(lif->netdev, "rxmode change dropped\n");
+		return;
 	}
-}
-
-static void ionic_ndo_set_rx_mode(struct net_device *netdev)
-{
-	ionic_set_rx_mode(netdev, CAN_NOT_SLEEP);
+	work->type = IONIC_DW_TYPE_RX_MODE;
+	netdev_dbg(lif->netdev, "deferred: rx_mode\n");
+	ionic_lif_deferred_enqueue(&lif->deferred, work);
 }
 
 static __le64 ionic_netdev_features_to_nic(netdev_features_t features)
@@ -2101,7 +2092,7 @@ static int ionic_txrx_init(struct ionic_lif *lif)
 	if (lif->netdev->features & NETIF_F_RXHASH)
 		ionic_lif_rss_init(lif);
 
-	ionic_set_rx_mode(lif->netdev, CAN_SLEEP);
+	ionic_lif_rx_mode(lif);
 
 	return 0;
 
-- 
2.17.1

