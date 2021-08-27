Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC293F9F4B
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 20:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhH0S4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 14:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbhH0S4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 14:56:14 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBDAC061757
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 11:55:25 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id w19-20020a17090aaf9300b00191e6d10a19so5465861pjq.1
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 11:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Cp7i7K6OSDhMAGdsX8KhMSF7bSObvG7DbX9s/VitGZU=;
        b=bnoGDWQYSM1894pNm5b5IAjSp1cHyvywunI+x6p1RKjiNsMArldtesI3Tafwilftr8
         E9Hu/c5B86nYiYCCsCf+iXiaiEKajiDmtYC431H3Ur3vjr6NvxC4jXyKflu8TfoBSOgT
         HZYv6Q56D6ro1sVUb3kfC6V5Oh5Izw37nw9lXREMgTlnvFkb2RWoQU+1yQI9wzLGCYz9
         2+RjvK039YGRjUx5vDZnaRizN1wcs1+kovpU8EdgaL6JrqcDebBoby5o+AFB9XXsyw06
         Cu++HOXoCpF8MhC5nw7+rGIW71YNvifrhqtm1D1kJpJuWPUu4+Opxt22OXbTXpAmC3y/
         OHhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Cp7i7K6OSDhMAGdsX8KhMSF7bSObvG7DbX9s/VitGZU=;
        b=UDq1QpKtuxJgw8nHLS6lIvJUxTmjwpxgkuojxyU9+2cr2P2gRQxk9D17ymVsWn20Bg
         tJhfJa113CXpRaTxhKUzxeJPQNL0qwLpkgTdSw/6galBWhqal9dzQ1+JIuPHKLVUPVe2
         LDLUZ2C/HitOJMAJzwjf79DOXXZplhfgQ9RACQla3MpSmZnwEWB8MMTTyciqghLv7jLo
         Y5wioLk5Gk14msHKDFehhkWeCqWBThXAcFCY/q89r4qNnKFXQN7pGLM19iQB1s8spMwD
         N9cyIcRoMB5X+f0nAEdu77BjpwM8YInpl3Pdib+yIVOoluX0csQRQ5KYd0z8roSB+Ypv
         /Few==
X-Gm-Message-State: AOAM530C4pJyLHP+oRLtoOs5XXLF7jI+xIMJOQtXX1FzvLJPvqE+YObs
        v3sA7QEpYygEh2FTnQlgOCzO7A==
X-Google-Smtp-Source: ABdhPJwdSbgVChWCYAXLDoebNBNYCxlwuFRlOBjDQaFROvgIWkITiaP+24D++NAruxjGmNEpuRRGSQ==
X-Received: by 2002:a17:90a:5d16:: with SMTP id s22mr25229741pji.69.1630090525515;
        Fri, 27 Aug 2021 11:55:25 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id f10sm7565975pgm.77.2021.08.27.11.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 11:55:25 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/6] ionic: fill mac addr earlier in add_addr
Date:   Fri, 27 Aug 2021 11:55:09 -0700
Message-Id: <20210827185512.50206-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210827185512.50206-1-snelson@pensando.io>
References: <20210827185512.50206-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure the ctx struct has the new mac address before
any save operations happen.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index df0137044c03..d69c80c3eaa2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1268,6 +1268,8 @@ int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
 	struct ionic_rx_filter *f;
 	int err = 0;
 
+	memcpy(ctx.cmd.rx_filter_add.mac.addr, addr, ETH_ALEN);
+
 	spin_lock_bh(&lif->rx_filters.lock);
 	f = ionic_rx_filter_by_addr(lif, addr);
 	if (f) {
@@ -1281,7 +1283,6 @@ int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
 		f->state = IONIC_FILTER_STATE_SYNCED;
 	} else {
 		/* save as SYNCED to catch any DEL requests while processing */
-		memcpy(ctx.cmd.rx_filter_add.mac.addr, addr, ETH_ALEN);
 		err = ionic_rx_filter_save(lif, 0, IONIC_RXQ_INDEX_ANY, 0, &ctx,
 					   IONIC_FILTER_STATE_SYNCED);
 	}
-- 
2.17.1

